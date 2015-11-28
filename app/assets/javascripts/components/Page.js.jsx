var Menu = require('./Menu');
var EditIcon = require('./icons/EditIcon');

var Text = require('./Text');
var Item = require('./Item');
var Event = require('./Event');
var Form = require('./Form');

var CLASS_ROOT = "page";

var Page = React.createClass({

  propTypes: {
    page: React.PropTypes.obj
  },

  render: function() {
    var page = this.props.page;

    var backPage;
    if (page.backPage) {
      backPage = (
        <a className={CLASS_ROOT + "__back"} href={page.backPage.url}>
          {page.backPage.name}
        </a>
      );
    }

    var editControl;
    if (page.editUrl) {
      editControl = (
        <a href={page.editUrl} className={CLASS_ROOT + "__edit control-icon"}>
          <EditIcon />
        </a>
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
        contents = (<Event event={pageElement.event} pageName={page.name} />);
        break;
      case 'Page':
        contents = (<a href={pageElement.page.url}>{pageElement.page.name}</a>);
        break;
      case 'Form':
        contents = (<Form form={pageElement.form} />);
        break;
      }
      return (
        <li key={pageElement.index} className={CLASS_ROOT + "__element"}>
          {contents}
        </li>
      );
    });

    return (
      <div className={CLASS_ROOT}>
        {editControl}
        {backPage}
        <ol className={CLASS_ROOT + "__elements list-bare"}>
          {elements}
        </ol>
      </div>
    );
  }
});

module.exports = Page;
