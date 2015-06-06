var Menu = require('./Menu');
var MenuIcon = require('./MenuIcon');

var AppHeader = React.createClass({
  
  propTypes: {
    logo: React.PropTypes.node,
    menuActions: React.PropTypes.arrayOf(React.PropTypes.object),
    rootPath: React.PropTypes.string
  },
 
  render: function() {
    var icon = (<MenuIcon />);
    
    return (
      <header className="app-header">
        <div className="app-header__contents">
          <a className="app-header__site" href={this.props.rootPath}>
            <img src={this.props.logo} />
          </a>
        </div>
      </header>
    );
  }
});

module.exports = AppHeader;
