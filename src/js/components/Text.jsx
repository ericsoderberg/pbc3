import React, { Component } from 'react';
import MarkdownIt from 'markdown-it';

const md = new MarkdownIt();
const CLASS_ROOT = "text";

export default class Text extends Component {

  render () {
    const html = md.render(this.props.text.text);
    return (
      <div className={CLASS_ROOT} dangerouslySetInnerHTML={{__html: html}} />
    );
  }
};
