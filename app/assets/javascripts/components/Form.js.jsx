
CLASS_ROOT = "form";

var FormField = React.createClass({

  propTypes: {
    field: React.PropTypes.object.isRequired
  },

  render: function () {
    var field = this.props.field;

    var result;

    if ('instructions' === field.fieldType) {

      result = (
        <div className={CLASS_ROOT + "__field form__fields_help"}>
          {field.help}
        </div>
      );

    } else {

      var label;
      if (field.name) {
        label = <label>{field.name}</label>;
      }

      var help;
      if (field.help) {
        help = <div className="form__field-help">{field.help}</div>;
      }

      var content;
      if ('single line' === field.fieldType) {
        content = <input type="text" value={field.value} />;
      } else if ('multiple lines' === field.fieldType) {
        content = <textarea value={field.value} />;
      } else if ('single choice' === field.fieldType) {
        var content = field.formFieldOptions.map(function (option) {
          return (
            <div key={option.id} className={CLASS_ROOT + "__field-option"}>
              <input type="radio" />
              {option.name}
              <span className="form__field-option-help">
                {option.help}
              </span>
            </div>
          );
        });
      } else if ('multiple choice' === field.fieldType) {
        var content = field.formFieldOptions.map(function (option) {
          return (
            <div key={option.id} className={CLASS_ROOT + "__field-option"}>
              <input type="checkbox" />
              {option.name}
              <span className="form__field-option-help">
                {option.help}
              </span>
            </div>
          );
        });
      } else if ('count' === field.fieldType) {
        content = <input type="number" value={field.value} />;
      }

      result = (
        <div className={CLASS_ROOT + "__field"}>
          {label}
          {help}
          {content}
        </div>
      );
    }

    return result;
  }
});

var FormSection = React.createClass({
  render: function () {
    var section = this.props.section;

    var fields = section.formFields.map(function (formField, index) {
      return (
        <FormField key={formField.id} field={formField} />
      );
    }, this);

    return (
      <fieldset className={CLASS_ROOT + "__section"}>
        <legend className={CLASS_ROOT + "__section-header"}>
          <h2>{section.name}</h2>
        </legend>
        <div className="form__fields" onDragOver={this._dragOver}>
          {fields}
        </div>
      </fieldset>
    );
  }
});


var Form = React.createClass({

  propTypes: {
    form: React.PropTypes.object.isRequired,
    tag: React.PropTypes.string
  },

  getDefaultProps: function () {
    return {tag: 'form'};
  },

  render: function() {
    var form = this.props.form;

    var sections = form.formSections.map(function (formSection, index) {
      return (
        <FormSection key={formSection.id} section={formSection} />
      );
    }, this);

    return (
      <this.props.tag className={CLASS_ROOT}>
        <div className={CLASS_ROOT + "__header"}>
          {form.name}
        </div>

        <div className={CLASS_ROOT + "__contents"}>
          <div className={CLASS_ROOT + "__sections"}>
            {sections}
          </div>
        </div>

        <div className={CLASS_ROOT + "__footer"}>
          <input type="submit" value="OK" className="btn btn--primary" />
        </div>
      </this.props.tag>
    );
  }
});

module.exports = Form;
