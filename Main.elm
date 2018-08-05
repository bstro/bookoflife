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
    , data : BookOfLife
    , height : Int
    , width : Int
    }


init : Flags -> ( Model, Cmd Msg )
init { now, data, height, width } =
    { now = DateTime.fromTimestamp now
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
view { now, data, month, day } =
    let
        current_month =
            case month of
                Just x ->
                    x

                Nothing ->
                    DateTime.month now |> intToMonth

        current_day =
            case day of
                Just x ->
                    x

                Nothing ->
                    DateTime.day now

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
            [ padding 50, width fill, height fill, verticalCenter, center ]
            [ column None
                [ maxWidth (px 1024) ]
                [ row DateRow [] [ paragraph DateText [] (List.map text [ rendered.month, " ", rendered.day ]) ]
                , row TitleRow [ paddingTop 15 ] [ text current_title |> el TitleText [] ]
                , row EntryRow
                    [ paddingTop 15 ]
                    [ paragraph EntryText
                        [ center ]
                        (List.map (\t -> t ++ " " |> text) paragraphs)
                    ]
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



-- [ Style.prop "font-family" "Archer SSm A, Archer SSm B"
-- [ Style.prop "font-family" "Hoefler Text A, Hoefler Text B"
-- [ Style.prop "font-family" "Gotham SSm A, Gotham SSm B"
-- [ Style.prop "font-family" "Operator Mono A, Operator Mono B"


stylesheet : StyleSheet Styles v
stylesheet =
    Style.styleSheet
        [ style DateText
            [ Style.prop "font-family" "Gotham SSm A, Gotham SSm B"
            , Style.prop "font-size" "0.6rem"
            , Font.weight 800
            , Font.uppercase
            , Font.letterSpacing 1

            -- , Font.weight 500
            ]
        , style TitleText
            [ Style.prop "font-family" "Hoefler Text A, Hoefler Text B"
            , Style.prop "font-size" "1.67rem"
            , Color.text <| Color.rgba 0 0 0 0.8
            , Font.weight 800
            ]
        , style EntryText
            [ Style.prop "font-family" "Hoefler Text A, Hoefler Text B"
            , Style.prop "font-size" "1.25rem"
            , Style.prop "line-height" "1.83rem"
            , Font.weight 400
            ]
        , style AppContainer
            [ Color.text <| Color.rgba 0 0 0 0.8

            -- , Style.prop "font-size" "calc(16px + 6 * ((100vw - 320px) / 1024))"
            ]
        , style DateRow []
        , style TitleRow []
        , style EntryRow []
        ]
