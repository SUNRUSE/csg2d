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
	describe "ramp", ->
		describe "top left", ->
			ramp = undefined
			beforeEach ->
				ramp = shapeToDistanceField
					left: 3
					width: 8
					top: 6
					height: 4
					ramp: "topLeft"
			it "returns the distance to the left side when beyond it", ->
				expect(ramp 2.5, 8).toBeCloseTo 0.5
			it "returns the distance to the top side when beyond it", ->
				expect(ramp 6, 4).toBeCloseTo 2
			it "returns the distance to the diagonal side when beyond it", ->
				expect(ramp 9.5, 10.5).toBeCloseTo 3.35
			it "returns the inverse of the distance to the left side when inside it", ->
				expect(ramp 3.25, 8).toBeCloseTo -0.25
			it "returns the inverse of the distance to the top side when inside it", ->
				expect(ramp 6, 7).toBeCloseTo -1
			it "returns the inverse of the distance to the diagonal side when inside it", ->
				expect(ramp 5.5, 7.5).toBeCloseTo -1.118
			it "returns the distance to the top left corner when beyond it", ->
				expect(ramp 2.59, 10.8).toBeCloseTo 0.899
			it "returns the distance to the bottom left corner when beyond it", ->
				expect(ramp 2.53, 4.84).toBeCloseTo 1.251
			it "returns the distance to the top right corner when beyond it", ->
				expect(ramp 12.06, 5.578).toBeCloseTo 1.139
		describe "top right", ->
			ramp = undefined
			beforeEach ->
				ramp = shapeToDistanceField
					left: 3
					width: 8
					top: 6
					height: 4
					ramp: "topRight"
			it "returns the distance to the right side when beyond it", ->
				expect(ramp 11.5, 8).toBeCloseTo 0.5
			it "returns the distance to the top side when beyond it", ->
				expect(ramp 6, 4).toBeCloseTo 2
			it "returns the distance to the diagonal side when beyond it", ->
				expect(ramp 9, 10).toBeCloseTo 0.894
			it "returns the inverse of the distance to the right side when inside it", ->
				expect(ramp 9.25, 8.5).toBeCloseTo -0.559
			it "returns the inverse of the distance to the top side when inside it", ->
				expect(ramp 6, 6.5).toBeCloseTo -0.5
			it "returns the inverse of the distance to the diagonal side when inside it", ->
				expect(ramp 10.75, 8.5).toBeCloseTo -0.25
			it "returns the distance to the top right corner when beyond it", ->
				expect(ramp 12.06, 5.578).toBeCloseTo 1.139
				expect(ramp 11.386, 5.08).toBeCloseTo 0.998
			it "returns the distance to the bottom right corner when beyond it", ->
				expect(ramp 11.66395, 10.27325).toBeCloseTo 0.72
			it "returns the distance to the top left corner when beyond it", ->
				expect(ramp 2.59, 5.53553).toBeCloseTo 0.623
		describe "bottom left", ->
			ramp = undefined
			beforeEach ->
				ramp = shapeToDistanceField
					left: 3
					width: 8
					top: 6
					height: 4
					ramp: "bottomLeft"
			it "returns the distance to the left side when beyond it", ->
				expect(ramp 2.5, 8).toBeCloseTo 0.5
			it "returns the distance to the bottom side when beyond it", ->
				expect(ramp 6, 12).toBeCloseTo 2
			it "returns the distance to the diagonal side when beyond it", ->
				expect(ramp 6.5, 6.5).toBeCloseTo 1.12
			it "returns the inverse of the distance to the left side when inside it", ->
				expect(ramp 3.25, 8).toBeCloseTo -0.25
			it "returns the inverse of the distance to the bottom side when inside it", ->
				expect(ramp 6, 9).toBeCloseTo -1
			it "returns the inverse of the distance to the diagonal side when inside it", ->
				expect(ramp 5.5, 8.5).toBeCloseTo -1.12
			it "returns the distance to the bottom left corner when beyond it", ->
				expect(ramp 2.53, 4.84).toBeCloseTo 1.251
			it "returns the distance to the top left corner when beyond it", ->
				expect(ramp 2.59, 10.8).toBeCloseTo 0.899
			it "returns the distance to the bottom right corner when beyond it", ->
				expect(ramp 11.62, 10.69).toBeCloseTo 0.931
		describe "bottom right", ->
			ramp = undefined
			beforeEach ->
				ramp = shapeToDistanceField
					left: 3
					width: 8
					top: 6
					height: 4
					ramp: "bottomRight"
			it "returns the distance to the right side when beyond it", ->
				expect(ramp 11.5, 8).toBeCloseTo 0.5
			it "returns the distance to the bottom side when beyond it", ->
				expect(ramp 6, 12).toBeCloseTo 2
			it "returns the distance to the diagonal side when beyond it", ->
				expect(ramp 6, 6).toBeCloseTo 2.236
			it "returns the inverse of the distance to the right side when inside it", ->
				expect(ramp 10.5, 8).toBeCloseTo -0.5
			it "returns the inverse of the distance to the bottom side when inside it", ->
				expect(ramp 6, 9.5).toBeCloseTo -0.5
			it "returns the inverse of the distance to the diagonal side when inside it", ->
				expect(ramp 7.25, 8.5).toBeCloseTo -0.559
			it "returns the distance to the bottom right corner when beyond it", ->
				expect(ramp 11.62, 10.69).toBeCloseTo 0.931
			it "returns the distance to the top right corner when beyond it", ->
				expect(ramp 12.06, 5.578).toBeCloseTo 1.139
				expect(ramp 11.386, 5.08).toBeCloseTo 0.998
			it "returns the distance to the bottom left corner when beyond it", ->
				expect(ramp 2.3, 9.66).toBeCloseTo 0.78
				expect(ramp 2.82, 10.83).toBeCloseTo 0.85