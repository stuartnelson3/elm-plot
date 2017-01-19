module Internal.Scatter exposing (..)

import Svg
import Svg.Attributes
import Plot.Types exposing (..)
import Internal.Types exposing (..)
import Internal.Draw exposing (..)
import Plot.Attributes exposing (..)


view : Meta -> Scatter a -> List Point -> Svg.Svg a
view meta { fill, stroke, radius } points =
    let
        svgPoints =
            List.map meta.toSvgCoords points
    in
        Svg.g
            [ Svg.Attributes.fill fill
            , Svg.Attributes.stroke stroke
            ]
            (List.map (toSvgCircle radius) svgPoints)


toSvgCircle : Int -> Point -> Svg.Svg a
toSvgCircle radius ( x, y ) =
    Svg.circle
        [ Svg.Attributes.cx (toString x)
        , Svg.Attributes.cy (toString y)
        , Svg.Attributes.r (toString radius)
        ]
        []
