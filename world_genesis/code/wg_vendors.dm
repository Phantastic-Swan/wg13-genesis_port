//WORLD GENESIS - SNACKTRON VENDOR
/obj/machinery/vending/imported/snacktron
	name = "SnackTron™"
	desc = "The flagship vending product for World Genesis. When you need a snack we've got your back!"
	icon = 'world_genesis/icons/machinery/vendors.dmi'
	icon_state = "snacktron"
	panel_type = "panel15"
	light_mask = "nt_food-light-mask"
	light_color = "#00ff40"
	product_ads = "You've encountered SnackTron! How fortunate for your hunger and/or thirst!;We've got your back when it comes to snacks!;What time is it? Snack time!"
	vend_reply = "SnackTron hopes you enjoy your selection!"

	product_categories = list(
		list(
			"name" = "Snacks",
			"icon" = "cookie",
			"products" = list(
				/obj/item/food/peanuts/random = 6,
				/obj/item/food/cnds/random = 6,
				/obj/item/food/pistachios = 6,
				/obj/item/food/cornchips/random = 6,
				/obj/item/food/sosjerky = 6,
				/obj/item/reagent_containers/cup/soda_cans/cola = 6,
				/obj/item/reagent_containers/cup/soda_cans/lemon_lime = 6,
				/obj/item/reagent_containers/cup/soda_cans/starkist = 6,
				/obj/item/reagent_containers/cup/soda_cans/pwr_game = 6,
			),
		),
		list(
			"name" = "Meals",
			"icon" = "pizza-slice",
			"products" = list(
				/obj/item/food/cake/chocolate = 99,
				/obj/item/food/burger/bigbite = 99,
				/obj/item/food/pizza/margherita = 99,
				/obj/item/wg13/devilcake = 6,
				/obj/item/wg13/cheribomb = 99,
			),
		),
	)

	refill_canister = /obj/item/vending_refill/snack/imported
	default_price = 0
	extra_price = 0
	payment_department = NO_FREEBIES
	allow_custom = TRUE



//WORLD GENESIS - GLOBODROBE VENDOR
/obj/machinery/vending/imported/globodrobe
	name = "Globodrobe™"
	desc = "A specialized machine that vends modular clothing items for the horizontally impaired."
	icon = 'world_genesis/icons/machinery/vendors.dmi'
	icon_state = "globodrobe"
	panel_type = "panel15"
	light_mask = "nt_food-light-mask"
	light_color = "#ff00f2"
	product_ads = "Wardrobe around the globe!;Suited and booted!;The finest threads for the finest employees!"
	vend_reply = "Looking good boss! Stop by again soon!"

	product_categories = list(
		list(
			"name" = "Jumpsuits",
			"icon" = "shirt",
			"products" = list(
				/obj/item/clothing/under/color/grey = 16,
				/obj/item/clothing/under/color/grey/cargo = 16,
				/obj/item/clothing/under/color/grey/medical= 16,
				/obj/item/clothing/under/color/grey/science = 16,
				/obj/item/clothing/under/color/grey/service = 16,
				/obj/item/clothing/under/color/grey/security = 16,
				/obj/item/clothing/under/color/grey/command = 16,
				/obj/item/clothing/under/color/grey/engi = 16,
			),
		),
	)

	refill_canister = /obj/item/vending_refill/snack/imported
	default_price = PAYCHECK_CREW * 0.5
	extra_price = PAYCHECK_COMMAND
	payment_department = NO_FREEBIES
	allow_custom = TRUE

//Devil's Food Cake
/obj/item/wg13/devilcake
	icon = 'world_genesis/icons/machinery/vendors.dmi'
	icon_state = "devilcake"
	name = "devil's food cake"
	desc = "A twisted treat that lets out demonic groans when bit into. It seems to regenerate itself when bitten into."

/obj/item/wg13/devilcake/attack(mob/living/carbon/M, mob/living/carbon/user) //WG13
	to_chat(M, "<span class='alert'>You take a bite from the devil's food cake.</span>")
	if(user != M)
		to_chat(user, "<span class='notice'>You feed the devil's food cake to [M], causing it to regenerate some of itself as you do so!</span>")
	playsound(M, 'sound/items/eatfood.ogg', 60, 1)
	M.fatness_real += 20


