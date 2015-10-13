describe "operator", ->
	rewire = require "rewire"
	operator = undefined
	beforeEach ->
		operator = rewire "./operator"
		
	describe "imports", ->
		it "history", ->
			expect(operator.__get__ "history").toBe require "./history"
			
	describe "on calling", ->
		current = history = undefined
		beforeEach ->
			history = 
				addStep: jasmine.createSpy "addStep"
			operator.__set__ "history", history
		go = ->
			operator
				getAttribute: (name) ->
					expect(name).toEqual "operator"
					current
				setAttribute: (name, value) ->
					expect(name).toEqual "operator"
					current = value
					undefined
		describe "when the operator is \"add\"", ->
			beforeEach ->
				current = "add"
				go()
			it "changes the operator to \"subtract\"", ->
				expect(current).toEqual "subtract"
			it "adds a history step", ->
				expect(history.addStep).toHaveBeenCalledWith (jasmine.any Function), (jasmine.any Function), (jasmine.any Function)
				expect(history.addStep.calls.count()).toEqual 1
			describe "on discarding", ->
				beforeEach ->
					(history.addStep.calls.argsFor 0)[2]()
				it "does nothing", ->
					expect(current).toEqual "subtract"
			describe "on undoing", ->
				beforeEach ->
					(history.addStep.calls.argsFor 0)[0]()
				it "restores the operator to \"add\"", ->
					expect(current).toEqual "add"
				describe "on discarding", ->
					beforeEach ->
						(history.addStep.calls.argsFor 0)[2]()
					it "does nothing", ->
						expect(current).toEqual "add"
				describe "on redoing", ->
					beforeEach ->
						(history.addStep.calls.argsFor 0)[1]()
					it "restores the operator to \"subtract\"", ->
						expect(current).toEqual "subtract"
						
		describe "when the operator is \"subtract\"", ->
			beforeEach ->
				current = "subtract"
				go()
			it "changes the operator to \"add\"", ->
				expect(current).toEqual "add"
			it "adds a history step", ->
				expect(history.addStep).toHaveBeenCalledWith (jasmine.any Function), (jasmine.any Function), (jasmine.any Function)
				expect(history.addStep.calls.count()).toEqual 1
			describe "on discarding", ->
				beforeEach ->
					(history.addStep.calls.argsFor 0)[2]()
				it "does nothing", ->
					expect(current).toEqual "add"
			describe "on undoing", ->
				beforeEach ->
					(history.addStep.calls.argsFor 0)[0]()
				it "restores the operator to \"add\"", ->
					expect(current).toEqual "subtract"
				describe "on discarding", ->
					beforeEach ->
						(history.addStep.calls.argsFor 0)[2]()
					it "does nothing", ->
						expect(current).toEqual "subtract"
				describe "on redoing", ->
					beforeEach ->
						(history.addStep.calls.argsFor 0)[1]()
					it "restores the operator to \"add\"", ->
						expect(current).toEqual "add"