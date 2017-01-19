module PlotSticky exposing (plotExample)

import Svg
import Plot exposing (..)
import Plot.Attributes as Attributes exposing (..)
import Common exposing (..)


plotExample : PlotExample msg
plotExample =
    { title = title
    , code = code
    , view = ViewStatic viewPlot
    , id = id
    }


title : String
title =
    "Sticky axis"


id : String
id =
    "PlotSticky"


data : List ( Float, Float )
data =
    [ ( 0, 14 ), ( 1, 16 ), ( 2, 26 ), ( 3, 32 ), ( 4, 28 ), ( 5, 32 ), ( 6, 29 ), ( 7, 46 ), ( 8, 52 ), ( 9, 53 ), ( 10, 59 ) ]


isOdd : Int -> Bool
isOdd n =
    rem n 2 > 0


tickStyles : List (Attribute (TickStyle msg))
tickStyles =
    [ length 7
    , stroke "#e4e3e3"
    ]


toLabelAttrsY : AxisLabelInfo -> List (Attribute (LabelStyle msg))
toLabelAttrsY { index, value } =
    if not <| isOdd index then
        []
    else
        [ displace ( -5, 0 ) ]


viewPlot : Svg.Svg a
viewPlot =
    plot
        [ size plotSize
        , margin ( 10, 20, 40, 20 )
        , padding ( 0, 20 )
        , domainLowest (always -21)
        ]
        [ line
            [ stroke pinkStroke
            , strokeWidth 2
            ]
            data
        , xAxis
            [ tick
                [ viewStatic tickStyles
                , values (ValuesFromList [ 3, 6 ])
                ]
            , lineStyle [ stroke Common.axisColor ]
            , label
                [ format (FormatFromFunc (\{ value } -> toString value ++ " ms")) ]
            , clearIntersections
            ]
        , yAxis
            [ position (PositionHighest)
            , clearIntersections
            , tick [ viewStatic tickStyles ]
            , lineStyle
                [ stroke Common.axisColor ]
            , label
                [ viewDynamic toLabelAttrsY
                , format
                    (FormatFromFunc
                        (\{ index, value } ->
                            if not <| isOdd index then
                                ""
                            else
                                toString (value * 10) ++ " x"
                        )
                    )
                ]
            ]
        , yAxis
            [ position (PositionLowest)
            , clearIntersections
            , anchor (AnchorInner)
            , lineStyle [ stroke Common.axisColor ]
            , label
                [ format
                    (FormatFromFunc
                        (\{ index, value } ->
                            if isOdd index then
                                ""
                            else
                                toString (value / 5) ++ "k"
                        )
                    )
                ]
            ]
        ]


code : String
code =
    """
    isOdd : Int -> Bool
    isOdd n =
        rem n 2 > 0


    tickStyles : List (Attribute msg)
    tickStyles =
        [ length 7
        , stroke "#e4e3e3"
        ]


    toLabelAttrsY : LabelInfo -> List (Attribute msg)
    toLabelAttrsY { index, value } =
        if not <| isOdd index then
            []
        else
            [ displace ( -5, 0 ) ]


    view : Svg.Svg a
    view =
        plot
            [ size plotSize
            , margin ( 10, 20, 40, 20 )
            , padding ( 0, 20 )
            , domainLowest (always -21)
            ]
            [ line
                [ Style.stroke pinkStroke
                , Style.strokeWidth 2
                ]
                data
            , xAxis
                [ tick
                    [ view toTickAttrs ]
                , tickValues [ 3, 6 ]
                , lineStyle [ Style.stroke axisColor ]
                , label
                    [ format (\\{ value } -> toString value ++ " ms") ]
                , clearIntersections
                ]
            , yAxis
                [ position (PositionHighest)
                , lineStyle [ Style.stroke axisColor ]
                , clearIntersections
                , tick [ view toTickAttrs ]
                , label
                    [ viewDynamic toLabelAttrsY
                    , format
                        (\\{ index, value } ->
                            if not <| isOdd index then
                                ""
                            else
                                toString (value * 10) ++ " x"
                        )
                    ]
                ]
            , yAxis
                [ position (PositionLowest)
                , clearIntersections
                , lineStyle [ Style.stroke axisColor ]
                , anchor (AnchorInner)
                , label
                    [ format
                        (\\{ index, value } ->
                            if isOdd index then
                                ""
                            else
                                toString (value / 5) ++ "k"
                        )
                    ]
                ]
            ]
    """
