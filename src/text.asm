SECTION "Text", ROMX[$7D00], BANK[1]

gameOverText::
	db "GAME  OVER"
gameOverTextEnd::
retry::
	db "START  RETRY"
retryEnd::
menu::
	db "SELECT MENU"
menuEnd::
pressStart::
	db "PRESS  START"
pressStartEnd::
nantes::
	db "NANTES"
nantesEnd::
creditsText::
	db "CREDITS"
creditsTextEnd::
creditTextArray::
	db "ORIGINAL IDEA", 0
	db "ANDGEL HALLEY", 0
	db "TRISTAN ROUX", 0
	db "CLEMENT LE BIHAN", 0
	db "MARCANTOINE WITTLING", 0
	db "JONATHAN MARTIN", 0
	db "ETIENNE BERTRAND", 0, 0

	db "ASSEMBLY", 0
	db "ANDGEL HALLEY", 0
	db "TRISTAN ROUX", 0
	db "CLEMENT LE BIHAN", 0, 0

	db "MUSIC", 0
	db "JONATHAN MARTIN", 0, 0

	db "GRAPHICS AND FONT", 0
	db "MARCANTOINE WITTLING", 0, 0

	db "HARDWARE", 0
	db "ETIENNE BERTRAND", 0
	db "ANDGEL HALLEY", 0
	db "JEREMY ANDREY", 0, 0

	db "LORE WARDEN", 0
	db "MARCANTOINE WITTLING", 0, 0

	db "SPECIAL THANKS", 0
	db "COFFEE MACHINE", 0
	db "TAN TRAM SCHEDULES", 0
	db "EPIDOOR", 0
	db "KEBAB COOK", 0
	db "CLEMENT'S SWITCH", 0
	db "OLD SCART TV", 0
	db "IONIS INTERNET", 0, 0

	db "SPECIAL THANKS", 0
	db "OTHER TEK3 GROUPS", 0
	db "EDF", 0
	db "THE SAILING SHIP", 0
	db "TABLES AND CHAIRS", 0
	db "THE WHITEBOARD", 0
	db "EEPROM", 0
	db "OUR BIG COMMUNITY", 0, 0
creditTextArrayEnd::
