$(function() {

  var path = location.pathname.split('/')[1];
  if (path == '') path = 'home'
  
  var navPlace = $('[data-nav="' + path + '"]')
  navPlace.find('span').addClass('active')


  // if (params != '') {
  //   if (params.split('price=')[1] === '50') {
  //     $('.price-filter .all-items').removeClass('active');
  //     $('.price-filter .under-50').addClass('active');
  //   }
  // }



  // // for hotkey info in footer
  // $('.hotkey').click(function(e) { e.preventDefault(); });
  // $("[data-toggle=popover]").popover();

  // $('.signed-out-box').click(function(e) { 
  //   var spinner = "<i class='icon-spinner icon-spin'></i>"
  //   $(this).find('p').html(spinner);
  // });

});