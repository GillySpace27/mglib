; docformat = 'rst'

;+
; Transformers prepare data for an estimator.
;
; Transformers have two main methods, `fit` and `transform`, along with the
; convenience method `fit_transform` that simply calls them both in sequence.
;
; A typical workflow is to fit and transform the training data, then transform
; test data::
;
;   x_train_transformed = trans->fit_transform(x_train)
;   x_test_transformed = trans->transform(x_test)
;-


;= API

;+
; Use training data `x` to determine the transformation.
;
; :Abstract:
;
; :Params:
;   x : in, required, type="fltarr(n_features, n_samples)"
;     data to learn on
;-
pro mg_transformer::fit, x, feature_names=feature_names
  compile_opt strictarr

  if (n_elements(feature_names) eq 0L) then begin
    if (*self.feature_names eq 0L) then begin
      dims = size(x, /dimensions)
      self->setProperty, feature_names=strtrim(lindgen(dims[0]), 2)
    endif
  endif else self->setProperty, feature_names=feature_names

  ; not implemented
end


;+
; Apply the learned transform to `x`.
;
; :Abstract:
;
; :Returns:
;   `fltarr(n_new_features, n_samples)`
;
; :Params:
;   x : in, required, type="fltarr(n_features, n_samples)"
;     data to transform
;-
function mg_transformer::transform, x
  compile_opt strictarr

  ; not implemented
end


;+
; Convenience method that performs a `fit` and then a `transform`.
;
; :Returns:
;   `fltarr(n_new_features, n_samples)`
;
; :Params:
;   x : in, required, type="fltarr(n_features, n_samples)"
;     data to fit and transform
;-
function mg_transformer::fit_transform, x, _extra=e
  compile_opt strictarr

  self->fit, x, _extra=e
  return, self->transform(x)
end


;= property access

;+
; Get property values.
;-
pro mg_transformer::getProperty, feature_names=feature_names
  compile_opt strictarr

  if (arg_present(feature_names)) then feature_names = *self.feature_names
end


;+
; Set property values.
;-
pro mg_transformer::setProperty, feature_names=feature_names
  compile_opt strictarr

  if (n_elements(feature_names) gt 0L) then *self.feature_names = feature_names
end


;= lifecycle methods

;+
; Free resources
;-
pro mg_transformer::cleanup
  compile_opt strictarr

  ptr_free, self.feature_names
end


;+
; Create transformer object.
;
; :Returns:
;   1 for success, 0 for failure
;-
function mg_transformer::init, _extra=e
  compile_opt strictarr

  self.feature_names = ptr_new(/allocate_heap)

  self->setProperty, _extra=e

  return, 1
end


;+
; Define the transfomer class.
;-
pro mg_transformer__define
  compile_opt strictarr

  !null = {mg_transformer, inherits IDL_Object, $
           feature_names: ptr_new() $
          }
end
