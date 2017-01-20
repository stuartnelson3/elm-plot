module Plot.Attributes
    exposing
        ( Attribute
        , stroke
        , strokeWidth
        , fill
        , opacity
        , classes
        , displace
        , lineStyle
        , InterpolationOption(..)
        , interpolation
        , maxBarWidthPer
        , label
        , radius
        , tick
        , FormatOption(..)
        , format
        , ValuesOption(..)
        , values
        , AnchorOption(..)
        , anchor
        , PositionOption(..)
        , position
        , clearIntersections
        , defaultLineStyle
        , Tick
        , TickStyle
        , defaultTickStyle
        , defaultTickConfig
        , LineStyle
        , Label
        , LabelStyle
        , defaultLabelStyle
        , AreaStyle
        , defaultAreaStyle
        , Grid
        , defaultGridConfig
        , Group
        , Bars
        , BarsStyle
        , BarLabelInfo
        , Axis
        , defaultAxisConfig
        , AxisLabelInfo
        , MaxWidth(..)
        , defaultBarsConfig
        , defaultBarsStyle
        , length
        , viewStatic
        , viewDynamic
        , viewCustom
        , Scatter
        , defaultScatterConfig
        , stackByY
        , maxBarWidth
        , fontSize
        , Hint
        , defaultHintConfig
        )

{-| Attributes to alter styling.
-}

import Svg
import Html
import Plot.Types exposing (..)
import Internal.Types exposing (..)
import Internal.Types exposing (Orientation(..))
import Internal.View as View


{-| -}
type alias Attribute a =
    a -> a


{-| Set the stroke color.
-}
stroke : String -> Attribute { c | stroke : String }
stroke stroke config =
    { config | stroke = stroke }


{-| Set the stroke width (in pixels).
-}
strokeWidth : Int -> Attribute { c | strokeWidth : Int }
strokeWidth strokeWidth config =
    { config | strokeWidth = strokeWidth }


{-| Set the fill color.
-}
fill : String -> Attribute { c | fill : String }
fill fill config =
    { config | fill = fill }


{-| Set the opacity.
-}
opacity : Float -> Attribute { c | opacity : Float }
opacity opacity config =
    { config | opacity = opacity }


{-| Displace an element.
-}
displace : ( Int, Int ) -> Attribute { c | displace : ( Int, Int ) }
displace displace config =
    { config | displace = displace }


{-| Set the font size (in pixels).
-}
fontSize : Int -> Attribute { c | style : Style }
fontSize fontSize config =
    { config | style = ( "font-size", toString fontSize ++ "px" ) :: config.style }


type InterpolationOption
    = Bezier
    | NoInterpolation


