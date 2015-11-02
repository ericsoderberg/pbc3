var EditIcon = React.createClass({

  render: function() {
    return (
      <svg className={this.props.className} width="24px" height="24px" viewBox="0 0 24 24" version="1.1"
        fill="#6E615D">
        <g fill="none" fillRule="evenodd" strokeLinejoin="round">
          <path d="M15,5 L3,17 L2,22 L6.99743652,21 L19,9" strokeWidth="3"></path>
          <path d="M16.5,1.5 L22.5,7.5" strokeWidth="4"></path>
        </g>
      </svg>
    );
  }
});

module.exports = EditIcon;
