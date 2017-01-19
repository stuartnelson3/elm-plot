module PlotGrid exposing (plotExample)

import Svg
import Plot exposing (..)
import Plot.Attributes as Attributes exposing (..)
import Plot.Axis as Axis
import Plot.Grid as Grid
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
    "Grids"


id : String
id =
    "PlotGrid"


data : List ( Float, Float )
data =
    [ ( 0, 8 ), ( 1, 0 ), ( 2, 14 ) ]


view : Svg.Svg a
view =
    plot
        [ size plotSize
        , margin ( 10, 20, 40, 20 )
        ]
        [ verticalGrid
            [ lineStyle
                [ stroke axisColorLight ]
            ]
        , horizontalGrid
            [ lineStyle
                [ stroke axisColorLight ]
            , values (ValuesFromList [ 4, 8, 12 ])
            ]
        , xAxis
            [ lineStyle [ stroke axisColor ]
            , tick [ values (ValuesFromDelta 0.5) ]
            ]
        , line
            [ stroke pinkStroke
            , strokeWidth 3
            ]
            data
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
            [ verticalGrid
                [ Grid.lines
                    [ stroke axisColorLight ]
                ]
            , horizontalGrid
                [ Grid.lines
                    [ stroke axisColorLight ]
                , Grid.values [ 4, 8, 12 ]
                ]
            , xAxis
                [ lineStyle [ stroke axisColor ]
                , Axis.tickDelta 0.5
                ]
            , line
                [ stroke blueStroke
                , strokeWidth 2
                ]
                data
            ]
    """
