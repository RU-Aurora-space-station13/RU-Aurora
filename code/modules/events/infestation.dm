#define INFESTATION_RATS "крысы"
#define INFESTATION_LIZARDS "ящерицы"
#define INFESTATION_SPACE_BATS "космические летучие мыши"
#define INFESTATION_SPIDERLINGS "личинки греморианов"
#define INFESTATION_HIVEBOTS "хайвботы"
#define INFESTATION_SLIMES "слизни"

/datum/event/infestation
	startWhen = 1
	announceWhen = 10
	endWhen = 11
	no_fake = 1
	var/area/chosen_area
	var/event_name = "Слизни"
	var/chosen_mob = INFESTATION_SLIMES
	var/chosen_verb = "слизни проскользнули в"
	var/list/chosen_mob_types = list()
	var/chosen_scan_type = "биологические сенсоры"
	var/list/possible_mobs = list(
		INFESTATION_RATS = 1,
		INFESTATION_LIZARDS = 1
	)

/datum/event/infestation/moderate
	possible_mobs = list(
		INFESTATION_SPACE_BATS = 1,
		INFESTATION_SPIDERLINGS = 1
	)

/datum/event/infestation/major/setup()
	var/player_count = 0
	var/armory_access = FALSE
	for(var/mob/living/carbon/human/H in GLOB.living_mob_list)
		if(H.stat == CONSCIOUS && H.client)
			player_count++
			if(H.mind.assigned_role in armory_positions)
				armory_access = TRUE
	if((player_count >= 15) && armory_access)
		possible_mobs = list(
			INFESTATION_HIVEBOTS = 1,
			INFESTATION_SLIMES = 1
		)
	else
		possible_mobs = list(
			INFESTATION_SLIMES = 1
		)
	..()

/datum/event/infestation/setup()
	choose_area()
	choose_mobs()

/datum/event/infestation/start()
	..()

	spawn_mobs()

/datum/event/infestation/proc/choose_area()
	chosen_area = random_station_area(TRUE)

/datum/event/infestation/proc/choose_mobs()

	chosen_mob = pickweight(possible_mobs)

	switch(chosen_mob)
		if(INFESTATION_HIVEBOTS)
			event_name = "Нашествие хайвботов"
			chosen_verb = "проникли в"
			chosen_scan_type = "блюспейс показания"
			var/list/beacon_types = list(
				/mob/living/simple_animal/hostile/hivebotbeacon = 1,
				/mob/living/simple_animal/hostile/hivebotbeacon/incendiary = 1
			)
			chosen_mob_types += pickweight(beacon_types)

		if(INFESTATION_SPACE_BATS)
			event_name = "Гнездо космических летучих мышей"
			chosen_verb = "завелись в"
			for(var/i = 1, i < rand(3,5),i++)
				chosen_mob_types += /mob/living/simple_animal/hostile/scarybat

		if(INFESTATION_LIZARDS)
			event_name = "Логово ящериц"
			chosen_verb = "расплодились в"
			for(var/i = 1, i < rand(6,8),i++)
				chosen_mob_types += /mob/living/simple_animal/lizard

		if(INFESTATION_RATS)
			event_name = "Логово крыс"
			chosen_verb = "расплодились в"
			var/list/rat_breeds = list(
				/mob/living/simple_animal/rat/gray = 4,
				/mob/living/simple_animal/rat/brown = 2,
				/mob/living/simple_animal/rat/white = 3,
				/mob/living/simple_animal/rat/hooded = 1,
				/mob/living/simple_animal/rat/irish = 2,
			)
			for(var/i = 1, i < rand(8,24),i++)
				chosen_mob_types += pickweight(rat_breeds)

		if(INFESTATION_SLIMES)
			event_name = "Нарушение условий содержания"
			chosen_verb = "проникли в"
			var/list/slime_types = list(
				/mob/living/carbon/slime,
				/mob/living/carbon/slime/purple,
				/mob/living/carbon/slime/metal,
				/mob/living/carbon/slime/orange,
				/mob/living/carbon/slime/blue,
				/mob/living/carbon/slime/dark_blue,
				/mob/living/carbon/slime/dark_purple,
				/mob/living/carbon/slime/yellow,
				/mob/living/carbon/slime/silver,
				/mob/living/carbon/slime/pink,
				/mob/living/carbon/slime/red,
				/mob/living/carbon/slime/green,
				/mob/living/carbon/slime/oil
			)
			var/chosen_slime_type = pick(slime_types)
			for(var/i = 1, i < rand(5,8),i++)
				chosen_mob_types += chosen_slime_type

		if(INFESTATION_SPIDERLINGS)
			event_name = "Нашествие грейморианов"
			chosen_verb = "зарылись в"
			for(var/i = 1, i < rand(3,6),i++)
				chosen_mob_types += /obj/effect/spider/spiderling
			chosen_mob_types += /obj/effect/spider/eggcluster

/datum/event/infestation/proc/spawn_mobs()
	for(var/spawned_mob in chosen_mob_types)
		new spawned_mob(chosen_area.random_space())

/datum/event/infestation/announce()
	command_announcement.Announce("Внимание экипажу: [chosen_scan_type] указывают, что [chosen_mob] [chosen_verb] [chosen_area]. Нейтрализовать угрозу.", event_name, new_sound = 'sound/AI/vermin.ogg', zlevels = affecting_z)


#undef INFESTATION_RATS
#undef INFESTATION_LIZARDS
#undef INFESTATION_SPACE_BATS
#undef INFESTATION_SPIDERLINGS
#undef INFESTATION_HIVEBOTS
#undef INFESTATION_SLIMES
