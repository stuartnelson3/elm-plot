module PlotScatter exposing (plotExample)

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
    "Scatters"


id : String
id =
    "PlotScatter"


data : List ( Float, Float )
data =
    [ ( 0, 10 ), ( 2, 12 ), ( 4, 27 ), ( 6, 25 ), ( 8, 46 ) ]


view : Svg.Svg a
view =
    plot
        [ size plotSize
        , margin ( 10, 20, 40, 40 )
        , domainLowest (min 0)
        ]
        [ scatter
            [ stroke pinkStroke
            , fill pinkFill
            , radius 8
            ]
            data
        , xAxis
            [ lineStyle
                [ stroke axisColor ]
            , tick [ values (ValuesFromDelta 2) ]
            ]
        ]


code : String
code =
    """
    view : Svg.Svg a
    view =
        plot
            [ size plotSize
            , margin ( 10, 20, 40, 40 )
            , domainLowest (min 0)
            ]
            [ scatter
                [ stroke pinkStroke
                , fill pinkFill
                , radius 8
                ]
                data
            , xAxis
                [ lineStyle
                    [ Style.stroke axisColor ]
                , Axis.tickDelta 2
                ]
            ]
    """
