import React, { Component, PropTypes } from 'react';
import { Link } from 'react-router';

export default class AppFooter extends Component {

  render () {
    const { site: {address, phone, menuActions} } = this.props;
    const copyright = (this.props.site && this.props.site.copyright ?
      this.props.site.copyright.replace('&copy;', '\u00a9') : '');

    let actions = [];
    if (menuActions) {
      actions = menuActions.map((actions, index) => {
        const items = actions.map((action, index) => {
          let control;
          if ('delete' === action.method) {
            control = (
              <form action={action.url} method="post">
                <input name="_method" type="hidden" value="delete" />
                <input name="authenticity_token" type="hidden" value={action.token} />
                <input type="submit" value={action.label} className="anchor" />
              </form>
            );
          } else if (action.path) {
            control = <Link to={action.path}>{action.label}</Link>;
          } else {
            control = <a href={action.url}>{action.label}</a>;
          }
          return (
            <li key={index} className="app-footer__action">
              {control}
            </li>
          );
        });
        return (
          <li key={index}>
            <ol className="app-footer__actions-set list-bare">
              {items}
            </ol>
          </li>
        );
      });
    }

    return (
      <footer className="app-footer">
        <ol className="app-footer__actions list-bare">
          {actions}
        </ol>
        <div className="app-footer__summary">
          <a className="app-footer__address" href={"http://maps.apple.com/?q=" + address}>
            {address}
          </a>
          <div className="app-footer__phone">
            {phone}
          </div>
          <div className="app-footer__copyright">
            {copyright}
          </div>
        </div>
      </footer>
    );
  }
};

AppFooter.propTypes = {
  site: PropTypes.shape({
    address: PropTypes.string,
    copyright: PropTypes.string,
    menuActions: PropTypes.arrayOf(PropTypes.oneOfType([PropTypes.object, PropTypes.array])),
    phone: PropTypes.string
  })
};
