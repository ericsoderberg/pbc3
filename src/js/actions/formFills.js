import REST from '../utils/REST';

export const FORM_FILLS_LOAD = 'FORM_FILLS_LOAD';
export const FORM_FILLS_LOAD_SUCCESS = 'FORM_FILLS_LOAD_SUCCESS';
export const FORM_FILLS_UNLOAD = 'FORM_FILLS_UNLOAD';

// Form Fills

export function loadFormFills (formId) {
  return function (dispatch) {
    dispatch({ type: FORM_FILLS_LOAD, formId: formId });
    REST.get(`/forms/${formId}/fills/user`).then(response => {
      dispatch({
        type: FORM_FILLS_LOAD_SUCCESS,
        form: response.body.form,
        formFills: response.body.formFills,
        newPath: response.body.newPath
      });
    });
  };
}

export function unloadFormFills (formId) {
  return { type: FORM_FILLS_UNLOAD, formId: formId };
}
