
# PLAYER
entities.push @p = player =
  type      : 'player'
  x        : Math.floor window.innerWidth/2
  z        : Math.floor window.innerHeight/2
  y        : 0
  width    : 0
  height   : 0
  depth    : 5
  rotation : 0

  shadow    : true
  hit       : true
  
  direction : 'right'
  action    : 'walk'
  
  force     : 0.5
  velocity:
    x : 0
    z : 0

  light : newLight().set
    on        : false
    y         : 20
    radius    : 0
    fade      : 200
    intensity : 1
    color     : '255,100,10'

  sprites:
    stand:
      left: [
          ['sprites2', 8, 1, 14, 24]
        ]
      right: [
          ['sprites2', 22, 1, 28, 24]
        ]
      up: [
          ['sprites2', 1, 1, 7, 25]
        ]
      down: [
          ['sprites2', 15, 1, 21, 24]
        ]
    walk:
      left: [
          ['sprites2', 8, 27, 14, 50]
          ['sprites2', 8, 53, 14, 76]
          ['sprites2', 8, 79, 14, 102]
          ['sprites2', 8, 105, 14, 128]
        ]
      right: [
          ['sprites2', 22, 27, 28, 50]
          ['sprites2', 22, 53, 28, 76]
          ['sprites2', 22, 79, 28, 102]
          ['sprites2', 22, 105, 28, 128]
        ]
      up: [
          ['sprites2', 1, 27, 7, 50]
          ['sprites2', 1, 53, 7, 76]
          ['sprites2', 1, 79, 7, 102]
          ['sprites2', 1, 105, 7, 128]
        ]
      down: [
          ['sprites2', 15, 27, 21, 50]
          ['sprites2', 15, 53, 21, 76]
          ['sprites2', 15, 79, 21, 102]
          ['sprites2', 15, 105, 21, 128]
        ]

  currentFrame: undefined
  frame: 0
  frameTimer: 0
  frameSpeed: 5

  keys:
    f:
      pressed   : false
      action    : (key) ->
        if @pressed
          player.light.toggle()
    left:
      pressed   : false
      action    : (key) ->
        player.move key
    right:
      pressed   : false
      action    : (key) ->
        player.move key
    up:
      pressed   : false
      action    : (key) ->
        player.move key
    down:
      pressed   : false
      action    : (key) ->
        player.move key

  move: (name) ->
    key = @keys[name]
    direction = directions[name]
    # move this direction?
    @velocity[direction.axis] = @force * direction.multiplier * (if key.pressed then 1 else 0)
    # move opposite direction?
    if @keys[direction.other].pressed and !key.pressed
      @move direction.other
    return

  preUpdate: ->
    # CYCLE FRAMES
    action = @sprites[@action]?[@direction]

    # reset frame to 0 if doesn't exist
    if !action[@frame]? then @frame = 0

    # save current frame
    @currentFrame = action[@frame]

    # save new width and height
    @width  = (@currentFrame[3] - @currentFrame[1])*scale
    @height = (@currentFrame[4] - @currentFrame[2])*scale

    # change frame
    if @frameTimer++ >= (@currentFrame[5] or @frameSpeed)
      @frameTimer = 0
      @frame++


  update: ->
    @x += @velocity.x*scale
    @z += @velocity.z*scale
    @direction = if @velocity.z > 0 then 'down' else if @velocity.z < 0 then 'up' else if @velocity.x > 0 then 'right' else if @velocity.x < 0 then 'left' else @direction
    @action = if !@velocity.x and !@velocity.z then 'stand' else 'walk'

    @light.set
      x: @left + if @direction is 'right' or @direction is 'down'
                @width+3
              else -3
      z: @drawBottom + if @direction is 'up' or @direction is 'right'
                -3-@depth/2
              else 3+@depth/2


    return

  draw: (ctx) ->
    if loaded
      frm = @currentFrame
      if frm?

        ctx.save()
        .translate(@left, @drawTop)
        .rotate(@rotation)
        .drawImage  resources.images[frm[0]]?.canvas, # source
                    frm[1]*scale,                     # source x
                    frm[2]*scale,                     # source y
                    @width,                           # source width
                    @height,                          # source height
                    0,                                # draw x
                    0,                                # draw y
                    @width,                           # draw width
                    @height                           # draw height
        .restore()


        # dev meshes
        if window.showDevMeshes
          ctx.save()
          # back
          .strokeStyle 'cyan'
          .strokeRect @left, @drawTop-@depth/2, @width, @height
          # front
          .strokeStyle 'red'
          .strokeRect @left, @drawTop+@depth/2, @width, @height
          # player center point
          .fillStyle 'red'
          .fillRect @x-2, @z-2, 4, 4
          # y line
          .strokeStyle 'yellow'
          .beginPath()
          .moveTo @x, @z
          .lineTo @x, @z-@y
          .stroke()
          # ground center point
          .fillStyle 'green'
          .fillRect @x-2, @z-@y-2, 4, 4
          .restore()
