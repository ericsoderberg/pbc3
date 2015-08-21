var Menu = require('./Menu');
var EditIcon = require('./EditIcon');

var Text = require('./Text');
var Item = require('./Item');
var Event = require('./Event');

var Page = React.createClass({

  propTypes: {
    page: React.PropTypes.obj
  },

  render: function() {
    var page = this.props.page;

    var editMenu;
    if (page.editActions) {
      editMenu = (
        <Menu className="page__edit-menu" actions={page.editActions} icon={(<EditIcon/>)} />
      );
    }

    var elements = page.pageElements.map(function (pageElement) {
      var contents;
      switch (pageElement.type) {
      case 'Text':
        contents = (<Text text={pageElement.text} />);
        break;
      case 'Item':
        contents = (<Item item={pageElement.item} />);
        break;
      case 'Event':
        contents = (<Event event={pageElement.event} />);
        break;
      case 'Page':
        contents = (<a href={pageElement.page.url}>{pageElement.page.name}</a>);
        break;
      }
      return (<li key={pageElement.index} className="page__element">{contents}</li>);
    });

    return (
      <div className="page">
        {editMenu}
        <ol className="page__elements list-bare">
          {elements}
        </ol>
      </div>
    );
  }
});

module.exports = Page;
