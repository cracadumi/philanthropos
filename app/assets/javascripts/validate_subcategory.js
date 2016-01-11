$(document).ready(function(){
  valid_status = false;
  $('#category_select').change(function(){
    if($(this).val() == 4){
      valid_status = validate_subcategory($('#subcategory_select'));
      add_alert(valid_status)
    }
  });
  $('#subcategory_select').change(function(){
     valid_status = validate_subcategory($('#subcategory_select'));
     add_alert(valid_status)
  });
  $('#post_submit').click(function(){
     valid_status = validate_subcategory($('#subcategory_select'));
    add_alert(valid_status)
  });
  $('#post_title_field').blur(function(){
    valid_status = validate_subcategory($('#subcategory_select'));
    add_alert(valid_status)

  });
  $('#post_title_field').blur(function(){
    valid_status = validate_subcategory($('#subcategory_select'));
    add_alert(valid_status)
  });
  if($('#category_select').val() == 4)
  {
    valid_status = validate_subcategory($('#subcategory_select'));
    add_alert(valid_status)
  }
}); 

function validate_subcategory(element)
{
  valid =  false;
  if(!(element.is(':disabled')))
  {  
    if (element.val() === "") {
      submit_form(false);
      valid = false;
    }
    else
    {
      if((!$('#post_title_field').val()) || (!$('#post_title_field').val()))
      {
        submit_form(false);
        valid = true;
      }
      else
      {
        submit_form(true);
        valid = true;
      }
    }
  }
  else
  {
    valid = true;
  }
  return valid;  
}

function submit_form(valid_check)
{
  if(valid_check)
  { 
    $('#post_form').unbind('submit');
  }
  else
  {
    $('#post_form').on('submit',function(e) {
      e.preventDefault();
    });  
  }  
}

function add_alert(valid)
{
  if (valid)
  {
    $('#subcategory_select').removeClass('buggy_element');
    $('#nilerror').addClass('hidden');
  }
  else
  {
    $('#subcategory_select').addClass('buggy_element');
    $('#nilerror').removeClass('hidden');
  }
}
