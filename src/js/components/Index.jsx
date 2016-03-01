import React, { Component, PropTypes } from 'react';
import { connect } from 'react-redux';
import { loadIndex, searchIndex, moreIndex, unloadIndex } from '../actions/actions';
import SearchInput from './SearchInput';
import AddIcon from './icons/AddIcon';
import EditIcon from './icons/EditIcon';

const CLASS_ROOT = "index";

class Index extends Component {

  constructor () {
    super();
    this._onChangeSearch = this._onChangeSearch.bind(this);
    this._onScroll = this._onScroll.bind(this);
  }

  componentDidMount () {
    this.props.dispatch(loadIndex(this.props.category, this.props.context));
    window.addEventListener('scroll', this._onScroll);
    this._onScroll(); // in case the window is already big
  }

  componentWillUnmount () {
    this.props.dispatch(unloadIndex());
    window.removeEventListener('scroll', this._onScroll);
  }

  _onChangeSearch (search) {
    this.props.dispatch(searchIndex(this.props.category, search));
  }

  _onScroll (event) {
    const bodyRect = document.body.getBoundingClientRect();
    if (bodyRect.bottom < (window.innerHeight + 100)) {
      const { category, index: {items, count, search} } = this.props;
      if (items.length < count) {
        clearTimeout(this._scrollTimer);
        this._scrollTimer = setTimeout(() => {
          // get the next page's worth
          this.props.dispatch(moreIndex(category, items.length, search));
        }, 200);
      }
    }
  }

  render () {
    const { index: { changing, count, filter, newUrl, editUrl },
      noneMessage, itemRenderer, page } = this.props;
    let classes = [CLASS_ROOT];
    if (changing) {
      classes.push(`${CLASS_ROOT}--changing`);
    }

    const items = this.props.index.items.map(item => {
      return (
        <li key={item.id} className={`${CLASS_ROOT}__item`}>
          {itemRenderer(item)}
        </li>
      );
    });

    let none;
    if (0 === count) {
      const text = (filter.search ? 'No matches' : noneMessage);
      none = (<div className={`${CLASS_ROOT}__no-matches`}>{text}</div>);
    }

    let spinner;
    if (items.length < count) {
      spinner = (<div className={`${CLASS_ROOT}__spinner spinner`}></div>);
    }

    let addControl;
    if (newUrl) {
      addControl = (
        <a className={`${CLASS_ROOT}__add control-icon`} href={newUrl}>
          <AddIcon />
        </a>
      );
    }

    let editControl;
    if (editUrl) {
      editControl = (
        <a className={`${CLASS_ROOT}__edit control-icon`} href={editUrl}>
          <EditIcon />
        </a>
      );
    }

    let backPage;
    if (page) {
      backPage = (
        <a className={`${CLASS_ROOT}__back`} href={page.url}>
          {page.name}
        </a>
      );
    }

    return (
      <div className={classes.join(' ')}>
        {backPage}
        <header className={`${CLASS_ROOT}__header`}>
          <h1 className={`${CLASS_ROOT}__title`}>{this.props.title}</h1>
          <SearchInput className={`${CLASS_ROOT}__search`}
            text={filter.search}
            placeholder={this.props.searchPlaceholder}
            onChange={this._onChangeSearch} />
          {addControl}
          {editControl}
        </header>
        {none}
        <ol className={`${CLASS_ROOT}__items list-bare`}>
          {items}
        </ol>
        {spinner}
        <div className={`${CLASS_ROOT}__count`}>{count}</div>
      </div>
    );
  }
};

Index.propTypes = {
  category: PropTypes.string.isRequired,
  context: PropTypes.string,
  index: PropTypes.shape({
    changing: PropTypes.bool,
    count: PropTypes.number,
    editUrl: PropTypes.string,
    filter: PropTypes.object.isRequired,
    items: PropTypes.array.isRequired,
    newUrl: PropTypes.string
  }).isRequired,
  itemRenderer: PropTypes.func.isRequired,
  noneMessage: PropTypes.string,
  page: PropTypes.object,
  searchPlaceholder: PropTypes.string,
  title: PropTypes.string.isRequired
};

Index.defaultProps = {
  noneMessage: "None",
  searchPlaceholder: "Search"
};

let select = (state) => ({index: state.index});

export default connect(select)(Index);
