import { render, unmountComponentAtNode } from 'react-dom';

var Layer = {

  add: function (content, align) {

    // initialize data
    var layer = {
      align: align
    };
    if (! layer.align) {
      layer.align = "top";
    }

    // setup DOM
    layer.overlay = document.createElement('div');
    if (layer.overlay.classList) {
      layer.overlay.classList.add('layer__overlay');
    } else {
      // unit test version
      layer.overlay.className += ' layer__overlay';
    }
    layer.container = document.createElement('div');
    if (layer.container.classList) {
      layer.container.classList.add('layer', 'layer--' + layer.align);
    } else {
      // unit test version
      layer.container.className += ' layer layer--' + layer.align;
    }
    layer.overlay.appendChild(layer.container);
    document.body.appendChild(layer.overlay);
    render(content, layer.container);
    layer.bodyScrollTop = document.body.scrollTop;
    document.body.classList.add('noscroll');

    layer.render = this._render.bind(this, layer);
    layer.remove = this._remove.bind(this, layer);

    return layer;
  },

  _render: function (layer, content) {
    React.render(content, layer.container);
  },

  _remove: function (layer) {
    unmountComponentAtNode(layer.container);
    document.body.removeChild(layer.overlay);
    document.body.classList.remove('noscroll');
    setTimeout(function () {
      document.body.scrollTop = layer.bodyScrollTop;
    }, 1);
  }

};

module.exports = Layer;
