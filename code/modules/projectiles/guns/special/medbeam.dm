/obj/item/gun/medbeam
	name = "Medical Beamgun"
	desc = "Don't cross the streams!"
	icon = 'icons/obj/chronos.dmi'
	icon_state = "chronogun"
	inhand_icon_state = "chronogun"
	w_class = WEIGHT_CLASS_NORMAL

	var/mob/living/current_target
	var/last_check = 0
	var/check_delay = 10 //Check los as often as possible, max resolution is SSobj tick though
	var/max_range = 8
	var/active = FALSE
	var/datum/beam/current_beam = null
	var/mounted = 0 //Denotes if this is a handheld or mounted version

	weapon_weight = WEAPON_MEDIUM

/obj/item/gun/medbeam/Destroy(mob/user)
	LoseTarget()
	return ..()

/obj/item/gun/medbeam/dropped(mob/user)
	..()
	LoseTarget()

/obj/item/gun/medbeam/equipped(mob/user)
	..()
	LoseTarget()

/**
 * Proc that always is called when we want to end the beam and makes sure things are cleaned up, see beam_died()
 */
/obj/item/gun/medbeam/proc/LoseTarget()
	if(active)
		QDEL_NULL(current_beam)
		active = FALSE
		on_beam_release(current_target)
	STOP_PROCESSING(SSobj, src)
	current_target = null


/**
 * Proc that is only called when the beam fails due to something, so not when manually ended.
 * manual disconnection = LoseTarget, so it can silently end
 * automatic disconnection = beam_died, so we can give a warning message first
 */
/obj/item/gun/medbeam/proc/beam_died()
	SIGNAL_HANDLER
	current_beam = null
	active = FALSE //skip qdelling the beam again if we're doing this proc, because
	if(isliving(loc))
		to_chat(loc, span_warning("You lose control of the beam!"))
	LoseTarget()

/obj/item/gun/medbeam/process_fire(atom/target, mob/living/user, message = TRUE, params = null, zone_override = "", bonus_spread = 0)
	if(isliving(user))
		add_fingerprint(user)

	if(current_target)
		LoseTarget()
	if(!isliving(target))
		return

	current_target = target
	active = TRUE
	current_beam = user.Beam(current_target, icon_state="medbeam", time = 10 MINUTES, maxdistance = max_range, beam_type = /obj/effect/ebeam/medical)
	RegisterSignal(current_beam, COMSIG_QDELETING, PROC_REF(beam_died))//this is a WAY better rangecheck than what was done before (process check)
	START_PROCESSING(SSobj, src)

	SSblackbox.record_feedback("tally", "gun_fired", 1, type)
	return TRUE

/obj/item/gun/medbeam/process()
	if(!mounted && !isliving(loc))
		LoseTarget()
		return

	if(!current_target)
		LoseTarget()
		return

	if(world.time <= last_check+check_delay)
		return

	last_check = world.time

	if(!los_check(get_atom_on_turf(src), current_target, mid_check = CALLBACK(src, PROC_REF(mid_los_check))))
		QDEL_NULL(current_beam)//this will give the target lost message
		return

	if(current_target)
		on_beam_tick(current_target)

/obj/item/gun/medbeam/proc/mid_los_check(atom/movable/user, mob/target, pass_args = PASSTABLE|PASSGLASS|PASSGRILLE, turf/next_step, obj/dummy)
	for(var/obj/effect/ebeam/medical/B in next_step)// Don't cross the str-beams!
		if(QDELETED(current_beam))
			break //We shouldn't be processing anymore.
		if(QDELETED(B))
			continue
		if(!B.owner)
			stack_trace("beam without an owner! [B]")
			continue
		if(B.owner.origin != current_beam.origin)
			explosion(B.loc, heavy_impact_range = 3, light_impact_range = 5, flash_range = 8, explosion_cause = src)
			qdel(dummy)
			return FALSE
	return TRUE

/obj/item/gun/medbeam/proc/on_beam_hit(mob/living/target)
	return

/obj/item/gun/medbeam/proc/on_beam_tick(mob/living/target)
	if(target.health != target.maxHealth)
		new /obj/effect/temp_visual/heal(get_turf(target), COLOR_HEALING_CYAN)
	var/need_mob_update
	need_mob_update = target.adjustBruteLoss(-4, updating_health = FALSE, forced = TRUE)
	need_mob_update += target.adjustFireLoss(-4, updating_health = FALSE, forced = TRUE)
	need_mob_update += target.adjustToxLoss(-1, updating_health = FALSE, forced = TRUE)
	need_mob_update += target.adjustOxyLoss(-1, updating_health = FALSE, forced = TRUE)
	if(need_mob_update)
		target.updatehealth()
	return

/obj/item/gun/medbeam/proc/on_beam_release(mob/living/target)
	return

/obj/effect/ebeam/medical
	name = "medical beam"

//////////////////////////////Mech Version///////////////////////////////
/obj/item/gun/medbeam/mech
	mounted = TRUE

/obj/item/gun/medbeam/mech/Initialize(mapload)
	. = ..()
	STOP_PROCESSING(SSobj, src) //Mech mediguns do not process until installed, and are controlled by the holder obj

//////////////////////////Caloray///////////////////////////////////////

#define CALORAY_DEFAULT_INTENSITY 20

/obj/item/gun/medbeam/caloray
	name = "Caloray"
	desc = "A device that uses gainium shards to siphon calories from organic beings."
	icon_state = "caloray_push"
	
	var/mode = "fatten"
	var/powerbeam = "r_beam"
	var/calgen = 0
	var/opened = FALSE
	var/intensity = CALORAY_DEFAULT_INTENSITY
	var/power_use = STANDARD_CELL_CHARGE * 5 / (10 * CALORAY_DEFAULT_INTENSITY)	// value in joules, with 20 intensity, it will result in 10% of the capacity of the default cell
	var/cell_type = /obj/item/stock_parts/power_store/cell/upgraded/plus
	var/obj/item/stock_parts/power_store/cell/cell

