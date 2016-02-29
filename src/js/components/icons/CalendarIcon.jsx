import React, { Component } from 'react';

export default class CalendarIcon extends Component {

  render () {
    return (
      <svg className={this.props.className} version="1.1"
        width="24px" height="24px" viewBox="0 0 24 24"
        fill="#6E615D">
        <g fill="none" fillRule="evenodd" strokeLinejoin="round">
        <path d="M0,3 L24,3" strokeWidth="6"></path>
        <path d="M0,11.5 L6,11.5" strokeWidth="5"></path>
        <path d="M9,11.5 L15,11.5" strokeWidth="5"></path>
        <path d="M18,11.5 L24,11.5" strokeWidth="5"></path>
        <path d="M0,19.5 L6,19.5" strokeWidth="5"></path>
        <path d="M9,19.5 L15,19.5" strokeWidth="5"></path>
        <path d="M18,19.5 L24,19.5" strokeWidth="5"></path>
        </g>
      </svg>
    );
  }
};
