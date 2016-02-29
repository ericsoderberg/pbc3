import React, { Component, PropTypes } from 'react';
import { Link } from 'react-router';
import { connect } from 'react-redux';
import { loadMessages, searchMessages, moreMessages, unloadMessages } from '../actions/actions';
import moment from 'moment';
import SearchInput from './SearchInput';
import AddIcon from './icons/AddIcon';

var CLASS_ROOT = "messages";

class Messages extends Component {

  constructor () {
    super();
    this._onChangeSearch = this._onChangeSearch.bind(this);
  }

  componentDidMount () {
    this.props.dispatch(loadMessages());
    window.addEventListener('scroll', this._onScroll);
    this._onScroll(); // in case the window is already big
  }

  componentWillUnmount () {
    this.props.dispatch(unloadMessages());
    window.removeEventListener('scroll', this._onScroll);
  }

  _onChangeSearch (search) {
    this.props.dispatch(searchMessages(search));
  }

  _onScroll (event) {
    var bodyRect = document.body.getBoundingClientRect();
    if (bodyRect.bottom < (window.innerHeight + 100)) {
      const { messages: {messages, count, search} } = this.props;
      if (messages.length < count) {
        clearTimeout(this._scrollTimer);
        this._scrollTimer = setTimeout(() => {
          // get the next page's worth
          this.props.dispatch(moreMessages(messages.length, search));
        }, 200);
      }
    }
  }

  render () {
    const { messages: { changing, count, filter },
      newUrl } = this.props;
    let classes = [CLASS_ROOT];
    if (changing) {
      classes.push(`${CLASS_ROOT}--changing`);
    }

    let year;
    const messages = this.props.messages.messages.map(message => {
      let classes = [`${CLASS_ROOT}__message`];
      const date = moment(message.date);
      if (! year || date.year() !== year) {
        classes.push(`${CLASS_ROOT}__message--year`);
        year = date.year();
      }
      return (
        <li key={message.id} className={classes.join(' ')}>
          <span className={`${CLASS_ROOT}__message-year`}>
            {date.format('YYYY')}
          </span>
          <span className={`${CLASS_ROOT}__message-date`}>
            {date.format('MMM D')}
          </span>
          <Link className={`${CLASS_ROOT}__message-title`} to={message.path}>
            {message.title}
          </Link>
          <span className={`${CLASS_ROOT}__message-verses`}>
            {message.verses}
          </span>
          <span className={`${CLASS_ROOT}__message-author`}>
            {message.author}
          </span>
        </li>
      );
    });

    let none;
    if (0 === count) {
      var text = (filter.search ? 'No matches' : 'No messages');
      none = (<div className={`${CLASS_ROOT}__no-matches`}>{text}</div>);
    }

    let spinner;
    if (messages.length < count) {
      spinner = (<div className={`${CLASS_ROOT}__spinner spinner`}></div>);
    }

    let addControl;
    if (newUrl) {
      addControl = (
        <a className={`${CLASS_ROOT}__add control-icon`} href={this.props.newUrl}>
          <AddIcon />
        </a>
      );
    }

    return (
      <div className={classes.join(' ')}>
        <header className={`${CLASS_ROOT}__header`}>
          <h1 className={`${CLASS_ROOT}__title`}>Library</h1>
          <SearchInput className={`${CLASS_ROOT}__search`}
            text={filter.search}
            placeholder="Search: Title, Book, Author, Date"
            suggestionsPath={'/messages/suggestions?q='}
            onChange={this._onChangeSearch} />
          {addControl}
        </header>
        {none}
        <ol className={`${CLASS_ROOT}__messages list-bare`}>
          {messages}
        </ol>
        {spinner}
        <div className={`${CLASS_ROOT}__count`}>{count}</div>
      </div>
    );
  }
};

Messages.propTypes = {
  messages: PropTypes.shape({
    changing: PropTypes.bool,
    count: PropTypes.number,
    filter: PropTypes.object,
    messages: PropTypes.array
  })
};

let select = (state) => ({messages: state.messages});

export default connect(select)(Messages);
