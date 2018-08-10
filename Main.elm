module Main exposing (..)

import Data exposing (..)
import Date exposing (Date, Day, Month)
import Element as El exposing (Element, column, el, empty, html, paragraph, row, text)
import Element.Attributes exposing (..)
import Html as H exposing (Html)
import Styles exposing (..)
import Task
import Time exposing (Time)
import Types exposing (..)
import Utils exposing (..)


init : ( Model, Cmd Msg )
init =
    { date = Nothing
    , month = Nothing
    , day = Nothing
    }
        ! [ getTime ]


getTime : Cmd Msg
getTime =
    Time.now
        |> Task.perform Tick


setDate : Cmd Msg
setDate =
    Date.now |> Task.perform SetDate


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
        Tick time ->
            model ! [ setDate ]

        SetDate date ->
            { model | date = Just date } ! []


view : Model -> Html Msg
view { date, month, day } =
    let
        current_month =
            case month of
                Just x ->
                    x

                Nothing ->
                    case date of
                        Just d ->
                            monthToInt <| Date.month d

                        Nothing ->
                            1

        current_day =
            case day of
                Just x ->
                    x

                Nothing ->
                    case date of
                        Just d ->
                            Date.day d

                        Nothing ->
                            1

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
