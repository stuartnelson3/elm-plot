module Plot.Tick
    exposing
        ( Attribute
        , StyleAttribute
        )

{-|
 Attributes for altering the view of your axis' ticks.

 Before you read any further, please note that when I speak of the tick _index_,
 then I'm talking about how many ticks that particular tick is from the origin.

 Ok, now you can go on!

# Definition
@docs Attribute, StyleAttribute


-}

import Plot.Attributes exposing (..)


{-| -}
type alias Attribute a msg =
    Tick a msg -> Tick a msg


{-| -}
type alias StyleAttribute msg =
    TickStyle msg -> TickStyle msg
