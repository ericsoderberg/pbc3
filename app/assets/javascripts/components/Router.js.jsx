var REST = require('./REST');

var Router = {
  
  _notify: function (path) {
    if (this._handler && this._currentPath !== path) {
      this._handler(path);
    }
    this.current_path = path;
  },
  
  _onPopState: function (event) {
    var path = document.location.pathname;
    var query = document.location.search;
    //console.log('!!! Router _onPopState', path + query);
    this._notify(path + query);
  },
  
  _getRoute: function (path) {
    var result = null;
    path = path.split('?')[0]; // strip query parameters
    this._routes.some(function (route) {
      var match = path.match(route.path);
      if (match) {
        result = route; 
        return true;
      }
    });
    return result;
  },
  
  initialize: function (routes) {
    this._routes = routes;
    this._routes.forEach(function (route) {
      route.factory = React.createFactory(route.type);
    });
  },
  
  getElement: function (path, content) {
    //console.log('!!! Router getElement', path, content);
    props = {key: path};
    for (var name in content) {
      if (content.hasOwnProperty(name)) {
        props[name] = content[name];
      }
    }
    var element;
    var route = this._getRoute(path);
    if (route) {
      element = route.factory(props);
    } else {
      element = (<div>No route</div>);
    }
    return element;
  },
  
  run: function (handler) {
    //console.log('!!! Router run');
    this._currentPath = document.location.pathname + document.location.search;
    this._handler = handler;
    window.addEventListener('popstate', this._onPopState.bind(this));
  },
  
  push: function (path, load) {
    //console.log('!!! Router push', path);
    history.pushState(null, null, path);
    if (load) {
      this._notify(path);
    } else {
      this._currentPath = path
    }
  },
  
  replace: function (path, load) {
    //console.log('!!! Router replace', path);
    history.replaceState(null, null, path);
    if (load) {
      this._notify(path);
    } else {
      this._currentPath = path
    }
  }
};

module.exports = Router;
