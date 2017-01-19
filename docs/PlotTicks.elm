module PlotTicks exposing (plotExample)

import Svg
import Plot exposing (..)
import Plot.Attributes as Attributes exposing (..)
import Common exposing (..)


plotExample : PlotExample msg
plotExample =
    { title = title
    , code = code
    , view = ViewStatic view
    , id = id
    }


title : String
title =
    "Custom ticks and labels"


id : String
id =
    "PlotTicks"


data : List ( Float, Float )
data =
    [ ( 0, 14 ), ( 1, 16 ), ( 2, 26 ), ( 3, 32 ), ( 4, 28 ), ( 5, 32 ), ( 6, 29 ), ( 7, 46 ), ( 8, 52 ), ( 9, 53 ), ( 10, 59 ) ]


isOdd : Int -> Bool
isOdd n =
    rem n 2 > 0


toTickStyle : AxisLabelInfo -> List (Attribute (TickStyle msg))
toTickStyle { index } =
    if isOdd index then
        [ length 7
        , stroke "#e4e3e3"
        ]
    else
        [ length 10
        , stroke "#b9b9b9"
        ]


toLabelStyle : AxisLabelInfo -> List (Attribute (LabelStyle msg))
toLabelStyle { index } =
    if isOdd index then
        []
    else
        [ stroke "#969696"
        ]


view : Svg.Svg a
view =
    plot
        [ size plotSize
        , margin ( 10, 20, 40, 20 )
        ]
        [ line
            [ stroke pinkStroke
            , strokeWidth 2
            ]
            data
        , xAxis
            [ lineStyle [ stroke axisColor ]
            , tick [ viewDynamic toTickStyle ]
            , label
                [ format
                    (FormatFromFunc
                        (\{ index, value } ->
                            if isOdd index then
                                ""
                            else
                                toString value ++ " s"
                        )
                    )
                , viewDynamic toLabelStyle
                ]
            ]
        ]


code : String
code =
    """
    isOdd : Int -> Bool
    isOdd n =
        rem n 2 > 0


    toTickStyle : LabelInfo -> List (Attribute msg)
    toTickStyle { index } =
        if isOdd index then
            [ length 7
            , stroke "#e4e3e3"
            ]
        else
            [ length 10
            , stroke "#b9b9b9"
            ]


    toLabelStyle : LabelInfo -> List (Label.Attribute msg)
    toLabelStyle { index } =
        if isOdd index then
            []
        else
            [ Label.stroke "#969696"
            ]


    view : Svg.Svg a
    view =
        plot
            [ size plotSize
            , margin ( 10, 20, 40, 20 )
            ]
            [ line
                [ Style.stroke pinkStroke
                , Style.strokeWidth 2
                ]
                data
            , xAxis
                [ lineStyle [ Style.stroke axisColor ]
                , tick [ viewDynamic toTickStyle ]
                , label
                    [ Label.format
                        (\\{ index, value } ->
                            if isOdd index then
                                ""
                            else
                                toString value ++ " s"
                        )
                    , Label.viewDynamic toLabelStyle
                    ]
                ]
            ]
    """
