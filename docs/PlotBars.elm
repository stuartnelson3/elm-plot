module PlotBars exposing (plotExample)

import Svg
import Svg.Attributes exposing (..)
import Svg.Plot exposing (..)
import Common exposing (..)


plotExample : PlotExample msg
plotExample =
    { title = title
    , code = code
    , view = view
    , id = id
    }


title : String
title =
    "Bars"


id : String
id =
    "PlotBars"


plotConfig : PlotConfig msg
plotConfig =
    toPlotConfigFancy
        { attributes = []
        , id = id
        , margin =
            { top = 20
            , left = 30
            , right = 30
            , bottom = 90
            }
        , proportions = { x = 600, y = 400 }
        , toDomainLowest = \l -> l - 50
        , toDomainHighest = \h -> h + 50
        , toRangeLowest = \l -> l - 50
        , toRangeHighest = \h -> h + 50
        }


xLabelView : String -> Svg.Svg msg
xLabelView =
    label
        [ fill axisColor
        , style "text-anchor: middle;"
        , displace ( 0, 25 )
        ]


barsConfig : BarsConfig msg
barsConfig =
    toBarsConfig
        { stackBy = Y
        , styles = [ [ fill pinkFill ], [ fill blueFill ], [ fill skinFill ] ]
        , labelView =
            .yValue
                >> toString
                >> label
                    [ stroke "#fff"
                    , fill "#fff"
                    , style "text-anchor: middle; font-size: 10px;"
                    , displace ( 0, 15 )
                    ]
        , maxWidth = Fixed 30
        }


view : Svg.Svg a
view =
    plot plotConfig
        [ pieSerie
            (toPieConfig
              { styles =
                  [ [ stroke pinkStroke, fill "transparent", strokeWidth "10" ]
                  , [ stroke blueStroke, fill "transparent", strokeWidth "10" ]
                  , [ stroke skinStroke, fill "transparent", strokeWidth "10" ]
                  ]
              , beginAt = 0
              , radius = 100
              , attributes = [ ]
              })
            [ 10, 30, 40 ]
        , xAxis atZero [ line [ stroke axisColor ], labels (toString >> label []) (fromDelta 0 50) ]
        , yAxis atZero [ line [ stroke axisColor ], labels (toString >> label []) (fromDelta 0 50) ]
        ]


code : String
code =
    """

plotConfig : PlotConfig msg
plotConfig =
    toPlotConfigCustom
        { attributes = []
        , id = id
        , margin =
            { top = 20
            , left = 30
            , right = 30
            , bottom = 90
            }
        , proportions =
            { x = 600, y = 400 }
        , toDomainLowest = identity
        , toDomainHighest = identity
        , toRangeLowest = \\l -> l - 0.5
        , toRangeHighest = \\h -> h + 0.5
        }


barsConfig : BarsConfig msg
barsConfig =
    toBarsConfig
        { stackBy = X
        , maxWidth = Fixed 30
        , barConfigs =
            [ bar1Config
            , bar2Config
            , bar3Config
            ]
        }


bar1Config : BarConfig msg
bar1Config =
    toBarConfig
        { attributes = [ fill pinkStroke ]
        , labelConfig = barLabelConfig
        }


bar2Config : BarConfig msg
bar2Config =
    toBarConfig
        { attributes = [ fill blueFill ]
        , labelConfig = barLabelConfig
        }


bar3Config : BarConfig msg
bar3Config =
    toBarConfig
        { attributes = [ fill skinFill ]
        , labelConfig = barLabelConfig
        }


barLabelConfig : LabelConfig BarValueInfo a msg
barLabelConfig =
    toBarLabelConfig
        { attributes =
            [ stroke "#fff"
            , fill "#fff"
            , style "text-anchor: middle; font-size: 10px;"
            , displace ( 0, 15 )
            ]
        , format = \\info -> toString info.yValue
        }


xLabelStrings : Array.Array String
xLabelStrings =
    Array.fromList [ "Autumn", "Winter", "Spring", "Summer" ]


axisLabelConfig : LabelConfig (ValueInfo { index : Int }) AxisMeta msg
axisLabelConfig =
    toAxisLabelConfig
        { attributes =
            [ fill axisColor
            , style "text-anchor: middle;"
            , transform "translate(10, 44) rotate(45) "
            ]
        , format = \\info -> Array.get info.index xLabelStrings |> Maybe.withDefault ""
        }


axisLabelY1Config : LabelConfig (ValueInfo a) AxisMeta msg
axisLabelY1Config =
    toAxisLabelConfig
        { attributes =
            [ fill axisColor
            , style "text-anchor: start;"
            , displace ( 10, 5 )
            ]
        , format = toString << .value
        }


axisLabelY2Config : LabelConfig (ValueInfo a) AxisMeta msg
axisLabelY2Config =
    toAxisLabelConfig
        { attributes =
            [ fill axisColor
            , style "text-anchor: end;"
            , displace ( -10, 5 )
            ]
        , format = toString << (*) 200 << .value
        }


axisLineConfig : AxisLineConfig msg
axisLineConfig =
    toAxisLineConfig
        { attributes =
            [ stroke axisColor
            ]
        }


tickConfig : TickConfig msg
tickConfig =
    toTickConfig
        { attributes =
            [ length 10
            , stroke axisColor
            ]
        }


view : Svg.Svg a
view =
    plot plotConfig
        [ barsSerie
            barsConfig
            (toGroups
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
            [ axisLine axisLineConfig
            , labels axisLabelConfig (\\_ -> List.indexedMap (\\i v -> { index = i, value = v }) [ 1, 2, 3, 4 ])
            , ticks tickConfig (fromDelta 1)
            ]
        , yAxisAt (\\l h -> l)
            [ axisLine axisLineConfig
            , labels axisLabelY1Config (fromCount 5 >> List.filter (\\v -> v.value /= 0))
            , ticks tickConfig (fromCount 5)
            , positionBy
                (fromAxis (\\p l h -> ( h / 2, p )))
                [ label
                    [ transform "translate(-10, 0) rotate(-90)"
                    , style "text-anchor: middle"
                    , fill axisColorLight
                    ]
                    "Units sold"
                ]
            ]
        , yAxisAt (\\l h -> h)
            [ axisLine axisLineConfig
            , labels axisLabelY2Config (fromCount 5 >> List.filter (\\v -> v.value /= 0))
            , ticks tickConfig (fromCount 5)
            , positionBy
                (fromAxis (\\p l h -> ( h / 2, p )))
                [ label
                    [ transform "translate(10, 0) rotate(90)"
                    , style "text-anchor: middle"
                    , fill axisColorLight
                    ]
                    "Ca$h for big big company"
                ]
            ]
        ]
    """
