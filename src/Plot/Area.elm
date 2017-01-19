module Plot.Area exposing (..)

{-|
 Attributes for altering the view of your area serie.

    myAreaSerie : Plot.Element (Interaction YourMsg)
    myAreaSerie =
        line
            [ stroke "deeppink"
            , strokeWidth 2
            , fill "red"
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

import Plot.Attributes exposing (..)


{-| -}
type alias Attribute a =
    AreaStyle a -> AreaStyle a
