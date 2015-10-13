describe "delete", ->
	rewire = require "rewire"
	_delete = undefined
	
	beforeEach ->
		_delete = rewire "./delete"
	
	describe "imports", ->
		it "history", -> expect(_delete.__get__ "history").toBe require "./history"
	
	describe "on calling", ->
		history = present = nextElementSibling = go = undefined
		beforeEach ->
			nextElementSibling = null
			present = true
			
			history =
				addStep: jasmine.createSpy "addStep"
			_delete.__set__ "history", history
			
			go = ->
				element = 
					nextElementSibling: nextElementSibling
					parentNode:
						removeChild: (el) ->
							expect(el).toBe element
							present = false
						appendChild: (el) ->
							expect(el).toBe element
							expect(nextElementSibling).toBeNull()
							present = true
						insertBefore: (el, before) ->
							expect(el).toBe element
							expect(nextElementSibling).not.toBeNull()
							expect(before).toBe nextElementSibling
							present = true
				_delete element
		
		describe "when the last element in the viewport", ->
			beforeEach ->
				go()
			it "removes the element", ->
				expect(present).toBeFalsy()
			it "adds a history step", ->
				expect(history.addStep).toHaveBeenCalledWith (jasmine.any Function), (jasmine.any Function), (jasmine.any Function)
				expect(history.addStep.calls.count()).toEqual 1
			describe "on discarding", ->
				beforeEach ->
					(history.addStep.calls.argsFor 0)[2]()
				it "does nothing", ->
					expect(present).toBeFalsy()
				it "does not add another history step", ->
					expect(history.addStep.calls.count()).toEqual 1
			describe "on undoing", ->
				beforeEach ->
					(history.addStep.calls.argsFor 0)[0]()
				it "puts the element back", ->
					expect(present).toBeTruthy()
				it "does not add another history step", ->
					expect(history.addStep.calls.count()).toEqual 1
				describe "on discarding", ->
					beforeEach ->
						(history.addStep.calls.argsFor 0)[2]()
					it "does nothing", ->
						expect(present).toBeTruthy()
					it "does not add another history step", ->
						expect(history.addStep.calls.count()).toEqual 1
				describe "on redoing", ->
					beforeEach ->
						(history.addStep.calls.argsFor 0)[1]()
					it "restores the operator to \"add\"", ->
						expect(present).toBeFalsy()
					it "does not add another history step", ->
						expect(history.addStep.calls.count()).toEqual 1
		
		describe "when not the last element in the viewport", ->
			beforeEach ->
				nextElementSibling = "next element"
				go()
			it "removes the element", ->
				expect(present).toBeFalsy()
			it "adds a history step", ->
				expect(history.addStep).toHaveBeenCalledWith (jasmine.any Function), (jasmine.any Function), (jasmine.any Function)
				expect(history.addStep.calls.count()).toEqual 1
			describe "on discarding", ->
				beforeEach ->
					(history.addStep.calls.argsFor 0)[2]()
				it "does nothing", ->
					expect(present).toBeFalsy()
				it "does not add another history step", ->
					expect(history.addStep.calls.count()).toEqual 1
			describe "on undoing", ->
				beforeEach ->
					(history.addStep.calls.argsFor 0)[0]()
				it "puts the element back", ->
					expect(present).toBeTruthy()
				it "does not add another history step", ->
					expect(history.addStep.calls.count()).toEqual 1
				describe "on discarding", ->
					beforeEach ->
						(history.addStep.calls.argsFor 0)[2]()
					it "does nothing", ->
						expect(present).toBeTruthy()
					it "does not add another history step", ->
						expect(history.addStep.calls.count()).toEqual 1
				describe "on redoing", ->
					beforeEach ->
						(history.addStep.calls.argsFor 0)[1]()
					it "restores the operator to \"add\"", ->
						expect(present).toBeFalsy()
					it "does not add another history step", ->
						expect(history.addStep.calls.count()).toEqual 1