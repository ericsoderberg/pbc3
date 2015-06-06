var CloseIcon = React.createClass({
 
  render: function() {
    return (
      <svg className={this.props.className}
        width="24px" height="24px" viewBox="0 0 24 24" version="1.1"
        stroke="#6E615D">
        <g strokeWidth="4" strokeLinecap="round" fill="none" fillRule="evenodd">
          <path d="M2,2 L22,22" />
          <path d="M2,22 L22,2" />
        </g>
      </svg>
    );
  }
});

module.exports = CloseIcon;
