describe "eventBindings", ->
	rewire = require "rewire"
	eventBindings = undefined
	
	beforeEach ->
		global.document = {}
		global.window = 
			document: global.document
		eventBindings = rewire "./eventBindings"
	
	describe "imports", ->
		it "events", ->
			expect(eventBindings.__get__ "events").toBe require "./events"
		it "keyUp", -> expect(eventBindings.__get__ "keyUp").toBe require "./../input/keyUp"
		it "keyDown", -> expect(eventBindings.__get__ "keyDown").toBe require "./../input/keyDown"
		it "loadFile", ->
			expect(eventBindings.__get__ "loadFile").toBe require "./io/loadFile"
			
	describe "on startup", ->
		events = loadFile = keyUp = keyDown = undefined
		beforeEach ->
			global.window.innerWidth = 600
			global.window.innerHeight = 350
			global.document.body = 
				scrollWidth: 7500
				scrollHeight: 9000
			
			events = {}
			eventBindings.__set__ "events", events
			
			keyUp = jasmine.createSpy "keyUp"
			keyUp.and.callFake -> fail "unexpected keyUp"
			eventBindings.__set__ "keyUp", keyUp
			
			keyDown = jasmine.createSpy "keyDown"
			keyDown.and.callFake -> fail "unexpected keyDown"
			eventBindings.__set__ "keyDown", keyDown
			
			loadFile = jasmine.createSpy "loadFile"
			eventBindings.__set__ "loadFile", loadFile
		it "listens for window.onload", ->
			expect(window.onload).toEqual jasmine.any Function
		it "does not listen for document events yet", ->
			expect(document.onmousedown).toBeUndefined()
			expect(document.onmousemove).toBeUndefined()
			expect(document.onmouseup).toBeUndefined()
			expect(document.ontouchdown).toBeUndefined()
			expect(document.ontouchmove).toBeUndefined()
			expect(document.ontouchup).toBeUndefined()
			expect(loadFile).not.toHaveBeenCalled()
		describe "on window.onload", ->
			beforeEach ->
				window.scrollTo = jasmine.createSpy "scrollTo"
				window.onload()
			it "scrolls to the middle of the canvas", -> 
				expect(window.scrollTo).toHaveBeenCalledWith 3450, 4325
			it "listens for document.onmousedown", ->
				expect(document.onmousedown).toEqual jasmine.any Function
			it "listens for document.onmousemove", ->
				expect(document.onmousemove).toEqual jasmine.any Function
			it "listens for document.onmouseup", ->
				expect(document.onmouseup).toEqual jasmine.any Function
			it "listens for document.ontouchmove", ->
				expect(document.ontouchmove).toEqual jasmine.any Function
			it "listens for document.ontouchend", ->
				expect(document.ontouchend).toEqual jasmine.any Function
			it "listens for document.onkeyup", ->
				expect(document.onkeyup).toEqual jasmine.any Function
			it "listens for document.onkeydown", ->
				expect(document.onkeydown).toEqual jasmine.any Function
			it "sets up loading files", ->
				expect(loadFile.calls.count()).toEqual 1
			describe "on mouse down", ->
				beforeEach ->
					events.start = jasmine.createSpy "start"
					events.tap = jasmine.createSpy "tap"
					document.onmousedown
						target: "test target"
				it "fires the start event", ->
					expect(events.start.calls.count()).toEqual 1
					expect(events.start).toHaveBeenCalledWith "test target"
				it "fires the tap event", ->
					expect(events.tap.calls.count()).toEqual 1
					expect(events.tap).toHaveBeenCalledWith "test target"
			describe "on mouse move", ->
				beforeEach ->
					events.move = jasmine.createSpy "move"
					document.onmousemove
						pageX: 8
						pageY: 15
				it "fires the move event", ->
					expect(events.move.calls.count()).toEqual 1
					expect(events.move).toHaveBeenCalledWith 8, 15
			describe "on mouse up", ->
				beforeEach ->
					events.end = jasmine.createSpy "end"
					document.onmouseup {}
				it "fires the end event", ->
					expect(events.end.calls.count()).toEqual 1
			describe "on touch move", ->
				beforeEach ->
					events.move = jasmine.createSpy "move"
					document.ontouchmove
						touches: [
							pageX: 8
							pageY: 15
						]
				it "fires the move event", ->
					expect(events.move.calls.count()).toEqual 1
					expect(events.move).toHaveBeenCalledWith 8, 15
			describe "on touch end", ->
				beforeEach ->
					events.end = jasmine.createSpy "end"
					document.ontouchend {}
				it "fires the end event", ->
					expect(events.end.calls.count()).toEqual 1
			describe "on key up", ->
				beforeEach ->
					keyUp.and.stub()
					document.onkeyup "test event"
				it "fires the keyUp event", ->
					expect(keyUp.calls.count()).toEqual 1
					expect(keyUp).toHaveBeenCalledWith "test event"
			describe "on key down", ->
				beforeEach ->
					keyDown.and.stub()
					document.onkeydown "test event"
				it "fires the keyUp event", ->
					expect(keyDown.calls.count()).toEqual 1
					expect(keyDown).toHaveBeenCalledWith "test event"