/obj/item/organ/chest/gainium_tumor
	name = "gainium tumor"
	desc = "A geode-like tumor harboring shards of red crystal encased in a blubbery casing"
	icon_state = "nutriment_implant"
	var/hunger_threshold = NUTRITION_LEVEL_FAT
	var/synthesizing = 0
	var/poison_amount = 5
	slot = ORGAN_SLOT_TUMOR

/obj/item/organ/chest/gainium_tumor/on_life(seconds_per_tick, times_fired)
	if(synthesizing)
		return

	if(owner.nutrition <= hunger_threshold)
		synthesizing = TRUE
		to_chat(owner, span_notice("You feel less hungry..."))
		owner.adjust_nutrition(250 * seconds_per_tick)
		addtimer(CALLBACK(src, PROC_REF(synth_cool)), 5 SECONDS)
		if(owner.fatness_real > FATNESS_LEVEL_19)
			owner.gib(DROP_ORGANS|DROP_BODYPARTS)

/obj/item/organ/chest/gainium_tumor/proc/synth_cool()
	synthesizing = FALSE
