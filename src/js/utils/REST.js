import superagent from 'superagent';
import PromisePoly from 'es6-promise';
import superagentPromise from 'superagent-promise';

let agent = superagentPromise(superagent, Promise || PromisePoly);

let _headers = {
  'Accept': 'application/json',
  'Content-Type': 'application/json'
};

const _timeout = 10000; // 10s

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
    var op = agent.get(uri).query(buildQueryParams(params));
    op.set(_headers);
    return op.end();
  },

  post (uri, token, data) {
    var op = agent.post(uri).send(data);
    op.timeout(_timeout);
    op.set({..._headers, ...{'X-CSRF-Token': token}});
    return op.end();
  },

  put (uri, token, data) {
    var op = agent.put(uri).send(data);
    op.timeout(_timeout);
    op.set({..._headers, ...{'X-CSRF-Token': token}});
    return op.end();
  },

  patch (uri, token, data) {
    var op = agent.patch(uri).send(data);
    op.timeout(_timeout);
    op.set({..._headers, ...{'X-CSRF-Token': token}});
    return op.end();
  },

  del (uri, token) {
    var op = agent.del(uri);
    op.timeout(_timeout);
    op.set({..._headers, ...{'X-CSRF-Token': token}});
    return op.end();
  }

};
