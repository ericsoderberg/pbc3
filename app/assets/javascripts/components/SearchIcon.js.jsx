var SearchIcon = React.createClass({
 
  render: function() {
    return (
      <svg className={this.props.className}
        width="24px" height="24px" viewBox="0 0 24 24" version="1.1"
        stroke="#6E615D">
        <g fill="none" fillRule="evenodd">
          <circle strokeWidth="3" cx="10" cy="10" r="8"></circle>
          <path d="M21.5,21.5 L16,16" strokeWidth="4" strokeLinecap="round"></path>
        </g>
      </svg>
    );
  }
});

module.exports = SearchIcon;
