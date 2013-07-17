$ ->

  chromScale = chroma.scale(['lightyellow', 'navy'])

  scale = (val) ->
    chromScale(parseInt(val) / 100.0)


  map = $K.map '#map'
  map.loadMap 'svg/plz2-1.svg', ->
    map.addLayer 'plz2',
      tooltips: (data) ->
        data.lr
      styles:
        fill: (data) ->
          scale data.lr

    layer = map.getLayer 'plz2'

    layer.on 'click', (data, path, event) ->
      if path.attr('fill') == 'red'
        path.attr 'fill', scale data.lr
      else
        path.attr 'fill', 'red'

