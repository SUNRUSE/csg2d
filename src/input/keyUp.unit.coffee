describe "keyUp", ->
	rewire = require "rewire"
	keyUp = undefined
	beforeEach -> keyUp = rewire "./keyUp"
	
	describe "imports", ->
		it "gamepad", -> expect(keyUp.__get__ "gamepad").toBe require "./gamepad"
		it "keyMappings", -> expect(keyUp.__get__ "keyMappings").toBe require "./keyMappings"
	
	describe "on calling", ->
		gamepad = undefined
		beforeEach ->
			keyUp.__set__ "gamepad", gamepad = 
				keyA: false
				keyB: true
		
			keyUp.__set__ "keyMappings",
				"60": "keyA"
				"80": "keyB"
				"90": "keyC"
				"100": "keyD"
		
		describe "when no key mapping matches", ->
			beforeEach ->
				keyUp
					keyCode: 50
			it "does not change any key state", ->
				expect(gamepad).toEqual
					keyA: false
					keyB: true
				
		describe "when a key mapping matches", ->
			describe "when the key is already down", ->
				beforeEach ->
					keyUp
						keyCode: 60
				it "does not change any key state", ->
					expect(gamepad).toEqual
						keyA: false
						keyB: true
					
			describe "when the key is up", ->
				beforeEach ->
					keyUp
						keyCode: 80
				it "sets the key up", ->
					expect(gamepad).toEqual
						keyA: false
						keyB: false
					
			describe "when the key is undefined", ->
				beforeEach ->
					keyUp
						keyCode: 90
				it "sets the key up", ->
					expect(gamepad).toEqual
						keyA: false
						keyB: true
						keyC: false