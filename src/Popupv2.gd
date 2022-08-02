extends Node2D

enum PopupIds {
	SUMMON = 100
	CAST
	ATTACK
	MANA
	SHIELD
	PLAYER
	EVOLVE
	MONSTER1
	MONSTER2
	MONSTER3
	MONSTER4
	MONSTER5
	EVOLVE1
	EVOLVE2
	EVOLVE3
	EVOLVE4
	EVOLVE5
}
const monsters = [PopupIds.MONSTER1, PopupIds.MONSTER2, PopupIds.MONSTER3, PopupIds.MONSTER4, PopupIds.MONSTER5]
const evolutions = [PopupIds.EVOLVE1, PopupIds.EVOLVE2, PopupIds.EVOLVE3, PopupIds.EVOLVE4, PopupIds.EVOLVE5]

onready var root = get_node("/root/Playspace")
onready var shield2 = get_node("/root/Playspace/Shield2/Shield")
onready var mana = get_node("/root/Playspace/Mana1/Mana")
onready var monster = get_node("/root/Playspace/Monster1/Cards")
onready var monster2 = get_node("/root/Playspace/Monster2/Cards")
onready var coms = get_node("/root/Playspace/Coms")
onready var menu = $PopupMenu

var card
var last_mouse_position
var stage = 1

func _ready():
	last_mouse_position = get_global_mouse_position()
	var source = str(get_node('../../'))
	var category = card.cardData.type
	var cost = card.cardData.cost
	var manaCount = 0
	var manaValid
	for civ in card.cardData.civilizations:
		if mana.get_parent().manaCivs[civ]:
			manaValid = true
			break
	
	for tempCard in mana.get_children():
		if !tempCard.cardData['tapped']:
			manaCount += 1
	
	if stage == 1:
		if 'Monster' in source and !card.cardData['sickness']:
			menu.add_item("Attack", PopupIds.ATTACK)
		elif category == 'Spell' and 'Hand' in source and !root.attackStarted:
			if !root.manaPerTurn:
				menu.add_item("Add to Mana", PopupIds.MANA)
			if manaCount >= cost and manaValid:
				menu.add_item("Cast Spell", PopupIds.CAST)
		elif category == 'Creature' and 'Hand' in source and !root.attackStarted:
			if !root.manaPerTurn:
				menu.add_item("Add to Mana", PopupIds.MANA)
			if card.cardData.has('supertypes') and card.cardData.supertypes[0] == "Evolution":
				var evolutionValid = false
				for tempMonster in monster.get_children():
					for subtypemonster in tempMonster.cardData.subtypes:
						for subtypeevolution in card.cardData.subtypes:
							if subtypeevolution == subtypemonster:
								evolutionValid = true
								menu.add_item("Evolve Creature", PopupIds.EVOLVE)
								break
						if evolutionValid:
							break
					if evolutionValid:
						break
			elif monster.get_child_count() < 5 and manaCount >= cost and manaValid and !root.attackStarted:
				menu.add_item("Summon Creature", PopupIds.SUMMON)
	elif stage == 2:
		if shield2.get_child_count() >= 1:
			menu.add_item("Shield", PopupIds.SHIELD)
		else:
			menu.add_item("Player", PopupIds.PLAYER)
		var i = 0
		for mon in monster2.get_children():
			if mon.cardData['tapped']:
				menu.add_item(mon.cardName, monsters[i])
			i += 1
	elif stage == 3:
		var i = 0
		for tempMonster in monster.get_children():
			for subtypemonster in tempMonster.cardData.subtypes:
				for subtypeevolution in card.cardData.subtypes:
					if subtypeevolution == subtypemonster:
						menu.add_item(tempMonster.cardName, evolutions[i])
			i += 1
	
	var outOfBoundsCheck = last_mouse_position.y + menu.rect_size.y
	if outOfBoundsCheck >= 1080:
		last_mouse_position.y -= outOfBoundsCheck - 1080
	if menu.get_item_count() > 0:
		menu.popup(Rect2(last_mouse_position.x, last_mouse_position.y, menu.rect_size.x, menu.rect_size.y))

func _on_PopupMenu_id_pressed(id):
	match id: # 100,101,102...
		PopupIds.SUMMON:
			root.hand2monster(card)
			root.tapmana(card)
		PopupIds.CAST:
			root.hand2grave(card)
			root.tapmana(card)
		PopupIds.ATTACK:
			var temp = instance()
			temp.stage = 2
			temp.card = card
			temp.last_mouse_position = last_mouse_position
			self.get_parent().add_child(temp)
		PopupIds.MANA:
			root.hand2mana(card)
		PopupIds.SHIELD:
			root.attackStarted = true
			root.shieldbreak(card)
			tap(card)
		PopupIds.PLAYER:
			get_tree().quit()
		PopupIds.EVOLVE:
			var temp = instance()
			temp.stage1 = 3
			temp.card = card
			temp.last_mouse_position = last_mouse_position
			self.get_parent().add_child(temp)
		PopupIds.MONSTER1:
			root.attackStarted = true
			root.fight(card, monster2.get_child(0))
			tap(card)
		PopupIds.MONSTER2:
			root.attackStarted = true
			root.fight(card, monster2.get_child(1))
			tap(card)
		PopupIds.MONSTER3:
			root.attackStarted = true
			root.fight(card, monster2.get_child(2))
			tap(card)
		PopupIds.MONSTER4:
			root.attackStarted = true
			root.fight(card, monster2.get_child(3))
			tap(card)
		PopupIds.MONSTER5:
			root.attackStarted = true
			root.fight(card, monster2.get_child(4))
			tap(card)
		PopupIds.EVOLVE1:
			root.evolve(card, monster.get_child(0))
		PopupIds.EVOLVE2:
			root.evolve(card, monster.get_child(1))
		PopupIds.EVOLVE3:
			root.evolve(card, monster.get_child(2))
		PopupIds.EVOLVE4:
			root.evolve(card, monster.get_child(3))
		PopupIds.EVOLVE5:
			root.evolve(card, monster.get_child(4))

func tap(tempCard):
	tempCard.cardData['tapped'] = true
	tempCard.rect_rotation = 90

func instance() -> Node:
	# Nodes have a `filename` property. Scene root nodes have this
	# set to the path of the scene file from which they were instantiated.
	var scn := load(filename) as PackedScene
	if not scn:
		push_error("There were problems loading the scene again.")
	return scn.instance()
