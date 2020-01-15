let loginForm, fileForm;

let accessToken = null;
let activeProfile = null;

function createXHR(method, url, callback) {
    let xhr = new XMLHttpRequest();
    xhr.onreadystatechange = callback;
    xhr.open(method, url);
    if (accessToken != null)
        xhr.setRequestHeader('Authorization', `Bearer ${accessToken}`);
    return xhr;
}

function login() {
    // Make sure the access token is blank
    accessToken = null;
    let email = loginForm.email.value;
    let password = loginForm.password.value;
    let xhr = new XMLHttpRequest();
    xhr.onreadystatechange = function() {
        if (xhr.readyState == XMLHttpRequest.DONE) {
            if (xhr.status == 200) {
                try {
                    let responseJSON = JSON.parse(xhr.responseText);
                    if (responseJSON['token_type'].toLowerCase() == 'bearer') {
                        accessToken = responseJSON['access_token'];
                    }
                    if (typeof accessToken != 'string') {
                        // If the access token is bad, abort
                        accessToken = null;
                        alert(`Login failed: could not understand response from server.`);
                    } else {
                        // If we've logged in, hide the login form
                        document.querySelector('div#login').style.display = 'none';
                        // And select a profile
                        loadProfileList();
                    }
                } catch (ex) {
                    alert(`Login failed: could not understand response. ${ex}`);
                }
            } else {
                alert(`Login failed: ${xhr.status} ${xhr.statusText}`);
            }
        }
    }
    xhr.open('POST', '/oauth/token');
    xhr.setRequestHeader('Content-type', 'application/json')
    xhr.send(JSON.stringify({email: email, password: password, grant_type: 'password'}));
}

function loadProfileList() {
    let container = document.querySelector('div#profile-list');
    // Show the list
    container.style.display = 'block';
    let listContainer = container.querySelector('.profiles');
    listContainer.innerHTML = 'Loading...';
    let xhr = createXHR('GET', 'api/v1/profiles', function() {
        if (this.readyState == XMLHttpRequest.DONE) {
            if (this.status == 200) {
                try {
                    let json = JSON.parse(this.responseText);
                    if (Array.isArray(json)) {
                        let list = document.createElement('ul');
                        listContainer.innerHTML = '';
                        listContainer.append(list);
                        let firstValidProfile = null;
                        for (let profile of json) {
                            let li = document.createElement('li');
                            let id = profile.id;
                            if (typeof id != 'number') {
                                li.append('Bad profile');
                            } else {
                                li.append(profile.name ? profile.name : 'Profile ' + profile.id);
                                li.setAttribute('id', 'profile-' + id);
                                li.setAttribute('data-profile-id', id);
                                li.addEventListener('click', function(event) {
                                    selectProfile(this.getAttribute('data-profile-id'));
                                });
                                if (firstValidProfile == null)
                                    firstValidProfile = id;
                            }
                            list.append(li);
                        }
                        if (firstValidProfile != null)
                            selectProfile(firstValidProfile);
                    } else {
                        listContainer.innerHTML = 'Error loading profile list: cannot understand response from server'
                        console.log(this.responseText);
                    }
                } catch (ex) {
                    listContainer.innerHTML = 'Error loading profile list: ';
                    listContainer.append(ex.toString());
                    console.log(ex);
                }
            }
        }
    });
    xhr.send();
}

function selectProfile(profileId) {
    console.log('Selecting profile ' + profileId);
    activeProfile = profileId;
    loadUploadedList();
}

function loadUploadedList() {
    let container = document.querySelector('div#upload-list');
    container.innerHTML = 'Loading...';
    // Make visible if not already
    document.querySelector('#file-upload').style.display = 'block';
    container.style.display = 'block';
    let xhr = createXHR('GET', `/api/pilot/uploaded_documents?profile_id=${activeProfile}`, function() {
        if (this.readyState == XMLHttpRequest.DONE) {
            if (this.status == 200) {
                // [{"id":1,"profile_id":1,"created_at":"2019-12-17T14:27:13.461Z","updated_at":"2019-12-17T14:27:13.469Z"}]
                let json = JSON.parse(this.responseText);
                if (Array.isArray(json)) {
                    if (json.length == 0) {
                        container.innerHTML = 'None';
                    } else {
                        let list = document.createElement('ul');
                        container.innerHTML = '';
                        container.append(list);
                        for (let file of json) {
                            let li = document.createElement('li');
                            let a = document.createElement('a');
                            a.setAttribute('href', `/api/pilot/uploaded_documents/${file.id}/download?access_token=${accessToken}`);
                            a.append(`${file.filename} - Uploaded ${file.created_at}`);
                            li.append(a);
                            list.append(li);
                        }
                    }
                } else {
                    container.innerHTML = 'Error: Unable to understand response from server';
                }
            } else {
                container.innerHTML = `Error loading document list: ${this.status} ${this.statusText}`;
            }
        }
    });
    xhr.send();
}

function uploadFile() {
    let loading = document.createElement('div');
    loading.append('Uploading file...');
    fileForm.append(loading);
    let xhr = createXHR('POST', '/api/pilot/uploaded_documents', function() {
        // TODO: Show progress?
        if (this.readyState == XMLHttpRequest.DONE) {
            // Remove the loading indicator
            loading.remove();
            console.log(xhr);
            loadUploadedList();
        }
    });
    let formData = new FormData();
    formData.set('uploaded_document[profile_id]', activeProfile.toString());
    formData.set('uploaded_document[document]', fileForm.document.files[0]);
    xhr.send(formData);
}

document.addEventListener('DOMContentLoaded', function() {
    // Find the login form and attach to it
    loginForm = document.querySelector('#login form');
    if (loginForm == null) {
        alert('Error loading page');
        return;
    }
    loginForm.addEventListener('submit', function(event) {
        try {
            login();
        } catch (ex) {
            console.log(ex);
            alert("Exception submitting form: " + ex);
        }
        event.preventDefault();
        return false;
    });
    loginForm.querySelector('input[type=submit]').disabled = false;
    fileForm = document.querySelector('div#file-upload form');
    fileForm.addEventListener('submit', function(event) {
        try {
            uploadFile();
        } catch (ex) {
            console.log(ex);
            alert('Error uploading file: ' + ex);
        }
        event.preventDefault();
    });
});