var path = require('path');
// var webpack = require('webpack');

var config = module.exports = {
  context: path.join(__dirname, '../', '../', 'src', 'js'),
  resolve: {
    extensions: ['', '.js', '.jsx'],
    alias: {
      'scss': path.join(__dirname, '../', '../', 'app', 'assets', 'stylesheets')
    }
  },
  module: {
    loaders: [
      {
        test: /\.jsx?$/,
        loader: 'babel-loader'
      },
      {
        test: /\.json$/,
        loader: 'json-loader'
      },
      {
        test: /\.scss$/,
        loader: 'style!css!sass?outputStyle=expanded&' +
          'includePaths[]=' + (encodeURIComponent('./node_modules'))
      },
      {
        test: /\.css$/,
        loader: 'style-loader!css-loader'
      }
    ]
  },
  plugins: []
};

config.entry = {
  app: './app.js',
  admin: './admin.js'
};

config.output = {
  filename: '[name].bundle.js',
  path: path.join(__dirname, '../', '../', 'app', 'assets', 'javascripts')
};
