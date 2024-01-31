/datum/event/gravity
	announceWhen = 5
	ic_name = "a gravity failure"
	no_fake = 1

/datum/event/gravity/setup()
	endWhen = rand(15, 60)

/datum/event/gravity/announce()
	command_announcement.Announce("Внимание экипажу: сбой в работе генератора гравитации. Осуществить ремонт немедленно.", "Сбой гравитации", zlevels = affecting_z)

/datum/event/gravity/start()
	..()

	// TO-DO: I'm not gonna touch this can of worms right now, but this effectively means that gravity is global for everyone,
	// meaning, if the horizon loses gravity, EVERYONE DOES. this seriously needs to be fixed, and i'm commenting out the gravity flux event until that is done
	GLOB.gravity_is_on = 0
	for(var/obj/machinery/gravity_generator/main/generator in SSmachinery.gravity_generators)
		if(generator.z in affecting_z)
			generator.eventshutofftoggle()
