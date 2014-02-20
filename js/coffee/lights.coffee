###


  when a shadow object registers a hit on the light's bounding box,
  draw the object to the mask layer belonging to the light

  when the light is drawn, apply the light to the mask layer belonging to the light,
  and then apply the mask layer belonging to the light to the shade rendering layer

  draw the light colour to the rendering layer if it exists
 


###


lightYScaleShift = 0.80
# LIGHTS
newLight = ->
  light =
    type: 'light'
    hit: true
    
    x: 0
    y: 0
    z: 0
    width: 0
    height: 0
    depth: 0

    intensity: 1
    radius: 0
    fade: 0
    color: ''
    on: false
    toggle: ->
      @on = !@on
    set: (opts) ->
      for key, opt of opts
        if @[key]?
          @[key] = opt
      @

    preUpdate: ->
      # check width, height and depth
      @width  = (@radius+@fade)*2
      @height = @width
      @depth = (@radius+@fade)*2*lightYScaleShift

      if @y < 0 then @y = 0

    # draw: (ctx, delta, time, index) ->
    #   if @on

    #     # console.log entities, index

    #     # light mask
    #     maskLight = shade.render
    #     .createRadialGradient(0, 0, @radius, 0, 0, @radius+@fade)
    #     maskLight.addColorStop(0, "rgba( 0,0,0,  1)")
    #     maskLight.addColorStop(1, "rgba( 0,0,0,  0 )")

    #     shade.lightsMask
    #     .save()
    #     .translate(@x, @z-@y)
    #     .fillStyle(maskLight)
    #     .beginPath()
    #     .arc(0,0,@radius+@fade,0,2*Math.PI)
    #     .fill()
    #     .restore()

    #     shade.entityMask
    #     .save()
    #     .globalCompositeOperation('destination-out')
    #     .translate(@x, @z-@y)
    #     .fillStyle(maskLight)
    #     .beginPath()
    #     .arc(0,0,@radius+@fade,0,2*Math.PI)
    #     .fill()
    #     .restore()

    #     # light color
    #     if @color
    #       light = shade.lightsColor
    #       .createRadialGradient(0, 0, @radius, 0, 0, @radius+@fade)
    #       light.addColorStop(0, "rgba( #{@color},  #{@intensity} )")
    #       light.addColorStop(1, "rgba( #{@color},  0 )")

    #       shade.lightsColor
    #       .save()
    #       .translate(@x, @z-@y)
    #       .fillStyle(light)
    #       .beginPath()
    #       .arc(0,0,@radius+@fade,0,2*Math.PI)
    #       .fill()
    #       .restore()

    #     # get bottom half of light edges
    #     i = 1 + index
    #     ll = @x-@radius-@fade
    #     lr = @x+@radius+@fade
    #     lt = @z
    #     lb = lt+@radius+@fade
    #     draw = true
    #     while draw and i <= entities.length-1
    #       entity = entities[i]
    #       # get element edges
    #       if entity?.width? and entity?.height?
    #         el = entity.x-entity.width/2
    #         er = entity.x+entity.width/2
    #         et = entity.z-entity.height/2
    #         eb = entity.z+entity.height/2
    #         # if element is in the light, draw it to the mask
    #         # if eb < lt
    #         # console.log index, @z, i
    #         if entity.shadow
    #           entity.draw? shade.entityMask, delta, time, i
    #       i++
    #           # else if et < lb

    #           # draw = false






  entities.push light
  light


      # draw shadows
