describe "events", ->
	rewire = require "rewire"
	events = undefined
	beforeEach ->
		events = rewire "./events"
		
	describe "imports", ->
		it "history", -> expect(events.__get__ "history").toBe require "./actions/history"
		it "addShape", -> expect(events.__get__ "addShape").toBe require "./actions/addShape"
		it "delete", -> expect(events.__get__ "_delete").toBe require "./actions/delete"
		it "clone", -> expect(events.__get__ "clone").toBe require "./actions/clone"
		it "move", -> expect(events.__get__ "move").toBe require "./actions/bounds/move"
		it "left", -> expect(events.__get__ "left").toBe require "./actions/bounds/left"
		it "top", -> expect(events.__get__ "top").toBe require "./actions/bounds/top"
		it "right", -> expect(events.__get__ "right").toBe require "./actions/bounds/right"
		it "bottom", -> expect(events.__get__ "bottom").toBe require "./actions/bounds/bottom"
		it "radius", -> expect(events.__get__ "radius").toBe require "./actions/bounds/radius"
		it "pullForward", -> expect(events.__get__ "pullForward").toBe require "./actions/pullForward"
		it "pushBack", -> expect(events.__get__ "pushBack").toBe require "./actions/pushBack"
		it "operator", -> expect(events.__get__ "operator").toBe require "./actions/operator"
		
	describe "on calling", ->
		history = dependencies = undefined
		beforeEach ->
			history = {}
			events.__set__ "history", history
			
			dependencies = {}
			
			mock = (dependency) ->
				dependencies[dependency] = jasmine.createSpy dependency
				dependencies[dependency].and.callFake -> expect(false).toBeTruthy()
				events.__set__ dependency, dependencies[dependency] 
				
			mock dependency for dependency in [
				"addShape"
				"_delete"
				"clone"
				"move"
				"left"
				"right"
				"top"
				"bottom"
				"radius"
				"pullForward"
				"pushBack"
				"operator"
			]
		
		doesNothingAfterClick = ->
			describe "on moving the pointer", ->
				beforeEach -> events.move 500, 700
				it "does nothing", ->
				describe "on moving the pointer", ->
					beforeEach -> events.move 700, 500
					it "does nothing", ->
					describe "on releasing the pointer", ->
						beforeEach -> events.end()
						it "does nothing", ->
				describe "on releasing the pointer", ->
					beforeEach -> events.end()
					it "does nothing", ->
			describe "on releasing the pointer", ->
				beforeEach -> events.end()
				it "does nothing", ->
			
		doesNothing = ->
			it "does nothing", ->
			doesNothingAfterClick()
			
		describe "tap", ->
			describe "without a target element", ->
				beforeEach ->
					events.tap null
				doesNothing()
			describe "with a target element", ->
				attributes = tagName = id = go = className = target = parentNode = undefined
				beforeEach ->
					tagName = id = className = undefined
					attributes = {}
					go = ->
						target = 
							tagName: tagName
							id: id
							className: className
							getAttribute: (name) -> attributes[name] or null
							parentNode: parentNode
						events.tap target
							
							
				describe "when the target element's tag name is unrecognized", ->
					beforeEach -> tagName = "UNKNOWN TAGNAME"
					doesNothing()
				
				describe "when the target element is a div", ->
					beforeEach -> tagName = "DIV"
					describe "when the target element's class is unrecognized", ->
						doesNothing()
					describe "when the target element's class is \"handle\"", ->
						beforeEach -> className = "handle"
						describe "when the target element is a delete handle", ->
							beforeEach ->
								parentNode = "test parent node"
								attributes.kind = "delete"
								dependencies._delete.and.stub()
								go()
							it "calls delete with the target element", ->
								expect(dependencies._delete).toHaveBeenCalledWith "test parent node"
								expect(dependencies._delete.calls.count()).toEqual 1
							doesNothingAfterClick()
						describe "when the target element is a clone handle", ->
							beforeEach ->
								parentNode = "test parent node"
								attributes.kind = "clone"
								dependencies.clone.and.stub()
								go()
							it "calls clone with the target element", ->
								expect(dependencies.clone).toHaveBeenCalledWith "test parent node"
								expect(dependencies.clone.calls.count()).toEqual 1
							doesNothingAfterClick()
							
						describe "when the target element is a pull forward handle", ->
							beforeEach ->
								parentNode = "test parent node"
								attributes.kind = "pullForward"
								dependencies.pullForward.and.stub()
								go()
							it "calls pullForward with the target element", ->
								expect(dependencies.pullForward).toHaveBeenCalledWith "test parent node"
								expect(dependencies.pullForward.calls.count()).toEqual 1
							doesNothingAfterClick()
							
						describe "when the target element is a push back handle", ->
							beforeEach ->
								parentNode = "test parent node"
								attributes.kind = "pushBack"
								dependencies.pushBack.and.stub()
								go()
							it "calls pushBack with the target element", ->
								expect(dependencies.pushBack).toHaveBeenCalledWith "test parent node"
								expect(dependencies.pushBack.calls.count()).toEqual 1
							doesNothingAfterClick()
							
						describe "when the target element is an operator handle", ->
							beforeEach ->
								parentNode = "test parent node"
								attributes.kind = "operator"
								dependencies.operator.and.stub()
								go()
							it "calls operator with the target element", ->
								expect(dependencies.operator).toHaveBeenCalledWith "test parent node"
								expect(dependencies.operator.calls.count()).toEqual 1
							doesNothingAfterClick()
							
						describe "when the target element is a move handle", ->
							beforeEach ->
								attributes.kind = "move"
								go()
							doesNothing()
							
						describe "when the target element is a left handle", ->
							beforeEach ->
								attributes.kind = "left"
								go()
							doesNothing()
							
						describe "when the target element is a right handle", ->
							beforeEach ->
								attributes.kind = "right"
								go()
							doesNothing()
							
						describe "when the target element is a top handle", ->
							beforeEach ->
								attributes.kind = "top"
								go()
							doesNothing()
							
						describe "when the target element is a bottom handle", ->
							beforeEach ->
								attributes.kind = "bottom"
								go()
							doesNothing()
							
						describe "when the target element is a left radius handle", ->
							beforeEach ->
								attributes.kind = "leftRadius"
								go()
							doesNothing()
							
						describe "when the target element is a right radius handle", ->
							beforeEach ->
								attributes.kind = "rightRadius"
								go()
							doesNothing()
							
						describe "when the target element is a top radius handle", ->
							beforeEach ->
								attributes.kind = "topRadius"
								go()
							doesNothing()
							
						describe "when the target element is a bottom radius handle", ->
							beforeEach ->
								attributes.kind = "bottomRadius"
								go()
							doesNothing()
							
				describe "when the target element is a button", ->
					beforeEach -> tagName = "BUTTON"
					describe "when the target element's id is \"undo\"", ->
						beforeEach -> id = "undo"
						describe "when the target element is disabled", ->
							beforeEach -> 
								attributes.disabled = "disabled"
								go()
							doesNothing()
						describe "when the target element is enabled", ->
							beforeEach ->
								history.undo = jasmine.createSpy "undo"
								go()
							it "calls history.undo", ->
								expect(history.undo.calls.count()).toEqual 1
							doesNothingAfterClick()
					describe "when the target element's id is \"redo\"", ->
						beforeEach -> id = "redo"
						describe "when the target element is disabled", ->
							beforeEach -> 
								attributes.disabled = "disabled"
								go()
							doesNothing()
						describe "when the target element is enabled", ->
							beforeEach ->
								history.redo = jasmine.createSpy "redo"
								go()
							it "calls history.redo", ->
								expect(history.redo.calls.count()).toEqual 1
							doesNothingAfterClick()
					describe "when the target element's class is \"add\"", ->
						beforeEach -> 
							className = "add"
							attributes.shape = "test shape"
							attributes.operator = "test operator"
							dependencies.addShape.and.stub()
							go()
						it "creates one new shape based on the attributes set", ->
							expect(dependencies.addShape.calls.count()).toEqual 1
							expect(dependencies.addShape).toHaveBeenCalledWith "test shape", "test operator"
						doesNothingAfterClick()
			
		describe "start", ->
			describe "without a target element", ->
				beforeEach ->
					events.start null
				doesNothing()
			describe "with a target element", ->
				attributes = tagName = id = go = className = target = parentNode = undefined
				beforeEach ->
					tagName = id = className = undefined
					attributes = {}
					go = ->
						target = 
							tagName: tagName
							id: id
							className: className
							getAttribute: (name) -> attributes[name] or null
							parentNode: parentNode
						events.start target
							
							
				describe "when the target element's tag name is unrecognized", ->
					beforeEach -> tagName = "UNKNOWN TAGNAME"
					doesNothing()
							
				describe "when the target element is a div", ->
					beforeEach -> tagName = "DIV"
					describe "when the target element's class is unrecognized", ->
						doesNothing()
					describe "when the target element's class is \"handle\"", ->
						beforeEach -> className = "handle"
						describe "when the target element is a delete handle", ->
							beforeEach ->
								parentNode = "test parent node"
								attributes.kind = "delete"
								go()
							doesNothing()
							
						describe "when the target element is a clone handle", ->
							beforeEach ->
								parentNode = "test parent node"
								attributes.kind = "clone"
								go()
							doesNothing()
							
						describe "when the target element is a pull forward handle", ->
							beforeEach ->
								parentNode = "test parent node"
								attributes.kind = "pullForward"
								go()
							doesNothing()
							
						describe "when the target element is a push back handle", ->
							beforeEach ->
								parentNode = "test parent node"
								attributes.kind = "pushBack"
								go()
							doesNothing()
							
						describe "when the target element is an operator handle", ->
							beforeEach ->
								parentNode = "test parent node"
								attributes.kind = "operator"
								go()
							doesNothing()
							
						withContinuation = (name, dependency) ->
							dependency = dependency or name
							continuation = undefined
							beforeEach ->
								parentNode = "test parent node"
								attributes.kind = name
								continuation = 
									move: jasmine.createSpy "move"
									end: jasmine.createSpy "end"
								dependencies[dependency].and.callFake -> continuation
								go()
							it "calls move with the target element", ->
								expect(dependencies[dependency].calls.count()).toEqual 1
								expect(dependencies[dependency]).toHaveBeenCalledWith "test parent node"
							it "does not move or end the continuation", ->
								expect(continuation.move).not.toHaveBeenCalled()
								expect(continuation.end).not.toHaveBeenCalled()
							describe "on moving the pointer", ->
								beforeEach -> events.move 70, 85
								it "does not call move again", ->
									expect(dependencies[dependency].calls.count()).toEqual 1
								it "moves the continuation", ->
									expect(continuation.move.calls.count()).toEqual 1
									expect(continuation.move).toHaveBeenCalledWith 70, 85
								it "does not end the continuation", ->
									expect(continuation.end).not.toHaveBeenCalled()
								describe "on moving the pointer", ->
									beforeEach -> events.move 90, 140
									it "does not call move again", ->
										expect(dependencies[dependency].calls.count()).toEqual 1
									it "moves the continuation", ->
										expect(continuation.move.calls.count()).toEqual 2
										expect(continuation.move).toHaveBeenCalledWith 90, 140
									it "does not end the continuation", ->
										expect(continuation.end).not.toHaveBeenCalled()
									describe "on releasing the pointer", ->
										beforeEach -> events.end()
										it "calls end", ->
											expect(continuation.end.calls.count()).toEqual 1
										it "does not call move again", ->
											expect(dependencies[dependency].calls.count()).toEqual 1
										it "does not move the continuation", ->
											expect(continuation.move.calls.count()).toEqual 2
										describe "on moving the pointer", ->
											beforeEach -> events.move 450, 720
											it "does not call move again", ->
												expect(dependencies[dependency].calls.count()).toEqual 1
											it "does not move the continuation", ->
												expect(continuation.move.calls.count()).toEqual 2
											it "does not end the continuation", ->
												expect(continuation.end.calls.count()).toEqual 1
										describe "on releasing the pointer", ->
											beforeEach -> events.end()
											it "does not call move again", ->
												expect(dependencies[dependency].calls.count()).toEqual 1
											it "does not move the continuation", ->
												expect(continuation.move.calls.count()).toEqual 2
											it "does not end the continuation", ->
												expect(continuation.end.calls.count()).toEqual 1						
								describe "on releasing the pointer", ->
									beforeEach -> events.end()
									it "calls end", ->
										expect(continuation.end.calls.count()).toEqual 1
									it "does not call move again", ->
										expect(dependencies[dependency].calls.count()).toEqual 1
									it "does not move the continuation", ->
										expect(continuation.move.calls.count()).toEqual 1
									describe "on moving the pointer", ->
										beforeEach -> events.move 450, 720
										it "does not call move again", ->
											expect(dependencies[dependency].calls.count()).toEqual 1
										it "does not move the continuation", ->
											expect(continuation.move.calls.count()).toEqual 1
										it "does not end the continuation", ->
											expect(continuation.end.calls.count()).toEqual 1
									describe "on releasing the pointer", ->
										beforeEach -> events.end()
										it "does not call move again", ->
											expect(dependencies[dependency].calls.count()).toEqual 1
										it "does not move the continuation", ->
											expect(continuation.move.calls.count()).toEqual 1
										it "does not end the continuation", ->
											expect(continuation.end.calls.count()).toEqual 1					
							describe "on releasing the pointer", ->
								beforeEach -> events.end()
								it "calls end", ->
									expect(continuation.end.calls.count()).toEqual 1
								it "does not call move", ->
									expect(dependencies[dependency].calls.count()).toEqual 1
								it "does not move the continuation", ->
									expect(continuation.move).not.toHaveBeenCalled()
								describe "on moving the pointer", ->
									beforeEach -> events.move 450, 720
									it "does not call move again", ->
										expect(dependencies[dependency].calls.count()).toEqual 1
									it "does not move the continuation", ->
										expect(continuation.move.calls.count()).toEqual 0
									it "does not end the continuation", ->
										expect(continuation.end.calls.count()).toEqual 1
								describe "on releasing the pointer", ->
									beforeEach -> events.end()
									it "does not call move again", ->
										expect(dependencies[dependency].calls.count()).toEqual 1
									it "does not move the continuation", ->
										expect(continuation.move.calls.count()).toEqual 0
									it "does not end the continuation", ->
										expect(continuation.end.calls.count()).toEqual 1
							
						describe "when the target element is a left handle", ->
							withContinuation "left"
							
						describe "when the target element is a right handle", ->
							withContinuation "right"
							
						describe "when the target element is a top handle", ->
							withContinuation "top"
							
						describe "when the target element is a bottom handle", ->
							withContinuation "bottom"
							
						describe "when the target element is a left radius handle", ->
							withContinuation "radiusLeft", "radius"
							
						describe "when the target element is a right radius handle", ->
							withContinuation "radiusRight", "radius"
							
						describe "when the target element is a top radius handle", ->
							withContinuation "radiusTop", "radius"
							
						describe "when the target element is a bottom radius handle", ->
							withContinuation "radiusBottom", "radius"
							
						describe "when the target element is a move handle", ->
							withContinuation "move"
							
				describe "when the target element is a button", ->
					beforeEach -> tagName = "BUTTON"
					describe "when the target element's id is \"undo\"", ->
						beforeEach -> id = "undo"
						describe "when the target element is disabled", ->
							beforeEach -> 
								attributes.disabled = "disabled"
								go()
							doesNothing()
						describe "when the target element is enabled", ->
							beforeEach ->
								go()
							doesNothing()
					describe "when the target element's id is \"redo\"", ->
						beforeEach -> id = "redo"
						describe "when the target element is disabled", ->
							beforeEach -> 
								attributes.disabled = "disabled"
								go()
							doesNothing()
						describe "when the target element is enabled", ->
							beforeEach ->
								go()
							doesNothing()
					describe "when the target element's class is \"add\"", ->
						beforeEach -> 
							className = "add"
							attributes.shape = "test shape"
							attributes.operator = "test operator"
							go()
						doesNothing()