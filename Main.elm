module Main exposing (..)

import Data exposing (..)
import Date exposing (Date)
import Element as El exposing (Element, column, el, empty, html, paragraph, row, text)
import Element.Attributes exposing (..)
import Html as H exposing (Html)
import Styles exposing (..)
import Task
import Time exposing (Time)
import Types exposing (..)
import Utils exposing (..)


type alias Flags =
    { month : Int, day : Int }


main : Program Flags Model Msg
main =
    H.programWithFlags
        { init = init
        , subscriptions = subscriptions
        , update = update
        , view = view
        }


init : Flags -> ( Model, Cmd Msg )
init { month, day } =
    ( day, month ) ! [ getTime ]


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
            ( monthToInt <| Date.month date
            , Date.day date
            )
                ! []


view : Model -> Html Msg
view ( month, day ) =
    let
        current_entry =
            List.head <| List.filter (entryForDate month day) bookOfLife

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
            { month = monthIntToString month
            , day = toString day
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
