module Simple exposing (..)

import Plot exposing (..)
import Svg
import Svg.Attributes



data1 : List ( Float, Float )
data1 =
    [ ( 0, 8 ), ( 1, 13 ), ( 2, 14 ), ( 3, 12 ), ( 4, 11 ), ( 5, 16 ), ( 6, 22 ), ( 7, 32 ), ( 8, 36 ) ]


data2 : List ( Float, Float )
data2 =
    [ ( 0, 3 ), ( 1, 2 ), ( 2, 8 ), ( 2.5, 15 ), ( 3, 18 ), ( 4, 17 ), ( 5, 16 ), ( 5.5, 15 ), ( 6.5, 14 ), ( 7.5, 13 ), ( 8, 12 ) ]


data3 : List ( Float, Float )
data3 =
    List.map (\(x, y) -> (x + 1, y * 2)) [ ( 0, 3 ), ( 1, 2 ), ( 2, 8 ), ( 2.5, 15 ), ( 3, 18 ), ( 4, 17 ), ( 5, 16 ), ( 5.5, 15 ), ( 6.5, 14 ), ( 7.5, 13 ), ( 8, 12 ) ]


isEven : Int -> Bool
isEven index =
    rem index 2 == 0


customTick : Int -> Float -> Svg.Svg a
customTick fromZero tick =
    Svg.line
        [ Svg.Attributes.style ("stroke: red")
        , Svg.Attributes.y2 (toString 5)
        ]
        []


plot1 =
    plot
        []
        [ line [ lineStyle [ ( "stroke", "mediumvioletred" ) ] ] data3
        , lineAnimated [ lineStyle [ ( "stroke", "mediumvioletred" ) ] ] data2 data1
        , yAxis []
        , xAxis []
        ]


main =
    plot1
