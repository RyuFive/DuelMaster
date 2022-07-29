extends Node2D

enum PopupIds {
	SUMMON = 100
	CAST
	ATTACK
	MANA
	SHIELD
	PLAYER
	MONSTER1
	MONSTER2
	MONSTER3
	MONSTER4
	MONSTER5
}

onready var root = get_node("/root/Playspace")
onready var shield = get_node("/root/Playspace/Shield2/Shield")
onready var monster = get_node("/root/Playspace/Monster1/Cards")
onready var monster2 = get_node("/root/Playspace/Monster2/Cards")
onready var menu = $PopupMenu

var card
var monster_target
var last_mouse_position
var stage1 = true
var monsters = [PopupIds.MONSTER1, PopupIds.MONSTER2, PopupIds.MONSTER3, PopupIds.MONSTER4, PopupIds.MONSTER5]

func _ready():
	last_mouse_position = get_global_mouse_position()
	var source = str(get_node('../../'))
	var type = card.cardData.type
	
	if stage1:
		if 'Monster' in source:
			menu.add_item("Attack", PopupIds.ATTACK)
		elif type == 'Spell' and 'Hand' in source:
			menu.add_item("Add to Mana", PopupIds.MANA)
			menu.add_item("Cast Spell", PopupIds.CAST)
		elif type == 'Creature' and 'Hand' in source:
			menu.add_item("Add to Mana", PopupIds.MANA)
			if monster.get_child_count() < 5:
				menu.add_item("Summon Creature", PopupIds.SUMMON)
	else:
		if shield.get_child_count() >= 1:
			menu.add_item("Shield", PopupIds.SHIELD)
		else:
			menu.add_item("Player", PopupIds.PLAYER)
		var i = 0
		for mon in monster2.get_children():
			menu.add_item(mon.cardName, monsters[i])
			i += 1
	menu.popup(Rect2(last_mouse_position.x, last_mouse_position.y, menu.rect_size.x, menu.rect_size.y))

func _on_PopupMenu_id_pressed(id):
	match id:# 100,101,102...
		PopupIds.SUMMON:
			root.hand2monster(card)
		PopupIds.CAST:
			root.hand2grave(card)
		PopupIds.ATTACK:
			var temp = instance()
			temp.stage1 = false
			temp.card = card
			self.get_parent().add_child(temp)
		PopupIds.MANA:
			root.hand2mana(card)
		PopupIds.SHIELD:
			pass
		PopupIds.PLAYER:
			pass
		PopupIds.MONSTER1:
			fight(card, monster2.get_child(0))
		PopupIds.MONSTER2:
			fight(card, monster2.get_child(1))
		PopupIds.MONSTER3:
			fight(card, monster2.get_child(2))
		PopupIds.MONSTER4:
			fight(card, monster2.get_child(3))
		PopupIds.MONSTER5:
			fight(card, monster2.get_child(4))

func fight(one, two):
	var green = one.cardData.power
	var red = two.cardData.power
	if green > red:
		two.free()
	elif green < red:
		root.monster2grave(one)
	elif green == red:
		root.monster2grave(one)
		two.free()

func instance() -> Node:
	# Nodes have a `filename` property. Scene root nodes have this
	# set to the path of the scene file from which they were instantiated.
	var scn := load(filename) as PackedScene
	if not scn:
		push_error("There were problems loading the scene again.")
	return scn.instance()
