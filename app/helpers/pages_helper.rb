module PagesHelper
  def edit_page_aspect_url(page, aspect)
    case aspect
    when 'text'
      edit_page_path(page)
    when 'events'
      page_events_path(page)
    when 'documents'
      page_documents_path(page)
    when 'forms'
      forms_path(:page_id => page.url)
    when 'photos'
      page_photos_path(page)
    when 'videos'
      page_videos_path(page)
    when 'access'
      page_authorizations_path(page)
    when 'contacts'
      page_contacts_path(page)
    when 'feature'
      edit_page_feature_path(page)
    when 'podcast'
      if page.podcast
        edit_page_podcast_path(page)
      else
        new_page_podcast_path(page)
      end
    end
  end
end
