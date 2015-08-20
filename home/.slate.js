S.configAll({
  'gridBackgroundColor': '75;77;81;0.2',
  'gridRoundedCornerSize': 1,
  'gridCellRoundedCornerSize': 3
});

var grid = S.op('grid', {
    'grids': {
	'2560x1440': {
	    'width': 4,
	    'height': 4
	},
	'1440x900': {
	    'width': 4,
	    'height': 4
	}
    },
  'padding': 5
});
S.bind('1:ctrl,alt,cmd,shift', grid);

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
  return isLaptopScreen(window) ? 20 : 90;
}

var iMessageLeftRail = function(window) {
  var borderGap = getPadding(window);
  window.doOperation('move', {
    x         : borderGap,
    y         : borderGap + 20,
    width     : '500',
    height    : 'screenSizeY - ' + (borderGap * 2),
    screen    : getMainScreen
  });
};

var mainContent = function(window) {
  var msgListWidth = 89;
  var borderGap = getPadding(window);
  window.doOperation('move', {
    x         : borderGap + msgListWidth,
    y         : borderGap + 20,
    width     : 'screenSizeX - ' + (borderGap * 2 + msgListWidth),
    height    : 'screenSizeY - ' + (borderGap * 2),
    screen    : getMainScreen
  });
};

var desktopFull = function(window) {
  var borderGap = getPadding(window);
  window.doOperation('move', {
    x      : borderGap,
    y      : borderGap + 20,
    width  : 'screenSizeX - ' + (borderGap * 2),
    height : 'screenSizeY - ' + (borderGap * 2)
  });
};

var desktopLeft = function(window) {
  var borderGap = getPadding(window);
  window.doOperation('move', {
    x      : borderGap,
    y      : borderGap + 20,
    width  : '(screenSizeX / 2) - ' + ((3/2) * borderGap),
    height : 'screenSizeY - ' + (borderGap * 2)
  });
};

var desktopRight = function(window) {
  var borderGap = getPadding(window);
  window.doOperation('move', {
    x      : '(screenSizeX / 2) + ' + (borderGap / 2),
    y      : borderGap + 20,
    width  : '(screenSizeX / 2) - ' + ((3/2) * borderGap),
    height : 'screenSizeY - ' + (borderGap * 2)
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
  ']:ctrl,alt,cmd,shift'     : layoutMainMonitor,
  'up:ctrl,alt,cmd,shift'    : desktopFull,
  'left:ctrl,alt,cmd,shift'  : desktopLeft,
  'right:ctrl,alt,cmd,shift' : desktopRight,
});
