$(document).ready ->
  selected_value = $('#category_select').val()
  if selected_value != '4'
    $('#sub_category_div').hide()
    $('#subcategory_select').attr 'disabled', 'disabled'
  $('#category_select').change ->
    if $(this).val() == '4'
      $('#sub_category_div').show()
      $('#subcategory_select').removeAttr 'disabled'
    else
      if $('#sub_category_div').is(':visible')
        $('#sub_category_div').hide()
        $('#subcategory_select').attr 'disabled', 'disabled'
    return
  return