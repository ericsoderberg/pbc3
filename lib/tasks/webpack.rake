namespace :webpack do
  desc 'compile bundles using webpack'
  task :compile do
    `webpack --config config/webpack/production.config.js -p`
    # cmd = 'webpack --config config/webpack/production.config.js -p --json'
    # output = `#{cmd}`
    #
    # stats = JSON.parse(output)
    #
    # File.open('./public/assets/webpack-manifest.json', 'w') do |f|
    #   f.write stats['assetsByChunkName'].to_json
    # end
  end
end
