var AddIcon = React.createClass({

  render: function() {
    return (
      <svg className={this.props.className} version="1.1"
        width="24px" height="24px" viewBox="0 0 24 24"
        stroke="#6E615D">
        <g strokeWidth="4" strokeLinecap="round" fill="none" fillRule="evenodd">
          <path d="M12,2 L12,22" />
          <path d="M2,12 L22,12" />
        </g>
      </svg>
    );
  }
});

module.exports = AddIcon;
