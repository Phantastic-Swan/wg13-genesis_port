/turf/open/floor/mineral/gainium
	name = "Gainium floor"
	icon = 'modular_gs/icons/turf/floors.dmi'
	damaged_dmi = 'modular_gs/icons/turf/floors.dmi'
	icon_state = "gainium"
	floor_tile = /obj/item/stack/tile/mineral/gainium
	icons = "gainium"
	var/last_event = 0
	var/active = null
	///How much fatness is added to the user upon crossing?
	var/fat_to_add = 25

/turf/open/floor/mineral/gainium/Entered(mob/living/carbon/M)
	if(!istype(M, /mob/living/carbon))
		return FALSE
	else
		M.adjust_fatness(fat_to_add, FATTENING_TYPE_ITEM)

// gainium floor, disguised version - GS13

/turf/open/floor/mineral/gainium/hide
	name = "Steel floor"
	icon_state = "gainium_hide"
	floor_tile = /obj/item/stack/tile/mineral/gainium/hide
	icons = "gainium_hide"
	damaged_dmi = null

// gainium floor, powerful version - GS13

/turf/open/floor/mineral/gainium/strong
	name = "Infused gainium floor"
	icon_state = "gainium_strong"
	floor_tile = /obj/item/stack/tile/mineral/gainium/strong
	damaged_dmi = null
	icons = "gainium_strong"
	fat_to_add = 100

// gainium dance floor, groovy! - GS13

/turf/open/floor/mineral/gainium/dance
	name = "Gainium dance floor"
	icon_state = "gainium_dance"
	floor_tile = /obj/item/stack/tile/mineral/gainium/dance
	icons = "gainium_dance"
	damaged_dmi = null
