module.exports = {
  idsMatch: function (o1, o2) {
    return ((o1.hasOwnProperty('id') && o2.hasOwnProperty('id') &&
        o1.id === o2.id) ||
      (o1.hasOwnProperty('_id') && o2.hasOwnProperty('_id') &&
        o1['_id'] === o2['_id']));
  },

  itemId: function (item) {
    return (item.hasOwnProperty('id') ? item.id : item['_id']);
  }
};
