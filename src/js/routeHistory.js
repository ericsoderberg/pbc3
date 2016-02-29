
import { useRouterHistory } from 'react-router';
import createBrowserHistory from 'history/lib/createBrowserHistory';

const createAppHistory = useRouterHistory(createBrowserHistory);

let routeHistory = createAppHistory({
  // parseQueryString: parse,
  // stringifyQuery: stringify
});

export default routeHistory;
