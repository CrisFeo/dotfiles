// Slate Config
// Find slate docs at:
//  https://github.com/jigish/slate/wiki/JavaScript-Configs


// Constants

const PADDING_MONITOR = 60;
const PADDING_LAPTOP = 20;
const TITLEBAR_HEIGHT = 20;
const MESSAGES_LIST_WIDTH = 89;
const MESSAGES_WINDOW_WIDTH = 500;
const MESSAGES_APPLICATION_NAME = 'Messages';
const CHROME_APPLICATION_NAME = 'Google Chrome';
const CHROME_HANGOUTS_WIDTH = 280;
const DIMENSIONS_LAPTOP = {
  height: 900,
  width: 1440
};
const DIMENSIONS_MONITOR = {
  height: 1440,
  width: 2560
};


// Helpers

function extend(target, source) {
  for (var property in source) {
    target[property] = source[property];
  }
  return target;
}

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
  return (rect.width  === DIMENSIONS_LAPTOP.width &&
          rect.height === DIMENSIONS_LAPTOP.height);
}

function isMonitorScreen(window) {
  var rect = window.screen().rect();
  return (rect.width  === DIMENSIONS_MONITOR.width &&
          rect.height === DIMENSIONS_MONITOR.height);
}

function getPadding(window) {
  return isLaptopScreen(window) ? PADDING_LAPTOP : PADDING_MONITOR;
}

function getScreenRect(window) {
  var screenRect = window.screen().rect();
  return {
    height: screenRect.height - TITLEBAR_HEIGHT,
    width: screenRect.width,
    x: screenRect.x,
    y: screenRect.y
  };
}

function moveWindow(window, options) {
  var windowRect = window.rect(window);
  var mergedOptions = extend({
    x         : windowRect.x,
    y         : windowRect.y - TITLEBAR_HEIGHT,
    width     : windowRect.width,
    height    : windowRect.height
  }, options);
  mergedOptions.y += TITLEBAR_HEIGHT;
  window.doOperation('move', mergedOptions);
}


// Manipulation Functions

var iMessageLeftRail = function(window) {
  var borderGap = getPadding(window);
  var screenRect = getScreenRect(window);
  moveWindow(window, {
    x         : borderGap,
    y         : borderGap,
    width     : MESSAGES_WINDOW_WIDTH,
    height    : screenRect.height - (borderGap * 2),
    screen    : getMainScreen
  });
};

var mainContent = function(window) {
  var borderGap = getPadding(window);
  var screenRect = getScreenRect(window);
  moveWindow(window, {
    x         : borderGap + MESSAGES_LIST_WIDTH,
    y         : borderGap,
    width     : screenRect.width - (borderGap * 2 + MESSAGES_LIST_WIDTH),
    height    : screenRect.height - (borderGap * 2),
    screen    : getMainScreen
  });
};

var desktopFull = function(window) {
  var borderGap = getPadding(window);
  var screenRect = getScreenRect(window);
  moveWindow(window, {
    x      : borderGap,
    y      : borderGap,
    width  : screenRect.width - (borderGap * 2),
    height : screenRect.height - (borderGap * 2)
  });
};

var desktopCenter = function(window) {
  var screenRect = getScreenRect(window);
  var windowRect = window.rect();
  moveWindow(window, {
    x      : (screenRect.width - windowRect.width) / 2,
    y      : (screenRect.height - windowRect.height) / 2
  });
};

var desktopLeftHalf = function(window) {
  var borderGap = getPadding(window);
  var screenRect = getScreenRect(window);
  moveWindow(window, {
    x      : borderGap,
    y      : borderGap,
    width  : (screenRect.width / 2) - ((3/2) * borderGap),
    height : screenRect.height - (borderGap * 2)
  });
};

var desktopRightHalf = function(window) {
  var borderGap = getPadding(window);
  var screenRect = getScreenRect(window);
  moveWindow(window, {
    x      : (screenRect.width / 2) + (borderGap / 2),
    y      : borderGap,
    width  : (screenRect.width / 2) - ((3/2) * borderGap),
    height : screenRect.height - (borderGap * 2)
  });
};

var desktopLeft = function(window) {
  var borderGap = getPadding(window);
  var screenRect = getScreenRect(window);
  moveWindow(window, {
    x      : borderGap,
    width  : (screenRect.width / 2) - ((3/2) * borderGap),
  });
};

var desktopRight = function(window) {
  var borderGap = getPadding(window);
  var screenRect = getScreenRect(window);
  moveWindow(window, {
    x      : (screenRect.width / 2) + (borderGap / 2),
    width  : (screenRect.width / 2) - ((3/2) * borderGap),
  });
};

var desktopTop = function(window) {
  var borderGap = getPadding(window);
  var screenRect = getScreenRect(window);
  var windowRect = window.rect();
  moveWindow(window, {
    y      : borderGap,
    height : (screenRect.height / 2) - ((3/2) * borderGap)
  });
};

var desktopBottom = function(window) {
  var borderGap = getPadding(window);
  var screenRect = getScreenRect(window);
  var windowRect = window.rect();
  moveWindow(window, {
    y      : (screenRect.height / 2) + (borderGap / 2),
    height : (screenRect.height / 2) - ((3/2) * borderGap)
  });
};


// Layouts

function layoutMainMonitor() {
  S.eachApp(function(app) {
    app.eachWindow(function(window) {
      if (app.name() === CHROME_APPLICATION_NAME) {
        if (window.rect().width !== CHROME_HANGOUTS_WIDTH){
          mainContent(window);
        }
      } else if (app.name() === MESSAGES_APPLICATION_NAME) {
        iMessageLeftRail(window);
      }
    });
  });
}

// Events

S.on('screenConfigurationChanged' , layoutMainMonitor); // Not working


// Keys

S.bnda({
  ']:ctrl,alt,cmd'           : layoutMainMonitor,
  'up:ctrl,alt,cmd'          : desktopFull,
  'down:ctrl,alt,cmd'        : desktopCenter,
  'left:ctrl,alt,cmd'        : desktopLeftHalf,
  'right:ctrl,alt,cmd'       : desktopRightHalf,
  'left:ctrl,alt,cmd,shift'  : desktopLeft,
  'right:ctrl,alt,cmd,shift' : desktopRight,
  'up:ctrl,alt,cmd,shift'    : desktopTop,
  'down:ctrl,alt,cmd,shift'  : desktopBottom
});
