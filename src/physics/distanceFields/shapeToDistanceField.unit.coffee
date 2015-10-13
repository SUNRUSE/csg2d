describe "shapeToDistanceField", ->
	shapeToDistanceField = require "./shapeToDistanceField"
	describe "circle", ->
		circle = undefined
		beforeEach ->
			circle = shapeToDistanceField
				origin:
					x: 7
					y: 10
				radius: 4
		it "returns the distance to the surface when outside", ->
			expect(circle 3, 6).toBeCloseTo 1.656854
			expect(circle 2, 16).toBeCloseTo 3.810250
			expect(circle 11, 12).toBeCloseTo 0.472136
			expect(circle 10, 5).toBeCloseTo 1.830952
		it "returns the inverse of the distance when inside", ->
			expect(circle 10, 9).toBeCloseTo -0.837722
			expect(circle 7, 11).toBeCloseTo -3
	describe "rectangle", ->
		square = undefined
		beforeEach ->
			square = shapeToDistanceField
				left: 3
				top: 7
				width: 4
				height: 8
		it "returns the distance to the top left corner when beyond it", ->
			expect(square 2, 16.5).toBeCloseTo 1.807316
		it "returns the distance to the top right corner when beyond it", ->
			expect(square 8, 17.25).toBeCloseTo 2.462214
		it "returns the distance to the bottom left corner when beyond it", ->
			expect(square 2, 5).toBeCloseTo 2.236068
		it "returns the distance to the bottom right corner when beyond it", ->
			expect(square 8, 6.5).toBeCloseTo 1.118034
		it "returns the distance to the left wall when beyond it", ->
			expect(square 2, 8).toBeCloseTo 1
		it "returns the distance to the right wall when beyond it", ->
			expect(square 9, 13).toBeCloseTo 2
		it "returns the distance to the top wall when beyond it", ->
			expect(square 6, 18).toBeCloseTo 3
		it "returns the distance to the bottom wall when beyond it", ->
			expect(square 5, 3).toBeCloseTo 4
		it "returns the inverse of the distance to the left wall when inside it", ->
			expect(square 3.25, 13).toBeCloseTo -0.25
		it "returns the inverse of the distance to the right wall when inside it", ->
			expect(square 6.6, 9.5).toBeCloseTo -0.4
		it "returns the inverse of the distance to the top wall when inside it", ->
			expect(square 5.5, 14.5).toBeCloseTo -0.5
		it "returns the inverse of the distance to the bottom wall when inside it", ->
			expect(square 5, 8.5).toBeCloseTo -1.5