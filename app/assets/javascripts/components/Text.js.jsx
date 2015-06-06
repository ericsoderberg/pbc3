var Text = React.createClass({
 
  render: function() {
    return (
      <div className="text" dangerouslySetInnerHTML={{__html: this.props.text.text}} />
    );
  }
});

module.exports = Text;
