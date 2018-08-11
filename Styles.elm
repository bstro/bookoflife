module Styles exposing (..)

import Color exposing (..)
import Style exposing (StyleSheet, style)
import Style.Color as Color
import Style.Font as Font


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
            , Style.prop "font-family" "Hoefler Text A, Hoefler Text B, Iowan Old Style, Georgia, Times, Times New Roman"
            ]
        , style DateRow []
        , style DateText
            [ Style.prop "font-size" "0.67rem"
            , Style.prop "font-family" "Gotham SSm A, Gotham SSm B, Avenir Next, Helvetica Neue, Helvetica, Arial"
            , Style.prop "font-weight" "700"
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
            [ Style.prop "font-family" "Hoefler Text Fleur A, Hoefler Text Fleur B, Wingdings, Webdings"
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
