/turf/closed/wall/mineral/gainium //GS13
	name = "gainium wall"
	desc = "A wall with gainium plating. Burp."
	icon = 'modular_gs/icons/turf/gainium_wall.dmi'
	icon_state = "gainium_wall-0"
	base_icon_state = "gainium_wall"
	sheet_type = /obj/item/stack/sheet/mineral/gainium
	smoothing_groups = SMOOTH_GROUP_GAINIUM_WALL + SMOOTH_GROUP_WALLS + SMOOTH_GROUP_CLOSED_TURFS
	canSmoothWith = SMOOTH_GROUP_GAINIUM_WALL
	var/active = null
	var/last_event = 0

/turf/closed/wall/mineral/gainium/proc/fatten()
	if(!active)
		if(world.time > last_event+15)
			active = 1
			for(var/mob/living/carbon/human/M in orange(3,src))
				M.adjust_fatness(30, FATTENING_TYPE_ITEM)
			last_event = world.time
			active = null
			return
	return

/turf/closed/wall/mineral/gainium/Bumped(atom/movable/AM)
	fatten()
	..()

/turf/closed/wall/mineral/gainium/attackby(obj/item/W, mob/user, params)
	fatten()
	return ..()

/turf/closed/wall/mineral/gainium/attack_hand(mob/user)
	fatten()
	. = ..()
