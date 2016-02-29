import React, { Component, PropTypes } from 'react';
import { Link } from 'react-router';
import { connect } from 'react-redux';
import { loadMessage, unloadMessage } from '../actions/actions';
import moment from 'moment';
import EditIcon from './icons/EditIcon';

var CLASS_ROOT = "message";

const messageSummary = (label, message, onClick) => {
  var date = moment(message.date);
  var author = (message.author ? message.author.name : '');
  return (
    <div className="message__footer-item">
      <span className="message__footer-label">{label}</span>
      <span className="message__footer-date">{date.format('MMM D, YYYY')}</span>
      <Link className="message__footer-title" to={message.path}>{message.title}</Link>
      <span className="message__footer-verses">{message.verses}</span>
      <span className="message__footer-author">{author}</span>
    </div>
  );
};

export default class Message extends Component {

  constructor (props) {
    super(props);
    this._onResize = this._onResize.bind(this);
  }

  componentDidMount () {
    this.props.dispatch(loadMessage(this.props.id));
    window.addEventListener('resize', this._onResize);
    this._onResize();
  }

  componentWillReceiveProps (nextProps) {
    if (nextProps.id !== this.props.id) {
      this.props.dispatch(loadMessage(nextProps.id));
    }
  }

  componentWillUnmount () {
    this.props.dispatch(unloadMessage());
    window.removeEventListener('resize', this._onResize);
  }

  _onResize () {
    if (this.refs.video) {
      clearTimeout(this._timer);
      this._timer = setTimeout(() => {
        // 912 = $max-content-width - double($inuit-base-spacing-unit)
        const width = Math.min(912, window.innerWidth - 48);
        const height = width * 0.5625;
        const video = this.refs.video;
        video.setAttribute('width', width);
        video.setAttribute('height', height);
      }, 200);
    }
  }

  render () {
    const { message: { message, nextMessage, previousMessage } } = this.props;
    const date = moment(message.date);
    let img = '';
    if (message.imageUrl) {
      img = (
        <img className="message__image" src={message.imageUrl}
          alt="message image"/>
      );
    }

    const files = message.files.map(function (file) {
      if (file.vimeoId) {
        return (
          <iframe key={file.id} ref="video"
            className="message__video vimeo-player" type="text/html"
            width="912" height="513"
            src={"http://player.vimeo.com/video/" + file.vimeoId + "?title=0&byline=0&portrait=0"}
            frameBorder="0" webkitAllowFullScreen mozallowfullscreen allowFullScreen>
          </iframe>
        );
      } else if (file.youtubeId) {
        return (
          <iframe key={file.id} ref="video"
            className="message__video youtube-player" type="text/html"
            width="912" height="513"
            src={"http://www.youtube.com/embed/" + file.youtubeId + "?vq=hd720"}
            frameBorder="0" webkitAllowFullScreen mozAllowFullScreen allowFullScreen>
          </iframe>
        );
      } else if (file.contentType.match(/^audio/)) {
        return (
          <audio key={file.id} className="message__audio" controls preload="metadata">
            <source src={file.url}
              type={file.contentType} />
            No audio with this browser
          </audio>
        );
      } else {
        var caption = file.caption || 'Read';
        return (
          <div key={file.id} className="message__file">
            <a href={file.url}>{caption}</a>
          </div>
        );
      }
    });

    let next;
    if (nextMessage) {
      next = messageSummary("Next", nextMessage);
    }

    let previous;
    if (previousMessage) {
      previous = messageSummary("Previous", previousMessage);
    }

    let editControl;
    if (message.editUrl) {
      editControl = (
        <a className={`${CLASS_ROOT}__edit control-icon`} href={message.editUrl}>
          <EditIcon />
        </a>
      );
    }

    return (
      <div className="message">
        <header className="message__header">
          <h1 className="message__title">{message.title}</h1>
          {editControl}
        </header>
        <div className="message__sub-header">
          <span className="message__date">{date.format('MMM D, YYYY')}</span>
          <span className="message__verses">{message.verses}</span>
          <span className="message__author">
            {message.author ? message.author.name : ''}
          </span>
        </div>
        {img}
        {files}
        <footer className="message__footer">
          {next}
          {previous}
        </footer>
      </div>
    );
  }
};

Message.propTypes = {
  id: PropTypes.string,
  message: PropTypes.shape({
    message: PropTypes.object,
    nextMessage: PropTypes.object,
    previousMessage: PropTypes.object
  })
};

let select = (state, props) => ({
  id: iprops.params.id,
  message: state.message
});

export default connect(select)(Message);
