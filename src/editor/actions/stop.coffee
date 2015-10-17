# On calling, switches the editor to "edit" mode, deleting the player element and restoring all editor controls.
module.exports = () ->
	document.body.setAttribute "mode", "edit"