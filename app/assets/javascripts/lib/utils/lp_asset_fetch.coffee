define ()->

  class AssetFetch

    @get: (_src, _callback) ->
      c = document.createElement('script')
      c.src = _src
      c.async = true
      c.onload = c.onreadystatechange = -> _callback()
      s = document.getElementsByTagName('script')[0]
      s.parentNode.insertBefore(c, s)
