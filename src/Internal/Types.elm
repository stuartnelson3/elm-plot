module Internal.Types
    exposing
        ( Scale
        , Meta
        , Oriented
        , Edges
        , EdgesAny
        )

import Plot.Attributes exposing (..)


type alias Edges =
    { lower : Float
    , upper : Float
    }


type alias EdgesAny a =
    { lower : a
    , upper : a
    }


type alias Oriented a =
    { x : a
    , y : a
    }


type alias Meta =
    { scale : Oriented Scale
    , ticks : List Float
    , toSvgCoords : Point -> Point
    , fromSvgCoords : Point -> Point
    , oppositeTicks : List Float
    , oppositeToSvgCoords : Point -> Point
    , axisCrossings : List Float
    , oppositeAxisCrossings : List Float
    , getHintInfo : Float -> HintInfo
    , toNearestX : Float -> Maybe Float
    , id : String
    }


type alias Scale =
    { range : Float
    , lowest : Float
    , highest : Float
    , length : Float
    , offset : Edges
    }
