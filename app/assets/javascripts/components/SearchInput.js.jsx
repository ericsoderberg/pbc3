var SearchIcon = require('./SearchIcon');
var CloseIcon = require('./CloseIcon');
var REST = require('./REST');

var ROOT_CLASS = "search-input";

var SearchInput = React.createClass({

  propTypes: {
    text: React.PropTypes.string,
    suggestionsPath: React.PropTypes.string,
    placeholder: React.PropTypes.string,
    onChange: React.PropTypes.func
  },

  _notify: function (text) {
    clearTimeout(this._changeTimer);
    this._changeTimer = setTimeout(function () {
      this.props.onChange(text);
    }.bind(this), 500);
  },

  _getSuggestions: function () {
    if (this.state.text && this.props.suggestionsPath) {
      var path = this.props.suggestionsPath + encodeURIComponent(this.state.text);
      REST.get(path, function (response) {
        this.setState({suggestions: response});
      }.bind(this));
    } else {
      this.setState({suggestions: []});
    }
  },

  _onChange: function (event) {
    var text = event.target.value;
    this.setState({text: text}, function () {
      clearTimeout(this._suggestionsTimer);
      this._suggestionsTimer = setTimeout(function () {
        this._getSuggestions(text);
      }.bind(this), 100);
      this._notify(this.state.text);
    });
  },

  _onKeyDown: function (event) {
    //console.log('!!!', event.keyCode);
    if (13 === event.keyCode) { // Enter
      if (this.state.suggestion) {
        this.setState({text: this.state.suggestion}, function () {
          this._notify(this.state.suggestion);
          this.refs.input.getDOMNode().blur();
        });
      } else {
        this.refs.input.getDOMNode().blur();
      }
    } else if (27 === event.keyCode) { // ESC
      this.refs.input.getDOMNode().blur();
    } else if (40 === event.keyCode) { // down
      var selectNext = (this.state.suggestion === null);
      this.state.suggestions.some(function (suggestion) {
        if (typeof suggestion === 'string') {
          if (selectNext) {
            this.setState({suggestion: suggestion});
            selectNext = false;
            return true;
          } else if (suggestion === this.state.suggestion) {
            selectNext = true;
          }
        } else {
          return suggestion.suggestions.some(function (item) {
            if (selectNext) {
              this.setState({suggestion: item});
              selectNext = false;
              return true;
            } else if (item === this.state.suggestion) {
              selectNext = true;
            }
          }.bind(this));
        }
      }.bind(this));
    } else if (38 === event.keyCode) { // up
      var prior = null;
      this.state.suggestions.some(function (suggestion) {
        if (typeof suggestion === 'string') {
          if (suggestion === this.state.suggestion) {
            this.setState({suggestion: prior});
            return true;
          }
          prior = suggestion;
        } else {
          return suggestion.suggestions.some(function (item) {
            if (item === this.state.suggestion) {
              this.setState({suggestion: prior});
              return true;
            }
            prior = item;
          }.bind(this));
        }
      }.bind(this));
    }
  },

  _onClickClear: function () {
    var text = '';
    this.setState({text: text, suggestions: []}, function () {
      this.refs.input.getDOMNode().focus();
      this._notify(this.state.text);
    });
  },

  _onMouseDownSuggestion: function (suggestion) {
    this.setState({active: false, text: suggestion}, function () {
      this.props.onChange(this.state.text);
    });
  },

  _onFocus: function (event) {
    //console.log('!!! SearchInput _onFocus');
    var input = event.target;
    this.setState({active: true});
    // select all text
    setTimeout(function () {input.select();}, 1);
  },

  _onBlur: function (event) {
    //console.log('!!! SearchInput _onBlur');
    //var element = event.target;
    //while (element && ! element.classList.contains("search-input");) { element = element.parentNode }
    this.setState({active: false});
    //this.props.onChange(this.state.text);
  },

  _onResize: function (event) {
    var containerElement = this.refs.container.getDOMNode();
    var inputElement = this.refs.input.getDOMNode();
    var suggestionsElement = this.refs.suggestions.getDOMNode();
    var containerRect = containerElement.getBoundingClientRect();
    var inputRect = inputElement.getBoundingClientRect();
    suggestionsElement.style.top = (inputRect.bottom - containerRect.top) + 'px';
  },

  getInitialState: function () {
    return {
      active: false,
      text: this.props.text || '',
      suggestions: this.props.suggestions || [],
      suggestion: null
    };
  },

  componentDidMount: function () {
    window.addEventListener('resize', this._onResize);
    this._onResize();
  },

  componentWillReceiveProps: function (nextProps) {
    this.setState({text: nextProps.text});
  },

  componentWillUnmount: function () {
    window.removeEventListener('resize', this._onResize);
  },

  render: function() {
    var classes = [ROOT_CLASS];
    if (this.state.active) {
      classes.push(ROOT_CLASS + "--active");
    }
    if (this.props.className) {
      classes.push(this.props.className);
    }

    var iconClasses = [ROOT_CLASS + "__icon"];
    var clearClasses = [ROOT_CLASS + "__clear"];
    if (this.state.text) {
      clearClasses.push(ROOT_CLASS + "__clear--active");
    } else {
      iconClasses.push(ROOT_CLASS + "__icon--active");
    }

    var suggestions = this.state.suggestions.map(function (suggestion) {
      if (typeof suggestion === 'string') {
        var suggestionClasses = [ROOT_CLASS + "__suggestion"];
        if (suggestion === this.state.suggestion) {
          suggestionClasses.push(ROOT_CLASS + "__suggestion--active");
        }
        return (
          <li key={suggestion} className={suggestionClasses.join(' ')}
            onMouseDown={this._onMouseDownSuggestion.bind(this, suggestion)}>
            {suggestion}
          </li>
        );
      } else {
        var items = suggestion.suggestions.map(function (item) {
          var suggestionClasses = [ROOT_CLASS + "__suggestion"];
          if (item === this.state.suggestion) {
            suggestionClasses.push(ROOT_CLASS + "__suggestion--active");
          }
          return (
            <li key={item} className={suggestionClasses.join(' ')}
              onMouseDown={this._onMouseDownSuggestion.bind(this, item)}>
              {item}
            </li>
          );
        }.bind(this));
        return (
          <li key={suggestion.label} className={ROOT_CLASS + "__suggestions-section"}>
            <div className={ROOT_CLASS + "__suggestions-section-label"}>
              {suggestion.label}
            </div>
            <ol className="list-bare">
              {items}
            </ol>
          </li>
        );
      }
    }.bind(this));

    var suggestionsClasses = [ROOT_CLASS + "__suggestions", "list-bare"];
    if (suggestions.length > 0) {
      suggestionsClasses.push(ROOT_CLASS + "__suggestions--active");
    }

    return (
      <div ref="container" className={classes.join(' ')}>
        <header className={ROOT_CLASS + "__header"}>
          <input ref="input" className={ROOT_CLASS + "__input"}
            value={this.state.text}
            onFocus={this._onFocus}
            onBlur={this._onBlur}
            onChange={this._onChange}
            onKeyDown={this._onKeyDown} />
          <span className={iconClasses.join(' ')}>
            <SearchIcon />
          </span>
          <span className={clearClasses.join(' ')} onClick={this._onClickClear}>
            <CloseIcon />
          </span>
        </header>
        <ol ref="suggestions" className={suggestionsClasses.join(' ')}>
          {suggestions}
        </ol>
      </div>
    );
    //             placeholder={this.props.placeholder || "Type to search"}

  }
});

module.exports = SearchInput;
