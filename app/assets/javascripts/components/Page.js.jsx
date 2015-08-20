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

    var editMenu = '';
    if (page.editActions) {
      editMenu = (
        <Menu className="page__edit-menu" actions={page.editActions} icon={(<EditIcon/>)} />
      );
    }

    var elements = page.pageElements.map(function (pageElement) {
      var contents = ''
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
      }
      return (<li key={pageElement.index} className="page__element">{contents}</li>);
    });

    return (
      <div className="page">
        <header className="page__header">
          <h1>{page.name}</h1>
          {editMenu}
        </header>
        <ol className="page__elements list-bare">
          {elements}
        </ol>
      </div>
    );
  }
});

module.exports = Page;
