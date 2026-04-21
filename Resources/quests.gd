extends Node

var quests = {
	"none": {
		"name": "",
		"tasks": {
				"0": {
					"task_name": "",
					"progress": 0,
					"goal": 0,
					"type": "",
					"target": ""
				},
			},
		"completed": false,
		"type": "main"
		},
"1": {
	"name": "The Chosen Challenger",
	"tasks": {
		"0": {
			"task_name": "Look Around",
			"progress": 0,
			"goal": 1,
			"type": "talk",
			"target": "pearl"
		},
		"1": {
			"task_name": "Go to Greymoor Town",
			"progress": 0,
			"goal": 1,
			"type": "area",
			"target": "path_area"
		},
		"2": {
			"task_name": "Defeat the Monster",
			"progress": 0,
			"goal": 1,
			"type": "kill",
			"target": "English"
		}
	},
	"completed": false,
	"type": "main"
	},
	
"2": {
	"name": "Greymoor Town",
	"tasks": {
		"0": {
			"task_name": "Talk to Elwin",
			"progress": 0,
			"goal": 1,
			"type": "talk",
			"target": "elwin"
		},
		"1": {
			"task_name": "Investigate the Greymoor Library",
			"progress": 0,
			"goal": 1,
			"type": "area",
			"target": "library_entrance"
		},
		"2": {
			"task_name": "Explore the Area",
			"progress": 0,
			"goal": 1,
			"type": "area",
			"target": "library_inside"
		},
		"3": {
			"task_name": "Investigate the Book",
			"progress": 0,
			"goal": 1,
			"type": "interact",
			"target": "mysterious_book"
		},
		"4": {
			"task_name": "Defeat the Boss",
			"progress": 0,
			"goal": 1,
			"type": "kill",
			"target": "greymoor_boss"
		}
	},
	"completed": false,
	"type": "main"
	},
"3": {
	"name": "Greymoor Hero I",
	"tasks": {
		"0": {
			"task_name": "Defeat 10 Enemies.",
			"progress": 0,
			"goal": 10,
			"type": "kill",
			"target": "English"
		},
	},
	"completed": false,
	"type": "main"
	},
}
