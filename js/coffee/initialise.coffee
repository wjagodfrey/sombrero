# canvas query game about punching things

# development config
@showDevMeshes = false

# game config
scale = 2

gravity = 0.04

# preloading
images = [
  {
    name   : 'sprites2'
    source : './img/sprites2.png'
  }
]

loaded = false
resourceCount = 0
@r = resources =
  images : {}
  audio  : {}
@e = entities = []

# load resources
for image in images
  do (image) ->
    img = document.createElement('img')
    img.onload = ->
      resources.images[image.name] = cq(img).resizePixel scale
      resourceCount++
      # set to true if resources are loaded
      if resourceCount is images.length
        loaded = true
    img.src = image.source