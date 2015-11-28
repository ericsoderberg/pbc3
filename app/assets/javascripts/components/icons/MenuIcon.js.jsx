var MenuIcon = React.createClass({

  render: function() {
    return (
      <svg className={this.props.className} version="1.1"
        width="24px" height="24px" viewBox="0 0 24 24"
        stroke="#6E615D">
        <g strokeWidth="4" strokeLinecap="round" fill="none" fillRule="evenodd">
          <path d="M2,2 L22,2" />
          <path d="M2,12 L22,12" />
          <path d="M2,22 L22,22" />
        </g>
      </svg>
    );
  }
});

module.exports = MenuIcon;
