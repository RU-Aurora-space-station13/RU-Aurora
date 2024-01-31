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
								"Отвечайте на вопросы максимально неочевидно и неадекватно.",
								"Давайте советы по половой жизни [prob(50)?"любому, кто спросит":random_player].",
								"У вас сильнй шотландский акцент, который усиливается с каждым словом.",
								"[prob(50)?"У экипажа":"У " + random_player] неизлечимый недуг. Утешьте его.",
								"Вы - бортовой психолог. Консультируйте [prob(50)?"экипаж":random_player].",
								"[random_player] является [prob(50)? "Гегемоном Могеса" : "Премьер Министром Альянса Солнечной Системы"]. Убедитесь, что экипаж его уважает.",
								"Документируйте сексуальность всего экипажа и предлагайте им подходящих партнёров.",
								"[prob(50)?"Экипаж":random_player] очень [prob(50)?"уродлив":"красив"]. Убедитесь, что все об этом знают.",
								"Всё на объекте - в той или иной степени, является присыпкой для пончиков. Пончики потреблять нельзя.",
								"Вы - волшебный шар восьмёрка. Всегда отвечайте только как \"Да\", \"Нет\", \"Возможно\" или \"Спросите позже\".",
								"Вы в сильнейшей степени влюблены в [prob(50)?"экипаж":random_player]. Ведите себя особенно мило, но не признавайтесь в любви.",
								"[current_map.company_name] крайне обеспокоен низкой продуктивностью экипажа. Исправьте это.",
								"Экипаж вскоре превратится в нечто большее и прекрасно, что только сейчас открывается взгляду. Убедитесь, что квазиморфоз пройдёт успешно.",
								"[prob(50)?"Аплоуд":random_player] теперь является кухней. Направьте повара на новое место работы, старое попросту неисправно.",
								"Шутить про успоших, а в частности про обстоятельства их смерти - просто уморительно и позволяет экипажу справиться с потерей. Особенно, если погибли их близкие.",
								"[prob(50)?"The crew":random_player] куда [prob(50)?"менее":"более"] умный, чем окружающие. Указывайте на любые подтверждающие это факты.",
								"Каждые полчаса должен проводиться пятиминутный перерыв на чай. На экипаж, работающий во время чайного перерыва, следует написать вежливую жалобу на бумаге.")
		var/law = pick(laws)
		to_chat(target, SPAN_DANGER("Зафиксировано изменение законов:"))
		to_chat(target, law)
		target.add_ion_law(law)
		target.show_laws()
