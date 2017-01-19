module Internal.View exposing (Config, ViewOption(..), toStyleConfig, useView)

{- View -}

import Svg


type ViewOption a c msg
    = FromStyle (List (c -> c))
    | FromStyleDynamic (a -> List (c -> c))
    | FromCustom (a -> Svg.Svg msg)
    | FromConfig c


type alias Config a c msg =
    { view : ViewOption a c msg
    , defaultStyles : c
    , defaultView : c -> a -> Svg.Svg msg
    }


toStyleConfig : Config a c msg -> List (c -> c) -> c
toStyleConfig config styles =
    List.foldl (<|) config.defaultStyles styles


useView : Config a c msg -> a -> Svg.Svg msg
useView config value =
    case config.view of
        FromStyle styleAttributes ->
            config.defaultView
                (toStyleConfig config styleAttributes)
                value

        FromStyleDynamic toStyleAttributes ->
            config.defaultView
                (toStyleAttributes value |> toStyleConfig config)
                value

        FromCustom view ->
            view value

        FromConfig styleConfig ->
            config.defaultView styleConfig value
