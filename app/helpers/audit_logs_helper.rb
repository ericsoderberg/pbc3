module AuditLogsHelper
  def link_to_audited_item(item)
    if item.is_a?(Page)
      link_to item.name, friendly_page_path(item)
    elsif item.is_a?(User)
      link_to (item.name || item.email), edit_account_path(item)
    elsif item.is_a?(Document)
      link_to item.name, item.file.url
    elsif item.is_a?(Audio)
      link_to (item.caption || '?'), item.audio.url
    elsif item.is_a?(Video)
      link_to (item.caption || '?'), item.video.url
    elsif item.is_a?(Event)
      link_to item.name, friendly_page_path(item.page)
    elsif item.is_a?(Message)
      link_to item.title, message_path(item)
    elsif item.is_a?(Style)
      link_to item.name, edit_style_path(item)
    elsif item.is_a?(Form)
      link_to item.name, edit_form_path(item)
    elsif item.is_a?(Podcast)
      if item.page
        link_to item.title, page_podcast_path(item.page, podcast)
      else
        link_to item.title, podcast_path(item)
      end
    elsif item.is_a?(Note)
      link_to truncate(item.text, :length => 12),
        friendly_page_path(item.page)
    end
  end
end
