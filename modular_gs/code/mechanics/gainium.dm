/datum/material/gainium
	name = "gainium"
	color = list(340/255, 150/255, 50/255,0, 0,0,0,0, 0,0,0,0, 0,0,0,1, 0,0,0,0)
	strength_modifier = 1.5
	categories = list(
		MAT_CATEGORY_SILO = TRUE,
		MAT_CATEGORY_RIGID=TRUE,
		MAT_CATEGORY_BASE_RECIPES = FALSE, // doesn't seem to work :(
		MAT_CATEGORY_ITEM_MATERIAL = TRUE,
		MAT_CATEGORY_ITEM_MATERIAL_COMPLEMENTARY = TRUE,
	)
	sheet_type = /obj/item/stack/sheet/mineral/gainium
	ore_type = /obj/item/stack/ore/gainium
	value_per_unit = 110 / SHEET_MATERIAL_AMOUNT
	tradable = TRUE
	tradable_base_quantity = MATERIAL_QUANTITY_RARE
	beauty_modifier = 0.05
	armor_modifiers = list(MELEE = 1.1, BULLET = 1.1, LASER = 1.15, ENERGY = 1.15, BOMB = 1, BIO = 1, RAD = 1, FIRE = 0.7, ACID = 1.1) // Same armor as gold.
	mineral_rarity = MATERIAL_RARITY_PRECIOUS
	points_per_unit = 40 / SHEET_MATERIAL_AMOUNT
	fish_weight_modifier = 1.5 // fishing values copied from gold
	fishing_difficulty_modifier = -8
	fishing_cast_range = 1
	fishing_experience_multiplier = 0.75
	fishing_completion_speed = 1.2
	fishing_bait_speed_mult = 1.1
	fishing_deceleration_mult = 1.2
	fishing_bounciness_mult = 0.8
	fishing_gravity_mult = 1.2

/obj/item/stack/ore/gainium //GS13
	name = "gainium geode"
	singular_name = "gainium geode"
	icon = 'modular_gs/icons/obj/mining.dmi'
	icon_state = "Gainium ore"
	inhand_icon_state = "gainium geode"
	singular_name = "Gainium geode"
	points = 40
	// custom_materials = list(/datum/material/gainium=MINERAL_MATERIAL_AMOUNT)
	mats_per_unit = list(/datum/material/gainium = SHEET_MATERIAL_AMOUNT)
	refined_type = /obj/item/stack/sheet/mineral/gainium
	mine_experience = 20
	scan_state = "rock_gainium"
	merge_type = /obj/item/stack/ore/gainium

/obj/item/stack/sheet/mineral/gainium
	name = "gainium"
	icon = 'modular_gs/icons/obj/stack_objects.dmi'
	icon_state = "sheet-gainium"
	inhand_icon_state = "sheet-gainium"
	singular_name = "gainium crystal"
	sheettype = "gainium"
	novariants = TRUE
	grind_results = list(/datum/reagent/consumable/lipoifier = 2)
	// point_value = 40
	// custom_materials = list(/datum/material/gainium=MINERAL_MATERIAL_AMOUNT)
	mats_per_unit = list(/datum/material/gainium = SHEET_MATERIAL_AMOUNT)
	merge_type = /obj/item/stack/sheet/mineral/gainium
	material_type = /datum/material/gainium
	walltype = /turf/closed/wall/mineral/gainium

/datum/material/gainium/on_applied(atom/source, amount, multiplier) // used to be material_flags instead of multiplier
	. = ..()
	// if(!(material_flags & MATERIAL_AFFECT_STATISTICS))
	// 	return

	if (isobj(source))
		var/obj/source_obj = source
		source_obj.damtype = FAT

/datum/material/gainium/on_removed(atom/source, multiplier) // used to be material_flags instead of multiplier
	// if(!(material_flags & MATERIAL_AFFECT_STATISTICS))
	// 	return ..()

	if (isobj(source))
		var/obj/source_obj = source
		source_obj.damtype = initial(source_obj.damtype)
		return ..()


/turf/closed/mineral/gainium //GS13
	mineralType = /obj/item/stack/ore/gainium
	scan_state = "rock_gainium"

/obj/item/stack/sheet/mineral/gainium/five
	amount = 5

/obj/item/stack/sheet/mineral/gainium/ten
	amount = 10

/obj/item/stack/sheet/mineral/gainium/fifty
	amount = 50

GLOBAL_LIST_INIT(gainium_recipes, list ( \
	new/datum/stack_recipe("gainium tile", /obj/item/stack/tile/mineral/gainium, 1, 4, 20, crafting_flags = NONE, category = CAT_TILES), \
	/*new/datum/stack_recipe("Gainium Ingots", /obj/item/ingot/gainium, time = 30), \*/
	new/datum/stack_recipe("Fatty statue", /obj/structure/statue/gainium/fatty, 5, time = 10 SECONDS, crafting_flags = CRAFT_CHECK_DENSITY | CRAFT_ON_SOLID_GROUND | CRAFT_ONE_PER_TURF),\
	/*new/datum/stack_recipe("Gainium doors", /obj/structure/mineral_door/gainium, 5, time = 5 SECONDS, crafting_flags = CRAFT_CHECK_DENSITY | CRAFT_ONE_PER_TURF | CRAFT_ON_SOLID_GROUND | CRAFT_APPLIES_MATS, category = CAT_DOORS),\*/
	))

/obj/item/stack/sheet/mineral/gainium/get_main_recipes()
	. = ..()
	. += GLOB.gainium_recipes

/obj/item/ingot/gainium
	custom_materials = list(/datum/material/gainium=1500)
