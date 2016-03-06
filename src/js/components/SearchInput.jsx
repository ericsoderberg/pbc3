import React, { Component, PropTypes } from 'react';
import SearchIcon from './icons/SearchIcon';
import CloseIcon from './icons/CloseIcon';
import REST from '../utils/REST';

const ROOT_CLASS = "search-input";

export default class SearchInput extends Component {

  constructor (props) {
    super(props);
    this._onChange = this._onChange.bind(this);
    this._onKeyDown = this._onKeyDown.bind(this);
    this._onClear = this._onClear.bind(this);
    this._onMouseDownSuggestion = this._onMouseDownSuggestion.bind(this);
    this._onFocus = this._onFocus.bind(this);
    this._onBlur = this._onBlur.bind(this);
    this._onResize = this._onResize.bind(this);
    this.state = {
      active: false,
      text: props.text || '',
      suggestions: props.suggestions || [],
      suggestion: null
    };
  }

  componentDidMount () {
    window.addEventListener('resize', this._onResize);
    this._onResize();
  }

  componentWillReceiveProps (nextProps) {
    this.setState({text: nextProps.text});
  }

  componentWillUnmount () {
    window.removeEventListener('resize', this._onResize);
  }

  _notify (text) {
    clearTimeout(this._changeTimer);
    this._changeTimer = setTimeout(() => {
      this.props.onChange(text);
    }, 200);
  }

  _getSuggestions () {
    if (this.state.text && this.props.suggestionsPath) {
      var path = this.props.suggestionsPath + encodeURIComponent(this.state.text);
      REST.get(path).then(response => {
        this.setState({suggestions: response.body});
      });
    } else {
      this.setState({suggestions: []});
    }
  }

  _onChange (event) {
    var text = event.target.value;
    this.setState({text: text}, () => {
      clearTimeout(this._suggestionsTimer);
      this._suggestionsTimer = setTimeout(() => {
        this._getSuggestions(text);
      }, 100);
      this._notify(this.state.text);
    });
  }

  _onKeyDown (event) {
    //console.log('!!!', event.keyCode);
    if (13 === event.keyCode) { // Enter
      if (this.state.suggestion) {
        this.setState({text: this.state.suggestion}, () => {
          this._notify(this.state.suggestion);
          this.refs.input.blur();
        });
      } else {
        this.refs.input.blur();
      }
    } else if (27 === event.keyCode) { // ESC
      this.refs.input.blur();
    } else if (40 === event.keyCode) { // down
      var selectNext = (this.state.suggestion === null);
      this.state.suggestions.some(suggestion => {
        if (typeof suggestion === 'string') {
          if (selectNext) {
            this.setState({suggestion: suggestion});
            selectNext = false;
            return true;
          } else if (suggestion === this.state.suggestion) {
            selectNext = true;
          }
        } else {
          return suggestion.suggestions.some(item => {
            if (selectNext) {
              this.setState({suggestion: item});
              selectNext = false;
              return true;
            } else if (item === this.state.suggestion) {
              selectNext = true;
            }
          });
        }
      });
    } else if (38 === event.keyCode) { // up
      var prior = null;
      this.state.suggestions.some(suggestion => {
        if (typeof suggestion === 'string') {
          if (suggestion === this.state.suggestion) {
            this.setState({suggestion: prior});
            return true;
          }
          prior = suggestion;
        } else {
          return suggestion.suggestions.some(item => {
            if (item === this.state.suggestion) {
              this.setState({suggestion: prior});
              return true;
            }
            prior = item;
          });
        }
      });
    }
  }

  _onClear () {
    var text = '';
    this.setState({text: text, suggestions: []}, () => {
      this.refs.input.focus();
      this._notify(this.state.text);
    });
  }

  _onMouseDownSuggestion (suggestion) {
    this.setState({active: false, text: suggestion}, () => {
      this.props.onChange(this.state.text);
    });
  }

  _onFocus (event) {
    //console.log('!!! SearchInput _onFocus');
    var input = event.target;
    this.setState({active: true});
    // select all text
    setTimeout(() => {
      input.select();
    }, 1);
  }

  _onBlur (event) {
    //console.log('!!! SearchInput _onBlur');
    //var element = event.target;
    //while (element && ! element.classList.contains("search-input");) { element = element.parentNode }
    this.setState({active: false});
    //this.props.onChange(this.state.text);
  }

  _onResize (event) {
    var containerElement = this.refs.container;
    var inputElement = this.refs.input;
    var suggestionsElement = this.refs.suggestions;
    var containerRect = containerElement.getBoundingClientRect();
    var inputRect = inputElement.getBoundingClientRect();
    suggestionsElement.style.top = (inputRect.bottom - containerRect.top) + 'px';
  }

  render () {
    var classes = [ROOT_CLASS];
    if (this.state.active) {
      classes.push(ROOT_CLASS + "--active");
    }
    if (this.state.text && this.state.text.length > 20) {
      classes.push(ROOT_CLASS + "--long");
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

    var suggestions = this.state.suggestions.map((suggestion, index) => {
      if (typeof suggestion === 'string') {
        var suggestionClasses = [ROOT_CLASS + "__suggestion"];
        if (suggestion === this.state.suggestion) {
          suggestionClasses.push(ROOT_CLASS + "__suggestion--active");
        }
        return (
          <li key={suggestion + index} className={suggestionClasses.join(' ')}
            onMouseDown={this._onMouseDownSuggestion.bind(this, suggestion)}>
            {suggestion}
          </li>
        );
      } else {
        var items = suggestion.suggestions.map(item => {
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
        });
        return (
          <li key={suggestion.label + index} className={ROOT_CLASS + "__suggestions-section"}>
            <div className={ROOT_CLASS + "__suggestions-section-label"}>
              {suggestion.label}
            </div>
            <ol className="list-bare">
              {items}
            </ol>
          </li>
        );
      }
    });

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
          <span className={clearClasses.join(' ')} onClick={this._onClear}>
            <CloseIcon />
          </span>
        </header>
        <ol ref="suggestions" className={suggestionsClasses.join(' ')}>
          {suggestions}
        </ol>
      </div>
    );
  }
};

SearchInput.propTypes = {
  text: PropTypes.string,
  suggestionsPath: PropTypes.string,
  placeholder: PropTypes.string,
  onChange: PropTypes.func
};
