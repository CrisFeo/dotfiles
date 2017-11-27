-- WINDOW LAYOUT
padding = 20
titlebarHeight = 0 -- 20

lastId = nil
lastFrame = nil

hs.urlevent.bind("center", function()
  local win = hs.window.focusedWindow()
  lastId = win:id()
  lastFrame = win:frame()
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

hs.urlevent.bind("push", function(name, params)
  local win = hs.window.focusedWindow()
  lastId = win:id()
  lastFrame = win:frame()
  local max = win:screen():frame()
  local f = win:frame()
  shapes = {
    ["up"] = function()
      f.y = padding + titlebarHeight
      f.h = (max.h / 2) - ((3/2) * padding)
    end,
    ["down"] = function()
      f.y = (max.h / 2) + ((1/2) * padding) + titlebarHeight
      f.h = (max.h / 2) - ((3/2) * padding)
    end,
    ["left"] = function()
      f.x = padding
      f.w = (max.w / 2) - ((3/2) * padding)
    end,
    ["right"] = function()
      f.x = (max.w / 2) + ((1/2) * padding)
      f.w = (max.w / 2) - ((3/2) * padding)
    end,
  }
  shapes[params["d"]]()
  win:setFrameInScreenBounds(f, 0)
end)

hs.urlevent.bind("expand", function(name, params)
  local win = hs.window.focusedWindow()
  lastId = win:id()
  lastFrame = win:frame()
  local max = win:screen():frame()
  local f = win:frame()
  shapes = {
    ["horizontal"] = function()
      f.x = padding
      f.w = max.w - (2 * padding)
    end,
    ["vertical"] = function()
      f.y = padding + titlebarHeight
      f.h = max.h - (2 * padding)
    end,
    ["both"] = function()
      f.x = padding
      f.y = padding + titlebarHeight
      f.w = max.w - (2 * padding)
      f.h = max.h - (2 * padding)
    end,
  }
  shapes[params["d"]]()
  win:setFrameInScreenBounds(f, 0)
end)

hs.urlevent.bind("undo", function()
  if lastId == nil or lastFrame == nil then
    return
  end
  local win = hs.window.get(lastId)
  if win == nil then
    return
  end
  local curFrame = win:frame()
  win:setFrameInScreenBounds(lastFrame, 0)
  lastFrame = curFrame
end)

-- WINDOW SWITCHING
focusableWindows = hs.window.filter.new():setCurrentSpace(true)

hs.urlevent.bind("focus", function(name, params)
  actions = {
    ["up"]    = "North",
    ["down"]  = "South",
    ["left"]  = "West",
    ["right"] = "East",
  }
  action = "focusWindow"..actions[params["d"]]
  focusableWindows[action](focusableWindows, nil, true, false)
end)

-- WINDOW BORDER
borderWidth = 8
borderRadius = 2
borderColor = {
  ["red"]=0.98,
  ["green"]=0.78,
  ["blue"]=0.29,
  ["alpha"]=1.0
}

border = nil
borderedWindows = hs.window.filter.new()

function drawBorder()
  if border then
    border:delete()
  end
  local win = hs.window.focusedWindow()
  if win == nil then return end
  local f = win:frame()
  local offset = padding / 2 + borderWidth / 4
  local fx = f.x - offset
  local fy = f.y - offset
  local fw = f.w + (2*offset)
  local fh = f.h + (2*offset)
  border = hs.drawing.rectangle(hs.geometry.rect(fx, fy, fw, fh))
  border:setStrokeWidth(borderWidth)
  border:setStrokeColor(borderColor)
  border:setRoundedRectRadii(borderRadius, borderRadius)
  border:setStroke(true):setFill(false)
  border:setLevel("floating")
  border:show()
end

borderedWindows:subscribe({
  hs.window.filter.windowFocused,
  hs.window.filter.windowUnfocused,
  hs.window.filter.windowMoved
}, drawBorder, true)

-- HOT RELOAD
function reloadConfig(files)
  for _,file in pairs(files) do
    if file:sub(-4) == ".lua" then
      hs.reload()
      return
    end
  end
end

hs.pathwatcher.new(os.getenv("HOME") .. "/.hammerspoon/", reloadConfig):start()


