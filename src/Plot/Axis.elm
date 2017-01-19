module Plot.Axis exposing (..)

{-|
 Attributes for altering the view of your axis.

# Definition
@docs Attribute

-}

import Plot.Attributes as Attributes


{-| -}
type alias Attribute msg =
    Attributes.Axis msg -> Attributes.Axis msg
