import React, { Component, PropTypes } from 'react';
import { connect } from 'react-redux';
import { loadSite } from '../actions/actions';
import AppHeader from './AppHeader';
import AppFooter from './AppFooter';

class App extends Component {

  componentDidMount () {
    this.props.dispatch(loadSite());
  }

  static fetchData () {
    this.props.dispatch(loadSite());
  }

  render () {
    const { site } = this.props;
    return (
      <div className="app">
        <AppHeader logoUrl={site.logoUrl} />
        {this.props.children}
        <AppFooter site={site} />
      </div>
    );
  }
};

App.propTypes = {
  site: PropTypes.shape({
    address: PropTypes.string,
    copyright: PropTypes.string,
    logoUrl: PropTypes.string,
    menuActions: PropTypes.arrayOf(PropTypes.oneOfType([PropTypes.object, PropTypes.array])),
    phone: PropTypes.string
  })
};

let select = (state) => ({site: state.site});

export default connect(select)(App);
