jade --watch *.jade &
coffee -w -j js/punch.js -c js/coffee/util.coffee js/coffee/initialise.coffee js/coffee/hit.coffee js/coffee/props.coffee js/coffee/player.coffee js/coffee/framework.coffee &
stylus -w css/ && fg