module PagesHelper
  
  def render_page_panel(page, aspects, children, categorized_events)
    if page.render_aspects?(aspects, children, categorized_events)
      content_tag(:li, :class => 'panel') do
        raw (aspects.split('').map{|aspect|
          render_page_aspect(page, aspect, children, categorized_events)
        }.join)
      end
    end
  end
  
  def render_page_aspect(page, aspect, children, categorized_events)
    case aspect
    when 't'
      content_tag(:div, :id => 'text') do
        raw page.text
      end
    when 'e'
      render :partial => 'events/viewer',
        :locals => {:categorized_events => categorized_events,
          :no_name => false}
    when 'c'
      render :partial => 'contacts/viewer',
        :locals => {:contacts => page.contacts}
    when 'm'
      render :partial => 'email_lists/subscribe',
        :locals => {:email_list => page.email_list}
    when 'd'
      render :partial => 'documents/viewer',
        :locals => {:documents => page.documents}
    when 'f'
      render :partial => 'forms/viewer', :locals => {:forms => page.forms}
    when 'p'
      render :partial => 'photos/viewer', :locals => {:photos => page.photos}
    when 'v'
      render :partial => 'videos/viewer', :locals => {:videos => page.videos}
    when 'a'
      render :partial => 'audios/viewer', :locals => {:audios => page.audios}
    when 'h'
      render :partial => 'notes/viewer', :locals => {:notes => page.notes}
    when 'g'
      render :partial => 'pages/viewer', :locals => {:pages => children}
    when 's'
      render :partial => 'social/viewer'
    end
  end
  
  def edit_page_aspect_url(page, aspect)
    case aspect
    when 'text'
      edit_page_path(page)
    when 'events'
      page_events_path(page)
    when 'documents'
      page_documents_path(page)
    when 'forms'
      forms_path(:page_id => page.id)
    when 'photos'
      page_photos_path(page)
    when 'videos'
      page_videos_path(page)
    when 'audios'
      page_audios_path(page)
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
    when 'social'
      edit_page_social_path(page)
    end
  end
end
