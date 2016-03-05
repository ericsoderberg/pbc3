import React, { Component, PropTypes } from 'react';
import { Link } from 'react-router';
import { connect } from 'react-redux';
import { loadPage, unloadPage } from '../actions/actions';
import EditIcon from './icons/EditIcon';
import Text from './Text';
import Item from './Item';
import Event from './Event';
import Form from './form/Form';

const CLASS_ROOT = "page";

class Page extends Component {

  componentDidMount () {
    this.props.dispatch(loadPage(this.props.id));
  }

  componentWillReceiveProps (nextProps) {
    if (nextProps.id !== this.props.id) {
      this.props.dispatch(loadPage(nextProps.id));
    }
  }

  componentWillUnmount () {
    this.props.dispatch(unloadPage());
  }

  render () {
    const { page: { name, pageElements, editUrl, backPage } } = this.props;

    let backPageLink;
    if (backPage) {
      backPageLink = (
        <Link className={`${CLASS_ROOT}__back`} to={backPage.path}>
          {backPage.name}
        </Link>
      );
    }

    let editControl;
    if (editUrl) {
      editControl = (
        <a href={editUrl} className={`${CLASS_ROOT}__edit control-icon`}>
          <EditIcon />
        </a>
      );
    }

    const elements = pageElements.map(pageElement => {
      let contents;
      switch (pageElement.type) {
        case 'Text':
          contents = (<Text text={pageElement.text} />);
          break;
        case 'Item':
          contents = (<Item item={pageElement.item} />);
          break;
        case 'Event':
          contents = (<Event event={pageElement.event} pageName={name} />);
          break;
        case 'Page':
          contents = (<Link to={pageElement.page.url}>{pageElement.page.name}</Link>);
          break;
        case 'Form':
          contents = (<Form form={pageElement.form}
            formFills={pageElement.formFills} edit={pageElement.edit} />);
          break;
      }
      return (
        <li key={pageElement.index} className={`${CLASS_ROOT}__element`}>
          {contents}
        </li>
      );
    });

    return (
      <div className={CLASS_ROOT}>
        {editControl}
        {backPageLink}
        <ol className={`${CLASS_ROOT}__elements list-bare`}>
          {elements}
        </ol>
      </div>
    );
  }
};

Page.propTypes = {
  id: PropTypes.string,
  page: PropTypes.shape({
    name: PropTypes.string,
    pageElements: PropTypes.array
  })
};

let select = (state, props) => ({
  id: props.params.id,
  page: state.page
});

export default connect(select)(Page);
