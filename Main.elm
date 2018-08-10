module Main exposing (..)

import Color exposing (..)
import Data exposing (..)
import Date exposing (Date, Day, Month)
import Element as El exposing (Element, column, el, empty, paragraph, row, text)
import Element.Attributes exposing (..)
import Html as H exposing (Html)
import Style exposing (StyleSheet, style)
import Style.Color as Color
import Style.Font as Font
import Task
import Time exposing (Time)
import Time.DateTime as DateTime exposing (DateTime)


type alias Entry =
    { month : Month
    , day : Day
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
    { now : Maybe Date
    , month : Maybe Month
    , day : Maybe Day
    }


type Msg
    = Tick Date


init : ( Model, Cmd Msg )
init =
    { now = Nothing
    , month = Nothing
    , day = Nothing
    }
        ! [ getTime ]


getTime : Cmd Msg
getTime =
    Date.now
        |> Task.perform Tick


main : Program Never Model Msg
main =
    H.program
        { init = init
        , update = update
        , view = view
        , subscriptions = subscriptions
        }


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.batch
        [ Time.every Time.second Tick
        ]


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        Tick now ->
            ( { model | now = Just now }
            , Cmd.none
            )


entryForDate : Month -> Day -> Entry -> Bool
entryForDate month day entry =
    if entry.month == month && entry.day == day then
        True
    else
        False


view : Model -> Html Msg
view { now, month, day } =
    let
        current_month =
            case month of
                Just x ->
                    x

                Nothing ->
                    case now of
                        Just n ->
                            Date.month n

                        Nothing ->
                            Date.Jan

        current_day =
            case day of
                Just x ->
                    x

                Nothing ->
                    case now of
                        Just n ->
                            Date.day n

                        Nothing ->
                            Date.Mon

        current_entry =
            List.filter (entryForDate current_month current_day) bookOfLife |> List.head

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
            { month = current_month |> toString
            , day = current_day |> toString
            }
    in
    El.viewport stylesheet <|
        column AppContainer
            [ width fill, height fill, verticalCenter, center ]
            [ column None
                [ maxWidth (px 831), height <| fill ]
                [ row None [ height <| fillPortion 1 ] []
                , row DateRow [ paddingBottom 20 ] [ paragraph DateText [] (List.map text [ rendered.month, " ", rendered.day ]) ]
                , row HrRow [] []
                , row TitleRow [ paddingTop 30 ] [ paragraph TitleText [] [ text current_title |> el None [] ] ]
                , row EntryRow
                    [ paddingTop 20 ]
                    [ paragraph EntryText
                        [ center ]
                        (List.map (\t -> t ++ " " |> text) paragraphs)
                    ]
                , "6" |> text |> el Fleuron [ paddingTop 25, paddingBottom 20 ]
                , "J. Krishnamurti" |> text |> el AuthorText [ paddingBottom 67 ]
                , row None [ height <| fillPortion 3 ] []
                ]
            ]


type Styles
    = None
    | AppContainer
    | DateText
    | HrRow
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
        [ style AppContainer
            [ Color.text <| Color.rgba 0 0 0 0.8
            , Style.prop "font-family" "Hoefler Text A, Hoefler Text B"
            ]
        , style DateRow []
        , style DateText
            [ Style.prop "font-size" "0.67rem"
            , Style.prop "font-family" "Gotham SSm A, Gotham SSm B"
            , Style.prop "color" "#BBB"
            , Font.uppercase
            , Font.letterSpacing 2
            ]
        , style HrRow
            [ Style.prop "border-top" "1px solid #DDD"
            ]
        , style TitleRow [ Style.prop "line-height" "2.667rem" ]
        , style TitleText
            [ Style.prop "font-size" "2rem"
            , Color.text <| Color.rgba 0 0 0 0.8
            , Font.weight 400
            ]
        , style EntryRow []
        , style EntryText
            [ Style.prop "font-size" "1.1rem"
            , Style.prop "line-height" "1.67rem"
            , Font.weight 400
            ]
        , style Fleuron
            [ Style.prop "font-family" "Hoefler Text Fleur A, Hoefler Text Fleur B"
            , Style.prop "font-size" "1.75rem"
            , Style.prop "user-select" "none"
            , Style.prop "pointer-events" "none"
            ]
        , style AuthorText
            [ Font.italic
            , Style.prop "font-size" "1rem"
            , Style.prop "line-height" "2rem"
            ]
        ]
