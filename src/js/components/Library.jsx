import React, { Component, PropTypes } from 'react';
import { Link } from 'react-router';
// import { connect } from 'react-redux';
// import { loadLibrary, unloadLibrary } from '../actions/actions';
import MessageSummary from './MessageSummary';

const CLASS_ROOT = 'library';

export default class Library extends Component {

  // componentDidMount () {
  //   this.props.dispatch(loadLibrary(this.props.library.id));
  // }
  //
  // componentWillUnmount () {
  //   this.props.dispatch(unloadLibrary(this.props.library.id));
  // }

  render () {
    const { library: { name, path, nextUpcomingMessage, mostRecentMessage } }
      = this.props;
    let nextUpcoming;
    if (nextUpcomingMessage) {
      nextUpcoming = <MessageSummary label="Upcoming" message={nextUpcomingMessage} />;
    }

    let mostRecent;
    if (mostRecentMessage) {
      mostRecent =  <MessageSummary label="Recent" message={mostRecentMessage} />;
    }
    return (
      <div className={CLASS_ROOT}>
        <h1><Link to={path}>{name}</Link></h1>
        {nextUpcoming}
        {mostRecent}
      </div>
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
