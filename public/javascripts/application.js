var Pelorus = Pelorus || {}

Pelorus.unselectable = function(element) {
  element.onselectstart = function(){return false};
  element.unselectable = "on";
  element.style.MozUserSelect = "none";
}

$$('a[href^="#"]').addEvent('click', function(e) {
  target = $((e && e.target) || this);
  new Fx.Scroll(window).toElement(document.getElement(target.getProperty('href')));
  return false;
});

$$('a.button').addEvent('click', function(e) {
  target = $((e && e.target) || this);
  return !target.getProperty('disabled');
});