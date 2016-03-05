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
    this._onFillerCancel = this._onFillerCancel.bind(this);
    this._onFillerChange = this._onFillerChange.bind(this);
    this.state = this._stateFromProps(props);
  }

  componentDidMount () {
    this.props.dispatch(loadFormFills(this.props.form.id));
  }

  componentWillReceiveProps (nextProps) {
    this.state = this._stateFromProps(nextProps);
  }

  componentWillUnmount () {
    this.props.dispatch(unloadFormFills(this.props.form.id));
  }

  _stateFromProps (props) {
    return {
      filled: (props.formFills.length > 0),
      filling: (props.formFills.length === 0)
    };
  }

  _onEdit (formFillId) {
    this.setState({ filling: true, id: formFillId });
  }

  _onAdd () {
    this.setState({ filling: true });
  }

  _onFillerCancel () {
    this.setState({ filling: false, id: undefined });
  }

  _onFillerChange () {
    this.setState({ filling: false, id: undefined });
    this.props.dispatch(loadFormFills(this.props.form.id));
  }

  render () {
    const { form, formFills, edit } = this.props;
    const { filled, filling, id } = this.state;
    const indexPath = (edit ? edit.indexPath : undefined);
    let result;
    if (filling) {
      const onCancel = (filled ? this._onFillerCancel : undefined);
      result = (
        <FormFiller formId={form.id} id={id} onCancel={onCancel}
          onChange={this._onFillerChange}
          indexPath={indexPath} disabled={undefined != edit}
          indexContext={false} />
      );
    } else {
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

let select = (state, props) => ({
  formFills: state.formFills[props.form.id] || props.formFills
});

export default connect(select)(Form);
