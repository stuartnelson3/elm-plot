module PlotStyles exposing (plotExample)

import Svg
import Plot exposing (..)
import Plot.Attributes as Attributes
import Plot.Axis as Axis
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
    "Lines"


id : String
id =
    "PlotLines"


data1 : List ( Float, Float )
data1 =
    [ ( 0, 2 ), ( 1, 4 ), ( 2, 5 ), ( 3, 10 ) ]


data2 : List ( Float, Float )
data2 =
    [ ( 0, 0 ), ( 1, 5 ), ( 2, 7 ), ( 3, 15 ) ]


view : Svg.Svg a
view =
    plot
        [ size plotSize
        , margin ( 10, 20, 40, 20 )
        , domainLowest (min 0)
        ]
        [ line
            [ Attributes.stroke blueStroke
            , Attributes.strokeWidth 2
            ]
            data1
        , line
            [ Attributes.stroke pinkStroke
            , Attributes.strokeWidth 2
            ]
            data2
        , xAxis
            [ Axis.line
                [ Attributes.stroke axisColor ]
            , Axis.tickDelta 1
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
            , domainLowest (min 0)
            ]
            [ line
                [ Style.stroke blueStroke
                , Style.strokeWidth 2
                ]
                data1
            , line
                [ Style.stroke pinkStroke
                , Style.strokeWidth 2
                ]
                data2
            , xAxis
                [ Axis.line
                    [ Style.stroke axisColor ]
                , Axis.tickDelta 1
                ]
            ]
    """
