/datum/event/grid_check	//NOTE: Times are measured in master controller ticks!
	announceWhen		= 5
	no_fake = 1

/datum/event/grid_check/start()
	..()

	power_failure(0, severity)

/datum/event/grid_check/announce()
	command_announcement.Announce("Внимание экипажу: Внеплановое отключение электрической сети.", "Отключение электросети", new_sound = 'sound/AI/poweroff.ogg', zlevels = affecting_z)
