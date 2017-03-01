padding = 20
titlebarHeight = 20

hs.urlevent.bind("fullscreen", function()
  local win = hs.window.focusedWindow()
  local f = win:frame()
  local screen = win:screen()
  local max = screen:frame()

  f.x = padding
  f.y = padding + titlebarHeight
  f.w = max.w - (2 * padding)
  f.h = max.h - (2 * padding)
  win:setFrameInScreenBounds(f, 0)
end)

hs.urlevent.bind("center", function()
  local win = hs.window.focusedWindow()
  local f = win:frame()
  local screen = win:screen()
  local max = screen:frame()

  f.x = (max.w - f.w) / 2
  f.y = ((max.h - f.h) / 2) + titlebarHeight
  win:setFrameInScreenBounds(f, 0)
end)

hs.urlevent.bind("stack", function()
  local win = hs.window.focusedWindow()
  local others = win:otherWindowsSameScreen()
  local f = win:frame()

  for _, other in ipairs(others) do
    other:setFrameInScreenBounds(f, 0)
  end
end)

hs.urlevent.bind("left", function()
  local win = hs.window.focusedWindow()
  local f = win:frame()
  local screen = win:screen()
  local max = screen:frame()

  f.x = padding
  f.w = (max.w / 2) - ((3/2) * padding)
  win:setFrameInScreenBounds(f, 0)
end)

hs.urlevent.bind("right", function()
  local win = hs.window.focusedWindow()
  local f = win:frame()
  local screen = win:screen()
  local max = screen:frame()

  f.x = (max.w / 2) + ((1/2) * padding)
  f.w = (max.w / 2) - ((3/2) * padding)
  win:setFrameInScreenBounds(f, 0)
end)

hs.urlevent.bind("top", function()
  local win = hs.window.focusedWindow()
  local f = win:frame()
  local screen = win:screen()
  local max = screen:frame()

  f.y = padding + titlebarHeight
  f.h = (max.h / 2) - ((3/2) * padding)
  win:setFrameInScreenBounds(f, 0)
end)

hs.urlevent.bind("bottom", function()
  local win = hs.window.focusedWindow()
  local f = win:frame()
  local screen = win:screen()
  local max = screen:frame()

  f.y = (max.h / 2) + ((1/2) * padding) + titlebarHeight
  f.h = (max.h / 2) - ((3/2) * padding)
  win:setFrameInScreenBounds(f, 0)
end)
