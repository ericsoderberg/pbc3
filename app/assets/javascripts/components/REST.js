var REST = {
  
  get: function (uri, finished) {
    this._xhr = new XMLHttpRequest();
    this._xhr.open('GET', uri);
    this._xhr.setRequestHeader("Content-Type", "application/json");
    this._xhr.setRequestHeader("Accept", "application/json");
    this._xhr.onreadystatechange = function () {
      if (this._xhr.readyState == 4  && this._xhr.status == 200) {
        var response = JSON.parse(this._xhr.responseText);
        finished(response);
      }
    }.bind(this);
    this._xhr.send();
  }
  
};

module.exports = REST;
