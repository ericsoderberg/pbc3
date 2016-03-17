import React, { Component, PropTypes } from 'react';
// import { connect } from 'react-redux';
// import { loadLibrary, unloadLibrary } from '../actions/actions';

export default class Library extends Component {

  // componentDidMount () {
  //   this.props.dispatch(loadLibrary(this.props.library.id));
  // }
  //
  // componentWillUnmount () {
  //   this.props.dispatch(unloadLibrary(this.props.library.id));
  // }

  render () {
    const { library } = this.props;
    return (
      <h1>{library.name}</h1>
    );
  }
};

Library.propTypes = {
  library: PropTypes.object.isRequired
};

// let select = (state, props) => ({
//   library: state.library
// });
//
// export default connect(select)(Library);
