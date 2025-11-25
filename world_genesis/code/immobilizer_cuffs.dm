/**
 * # Generic restraints
 *
 * Parent class for handcuffs and handcuff accessories
 *
 * Functionality:
 * 1. A special suicide
 * 2. If a restraint is handcuffing/legcuffing a carbon while being deleted, it will remove the handcuff/legcuff status.
*/

/obj/item/restraints
	breakouttime = 1 MINUTES
	dye_color = DYE_PRISONER
	icon = 'icons/obj/weapons/restraints.dmi'

/obj/item/restraints/suicide_act(mob/living/carbon/user)
	user.visible_message(span_suicide("[user] is strangling [user.p_them()]self with [src]! It looks like [user.p_theyre()] trying to commit suicide!"))
	return OXYLOSS

// Zipties, cable cuffs, etc. Can be cut with wirecutters instantly.
#define HANDCUFFS_TYPE_WEAK 0
// Handcuffs... alien handcuffs. Can be cut through only by jaws of life.
#define HANDCUFFS_TYPE_STRONG 1

/**
 * # Handcuffs
 *
 * Stuff that makes humans unable to use hands
 *
 * Clicking people with those will cause an attempt at handcuffing them to occur
*/
/obj/item/restraints/immobilizer_cuffs
	name = "immobilizer cuffs"
	gender = PLURAL
	icon_state = "immobilizer_on"
	worn_icon_state = "handcuff"
	inhand_icon_state = "handcuff"
	lefthand_file = 'icons/mob/inhands/equipment/security_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/equipment/security_righthand.dmi'
	obj_flags = CONDUCTS_ELECTRICITY
	slot_flags = ITEM_SLOT_BELT | ITEM_SLOT_HANDCUFFED
	throwforce = 0
	w_class = WEIGHT_CLASS_SMALL
	throw_speed = 3
	throw_range = 5
	custom_materials = list(/datum/material/iron= SMALL_MATERIAL_AMOUNT * 5)
	breakouttime = 1 MINUTES
	armor_type = /datum/armor/restraints_handcuffs
	custom_price = PAYCHECK_COMMAND * 0.35
	pickup_sound = 'sound/items/handling/handcuffs/handcuffs_pick_up.ogg'
	drop_sound = 'sound/items/handling/handcuffs/handcuffs_drop.ogg'
	sound_vary = TRUE
	var/opened = FALSE
	var/cell_type = /obj/item/stock_parts/power_store/cell/upgraded/plus
	var/obj/item/stock_parts/power_store/cell/upgraded/plus/cell

	///How long it takes to handcuff someone
	var/handcuff_time = 4 SECONDS
	///Multiplier for handcuff time
	var/handcuff_time_mod = 1
	///Sound that plays when starting to put handcuffs on someone
	var/cuffsound = 'sound/items/weapons/handcuffs.ogg'
	///Sound that plays when restrain is successful
	var/cuffsuccesssound = 'sound/items/weapons/gun/general/ionpulse.ogg'
	///If set, handcuffs will be destroyed on application and leave behind whatever this is set to.
	var/trashtype = null
	/// How strong the cuffs are. Weak cuffs can be broken with wirecutters or boxcutters.
	var/restraint_strength = HANDCUFFS_TYPE_STRONG

/obj/item/restraints/immobilizer_cuffs/Initialize(mapload)
	. = ..()
	START_PROCESSING(SSobj, src)
	if(!cell && cell_type)
		cell = new cell_type
		cell.charge = cell.maxcharge
		desc = "A set of specialized restraints that emit a localized gainium pulse when applied. The power cell is [(cell.charge/cell.maxcharge)*100]% charged."

/obj/item/restraints/immobilizer_cuffs/apply_fantasy_bonuses(bonus)
	. = ..()
	handcuff_time = modify_fantasy_variable("handcuff_time", handcuff_time, -bonus * 2, minimum = 0.3 SECONDS)

/obj/item/restraints/immobilizer_cuffs/remove_fantasy_bonuses(bonus)
	handcuff_time = reset_fantasy_variable("handcuff_time", handcuff_time)
	return ..()


/obj/item/restraints/immobilizer_cuffs/attack(mob/living/target_mob, mob/living/user)
	if(!iscarbon(target_mob))
		return

	attempt_to_cuff(target_mob, user)

