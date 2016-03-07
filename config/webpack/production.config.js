var webpack = require('webpack');
var AssetsPlugin = require('assets-webpack-plugin');
var _ = require('lodash');
var path = require('path');

var config = module.exports = require('./main.config.js');

config.output = _.merge(config.output, {
  path: path.join(__dirname, '../', '../', 'public', 'assets'),
  filename: '[name]-bundle-[hash].js',
  chunkFilename: '[id]-bundle-[hash].js'
});

config.plugins.push(
  new AssetsPlugin({
    filename: 'webpack-manifest.json',
    path: path.join(__dirname, '../', '../', 'public', 'assets')
  }),
  new webpack.optimize.UglifyJsPlugin(),
  new webpack.optimize.OccurenceOrderPlugin()
);
