module PlotBars exposing (plotExample)

import Svg
import Plot exposing (..)
import Plot.Bars as Bars
import Plot.Axis as Axis
import Plot.Attributes as Attributes exposing (..)
import Plot.Label as Label
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
    "Bars"


id : String
id =
    "PlotBars"


view : Svg.Svg a
view =
    plot
        [ size Common.plotSize
        , margin ( 10, 20, 40, 30 )
        , padding ( 0, 20 )
        ]
        [ bars
            [ maxBarWidth 30
            , stackByY
            , label
                [ format (FormatFromList [ "A", "B", "C" ])
                , viewStatic
                    [ displace ( 0, 13 )
                    , fontSize 10
                    ]
                ]
            ]
            [ [ fill Common.blueFill ]
            , [ fill Common.skinFill ]
            , [ fill Common.pinkFill ]
            ]
            (Bars.toBarData
                { yValues = .values
                , xValue = Nothing
                }
                [ { values = [ 40, 30, 20 ] }
                , { values = [ 20, 30, 40 ] }
                , { values = [ 40, 20, 10 ] }
                , { values = [ 40, 50, 20 ] }
                ]
            )
        , xAxis
            [ Attributes.lineStyle [ Attributes.stroke Common.axisColor ]
            , tick [ values (ValuesFromDelta 1) ]
            ]
        ]


code : String
code =
    """
    view : Svg.Svg a
    view =
        plot
            [ size Common.plotSize
            , margin ( 10, 20, 40, 30 )
            , padding ( 0, 20 )
            ]
            [ bars
                [ maxBarWidth 30
                , stackByY
                , label
                    [ formatFromList [ "A", "B", "C" ]
                    , view
                        [ displace ( 0, 13 )
                        , fontSize 10
                        ]
                    ]
                ]
                [ [ fill Common.blueFill ]
                , [ fill Common.skinFill ]
                , [ fill Common.pinkFill ]
                ]
                (toBarData
                    { yValues = .values
                    , xValue = Nothing
                    }
                    [ { values = [ 1, 3, 2 ] }
                    , { values = [ 2, 1, 4 ] }
                    , { values = [ 4, 2, 1 ] }
                    , { values = [ 4, 5, 2 ] }
                    ]
                )
            , xAxis
                [ Attributes.lineStyle [ Attributes.stroke Common.axisColor ]
                , Axis.tickDelta 1
                ]
            ]
    """
