// Behaviors
// 

Rollover = {};

Rollover.WithPopup = Behavior.create({
  initialize: function() {
    this._origin = this.element;
    this._popup = this.element.down(".rollover_popup");
    
    this._show_timer = null;
    this._hide_timer = null;
    this._show_delay = 1000;
    this._hide_delay = 1000;
  },
  onmouseover: function(ev) {
    var pos = _YooJin.getBelowPosition(this._origin);
    var dim = Element.getDimensions(this._popup);
    
    try {
      var left_border_width = _YooJin.getStyle(this._origin, "border-left-width");
      var fix_x = (left_border_width) ? parseInt(left_border_width) : 0;
    } catch(e) {
      var fix_x = 0;
    }

    var fix_y = 0;
    
    Element.setStyle(this._popup, { 
      top: pos.y - dim.height + fix_y + "px",
      left: pos.x + fix_x + "px"
    });

    Element.show(this._popup);

//    new Effect.Appear(this._popup, { duration: 0.15, to: 0.5 });
  },
  onmouseout: function(ev) {
    var e = ev.relatedTarget || ev.toElement;

    if (Element.descendantOf(e, this._origin)) {
    }
    else {
//      new Effect.Fade(this._popup, { duration: 0.3 });
      Element.hide(this._popup);
    }
  },
  //
  //
  _show: function(ev) {
  },
  _hide: function(ev) {
  },
  _startShowTimer: function(ev) {
    this._stopShowTimer(ev);
    this._hide_timer = setTimeout(this._show.bind(this, ev), this._show_delay);
  },
  _stopShowTimer: function(ev) {
    if (this._show_timer) {
      clearTimeout(this._show_timer);
      this._show_timer = null;
    }
  },
  _startHideTimer: function(ev) {
    this._stopHideTimer(ev);
    this._hide_timer = setTimeout(this._hide.bind(this, ev), this._hide_delay);
  },
  _stopHideTimer: function(ev) {
    if (this._hide_timer) {
      clearTimeout(this._hide_timer);
      this._hide_timer = null;
    }
  }
});



Form.WithInlineLabels = Behavior.create({
  initialize: function() {
    this.label = this.element.previous('label');
    this.label.hide();

    this.labelText = this.label.innerHTML;
    this.element.tagName == 'TEXTAREA' ? this.element.innerHTML = this.labelText : this.element.value = this.labelText;
    this.element.addClassName('with_label');
  },
  onfocus: function(e) {
    if($F(this.element) == this.labelText) {
      this.element.removeClassName('with_label');
      this.element.tagName == 'TEXTAREA' ? this.element.innerHTML = '' : this.element.value = '';
    }
  },
  onblur: function(e) {
    if($F(this.element).blank()) {
      this.element.addClassName('with_label');
      this.element.tagName == 'TEXTAREA' ? this.element.innerHTML = this.labelText : this.element.value = this.labelText;
    }
  }
});


Form.WithSpinner = Behavior.create({
  initialize: function() {
    
  },
  onsubmit: function(e) {
    var e = $("spinner");
    e.down("img").show();
  }
});


Link = {};

Link.Null = Behavior.create({
  initialize: function() {
    
  },
  onclick: function(e) {
    return false;
  }
});


/////////////////////////////////////////////////////////
//

Popup = {
  version: "1.0.0",
  closeAll: function() {
    $$("div.Popup_popup").invoke("hide");
    if (Popup.overlay) Popup.hideOverlay();
  },
  closePopup: function(e) {
    $(e).up('div.Popup_popup').popup.hide();
    return false;
  },
  overlayShow: false,
  showOverlay: function() {
    if (!Popup.overlay) {
      var overlay = document.createElement('div');
      overlay.setAttribute('id','Popup_overlay');
      overlay.style.display = 'none';
      document.body.appendChild(overlay);
      Popup.overlay = overlay;
      
      Event.observe(overlay, "click", function(e){Event.stop(e)});
    }
    Popup.overlay.style.height = _YooJin.getPageDimensions().height + 'px';

    if (Popup.overlayShow == false) {
      new Effect.Appear(Popup.overlay, {
        duration: 0.3, to: 0.6,
        queue: { position: 'end', scope: 'Popup_overlay' }}
      );
      Popup.overlayShow = true;
    }
  },
  hideOverlay: function() {
    if (Popup.overlayShow == true) {
      new Effect.Fade(Popup.overlay, { 
        duration: 0.3,
        queue: { position: 'end', scope: 'Popup_overlay'}}
      );
      Popup.overlayShow = false;
    }
  }
};

Popup.Behavior = Behavior.create({
  initialize: function() {
    var matches = this.element.href.match(/\#(.+)$/);
    if (matches) {
      this._popup = new Popup.Window($(matches[1]));
    } else {
      this._popup = new Popup.AjaxWindow(this.element.href);
    }
    
    this.element.popup = this._popup;
    
    this._popup.modal = this.element.hasClassName("modal");
  },
  onclick: function(event) {
    this._popup.toggle();
    event.stop();
  }
});

Popup.AbstractWindow = Class.create({
  initialize: function() {
    this.buildWindow();
  },
  buildWindow: function() {
    this.element = $div({'class':'Popup_popup', style:'display:none'});
    var body = $$('body').first();
    body.insert(this.element);
    this.element.popup = this;
  },
  show: function() {
    this.beforeShow();
//    this.element.show();
    if (this.modal) Popup.showOverlay();
    new Effect.Appear(this.element, { duration: 0.3 });
  },
  hide: function() {
    this.beforeHide();
//    this.element.hide();
    if (this.modal) Popup.hideOverlay();
    new Effect.Fade(this.element, { duration: 0.3 });
  },
  toggle: function() {
    if (this.element.visible()) {
      this.hide();
    } else {
      this.show();
    }
  },
  centerWindowInView: function() {
    var offsets = document.viewport.getScrollOffsets();
    this.element.setStyle({
      left: parseInt(offsets.left + (document.viewport.getWidth() - this.element.getWidth()) / 2) + 'px',
      top: parseInt(offsets.top + (document.viewport.getHeight() - this.element.getHeight()) / 2.2) + 'px'
    });
  }
});

Popup.Window = Class.create(Popup.AbstractWindow, {
  initialize: function($super, element, options) {
    $super(options);
    element.remove();
    this.element.update(element);
    element.show();
  },
  beforeShow: function() {
    Popup.closeAll();
    this.centerWindowInView();
  },
  beforeHide: function() {
  }
});

Popup.AjaxWindow = Class.create(Popup.AbstractWindow, {
  initialize: function($super, url, options) {
    $super();
    options = Object.extend({reload: true}, options);
    this.url = url;
    this.reload = options.reload;
  },
  show: function($super) {
    if (!this.loaded || this.reload) {
      new Ajax.Updater(this.element, this.url, {asynchronous: false, method: "get", evalScripts: true, onComplete: $super});
      this.loaded = true;
    } else {
      $super();
    }
  },
  beforeShow: function() {
    Popup.closeAll();
    this.centerWindowInView();
  },
  beforeHide: function() {
  }
});



// addBehaviors
//

Event.addBehavior({
  ".popup": Popup.Behavior,
  "a.null": Link.Null
});
