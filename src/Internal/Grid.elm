module Internal.Grid exposing (..)

import Svg
import Plot.Types exposing (..)
import Plot.Attributes exposing (..)
import Internal.Types exposing (..)
import Internal.Draw as Draw exposing (..)
import Internal.Line as Line


getValues : List Float -> ValuesOption -> List Float
getValues tickValues values =
    case values of
        ValuesAuto ->
            tickValues

        ValuesFromList customValues ->
            customValues

        ValuesFromDelta delta ->
            [ 0, 2, 3 ]


view : Meta -> Grid a -> Svg.Svg a
view meta ({ values, classes, orientation } as config) =
    Svg.g
        [ Draw.classAttributeOriented "grid" orientation classes ]
        (viewLines meta config)


viewLines : Meta -> Grid a -> List (Svg.Svg a)
viewLines ({ oppositeTicks } as meta) { values, lineStyle } =
    List.map (viewLine lineStyle meta) <| getValues oppositeTicks values


viewLine : LineStyle a -> Meta -> Value -> Svg.Svg a
viewLine config meta position =
    Line.view meta config [ ( meta.scale.x.lowest, position ), ( meta.scale.x.highest, position ) ]
