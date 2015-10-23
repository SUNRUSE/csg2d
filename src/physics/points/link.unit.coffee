describe "link", ->
	rewire = require "rewire"
	link = undefined
	beforeEach -> link = rewire "./link"
	
	describe "on calling", ->
		a = b = result = undefined
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
			result = link a, b, 0.5, 2
		it "does not modify either point", ->
			expect(a).toEqual
				location:
					x: 7
					y: 3
			expect(b).toEqual
				location:
					x: 2
					y: 1
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
				it "does not modify either point", ->
					expect(a.location.x).toEqual 7
					expect(a.location.y).toEqual 3
					expect(a.velocity.x).toEqual -4
					expect(a.velocity.y).toEqual 8
					
					expect(b.location.x).toEqual 2
					expect(b.location.y).toEqual 1
					expect(b.velocity.x).toEqual 6
					expect(b.velocity.y).toEqual -9
			describe "when the points move without changing distance", ->
				beforeEach ->
					a.location.x = 9
					a.location.y = 1
					b.location.x = 4
					b.location.y = -1 
					result()
				it "does not modify either point", ->
					expect(a.location.x).toEqual 9
					expect(a.location.y).toEqual 1
					expect(a.velocity.x).toEqual -4
					expect(a.velocity.y).toEqual 8
					
					expect(b.location.x).toEqual 4
					expect(b.location.y).toEqual -1
					expect(b.velocity.x).toEqual 6
					expect(b.velocity.y).toEqual -9
			describe "when the points change orientation without changing distance", ->
				beforeEach ->
					a.location.x = 5
					a.location.y = 0
					b.location.x = 3
					b.location.y = 5 
					result()
				it "does not modify either point", ->
					expect(a.location.x).toEqual 5
					expect(a.location.y).toEqual 0
					expect(a.velocity.x).toEqual -4
					expect(a.velocity.y).toEqual 8
					
					expect(b.location.x).toEqual 3
					expect(b.location.y).toEqual 5
					expect(b.velocity.x).toEqual 6
					expect(b.velocity.y).toEqual -9
			describe "when the first point moves closer to the second point", ->
				beforeEach ->
					a.location.x = 6
					a.location.y = 2
					result()
					# Distance: 4.123106
				it "the points accelerate away from one another", ->
					# Difference: 5.385165 - 4.123106 = 1.262059
					# Apply strength and delinearization: (1.262059 * 0.5) ^ 2.0 = 0.39819823
					# Normal = (6 - 2) / 4.123106, (2 - 1) / 4.123106 = 0.970142412, 0.242535603
					# Change = 0.970142412 * 0.39819823, 0.242535603 * 0.39819823 = 0.386308991, 0.096577248
					# Old values: -4, 8 :: 6, -9
					expect(a.velocity.x).toBeCloseTo -4.386308991
					expect(a.velocity.y).toBeCloseTo 7.903422752
					
					expect(b.velocity.x).toBeCloseTo 6.386308991
					expect(b.velocity.y).toBeCloseTo -8.903422752
				it "does not directly move either point", ->
					expect(a.location.x).toEqual 6
					expect(a.location.y).toEqual 2
					expect(b.location.x).toEqual 2
					expect(b.location.y).toEqual 1
			describe "when the second point moves closer to the first point", ->
				beforeEach ->
					b.location.x = 3
					b.location.y = 2
					result()
					# Distance: 4.123106
				it "the points accelerate away from one another", ->
					# Difference: 5.385165 - 4.123106 = 1.262059
					# Apply strength and delinearization: (1.262059 * 0.5) ^ 2.0 = 0.39819823
					# Normal = (6 - 2) / 4.123106, (2 - 1) / 4.123106 = 0.970142412, 0.242535603
					# Change = 0.970142412 * 0.39819823, 0.242535603 * 0.39819823 = 0.386308991, 0.096577248
					# Old values: -4, 8 :: 6, -9
					expect(a.velocity.x).toBeCloseTo -4.386308991
					expect(a.velocity.y).toBeCloseTo 7.903422752
					
					expect(b.velocity.x).toBeCloseTo 6.386308991
					expect(b.velocity.y).toBeCloseTo -8.903422752
				it "does not directly move either point", ->
					expect(a.location.x).toEqual 7
					expect(a.location.y).toEqual 3
					expect(b.location.x).toEqual 3
					expect(b.location.y).toEqual 2
			describe "when the first point moves away from the second point", ->
				beforeEach ->
					a.location.x = 10
					a.location.y = 2
					result()
					# Distance: 8.062258
				it "the points accelerate towards one another", ->
					# Difference: 5.385165 - 8.062258 = -2.677093
					# Apply strength and delinearization: (-2.677093 * 0.5) ^ 2.0 = 1.791706733
					# Normal = (7 - -1) / 8.062258, (2 - 3) / 8.062258 = 0.992277846, -0.124034731
					# Change = 0.992277846 * 1.791706733, -0.124034731 * 1.791706733 = 1.777870898, −0.222233863
					# Old values: -4, 8 :: 6, -9
					expect(a.velocity.x).toBeCloseTo -5.777870898
					expect(a.velocity.y).toBeCloseTo 7.777766137
					
					expect(b.velocity.x).toBeCloseTo 7.777870898
					expect(b.velocity.y).toBeCloseTo -8.777766137
				it "does not directly move either point", ->
					expect(a.location.x).toEqual 10
					expect(a.location.y).toEqual 2
					expect(b.location.x).toEqual 2
					expect(b.location.y).toEqual 1
			describe "when the second point moves away from the first point", ->
				beforeEach ->
					b.location.x = -1
					b.location.y = 2
					result()
					# Distance: 8.062258
				it "the points accelerate towards one another", ->
					# Difference: 5.385165 - 8.062258 = -2.677093
					# Apply strength and delinearization: (-2.677093 * 0.5) ^ 2.0 = 1.791706733
					# Normal = (7 - -1) / 8.062258, (2 - 3) / 8.062258 = 0.992277846, -0.124034731
					# Change = 0.992277846 * 1.791706733, -0.124034731 * 1.791706733 = 1.777870898, −0.222233863
					# Old values: -4, 8 :: 6, -9
					expect(a.velocity.x).toBeCloseTo -5.777870898
					expect(a.velocity.y).toBeCloseTo 7.777766137
					
					expect(b.velocity.x).toBeCloseTo 7.777870898
					expect(b.velocity.y).toBeCloseTo -8.777766137
				it "does not directly move either point", ->
					expect(a.location.x).toEqual 7
					expect(a.location.y).toEqual 3
					expect(b.location.x).toEqual -1
					expect(b.location.y).toEqual 2