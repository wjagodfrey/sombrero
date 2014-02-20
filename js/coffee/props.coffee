
propSprites = [
  ['sprites2', 31, 1, 40, 31, 7, 'cactus']
  ['sprites2', 41, 1, 50, 41, 8, 'big cactus']
  ['sprites2', 33, 34, 40, 40, 7, 'skull']
]
propCount = 5 * (window.innerHeight * window.innerWidth / 100000) / scale

while propCount-- > 0
  sprite = propSprites[Math.floor Math.random()*propSprites.length]
  entities.push @c = cactus =
    type: 'prop'
    spriteName: sprite[6]
    shadow: true
    hit: true
    x        : Math.floor Math.random()*window.innerWidth
    z        : Math.floor Math.random()*window.innerHeight
    y        : 0
    width    : (sprite[3] - sprite[1])*scale
    height   : (sprite[4] - sprite[2])*scale
    depth    : sprite[5]
    rotation : 0
    sprite   : sprite

    draw: (ctx) ->
      if loaded
        frm = @sprite
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

          # center point
          .fillStyle 'red'
          .fillRect @x-2, @z-2, 4, 4
          # y line
          .strokeStyle 'yellow'
          .beginPath()
          .moveTo @x, @z
          .lineTo @x, @z-@y
          .stroke()
          # center point
          .fillStyle 'green'
          .fillRect @x-2, @z-@y-2, 4, 4
          .restore()

