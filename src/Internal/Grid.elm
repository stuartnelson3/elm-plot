module Internal.Grid exposing (..)

import Svg
import Plot.Types exposing (..)
import Internal.Types exposing (..)
import Internal.Draw as Draw exposing (..)
import Internal.Line as Line


type Values
    = MirrorTicks
    | CustomValues (List Float)


type alias Config a =
    { values : Values
    , linesConfig : Line.Config a
    , classes : List String
    , orientation : Orientation
    , customAttrs : List (Svg.Attribute a)
    }


defaultConfigX : Config a
defaultConfigX =
    { values = MirrorTicks
    , linesConfig = Line.defaultConfig
    , classes = []
    , orientation = X
    , customAttrs = []
    }


defaultConfigY : Config a
defaultConfigY =
    { defaultConfigX | orientation = Y }


getValues : List Float -> Values -> List Float
getValues tickValues values =
    case values of
        MirrorTicks ->
            tickValues

        CustomValues customValues ->
            customValues


view : Meta -> Config a -> Svg.Svg a
view meta ({ values, classes, orientation } as config) =
    Svg.g
        [ Draw.classAttributeOriented "grid" orientation classes ]
        (viewLines meta config)


viewLines : Meta -> Config a -> List (Svg.Svg a)
viewLines ({ oppositeTicks } as meta) { values, linesConfig } =
    List.map (viewLine linesConfig meta) <| getValues oppositeTicks values


viewLine : Line.Config a -> Meta -> Value -> Svg.Svg a
viewLine config meta position =
    Line.view meta config [ ( meta.scale.x.lowest, position ), ( meta.scale.x.highest, position ) ]
