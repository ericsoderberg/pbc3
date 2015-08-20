var MarkdownIt = require('markdown-it');
var md = new MarkdownIt();

var CLASS_ROOT = "text";

var Text = React.createClass({

  render: function() {
    var html = md.render(this.props.text.text);
    return (
      <div className={CLASS_ROOT} dangerouslySetInnerHTML={{__html: html}} />
    );
  }
});

module.exports = Text;
