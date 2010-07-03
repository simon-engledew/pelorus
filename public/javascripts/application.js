var Pelorus = Pelorus || {}

Pelorus.unselectable = function(element) {
  element.onselectstart = function(){return false};
  element.unselectable = "on";
  element.style.MozUserSelect = "none";
}

$$('a[href^="#"]').each(function(link) {
  link.addEvent('click', function(e){
    new Fx.Scroll(window).toElement(document.getElement(link.getProperty('href')));
    return false;
  });
});
 