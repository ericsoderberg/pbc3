module SearchHelper
  def render_search_result(object)
    case object
    when Page then
      render :partial => 'pages/search_result', :locals => {:page => object}
    when Message then
      render :partial => 'messages/search_result', :locals => {:message => object}
    when MessageSet then
      render :partial => 'message_sets/search_result',
        :locals => {:message_set => object}
    when Author then
      render :partial => 'authors/search_result', :locals => {:author => object}
    when Event then
      render :partial => 'events/search_result', :locals => {:event => object}
    when Document then
      render :partial => 'documents/search_result', :locals => {:document => object}
    when Form then
      render :partial => 'forms/search_result', :locals => {:form => object}
    when User then
      render :partial => 'accounts/search_result', :locals => {:user => object}
    when Style then
      render :partial => 'styles/search_result', :locals => {:style => object}
    else
      ''
    end
  end
end
