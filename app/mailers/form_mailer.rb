class FormMailer < ActionMailer::Base
  
  def form_email(filled_form)
    @filled_form = filled_form
    @form = filled_form.form
    @page = @form.page
    @submitter = @filled_form.user
    @url  = edit_form_fill_url(@form, @filled_form)
    mail(:to => @page.contacts.map{|c| c.user.email},
      :from => Site.first.email,
      :subject => "#{@form.name} submitted")
  end
  
end
