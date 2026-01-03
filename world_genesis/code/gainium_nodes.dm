//WG13 Specific Designs

/datum/design/caloray
	name = "Caloray"
	desc = "A device that uses gainium shards to siphon calories from organic beings."
	id = "caloray"
	build_type = PROTOLATHE | AWAY_LATHE
	materials = list(/datum/material/iron = SMALL_MATERIAL_AMOUNT * 0.5, /datum/material/glass =SMALL_MATERIAL_AMOUNT, /datum/material/gainium =SMALL_MATERIAL_AMOUNT)
	construction_time = 0.5 SECONDS
	build_path = /obj/item/gun/medbeam/caloray/charged
	category = list(
		RND_CATEGORY_EQUIPMENT
	)
	departmental_flags = DEPARTMENT_BITFLAG_SCIENCE | DEPARTMENT_BITFLAG_ENGINEERING

//WG13 Specific Techweb Nodes

/datum/techweb_node/gainium_energy
	id = TECHWEB_NODE_GAINIUM
	display_name = "Gainium Energy Conversion"
	description = "Converting caloric energy to electrical energy through the power of focused beam technology."
	prereq_ids = list(TECHWEB_NODE_ENERGY_MANIPULATION)
	design_ids = list(
		"caloray",
	)
	research_costs = list(TECHWEB_POINT_TYPE_GENERIC = TECHWEB_TIER_1_POINTS)
	announce_channels = list(RADIO_CHANNEL_SCIENCE)

