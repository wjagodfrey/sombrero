# GUI DISPLAY
entities.push display =
  type: 'display'
  render    : cq()
  updateWait  : 10
  updateCount : 0
  x         : 10
  z         : 10
  draw: (ctx, delta, time) ->
    if @updateCount is 0
      text = "#{entities.length} entities | x: #{player.x}, z: #{player.z} , y: #{player.y} | d#{delta}"
      @render
      .clear()
      .save()
      .textBaseline('top')
      .font('20px consolas')
      .fillStyle('white')
      .fillText(text, 0, 0)
      .restore()
    if @updateCount++ > @updateWait
      @updateCount = 0
    ctx.save()
    .translate(@x, @z)
    .drawImage(@render.canvas, 0, 0)
    .restore()

iii = 0

gameCanvas = cq().framework(
  onresize: (width, height) ->
    @canvas.width = width
    @canvas.height = height
    return

  onmousemove: (x, z) ->

  onkeydown: (key) ->
    if player.keys[key]? and !player.keys[key]?.pressed
      player.keys[key].pressed = true
      player.keys[key].action key
    return

  onkeyup: (key) ->
    if player.keys[key]?.pressed
      player.keys[key].pressed = false
      player.keys[key].action key
    return

  onrender: (delta, time) ->
    # if iii < 50
      if loaded then iii++
      @clear('#f8e8c3')

      # update entities
      for i, entity of entities
        i = parseInt(i)
        entity.preUpdate? i, delta, time
        updateEdges entity
        checkHit entity, i, delta, time
        entity.update? i, delta, time

      # adjust draw order
      entities.sort (a,b) ->
        if !a.height? and !b.height? then return 0
        else if !a.height? then return 1
        else if !b.height? then return -1
        (a.z) - (b.z)

      # draw entities
      for i, entity of entities
        entity.draw?(@, delta, time, parseInt i)
      return
).appendTo 'body'