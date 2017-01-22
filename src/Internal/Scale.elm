module Internal.Scale exposing (..)

import Internal.Types exposing (..)
import Plot.Attributes exposing (..)


unzipPoints : List Point -> Oriented (List Value)
unzipPoints points =
    List.unzip points
        |> \( x, y ) -> Oriented x y


updateValues : List Point -> Oriented Scale -> Oriented Scale
updateValues points scales =
    unzipPoints points
        |> \values ->
            { x = updateScaleValues values.x scales.x
            , y = updateScaleValues values.y scales.y
            }


updateScaleValues : List Value -> Scale -> Scale
updateScaleValues values scale =
    { scale
        | values = scale.values ++ values
        , bounds = strechBounds values scale.bounds
    }


updateBoundsArea : Oriented Scale -> Oriented Scale
updateBoundsArea scales =
    { lower = 0, upper = 0 }
        |> updateScaleBounds scales.y
        |> Oriented scales.x


updateBoundsBars : List Point -> Oriented Scale -> Oriented Scale
updateBoundsBars points scales =
    List.unzip points
        |> Tuple.first
        |> toBarXEdges
        |> updateScaleBounds scales.x
        |> \scaleX -> Oriented scaleX scales.y


toBarXEdges : List Value -> Edges
toBarXEdges xValues =
    { lower = getLowest xValues - 0.5
    , upper = getHighest xValues + 0.5
    }


updateScaleBounds : Scale -> Edges -> Scale
updateScaleBounds scale bounds =
    { scale | bounds = strechBounds [ bounds.lower, bounds.upper ] scale.bounds }


strechBounds : List Value -> Edges -> Edges
strechBounds values bounds =
    { lower = min bounds.lower (getLowest values)
    , upper = max bounds.upper (getHighest values)
    }


updateTicks : Orientation -> Oriented Scale -> List Value -> Oriented Scale
updateTicks orientation scales ticks =
    case orientation of
        X ->
            Oriented (updateScaleTicks scales.x ticks) scales.y

        Y ->
            Oriented scales.x (updateScaleTicks scales.y ticks)


updateScaleTicks : Scale -> List Value -> Scale
updateScaleTicks scale ticks =
    { scale | ticks = ticks }


scaleValue : Scale -> Value -> Value
scaleValue ({ length, bounds, offset } as scale) v =
    (v * length / (getRange scale)) + offset.lower


unScaleValue : Scale -> Value -> Value
unScaleValue ({ length, bounds, offset } as scale) v =
    ((v - offset.lower) * (getRange scale) / length) + bounds.lower


fromSvgCoords : Scale -> Scale -> Point -> Point
fromSvgCoords xScale yScale ( x, y ) =
    ( unScaleValue xScale x
    , unScaleValue yScale (yScale.length - y)
    )


toSvgCoordsOriented : Orientation -> Plot -> Point -> Point
toSvgCoordsOriented orientation =
    case orientation of
        X ->
            toSvgCoords

        Y ->
            toSvgCoordsFlipped


toSvgCoords : Plot -> Point -> Point
toSvgCoords { scales } ( x, y ) =
    ( scaleValue scales.x (x - scales.x.bounds.lower)
    , scaleValue scales.y (scales.y.bounds.upper - y)
    )


toSvgCoordsFlipped : Plot -> Point -> Point
toSvgCoordsFlipped { scales } ( x, y ) =
    ( scaleValue scales.y (y - scales.y.bounds.lower)
    , scaleValue scales.x (scales.x.bounds.upper - x)
    )


getHighest : List Float -> Float
getHighest values =
    Maybe.withDefault 10 (List.maximum values)


getLowest : List Float -> Float
getLowest values =
    Maybe.withDefault 0 (List.minimum values)


getRange : Scale -> Float
getRange { bounds } =
    if (bounds.upper - bounds.lower) > 0 then
        bounds.upper - bounds.lower
    else
        1


foldBounds : Maybe Edges -> Edges -> Edges
foldBounds oldBounds newBounds =
    case oldBounds of
        Just bounds ->
            { lower = min bounds.lower newBounds.lower
            , upper = max bounds.upper newBounds.upper
            }

        Nothing ->
            newBounds


getEdgesX : List Point -> ( Float, Float )
getEdgesX points =
    getEdges <| List.map Tuple.first points


getEdgesY : List Point -> ( Float, Float )
getEdgesY points =
    getEdges <| List.map Tuple.second points


getEdges : List Float -> ( Float, Float )
getEdges range =
    ( getLowest range, getHighest range )


pixelsToValue : Float -> Float -> Float -> Float
pixelsToValue length range pixels =
    range * pixels / length


ceilToNearest : Float -> Float -> Float
ceilToNearest precision value =
    toFloat (ceiling (value / precision)) * precision


getDifference : Float -> Float -> Float
getDifference a b =
    abs <| a - b


getClosest : Float -> Float -> Maybe Float -> Maybe Float
getClosest value candidate closest =
    case closest of
        Just closeValue ->
            if getDifference value candidate < getDifference value closeValue then
                Just candidate
            else
                Just closeValue

        Nothing ->
            Just candidate


toNearestX : Plot -> Float -> Maybe Float
toNearestX plot value =
    List.foldr (getClosest value) Nothing plot.scales.x.values


flipOriented : Oriented a -> Oriented a
flipOriented { x, y } =
    { x = y, y = x }


foldOriented : (a -> a) -> Orientation -> Oriented a -> Oriented a
foldOriented fold orientation old =
    case orientation of
        X ->
            { old | x = fold old.x }

        Y ->
            { old | y = fold old.y }
