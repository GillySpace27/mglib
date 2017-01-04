; docformat = 'rst'

;+
; Compute normal coordinates for subplot.
;
; :Private:
; 
; :Returns:
;   `fltarr(4)`
;
; :Params:
;   col : in, required, type=integer
;     column (0 is leftmost)
;   row : in, required, type=integer
;     row (0 is topmost)
;
; :Keywords:
;   dimension : in, required, type=integer
;     number of rows/columns in matrix
;-
function mg_scatterplot_matrix_position, col, row, $
                                         dimension=dimension, $
                                         position=position
  compile_opt strictarr

  _position = n_elements(position) eq 0L ? [0.1, 0.1, 0.975, 0.975] : position

  pos = [float(col) / dimension, $
         1.0 - (row + 1.0) / dimension, $
         (col + 1.0) / dimension, $
         1.0 - float(row) / dimension]

  ; now convert to inside POSITION
  x_range = [0.1, 0.975]
  y_range = [0.1, 0.975]
  return, [pos[0] * (_position[2] - _position[0]) + _position[0], $
           pos[1] * (_position[3] - _position[1]) + _position[1], $
           pos[2] * (_position[2] - _position[0]) + _position[0], $
           pos[3] * (_position[3] - _position[1]) + _position[1]]
end


;+
; Create a matrix of scatter plots.
;
; :Examples:
;   Try the main-level example program at the end of this file::
;
;     IDL> .run mg_scatterplot_matrix
;
;   This should produce:
;
;   .. image:: scatterplot_matrix.png
;
; :Params:
;   data : in, required, type="fltarr(m, n)"
;     m data sets of n elements each
;
; :Keywords:
;   columns_names : in, optional, type=strarr
;     x- and y-titles
;   _extra : in, optional, type=keywords
;     keywords to `PLOT`, `MG_HISTPLOT`, or `HISTOGRAM` routines
;-
pro mg_scatterplot_matrix, data, column_names=column_names, $
                           bar_color=bar_color, $
                           psym=psym, symsize=symsize, $
                           axis_color=axis_color, color=color, $
                           position=position, _extra=e
  compile_opt strictarr

  _psym = n_elements(psym) eq 0L ? 3 : psym
  dims = size(data, /dimensions)
  _column_names = n_elements(column_names) eq 0L ? strarr(dims[1]) : column_names

  x_range = fltarr(2, dims[0])
  y_range = fltarr(2, dims[0])

  for row = 0L, dims[0] - 1L do begin
    col = row
    h = histogram(data[row, *], locations=bins, _extra=e)
    mg_histplot, bins, h, /fill, axis_color=axis_color, color=bar_color, $
                 position=mg_scatterplot_matrix_position(col, row, dimension=dims[0], position=position), $
                 xtitle=row eq (dims[0] - 1) ? _column_names[col] : '', $
                 xrange=x_range[*, col], yrange=[0, max(h) * 1.10], $
                 xstyle=1, ystyle=1, $
                 xtickname=strarr(40) + (row eq [dims[0] - 1] ? '' : ' '), $
                 yticks=1, yminor=1, ytickname=strarr(2) + ' ', $
                 /noerase, _extra=e
    x_range[*, row] = !x.range
  endfor

  for row = 0L, dims[0] - 1L do begin
    col = (row + dims[0] - 1) mod dims[0]
    plot, data[col, *], data[row, *], /nodata, /noerase, $
          xtitle=row eq (dims[0] - 1) ? _column_names[col] : '', $
          ytitle=col eq 0L ? _column_names[row] : '', $
          color=axis_color, $
          position=mg_scatterplot_matrix_position(col, row, dimension=dims[0], position=position), $
          xrange=x_range[*, col], $
          xstyle=1, /ynozero, $
          xtickname=strarr(40) + (row eq [dims[0] - 1] ? '' : ' '), $
          ytickname=strarr(40) + (col eq 0L ? '' : ' '), $
          _extra=e
    y_range[*, row] = !y.crange
    mg_plots, reform(data[col, *]), reform(data[row, *]), psym=_psym, $
              color=color, symsize=symsize, _extra=e
  endfor

  for row = 0L, dims[0] - 1L do begin
    for col = 0L, dims[0] - 1L do begin
      if (col eq (row + dims[0] - 1) mod dims[0]) then continue
      if (row eq 0 && col eq 0) then begin
        plot, data[col, *], data[row, *], /nodata, /noerase, $
              xtitle=row eq (dims[0] - 1) ? _column_names[col] : '', $
              ytitle=col eq 0L ? _column_names[row] : '', $
              color=axis_color, $
              position=mg_scatterplot_matrix_position(col, row, dimension=dims[0], position=position), $
              xrange=x_range[*, col], yrange=y_range[*, row], $
              xstyle=5, ystyle=9, $
              xtickname=strarr(40) + (row eq [dims[0] - 1] ? '' : ' '), $
              ytickname=strarr(40) + (col eq 0L ? '' : ' '), $
              _extra=e
      endif
      if (col ne row) then begin
        plot, data[col, *], data[row, *], /nodata, /noerase, $
              xtitle=row eq (dims[0] - 1) ? _column_names[col] : '', $
              ytitle=col eq 0L ? _column_names[row] : '', $
              color=axis_color, $
              position=mg_scatterplot_matrix_position(col, row, dimension=dims[0], position=position), $
              xrange=x_range[*, col], yrange=y_range[*, row], $
              xstyle=1, ystyle=1, $
              xtickname=strarr(40) + (row eq [dims[0] - 1] ? '' : ' '), $
              ytickname=strarr(40) + (col eq 0L ? '' : ' '), $
              _extra=e
        mg_plots, reform(data[col, *]), reform(data[row, *]), psym=_psym, $
                  color=color, symsize=symsize, _extra=e
      endif
    endfor
  endfor
end


; main-level example program

ps = 0

mg_constants

m = 4
n = 40

if (keyword_set(ps)) then mg_psbegin, filename='scatterplot_matrix.ps'
mg_window, xsize=10, ysize=10, /inches, title='mg_scatterplot_matrix example'

data = randomu(seed, m, n)

mg_scatterplot_matrix, data, $
                       psym=!mg.psym.diamond, charsize=1.0, symsize=0.6, $
                       nbins=10, $
                       column_names=['A', 'B', 'C', 'D']

if (keyword_set(ps)) then begin
  mg_psend
  mg_convert, 'scatterplot_matrix', max_dimension=[1000, 1000], output=im
  mg_image, im, /new_window
endif

end
