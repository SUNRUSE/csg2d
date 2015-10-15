addElement = require "./../addElement"
entityToElement = require "./../../dom/entityToElement"
pixelsPerRem = require "./../../dom/pixelsPerRem"
getUniqueEntityNameByType = require "./getUniqueEntityNameByType"

# Adds a new player entity in the middle of the viewport.
module.exports = () ->
	addElement (entityToElement "player", (getUniqueEntityNameByType "player"), 
		origin: 
			x: Math.round (window.pageXOffset + window.innerWidth / 2) / pixelsPerRem
			y: Math.round (window.pageYOffset + window.innerHeight / 2) / pixelsPerRem
		facing: "right"), "entities"