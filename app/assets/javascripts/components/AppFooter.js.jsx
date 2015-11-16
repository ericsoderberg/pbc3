var REST = require('./REST');

var AppFooter = React.createClass({

  propTypes: {
    menuActions: React.PropTypes.arrayOf(
      React.PropTypes.arrayOf(React.PropTypes.object)),
    site: React.PropTypes.object
  },

  render: function() {
    var site = this.props.site;
    var copyright = site.copyright.replace('&copy;', '\u00a9');

    var actions = [];
    if (this.props.menuActions) {
      actions = this.props.menuActions.map(function (actions, index) {
        items = actions.map(function (action, index) {
          var control;
          if ('delete' === action.method) {
            control = (
              <form action={action.url} method="post">
                <input name="_method" type="hidden" value="delete" />
                <input name="authenticity_token" type="hidden" value={action.token} />
                <input type="submit" value={action.label} className="anchor" />
              </form>
            );
          } else {
            control = <a href={action.url}>{action.label}</a>;
          }
          return (
            <li key={index} className="app-footer__action">
              {control}
            </li>
          )
        }, this);
        return (
          <li key={index}>
            <ol className="app-footer__actions-set list-bare">
              {items}
            </ol>
          </li>
        );
      }, this);
    }

    return (
      <footer className="app-footer">
        <ol className="app-footer__actions list-bare">
          {actions}
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
