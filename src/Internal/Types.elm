module Internal.Types
    exposing
        ( Scale
        , Oriented
        , Edges
        , EdgesAny
        )


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


type alias Scale =
    { values : List Float
    , ticks : List Float
    , bounds : Edges
    , padding : Edges
    , offset : Edges
    , length : Float
    }
