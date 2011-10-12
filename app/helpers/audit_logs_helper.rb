module AuditLogsHelper
  def link_to_audited_item(audit_log)
    if audit_log.auditable.is_a?(Page)
      page = audit_log.auditable
      link_to page.name, friendly_page_path(page)
    elsif audit_log.auditable.is_a?(User)
      user = audit_log.auditable
      link_to (user.name || user.email), edit_account_path(user)
    elsif audit_log.auditable.is_a?(Event)
      event = audit_log.auditable
      link_to event.name, friendly_page_path(event.page)
    elsif audit_log.auditable.is_a?(Podcast)
      podcast = audit_log.auditable
      if podcast.page
        link_to podcast.title, page_podcast_path(podcast.page, podcast)
      else
        link_to podcast.title, podcast_path(podcast)
      end
    elsif audit_log.auditable.is_a?(Note)
      note = audit_log.auditable
      link_to truncate(note.text, :length => 12),
        friendly_page_path(note.page)
    else
      obj = audit_log.auditable
      link_label = obj.id
      %w(name title).each do |k|
        if obj[k]
          link_label = obj[k]
          break
        end
      end
      link_to link_label, audit_log.auditable
    end
  end
end
