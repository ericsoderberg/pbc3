class FormBuilderForm
  include ActiveModel::Model

=begin
  class FormBuilderSection
    include ActiveModel::Model

    attr_accessor :id, :name, :form_index, :form_fields

    class FormBuilderField
      include ActiveModel::Model

      attr_accessor :id, :name, :field_type, :help, :value

      class FormBuilderOption
        include ActiveModel::Model

        attr_accessor :id
      end
    end
  end
=end

  attr_accessor :form

  delegate :id, :name, :persisted?, to: :form

  validate :validate_contents

  def self.model_name
    Form.model_name
  end

  #def form
  #  p "!!! new form" unless @form
  #  @form ||= Form.new
  #end

  def update_attributes(params)
    sections = {}
    fields = {}
    options = {}
    Form.transaction do

      # add and update
      @form.update_attributes!(params.slice(*%w[id name]))
      params["form_sections"].each do |fs|

        fs_params = fs.slice(*%w[id name form_index depends_on_id])
        if fs_params["id"] and @form.form_sections.exists?(fs_params["id"])
          form_section = @form.form_sections.find(fs_params["id"])
          form_section.update_attributes!(fs_params)
        else
          form_section = @form.form_sections.create!(fs_params)
        end
        sections[form_section.id] = form_section

        fs["form_fields"].each do |ff|

          ff_params = ff.slice(*%w[id name form_index field_type help
            required monetary value limit depends_on_id])
          if ff_params["id"] and form_section.form_fields.exists?(ff_params["id"])
            form_field = form_section.form_fields.find(ff_params["id"])
            form_field.update_attributes!(ff_params)
          else
            form_field = form_section.form_fields.create!(ff_params)
          end
          fields[form_field.id] = form_field

          ff["form_field_options"].each do |fo|

            fo_params = fo.slice(*%w[id name option_type help disabled value form_field_index])
            if fo_params["id"] and form_field.form_field_options.exists?(fo_params["id"])
              form_field_option = form_field.form_field_options.find(fo_params["id"])
              form_field_option.update_attributes!(fo_params)
            else
              form_field_option = form_field.form_field_options.create!(fo_params)
            end
            options[form_field_option.id] = form_field_option
          end if ff.has_key?("form_field_options")

        end if fs.has_key?("form_fields")

      end if params.has_key?("form_sections")

      # remove
      @form.form_sections.each do |form_section|
        if not sections.has_key?(form_section.id)
          form_section.destroy!
        else
          form_section.form_fields.each do |form_field|
            if not fields.has_key?(form_field.id)
              form_field.destroy!
            else
              form_field.form_field_options.each do |form_field_option|
                if not options.has_key?(form_field_option.id)
                  form_field_option.destroy!
                end
              end
            end
          end
        end
      end
    end
  end

  def saveX
    if valid?
      Form.transaction do
        @form.save!
        @form.form_sections.each do |form_section|
          form_section.save!
          p "!!! save #{form_section.form_fields.size}"
          form_section.form_fields.each do |form_field|
            form_field.save!
            form_field.form_field_options.each do |form_field_options|
              form_field_option.save!
            end
          end
        end
      end
    end
  end

  private

  def validate_contents

    if form.invalid?
      promote_errors(form.errors)
    end

    form.form_sections.each do |form_section|
      if form_section.invalid?
        promote_errors(form_section.errors)
      end

      form_section.form_fields.each do |form_field|
        if form_field.invalid?
          promote_errors(form_field.errors)
        end

        form_field.form_field_options.each do |form_field_option|
          if form_field_option.invalid?
            promote_errors(form_field_option.errors)
          end
        end
      end
    end
  end

  def promote_errors(content_errors)
    content_errors.each do |attribute, message|
      errors.add(attribute, message)
    end
  end

end
