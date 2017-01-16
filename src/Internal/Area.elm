module Internal.Area exposing (..)

import Svg
import Svg.Attributes
import Internal.Types exposing (..)
import Plot.Types exposing (..)
import Internal.Stuff exposing (getEdgesX)
import Internal.Draw exposing (PathType(..), toPath, toLinePath, toStyle, toClipPathId)


type alias Config a =
    { stroke : String
    , strokeWidth : Int
    , fill : String
    , opacity : Float
    , smoothing : Smoothing
    , customAttrs : List (Svg.Attribute a)
    }


defaultConfig : Config a
defaultConfig =
    { stroke = "black"
    , strokeWidth = 1
    , fill = "grey"
    , opacity = 1
    , smoothing = None
    , customAttrs = []
    }


view : Meta -> Config a -> List Point -> Svg.Svg a
view meta config points =
    let
        ( lowestX, highestX ) =
            getEdgesX points

        lowestY =
            clamp meta.scale.y.lowest meta.scale.y.highest 0

        instructions =
            List.concat
                [ [ M ( lowestX, lowestY ) ]
                , (toLinePath config.smoothing points)
                , [ L ( highestX, lowestY ), Z ]
                ]
                |> toPath meta
    in
        Svg.path
            (List.append
                [ Svg.Attributes.d instructions
                , Svg.Attributes.opacity (toString config.opacity)
                , Svg.Attributes.fill config.fill
                , Svg.Attributes.stroke config.stroke
                , Svg.Attributes.strokeWidth (toString config.strokeWidth ++ "px")
                , Svg.Attributes.class "elm-plot__serie--area"
                , Svg.Attributes.clipPath ("url(#" ++ toClipPathId meta ++ ")")
                ]
                config.customAttrs
            )
            []
