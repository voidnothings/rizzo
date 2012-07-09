# LP Support
# Prototype place-holder for generic cross lib methods 
#
# Methods
#   Support.
#     (string) benchmark: Outputs the execution time of a closure
#     (string) domBenchmark: Outputs the execution time of a closure that interacts with the dom
#

_dep = [
]

define _dep, () ->

  class Support
    @benchmark: (_id='', _fn)->
      _a = new Date().getTime()
      _output = _fn.call()
      _b = new Date().getTime()
      console.log("BM: #{_id}-> #{_b-_a}")
      _output

    @domBenchmark: (_id='', _fn)->
      _a = new Date().getTime()
      _output = _fn.call()
      setTimeout(->
        _b = new Date().getTime()
        _r = (_b-_a)
        console.log("dBM: #{_id}-> #{_r}")
      ,10)
      _output
