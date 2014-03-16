# updates complex edge positions
updateEdges = (e) ->

  e.drawBottom = e.z-e.y
  e.drawTop = e.z-e.y-e.height

  e.top     = e.y+e.height
  e.bottom  = e.y

  e.front   = e.z+e.depth
  e.back    = e.z
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
