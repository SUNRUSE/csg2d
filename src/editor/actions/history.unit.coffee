describe "history", ->
	rewire = require "rewire"
	canUndo = canRedo = doneSteps = history = document = window = undefined
	
	beforeEach ->
		doneSteps = []
		canUndo = false
		canRedo = false
		
		history = rewire "./history"
		
		document = 
			getElementById: (id) ->
				switch id
					when "undo"
						setAttribute: (name, value) ->
							expect(name).toEqual "disabled"
							expect(value).toEqual "disabled"
							canUndo = false
						removeAttribute: (name) ->
							expect(name).toEqual "disabled"
							canUndo = true
					when "redo"
						setAttribute: (name, value) ->
							expect(name).toEqual "disabled"
							expect(value).toEqual "disabled"
							canRedo = false
						removeAttribute: (name) ->
							expect(name).toEqual "disabled"
							canRedo = true
					else null
					
		window = 
			confirm: (message) -> fail "unexpected confirm"
			document: document
			
		history.__set__ "window", window
		history.__set__ "document", document
		
	it "disables undo and redo", ->
		expect(canUndo).toBeFalsy()
		expect(canRedo).toBeFalsy()

	describe "on adding a history step", ->									# [X]
		beforeEach ->
			history.addStep (-> doneSteps.push "undo 1"), (-> doneSteps.push "redo 1"), (-> doneSteps.push "discard 1")
		it "enables undo", ->
			expect(canUndo).toBeTruthy()
			expect(canRedo).toBeFalsy()
		it "does not undo or redo", ->
			expect(doneSteps).toEqual []
		describe "on pressing undo", ->										# [-]
			beforeEach ->
				history.undo()
			it "enables redo and disables undo", ->
				expect(canUndo).toBeFalsy()
				expect(canRedo).toBeTruthy()
			it "calls undo for the first step", ->
				expect(doneSteps).toEqual ["undo 1"]
			describe "on pressing redo", ->									# [X]
				beforeEach ->
					history.redo()
				it "enables undo and disables redo", ->
					expect(canUndo).toBeTruthy()
					expect(canRedo).toBeFalsy()
				it "calls redo for the first step", ->
					expect(doneSteps).toEqual ["undo 1", "redo 1"]
				describe "on adding a history step", ->						# [XX]
					beforeEach ->
						history.addStep (-> doneSteps.push "undo 2"), (-> doneSteps.push "redo 2"), (-> doneSteps.push "discard 2")
					it "leaves only undo enabled", ->
						expect(canUndo).toBeTruthy()
						expect(canRedo).toBeFalsy()
					it "does not undo or redo", ->
						expect(doneSteps).toEqual ["undo 1", "redo 1"]
					describe "on pressing undo", ->							# [X-]
						beforeEach ->
							history.undo()
						it "enables both undo and redo", ->
							expect(canUndo).toBeTruthy()
							expect(canRedo).toBeTruthy()
						it "calls undo for the second step", ->
							expect(doneSteps).toEqual ["undo 1", "redo 1", "undo 2"]
						describe "on pressing undo", ->						# [--]
							beforeEach ->
								history.undo()
							it "disables undo", ->
								expect(canUndo).toBeFalsy()
								expect(canRedo).toBeTruthy()
							it "calls undo for the first step", ->
								expect(doneSteps).toEqual ["undo 1", "redo 1", "undo 2", "undo 1"]
							describe "on pressing redo", ->					# [X-]
								beforeEach ->
									history.redo()
								it "calls redo for the first step", ->
									expect(doneSteps).toEqual ["undo 1", "redo 1", "undo 2", "undo 1", "redo 1"]
								describe "on pressing redo", ->				# [XX]
									beforeEach ->
										history.redo()
									it "calls redo for the second step", ->
										expect(doneSteps).toEqual ["undo 1", "redo 1", "undo 2", "undo 1", "redo 1", "redo 2"]
						describe "on pressing redo", ->						# [XX]
							beforeEach ->
								history.redo()
							it "disables redo", ->
								expect(canUndo).toBeTruthy()
								expect(canRedo).toBeFalsy()
							it "calls redo for the second step", ->
								expect(doneSteps).toEqual ["undo 1", "redo 1", "undo 2", "redo 2"]
							describe "on pressing undo", ->					# [X-]
								beforeEach ->
									history.undo()
								it "enables redo", ->
									expect(canUndo).toBeTruthy()
									expect(canRedo).toBeTruthy()
								it "calls undo for the second step", ->
									expect(doneSteps).toEqual ["undo 1", "redo 1", "undo 2", "redo 2", "undo 2"]
						describe "on pressing undo", ->						# [--]
							beforeEach ->
								history.undo()
							it "disables undo", ->
								expect(canUndo).toBeFalsy()
								expect(canRedo).toBeTruthy()
							it "calls undo for the first step", ->
								expect(doneSteps).toEqual ["undo 1", "redo 1", "undo 2", "undo 1"]
							describe "on pressing redo", ->					# [X-]
								beforeEach ->
									history.redo()
								it "enables undo", ->
									expect(canUndo).toBeTruthy()
									expect(canRedo).toBeTruthy()
								it "calls redo for the first step", ->
									expect(doneSteps).toEqual ["undo 1", "redo 1", "undo 2", "undo 1", "redo 1"]
								describe "on pressing redo", ->				# [XX]
									beforeEach ->
										history.redo()
									it "disables redo", ->
										expect(canUndo).toBeTruthy()
										expect(canRedo).toBeFalsy()
									it "calls redo for the second step", ->
										expect(doneSteps).toEqual ["undo 1", "redo 1", "undo 2", "undo 1", "redo 1", "redo 2"]
							describe "on adding a history step", ->
								describe "on discarding the old step", ->	# [X]
									beforeEach ->
										spyOn window, "confirm"
											.and.callFake (message) ->
												expect(message).toEqual "You have undone changes which will be lost if you make this change.  Are you sure you wish to continue, losing your undone changes?"
												true
										history.addStep (-> doneSteps.push "undo 3"), (-> doneSteps.push "redo 3"), (-> doneSteps.push "discard 3")
									it "calls confirm once", ->
										expect(window.confirm.calls.count()).toEqual 1
									it "enables undo and disables redo", ->
										expect(canUndo).toBeTruthy()
										expect(canRedo).toBeFalsy()
									it "discards the first and second steps", ->
										expect(doneSteps).toEqual ["undo 1", "redo 1", "undo 2", "undo 1", "discard 1", "discard 2"]
									describe "on pressing undo", ->			# [-]
										beforeEach ->
											history.undo()
										it "disables undo", ->
											expect(canUndo).toBeFalsy()
											expect(canRedo).toBeTruthy()
										it "calls undo for the first step", ->
											expect(doneSteps).toEqual ["undo 1", "redo 1", "undo 2", "undo 1", "discard 1", "discard 2", "undo 3"]
										describe "on pressing redo", ->		# [X]
											beforeEach ->
												history.redo()
											it "disables redo", ->
												expect(canUndo).toBeTruthy()
												expect(canRedo).toBeFalsy()
											it "calls undo for the first step", ->
												expect(doneSteps).toEqual ["undo 1", "redo 1", "undo 2", "undo 1", "discard 1", "discard 2", "undo 3", "redo 3"]
								describe "on retaining the old step", ->	# [--]
									beforeEach ->
										spyOn window, "confirm"
											.and.callFake (message) ->
												expect(message).toEqual "You have undone changes which will be lost if you make this change.  Are you sure you wish to continue, losing your undone changes?"
												false
										history.addStep (-> doneSteps.push "undo 3"), (-> doneSteps.push "redo 3"), (-> doneSteps.push "discard 3")
									it "calls confirm once", ->
										expect(window.confirm.calls.count()).toEqual 1
									it "does not enable or disable redo or undo", ->
										expect(canUndo).toBeFalsy()
										expect(canRedo).toBeTruthy()
									it "undoes and discards the new step", ->
										expect(doneSteps).toEqual ["undo 1", "redo 1", "undo 2", "undo 1", "undo 3", "discard 3"]
									describe "on pressing redo", ->			# [X-]
										beforeEach ->
											history.redo()
										it "enables undo", ->
											expect(canUndo).toBeTruthy()
											expect(canRedo).toBeTruthy()
										it "calls redo for the first step", ->
											expect(doneSteps).toEqual ["undo 1", "redo 1", "undo 2", "undo 1", "undo 3", "discard 3", "redo 1"]
										describe "on pressing redo", ->		# [XX]
											beforeEach ->
												history.redo()
											it "disables redo", ->
												expect(canUndo).toBeTruthy()
												expect(canRedo).toBeFalsy()
											it "calls redo for the second step", ->
												expect(doneSteps).toEqual ["undo 1", "redo 1", "undo 2", "undo 1", "undo 3", "discard 3", "redo 1", "redo 2"]
						describe "on adding a history step", ->
							describe "on discarding the old step", ->		# [XX]
								beforeEach ->
									spyOn window, "confirm"
										.and.callFake (message) ->
											expect(message).toEqual "You have undone changes which will be lost if you make this change.  Are you sure you wish to continue, losing your undone changes?"
											true
									history.addStep (-> doneSteps.push "undo 3"), (-> doneSteps.push "redo 3"), (-> doneSteps.push "discard 3")
								it "calls confirm once", ->
									expect(window.confirm.calls.count()).toEqual 1
								it "enables undo and disables redo", ->
									expect(canUndo).toBeTruthy()
									expect(canRedo).toBeFalsy()
								it "discards the second step", ->
									expect(doneSteps).toEqual ["undo 1", "redo 1", "undo 2", "discard 2"]
								describe "on pressing undo", ->				# [X-]
									beforeEach ->
										history.undo()
									it "enables redo", ->
										expect(canUndo).toBeTruthy()
										expect(canRedo).toBeTruthy()
									it "calls undo for the third step", ->
										expect(doneSteps).toEqual ["undo 1", "redo 1", "undo 2", "discard 2", "undo 3"]
									describe "on pressing redo", ->			# [XX]
										beforeEach ->
											history.redo()
										it "disables redo", ->
											expect(canUndo).toBeTruthy()
											expect(canRedo).toBeFalsy()
										it "calls redo for the third step", ->
											expect(doneSteps).toEqual ["undo 1", "redo 1", "undo 2", "discard 2", "undo 3", "redo 3"]
									describe "on pressing undo", ->			# [--]
										beforeEach ->
											history.undo()
										it "disables undo", ->
											expect(canUndo).toBeFalsy()
											expect(canRedo).toBeTruthy()
										it "calls undo for the first step", ->
											expect(doneSteps).toEqual ["undo 1", "redo 1", "undo 2", "discard 2", "undo 3", "undo 1"]
										describe "on pressing redo", ->		# [X-]
											beforeEach ->
												history.redo()
											it "enables redo", ->
												expect(canUndo).toBeTruthy()
												expect(canRedo).toBeTruthy()
											it "calls redo for the first step", ->
												expect(doneSteps).toEqual ["undo 1", "redo 1", "undo 2", "discard 2", "undo 3", "undo 1", "redo 1"]
											describe "on pressing redo", ->	# [XX]
												beforeEach ->
													history.redo()
												it "disables redo", ->
													expect(canUndo).toBeTruthy()
													expect(canRedo).toBeFalsy()
												it "calls redo for the first step", ->
													expect(doneSteps).toEqual ["undo 1", "redo 1", "undo 2", "discard 2", "undo 3", "undo 1", "redo 1", "redo 3"]
							describe "on retaining the old step", ->		# [X-]
								beforeEach ->
									spyOn window, "confirm"
										.and.callFake (message) ->
											expect(message).toEqual "You have undone changes which will be lost if you make this change.  Are you sure you wish to continue, losing your undone changes?"
											false
									history.addStep (-> doneSteps.push "undo 3"), (-> doneSteps.push "redo 3"), (-> doneSteps.push "discard 3")
								it "calls confirm once", ->
									expect(window.confirm.calls.count()).toEqual 1
								it "does not disable undo or redo", ->
									expect(canUndo).toBeTruthy()
									expect(canRedo).toBeTruthy()
								it "undoes and discards the new step", ->
									expect(doneSteps).toEqual ["undo 1", "redo 1", "undo 2", "undo 3", "discard 3"]
								describe "on pressing redo", ->				# [XX]
									beforeEach ->
										history.redo()
									it "disables redo", ->
										expect(canUndo).toBeTruthy()
										expect(canRedo).toBeFalsy()
									it "calls redo for the second step", ->
										expect(doneSteps).toEqual ["undo 1", "redo 1", "undo 2", "undo 3", "discard 3", "redo 2"]
									describe "on pressing undo", ->			# [X-]
										beforeEach ->
											history.undo()
										it "enables redo", ->
											expect(canUndo).toBeTruthy()
											expect(canRedo).toBeTruthy()
										it "calls undo for the second step", ->
											expect(doneSteps).toEqual ["undo 1", "redo 1", "undo 2", "undo 3", "discard 3", "redo 2", "undo 2"]
								describe "on pressing undo", ->				# [--]
									beforeEach ->
										history.undo()
									it "disables undo", ->
										expect(canUndo).toBeFalsy()
										expect(canRedo).toBeTruthy()
									it "calls undo for the first step", ->
										expect(doneSteps).toEqual ["undo 1", "redo 1", "undo 2", "undo 3", "discard 3", "undo 1"]
									describe "on pressing redo", ->			# [X-]
										beforeEach ->
											history.redo()
										it "enables undo", ->
											expect(canUndo).toBeTruthy()
											expect(canRedo).toBeTruthy()
										it "calls redo for the first step", ->
											expect(doneSteps).toEqual ["undo 1", "redo 1", "undo 2", "undo 3", "discard 3", "undo 1", "redo 1"]
										describe "on pressing redo", ->		# [XX]
											beforeEach ->
												history.redo()
											it "disables redo", ->
												expect(canUndo).toBeTruthy()
												expect(canRedo).toBeFalsy()
											it "calls redo for the second step", ->
												expect(doneSteps).toEqual ["undo 1", "redo 1", "undo 2", "undo 3", "discard 3", "undo 1", "redo 1", "redo 2"]
			describe "on adding a history step", ->
				describe "on discarding the old step", ->					# [X]
					beforeEach ->
						spyOn window, "confirm"
							.and.callFake (message) ->
								expect(message).toEqual "You have undone changes which will be lost if you make this change.  Are you sure you wish to continue, losing your undone changes?"
								true
						history.addStep (-> doneSteps.push "undo 2"), (-> doneSteps.push "redo 2"), (-> doneSteps.push "discard 2")
					it "enables undo and disables redo", ->
						expect(canUndo).toBeTruthy()
						expect(canRedo).toBeFalsy()
					it "discards the first step", ->
						expect(doneSteps).toEqual ["undo 1", "discard 1"]
					describe "on pressing undo", ->							# [-]	
						beforeEach ->
							history.undo()
						it "enables redo and disables undo", ->
							expect(canUndo).toBeFalsy()
							expect(canRedo).toBeTruthy()
						it "calls undo for the second step", ->
							expect(doneSteps).toEqual ["undo 1", "discard 1", "undo 2"]
						describe "on pressing redo", ->						# [X]
							beforeEach ->
								history.redo()
							it "enables undo and disables redo", ->
								expect(canUndo).toBeTruthy()
								expect(canRedo).toBeFalsy()
							it "calls redo for the second step", ->
								expect(doneSteps).toEqual ["undo 1", "discard 1", "undo 2", "redo 2"]
				describe "on retaining the old step", ->					# [-]
					beforeEach ->
						spyOn window, "confirm"
							.and.callFake (message) ->
								expect(message).toEqual "You have undone changes which will be lost if you make this change.  Are you sure you wish to continue, losing your undone changes?"
								false
						history.addStep (-> doneSteps.push "undo 2"), (-> doneSteps.push "redo 2"), (-> doneSteps.push "discard 2")
					it "does not enable or disable undo or redo", ->
						expect(canUndo).toBeFalsy()
						expect(canRedo).toBeTruthy()
					it "undoes and discards the second step", ->
						expect(doneSteps).toEqual ["undo 1", "undo 2", "discard 2"]
					describe "on pressing redo", ->							# [X]
						beforeEach ->
							history.redo()
						it "enables undo and disables redo", ->
							expect(canUndo).toBeTruthy()
							expect(canRedo).toBeFalsy()
						it "calls redo for the first step", ->
							expect(doneSteps).toEqual ["undo 1", "undo 2", "discard 2", "redo 1"]
						describe "on pressing undo", ->						# [-]
							beforeEach ->
								history.undo()
							it "enables redo and disables undo", ->
								expect(canUndo).toBeFalsy()
								expect(canRedo).toBeTruthy()
							it "calls undo for the first step", ->
								expect(doneSteps).toEqual ["undo 1", "undo 2", "discard 2", "redo 1", "undo 1"]