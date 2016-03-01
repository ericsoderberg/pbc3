import React from 'react';
import PageBuilder from './components/PageBuilder';
import FormBuilder from './components/formBuilder/FormBuilder';
import FormFiller from './components/form/FormFiller';

const Root = (props) => (
  <div>{props.children}</div>
);

export default { path: '/', component: Root,
  childRoutes: [
    { path: 'forms/:id/edit_contents', component: FormBuilder},
    { path: 'forms/:formId/fills/new', component: FormFiller},
    { path: 'forms/:formId/fills/:id/edit', component: FormFiller},
    { path: 'pages/:id/edit_contents', component: PageBuilder}
  ]
};
