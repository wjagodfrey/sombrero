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
      text = "Change 'showDevMeshes' in the console. Press 'f'   ||   #{entities.length} entities | x: #{player.x}, z: #{player.z} | d#{delta}"
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

@l = light = newLight().set
  on: true
  radius: 40
  fade: 40
  x: window.innerWidth/2+20
  z: window.innerHeight/2
  y: 150
iii = 0

gameCanvas = cq().framework(
  onresize: (width, height) ->
    @canvas.width = width
    @canvas.height = height
    return

  onmousemove: (x, z) ->
    light.set
      x: x
      y: light.z-z

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
    # if iii < 2
    @clear('#f8e8c3')

    # update entities
    for i, entity of entities
      entity.preUpdate? parseInt(i), delta, time
      updateEdges entity
      checkHit entity
      entity.update? parseInt(i), delta, time
      shade.updateRender entity, parseInt(i), delta, time

    # adjust draw order
    entities.sort (a,b) ->
      if !a.height? and !b.height? then return 0
      else if !a.height? then return 1
      else if !b.height? then return -1
      (a.z) - (b.z)

    # draw entities
    for i, entity of entities
      # if entity.type in ['shade','light']
        entity.draw?(@, delta, time, parseInt i)
    iii++
    return
).appendTo 'body'