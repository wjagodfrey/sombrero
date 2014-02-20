# updates complex edge positions
updateEdges = (e) ->
  centerY = if e.type is 'light'
    e.height/2
  else 0

  e.drawBottom = e.z-e.y+centerY
  e.drawTop = e.z-e.y-e.height+centerY

  e.top     = e.y+e.height-centerY
  e.bottom  = e.y-centerY

  e.front   = e.z+e.depth/2
  e.back    = e.z-e.depth/2
  e.right   = e.x+e.width/2
  e.left    = e.x-e.width/2


# direction helper
directions =
  left:
    axis       : 'x'
    multiplier : -1
    other      : 'right'
  right:
    axis       : 'x'
    multiplier : 1
    other      : 'left'
  up:
    axis       : 'z'
    multiplier : -1
    other      : 'down'
  down:
    axis       : 'z'
    multiplier : 1
    other      : 'up'
