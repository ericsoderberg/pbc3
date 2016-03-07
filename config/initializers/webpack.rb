### working OK
if Rails.configuration.webpack[:use_manifest]
  webpack_manifest = Rails.root.join('public', 'assets', 'webpack-manifest.json')

  if File.exist?(webpack_manifest)
    Rails.configuration.webpack[:manifest] = JSON.parse(
      File.read(webpack_manifest),
    ).with_indifferent_access
  end
end
