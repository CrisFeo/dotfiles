const TITLEBAR_HEIGHT = 20;


function getMainScreen() {
  var mainScreen = null;
  S.eachScreen(function(screen) {
    if (screen.isMain()) {
      mainScreen = screen;
    }
  });
  return mainScreen;
}

function isLaptopScreen(window) {
  var rect = window.screen().rect();
  return (rect.width  === 1440 &&
          rect.height === 900);
}

function isMonitorScreen(window) {
  var rect = window.screen().rect();
  return (rect.width  === 2560 &&
          rect.height === 1440);
}

function getPadding(window) {
  return isLaptopScreen(window) ? 20 : 80;
}

var iMessageLeftRail = function(window) {
  var borderGap = getPadding(window);
  var screenRect = window.screen().rect();
  window.doOperation('move', {
    x         : borderGap,
    y         : borderGap + TITLEBAR_HEIGHT,
    width     : '500',
    height    : (screenRect.height - TITLEBAR_HEIGHT) - (borderGap * 2),
    screen    : getMainScreen
  });
};

var mainContent = function(window) {
  var msgListWidth = 89;
  var borderGap = getPadding(window);
  var screenRect = window.screen().rect();
  window.doOperation('move', {
    x         : borderGap + msgListWidth,
    y         : borderGap + TITLEBAR_HEIGHT,
    width     : screenRect.width - (borderGap * 2 + msgListWidth),
    height    : (screenRect.height - TITLEBAR_HEIGHT) - (borderGap * 2),
    screen    : getMainScreen
  });
};

var desktopFull = function(window) {
  var borderGap = getPadding(window);
  var screenRect = window.screen().rect();
  window.doOperation('move', {
    x      : borderGap,
    y      : borderGap + TITLEBAR_HEIGHT,
    width  : screenRect.width - (borderGap * 2),
    height : (screenRect.height - TITLEBAR_HEIGHT) - (borderGap * 2)
  });
};

var desktopLeft = function(window) {
  var borderGap = getPadding(window);
  var screenRect = window.screen().rect();
  window.doOperation('move', {
    x      : borderGap,
    y      : borderGap + TITLEBAR_HEIGHT,
    width  : (screenRect.width / 2) - ((3/2) * borderGap),
    height : (screenRect.height - TITLEBAR_HEIGHT) - (borderGap * 2)
  });
};

var desktopRight = function(window) {
  var borderGap = getPadding(window);
  var screenRect = window.screen().rect();
  window.doOperation('move', {
    x      : (screenRect.width / 2) + (borderGap / 2),
    y      : borderGap + TITLEBAR_HEIGHT,
    width  : (screenRect.width / 2) - ((3/2) * borderGap),
    height : (screenRect.height - TITLEBAR_HEIGHT) - (borderGap * 2)
  });
};

var desktopTop = function(window) {
  var borderGap = getPadding(window);
  var screenRect = window.screen().rect();
  var windowRect = window.rect();
  window.doOperation('move', {
    x      : windowRect.x,
    y      : borderGap + TITLEBAR_HEIGHT,
    width  : windowRect.width,
    height : (screenRect.height / 2 - TITLEBAR_HEIGHT) - (borderGap / 2)
  });
};

var desktopBottom = function(window) {
  var borderGap = getPadding(window);
  var screenRect = window.screen().rect();
  var windowRect = window.rect();
  window.doOperation('move', {
    x      : windowRect.x,
    y      : (screenRect.height / 2 + TITLEBAR_HEIGHT) + (borderGap / 2),
    width  : windowRect.width,
    height : (screenRect.height / 2 - TITLEBAR_HEIGHT) - ((3/2) * borderGap)
  });
};

function layoutMainMonitor() {
  S.eachApp(function(app) {
    app.eachWindow(function(window) {
      if (app.name() === 'Google Chrome') {
        mainContent(window);
      } else if (app.name() === 'Messages') {
        iMessageLeftRail(window);
      }
    });
  });
}
S.on('screenConfigurationChanged' , layoutMainMonitor);

S.bnda({
  ']:ctrl,alt,cmd'          : layoutMainMonitor,
  'up:ctrl,alt,cmd'         : desktopFull,
  'left:ctrl,alt,cmd'       : desktopLeft,
  'right:ctrl,alt,cmd'      : desktopRight,
  'up:ctrl,alt,cmd,shift'   : desktopTop,
  'down:ctrl,alt,cmd,shift' : desktopBottom
});
