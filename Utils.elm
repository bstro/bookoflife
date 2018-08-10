module Utils exposing (..)

import Date exposing (..)
import Task
import Time exposing (now)
import Types exposing (..)


getTime : Cmd Msg
getTime =
    Time.now
        |> Task.perform Tick


setDate : Cmd Msg
setDate =
    Date.now |> Task.perform SetDate


entryForDate : Int -> Int -> Entry -> Bool
entryForDate month day entry =
    if entry.month == month && entry.day == day then
        True
    else
        False


monthIntToString : Int -> String
monthIntToString m =
    case m of
        1 ->
            "January"

        2 ->
            "February"

        3 ->
            "March"

        4 ->
            "April"

        5 ->
            "May"

        6 ->
            "June"

        7 ->
            "July"

        8 ->
            "August"

        9 ->
            "September"

        10 ->
            "October"

        11 ->
            "November"

        12 ->
            "December"

        _ ->
            "Invalid month"


monthToInt : Date.Month -> Int
monthToInt m =
    case m of
        Jan ->
            1

        Feb ->
            2

        Mar ->
            3

        Apr ->
            4

        May ->
            5

        Jun ->
            6

        Jul ->
            7

        Aug ->
            8

        Sep ->
            9

        Oct ->
            10

        Nov ->
            11

        Dec ->
            12
