var AppHeader = React.createClass({

  propTypes: {
    logo: React.PropTypes.node,
    rootPath: React.PropTypes.string
  },

  render: function() {
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
