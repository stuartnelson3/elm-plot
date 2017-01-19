module Internal.Label
    exposing
        ( view
        , defaultView
        )

import Plot.Attributes as Attributes exposing (..)
import Internal.Draw as Draw exposing (..)
import Svg
import Svg.Attributes
import Internal.View as View


type alias LabelInfo a =
    { a | text : String }


type alias ViewWrap a msg =
    a -> Svg.Svg msg -> Svg.Svg msg


view : Label c (LabelInfo a) msg -> ViewWrap (LabelInfo a) msg -> List (LabelInfo a) -> List (Svg.Svg msg)
view config wrapView infos =
    toLabelText config infos
        |> List.map (View.useView (viewConfig config))
        |> List.map2 wrapView infos


viewConfig : Label c (LabelInfo a) msg -> View.Config (LabelInfo a) (LabelStyle msg) msg
viewConfig config =
    { view = config.view
    , defaultStyles = defaultLabelStyle
    , defaultView = defaultView
    }


toLabelText : Label c (LabelInfo a) msg -> List (LabelInfo a) -> List (LabelInfo a)
toLabelText config infos =
    case config.format of
        FormatFromFunc formatter ->
            List.map (\info -> { info | text = formatter info }) infos

        FormatFromList texts ->
            List.map2 (\info text -> { info | text = text }) infos texts


defaultView : LabelStyle msg -> LabelInfo a -> Svg.Svg msg
defaultView config info =
    let
        ( dx, dy ) =
            config.displace
    in
        Svg.text_
            (List.append
                [ Svg.Attributes.transform (toTranslate ( toFloat dx, toFloat dy ))
                , Svg.Attributes.opacity (toString config.opacity)
                , Svg.Attributes.fill config.fill
                , Svg.Attributes.style (toStyle config.style)
                , Svg.Attributes.stroke (toString config.stroke ++ "px")
                , Svg.Attributes.strokeWidth (toString config.strokeWidth ++ "px")
                , Svg.Attributes.class (String.join " " ("elm-plot__label__default-view" :: config.classes))
                ]
                config.customAttrs
            )
            [ Svg.tspan [] [ Svg.text info.text ] ]
