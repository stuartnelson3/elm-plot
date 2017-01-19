module Plot.Label
    exposing
        ( Attribute
        , StyleAttribute
        )

{-|
 Attributes for altering the view of your labels.

 Before you read any further, please note that when I speak of the label _index_,
 then I'm talking about how many labels that particular label is from the origin.

 Ok, now you can go on!

# Definition
@docs Attribute, StyleAttribute

-}

import Plot.Attributes exposing (..)


{-| -}
type alias Attribute c a msg =
    Label c a msg -> Label c a msg


{-| -}
type alias StyleAttribute msg =
    LabelStyle msg -> LabelStyle msg
