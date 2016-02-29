module.exports = {
  context: __dirname + '/src/js',
  entry: {
    app: './app.js',
    admin: './admin.js'
  },
  output: {
    filename: '[name].bundle.js',
    path: __dirname + '/app/assets/javascripts'
  },
  resolve: {
    extensions: ['', '.js', '.jsx'],
    alias: {
      'scss': __dirname + '/app/assets/stylesheets'
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
  }
};
