module Plot.Scatter exposing (..)

{-|
 Attributes for altering the view of your scatter serie.

    myScatterSerie : Plot.Element (Interaction YourMsg)
    myScatterSerie =
        line
            [ stroke "deeppink"
            , strokeWidth 2
            , fill "purple"
            , opacity 0.5
            , radius 10
            , customAttrs
                [ Svg.Events.onClick <| Custom MyClickMsg
                , Svg.Events.onMouseOver <| Custom Glow
                ]
            ]
            scatterDataPoints

# Definition
@docs Attribute


-}

import Plot.Attributes exposing (..)


{-| -}
type alias Attribute a =
    Scatter a -> Scatter a
