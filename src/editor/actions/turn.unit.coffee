describe "turn", ->
	rewire = require "rewire"
	turn = undefined
	beforeEach ->
		turn = rewire "./turn"
		
	describe "imports", ->
		it "history", ->
			expect(turn.__get__ "history").toBe require "./history"
			
	describe "on calling", ->
		current = history = undefined
		beforeEach ->
			history = 
				addStep: jasmine.createSpy "addStep"
			turn.__set__ "history", history
		go = ->
			turn
				getAttribute: (name) ->
					expect(name).toEqual "position"
					current
				setAttribute: (name, value) ->
					expect(name).toEqual "position"
					current = value
					undefined
		describe "when the position is \"topLeft\"", ->
			beforeEach ->
				current = "topLeft"
				go()
			it "changes the position to \"topRight\"", ->
				expect(current).toEqual "topRight"
			it "adds a history step", ->
				expect(history.addStep).toHaveBeenCalledWith (jasmine.any Function), (jasmine.any Function), (jasmine.any Function)
				expect(history.addStep.calls.count()).toEqual 1
			describe "on discarding", ->
				beforeEach ->
					(history.addStep.calls.argsFor 0)[2]()
				it "does nothing", ->
					expect(current).toEqual "topRight"
			describe "on undoing", ->
				beforeEach ->
					(history.addStep.calls.argsFor 0)[0]()
				it "restores the position to \"topLeft\"", ->
					expect(current).toEqual "topLeft"
				describe "on discarding", ->
					beforeEach ->
						(history.addStep.calls.argsFor 0)[2]()
					it "does nothing", ->
						expect(current).toEqual "topLeft"
				describe "on redoing", ->
					beforeEach ->
						(history.addStep.calls.argsFor 0)[1]()
					it "restores the position to \"topRight\"", ->
						expect(current).toEqual "topRight"