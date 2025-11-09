/mob/living/carbon/proc/get_fullness_text()
	var/t_He = p_They()
	var/t_His = p_Their()

	switch(fullness)
		if(FULLNESS_LEVEL_BLOATED to FULLNESS_LEVEL_BEEG)
			return "[t_He] look[p_s()] like [t_He] ate a bit too much.\n"
		if(FULLNESS_LEVEL_BEEG to FULLNESS_LEVEL_NOMOREPLZ)
			return "[t_His] stomach looks very round and very full.\n"
		if(FULLNESS_LEVEL_NOMOREPLZ to INFINITY)
			return "[t_His] stomach has been stretched to enormous proportions.\n"

/mob/living/carbon/proc/get_weight_text()
	var/t_He = p_They()
	var/t_he = p_they()
	var/t_His = p_Their()
	var/t_his = p_their()
	var/t_is = p_are()
	var/ws_text

	if(fatness >= FATNESS_LEVEL_19)
		. += span_boldwarning("[t_He] [t_is] completely swallowed by immobile lard, a useless pile of jiggling flesh larger than it is tall by leaps and bounds. [t_his] stomach shakes the ground as it groans, demanding more. If you hadn't known who this was before, [t_He] would be unrecognizable.")

	else if(fatness >= FATNESS_LEVEL_18)
		. += span_boldwarning("[t_His] body is buried in lard so completely that [t_his] head is almost totally obscured by [t_his] jowls and neck rolls. Somehow, [t_he] finds a way to keep eating anyway.")

	else if(fatness >= FATNESS_LEVEL_17)
		. += span_boldwarning("[t_He] [t_is] so laden with lard that it cascades from [t_his] nearly buried head down to the place where [t_his] feet used to be. It's a miracle [t_his] skin can handle the sheer weight of [t_his] fat.")

	else if(fatness >= FATNESS_LEVEL_16)
		. += span_boldwarning("[t_His] formless blob of lard [t_he] calls a body is unable to be contained by anything even close to clothing. Nobody could ever see anything private, anyways.")

	else if(fatness >= FATNESS_LEVEL_15)
		. += span_boldwarning("[t_He] [t_is] laden with a superb amount of lard, [t_his] shapeless blob of a body useless for anything but rolling towards more food.")

	else if(fatness >= FATNESS_LEVEL_14)
		. += span_boldwarning("[t_He] [t_is] a large blob of fat, [t_his] body losing shape amid [t_his] endless flab. [t_His] legs are easily too coated in lard to do anything more than jiggle.")

	else if(fatness >= FATNESS_LEVEL_13)
		. += span_boldwarning("[t_He] [t_is] nothing more than a fatty blob, covered in doughy blubber, and far too fat to be moving.")

	else if(fatness >= FATNESS_LEVEL_12)
		. += span_warning("[t_He] [t_is] morbidly obese. [t_His] enormous gut sweeps the floor when [t_he] waddles. The fact that [t_he] can waddle at all is a miracle.")

	else if(fatness >= FATNESS_LEVEL_11)
		. += span_warning("[t_He] [t_is] extremely obese, [t_his] body heaving with each step, mobility beginning to slip from [t_his] grasp.")

	else if(fatness >= FATNESS_LEVEL_10)
		. += span_warning("[t_He] [t_is] obese, every last nook and cranny loaded with blubber and flab.")

	else if(fatness >= FATNESS_LEVEL_9)
		. += span_warning("[t_He] [t_is] completely swaddled in rolls of lard. [t_His] extremely overweight body seemingly never stops jiggling.")

	else if(fatness >= FATNESS_LEVEL_8)
		. += span_warning("[t_His] overweight body is covered in fat, [t_his] weight making movement nigh impossible.")

	else if(fatness >= FATNESS_LEVEL_7)
		. += span_notice("[t_He] [t_is] visibly overweight, if only slightly. A bulging belly and fat thighs force [t_his] to waddle rather than walk.")

	else if(fatness >= FATNESS_LEVEL_6)
		. += span_notice("[t_He] [t_is] is extremely chubby, [t_his] now sizeable gut and flabby rolls make moving a hassle.")

	else if(fatness >= FATNESS_LEVEL_5)
		. += span_notice("[t_He] has gotten chubby, [t_his] chunky body starting to form rolls around [t_his] midsection.")

	else if(fatness >= FATNESS_LEVEL_4)
		. += span_notice("[t_He] [t_is] looking slightly chubby, a pronounced, fat middle wobbling as [t_he] moves.")

	else if(fatness >= FATNESS_LEVEL_3)
		. += span_notice("[t_He] [t_is] getting plump, a plush belly and tight clothes resting on [t_his] frame.")

	else if(fatness >= FATNESS_LEVEL_2)
		. += span_notice("[t_He] [t_is] sporting the tiniest bit of paunch, a slight jiggle in each step.")

	return
