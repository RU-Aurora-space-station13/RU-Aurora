/var/global/account_hack_attempted = 0

/datum/event/money_hacker
	var/datum/money_account/affected_account
	endWhen = 100
	var/end_time

/datum/event/money_hacker/setup()
	end_time = world.time + 6000
	if(SSeconomy.all_money_accounts.len)
		affected_account = SSeconomy.get_account(pick(SSeconomy.all_money_accounts))

		account_hack_attempted = 1
	else
		kill(TRUE)

/datum/event/money_hacker/announce()
	var/message = "Внимание экипажу: внешнее вмешательство. Зафиксирован взлом банковского аккаунта #[affected_account.account_number], \
	до отключения системы безопасности: ДЕСЯТЬ минут. Требуется вмешательство: заморозка аккаунта до окончания атаки. \
	Ожидайте дальнейших сообщений.<br>"
	var/my_department = "Брандмауэр [station_name()]"

	for(var/obj/machinery/telecomms/message_server/MS in SSmachinery.all_telecomms)
		if(!MS.use_power || !(MS.z in affecting_z))
			continue
		MS.send_rc_message("Executive Officer's Desk", my_department, message, "", "", 2)


/datum/event/money_hacker/tick()
	if(world.time >= end_time)
		endWhen = activeFor
	else
		endWhen = activeFor + 10

/datum/event/money_hacker/end(var/faked)
	..()

	var/message
	if(affected_account && !affected_account.suspended && !faked)
		//hacker wins
		message = "Внимание экипажу: Взлом удался."

		//subtract the money
		var/lost = affected_account.money * 0.8 + (rand(2,4) - 2) / 10
		affected_account.money -= lost

		//create a taunting log entry
		var/datum/transaction/T = new()
		T.target_name = pick("","дороу братишк","эль Президенто","мистер СамоСбор")
		T.purpose = pick("Не$ ---ичество ср%тв иниц*&ализац@*я","МАМОЧКЕ НУЖНЫ ДЕНЬГИ","Списание средств","трахнут","1505407","АДОМАЙ НАШ")
		T.amount = pick("","([rand(0,99999)])","маны маны мне в карманы","9001$","ЗДОРОВО РОМА ЕБАТЬ ТЕБЯ В РОТ","([lost])")
		var/date1 = "31 декабря, 1999"
		var/date2 = "[num2text(rand(1,31))] [pick("Января","Февраля","Марта","Апреля","Мая","Июня","Июля","Августа","Сентября","Октября","Ноября","Декабря")], [rand(1000,3000)]"
		T.date = pick("", worlddate2text(), date1, date2)
		var/time1 = rand(0, 99999999)
		var/time2 = "[round(time1 / 36000)+12]:[(time1 / 600 % 60) < 10 ? add_zero(time1 / 600 % 60, 1) : time1 / 600 % 60]"
		T.time = pick("", worldtime2text(), time2)
		T.source_terminal = pick("","[pick("Бизель","Новый Гибсон")] Терминал GalaxyNet #[rand(111,999)]","твоя мамка","цЫнтральное камандаванее нанотрейсен")
		SSeconomy.add_transaction_log(affected_account,T)

	else
		//crew wins
		message = "Внимание экипажу: Атака успешно отражена."

	var/my_department = "Брандмауэр [station_name()]"

	for(var/obj/machinery/telecomms/message_server/MS in SSmachinery.all_telecomms)
		if(!MS.use_power || !(MS.z in affecting_z))
			continue
		MS.send_rc_message("Executive Officer's Desk", my_department, message, "", "", 2)
