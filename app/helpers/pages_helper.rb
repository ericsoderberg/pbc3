module PagesHelper
  
  # args are: children, categorized_events, width
  def render_page_panel(page, aspects, args={})
    if page.render_aspects?(aspects, args)
      content_tag(:li, :class => 'panel') do
        raw (aspects.split('').map{|aspect|
          render_page_aspect(page, aspect, args)
        }.join)
      end
    end
  end
  
  def render_page_aspect(page, aspect, args={})
    case aspect
    when 't'
      content_tag(:div, :id => 'text') do
        raw page.text
      end
    when 'e'
      if @page.gallery? or @page.landing?
        render :partial => 'events/gallery',
          :locals => {:categorized_events => args[:categorized_events],
            :no_name => false}
      else
        render :partial => 'events/viewer',
          :locals => {:categorized_events => args[:categorized_events],
            :no_name => false}
      end
    when 'c'
      if @page.gallery?
        render :partial => 'contacts/lineup',
          :locals => {:contacts => page.contacts}
      else
        render :partial => 'contacts/viewer',
          :locals => {:contacts => page.contacts}
      end
    when 'm'
      render :partial => 'email_lists/subscribe',
        :locals => {:email_list => page.email_list}
    when 'd'
      if @page.gallery?
        render :partial => 'documents/library',
          :locals => {:documents => page.documents}
      else
        render :partial => 'documents/viewer',
          :locals => {:documents => page.documents}
      end
    when 'f'
      if @page.gallery?
        render :partial => 'forms/library', :locals => {:forms => page.forms}
      else
        render :partial => 'forms/viewer', :locals => {:forms => page.forms}
      end
    when 'p'
      if @page.gallery?
        render :partial => 'photos/gallery', :locals => {:photos => page.photos}
      else
        render :partial => 'photos/viewer', :locals => {:photos => page.photos}
      end
    when 'v'
      if @page.gallery?
        render :partial => 'videos/gallery', :locals => {:videos => page.videos}
      else
        render :partial => 'videos/viewer', :locals => {:videos => page.videos}
      end
    when 'a'
      if @page.gallery?
        render :partial => 'audios/gallery', :locals => {:audios => page.audios}
      else
        render :partial => 'audios/viewer', :locals => {:audios => page.audios}
      end
    when 'h'
      render :partial => 'notes/viewer', :locals => {:notes => page.notes}
    when 'g'
      render :partial => 'pages/viewer', :locals => {:pages => args[:children]}
    when 'F'
      render :partial => 'social/facebook',
        :locals => {:width => args[:width], :height => args[:height]}
    when 'T'
      render :partial => 'social/twitter',
        :locals => {:width => args[:width], :height => args[:height]}
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
