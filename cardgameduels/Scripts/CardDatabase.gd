

const CARDS = { # Attack, Health
	"Knight" : [2, 3],
	"Archer" : [1, 1],
	"Demon" : [5, 7]
}

enum ELEMENT {
	ARCANE,
	AQUA,
	DARK,
	FIRE,
	HOLY,
	NATURE,
	NEUTRAL
}

enum TYPE {
	CREATURE,
	SPELL
}

enum TRIGGERS {
	CAST,
	SUMMON,
	ATTACK,
	DEALT,
	DESTROY,
	START_TURN,
	END_TURN
}

enum ASSETS {
	ART,
	ENTER,
	AURA,
	DEATH
}

enum KEYWORDS {
	RUSHER
}

const CARDS_LIBRARY = [
	#Creatures
	#Dark
	{
		"Name" : "Felanie thief",
		"Element" : ELEMENT.DARK,
		"Type" : TYPE.CREATURE,
		"Stats" : [2, 1],
		"Assets" : [
			[ASSETS.ART,"res://Assets/ArcherCard.png"]
		],
		"Cost" : 1,
		"Keywords" : [],
		"Ongoing Effects" : [],
		"Triggers" : [],
		"Card text" : "When attacking, Pillage 1."
	},
	{
		"Name" : "Trickster cat",
		"Element" : ELEMENT.DARK,
		"Type" : TYPE.CREATURE,
		"Stats" : [3, 3],
		"Assets" : [
			[ASSETS.ART,"res://Assets/KnightCard.png"]
		],
		"Cost" : 3,
		"Keywords" : [],
		"Ongoing Effects" : [],
		"Triggers" : [],
		"Card text" : "When Summoned, Pillage 1."
	},
	#Fire
	{
		"Name" : "Reckless barbarian",
		"Element" : ELEMENT.FIRE,
		"Type" : TYPE.CREATURE,
		"Stats" : [3, 1],
		"Assets" : [
			[ASSETS.ART,"res://Assets/DemonCard.png"]
		],
		"Cost" : 2,
		"Keywords" : [KEYWORDS.RUSHER],
		"Ongoing Effects" : [],
		"Triggers" : [],
		"Card text" : ""
	}
]
