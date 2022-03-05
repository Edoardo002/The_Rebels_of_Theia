function get_md(token_id) { //return metadata json
  var xhr = new XMLHttpRequest();
    xhr.open("GET", "https://metadata_server_URL/metadata/"+token_id, false);
    xhr.send();

    // stop the engine while xhr isn't done
    for(; xhr.readyState !== 4;)

    if (xhr.status === 200) {

        console.log('SUCCESS', xhr.responseText);

    } else console.warn('request_error');

    return JSON.parse(xhr.responseText);
}

function pin(metadata_json) {  //return json_URI
  var xhr = new XMLHttpRequest();
    xhr.open("POST", "https://metadata_server_URL/metadata/jsonblobs", false);
    xhr.send(metadata_json);

    // stop the engine while xhr isn't done
    for(; xhr.readyState !== 4;)

    if (xhr.status === 200) {

        console.log('SUCCESS', xhr.responseText);

    } else console.warn('request_error');

    return xhr.responseText;
}