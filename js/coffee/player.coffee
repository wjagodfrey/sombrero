
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
  action    : 'stand'

  force     : 0.5
  velocity:
    x : 0
    y : 0
    z : 0

  sprites:
    stand:
      left: [
          ['sprites2', 8, 1, 14, 23]
        ]
      right: [
          ['sprites2', 22, 1, 28, 23]
        ]
      up: [
          ['sprites2', 1, 1, 7, 23]
        ]
      down: [
          ['sprites2', 15, 1, 21, 23]
        ]
    walk:
      left: [
          ['sprites2', 8, 30, 14, 52]
          ['sprites2', 8, 59, 14, 81]
          ['sprites2', 8, 88, 14, 110]
          ['sprites2', 8, 117, 14, 139]
        ]
      right: [
          ['sprites2', 22, 30, 28, 52]
          ['sprites2', 22, 59, 28, 81]
          ['sprites2', 22, 88, 28, 110]
          ['sprites2', 22, 117, 28, 139]
        ]
      up: [
          ['sprites2', 1, 30, 7, 52]
          ['sprites2', 1, 59, 7, 81]
          ['sprites2', 1, 88, 7, 110]
          ['sprites2', 1, 117, 7, 139]
        ]
      down: [
          ['sprites2', 15, 30, 21, 52]
          ['sprites2', 15, 59, 21, 81]
          ['sprites2', 15, 88, 21, 110]
          ['sprites2', 15, 117, 21, 139]
        ]

  currentFrame: undefined
  frame: 0
  frameTimer: 0
  frameSpeed: 5

  keys:
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

  onHit: (hit) ->
    o = hit.other
    if o.y+o.height < @y+@height/4
      @y = o.y+o.height
      updateEdges @
    else #fix collision

      # absX = Math.abs(@velocity.x)
      # absZ = Math.abs(@velocity.z)

      # if absX >= absY and absX >= absZ
      #   direction = if @velocity.x > 0 then 1 else -1
      #   # @velocity.x = 0
      #   @x = (o.x-((o.width)/2*direction))-(@width/2)*direction
      # if absY >= absX and absY >= absZ
      #   direction = if @velocity.y > 0 then 1 else -1
      #   @velocity.y = 0
      # if absZ >= absY and absZ >= absX
      #   if @velocity.z > 0 # hitting the back
      #     depth = -@depth-2
      #   else # hitting the front
      #     depth = o.depth+2
      #   # @velocity.z = 0
      #  @z = o.z+depth

  preUpdate: ->
    # CYCLE FRAMES
    @velocity.y -= gravity
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
    @y += @velocity.y*scale
    @z += @velocity.z*scale

    if @y < 0
      @y = 0

    @direction = if @velocity.z > 0 then 'down' else if @velocity.z < 0 then 'up' else if @velocity.x > 0 then 'right' else if @velocity.x < 0 then 'left' else @direction
    @action = if !@velocity.x and !@velocity.z then 'stand' else 'walk'
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
                    @height+(4*scale),                # source height
                    0,                                # draw x
                    0,                                # draw y
                    @width,                           # draw width
                    @height+(4*scale)                 # draw height
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
