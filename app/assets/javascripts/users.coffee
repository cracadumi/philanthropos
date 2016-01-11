$(document).ready ->

  readURL = (input) ->
    if input.files and input.files[0]
      reader = new FileReader

      reader.onload = (e) ->
        $('#img_holder').attr 'src', e.target.result
        return

      reader.readAsDataURL input.files[0]
    return

  $('#img_input').change ->
    readURL this
    return
  return
