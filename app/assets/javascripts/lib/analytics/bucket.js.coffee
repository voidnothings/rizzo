define [], ->

  class Bucket

    constructor: (opts={})->
      @bin = opts.bin or 25
      @max = opts.max or 10000
      @min = opts.min or 0
      @floor = if opts.floor is false then false else true

    distribute: (value)->
     if @floor
       parseInt((value - (value % @bin)),10)
     else
       parseInt((value + (@bin - (value % @bin))),10)

    normalize: (value)->
      if(value > @max)
        return @max
      if(value < this.min)
        return @min
      @distribute(value)
