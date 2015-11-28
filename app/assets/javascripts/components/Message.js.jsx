var Link = require('./Link');
var moment = require('moment');
var EditIcon = require('./icons/EditIcon');

var CLASS_ROOT = "message";

function messageSummary(label, message, onClick) {
  var date = moment(message.date);
  var author = (message.author ? message.author.name : '');
  return (
    <div className="message__footer-item">
      <span className="message__footer-label">{label}</span>
      <span className="message__footer-date">{date.format('MMM D, YYYY')}</span>
      <Link className="message__footer-title" href={message.url}>{message.title}</Link>
      <span className="message__footer-verses">{message.verses}</span>
      <span className="message__footer-author">{author}</span>
    </div>
  );
}

var Message = React.createClass({

  propTypes: {
    message: React.PropTypes.object,
    nextMessage: React.PropTypes.object,
    previousMessage: React.PropTypes.object
  },

  _onResize: function () {
    if (this.refs.video) {
      clearTimeout(this._timer);
      this._timer = setTimeout(function () {
        var width = Math.min(912, window.innerWidth - 48); // 912 = $max-content-width - double($inuit-base-spacing-unit)
        var height = width * 0.5625;
        var video = this.refs.video.getDOMNode();
        video.setAttribute('width', width);
        video.setAttribute('height', height);
      }.bind(this), 200);
    }
  },

  getInitialState: function () {
    return {
      message: this.props.message,
      nextMessage: this.props.nextMessage,
      previousMessage: this.props.previousMessage
    };
  },

  componentDidMount: function () {
    window.addEventListener('resize', this._onResize);
    this._onResize();
  },

  componentWillUnmount: function () {
    window.removeEventListener('resize', this._onResize);
  },

  render: function () {
    var message = this.state.message;
    var date = moment(message.date);
    var img = '';
    if (message.imageUrl) {
      img = (<img className="message__image" src={message.imageUrl} alt="message image"/>);
    }

    var files = message.files.map(function (file) {
      if (file.vimeoId) {
        return (
          <iframe key={file.id} ref="video" className="message__video vimeo-player" type="text/html"
            width="912" height="513"
            src={"http://player.vimeo.com/video/" + file.vimeoId + "?title=0&byline=0&portrait=0"}
            frameborder="0" webkitAllowFullScreen mozallowfullscreen allowFullScreen>
          </iframe>
        );
      } else if (file.youtubeId) {
        return (
          <iframe key={file.id} ref="video" className="message__video youtube-player" type="text/html"
            width="912" height="513"
            src={"http://www.youtube.com/embed/" + file.youtubeId + "?vq=hd720"}
            frameborder="0" webkitAllowFullScreen mozallowfullscreen allowfullscreen>
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
        var caption = file.caption || 'Read'
        return (
          <div key={file.id} className="message__file">
            <a href={file.url}>{caption}</a>
          </div>
        );
      }
    });

    var next = '';
    if (this.state.nextMessage) {
      var nextMessage = this.state.nextMessage;
      next = messageSummary("Next", nextMessage);
    }

    var previous = '';
    if (this.state.previousMessage) {
      var previousMessage = this.state.previousMessage;
      previous = messageSummary("Previous", previousMessage);
    }

    var editControl;
    if (message.editUrl) {
      editControl = (
        <a className={CLASS_ROOT + "__edit control-icon"} href={message.editUrl}>
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
});

module.exports = Message;
