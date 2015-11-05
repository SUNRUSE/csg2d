# Given:
# - The object returned by ./points/loadRig.
# - An equivalent to the ./../input/gamepad object.
# - An instance of a ./points/scene.
# Manipulates the rig every scene tick in response to gamepad input to implement manuals, pushing and braking.
module.exports = (rig, gamepad, scene) ->
	scene.append ->
		if rig.points.leftWheel.colliding
			if gamepad.leanLeft
				rig.points.rightWheel.velocity.y -= 0.1
			if gamepad.leanRight
				rig.points.rightWheel.velocity.y += 0.1
		if rig.points.rightWheel.colliding
			if gamepad.leanLeft
				rig.points.leftWheel.velocity.y += 0.1
			if gamepad.leanRight
				rig.points.leftWheel.velocity.y -= 0.1