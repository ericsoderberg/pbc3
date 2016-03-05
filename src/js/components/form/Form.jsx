import React, { Component, PropTypes } from 'react';
import { connect } from 'react-redux';
import { loadFormFills, unloadFormFills } from '../../actions/actions';
import UserFormFills from './UserFormFills';
import FormFiller from './FormFiller';

export default class Form extends Component {

  constructor (props) {
    super(props);
    this._onAdd = this._onAdd.bind(this);
    this._onEdit = this._onEdit.bind(this);
    this._onCloseFiller = this._onCloseFiller.bind(this);
    this.state = {
      filled: (props.formFills.length > 0),
      filling: (props.formFills.length === 0)
    };
  }

  componentDidMount () {
    this.props.dispatch(loadFormFills(this.props.form.id));
  }

  componentWillReceiveProps (nextProps) {
    this.setState({ filled: (nextProps.formFills.length > 0) });
  }

  componentWillUnmount () {
    this.props.dispatch(unloadFormFills(this.props.form.id));
  }

  _onEdit (formFillId) {
    this.setState({ filling: true, id: formFillId });
  }

  _onAdd () {
    this.setState({ filling: true });
  }

  _onCloseFiller (refresh) {
    this.setState({ filling: false, id: undefined });
    this.props.dispatch(loadFormFills(this.props.form.id));
  }

  render () {
    const { form, formFills, edit } = this.props;
    const { filled, filling, id } = this.state;
    let result;
    if (filling) {
      const onClose = (filled ? this._onCloseFiller : undefined);
      result = (
        <FormFiller formId={form.id} id={id} onClose={onClose}
          disabled={undefined != edit} />
      );
    } else {
      const indexPath = (edit ? edit.indexPath : undefined);
      result = (
        <UserFormFills form={form} formFills={formFills}
          indexPath={indexPath}
          onAdd={this._onAdd} onEdit={this._onEdit} />
      );
    }
    return result;
  }
};

Form.propTypes = {
  edit: PropTypes.shape({
    authenticityToken: PropTypes.string,
    createUrl: PropTypes.string,
    indexPath: PropTypes.string,
    pageId: PropTypes.number
  }),
  formFills: PropTypes.array,
  form: PropTypes.object.isRequired
};

// let select = (state, props) => {
//   console.log('!!! Form select', state.formFills, props);
//   return {};
// };

let select = (state, props) => ({
  formFills: state.formFills[props.form.id] || props.formFills
});

export default connect(select)(Form);
