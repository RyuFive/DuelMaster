extends Node


const civ  = [
		"Gladiator",
		"Armorloid"
	  ]
 
const monster = {
	  "civilizations": [
		"Light"
	  ],
	  "cost": 7,
	  "name": "Alek, Solidity Enforcer",
	  "power": "4000+",
	  "printings": [
		{
		  "set": "DM-03 Rampage of the Super Warriors",
		  "id": "1/55",
		  "rarity": "Rare",
		  "illustrator": "Takesi Kuno",
		  "flavor": "\"Hey, you! Get solid!\""
		}
	  ],
	  "subtypes": [
		"Berserker"
	  ],
	  "text": "Blocker (Whenever an opponent's creature attacks, you may tap this creature to stop the attack. Then the 2 creatures battle.)\nThis creature gets +1000 power for each other light creature you have in the battle zone.",
	  "type": "Creature"
	}

func _ready():
#	int(rand_range(1,10)*100000000)
#	print('Fire' in civ.civilizations)
#	yield(sum(), "completed") # waiting for the countdown() function to complete
#	print(randi() % 2)
#	print("Gladiator" in civ)
#	print('Ready')
	print(self.name)
	$Node2.testFunc()

	pass

func sum():
	yield(get_tree().create_timer(0.001), "timeout")
	print('c')
	return self

func merge_array(array_1: Array, array_2: Array, deep_merge: bool = false) -> Array:
	var new_array = array_1.duplicate(true)
	var compare_array = new_array
	var item_exists

	if deep_merge:
		compare_array = []
		for item in new_array:
			if item is Dictionary or item is Array:
				compare_array.append(JSON.print(item))
			else:
				compare_array.append(item)

	for item in array_2:
		item_exists = item
		if item is Dictionary or item is Array:
			item = item.duplicate(true)
			if deep_merge:
				item_exists = JSON.print(item)

		if not item_exists in compare_array:
			new_array.append(item)
	return new_array

func merge_dict(dict_1: Dictionary, dict_2: Dictionary, deep_merge: bool = false) -> Dictionary:
	var new_dict = dict_1.duplicate(true)
	for key in dict_2:
		if key in new_dict:
			if deep_merge and dict_1[key] is Dictionary and dict_2[key] is Dictionary:
				new_dict[key] = merge_dict(dict_1[key], dict_2[key])
			elif deep_merge and dict_1[key] is Array and dict_2[key] is Array:
				new_dict[key] = merge_array(dict_1[key], dict_2[key])
			else:
				new_dict[key] = dict_2[key]
		else:
			new_dict[key] = dict_2[key]
	return new_dict
