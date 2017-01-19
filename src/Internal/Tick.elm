module Internal.Tick exposing (toView)

import Plot.Attributes as Attributes exposing (..)
import Internal.Types exposing (Orientation(..), Scale, Meta, IndexedInfo)
import Internal.Draw as Draw exposing (..)
import Internal.View as View
import Svg
import Svg.Attributes


type alias TickInfo a =
    { a | orientation : Orientation }


toView : Tick (TickInfo a) msg -> TickInfo a -> Svg.Svg msg
toView { view } =
    View.useView
        { view = view
        , defaultStyles = defaultTickStyle
        , defaultView = defaultView
        }


defaultView : TickStyle msg -> TickInfo a -> Svg.Svg msg
defaultView { length, width, style, classes, customAttrs } { orientation } =
    let
        styleFinal =
            style ++ [ ( "stroke-width", toPixelsInt width ) ]

        attrs =
            [ Svg.Attributes.style (toStyle styleFinal)
            , Svg.Attributes.y2 (toString length)
            , Svg.Attributes.class <| String.join " " <| "elm-plot__tick__default-view" :: classes
            ]
                ++ customAttrs
    in
        Svg.line attrs []
