module PlotGrid exposing (plotExample)

import Svg
import Plot exposing (..)
import Plot.Attributes as Attributes
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
            [ Grid.lines
                [ Attributes.stroke axisColorLight ]
            ]
        , horizontalGrid
            [ Grid.lines
                [ Attributes.stroke axisColorLight ]
            , Grid.values [ 4, 8, 12 ]
            ]
        , xAxis
            [ Axis.line [ Attributes.stroke axisColor ]
            , Axis.tickDelta 0.5
            ]
        , line
            [ Attributes.stroke pinkStroke
            , Attributes.strokeWidth 3
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
                    [ Attributes.stroke axisColorLight ]
                ]
            , horizontalGrid
                [ Grid.lines
                    [ Attributes.stroke axisColorLight ]
                , Grid.values [ 4, 8, 12 ]
                ]
            , xAxis
                [ Axis.line [ Attributes.stroke axisColor ]
                , Axis.tickDelta 0.5
                ]
            , line
                [ Attributes.stroke blueStroke
                , Attributes.strokeWidth 2
                ]
                data
            ]
    """
