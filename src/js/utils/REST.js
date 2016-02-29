import request from 'superagent';

let _headers = {
  'Accept': 'application/json',
  'Content-Type': 'application/json'
};

// convert params to string, to deal with array values
function buildQueryParams(params) {
  var result = [];
  for (var property in params) {
    if (params.hasOwnProperty(property)) {
      var value = params[property];
      if (null !== value && undefined !== value) {
        if (Array.isArray(value)) {
          for (var i = 0; i < value.length; i++) {
            result.push(property + '=' + value[i]);
          }
        } else {
          result.push(property + '=' + value);
        }
      }
    }
  }
  return result.join('&');
}

export default {

  get (uri, params) {
    var op = request.get(uri).query(buildQueryParams(params));
    op.set(_headers);
    return op;
  },

  post (uri, token, data) {
    var op = request.post(uri).send(data);
    op.timeout(_timeout);
    op.set({..._headers, ...{'X-CSRF-Token': token}});
    return op;
  },

  put (uri, token, data) {
    var op = request.put(uri).send(data);
    op.timeout(_timeout);
    op.set({..._headers, ...{'X-CSRF-Token': token}});
    return op;
  },

  patch (uri, token, data) {
    var op = request.patch(uri).send(data);
    op.timeout(_timeout);
    op.set({..._headers, ...{'X-CSRF-Token': token}});
    return op;
  },

  del (uri, token) {
    var op = request.del(uri);
    op.timeout(_timeout);
    op.set({..._headers, ...{'X-CSRF-Token': token}});
    return op;
  }

};
