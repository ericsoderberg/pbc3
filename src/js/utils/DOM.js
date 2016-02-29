// (C) Copyright 2014-2015 Hewlett-Packard Development Company, L.P.

var DOM = {
  findScrollParents: function (element) {
    var result = [];
    var parent = element.parentNode;
    while (parent) {
      // account for border the lazy way for now
      if (parent.scrollHeight > (parent.offsetHeight + 10)) {
        result.push(parent);
      }
      parent = parent.parentNode;
    }
    if (result.length === 0) {
      result.push(document);
    }
    return result;
  },

  isDescendant: function (parent, child) {
    var node = child.parentNode;
    while (node != null) {
      if (node == parent) {
        return true;
      }
      node = node.parentNode;
    }
    return false;
  }
};

module.exports = DOM;
