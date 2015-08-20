var Menu = require('./Menu');
var AddIcon = require('./AddIcon');
var EditIcon = require('./EditIcon');
var REST = require('./REST');

var Text = require('./Text');
var Item = require('./Item');
var Event = require('./Event');

var PageEditContents = React.createClass({

  _updateOrder: function () {
    var url = this.props.editContents.updateContentsOrderUrl;
    var token = this.props.editContents.authenticityToken;
    var elementIds = this.state.elements.map(function (pageElement) {
      return pageElement.id;
    });
    var data = {
      element_order: elementIds,

    };
    REST.patch(url, token, data, function (response) {
      console.log('!!! PageEditContents _updateOrder completed', response);
    }.bind(this));
  },

  // http://webcloud.se/sortable-list-component-react-js/

  _dragStart: function (event) {
    this._dragged = event.currentTarget;
    event.dataTransfer.effectAllowed = 'move';

    // Firefox requires calling dataTransfer.setData
    // for the drag to properly work
    event.dataTransfer.setData("text/html", event.currentTarget);

    this._placeholder = document.createElement("li");
    this._placeholder.className = "placeholder";
  },

  _dragEnd: function (event) {
    var placeholder = this._placeholder;
    this._dragged.style.display = "block";
    this._dragged.parentNode.removeChild(placeholder);

    // Update state
    var elements = this.state.elements;
    var from = Number(this._dragged.dataset.index);
    var to = Number(this._over.dataset.index);
    if (from < to) to--;
    elements.splice(to, 0, elements.splice(from, 1)[0]);
    this.setState({elements: elements}, this._updateOrder);
  },

  _dragOver: function (event) {
    event.preventDefault();
    var placeholder = this._placeholder;
    this._dragged.style.display = "none";
    var element = event.target;
    // find containing element
    while ((element = element.parentElement) && !element.classList.contains('page-contents-edit__element'));
    if (element && element.className !== "placeholder") {
      this._over = element;
      element.parentNode.insertBefore(placeholder, element);
    }
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
      }
      return (
        <li key={pageElement.id} className="page-contents-edit__element"
          data-index={index}
          draggable="true"
          onDragEnd={this._dragEnd}
          onDragStart={this._dragStart}>
          <a className="page-contents-edit__element-edit control-icon" href={pageElement.editUrl}>
            <EditIcon />
          </a>
          {contents}
        </li>
      );
    }, this);

    return (
      <div className="page-contents-edit">
        <input ref="indexes" type="hidden" name="element_order" value={elementIds.join(',')} />
        <ol className="page-contents-edit__elements list-bare"
          onDragOver={this._dragOver}>
          {elements}
        </ol>

        <Menu className="page-contents-edit__add-menu"
          actions={this.props.editContents.addMenuActions} icon={addIcon}
          direction="up" />
      </div>
    );
  }
});

module.exports = PageEditContents;
