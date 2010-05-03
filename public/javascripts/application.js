var Pelorus = Pelorus || {}

Pelorus.unselectable = function(element) {
  element.onselectstart = function(){return false};
  element.unselectable = "on";
  element.style.MozUserSelect = "none";
}

/*
$$('#description').each(function(description) {
  description.setStyle('overflow-y', 'hidden');
  description.addEvent('mouseout', function(e){
    description.setStyles({'height': '5em'});
  });
  description.addEvent('mouseover', function(e){
    description.setStyles({'height': 'auto'});
  });
  description.fireEvent('mouseout');
});
*/

$$('a[href^="#"]').each(function(link) {
  link.addEvent('click', function(e){
    new Fx.Scroll(window).toElement(document.getElement(link.getProperty('href')));
    return false;
  });
});

/*
$$('div.container > table > tbody > tr:nth-child(odd)').addClass('odd');
$$('div.container > table > tbody > tr').each(function(row){
  var element = row.getElement('.delete');
  if ($defined(element)) {
    Pelorus.unselectable(element);
    row.addEvent('mouseover', function(e){element.setStyle('opacity', 1)});
    row.addEvent('mouseout', function(e){element.setStyle('opacity', 0)});
    row.fireEvent('mouseout');
  }
});
*/

// document.addEvent('domready', function() {
//    $$('.tab').each(function(tab, i) {
//      if (i > 0) tab.setStyle('display', 'none');
//    });
// }); 