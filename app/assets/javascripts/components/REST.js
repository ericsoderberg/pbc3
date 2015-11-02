var REST = {

  get: function (uri, finished) {
    this._xhr = new XMLHttpRequest();
    this._xhr.open('GET', uri);
    this._xhr.setRequestHeader("Content-Type", "application/json");
    this._xhr.setRequestHeader("Accept", "application/json");
    this._xhr.onreadystatechange = function () {
      if (this._xhr.readyState == 4 && this._xhr.status == 200) {
        var response = JSON.parse(this._xhr.responseText);
        finished(response);
      }
    }.bind(this);
    this._xhr.send();
  },

  post: function (uri, token, dataObject, finished) {
    this._xhr = new XMLHttpRequest();
    this._xhr.open('POST', uri);
    this._xhr.setRequestHeader("Content-Type", "application/json");
    this._xhr.setRequestHeader("Accept", "application/json");
    this._xhr.setRequestHeader("X-CSRF-Token", token);
    this._xhr.onreadystatechange = function () {
      if (this._xhr.readyState == 4 && this._xhr.status == 200) {
        var response = JSON.parse(this._xhr.responseText);
        finished(response);
      }
    }.bind(this);
    this._xhr.send(JSON.stringify(dataObject));
  },

  patch: function (uri, token, dataObject, finished) {
    this._xhr = new XMLHttpRequest();
    this._xhr.open('PATCH', uri);
    this._xhr.setRequestHeader("Content-Type", "application/json");
    this._xhr.setRequestHeader("Accept", "application/json");
    this._xhr.setRequestHeader("X-CSRF-Token", token);
    this._xhr.onreadystatechange = function () {
      if (this._xhr.readyState == 4 && this._xhr.status == 200) {
        var response = JSON.parse(this._xhr.responseText);
        finished(response);
      }
    }.bind(this);
    this._xhr.send(JSON.stringify(dataObject));
  },

  delete: function (uri, finished) {
    this._xhr = new XMLHttpRequest();
    this._xhr.open('DELETE', uri);
    this._xhr.onreadystatechange = function () {
      if (this._xhr.readyState == 4 && this._xhr.status == 204) {
        finished();
      }
    }.bind(this);
    this._xhr.send();
  }

};

module.exports = REST;
