import React from 'react';
import PageBuilder from './components/PageBuilder';
import FormBuilder from './components/formBuilder/FormBuilder';

const Root = (props) => (
  <div>{props.children}</div>
);

export default { path: '/', component: Root,
  childRoutes: [
    { path: 'forms/:id/edit_contents', component: FormBuilder},
    { path: 'pages/:id/edit_contents', component: PageBuilder}
  ]
};
