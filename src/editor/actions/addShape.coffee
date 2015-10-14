addElement = require "./addElement"
shapeToElement = require "./../dom/shapeToElement"
pixelsPerRem = require "./../dom/pixelsPerRem"

# Call with:
# - A string specifying the shape to add.
# - A string specifying the operator to add using.
# To create a new shape in the middle of the viewport.
module.exports = (shape, operator) ->
	addElement (shapeToElement
		operator: operator
		shape: switch shape
			when "circle"
				origin:
					x: Math.round((window.pageXOffset + (window.innerWidth / 2)) / pixelsPerRem)
					y: Math.round((window.pageYOffset + (window.innerHeight / 2)) / pixelsPerRem)
				radius: Math.max(1, Math.round(Math.min(window.innerWidth, window.innerHeight) / 4 / pixelsPerRem))
			when "rectangle"
				left: Math.round((window.pageXOffset + (window.innerWidth / 4)) / pixelsPerRem)
				top: Math.round((window.pageYOffset + (window.innerHeight / 4)) / pixelsPerRem)
				width: Math.max(1, Math.round((window.innerWidth / 2) / pixelsPerRem))
				height: Math.max(1, Math.round((window.innerHeight / 2) / pixelsPerRem))), "shapes"