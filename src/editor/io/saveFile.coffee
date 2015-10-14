# Given a filename and a JSON object, downloads the JSON object as the filename to the client.
module.exports = (filename, content) ->
    json = JSON.stringify content
    if window.navigator.msSaveBlob
        blob = new Blob [json], 
            type: "application/json;charset=utf-8;"
        window.navigator.msSaveBlob blob, filename
    else
        el = document.createElement "a"
        el.setAttribute "href", "data:application/json;charset=utf-8," + encodeURIComponent json
        el.setAttribute "download", filename
        document.body.appendChild el
        el.click()
        document.body.removeChild el