var CLASS_ROOT = "item";

var Item = React.createClass({

  _layout: function () {
    var rect = this.refs.item.getDOMNode().getBoundingClientRect();
    this.setState({
      width: rect.width,
      height: Math.round(rect.width * 9 / 16)
    });
  },

  _onResize: function () {
    clearTimeout(this._resizeTimer);
    this._resizeTimer = setTimeout(this._layout, 100);
  },

  getInitialState: function () {
    return {
      width: 400,
      height: 300
    };
  },

  componentDidMount: function () {
    window.addEventListener('resize', this._onResize);
    this._layout();
  },

  componentWillUnmount: function () {
    window.removeEventListener('resize', this._onResize);
  },

  render: function() {
    var item = this.props.item;
    var classes = [CLASS_ROOT, CLASS_ROOT + "--" + item.kind];
    var contents;
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
});

module.exports = Item;