/obj/item/gun/medbeam/caloray/Initialize(mapload)
	. = ..()
	START_PROCESSING(SSobj, src)
	if(!cell && cell_type)
		cell = new cell_type
		cell.charge = 0
	update_icon_state()

/obj/item/gun/medbeam/caloray/charged/Initialize(mapload)
	. = ..()
	cell.charge = cell.max_charge()
	update_icon_state()

/obj/item/gun/medbeam/caloray/examine(mob/user)
	. = ..()

	. += span_notice("It is currently set to [mode] at [intensity]% intensity.")

	if (cell)
		. += span_notice("It's cell is [cell.percent()]% charged.")
	else
		. += span_notice("It has no power cell installed.")
	
	if (opened)
		. += span_notice("It's battery compartment is currently open.")

/obj/item/gun/medbeam/caloray/update_icon_state()
	. = ..()
	if(!cell || cell.charge() == 0)
		icon_state = "caloray_off"
		return
	
	if(mode == "fatten")
		icon_state = "caloray_push"
	
	if(mode == "thin")
		icon_state = "caloray_pull"


/obj/item/gun/medbeam/caloray/attack_self(mob/user)
	if(opened == FALSE)
		playsound(user, 'sound/items/weapons/gun/general/slide_lock_1.ogg', 60, 1)
		if (mode == "fatten")
			to_chat(user, span_notice("You change the setting on the beam to thin."))
			powerbeam = "b_beam"
			mode = "thin"
		else
			to_chat(user, span_notice("You change the setting on the beam to fatten."))
			powerbeam = "r_beam"
			mode = "fatten"

	if(opened == TRUE && cell)
		user.visible_message("[user] removes [cell] from [src]!", span_notice("You remove [cell]."))
		cell.update_icon()
		user.put_in_hands(cell)
		cell = null
		playsound(user, 'sound/items/weapons/gun/general/ionpulse.ogg', 60, 1)

	else if(opened == TRUE && isnull(cell))
		user.visible_message(span_warning("The Caloray doesn't have a power cell installed."))
	
	update_icon_state()
	LoseTarget()

/obj/item/gun/medbeam/caloray/attackby(obj/item/item, mob/user)
	if(item.tool_behaviour == TOOL_WRENCH)
		if(opened == FALSE)
			to_chat(user, span_notice("You open the Caloray's battery compartment."))
			opened = TRUE
		else
			to_chat(user, span_notice("You close the Caloray's battery compartment."))
			opened = FALSE

		item.play_tool_sound(src)
		LoseTarget()
		return

	if(opened && istype(item, /obj/item/stock_parts/power_store/cell))
		if(cell)
			to_chat(user, span_notice("[src] already has \a [cell] installed!"))
			return
		
		if(!user.transferItemToLoc(item, src))
			return
		
		to_chat(user, span_notice("You insert [item] into [src]."))
		cell = item

		if(mode == "fatten")
			powerbeam = "r_beam"
		if(mode == "thin")
			powerbeam = "b_beam"
		
		update_icon_state()

/obj/item/gun/medbeam/caloray/LoseTarget()
	. = ..()
	update_icon_state()

/obj/item/gun/medbeam/caloray/process_fire(atom/target, mob/living/user, message = TRUE, params = null, zone_override = "", bonus_spread = 0)
	if(isliving(user))
		add_fingerprint(user)

	if(current_target)
		LoseTarget()
	if(!isliving(target))
		return

	current_target = target
	active = TRUE
	current_beam = user.Beam(current_target, icon_state = powerbeam, time = 10 MINUTES, maxdistance = max_range, beam_type = /obj/effect/ebeam/medical)
	playsound(user, 'sound/items/weapons/gun/general/caloray.ogg', 60, 1)
	RegisterSignal(current_beam, COMSIG_QDELETING, PROC_REF(beam_died))//this is a WAY better rangecheck than what was done before (process check)
	START_PROCESSING(SSobj, src)

	SSblackbox.record_feedback("tally", "gun_fired", 1, type)
	return TRUE

/obj/item/gun/medbeam/caloray/on_beam_tick(mob/living/carbon/target)
	if(mode == "fatten")
		if(cell.charge() > 0 && target.fatness_real < FATNESS_LEVEL_19)
			var/energy_used = cell.use(power_use * intensity, TRUE)
			target.adjust_fatness(energy_used / 250, FATTENING_TYPE_ITEM)	// assuming energy_used = power_use, this will result in a maximum of 20 BFI
			new /obj/effect/temp_visual/heal(get_turf(target), "#ff0000")
		else
			LoseTarget()
			return

	if(mode == "thin")
		if(cell.charge() < cell.max_charge() && target.fatness_real > 0)
			var/BFI_burned = min(target.fatness_real, intensity)
			target.adjust_fatness(BFI_burned, FATTENING_TYPE_ITEM)
			cell.give(BFI_burned * 250)	// with intensity 20, at most 5000 Joules
			new /obj/effect/temp_visual/heal(get_turf(target), "#1100ff")
		else
			LoseTarget()
			return

//////////////////////////////Mech Version///////////////////////////////
/obj/item/gun/medbeam/caloray/mech
	mounted = TRUE

/obj/item/gun/medbeam/caloray/mech/Initialize(mapload)
	. = ..()
	STOP_PROCESSING(SSobj, src) //Mech mediguns do not process until installed, and are controlled by the holder obj

#undef CALORAY_DEFAULT_INTENSITY
