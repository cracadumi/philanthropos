$(document).ready(function(){

   $('#search_user_button').click(function(){
      if (localStorage.getItem('lastTab'))
      {
        localStorage.removeItem('lastTab');
      }
   });

   $('a[data-toggle="tab"]').on('shown.bs.tab', function (e) {
        // save the latest tab; use cookies if you like 'em better:
        if($(this).attr('href') == "#mapdiv")
        {
          loadInternationalMap();
        }
        localStorage.setItem('lastTab', $(this).attr('href'));
    });

    // go to the latest tab, if it exists:
    var lastTab = localStorage.getItem('lastTab');
    if (lastTab) {
        $('[href="' + lastTab + '"]').tab('show');
    }

});