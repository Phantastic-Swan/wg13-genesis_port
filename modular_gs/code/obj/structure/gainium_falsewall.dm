/obj/structure/falsewall/gainium            //GS13
	name = "gainium wall"
	desc = "A wall with gainium plating. Burp."
	icon = 'modular_gs/icons/turf/false_walls.dmi'
	fake_icon = 'modular_gs/icons/turf/gainium_wall.dmi'
	icon_state = "gainium_wall-open"
	base_icon_state = "gainium_wall"
	mineral = /obj/item/stack/sheet/mineral/gainium
	walltype = /turf/closed/wall/mineral/gainium
	smoothing_flags = SMOOTH_BITMASK
	smoothing_groups = SMOOTH_GROUP_GAINIUM_WALL + SMOOTH_GROUP_WALLS
	canSmoothWith = SMOOTH_GROUP_GAINIUM_WALL
	var/active = null
	var/last_event = 0

/obj/structure/falsewall/gainium/proc/fatten()
	if(!active)
		if(world.time > last_event+15)
			active = 1
			for(var/mob/living/carbon/human/M in orange(3,src))
				M.adjust_fatness(30, FATTENING_TYPE_ITEM)
			last_event = world.time
			active = null
			return
	return

/obj/structure/falsewall/gainium/Bumped(atom/movable/AM)
	fatten()
	..()

/obj/structure/falsewall/gainium/attackby(obj/item/W, mob/user, params)
	fatten()
	return ..()

/obj/structure/falsewall/gainium/attack_hand(mob/user)
	fatten()
	. = ..()
