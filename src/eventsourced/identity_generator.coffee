class IdentityGenerator
  @new: () ->
    _p8 = (s) ->
      p = (Math.random().toString(16) + '000000000').substr(2, 8)
      if s
        return "-#{p.substr(0, 4)}-#{p.substr(4, 4)}"
      p
    _p8() + _p8(true) + _p8(true) + _p8()


module.exports = IdentityGenerator
