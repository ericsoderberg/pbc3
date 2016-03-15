import App from './components/App';
import AppContext from './components/AppContext';
import Search from './components/Search';
import Page from './components/Page';
import Pages from './components/Pages';
import Accounts from './components/Accounts';
import Calendar from './components/Calendar';
import Holidays from './components/Holidays';
import Libraries from './components/Libraries';
import Messages from './components/Messages';
import Message from './components/Message';
import Resources from './components/Resources';
import Forms from './components/Forms';
import FormFills from './components/FormFills';
import FormFiller from './components/form/FormFiller';
import Payments from './components/Payments';
import Newsletters from './components/Newsletters';
import EmailLists from './components/EmailLists';
import EmailList from './components/EmailList';

export default { path: '/', component: App,
  childRoutes: [
    { path: 'forms/:formId/fills/new', component: FormFiller},
    { path: 'forms/:formId/fills/:id/edit', component: FormFiller},
    { component: AppContext,
      indexRoute: { component: Page },
      childRoutes: [
        { path: 'search', component: Search},
        { path: 'pages', component: Pages},
        { path: 'calendar', component: Calendar},
        { path: 'messages/:id', component: Message},
        { path: 'messages', component: Messages},
        { path: 'accounts', component: Accounts},
        { path: 'resources', component: Resources},
        { path: 'libraries', component: Libraries},
        { path: 'holidays', component: Holidays},
        { path: 'newsletters', component: Newsletters},
        { path: 'email_lists/:id', component: EmailList},
        { path: 'email_lists', component: EmailLists},

        { path: 'forms/:id/fills', component: FormFills},
        { path: 'forms', component: Forms},
        { path: 'payments', component: Payments},
        { path: ':id', component: Page}
      ]}
  ]
};
