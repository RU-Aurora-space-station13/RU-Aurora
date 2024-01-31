/datum/event/communications_blackout
	no_fake = 1

/datum/event/communications_blackout/announce()
	var/alert = pick(	"Внимние экипажу: Ионосферная аномалия. Свяжитесь с*%fj00)`5vc-BZZT", \
						"Внимание экипажу: Ионосферная анома*3mga;b4;'1v-BZZZT", \
						"Внимание экипажу: Ионосфер#MCi46:5.;@63-BZZZZT", \
						"Внимание экипа'fZ\\kg5_0-BZZZZZT", \
						"Вниман:% MCayj^j<.3-BZZZZZZT", \
						"#4nd%;f4y6,>%-BZZZZZZZT")

	for(var/mob/living/silicon/ai/A in GLOB.player_list)	//AIs are always aware of communication blackouts.
		if(A.z in affecting_z)
			to_chat(A, "<br>")
			to_chat(A, "<span class='warning'><b>[alert]</b></span>")
			to_chat(A, "<br>")

	if(prob(30))	//most of the time, we don't want an announcement, so as to allow AIs to fake blackouts.
		command_announcement.Announce(alert, zlevels = affecting_z)
		return
	return 1


/datum/event/communications_blackout/start()
	..()

	for(var/obj/machinery/telecomms/T in SSmachinery.all_telecomms)
		if(T.z in affecting_z)
			T.emp_act(EMP_HEAVY)
