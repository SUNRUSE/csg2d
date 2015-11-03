# Given an element representing a shape in the editor, returns the map JSON shape it represents.
module.exports = (element) ->
	output = 
		operator: element.getAttribute "operator"
		
	output.shape = switch element.getAttribute "shape"
		when "circle"
			radius: (parseInt element.style.width) / 2
			origin:
				x: (parseInt element.style.left) + ((parseInt element.style.width) / 2)
				y: (parseInt element.style.top) + ((parseInt element.style.width) / 2)
		else
			left: (parseInt element.style.left)
			top: (parseInt element.style.top)
			width: (parseInt element.style.width)
			height: (parseInt element.style.height)
			ramp: if (element.getAttribute "shape") is "ramp" then element.getAttribute "position"
		
	output