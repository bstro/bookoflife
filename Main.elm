module Main exposing (..)

import Color exposing (..)
import Element as El exposing (Element, column, el, empty, paragraph, row, text)
import Element.Attributes exposing (..)
import Html as H exposing (Html)
import Style exposing (StyleSheet, style)
import Style.Color as Color
import Style.Font as Font
import Time exposing (Time)
import Time.DateTime as DateTime exposing (DateTime)
import Time.TimeZones as TimeZones
import Time.ZonedDateTime as ZonedDateTime
import Window


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


type alias Model =
    { now : DateTime
    , timezone : String
    , month : Maybe Month
    , day : Maybe Int
    , data : BookOfLife
    , width : Int
    , height : Int
    }


type Msg
    = Tick Time
    | Resize Window.Size


type Month
    = January
    | February
    | March
    | April
    | May
    | June
    | July
    | August
    | September
    | October
    | November
    | December


type alias Day =
    Int


intToMonth : Int -> Month
intToMonth x =
    case x of
        1 ->
            January

        2 ->
            February

        3 ->
            March

        4 ->
            April

        5 ->
            May

        6 ->
            June

        7 ->
            July

        8 ->
            August

        9 ->
            September

        10 ->
            October

        11 ->
            November

        12 ->
            December

        _ ->
            Debug.crash "TODO"


monthToInt : Month -> Int
monthToInt x =
    case x of
        January ->
            1

        February ->
            2

        March ->
            3

        April ->
            4

        May ->
            5

        June ->
            6

        July ->
            7

        August ->
            8

        September ->
            9

        October ->
            10

        November ->
            11

        December ->
            12


monthToString : Month -> String
monthToString x =
    case x of
        January ->
            "January"

        February ->
            "February"

        March ->
            "March"

        April ->
            "April"

        May ->
            "May"

        June ->
            "June"

        July ->
            "July"

        August ->
            "August"

        September ->
            "September"

        October ->
            "October"

        November ->
            "November"

        December ->
            "December"


type alias Flags =
    { now : Time
    , timezone : String
    , data : BookOfLife
    , height : Int
    , width : Int
    }


init : Flags -> ( Model, Cmd Msg )
init { now, data, height, width, timezone } =
    { now = DateTime.fromTimestamp now
    , timezone = timezone
    , month = Nothing
    , day = Nothing
    , data = data
    , height = height
    , width = width
    }
        ! []


main : Program Flags Model Msg
main =
    H.programWithFlags
        { init = init
        , update = update
        , view = view
        , subscriptions = subscriptions
        }


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.batch
        [ Time.every Time.second Tick
        , Window.resizes Resize
        ]


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        Tick now ->
            ( { model | now = DateTime.fromTimestamp now }
            , Cmd.none
            )

        Resize { width, height } ->
            { model | width = width, height = height } ! []


entryForDate : Month -> Day -> Entry -> Bool
entryForDate month day entry =
    if entry.month == monthToInt month && entry.day == day then
        True
    else
        False


view : Model -> Html Msg
view { now, data, month, day, timezone } =
    let
        localTime =
            ZonedDateTime.fromDateTime (Maybe.withDefault (TimeZones.utc ()) (TimeZones.fromName timezone)) now

        current_month =
            case month of
                Just x ->
                    x

                Nothing ->
                    ZonedDateTime.month localTime |> intToMonth

        current_day =
            case day of
                Just x ->
                    x

                Nothing ->
                    ZonedDateTime.day localTime

        current_entry =
            List.filter (entryForDate current_month current_day) data.entries |> List.head

        current_title =
            case current_entry of
                Just entry ->
                    entry.title

                Nothing ->
                    "No entry for this date"

        paragraphs =
            case current_entry of
                Just entry ->
                    entry.content

                Nothing ->
                    []

        rendered =
            { month = current_month |> monthToString
            , day = current_day |> toString
            }
    in
    El.viewport stylesheet <|
        column AppContainer
            [ width fill, height fill, verticalCenter, center ]
            [ column None
                [ maxWidth (px 831), height <| fill ]
                [ row None [ height <| fillPortion 1 ] []
                , row DateRow [] [ paragraph DateText [] (List.map text [ rendered.month, " ", rendered.day ]) ]
                , row TitleRow [ paddingTop 10 ] [ paragraph TitleText [] [ text current_title |> el None [] ] ]
                , row EntryRow
                    [ paddingTop 20 ]
                    [ paragraph EntryText
                        [ center ]
                        (List.map (\t -> t ++ " " |> text) paragraphs)
                    ]
                , "6" |> text |> el Fleuron [ paddingTop 25, paddingBottom 20 ]
                , "Jiddu Krishnamurti" |> text |> el AuthorText [ paddingBottom 40 ]
                , row None [ height <| fillPortion 3 ] []
                ]
            ]


type Styles
    = None
    | AppContainer
    | DateText
    | TitleText
    | EntryText
    | DateRow
    | TitleRow
    | EntryRow
    | Fleuron
    | AuthorText


stylesheet : StyleSheet Styles v
stylesheet =
    Style.styleSheet
        [ style DateText
            [ Style.prop "font-size" "0.72rem"
            , Style.prop "padding-bottom" "1.6rem"
            , Style.prop "line-height" "1.6rem"
            , Style.prop "font-family" "Gotham SSm A, Gotham SSm B"
            , Style.prop "color" "#BBB"
            , Font.weight 700
            , Font.uppercase
            , Font.letterSpacing 2
            ]
        , style TitleText
            [ Style.prop "font-size" "2rem"
            , Style.prop "padding-bottom" "0.25rem"
            , Color.text <| Color.rgba 0 0 0 0.8
            , Font.weight 400
            ]
        , style EntryText
            [ Style.prop "font-size" "1.1rem"
            , Style.prop "line-height" "1.67rem"
            , Font.weight 400
            ]
        , style AppContainer
            [ Color.text <| Color.rgba 0 0 0 0.8
            , Style.prop "font-family" "Hoefler Text A, Hoefler Text B"
            ]
        , style Fleuron
            [ Style.prop "font-family" "Hoefler Text Fleur A, Hoefler Text Fleur B"
            , Style.prop "font-size" "1.75rem"
            , Style.prop "user-select" "none"
            , Style.prop "pointer-events" "none"
            ]
        , style DateRow []
        , style EntryRow []
        , style TitleRow [ Style.prop "line-height" "2.43rem" ]
        , style AuthorText
            [ Font.italic
            , Style.prop "font-size" "1rem"
            , Style.prop "line-height" "2rem"
            ]
        ]
