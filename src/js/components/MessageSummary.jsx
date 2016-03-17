import React, { PropTypes } from 'react';
import { Link } from 'react-router';
import moment from 'moment';

var CLASS_ROOT = "message-summary";

var MessageSummary = (props) => {
  const { label, message } = props;
  var date = moment(message.date);
  var author = (message.author ? message.author.name : '');
  return (
    <div className={CLASS_ROOT}>
      <span className={`${CLASS_ROOT}__label`}>{label}</span>
      <span className={`${CLASS_ROOT}__date`}>{date.format('MMM D, YYYY')}</span>
      <Link className={`${CLASS_ROOT}__title`} to={message.path}>{message.title}</Link>
      <span className={`${CLASS_ROOT}__verses`}>{message.verses}</span>
      <span className={`${CLASS_ROOT}__author`}>{author}</span>
    </div>
  );
};

MessageSummary.propTypes = {
  label: PropTypes.string,
  message: PropTypes.shape({
    author: PropTypes.shape({
      name: PropTypes.string
    }),
    date: PropTypes.string,
    path: PropTypes.string,
    title: PropTypes.string,
    verses: PropTypes.string
  })
};

export default MessageSummary;
