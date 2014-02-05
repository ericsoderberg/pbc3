module FormsHelper
  def best_form_url(form)
    if current_user
      filled_forms = form.filled_forms.for_user(current_user)
      if filled_forms.length > 0
        if form.payable?
          form_fills_url(form, :protocol => 'https')
        else
          edit_form_fill_url(form,
            filled_forms.first, :protocol => 'https')
        end
      else
        new_form_fill_url(form, :protocol => 'https')
      end
    else
      new_form_fill_url(form, :protocol => 'https')
    end
  end
end
