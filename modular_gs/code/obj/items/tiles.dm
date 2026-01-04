// not in a folder on it's own because rn we don't have enough
// if we start having more of those than just the gainium ones, we should just put it into a folder
// and name the files appropiately

/obj/item/stack/tile/mineral/gainium  //GS13
	name = "Gainium tile"
	singular_name = "Gainium floor tile"
	desc = "A tile made out of gainium. Bwoomph."
	icon = 'modular_gs/icons/obj/tiles.dmi'
	inhand_icon_state = null
	lefthand_file = null
	righthand_file = null
	icon_state = "tile_gainium"
	turf_type = /turf/open/floor/mineral/gainium
	mineralType = "gainium"
	mats_per_unit = list(/datum/material/gainium = SHEET_MATERIAL_AMOUNT*0.25)
	merge_type = /obj/item/stack/tile/mineral/gainium

/obj/item/stack/tile/mineral/gainium/hide  //GS13 - disguised variant
	name = "Floor tile"
	singular_name = "gainium floor tile"
	desc = "A tile totally made out of steel."
	icon_state = "tile"
	turf_type = /turf/open/floor/mineral/gainium/hide

/obj/item/stack/tile/mineral/gainium/strong  //GS13 - strong variant
	name = "Infused gainium tile"
	singular_name = "Infused gainium floor tile"
	desc = "A tile made out of stronger variant of gainium. Bwuurp."
	icon_state = "tile_gainium_strong"
	turf_type = /turf/open/floor/mineral/gainium/strong

/obj/item/stack/tile/mineral/gainium/dance  //GS13 - glamourous variant!
	name = "Gainium dance floor"
	singular_name = "Gainium dance floor tile"
	desc = "A dance floor made out of gainium, for a party both you and your waistline will never forget!."
	icon_state = "tile_gainium_dance"
	turf_type = /turf/open/floor/mineral/gainium/dance
