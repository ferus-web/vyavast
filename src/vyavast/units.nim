import vmath

type
  Bounds* = object
    w*, h*: float

proc `<`*(x, y: Bounds): bool =
  (x.w * x.h) < (y.w * y.h)

proc bounds*(w, h: float): Bounds {.inline.} =
  Bounds(w: w, h: h)

export vmath
