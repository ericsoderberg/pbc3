var BooksFilter = React.createClass({
  
  _onChangeTestament: function (name) {
    var testaments = this.state.testaments;
    var sections = this.state.sections;
    var books = this.state.books;
    if (testaments[name]) {
      delete testaments[name];
      this.props.testaments.forEach(function (testament) {
        if (name === testament.name) {
          testament.sections.forEach(function (section) {
            delete sections[section.name];
            section.books.forEach(function (book) {
              delete books[book.name];
            }, this);
          }, this);
        }
      }, this);
    } else {
      testaments[name] = true;
      this.props.testaments.forEach(function (testament) {
        if (name === testament.name) {
          testament.sections.forEach(function (section) {
            sections[section.name] = true;
            section.books.forEach(function (book) {
              books[book.name] = true;
            }, this);
          }, this);
        }
      }, this);
    }
    state = {testaments: testaments, sections: sections, books: books}
    this.setState(state);
    if (this.props.onChange) {
      this.props.onChange(state);
    }
  },
  
  _onChangeSection: function (name) {
    var sections = this.state.sections;
    var books = this.state.books;
    if (sections[name]) {
      delete sections[name];
      this.props.testaments.forEach(function (testament) {
        testament.sections.forEach(function (section) {
          if (name === section.name) {
            section.books.forEach(function (book) {
              delete books[book.name];
            }, this);
          }
        }, this);
      }, this);
    } else {
      sections[name] = true;
      this.props.testaments.forEach(function (testament) {
        testament.sections.forEach(function (section) {
          if (name === section.name) {
            section.books.forEach(function (book) {
              books[book.name] = true;
            }, this);
          }
        }, this);
      }, this);
    }
    state = {testaments: this.state.testaments, sections: sections, books: books}
    this.setState(state);
    if (this.props.onChange) {
      this.props.onChange(state.books); // just books for now
    }
  },
  
  _onChangeBook: function (name) {
    var books = this.state.books;
    if (books[name]) {
      delete books[name];
    } else {
      books[name] = true;
    }
    state = {testaments: this.state.testaments, sections: this.state.sections, books: books}
    this.setState(state);
    if (this.props.onChange) {
      this.props.onChange(state);
    }
  },
  
  getInitialState: function () {
    return {testaments: {}, sections: {}, books: {}}
  },
 
  render: function () {
    var testaments = this.props.structure.map(function (testament, index) {
      
      var sections = testament.sections.map(function (section, index) {
        
        var books = section.books.map(function (book, index) {
          return (
            <li key={index} className="books-filter__book">
              <input type="checkbox" id={book}
                checked={this.state.books[book]}
                onChange={this._onChangeBook.bind(this, book)} />
              <label htmlFor={book}>{book}</label>
            </li>
          );
        }, this);
        
        return (
          <li key={index} className="books-filter__section">
            <input type="checkbox" id={section.name}
              checked={this.state.sections[section.name]}
              onChange={this._onChangeSection.bind(this, section.name)} />
            <label htmlFor={section.name}>{section.name}</label>
            <ol className="books-filter__books list-bare">
              {books}
            </ol>
          </li>
        );
      }, this);
      
      return (
        <li key={index} className="books-filter__testament">
          <input type="checkbox" id={testament.name}
            checked={this.state.testaments[testament.name]}
            onChange={this._onChangeTestament.bind(this, testament.name)} />
          <label htmlFor={testament.name}>{testament.name}</label>
          <ol className="books-filter__sections list-bare">
            {sections}
          </ol>
        </li>
      );
    }, this);
    
    return (
      <div className="books-filter">
        <ol className="books-filter__testaments list-bare">
          {testaments}
        </ol>
      </div>
    );
  }
});

module.exports = BooksFilter;
