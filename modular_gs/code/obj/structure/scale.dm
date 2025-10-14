/obj/structure/scale
	name = "HEF-T Heavy Duty Scale"
	desc = "That's HEF-T! A durable scale with a built in AI intellicard and LED display. A perfect weight management companion built by World Genesis."
	icon = 'modular_gs/icons/obj/scale.dmi'
	icon_state = "scale_off"
	anchored = TRUE
	resistance_flags = NONE
	max_integrity = 250
	integrity_failure = 25
	var/buildstacktype = /obj/item/stack/sheet/iron
	var/buildstackamount = 3
	layer = OBJ_LAYER
	//stores the weight of the last person to step on in Lbs
	var/lastreading = 0
	//the conversion ratio for how much a point of fatness weighs on a 6' person
	var/fatnessToWeight = 0.25

/obj/structure/scale/attackby(obj/item/W, mob/user, params)
	if(W.tool_behaviour == TOOL_WRENCH && !(flags_1 & NO_DEBRIS_AFTER_DECONSTRUCTION))
		W.play_tool_sound(src)
		deconstruct()

	return ..()

/obj/structure/scale/Initialize(mapload)
	. = ..()
	var/static/list/loc_connections = list(
		COMSIG_ATOM_ENTERED = PROC_REF(weighperson)
	)
	AddElement(/datum/element/connect_loc, loc_connections)

/obj/structure/scale/examine(mob/user)
	. = ..()
	. += "Its last reading was: [src.lastreading]lbs"
	. += "<span class='notice'>It's held together by a couple of <b>bolts</b>.</span>"

/obj/structure/scale/proc/weighEffect(mob/living/carbon/human/fatty) //WG13 HEF-T Scale Edit

	to_chat(fatty, "<span class='notice'>You weigh yourself.</span>")
	to_chat(fatty, "<span class='notice'>The numbers on the screen tick up and eventually settle on:</span>")
	//The appearance of the numbers changes with the fat level of the character
	if (HAS_TRAIT(fatty, TRAIT_FATNESS_19))
		to_chat(fatty, "<span class='userdanger'><span class='big'>The scale breaks beneath your weight!!!</span></span>")
		playsound(fatty,'sound/effects/bang.ogg', 60, 1)
		deconstruct()

	else if(HAS_TRAIT(fatty, TRAIT_FATNESS_15) || HAS_TRAIT(fatty, TRAIT_FATNESS_16) || HAS_TRAIT(fatty, TRAIT_FATNESS_17)|| HAS_TRAIT(fatty, TRAIT_FATNESS_18))
		to_chat(fatty, "<span class='userdanger'><span class='big'>[round(src.lastreading/2000, 0.01)]TONS!!!</span></span>")
		icon_state = "scale_bsod"
		say(pick("ERR: MAXIMUM WEIGHT EXCEEDED.", "INTERNAL EXCEPTION: LARDASS FOUND.", "SYSTEM MESSAGE: HAVE MERCY!", "[fatty] EXCEEDS WEIGHT PARAMATERS FOR THIS UNIT."))
		playsound(fatty,'sound/machines/arcade/lose.ogg', 60, 1)

	else if(HAS_TRAIT(fatty, TRAIT_FATNESS_11) || HAS_TRAIT(fatty, TRAIT_FATNESS_12) || HAS_TRAIT(fatty, TRAIT_FATNESS_13)|| HAS_TRAIT(fatty, TRAIT_FATNESS_14))
		to_chat(fatty, "<span class='boldannounnce'>[src.lastreading]lbs.</span>")
		icon_state = "scale_obese"
		say(pick("Careful [fatty]! You almost +BROKE+ me there!", "I just registered a 4.0 on the richter scale. +You+ wouldn't happen to know anything about that would you?", "Hey! This unit isn't meant to weigh livestock! Get off!", "Heeeelp! Pressure damage detected!"))
		playsound(fatty,'sound/machines/compiler/compiler-failure.ogg', 60, 1)

	else if(HAS_TRAIT(fatty, TRAIT_FATNESS_7) || HAS_TRAIT(fatty, TRAIT_FATNESS_8) || HAS_TRAIT(fatty, TRAIT_FATNESS_9)|| HAS_TRAIT(fatty, TRAIT_FATNESS_10))
		to_chat(fatty, "<span class='alert'>[src.lastreading]lbs.</span>")
		icon_state = "scale_overweight"
		say(pick("Hey there... [fatty]. I didn't recognize you all that extra fluff!", "Working on your love handles [fatty]?", "Have you considered applying to the fattery program [fatty]? You'd be a great fit!", "Clothes feeling snug? I hear the GloboDrobe has some great threads in plus sizes!"))
		playsound(fatty,'sound/machines/buzz/buzz-two.ogg', 60, 1)

	else if(HAS_TRAIT(fatty, TRAIT_FATNESS_3) || HAS_TRAIT(fatty, TRAIT_FATNESS_4) || HAS_TRAIT(fatty, TRAIT_FATNESS_5)|| HAS_TRAIT(fatty, TRAIT_FATNESS_6))
		to_chat(fatty, "<span class='notice'>[src.lastreading]lbs.</span>")
		icon_state = "scale_chubby"
		say(pick("Looking kinda' chunky there [fatty]!", "Woah, seems you've packed on a few pounds!", "Easy on the snacks there [fatty]!", "May I suggest a complimentary salad from one of our many World Genesis food vendors?"))
		playsound(fatty,'sound/machines/buzz/buzz-sigh.ogg', 60, 1)

	else
		to_chat(fatty, "<span class='notice'>[src.lastreading]lbs.</span>")
		say(pick("Looking good!", "All Healthy Here!", "Keeping trim I see!", "Nice bod [fatty]!"))
		icon_state = "scale_normal"
		playsound(fatty,'sound/machines/ping.ogg', 60, 1)

/obj/structure/scale/proc/weighperson(datum/source, var/mob/living/carbon/fatty)
	SIGNAL_HANDLER
	if(!istype(fatty) || (fatty.movement_type & FLYING))
		return FALSE

	src.lastreading = fatty.calculate_weight_in_pounds()
	weighEffect(fatty)
	visible_message("<span class='notice'>[fatty] weighs themselves.</span>")
	visible_message("<span class='notice'>The numbers on the screen settle on: [src.lastreading]Lbs.</span>")
	visible_message("<span class='notice'>The numbers on the screen read out: [fatty] has a BFI of [fatty.fatness].</span>")

/mob/living/carbon/proc/calculate_weight_in_pounds()
	return round((140 + (fatness*FATNESS_TO_WEIGHT_RATIO)))
	//return round((140 + (fatness*FATNESS_TO_WEIGHT_RATIO))*(size_multiplier**2)*((dna.features["taur"] != "None") ? 2.5: 1))
