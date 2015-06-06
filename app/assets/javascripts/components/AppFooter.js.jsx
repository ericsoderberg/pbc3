var AppFooter = React.createClass({
  
  propTypes: {
    menuActions: React.PropTypes.arrayOf(React.PropTypes.object),
    site: React.PropTypes.object
  },
 
  render: function() {
    var site = this.props.site;
    var copyright = site.copyright.replace('&copy;', '\u00a9');
    
    var items = [];
    if (this.props.menuActions) {
      items = this.props.menuActions.map(function (action, index) {
        return (
          <li key={index} className="app-footer__action">
            <a href={action.url}>{action.label}</a>
          </li>
        );
      });
    }
    
    return (
      <footer className="app-footer">
        <ol className="app-footer__actions list-bare">
          {items}
        </ol>
        <div className="app-footer__summary">
          <a className="app-footer__address" href={"http://maps.apple.com/?q=" + site.address}>
            {site.address}
          </a>
          <div className="app-footer__phone">
            {site.phone}
          </div>
          <div className="app-footer__copyright">
            {copyright}
          </div>
        </div>
      </footer>
    );
  }
});

module.exports = AppFooter;
