describe "scene", ->
	rewire = require "rewire"
	scene = undefined
	beforeEach -> scene = rewire "./scene"
	
	describe "on calling", ->
		result = setInterval = clearInterval = document = mode = undefined
		beforeEach ->
			setInterval = jasmine.createSpy "setInterval"
			setInterval.and.returnValue "test timer id"
			scene.__set__ "setInterval", setInterval
			
			clearInterval = jasmine.createSpy "clearInterval"
			scene.__set__ "clearInterval", clearInterval
			
			mode = undefined
			body = 
				getAttribute: (name) -> switch name
					when "mode" then mode
					else null
			
			document = {}
			scene.__set__ "document", 
				body: body
			
		tests = (initialMode) ->
			describe "when starting in \"" + initialMode + "\"", ->
				beforeEach ->
					mode = initialMode
					result = scene()
				it "sets up an interval", ->
					expect(setInterval.calls.count()).toEqual 1
					expect(setInterval).toHaveBeenCalledWith (jasmine.any Function), 16.6666666666666666666
				it "does not clear an interval", ->
					expect(clearInterval).not.toHaveBeenCalled()
				it "returns an object", ->
					expect(result).toEqual jasmine.any Object
				it "returns an append function", ->
					expect(result.append).toEqual jasmine.any Function
				it "returns a stop function", ->
					expect(result.stop).toEqual jasmine.any Function
				describe "when the timer runs without setting up any functions", ->
					describe "when the program is in \"play\" mode", ->
						beforeEach ->
							mode = "play"
							(setInterval.calls.argsFor 0)[0]()
						it "does not set up another interval", ->
							expect(setInterval.calls.count()).toEqual 1
						it "does not clear an interval", ->
							expect(clearInterval).not.toHaveBeenCalled()
					describe "when the program is not in \"play\" mode", ->
						beforeEach ->
							mode = "other"
							(setInterval.calls.argsFor 0)[0]()
						it "does not set up another interval", ->
							expect(setInterval.calls.count()).toEqual 1
						it "does not clear an interval", ->
							expect(clearInterval).not.toHaveBeenCalled()
				describe "on appending a function", ->
					callbackA = undefined
					beforeEach ->
						callbackA = jasmine.createSpy "callbackA"
						result.append callbackA
					it "does not call the function", ->
						expect(callbackA).not.toHaveBeenCalled()
					it "does not set up another interval", ->
						expect(setInterval.calls.count()).toEqual 1
					it "does not clear an interval", ->
						expect(clearInterval).not.toHaveBeenCalled()
					describe "when the timer runs without setting up any further functions", ->
						describe "when the program is in \"play\" mode", ->
							beforeEach ->
								mode = "play"
								(setInterval.calls.argsFor 0)[0]()
							it "does not set up another interval", ->
								expect(setInterval.calls.count()).toEqual 1
							it "does not clear an interval", ->
								expect(clearInterval).not.toHaveBeenCalled()
							it "calls all callbacks", ->
								expect(callbackA.calls.count()).toEqual 1
							describe "on appending another function", ->
								callbackB = undefined
								beforeEach ->
									callbackB = jasmine.createSpy "callbackB"
									result.append callbackB
								it "does not set up another interval", ->
									expect(setInterval.calls.count()).toEqual 1
								it "does not clear an interval", ->
									expect(clearInterval).not.toHaveBeenCalled()
								it "does not call the function", ->
									expect(callbackA.calls.count()).toEqual 1
									expect(callbackB.calls.count()).toEqual 0
								describe "when the timer runs without setting up any further functions", ->
									describe "when the program is in \"play\" mode", ->
										beforeEach ->
											mode = "play"
											(setInterval.calls.argsFor 0)[0]()
										it "does not set up another interval", ->
											expect(setInterval.calls.count()).toEqual 1
										it "does not clear an interval", ->
											expect(clearInterval).not.toHaveBeenCalled()
										it "calls all callbacks", ->
											expect(callbackA.calls.count()).toEqual 2
											expect(callbackB.calls.count()).toEqual 1
									describe "when the program is not in \"play\" mode", ->
										beforeEach ->
											mode = "other"
											(setInterval.calls.argsFor 0)[0]()
										it "does not set up another interval", ->
											expect(setInterval.calls.count()).toEqual 1
										it "does not clear an interval", ->
											expect(clearInterval).not.toHaveBeenCalled()
										it "does not call callbacks", ->
											expect(callbackA.calls.count()).toEqual 1
											expect(callbackB.calls.count()).toEqual 0
							describe "when the timer runs again without setting up any further functions", ->
								describe "when the program is in \"play\" mode", ->
									beforeEach ->
										mode = "play"
										(setInterval.calls.argsFor 0)[0]()
									it "does not set up another interval", ->
										expect(setInterval.calls.count()).toEqual 1
									it "does not clear an interval", ->
										expect(clearInterval).not.toHaveBeenCalled()
									it "calls all callbacks", ->
										expect(callbackA.calls.count()).toEqual 2
								describe "when the program is not in \"play\" mode", ->
									beforeEach ->
										mode = "other"
										(setInterval.calls.argsFor 0)[0]()
									it "does not set up another interval", ->
										expect(setInterval.calls.count()).toEqual 1
									it "does not clear an interval", ->
										expect(clearInterval).not.toHaveBeenCalled()
									it "does not call callbacks", ->
										expect(callbackA.calls.count()).toEqual 1
						describe "when the program is not in \"play\" mode", ->
							beforeEach ->
								mode = "other"
								(setInterval.calls.argsFor 0)[0]()
							it "does not set up another interval", ->
								expect(setInterval.calls.count()).toEqual 1
							it "does not clear an interval", ->
								expect(clearInterval).not.toHaveBeenCalled()
							it "does not call callbacks", ->
								expect(callbackA.calls.count()).toEqual 0
							describe "when the timer runs again without setting up any further functions", ->
								describe "when the program is in \"play\" mode", ->
									beforeEach ->
										mode = "play"
										(setInterval.calls.argsFor 0)[0]()
									it "does not set up another interval", ->
										expect(setInterval.calls.count()).toEqual 1
									it "does not clear an interval", ->
										expect(clearInterval).not.toHaveBeenCalled()
									it "calls all callbacks", ->
										expect(callbackA.calls.count()).toEqual 1
								describe "when the program is not in \"play\" mode", ->
									beforeEach ->
										mode = "other"
										(setInterval.calls.argsFor 0)[0]()
									it "does not set up another interval", ->
										expect(setInterval.calls.count()).toEqual 1
									it "does not clear an interval", ->
										expect(clearInterval).not.toHaveBeenCalled()
									it "does not call callbacks", ->
										expect(callbackA.calls.count()).toEqual 0
					describe "on appending another function", ->
						callbackB = undefined
						beforeEach ->
							callbackB = jasmine.createSpy "callbackB"
							result.append callbackB
						it "does not set up another interval", ->
							expect(setInterval.calls.count()).toEqual 1
						it "does not clear an interval", ->
							expect(clearInterval).not.toHaveBeenCalled()
						it "does not call the function", ->
							expect(callbackA).not.toHaveBeenCalled()
							expect(callbackB).not.toHaveBeenCalled()
						describe "when the timer runs without setting up any further functions", ->
							describe "when the program is in \"play\" mode", ->
								beforeEach ->
									mode = "play"
								it "does not set up another interval", ->
									(setInterval.calls.argsFor 0)[0]()
									expect(setInterval.calls.count()).toEqual 1
								it "does not clear an interval", ->
									(setInterval.calls.argsFor 0)[0]()
									expect(clearInterval).not.toHaveBeenCalled()
								it "calls all callbacks", ->
									(setInterval.calls.argsFor 0)[0]()
									expect(callbackA.calls.count()).toEqual 1
									expect(callbackB.calls.count()).toEqual 1
								it "calls the callbacks in order", ->
									callbackB.and.callFake ->
										expect(callbackA).toHaveBeenCalled()
									(setInterval.calls.argsFor 0)[0]()
							describe "when the program is not in \"play\" mode", ->
								beforeEach ->
									mode = "other"
									(setInterval.calls.argsFor 0)[0]()
								it "does not set up another interval", ->
									expect(setInterval.calls.count()).toEqual 1
								it "does not clear an interval", ->
									expect(clearInterval).not.toHaveBeenCalled()
								it "does not call callbacks", ->
									expect(callbackA.calls.count()).toEqual 0
									expect(callbackB.calls.count()).toEqual 0
		tests "play"
		tests "other"