module Plot.Line exposing (..)

{-|
 Attributes for altering the view of your line serie.

    myLineSerie : Plot.Element (Interaction YourMsg)
    myLineSerie =
        line
            [ stroke "deeppink"
            , strokeWidth 2
            , opacity 0.5
            , smoothing Cosmetic
            , customAttrs
                [ Svg.Events.onClick <| Custom MyClickMsg ]
            ]
            lineDataPoints


# Definition
@docs Attribute


-}

import Plot.Attributes exposing (..)


{-| -}
type alias Attribute a =
    LineStyle a -> LineStyle a
