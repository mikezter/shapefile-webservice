$ ->

  chromaScale = chroma.scale(['lightyellow', 'navy'])

  map = $K.map '#map'
  map.loadMap 'svg/world.svg', ->
    map.addLayer 'layer_0',
      tooltips: (data) ->
        data.id
      styles:
        stroke: 'black'
        fill: -> chromaScale(Math.random())

    layer = map.getLayer 'layer_0'

    layer.on 'click', (data, path, event) ->
      if path.attr('fill') == 'red'
        path.attr 'fill', chromaScale(Math.random())
      else
        path.attr 'fill', 'red'

