module AuditLogsHelper
  def link_to_audited_item(audit_log)
    if audit_log.auditable.is_a?(Page)
      page = audit_log.auditable
      link_to page.name, friendly_page_path(page)
    else
      link_to audit_log.auditable
    end
  end
end