{-| Smooth line with [Bézier curves] (https://en.wikipedia.org/wiki/B%C3%A9zier_curve).
-}
interpolation : InterpolationOption -> Attribute { c | interpolation : InterpolationOption }
interpolation interpolation config =
    { config | interpolation = interpolation }


{-| Add your own attributes. For events, see [this example](https://github.com/terezka/elm-plot/blob/master/examples/Interactive.elm)
-}
customAttrs : List (Svg.Attribute msg) -> Attribute { c | customAttrs : List (Svg.Attribute msg) }
customAttrs attrs config =
    { config | customAttrs = attrs }


{-| Adds classes.
-}
classes : List String -> Attribute { c | classes : List String }
classes classes config =
    { config | classes = classes }


{-| Adds classes.
-}
length : Int -> Attribute { c | length : Int }
length length config =
    { config | length = length }


{-| Adds classes.
-}
width : Int -> Attribute { c | width : Int }
width width config =
    { config | width = width }


{-| Set the radius of your points.
-}
radius : Int -> Attribute { c | radius : Int }
radius radius config =
    { config | radius = radius }


{-| Set HTML view. (Like for the hint)
-}
viewHtml : (a -> Html.Html msg) -> Attribute { c | view : a -> Html.Html msg }
viewHtml view config =
    { config | view = view }



-- Highlevel attributes


{-| The available info provided to your hint view.
-}
type alias HintInfo =
    { xValue : Float
    , yValues : List (Maybe (List Value))
    , isLeftSide : Bool
    }


type alias Hint msg =
    { view : Maybe (HintInfo -> Html.Html msg)
    , lineStyle : LineStyle msg
    }


defaultHintConfig : Hint msg
defaultHintConfig =
    { view = Nothing
    , lineStyle = defaultLineStyle
    }


type alias Scatter a =
    { radius : Int
    , fill : String
    , stroke : String
    , customAttrs : List (Svg.Attribute a)
    , radius : Int
    }


defaultScatterConfig : Scatter a
defaultScatterConfig =
    { stroke = "black"
    , fill = "transparent"
    , customAttrs = []
    , radius = 5
    }


type alias AxisLabelInfo =
    { value : Float
    , index : Int
    , orientation : Orientation
    , text : String
    }


type alias Axis msg =
    { tick : Tick AxisLabelInfo msg
    , label : Label { values : ValuesOption } AxisLabelInfo msg
    , lineStyle : LineStyle msg
    , orientation : Orientation
    , anchor : AnchorOption
    , clearIntersections : Bool
    , position : PositionOption
    , classes : List String
    }


defaultAxisConfig : Axis msg
defaultAxisConfig =
    { tick = defaultTickConfig
    , label =
        { view = View.FromConfig defaultLabelStyle
        , format = FormatFromFunc (.value >> toString)
        , values = ValuesAuto
        }
    , lineStyle = defaultLineStyle
    , orientation = X
    , clearIntersections = False
    , anchor = AnchorOuter
    , position = PositionAtZero
    , classes = []
    }


type alias BarLabelInfo =
    { index : Int
    , xValue : Value
    , yValue : Value
    , text : String
    }


type alias Group =
    { xValue : Value
    , yValues : List Value
    }


type alias BarsStyle msg =
    { fill : String
    , customAttrs : List (Svg.Attribute msg)
    }


type alias Bars msg =
    { stackBy : Orientation
    , label : Label {} BarLabelInfo msg
    , maxWidth : MaxWidth
    }


defaultBarsConfig : Bars msg
defaultBarsConfig =
    { stackBy = X
    , label =
        { view = View.FromConfig defaultLabelStyle
        , format = FormatFromFunc (always "")
        }
    , maxWidth = Percentage 100
    }


defaultBarsStyle : BarsStyle msg
defaultBarsStyle =
    { fill = "grey"
    , customAttrs = []
    }


type alias AreaStyle a =
    { stroke : String
    , strokeWidth : Int
    , fill : String
    , opacity : Float
    , interpolation : InterpolationOption
    , customAttrs : List (Svg.Attribute a)
    }


defaultAreaStyle : AreaStyle a
defaultAreaStyle =
    { stroke = "black"
    , strokeWidth = 1
    , fill = "grey"
    , opacity = 1
    , interpolation = NoInterpolation
    , customAttrs = []
    }


type alias Grid a =
    { values : ValuesOption
    , lineStyle : LineStyle a
    , classes : List String
    , orientation : Orientation
    , customAttrs : List (Svg.Attribute a)
    }


defaultGridConfig : Grid a
defaultGridConfig =
    { values = ValuesAuto
    , lineStyle = defaultLineStyle
    , classes = []
    , orientation = X
    , customAttrs = []
    }


type alias LineStyle a =
    { stroke : String
    , strokeWidth : Int
    , opacity : Float
    , interpolation : InterpolationOption
    , customAttrs : List (Svg.Attribute a)
    }


defaultLineStyle : LineStyle a
defaultLineStyle =
    { stroke = "black"
    , strokeWidth = 1
    , opacity = 1
    , interpolation = NoInterpolation
    , customAttrs = []
    }


{-| Configures a line.
-}
lineStyle : List (Attribute (LineStyle msg)) -> Attribute { a | lineStyle : LineStyle msg }
lineStyle attrs config =
    { config | lineStyle = List.foldr (<|) defaultLineStyle attrs }



--- Label


type alias Label c a msg =
    { c | view : View.ViewOption a (LabelStyle msg) msg, format : FormatOption a }


type alias LabelStyle msg =
    { displace : ( Int, Int )
    , style : Style
    , opacity : Int
    , fill : String
    , strokeWidth : Int
    , stroke : String
    , classes : List String
    , customAttrs : List (Svg.Attribute msg)
    }


defaultLabelStyle : LabelStyle msg
defaultLabelStyle =
    { displace = ( 0, 0 )
    , style = []
    , opacity = 1
    , strokeWidth = 1
    , fill = "grey"
    , stroke = "black"
    , classes = []
    , customAttrs = []
    }


{-| By providing this attribute with a list of [label attributes](http://package.elm-lang.org/packages/terezka/elm-plot/latest/Plot-Label),
 you may alter the values and ticks displayed as your axis' labels.
-}
label : List (Attribute (Label c v msg)) -> Attribute { a | label : Label c v msg }
label attributes config =
    { config | label = List.foldl (<|) config.label attributes }



-- Ticks


type alias Tick a msg =
    { view : View.ViewOption a (TickStyle msg) msg
    , values : ValuesOption
    }


type alias TickStyle msg =
    { length : Int
    , stroke : String
    , width : Int
    , style : Style
    , classes : List String
    , customAttrs : List (Svg.Attribute msg)
    }


defaultTickConfig : Tick a msg
defaultTickConfig =
    { view = View.FromConfig defaultTickStyle
    , values = ValuesAuto
    }


defaultTickStyle : TickStyle msg
defaultTickStyle =
    { length = 7
    , stroke = "black"
    , width = 1
    , style = []
    , classes = []
    , customAttrs = []
    }


{-| By providing this attribute with a list of [tick attributes](http://package.elm-lang.org/packages/terezka/elm-plot/latest/Plot-Tick),
 you may alter the values and ticks displayed as your axis' ticks.
-}
tick : List (Attribute (Tick v msg)) -> Attribute { a | tick : Tick v msg }
tick attributes config =
    { config | tick = List.foldl (<|) defaultTickConfig attributes }



-- View


{-| Configure the default view with style attributes.
-}
viewStatic : List (Attribute c) -> Attribute { b | view : View.ViewOption a c msg }
viewStatic styles config =
    { config | view = View.FromStyle styles }


{-| Configure the default view with style attributes based on the view value.
-}
viewDynamic : (a -> List (Attribute c)) -> Attribute { b | view : View.ViewOption a c msg }
viewDynamic toStyle config =
    { config | view = View.FromStyleDynamic toStyle }


{-| Use a custom view based on the view value.
-}
viewCustom : (a -> Svg.Svg msg) -> Attribute { b | view : View.ViewOption a c msg }
viewCustom view config =
    { config | view = View.FromCustom view }



-- Formatting


type FormatOption v
    = FormatFromList (List String)
    | FormatFromFunc (v -> String)


format : FormatOption v -> Attribute { a | format : FormatOption v }
format formatter config =
    { config | format = formatter }



-- Axis attributes


type AnchorOption
    = AnchorInner
    | AnchorOuter


{-| Anchor the ticks/labels on the inside of the plot. By default they are anchored on the outside.
-}
anchor : AnchorOption -> Attribute { a | anchor : AnchorOption }
anchor anchor config =
    { config | anchor = anchor }


type PositionOption
    = PositionLowest
    | PositionHighest
    | PositionAtZero


{-| Position this axis to the lowest value on the opposite axis. E.g. if
 this attribute is added on an y-axis, it will be positioned to the left.
-}
position : PositionOption -> Attribute { a | position : PositionOption }
position position config =
    { config | position = position }


{-| Remove tick and value where the axis crosses the opposite axis.
-}
clearIntersections : Attribute { a | clearIntersections : Bool }
clearIntersections config =
    { config | clearIntersections = True }


{-| Set a fixed max width (in pixels) on your bars.
-}
maxBarWidth : Int -> Attribute { a | maxWidth : MaxWidth }
maxBarWidth max config =
    { config | maxWidth = Fixed max }


type MaxWidth
    = Fixed Int
    | Percentage Int


{-| Set a relative max width (in percentage) your bars.
-}
maxBarWidthPer : Int -> Attribute { a | maxWidth : MaxWidth }
maxBarWidthPer max config =
    { config | maxWidth = Percentage max }


{-| By default your bars are stacked by x. If you want to stack them y, add this attribute.
-}
stackByY : Attribute { a | stackBy : Orientation }
stackByY config =
    { config | stackBy = Y }


type ValuesOption
    = ValuesFromList (List Value)
    | ValuesFromDelta Value
    | ValuesAuto


{-| Specify at what values will be added a tick.

    myXAxis : Plot.Element msg
    myXAxis =
        Plot.xAxis
            [ Axis.tickValues [ 0, 1, 2, 4, 8 ] ]

 **Note:** If you add another attribute altering the values like `tickDelta` _after_ this attribute,
 then this attribute will have no effect.
-}
values : ValuesOption -> Attribute { a | values : ValuesOption }
values values config =
    { config | values = values }
