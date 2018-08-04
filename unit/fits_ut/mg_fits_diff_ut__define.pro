; docformat = 'rst'


function mg_fits_diff_ut::test_differentdata
  compile_opt strictarr

  assert, self->have_routine('fits_open'), 'FITS_OPEN routine not found', /skip

  filename1 = filepath('20150428_223017_kcor.fts', root=self.fits_data_root)
  filename2 = filepath('20150428_223017_kcor_changeddata.fts', $
                       root=self.fits_data_root)

  diff = mg_fits_diff(filename1, filename2)
  assert, diff eq 1, 'difference not found'

  return, 1
end


function mg_fits_diff_ut::test_differentkeywords
  compile_opt strictarr

  assert, self->have_routine('fits_open'), 'FITS_OPEN routine not found', /skip

  filename1 = filepath('20150428_223017_kcor.fts', root=self.fits_data_root)
  filename2 = filepath('20150428_223017_kcor_changedkeywords.fts', $
                       root=self.fits_data_root)

  diff = mg_fits_diff(filename1, filename2)
  assert, diff eq 1, 'difference not found'

  return, 1
end


function mg_fits_diff_ut::test_differentkeywords_ignored
  compile_opt strictarr

  assert, self->have_routine('fits_open'), 'FITS_OPEN routine not found', /skip

  filename1 = filepath('20150428_223017_kcor.fts', root=self.fits_data_root)
  filename2 = filepath('20150428_223017_kcor_changedkeywords.fts', $
                       root=self.fits_data_root)

  diff = mg_fits_diff(filename1, filename2, ignore_keywords=['DATE*'])
  assert, diff eq 0, 'found a difference where there was not one'

  return, 1
end


function mg_fits_diff_ut::test_differentkeywordvalues
  compile_opt strictarr

  assert, self->have_routine('fits_open'), 'FITS_OPEN routine not found', /skip

  filename1 = filepath('20150428_223017_kcor.fts', root=self.fits_data_root)
  filename2 = filepath('20150428_223017_kcor_diffkeywordvalue.fts', $
                       root=self.fits_data_root)

  diff = mg_fits_diff(filename1, filename2)
  assert, diff eq 1, 'difference not found'

  return, 1
end


function mg_fits_diff_ut::test_differentkeywordvalues_ignored
  compile_opt strictarr

  assert, self->have_routine('fits_open'), 'FITS_OPEN routine not found', /skip

  filename1 = filepath('20150428_223017_kcor.fts', root=self.fits_data_root)
  filename2 = filepath('20150428_223017_kcor_diffkeywordvalue.fts', $
                       root=self.fits_data_root)

  diff = mg_fits_diff(filename1, filename2, ignore_keywords='OBSSWID')
  assert, diff eq 0, 'found a difference where there was not one'

  return, 1
end


function mg_fits_diff_ut::test_copy
  compile_opt strictarr

  assert, self->have_routine('fits_open'), 'FITS_OPEN routine not found', /skip

  filename1 = filepath('20150428_223017_kcor.fts', root=self.fits_data_root)
  filename2 = filepath('20150428_223017_kcor_copy.fts', $
                       root=self.fits_data_root)

  diff = mg_fits_diff(filename1, filename2)
  assert, diff eq 0, 'found a difference where there was not one'

  return, 1
end


function mg_fits_diff_ut::init, _extra=e
  compile_opt strictarr

  if (~self->MGutLibTestCase::init(_extra=e)) then return, 0

  self->addTestingRoutine, ['mg_fits_diff', $
                            'mg_fits_diff_getkeywords', $
                            'mg_fits_diff_checkkeywords', $
                            'mg_fits_diff_checkdata'], $
                           /is_function

  self.fits_data_root = mg_src_root()

  return, 1
end


pro mg_fits_diff_ut__define
  compile_opt strictarr

  define = { mg_fits_diff_ut, inherits MGutLibTestCase, $
             fits_data_root: '' $
           }
end
