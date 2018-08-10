module Types exposing (..)

import Date exposing (Date)
import Time exposing (Time)


type alias Entry =
    { month : Int
    , day : Int
    , title : String
    , content : List String
    }


type alias BookOfLife =
    { entries : List Entry
    , author : String
    , edition : Int
    , docsite : String
    }


type alias Day =
    Int


type alias Month =
    Int


type alias Model =
    ( Month, Day )


type Msg
    = Tick Time
    | SetDate Date
