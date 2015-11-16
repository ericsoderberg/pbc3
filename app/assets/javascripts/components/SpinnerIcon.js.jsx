var SpinnerIcon = React.createClass({

  render: function() {
    return (
      <svg className={this.props.className} version="1.1"
        width="24px" height="24px" viewBox="0 0 24 24"
        fill="#6E615D">
        <g stroke="none" strokeLinecap="round" fillRule="evenodd">
          <circle cx="12" cy="2" r="2"></circle>
          <circle opacity="0.9" cx="5" cy="5" r="2"></circle>
          <circle opacity="0.8" cx="2" cy="12" r="2"></circle>
          <circle opacity="0.7" cx="5" cy="19" r="2"></circle>
          <circle opacity="0.6" cx="12" cy="22" r="2"></circle>
          <circle opacity="0.5" cx="19" cy="19" r="2"></circle>
          <circle opacity="0.4" cx="22" cy="12" r="2"></circle>
          <circle opacity="0.3" cx="19" cy="5" r="2"></circle>
        </g>
      </svg>
    );
  }
});

module.exports = SpinnerIcon;
