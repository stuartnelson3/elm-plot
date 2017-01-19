module PlotArea exposing (plotExample)

import Svg
import Plot exposing (..)
import Common exposing (..)
import Plot.Area as Area
import Plot.Line as Line
import Plot.Axis as Axis
import Plot.Attributes exposing (..)


plotExample : PlotExample msg
plotExample =
    { title = title
    , code = code
    , view = ViewStatic view
    , id = id
    }


title : String
title =
    "Areas"


id : String
id =
    "PlotArea"


data1 : List ( Float, Float )
data1 =
    [ ( 0, 20 ), ( 10, 65 ), ( 20, 35 ), ( 30, 85 ) ]


data2 : List ( Float, Float )
data2 =
    [ ( 0, 10 ), ( 10, 50 ), ( 20, 10 ), ( 30, 75 ) ]


view : Svg.Svg a
view =
    plot
        [ size plotSize
        , margin ( 10, 20, 40, 20 )
        ]
        [ area
            [ stroke skinStroke
            , smoothingBezier
            , fill skinFill
            ]
            data1
        , area
            [ stroke blueStroke
            , interpolation Bezier
            , fill blueFill
            ]
            data2
        , xAxis
            [ lineStyle [ stroke axisColor ]
            , tick [ values (ValuesFromDelta 10) ]
            ]
        ]


code : String
code =
    """
    view : Svg.Svg a
    view =
        plot
            [ size plotSize
            , margin ( 10, 20, 40, 20 )
            ]
            [ area
                [ stroke skinStroke
                , fill skinFill
                ]
                data1
            , area
                [ stroke blueStroke
                , fill blueFill
                ]
                data2
            , xAxis
                [ Attributes.lineStyle [ Line.stroke axisColor ]
                , Axis.tickDelta 10
                ]
            ]
    """
