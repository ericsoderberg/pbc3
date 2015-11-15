var AppHeader = require('./AppHeader');
var AppFooter = require('./AppFooter');
var Router = require('./Router');
var REST = require('./REST');

var Page = require('./Page');
var Search = require('./Search');
var Pages = require('./Pages');
var Accounts = require('./Accounts');
var Calendar = require('./Calendar');
var Holidays = require('./Holidays');
var Messages = require('./Messages');
var Message = require('./Message');
var Resources = require('./Resources');
var Forms = require('./Forms');
var FilledForms = require('./FilledForms');
var Newsletters = require('./Newsletters');

var ROUTES = [
  {path: '/search', type: Search},
  {path: '/pages', type: Pages},
  {path: '/calendar', type: Calendar},
  {path: '/messages/(.+)', type: Message},
  {path: '/messages', type: Messages},
  {path: '/accounts', type: Accounts},
  {path: '/resources', type: Resources},
  {path: '/holidays', type: Holidays},
  {path: '/newsletters', type: Newsletters},
  {path: '/forms/[^/]+/fills', type: FilledForms},
  {path: '/forms', type: Forms},
  {path: '/(.*)', type: Page}
];

var App = React.createClass({

  /*propTypes: {
    app: React.PropTypes.shapeOf({
      content: React.PropTypes.object,
      logoUrl: React.PropTypes.string,
      menuActions: React.PropTypes.arrayOf(React.PropTypes.object),
      requestPath: React.PropTypes.string,
      site: React.PropTypes.object
    })
  },*/

  _onChangePath: function (path) {
    //console.log('!!! App _onChangePath', path);
    REST.get(path, function (response) {
      this.setState({
        path: path,
        content: response
      });
    }.bind(this));
  },

  getInitialState: function () {
    return {
      path: this.props.app.requestPath,
      content: this.props.app.content
    };
  },

  componentWillMount: function () {
    Router.initialize(ROUTES);
  },

  componentDidMount: function () {
    Router.run(this._onChangePath);
  },

  render: function () {
    var app = this.props.app;

    var contents = Router.getElement(this.state.path, this.state.content);

    return (
      <div className="app">
        <AppHeader site={app.site} logo={app.logoUrl}
          rootPath={app.rootPath} />
        {contents}
        <AppFooter site={app.site} menuActions={app.menuActions} />
      </div>
    );
  }
});

module.exports = App;
