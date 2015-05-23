slate.configAll({
    'gridBackgroundColor': '75;77;81;0.2',
    'gridRoundedCornerSize': 1,
    'gridCellRoundedCornerSize': 3,
});

var grid = slate.operation('grid', {
    'grids': {
	'2560x1440': {
	    'width': 12,
	    'height': 10
	},
	'2880x1800': {
	    'width': 12,
	    'height': 10
	}
    },
  'padding': 5
});

slate.bind('1:ctrl', grid);