/// Handles all of the checks and application in a typical situation where someone attacks a carbon victim with the handcuff item.
/obj/item/restraints/immobilizer_cuffs/proc/attempt_to_cuff(mob/living/carbon/victim, mob/living/user)
	if(SEND_SIGNAL(victim, COMSIG_CARBON_CUFF_ATTEMPTED, user) & COMSIG_CARBON_CUFF_PREVENT)
		victim.balloon_alert(user, "can't be handcuffed!")
		return

	if(iscarbon(user) && (HAS_TRAIT(user, TRAIT_CLUMSY) && prob(50))) //Clumsy people have a 50% chance to handcuff themselves instead of their target.
		to_chat(user, span_warning("Uh... how do those things work?!"))
		apply_cuffs(user, user)
		return

	if(!isnull(victim.handcuffed))
		victim.balloon_alert(user, "already handcuffed!")
		return

	if(!victim.canBeHandcuffed())
		victim.balloon_alert(user, "can't be handcuffed!")
		return

	victim.visible_message(
		span_danger("[user] is trying to put [src] on [victim]!"),
		span_userdanger("[user] is trying to put [src] on you!"),
	)

	if(victim.is_blind())
		to_chat(victim, span_userdanger("As you feel someone grab your wrists, [src] start digging into your skin!"))

	playsound(loc, cuffsound, 30, TRUE, -2)
	log_combat(user, victim, "attempted to handcuff")

	if(HAS_TRAIT(user, TRAIT_FAST_CUFFING))
		handcuff_time_mod = 0.75
	else
		handcuff_time_mod = 1

	if(!do_after(user, handcuff_time * handcuff_time_mod, victim, timed_action_flags = IGNORE_SLOWDOWNS) || !victim.canBeHandcuffed())
		victim.balloon_alert(user, "failed to handcuff!")
		to_chat(user, span_warning("You fail to handcuff [victim]!"))
		log_combat(user, victim, "failed to handcuff")
		return

	apply_cuffs(victim, user, dispense = iscyborg(user))
	playsound(loc, cuffsuccesssound, 30, TRUE, -2)
	victim.fatness_real += cell.charge/10
	cell.charge = 0
	icon_state = "immobilizer_off"
	desc = "A set of specialized restraints that emit a localized gainium pulse when applied. The power cell is empty."

	victim.visible_message(
		span_notice("[user] handcuffs [victim]."),
		span_userdanger("[user] handcuffs you. Sending out a pulse of gainium infused energy."),
	)

	log_combat(user, victim, "successfully handcuffed")
	SSblackbox.record_feedback("tally", "handcuffs", 1, type)


/**
 * When called, this instantly puts handcuffs on someone (if actually possible)
 *
 * Arguments:
 * * mob/living/carbon/target - Who is being handcuffed
 * * mob/user - Who or what is doing the handcuffing
 * * dispense - True if the cuffing should create a new item instead of using putting src on the mob, false otherwise. False by default.
*/
/obj/item/restraints/immobilizer_cuffs/proc/apply_cuffs(mob/living/carbon/target, mob/user, dispense = FALSE)
	if(target.handcuffed)
		return

	if(!user.temporarilyRemoveItemFromInventory(src) && !dispense)
		return

	var/obj/item/restraints/handcuffs/cuffs = src
	if(trashtype)
		cuffs = new trashtype()
	else if(dispense)
		cuffs = new type()

	target.equip_to_slot(cuffs, ITEM_SLOT_HANDCUFFED)
	SEND_SIGNAL(target, COMSIG_MOB_HANDCUFFED) //BUBBER EDIT ADDITION

	if(trashtype && !dispense)
		qdel(src)

/obj/item/restraints/immobilizer_cuffs/attackby(obj/item/W, mob/user)
	if(W.tool_behaviour == TOOL_WRENCH)
		if(opened == FALSE)
			W.play_tool_sound(src)
			to_chat(user, "<span class='notice'>You open the battery compartment on the immobilizer cuffs.</span>")
			opened = TRUE
			return

		if(opened == TRUE)
			W.play_tool_sound(src)
			to_chat(user, "<span class='notice'>You close the battery compartment on the immobilizer cuffs.</span>")
			opened = FALSE
			return

	if(istype(W, /obj/item/stock_parts/power_store/cell))
		if(opened)
			if(!cell)
				if(!user.transferItemToLoc(W, src))
					return
				to_chat(user, "<span class='notice'>You insert [W] into [src].</span>")
				cell = W
				if(cell.charge > 0)
					icon_state = "immobilizer_on"
					desc = "A set of specialized restraints that emit a localized gainium pulse when applied. The power cell is [(cell.charge/cell.maxcharge)*100]% charged."
				else
					icon_state = "immobilizer_off"
					desc = "A set of specialized restraints that emit a localized gainium pulse when applied. It seems to be lacking a power source."
				return
			else
				to_chat(user, "<span class='notice'>[src] already has \a [cell] installed!</span>")
				return



/obj/item/restraints/immobilizer_cuffs/attack_self(mob/user)
	if(opened == TRUE && cell)
		to_chat(user, "<span class='notice'>You remove the power cell from the immobilizer cuffs.</span>")
		user.put_in_hands(cell)
		cell = null
		icon_state = "immobilizer_off"
		desc = "A set of specialized restraints that emit a localized gainium pulse when applied. It seems to be lacking a power source."
		playsound(user, 'sound/items/weapons/gun/general/slide_lock_1.ogg', 60, 1)
