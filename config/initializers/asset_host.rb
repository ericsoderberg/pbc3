ActionController::Base.asset_host = Proc.new { |source, request|
  "#{request.protocol}#{request.host_with_port}"
}
