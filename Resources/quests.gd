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
			"task_name": "Defeat ALL the Monsters",
			"progress": 0,
			"goal": 5,
			"type": "kill",
			"target": "English"
		}
	},
	"completed": false,
	"type": "main"
	},
"2": {
	"name": "Defeat Enemies",
	"tasks": {
		"0": {
			"task_name": "Defeat 10 Enemies.",
			"progress": 0,
			"goal": 10,
			"type": "talk",
			"target": "English"
		},
	},
	"completed": false,
	"type": "main"
	},
}
