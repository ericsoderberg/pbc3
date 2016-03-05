import React, { Component, PropTypes } from 'react';
import { connect } from 'react-redux';
import { loadPageEdit, updatePageContentsOrder, unloadPage } from '../actions/actions';
import Menu from './Menu';
import AddIcon from './icons/AddIcon';
import EditIcon from './icons/EditIcon';
import CloseIcon from './icons/CloseIcon';
import DragAndDrop from '../utils/DragAndDrop';
import Text from './Text';
import Item from './Item';
import Event from './Event';
import FormFiller from './form/FormFiller';

var CLASS_ROOT = "page-builder";
var PLACEHOLDER_CLASS = `${CLASS_ROOT}__placeholder`;

class PageBuilder extends Component {

  constructor (props) {
    super(props);
    this._onSubmit = this._onSubmit.bind(this);
    this._dragStart = this._dragStart.bind(this);
    this._dragOver = this._dragOver.bind(this);
    this._dragEnd = this._dragEnd.bind(this);
    this.state = { elements: props.page.pageElements };
  }

  componentDidMount () {
    this.props.dispatch(loadPageEdit(this.props.id));
  }

  componentWillReceiveProps (nextProps) {
    if (nextProps.id !== this.props.id) {
      this.props.dispatch(loadPageEdit(nextProps.id));
    }
    this.setState({ elements: nextProps.page.pageElements });
  }

  componentWillUnmount () {
    this.props.dispatch(unloadPage());
  }

  _onSubmit (event) {
    event.preventDefault();
    const { edit: { updateContentsOrderUrl, authenticityToken }} = this.props;
    const { elements } = this.state;
    const elementIds = elements.map(pageElement => {
      return pageElement.id;
    });
    this.props.dispatch(updatePageContentsOrder(
      updateContentsOrderUrl, authenticityToken, elementIds));
  }

  _dragStart (event) {
    this._dragAndDrop = DragAndDrop.start({
      event: event,
      itemClass: `${CLASS_ROOT}__element`,
      placeholderClass: PLACEHOLDER_CLASS,
      list: this.state.elements.slice(0)
    });
  }

  _dragOver (event) {
    this._dragAndDrop.over(event);
  }

  _dragEnd (event) {
    let elements = this._dragAndDrop.end(event);
    elements.forEach(function (section, index) {
      section.index = index + 1;
    });
    this.setState({elements: elements});
  }

  render () {
    const { page: { name },
      edit: { addMenuActions, editContextUrl, cancelUrl }} = this.props;
    const addIcon = (<AddIcon />);
    let elementIds = [];

    const elements = this.state.elements.map((pageElement, index) => {
      elementIds.push(pageElement.id);
      let contents = '';
      switch (pageElement.type) {
        case 'Text':
          contents = (<Text text={pageElement.text} />);
          break;
        case 'Item':
          contents = (<Item item={pageElement.item} />);
          break;
        case 'Event':
          contents = (<Event event={pageElement.event} />);
          break;
        case 'Page':
          contents = (<a href={pageElement.page.url}>{pageElement.page.name}</a>);
          break;
        case 'Form':
          contents = (
            <FormFiller formId={pageElement.form.id} />
          );
          break;
      }
      return (
        <div key={pageElement.id} className={`${CLASS_ROOT}__element`}
          data-index={index}
          draggable="true"
          onDragEnd={this._dragEnd}
          onDragStart={this._dragStart}>
          <a className={`${CLASS_ROOT}__element-edit control-icon`}
            href={pageElement.editUrl}>
            <EditIcon />
          </a>
          {contents}
        </div>
      );
    });

    return (
      <form className={`${CLASS_ROOT} form`}>
        <div className="form__header">
          <span className="form__title">Edit {name}</span>
          <a className="control-icon" href={cancelUrl}>
            <CloseIcon />
          </a>
        </div>

        <div className="form__contents">
          <input ref="indexes" type="hidden" name="element_order"
            value={elementIds.join(',')} />
          <div className={`${CLASS_ROOT}__elements`}
            onDragOver={this._dragOver}>
            {elements}
          </div>

          <Menu className={`${CLASS_ROOT}__add`}
            actions={addMenuActions} icon={addIcon} />
        </div>

        <div className="form__footer">
          <input type="submit" value="Update" className="btn btn--primary"
            onClick={this._onSubmit} />
          <a href={editContextUrl}>
            Context
          </a>
        </div>
        {/*}
        <footer className={`${CLASS_ROOT}__footer`}>
          <a href={this.props.page.editContextUrl}>Context</a>
        </footer>
        {*/}
      </form>
    );
  }
};

PageBuilder.propTypes = {
  id: PropTypes.string,
  page: PropTypes.shape({
    name: PropTypes.string,
    pageElements: PropTypes.array
  }),
  edit: PropTypes.shape({
    addMenuActions: PropTypes.array,
    authenticityToken: PropTypes.string,
    editContextUrl: PropTypes.string,
    updateContentsOrderUrl: PropTypes.string
  })
};

let select = (state, props) => ({
  id: props.params.id,
  page: state.page,
  edit: state.pageEdit
});

export default connect(select)(PageBuilder);
