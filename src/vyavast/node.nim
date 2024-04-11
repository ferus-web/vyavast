import std/options
import vmath
import ./[
  margins, paddings
]

type
  NodeOpts* = ref object
    moves*: bool
    scales*: bool

  DisplayKind* = enum
    dkBlock
    dkInline
    dkTable
    dkGrid
    dkPositioned
    dkFlex

  Node* = ref object
    scale*: Vec2
    opts*: NodeOpts

    computed*: Option[Vec2]

    margin*: Margin = Margin(top: 4, bottom: 4, left: 4, right: 4)
    padding*: Padding = Padding(top: 4, bottom: 4, left: 4, right: 4)

    case kind*: DisplayKind
    of dkPositioned:
      left*, right*, up*, down*: float32
    else: discard

proc isFlow*(display: DisplayKind): bool {.inline.} =
  display == dkBlock or display == dkInline
