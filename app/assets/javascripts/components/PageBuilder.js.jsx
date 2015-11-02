var Menu = require('./Menu');
var AddIcon = require('./AddIcon');
var EditIcon = require('./EditIcon');
var REST = require('./REST');
var DragAndDrop = require('../utils/DragAndDrop');

var Text = require('./Text');
var Item = require('./Item');
var Event = require('./Event');
var Form = require('./Form');

var CLASS_ROOT = "page-builder";
var PLACEHOLDER_CLASS = CLASS_ROOT + "__placeholder";

var PageBuilder = React.createClass({

  propTypes: {
    editContents: React.PropTypes.object.isRequired
  },

  _onSubmit: function (event) {
    event.preventDefault();
    var url = this.props.editContents.updateContentsOrderUrl;
    var token = this.props.editContents.authenticityToken;
    var elementIds = this.state.elements.map(function (pageElement) {
      return pageElement.id;
    });
    var data = {
      element_order: elementIds
    };
    REST.patch(url, token, data, function (response) {
      console.log('!!! PageBuilder _onSubmit completed', response);
      if (response.result === 'ok') {
        location = response.redirect_to;
      }
    }.bind(this));
  },

  _updateOrder: function () {
    var url = this.props.editContents.updateContentsOrderUrl;
    var token = this.props.editContents.authenticityToken;
    var elementIds = this.state.elements.map(function (pageElement) {
      return pageElement.id;
    });
    var data = {
      element_order: elementIds
    };
    REST.patch(url, token, data, function (response) {
      console.log('!!! PageBuilder _updateOrder completed', response);
    }.bind(this));
  },

  _dragStart: function (event) {
    this._dragAndDrop = DragAndDrop.start({
      event: event,
      itemClass: CLASS_ROOT + '__element',
      placeholderClass: PLACEHOLDER_CLASS,
      list: this.state.elements.slice(0)
    });
  },

  _dragOver: function (event) {
    this._dragAndDrop.over(event);
  },

  _dragEnd: function (event) {
    var elements = this._dragAndDrop.end(event);
    elements.forEach(function (section, index) {
      section.index = index + 1;
    });
    this.setState({elements: elements});
  },

  getInitialState: function () {
    return {elements: this.props.editContents.page.pageElements};
  },

  render: function () {
    var page = this.props.editContents.page;
    var addIcon = (<AddIcon />);
    var elementIds = [];

    var elements = this.state.elements.map(function (pageElement, index) {
      elementIds.push(pageElement.id);
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
      case 'Page':
        contents = (<a href={pageElement.page.url}>{pageElement.page.name}</a>);
        break;
      case 'Form':
        contents = (<Form form={pageElement.form} tag="div" />);
        break;
      }
      return (
        <div key={pageElement.id} className={CLASS_ROOT + "__element"}
          data-index={index}
          draggable="true"
          onDragEnd={this._dragEnd}
          onDragStart={this._dragStart}>
          <a className={CLASS_ROOT + "__element-edit control-icon"}
            href={pageElement.editUrl}>
            <EditIcon />
          </a>
          {contents}
        </div>
      );
    }, this);

    return (
      <form className={CLASS_ROOT + " form"}>
        <input ref="indexes" type="hidden" name="element_order" value={elementIds.join(',')} />
        <div className={CLASS_ROOT + "__elements"}
          onDragOver={this._dragOver}>
          {elements}
        </div>

        <Menu className={CLASS_ROOT + "__add-menu"}
          actions={this.props.editContents.addMenuActions} icon={addIcon} />

        <div className="form__footer">
          <input type="submit" value="Update" className="btn btn--primary"
            onClick={this._onSubmit} />
          <a href={this.props.editContents.editContextUrl}>
            Context
          </a>
        </div>
        {/*}
        <footer className={CLASS_ROOT + "__footer"}>
          <a href={this.props.editContents.editContextUrl}>Context</a>
        </footer>
        {*/}
      </form>
    );
  }
});

module.exports = PageBuilder;
