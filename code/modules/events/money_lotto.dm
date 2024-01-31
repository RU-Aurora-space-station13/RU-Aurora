/datum/event/money_lotto
	var/winner_name = "John Smith"
	var/winner_sum = 0
	var/deposit_success = 0

/datum/event/money_lotto/start()
	..()

	winner_sum = pick(1, 50, 100, 500, 1000, 2000, 5000)
	if(SSeconomy.all_money_accounts.len)
		var/datum/money_account/D = SSeconomy.get_account(pick(SSeconomy.all_money_accounts))
		winner_name = D.owner_name
		if(!D.suspended)
			D.money += winner_sum

			var/datum/transaction/T = new()
			T.target_name = "-Космолото- Тау Киты: ЕЖЕДНЕВНЫЕ РОЗЫГРЫШЫ"
			T.purpose = "Победа!"
			T.amount = winner_sum
			T.date = worlddate2text()
			T.time = worldtime2text()
			T.source_terminal = "TCD Терминал Бизеля #[rand(111,333)]"
			SSeconomy.add_transaction_log(D,T)

			deposit_success = 1

/datum/event/money_lotto/announce()
	var/author = "Редактор [current_map.company_name]"
	var/channel = "Tau Ceti Daily"

	var/body = "Tau Ceti Daily поздравляет <b>[winner_name]</b> с победой в космолото Тау Киты, ваш выигрыш составляет целых [winner_sum] кредитов!"
	if(!deposit_success)
		body += "<br>К сожалению, нам не удалось подтвердить ваши банковские данные, из за чего перевод не состоялся. Отправьте чек на сумму в 5000 тысяч кредит на ООО 'Космолото' с обновлённой платёжной информации, и Ваш выигрыш будет отправлен в течении месяца."
	var/datum/feed_channel/ch =  SSnews.GetFeedChannel(channel)
	SSnews.SubmitArticle(body, author, ch, null, 1)
