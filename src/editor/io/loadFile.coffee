mapToElements = require "./../dom/mapToElements"

# On calling, finds and listens for file uploads to the "openFile" input.  It
# then deserializes the JSON to an object and passes it to mapToElements.
module.exports = () ->
    openFile = document.getElementById "openFile"
    openFile.onchange = (e) -> for file in openFile.files
        fr = new FileReader()
        fr.onload = ->
            try
                mapToElements JSON.parse fr.result
            catch e
                alert "This file could not be read."
        fr.onabort = -> alert "Reading this file was aborted."
        fr.onerror = -> alert "This file could not be read."
        fr.readAsText(file)