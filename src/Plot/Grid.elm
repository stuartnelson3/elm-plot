module Plot.Grid exposing (..)

{-|
 Attributes for altering the view of your grid.

    myGrid : Plot.Element (Interaction YourMsg)
    myGrid =
        line
            [ stroke "deeppink"
            , strokeWidth 2
            , opacity 0.5
            , customAttrs
                [ Svg.Events.onClick <| Custom MyClickMsg
                , Svg.Events.onMouseOver <| Custom Glow
                ]
            ]
            areaDataPoints

# Definition
@docs Attribute


-}

import Plot.Attributes exposing (Grid)


{-| -}
type alias Attribute a =
    Grid a -> Grid a
