import React, { Component } from 'react';

const CLASS_ROOT = "item";

export default class Item extends Component {

  constructor () {
    super();
    this._onResize = this._onResize.bind(this);
    this._layout = this._layout.bind(this);
    this.state = {
      width: 400,
      height: 300
    };
  }

  componentDidMount () {
    window.addEventListener('resize', this._onResize);
    this._layout();
  }

  componentWillUnmount () {
    window.removeEventListener('resize', this._onResize);
  }

  _layout () {
    var rect = this.refs.item.getBoundingClientRect();
    this.setState({
      width: rect.width,
      height: Math.round(rect.width * 9 / 16)
    });
  }

  _onResize () {
    clearTimeout(this._resizeTimer);
    this._resizeTimer = setTimeout(this._layout, 100);
  }

  render () {
    const { item } = this.props;
    let classes = [CLASS_ROOT, `${CLASS_ROOT}--${item.kind}`];
    let contents;
    if ('image' === item.kind) {
      contents = <img src={item.url} />;
    } else if ('document' === item.kind) {
      contents = <a href={item.url}>{item.name || item.url}</a>;
    } else if ('audio' === item.kind) {
      contents = (
        <audio controls preload="metadata">
          <source src={item.url}/>
        </audio>
      );
    } else if ('video' === item.kind) {
      if (item.url.match(/vimeo/)) {
        // convert generic URL to embedded player URL
        // https://vimeo.com/136228343
        // to:
        // https://player.vimeo.com/video/136228343?portrait=0&badge=0
        var url = item.url.replace('/vimeo.com/', '/player.vimeo.com/video/') +
          '?portrait=0&badge=0';
        contents = (
          <iframe className="vimeo-player" type="text/html"
            width={this.state.width} height={this.state.height}
            src={url}
            frameBorder="0"
            webkitAllowFullScreen mozallowfullscreen allowFullScreen>
          </iframe>
        );
      } else if (item.url.match(/youtube/)) {
        // convert generic URL to embedded player URL
        // https://www.youtube.com/watch?v=FkJBK3-R_Aw
        // to:
        // https://www.youtube.com/embed/FkJBK3-R_Aw
        var id = item.url.split('=')[1];
        var url = item.url.replace(/\/watch.*/, '/embed/' + id);
        contents = (
          <iframe className="youtube-player" type="text/html"
            width={this.state.width} height={this.state.height}
            src={url}
            frameBorder="0">
          </iframe>
        );
      } else {
        contents = (
          <video controls>
            <source src={item.url}/>
          </video>
        );
      }
    } else {
      contents = "I'm not sure what kind of item this is.";
    }
    return (
      <div ref="item" className={classes.join(' ')}>
        {contents}
      </div>
    );
  }
};
