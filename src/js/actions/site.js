import REST from '../utils/REST';

export const SITE_LOAD = 'SITE_LOAD';
export const SITE_LOAD_SUCCESS = 'SITE_LOAD_SUCCESS';

export function loadSite () {
  return function (dispatch) {
    dispatch({ type: SITE_LOAD });
    REST.get('/site').then((res) => {
      dispatch({ type: SITE_LOAD_SUCCESS, site: res.body.site });
    });
  };
}
