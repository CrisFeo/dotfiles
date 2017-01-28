'use strict';

// Slate Config
// Find slate docs at:
//  https://github.com/jigish/slate/wiki/JavaScript-Configs

// Constants

var PADDING_MONITOR = 60;
var PADDING_LAPTOP = 20;
var TITLEBAR_HEIGHT = 20;
var MESSAGES_APPLICATION_NAME = 'Messages';
var MESSAGES_LIST_WIDTH = 89;
var MESSAGES_WINDOW_WIDTH = 500;
var CHROME_APPLICATION_NAME = 'Google Chrome';
var CHROME_HANGOUTS_WIDTH = 280;
var ATOM_APPLICATION_NAME = 'Atom';
var ATOM_WINDOW_WIDTH = 750;
var DIMENSIONS_MONITOR = {
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

function isMonitorScreen(window) {
  var rect = window.screen().rect();
  return (rect.width  === DIMENSIONS_MONITOR.width &&
          rect.height === DIMENSIONS_MONITOR.height);
}

function getPadding(window) {
  return isMonitorScreen(window) ? PADDING_MONITOR : PADDING_LAPTOP;
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

function getAllWindows() {
  var windows = [];
  S.eachApp(function(app) {
    app.eachWindow(function(window) {
      windows.push(window);
    });
  });
  return windows;
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

var desktopCenterWithResize = function(window, width, height) {
  var screenRect = getScreenRect(window);
  moveWindow(window, {
    x      : (screenRect.width - width) / 2,
    y      : (screenRect.height - height) / 2,
    width  : width,
    height : height,
  });
};

var desktopCenter = function(window) {
  var windowRect = window.rect();
  desktopCenterWithResize(window, windowRect.width, windowRect.height);
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

var layoutMainMonitor = function() {
  var allWindows = getAllWindows();
  allWindows.forEach(function(window) {
    var app = window.app();
    switch(app.name()) {
      case CHROME_APPLICATION_NAME:
        if (window.rect().width !== CHROME_HANGOUTS_WIDTH){
          mainContent(window);
        }
      break;
      case MESSAGES_APPLICATION_NAME: iMessageLeftRail(window); break;
      case ATOM_APPLICATION_NAME: atomSoloWindow(window); break;
    }
  });
}

var layoutStack = function() {
  var size = S.window().size();
  var allWindows = getAllWindows();
  allWindows.forEach(function(window) {
    desktopCenterWithResize(window, size.width, size.height);
  });
}

// Keys

S.bnda({
  ']:ctrl,alt,cmd'           : layoutMainMonitor,
  '[:ctrl,alt,cmd'           : layoutStack,
  'up:ctrl,alt,cmd'          : desktopFull,
  'down:ctrl,alt,cmd'        : desktopCenter,
  'left:ctrl,alt,cmd'        : desktopLeftHalf,
  'right:ctrl,alt,cmd'       : desktopRightHalf,
  'left:ctrl,alt,cmd,shift'  : desktopLeft,
  'right:ctrl,alt,cmd,shift' : desktopRight,
  'up:ctrl,alt,cmd,shift'    : desktopTop,
  'down:ctrl,alt,cmd,shift'  : desktopBottom
});
