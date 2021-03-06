describe "link", ->
	rewire = require "rewire"
	link = undefined
	beforeEach -> link = rewire "./link"
	
	describe "on calling", ->
		a = b = result = material = go = undefined
		
		beforeEach ->
			a = 
				location: 
					x: 7
					y: 3
			b = 
				location:
					x: 2
					y: 1
			# Distance: 5.385165
			
			material = 
				linearityScale: 0.5
				linearityShape: 2
				strength: 3
			
		go = (extraTests) ->
			it "does not modify either point", ->
				expect(a).toEqual
					location:
						x: 7
						y: 3
				expect(b).toEqual
					location:
						x: 2
						y: 1
			it "does not modify the material", ->
				expect(material).toEqual
					linearityScale: 0.5
					linearityShape: 2
					strength: 3
			extraTests()
			it "returns a function", ->
				expect(result).toEqual jasmine.any Function
			describe "when calling the result", ->
				beforeEach ->
					a.velocity =  
						x: -4
						y: 8
					b.velocity =
						x: 6
						y: -9
				describe "when the points have not moved at all", ->
					beforeEach -> result()
					extraTests()
					it "does not modify either point", ->
						expect(a.location.x).toEqual 7
						expect(a.location.y).toEqual 3
						expect(a.velocity.x).toEqual -4
						expect(a.velocity.y).toEqual 8
						
						expect(b.location.x).toEqual 2
						expect(b.location.y).toEqual 1
						expect(b.velocity.x).toEqual 6
						expect(b.velocity.y).toEqual -9
					it "does not modify the material", ->
						expect(material).toEqual
							linearityScale: 0.5
							linearityShape: 2
							strength: 3
				describe "when the points move without changing distance", ->
					beforeEach ->
						a.location.x = 9
						a.location.y = 1
						b.location.x = 4
						b.location.y = -1 
						result()
					extraTests()
					it "does not modify either point", ->
						expect(a.location.x).toEqual 9
						expect(a.location.y).toEqual 1
						expect(a.velocity.x).toEqual -4
						expect(a.velocity.y).toEqual 8
						
						expect(b.location.x).toEqual 4
						expect(b.location.y).toEqual -1
						expect(b.velocity.x).toEqual 6
						expect(b.velocity.y).toEqual -9
					it "does not modify the material", ->
						expect(material).toEqual
							linearityScale: 0.5
							linearityShape: 2
							strength: 3
				describe "when the points change orientation without changing distance", ->
					beforeEach ->
						a.location.x = 5
						a.location.y = 0
						b.location.x = 3
						b.location.y = 5 
						result()
					extraTests()
					it "does not modify either point", ->
						expect(a.location.x).toEqual 5
						expect(a.location.y).toEqual 0
						expect(a.velocity.x).toEqual -4
						expect(a.velocity.y).toEqual 8
						
						expect(b.location.x).toEqual 3
						expect(b.location.y).toEqual 5
						expect(b.velocity.x).toEqual 6
						expect(b.velocity.y).toEqual -9
					it "does not modify the material", ->
						expect(material).toEqual
							linearityScale: 0.5
							linearityShape: 2
							strength: 3
				describe "when the first point moves closer to the second point", ->
					beforeEach ->
						a.location.x = 6
						a.location.y = 2
						result()
						# Distance: 4.123106
					extraTests()
					it "the points accelerate away from one another", ->
						# Difference: 5.385165 - 4.123106 = 1.262059
						# Apply delinearization: (((1.262059 * 0.5) + 1.0) ^ 2.0) - 1.0 = 1.66025723
						# Apply strength: 0.39819823 * 3 = 4.98077169
						# Normal = (6 - 2) / 4.123106, (2 - 1) / 4.123106 = 0.970142412, 0.242535603
						# Change = 0.970142412 * 4.98077169, 0.242535603 * 4.98077169 = 4.832057861, 1.208014465
						# Old values: -4, 8 :: 6, -9
						expect(a.velocity.x).toBeCloseTo 0.832057861
						expect(a.velocity.y).toBeCloseTo 9.208014465
						
						expect(b.velocity.x).toBeCloseTo 1.167942139
						expect(b.velocity.y).toBeCloseTo -10.208014465
					it "does not directly move either point", ->
						expect(a.location.x).toEqual 6
						expect(a.location.y).toEqual 2
						expect(b.location.x).toEqual 2
						expect(b.location.y).toEqual 1
					it "does not modify the material", ->
						expect(material).toEqual
							linearityScale: 0.5
							linearityShape: 2
							strength: 3
				describe "when the second point moves closer to the first point", ->
					beforeEach ->
						b.location.x = 3
						b.location.y = 2
						result()
						# Distance: 4.123106
					extraTests()
					it "the points accelerate away from one another", ->
						# Difference: 5.385165 - 4.123106 = 1.262059
						# Apply delinearization: (((1.262059 * 0.5) + 1.0) ^ 2.0) - 1.0 = 1.66025723
						# Apply strength: 0.39819823 * 3 = 4.98077169
						# Normal = (6 - 2) / 4.123106, (2 - 1) / 4.123106 = 0.970142412, 0.242535603
						# Change = 0.970142412 * 4.98077169, 0.242535603 * 4.98077169 = 4.832057861, 1.208014465
						# Old values: -4, 8 :: 6, -9
						expect(a.velocity.x).toBeCloseTo 0.832057861
						expect(a.velocity.y).toBeCloseTo 9.208014465
						
						expect(b.velocity.x).toBeCloseTo 1.167942139
						expect(b.velocity.y).toBeCloseTo -10.208014465
					it "does not directly move either point", ->
						expect(a.location.x).toEqual 7
						expect(a.location.y).toEqual 3
						expect(b.location.x).toEqual 3
						expect(b.location.y).toEqual 2
					it "does not modify the material", ->
						expect(material).toEqual
							linearityScale: 0.5
							linearityShape: 2
							strength: 3
				describe "when the first point moves away from the second point", ->
					beforeEach ->
						a.location.x = 10
						a.location.y = 2
						result()
						# Distance: 8.062258
					extraTests()
					it "the points accelerate towards one another", ->
						# Difference: 5.385165 - 8.062258 = -2.677093
						# Delinearized: (((-2.677093 * 0.5) - 1.0) ^ 2.0) - 1.0 = 4.468799733
						# With strength: 4.468799733 * 3 = 13.406399198
						# Normal = (7 - -1) / 8.062258, (2 - 3) / 8.062258 = 0.992277846, -0.124034731
						# Change = 0.992277846 * 13.406399198, -0.124034731 * 13.406399198 = 13.302872919, −1.662859118
						# Old values: -4, 8 :: 6, -9
						expect(a.velocity.x).toBeCloseTo -17.302872919
						expect(a.velocity.y).toBeCloseTo 6.337140882
						
						expect(b.velocity.x).toBeCloseTo 19.302872919
						expect(b.velocity.y).toBeCloseTo -7.337140882
					it "does not directly move either point", ->
						expect(a.location.x).toEqual 10
						expect(a.location.y).toEqual 2
						expect(b.location.x).toEqual 2
						expect(b.location.y).toEqual 1
					it "does not modify the material", ->
						expect(material).toEqual
							linearityScale: 0.5
							linearityShape: 2
							strength: 3
				describe "when the second point moves away from the first point", ->
					beforeEach ->
						b.location.x = -1
						b.location.y = 2
						result()
						# Distance: 8.062258
					extraTests()
					it "the points accelerate towards one another", ->
						# Difference: 5.385165 - 8.062258 = -2.677093
						# Delinearized: (((-2.677093 * 0.5) - 1.0) ^ 2.0) - 1.0 = 4.468799733
						# With strength: 4.468799733 * 3 = 13.406399198
						# Normal = (7 - -1) / 8.062258, (2 - 3) / 8.062258 = 0.992277846, -0.124034731
						# Change = 0.992277846 * 13.406399198, -0.124034731 * 13.406399198 = 13.302872919, −1.662859118
						# Old values: -4, 8 :: 6, -9
						expect(a.velocity.x).toBeCloseTo -17.302872919
						expect(a.velocity.y).toBeCloseTo 6.337140882
						
						expect(b.velocity.x).toBeCloseTo 19.302872919
						expect(b.velocity.y).toBeCloseTo -7.337140882
					it "does not directly move either point", ->
						expect(a.location.x).toEqual 7
						expect(a.location.y).toEqual 3
						expect(b.location.x).toEqual -1
						expect(b.location.y).toEqual 2
					it "does not modify the material", ->
						expect(material).toEqual
							linearityScale: 0.5
							linearityShape: 2
							strength: 3
		
		describe "without tensions or a gamepad", ->
			beforeEach ->
				result = link a, b, material
			
			go ->
		describe "with tensions but no gamepad", ->
			tensions = undefined
			beforeEach ->
				tensions = 
						controlA: 1.666666667
						controlB: 1.4
						controlC: 5
					
				result = link a, b, material, null, tensions
			
			go ->
				it "does not modify the tensions", ->
					expect(tensions).toEqual
						controlA: 1.666666667
						controlB: 1.4
						controlC: 5
		describe "without tensions but with an empty gamepad", ->
			gamepad = undefined
			beforeEach ->
				gamepad = {}
				result = link a, b, material, gamepad, null
			
			go ->
				it "does not modify the gamepad", ->
					expect(gamepad).toEqual {}
		describe "with tensions and a gamepad", ->
			tensions = gamepad = undefined
			beforeEach ->
				gamepad = {}
				tensions = 
						controlA: 1.666666667
						controlB: 1.4
						controlC: 5
				result = link a, b, material, gamepad, tensions
			describe "when no keys are defined", ->
				go ->
					it "does not modify the gamepad", ->
						expect(gamepad).toEqual {}
					it "does not modify the tensions", ->
						expect(tensions).toEqual
							controlA: 1.666666667
							controlB: 1.4
							controlC: 5
			describe "when all keys are false", ->
				beforeEach ->
					gamepad.controlA = false
					gamepad.controlB = false
					gamepad.controlD = false
				go ->
					it "does not modify the gamepad", ->
						expect(gamepad).toEqual
							controlA: false
							controlB: false
							controlD: false
					it "does not modify the tensions", ->
						expect(tensions).toEqual
							controlA: 1.666666667
							controlB: 1.4
							controlC: 5
			describe "when keys not matching tensions are pressed", ->
				beforeEach ->
					gamepad.controlA = false
					gamepad.controlB = false
					gamepad.controlD = true
				go ->
					it "does not modify the gamepad", ->
						expect(gamepad).toEqual
							controlA: false
							controlB: false
							controlD: true
					it "does not modify the tensions", ->
						expect(tensions).toEqual
							controlA: 1.666666667
							controlB: 1.4
							controlC: 5
			describe "when keys matching tensions are pressed", ->
				beforeEach ->
					gamepad.controlA = false
					gamepad.controlB = false
					gamepad.controlC = false
					gamepad.controlD = false
				it "does not modify either point", ->
					expect(a).toEqual
						location:
							x: 7
							y: 3
					expect(b).toEqual
						location:
							x: 2
							y: 1
				it "does not modify the material", ->
					expect(material).toEqual
						linearityScale: 0.5
						linearityShape: 2
						strength: 3
				it "does not modify the gamepad", ->
					expect(gamepad).toEqual
						controlA: false
						controlB: false
						controlC: false
						controlD: false
				it "does not modify the tensions", ->
					expect(tensions).toEqual
						controlA: 1.666666667
						controlB: 1.4
						controlC: 5
				it "returns a function", ->
					expect(result).toEqual jasmine.any Function
				describe "on calling the function", ->
					beforeEach ->
						a.velocity =  
							x: -4
							y: 8
						b.velocity =
							x: 6
							y: -9
						gamepad.controlA = true
						gamepad.controlC = true
						result()
					it "the points accelerate towards one another as though the link were scaled by the product of the activated tension controls", ->
						# Actual distance: 5.385165
						# Adjusted target distance: 5.385165 * 0.6 * 0.2 = 0.6462198
						# Distance difference = 0.6462198 - 5.385165 = 4.7389452
						# Delinearized: (((4.7389452 * 0.5) + 1.0) ^ 2.0) - 1.0 = 10.353345602
						# With strength: 10.353345602 * 3 = 31.060036806
						# Difference = 2 - 7, 1 - 3 = -5, -2
						# Normalized = -5 / 5.385165, -2 / 5.385165 = -0.928476658, -0.371390663
						# Velocity change = -0.928476658 * 31.060036806, -0.371390663 * 31.060036806 = -28.838519171, -11.535407662
						# Old values: -4, 8 :: 6, -9
						expect(a.velocity.x).toBeCloseTo -32.838519171
						expect(a.velocity.y).toBeCloseTo -3.535407662
						
						expect(b.velocity.x).toBeCloseTo 34.838519171
						expect(b.velocity.y).toBeCloseTo 2.535407662
					it "does not directly move either point", ->
						expect(a.location.x).toEqual 7
						expect(a.location.y).toEqual 3
						expect(b.location.x).toEqual 2
						expect(b.location.y).toEqual 1
					it "does not modify the material", ->
						expect(material).toEqual
							linearityScale: 0.5
							linearityShape: 2
							strength: 3
					it "does not modify the gamepad", ->
						expect(gamepad).toEqual
							controlA: true
							controlB: false
							controlC: true
							controlD: false
					it "does not modify the tensions", ->
						expect(tensions).toEqual
							controlA: 1.666666667
							controlB: 1.4
							controlC: 5