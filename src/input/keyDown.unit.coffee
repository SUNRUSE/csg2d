describe "keyDown", ->
	rewire = require "rewire"
	keyDown = undefined
	beforeEach -> keyDown = rewire "./keyDown"
	
	describe "imports", ->
		it "gamepad", -> expect(keyDown.__get__ "gamepad").toBe require "./gamepad"
		it "keyMappings", -> expect(keyDown.__get__ "keyMappings").toBe require "./keyMappings"
	
	describe "on calling", ->
		gamepad = undefined
		beforeEach ->
			keyDown.__set__ "gamepad", gamepad = 
				keyA: false
				keyB: true
		
			keyDown.__set__ "keyMappings",
				"60": "keyA"
				"80": "keyB"
				"90": "keyC"
				"100": "keyD"
		
		describe "when no key mapping matches", ->
			beforeEach ->
				keyDown
					keyCode: 50
			it "does not change any key state", ->
				expect(gamepad).toEqual
					keyA: false
					keyB: true
				
		describe "when a key mapping matches", ->
			describe "when the key is already down", ->
				beforeEach ->
					keyDown
						keyCode: 80
				it "does not change any key state", ->
					expect(gamepad).toEqual
						keyA: false
						keyB: true
					
			describe "when the key is up", ->
				beforeEach ->
					keyDown
						keyCode: 60
				it "sets the key down", ->
					expect(gamepad).toEqual
						keyA: true
						keyB: true
					
			describe "when the key is undefined", ->
				beforeEach ->
					keyDown
						keyCode: 90
				it "sets the key down", ->
					expect(gamepad).toEqual
						keyA: false
						keyB: true
						keyC: true