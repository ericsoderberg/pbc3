var Router = require('./Router');

var Link = React.createClass({
  
  propTypes: {
    href: React.PropTypes.string
  },
  
  _onClick: function (event) {
    event.preventDefault();
    var path = event.target.getAttribute('href');
    Router.push(path, true);
  },
 
  render: function () {
    var classes = ["link"];
    if (this.props.className) {
      classes.push(this.props.className);
    }
    return (
      <a className={classes.join(' ')} href={this.props.href} onClick={this._onClick}>
        {this.props.children}
      </a>
    );
  }
});

module.exports = Link;
