var FilterIcon = React.createClass({
 
  render: function() {
    return (
      <svg className={this.props.className}
        width="24px" height="24px" viewBox="0 0 24 24" version="1.1"
        stroke="#6E615D" fill="#6E615D">
        <g strokeWidth="4" strokeLinecap="round" fillRule="evenodd">
          <polygon points="12 17 23 1 1 1 "></polygon>
          <rect x="10" y="7" width="4" height="16"></rect>
        </g>
      </svg>
    );
  }
});

module.exports = FilterIcon;