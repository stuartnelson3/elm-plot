module Internal.Bars
    exposing
        ( view
        , toPoints
        , getYValues
        )

import Svg
import Svg.Attributes
import Plot.Attributes as Attributes exposing (..)
import Plot.Types exposing (Style, Point, Value)
import Internal.Types exposing (Orientation(..), MaxWidth(..), Meta, Edges, Oriented, Scale)
import Internal.Draw exposing (..)
import Internal.Stuff exposing (..)
import Internal.Label as Label


-- VIEW


view : Meta -> Bars msg -> List (BarsStyle msg) -> List Group -> Svg.Svg msg
view meta config styleConfigs groups =
    let
        width =
            toBarWidth config groups (toAutoWidth meta config styleConfigs groups)
    in
        Svg.g [] (List.map (viewGroup meta config styleConfigs width) groups)


viewGroup : Meta -> Bars msg -> List (BarsStyle msg) -> Float -> Group -> Svg.Svg msg
viewGroup meta config styleConfigs width group =
    let
        labelInfos =
            List.indexedMap
                (\i y ->
                    { index = i, xValue = group.xValue, yValue = y, text = "" }
                )
                group.yValues

        toCoords =
            toStackedCoords meta config styleConfigs width group
    in
        Svg.g []
            [ Svg.g []
                (List.map2
                    (\styleConfig info ->
                        viewBar meta width (toCoords info) config styleConfig info
                    )
                    styleConfigs
                    labelInfos
                )
            , Svg.g [ Svg.Attributes.clipPath ("url(#" ++ toClipPathId meta ++ ")") ]
                (Label.view
                    config.label
                    (\info -> placeLabel width (toCoords info))
                    labelInfos
                )
            ]


toLength : Meta -> Bars msg -> BarLabelInfo -> Value
toLength meta config bar =
    case config.stackBy of
        X ->
            toLengthTouchingXAxis meta config bar

        Y ->
            if bar.index == 0 then
                toLengthTouchingXAxis meta config bar
            else
                bar.yValue * meta.scale.y.length / meta.scale.y.range


toLengthTouchingXAxis : Meta -> Bars msg -> BarLabelInfo -> Value
toLengthTouchingXAxis { scale } config { yValue, index } =
    (yValue - (clamp scale.y.lowest scale.y.highest 0)) * scale.y.length / scale.y.range


toXStackedOffset : List (BarsStyle msg) -> Float -> BarLabelInfo -> Value
toXStackedOffset styleConfigs width { index, yValue } =
    let
        offsetGroup =
            toFloat (List.length styleConfigs) * width / 2

        offsetBar =
            toFloat index * width
    in
        offsetBar - offsetGroup


toYStackedOffset : Group -> BarLabelInfo -> Value
toYStackedOffset { yValues } { index, yValue } =
    List.take index yValues
        |> List.filter (\y -> (y < 0) == (yValue < 0))
        |> List.sum


toStackedCoords : Meta -> Bars msg -> List (BarsStyle msg) -> Float -> Group -> BarLabelInfo -> Point
toStackedCoords meta config styleConfigs width group bar =
    case config.stackBy of
        X ->
            ( bar.xValue, max (min 0 meta.scale.y.highest) bar.yValue )
                |> meta.toSvgCoords
                |> addDisplacement ( toXStackedOffset styleConfigs width bar, 0 )

        Y ->
            ( bar.xValue, bar.yValue )
                |> addDisplacement ( 0, toYStackedOffset group bar )
                |> meta.toSvgCoords
                |> addDisplacement
                    ( -width / 2
                    , min 0 (toLength meta config bar)
                    )


placeLabel : Float -> Point -> Svg.Svg msg -> Svg.Svg msg
placeLabel width ( xSvg, ySvg ) label =
    Svg.g
        [ Svg.Attributes.transform (toTranslate ( xSvg + width / 2, ySvg ))
        , Svg.Attributes.style "text-anchor: middle;"
        ]
        [ label ]


viewBar : Meta -> Float -> Point -> Bars msg -> BarsStyle msg -> BarLabelInfo -> Svg.Svg msg
viewBar meta width ( xSvg, ySvg ) config styleConfig info =
    Svg.rect
        ([ Svg.Attributes.x (toString xSvg)
         , Svg.Attributes.y (toString ySvg)
         , Svg.Attributes.width (toString width)
         , Svg.Attributes.height (toString (abs (toLength meta config info)))
         , Svg.Attributes.fill styleConfig.fill
         , Svg.Attributes.stroke "transparent"
         ]
            ++ styleConfig.customAttrs
        )
        []



-- Calculate width


toAutoWidth : Meta -> Bars msg -> List (BarsStyle msg) -> List Group -> Float
toAutoWidth { scale, toSvgCoords } { maxWidth, stackBy } styleConfigs groups =
    let
        width =
            case stackBy of
                X ->
                    1 / toFloat (List.length styleConfigs)

                Y ->
                    1
    in
        width * scale.x.length / scale.x.range


toBarWidth : Bars msg -> List Group -> Float -> Float
toBarWidth { maxWidth } groups default =
    case maxWidth of
        Attributes.Percentage perc ->
            default * (toFloat perc) / 100

        Attributes.Fixed max ->
            if default > (toFloat max) then
                toFloat max
            else
                default



-- For meta calculations


toPoints : Bars msg -> List Group -> List Point
toPoints config groups =
    List.foldl (foldPoints config) [] groups


foldPoints : Bars msg -> Group -> List Point -> List Point
foldPoints { stackBy } { xValue, yValues } points =
    if stackBy == X then
        points ++ [ ( xValue, getLowest yValues ), ( xValue, getHighest yValues ) ]
    else
        let
            ( positive, negative ) =
                List.partition (\y -> y >= 0) yValues
        in
            points ++ [ ( xValue, List.sum positive ), ( xValue, List.sum negative ) ]


getYValues : Value -> List Group -> Maybe (List Value)
getYValues xValue groups =
    List.map (\{ xValue, yValues } -> ( xValue, Just yValues )) groups
        |> List.filter (\( x, _ ) -> x == xValue)
        |> List.head
        |> Maybe.withDefault ( 0, Nothing )
        |> Tuple.second
