/mob/living/simple_animal/dancingcow
	name = "Polish Cow"
	desc = "Is it dancing?"
	icon_state = "dancingcow"
	icon_living = "dancingcow"
	icon_dead = "dancingcow_dead"
	gender = FEMALE
	mob_biotypes = MOB_ORGANIC|MOB_BEAST
	speak = list("moo?","moo","MOOOOOO", "Tylko jedno w glowie mam")
	speak_emote = list("moos","moos hauntingly")
	emote_hear = list("brays.")
	emote_see = list("shakes its head.")
	speak_chance = 1
	turns_per_move = 5
	see_in_dark = 6
	butcher_results = list(/obj/item/food/meat/slab = 6)
	response_help_continuous = "pets"
	response_help_simple = "pet"
	response_disarm_continuous = "gently pushes aside"
	response_disarm_simple = "gently push aside"
	response_harm_continuous = "kicks"
	response_harm_simple = "kick"
	attack_verb_continuous = "kicks"
	attack_verb_simple = "kick"
	attack_sound = 'sound/weapons/punch1.ogg'
	health = 50
	maxHealth = 50
	var/obj/item/udder/udder = null
	gold_core_spawnable = FRIENDLY_SPAWN
	blood_volume = BLOOD_VOLUME_NORMAL
	food_type = list(/obj/item/reagent_containers/food/snacks/grown/wheat)
	tame_chance = 25
	bonus_tame_chance = 15
	footstep_type = FOOTSTEP_MOB_SHOE
	pet_bonus = TRUE
	pet_bonus_emote = "moos happily!"

/mob/living/simple_animal/dancingcow/Initialize()
	udder = new()
	add_cell_sample()
	. = ..()

/mob/living/simple_animal/dancingcow/add_cell_sample()
	AddElement(/datum/element/swabable, CELL_LINE_TABLE_COW, CELL_VIRUS_TABLE_GENERIC_MOB, 1, 5)

/mob/living/simple_animal/dancingcow/Destroy()
	qdel(udder)
	udder = null
	return ..()

/mob/living/simple_animal/dancingcow/attackby(obj/item/O, mob/user, params)
	if(stat == CONSCIOUS && istype(O, /obj/item/reagent_containers/glass))
		udder.milkAnimal(O, user)
		return 1
	else
		return ..()

/mob/living/simple_animal/dancingcow/tamed()
	. = ..()
	can_buckle = TRUE
	buckle_lying = 0
	var/datum/component/riding/D = LoadComponent(/datum/component/riding)
	D.set_riding_offsets(RIDING_OFFSET_ALL, list(TEXT_NORTH = list(0, 8), TEXT_SOUTH = list(0, 8), TEXT_EAST = list(-2, 8), TEXT_WEST = list(2, 8)))
	D.set_vehicle_dir_layer(SOUTH, ABOVE_MOB_LAYER)
	D.set_vehicle_dir_layer(NORTH, OBJ_LAYER)
	D.set_vehicle_dir_layer(EAST, OBJ_LAYER)
	D.set_vehicle_dir_layer(WEST, OBJ_LAYER)
	D.drive_verb = "ride"

/mob/living/simple_animal/dancingcow/Life()
	. = ..()
	if(stat == CONSCIOUS)
		udder.generateMilk()

/mob/living/simple_animal/dancingcow/attack_hand(mob/living/carbon/M)
	if(!stat && M.a_intent == INTENT_DISARM && icon_state != icon_dead)
		M.visible_message("<span class='warning'>[M] tips over [src].</span>",
			"<span class='notice'>You tip over [src].</span>")
		to_chat(src, "<span class='userdanger'>You are tipped over by [M]!</span>")
		Paralyze(60, ignore_canstun = TRUE)
		icon_state = icon_dead
		addtimer(CALLBACK(src, .proc/cow_tipped, M), rand(20,50))

	else
		..()

/mob/living/simple_animal/dancingcow/proc/cow_tipped(mob/living/carbon/M)
	if(QDELETED(M) || stat)
		return
	icon_state = icon_living
	var/external
	var/internal
	if(prob(75))
		var/text = pick("imploringly.", "pleadingly.",
			"with a resigned expression.")
		external = "[src] looks at [M] [text]"
		internal = "You look at [M] [text]"
	else
		external = "[src] seems resigned to its fate."
		internal = "You resign yourself to your fate."
	visible_message("<span class='notice'>[external]</span>",
		"<span class='revennotice'>[internal]</span>")