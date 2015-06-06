// UNUSED for now
var Form = React.createClass({
 
  render: function() {
    return (
      <form className="form">
        <div className="form__header">
          {this.props.title}
        </div>

        <div className="form__contents">
          {this.props.children}
        </div>

        <div className="form__footer">
          <input type="submit" value="OK" className="btn btn--primary" />
          <a className="btn" href={cancelPath}>Cancel</a>
        </div>
      </form>
    );
  }
});

module.exports = Form;
