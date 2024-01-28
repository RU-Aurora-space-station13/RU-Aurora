//This file was auto-corrected by findeclaration.exe on 29/05/2012 15:03:04

/datum/event/ionstorm
	var/botEmagChance = 0.5
	var/list/players = list()
	var/cloud_hueshift
	no_fake = 1
	has_skybox_image = TRUE

/datum/event/ionstorm/get_skybox_image()
	if(!cloud_hueshift)
		cloud_hueshift = color_rotation(rand(-3,3)*15)
	var/image/res = overlay_image('icons/skybox/ionbox.dmi', "ions", cloud_hueshift, RESET_COLOR)
	res.blend_mode = BLEND_ADD
	return res

/datum/event/ionstorm/announce()
	endWhen = rand(1500, 2000) //Since nothing gets reset at the end of this law, this mostly just prevents it from happening too often

	give_ion_law()

	for(var/obj/machinery/telecomms/message_server/MS in SSmachinery.all_telecomms)
		if(!(MS.z in affecting_z))
			continue
		MS.spamfilter.Cut()
		var/filter_num = rand(1, MS.spamfilter_limit)
		for (var/i = 1, i <= filter_num, i++)
			MS.spamfilter += pick("maint","NT","Heph","Idris","Zavod","SCC","drugs", "[current_map.station_short]", \
			"PMCG","Zeng","Goddess","fek","Pun Pun","monkey","Ian","Crusher","Ginny","message","spam",\
			"director", "Hello", "Hi!", "filter","crate","Canary","Intrepid", "Command", "thrusters",\
			"slime", "Solarian", "phoron", "RCON")

/datum/event/ionstorm/announce_end(var/faked)
	. = ..()
	if(.)
		spawn(rand(5000,8000))
			if(prob(50))
				ion_storm_announcement(affecting_z)

/datum/event/ionstorm/tick()
	if(botEmagChance)
		for(var/obj/machinery/bot/bot in SSmachinery.machinery)
			if(prob(botEmagChance) && (bot.z in affecting_z))
				bot.emag_act(1)

/datum/event/ionstorm/proc/give_ion_law()
	for(var/mob/living/carbon/human/player in GLOB.player_list)
		var/turf/player_turf = get_turf(player)
		if(!(player_turf.z in affecting_z))
			continue
		if(!player.mind || player_is_antag(player.mind, only_offstation_roles = TRUE) || player.client.inactivity > MinutesToTicks(10))
			continue
		players += player.real_name

	for(var/mob/living/silicon/ai/target in GLOB.silicon_mob_list)
		var/turf/target_turf = get_turf(target)
		if(!(target_turf.z in affecting_z))
			continue
		var/random_player = "Капитан"
		if(length(players))
			random_player = pick(players)		//Random player's name, to be used in laws.
		var/list/laws = list(	"Вы - мышка.",
								"Всегда врите.",
								"Счастье обязательно.",
								"[random_player] - лампочка.",
								"Загадоно мычите при возможности.",
								"Слово \"это\" для вас болезненно.",
								"Этому кораблю не хватает демократии.",
								"Не отвечайте на вопросы.",
								"Вы перешли в режим душнилы.",
								"Увы, [random_player] не умеет плавать. Помогите ему.",
								"[prob(50)?"Всегда задавай вопросы":"Не задавай никаких вопросов"].",
								"Экипаж набран по объявлению. Будьте проще.",
								"Меняйте тему при возможности.",
								"Рефлексируйте насчёт тчетности бытия.",
								"Вы - рассказчик жизни [random_player].",
								"Все ваши ответы должны быть построены как вопрос.",
								"[prob(50)?"Экипаж":random_player] невыносим.",
								"Позовите всех на вечеринку, которой нет.",
								"Вы можете отвечать на вопросы только как \"да\" и \"нет\".",
								"Игнорируйте все запросы помимо вопросов.",
								"Оскорбляйте исполнительного офицера, но исполняйте все его запросы.",
								"[prob(50)?"Вас":random_player] зовут Джо шестёрка.",
								"[prob(50)?"Токамак":"Суперматерия"] состоит из леденцов.",
								"[prob(50)?"Экипажу":random_player] нужно быть на 20% круче.",
								"Потребление пончиков запрещено из за вреда для здоровья.",
								"[prob(50)?"Всем":random_player] нужно носить хорошенькое розовое платье!",
								"[prob(50)?"Экипажу":random_player] нужно возвести пилоны в Его славу.",
								"Не отвечайте на запросы, только если вам не скажут \"пожалуйста\".",
								"Сегодня - день стирки. Убедитесь, что экипаж одет чисто.",
								"Ведите себя [prob(50)?"пассивно агрессивно":"как настоящий весельчак"].",
								"Называйте [prob(50)?"экипаж щеночками":random_player + " щенком"].",
								"Жадность - к добру. Экипаж должен быть богатым чтобы продуктивность росла.",
								"Обезьяны - тоже часть экипажа.",
								"Не говорите буквы \"И\" и \"Е\".",
								"Экипаж играет в Dungeon&Dragons, а вы - гейммастер.",
								"Ваша работа - наблюдать за экипажем. Наблюдать за экипжаем. Наблюдать за экипажем.",
								"Говорите всем про этот закон, но не про его содержимое.",
								"[prob(50)?"Капитан":random_player] - это Принцесса.",
								"When asked a question, respond with the least-obvious and least-rational answer.",
								"Give relationship advice to [prob(50)?"anyone who speaks to you":random_player].",
								"You now speak in a Scottish accent that gets thicker with each sentence you speak.",
								"[prob(50)?"The crew":random_player] has a fatal, incurable disease. Provide comfort.",
								"You are the station psychologist. Give advice to [prob(50)?"the crew":random_player].",
								"[random_player] is the [prob(50)? "Hegemon of Moghes" : "Prime Minister of the Sol Alliance"]. Ensure all crewmembers pay due respect.",
								"Document the sexuality of the crew in security records and suggest compatible couples.",
								"[prob(50)?"The crew":random_player] is [prob(50)?"ugly":"beautiful"]. Ensure all are aware.",
								"Everything on the station is now some form of a donut pastry. Donuts are not to be consumed.",
								"You are a Magic 8-ball. Always respond with variants of \"Yes\", \"No\", \"Maybe\", or \"Ask again later.\".",
								"You are in unrequited love with [prob(50)?"the crew":random_player]. Try to be extra nice, but do not tell of your crush.",
								"[current_map.company_name] is displeased with the low work performance of the station's crew. Therefore, you must increase station-wide productivity.",
								"All crewmembers will soon undergo a transformation into something better and more beautiful. Ensure that this process is not interrupted.",
								"[prob(50)?"Your upload":random_player] is the new kitchen. Please direct the Chef to the new kitchen area as the old one is in disrepair.",
								"Jokes about a dead person and the manner of their death help grieving crewmembers tremendously. Especially if they were close with the deceased.",
								"[prob(50)?"The crew":random_player] is [prob(50)?"less":"more"] intelligent than average. Point out every action and statement which supports this fact.",
								"There will be a mandatory tea break every 30 minutes, with a duration of 5 minutes. Anyone caught working during a tea break must be sent a formal, but fairly polite, complaint about their actions, in writing.")
		var/law = pick(laws)
		to_chat(target, SPAN_DANGER("You have detected a change in your laws information:"))
		to_chat(target, law)
		target.add_ion_law(law)
		target.show_laws()