//Gainium Tenderburger
/obj/item/wg13/tenderburger
	icon = 'icons/obj/food/burgerbread.dmi'
	icon_state = "cheeseburgeralt"
	name = "gainium seasoned tenderburger"
	desc = "A burger tenderized with gainium instead of seasoning salt."
	var/hp = 5

/obj/item/wg13/tenderburger/attack(mob/living/carbon/M, mob/living/carbon/user) //WG13
	if(hp > 0 )
		M.fatness_real += 10
		to_chat(M, "<span class='notice'>You take a bite from the [src].</span>")
		if(user != M)
			to_chat(user, "<span class='notice'>You feed the [src] to [M].</span>")
		playsound(M, 'sound/items/eatfood.ogg', 60, 1)
		hp -= 1
	else
		M.fatness_real += 10
		qdel(src)
		to_chat(M, "<span class='alert'>There is no more of the [src] left to eat. Oh no!</span>")



//Gainium Pizza
/obj/item/wg13/gainiumpizza
	icon = 'icons/obj/food/pizza.dmi'
	icon_state = "arnoldpizza"
	name = "gainium seasoned pizza"
	desc = "A pizza lightly dusted in gainium flakes."
	var/hp = 15

/obj/item/wg13/gainiumpizza/attack(mob/living/carbon/M, mob/living/carbon/user) //WG13
	if(hp > 0 )
		M.fatness_real += 10
		to_chat(M, "<span class='notice'>You take a bite from the [src].</span>")
		if(user != M)
			to_chat(user, "<span class='notice'>You feed the [src] to [M].</span>")
		playsound(M, 'sound/items/eatfood.ogg', 60, 1)
		hp -= 1
	else
		M.fatness_real += 10
		qdel(src)
		to_chat(M, "<span class='alert'>There is no more of the [src] left to eat. Oh no!</span>")


//Gainium Cake
/obj/item/wg13/gainiumcake
	icon = 'icons/obj/food/piecake.dmi'
	icon_state = "liars_cake"
	name = "edencake"
	desc = "The frosting on this cake is imbued with gainium extract. Hoo boy!"
	var/hp = 4

/obj/item/wg13/gainiumcake/attack(mob/living/carbon/M, mob/living/carbon/user) //WG13
	if(hp > 0 )
		M.fatness_real += 20
		to_chat(M, "<span class='notice'>You take a bite from the [src].</span>")
		if(user != M)
			to_chat(user, "<span class='notice'>You feed the [src] to [M].</span>")
		playsound(M, 'sound/items/eatfood.ogg', 60, 1)
		hp -= 1
	else
		M.fatness_real += 20
		qdel(src)
		to_chat(M, "<span class='alert'>There is no more of the [src] left to eat. Oh no!</span>")



//Cheri Bomb
/obj/item/wg13/cheribomb
	icon = 'icons/obj/drinks/bottles.dmi'
	icon_state = "cheribomb"
	name = "Cheri Bomb"
	desc = "A highly potent mix of fizzy soda containing gainium salts, don't drink this if you want your clothes to fit!"
	var/hp = 20

/obj/item/wg13/cheribomb/attack(mob/living/carbon/M, mob/living/carbon/user) //WG13
	if(hp > 0 )
		M.fatness_real += 5
		to_chat(M, "<span class='notice'>You take a sip from the [src] bottle.</span>")
		if(user != M)
			to_chat(user, "<span class='notice'>You feed the [src] to [M].</span>")
		playsound(M, 'sound/items/drink.ogg', 60, 1)
		playsound(M, 'modular_gs/sound/voice/belch1.ogg', 60, 1)
		hp -= 1
	else
		to_chat(M, "<span class='alert'>There is no more of the [src] left to drink. Oh no!</span>")
		to_chat(user, "<span class='alert'>There is no more of the [src] left to feed to [M]. Oh no!</span>")
