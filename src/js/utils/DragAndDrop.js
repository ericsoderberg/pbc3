/*
 * DragAndDrop is a utility for managing drag and drop.
 *
 * See: http://webcloud.se/sortable-list-component-react-js/
 */

var DragAndDrop = {

  // options: {event: , itemClass: , placeholderClass: , list: }
  start: function (options) {
    var dragAndDrop = {
      dragged: options.event.currentTarget,
      itemClass: options.itemClass,
      placeholderClass: options.placeholderClass,
      list: options.list
    };

    options.event.stopPropagation(); // allows nested drag and drop
    options.event.dataTransfer.effectAllowed = 'move';

    // Firefox requires calling dataTransfer.setData
    // for the drag to properly work
    options.event.dataTransfer.setData("text/html", event.currentTarget);

    dragAndDrop.placeholder = document.createElement("div");
    dragAndDrop.placeholder.className = dragAndDrop.placeholderClass;

    dragAndDrop.end = this._end.bind(this, dragAndDrop);
    dragAndDrop.over = this._over.bind(this, dragAndDrop);

    return dragAndDrop;
  },

  _end: function (dragAndDrop, event) {
    dragAndDrop.dragged.style.display = "";
    dragAndDrop.dragged.parentNode.removeChild(dragAndDrop.placeholder);

    // Update list
    var from = Number(dragAndDrop.dragged.dataset.index);
    var to = Number(dragAndDrop.before.dataset.index);
    if (from < to) to--;
    dragAndDrop.list.splice(to, 0, dragAndDrop.list.splice(from, 1)[0]);
    return dragAndDrop.list;
  },

  _over: function (dragAndDrop, event) {
    event.preventDefault();
    dragAndDrop.dragged.style.display = "none";
    var element = event.target;
    // find containing element
    while (!element.classList.contains(dragAndDrop.itemClass) &&
      (element = element.parentElement));
    if (element && element.className !== dragAndDrop.placeholderClass) {
      dragAndDrop.before = element;
      element.parentNode.insertBefore(dragAndDrop.placeholder, element);
    }
  }
};

module.exports = DragAndDrop;
