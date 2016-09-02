'use strict';

// Slate Config
// Find slate docs at:
//  https://github.com/jigish/slate/wiki/JavaScript-Configs

// Constants

const PADDING_MONITOR = 60;
const PADDING_LAPTOP = 20;
const TITLEBAR_HEIGHT = 20;
const MESSAGES_APPLICATION_NAME = 'Messages';
const MESSAGES_LIST_WIDTH = 89;
const MESSAGES_WINDOW_WIDTH = 500;
const CHROME_APPLICATION_NAME = 'Google Chrome';
const CHROME_HANGOUTS_WIDTH = 280;
const ATOM_APPLICATION_NAME = 'Atom';
const ATOM_WINDOW_WIDTH = 750;
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
  const rect = window.screen().rect();
  return (rect.width  === DIMENSIONS_LAPTOP.width &&
          rect.height === DIMENSIONS_LAPTOP.height);
}

function isMonitorScreen(window) {
  const rect = window.screen().rect();
  return (rect.width  === DIMENSIONS_MONITOR.width &&
          rect.height === DIMENSIONS_MONITOR.height);
}

function getPadding(window) {
  return isLaptopScreen(window) ? PADDING_LAPTOP : PADDING_MONITOR;
}

function getScreenRect(window) {
  const screenRect = window.screen().rect();
  return {
    height: screenRect.height - TITLEBAR_HEIGHT,
    width: screenRect.width,
    x: screenRect.x,
    y: screenRect.y
  };
}

function moveWindow(window, options) {
  const windowRect = window.rect(window);
  const mergedOptions = extend({
    x         : windowRect.x,
    y         : windowRect.y - TITLEBAR_HEIGHT,
    width     : windowRect.width,
    height    : windowRect.height
  }, options);
  mergedOptions.y += TITLEBAR_HEIGHT;
  window.doOperation('move', mergedOptions);
}

function getAllWindows() {
  const windows = [];
  S.eachApp(function(app) {
    app.eachWindow(function(window) {
      windows.push(window);
    });
  });
  return windows;
}

// Manipulation Functions

const iMessageLeftRail = function(window) {
  const borderGap = getPadding(window);
  const screenRect = getScreenRect(window);
  moveWindow(window, {
    x         : borderGap,
    y         : borderGap,
    width     : MESSAGES_WINDOW_WIDTH,
    height    : screenRect.height - (borderGap * 2),
    screen    : getMainScreen
  });
};

const mainContent = function(window) {
  const borderGap = getPadding(window);
  const screenRect = getScreenRect(window);
  moveWindow(window, {
    x         : borderGap + MESSAGES_LIST_WIDTH,
    y         : borderGap,
    width     : screenRect.width - (borderGap * 2 + MESSAGES_LIST_WIDTH),
    height    : screenRect.height - (borderGap * 2),
    screen    : getMainScreen
  });
};

const desktopFull = function(window) {
  const borderGap = getPadding(window);
  const screenRect = getScreenRect(window);
  moveWindow(window, {
    x      : borderGap,
    y      : borderGap,
    width  : screenRect.width - (borderGap * 2),
    height : screenRect.height - (borderGap * 2)
  });
};

const desktopCenterWithResize = function(window, width, height) {
  const screenRect = getScreenRect(window);
  moveWindow(window, {
    x      : (screenRect.width - width) / 2,
    y      : (screenRect.height - height) / 2,
    width  : width,
    height : height,
  });
};

const desktopCenter = function(window) {
  const windowRect = window.rect();
  desktopCenterWithResize(window, windowRect.width, windowRect.height);
};

const desktopLeftHalf = function(window) {
  const borderGap = getPadding(window);
  const screenRect = getScreenRect(window);
  moveWindow(window, {
    x      : borderGap,
    y      : borderGap,
    width  : (screenRect.width / 2) - ((3/2) * borderGap),
    height : screenRect.height - (borderGap * 2)
  });
};

const desktopRightHalf = function(window) {
  const borderGap = getPadding(window);
  const screenRect = getScreenRect(window);
  moveWindow(window, {
    x      : (screenRect.width / 2) + (borderGap / 2),
    y      : borderGap,
    width  : (screenRect.width / 2) - ((3/2) * borderGap),
    height : screenRect.height - (borderGap * 2)
  });
};

const desktopLeft = function(window) {
  const borderGap = getPadding(window);
  const screenRect = getScreenRect(window);
  moveWindow(window, {
    x      : borderGap,
    width  : (screenRect.width / 2) - ((3/2) * borderGap),
  });
};

const desktopRight = function(window) {
  const borderGap = getPadding(window);
  const screenRect = getScreenRect(window);
  moveWindow(window, {
    x      : (screenRect.width / 2) + (borderGap / 2),
    width  : (screenRect.width / 2) - ((3/2) * borderGap),
  });
};

const desktopTop = function(window) {
  const borderGap = getPadding(window);
  const screenRect = getScreenRect(window);
  const windowRect = window.rect();
  moveWindow(window, {
    y      : borderGap,
    height : (screenRect.height / 2) - ((3/2) * borderGap)
  });
};

const desktopBottom = function(window) {
  const borderGap = getPadding(window);
  const screenRect = getScreenRect(window);
  const windowRect = window.rect();
  moveWindow(window, {
    y      : (screenRect.height / 2) + (borderGap / 2),
    height : (screenRect.height / 2) - ((3/2) * borderGap)
  });
};

// Layouts

const layoutMainMonitor = function() {
  const allWindows = getAllWindows();
  allWindows.forEach(function(window) {
    const app = window.app();
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

const layoutStack = function() {
  const size = S.window().size();
  const allWindows = getAllWindows();
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