entities.push shade =
  opacity: 0.5
  color: '#34284b'
  type: 'shade'
  render: cq()
  entityMask: cq()
  lightsMask: cq()
  lightsColor: cq()
  updateRender: (e, index, delta, time)->

      if e.type is 'light'
        if e.on

          # calculate new radius and fade with y axis
          radius = e.radius - e.y
          fade = e.fade
          intensity = e.intensity
          if radius < 0 #or radius > e.radius
            radius = 0
            fade -= e.y - e.radius
            if fade < 0 #or fade > e.fade
              fade = 0
            intensity = fade / e.fade

          # light mask
          maskLight = @render
          .createRadialGradient(0, 0, radius, 0, 0, radius+fade)
          maskLight.addColorStop(0, "rgba( 0,0,0,  #{intensity} )")
          maskLight.addColorStop(1, "rgba( 0,0,0,  0 )")

          @lightsMask
          .save()
          .translate(e.x, e.z)
          .scale(1,lightYScaleShift)
          .fillStyle(maskLight)
          .beginPath()
          .arc(0,0,radius+fade,0,2*Math.PI)
          .fill()
          .restore()

          @entityMask
          .save()
          .globalCompositeOperation('destination-out')
          .translate(e.x, e.z)
          .fillStyle(maskLight)
          .beginPath()
          .arc(0,0,radius+fade,0,2*Math.PI)
          .fill()
          .restore()


          # light color
          if e.color
            light = @lightsColor
            .createRadialGradient(0, 0, radius, 0, 0, radius+fade)
            light.addColorStop(0, "rgba( #{e.color},  #{intensity} )")
            light.addColorStop(1, "rgba( #{e.color},  0 )")

            @lightsColor
            .save()
            .translate(e.x, e.z)
            .scale(1,lightYScaleShift)
            .fillStyle(light)
            .beginPath()
            .arc(0,0,radius+fade,0,2*Math.PI)
            .fill()
            .restore()

          # dev meshes
          if window.showDevMeshes

            belowGround = 0
            if e.y < e.height/2
              belowGround = (e.height/2)-e.y

            @lightsColor.save()
            # back
            .strokeStyle 'cyan'
            .strokeRect e.left, e.drawTop-e.depth/2, e.width, e.height-belowGround

            # player center point
            .fillStyle 'red'
            .fillRect e.x-2, e.z-2, 4, 4
            # y line
            .strokeStyle 'yellow'
            .beginPath()
            .moveTo e.x, e.z
            .lineTo e.x, e.z-e.y
            .stroke()

            # diagonal bottom lines
            .strokeStyle 'blue'
            .beginPath()
            .moveTo e.left, e.drawBottom+e.depth/2-belowGround
            .lineTo e.right, e.drawBottom-e.depth/2-belowGround
            .stroke()
            .beginPath()
            .moveTo e.right, e.drawBottom+e.depth/2-belowGround
            .lineTo e.left, e.drawBottom-e.depth/2-belowGround
            .stroke()

            # diagonal top lines
            .strokeStyle 'orange'
            .beginPath()
            .moveTo e.left, e.drawTop+e.depth/2
            .lineTo e.right, e.drawTop-e.depth/2
            .stroke()
            .beginPath()
            .moveTo e.right, e.drawTop+e.depth/2
            .lineTo e.left, e.drawTop-e.depth/2
            .stroke()

            # ground center point
            .fillStyle 'green'
            .fillRect e.x-2, e.z-e.y-2, 4, 4
            .restore()

            # front
            .strokeStyle 'red'
            .strokeRect e.left, e.drawTop+e.depth/2, e.width, e.height-belowGround


          # @lightsColor.save()
          # # center point
          # .fillStyle 'red'
          # .fillRect e.x-2, e.z-2, 4, 4
          # # y line
          # .strokeStyle 'yellow'
          # .beginPath()
          # .moveTo e.x, e.z
          # .lineTo e.x, e.z-e.y
          # .stroke()
          # # center point
          # .fillStyle 'green'
          # .fillRect e.x-2, e.z-e.y-2, 4, 4
          # .restore()

      else if e.shadow
        e.draw? @entityMask, delta, time, index
        

  draw: (ctx, delta, time, index) ->
    if loaded


      # apply mask to lights
      @lightsColor
      .save()
      .globalCompositeOperation('destination-out')
      .drawImage(@entityMask.canvas,0,0)
      .restore()

      @lightsMask
      .save()
      .globalCompositeOperation('destination-out')
      .drawImage(@entityMask.canvas,0,0)
      .restore()

      # apply mask and then lights to shadows
      @render
      .save()
      .globalCompositeOperation('destination-out')
      .drawImage(@lightsMask.canvas,0,0)
      .restore()
      .save()
      .drawImage(@lightsColor.canvas,0,0)
      .restore()

      # draw to screen
      ctx
      .save()
      .globalAlpha(@opacity)
      .drawImage(@render.canvas,0,0)
      .restore()

      @lightsColor
      .clear()
      @entityMask
      .clear()
      @lightsMask
      .clear()
      @render
      .clear(@color)