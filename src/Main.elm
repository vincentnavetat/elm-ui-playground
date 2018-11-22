port module Main exposing (Model, Msg(..), add1, init, main, toJs, update, view)

import Browser
import Browser.Navigation as Nav
import Element exposing (..)
import Element.Background as Background
import Element.Border as Border
import Element.Font as Font
import Html exposing (Html)
import Http exposing (Error(..))
import Json.Decode as Decode



-- ---------------------------
-- PORTS
-- ---------------------------


port toJs : String -> Cmd msg



-- ---------------------------
-- MODEL
-- ---------------------------


type alias Model =
    { counter : Int
    , serverMessage : String
    }


init : Int -> ( Model, Cmd Msg )
init flags =
    ( { counter = flags, serverMessage = "" }, Cmd.none )



-- ---------------------------
-- UPDATE
-- ---------------------------


type Msg
    = Inc
    | Set Int
    | TestServer
    | OnServerResponse (Result Http.Error String)


update : Msg -> Model -> ( Model, Cmd Msg )
update message model =
    case message of
        Inc ->
            ( add1 model, toJs "Hello Js" )

        Set m ->
            ( { model | counter = m }, toJs "Hello Js" )

        TestServer ->
            ( model
            , Http.get "/test" (Decode.field "result" Decode.string)
                |> Http.send OnServerResponse
            )

        OnServerResponse res ->
            case res of
                Ok r ->
                    ( { model | serverMessage = r }, Cmd.none )

                Err err ->
                    ( { model | serverMessage = "Error: " ++ httpErrorToString err }, Cmd.none )


httpErrorToString : Http.Error -> String
httpErrorToString err =
    case err of
        BadUrl _ ->
            "BadUrl"

        Timeout ->
            "Timeout"

        NetworkError ->
            "NetworkError"

        BadStatus _ ->
            "BadStatus"

        BadPayload _ _ ->
            "BadPayload"


{-| increments the counter

    add1 5 --> 6

-}
add1 : Model -> Model
add1 model =
    { model | counter = model.counter + 1 }



-- ---------------------------
-- VIEW
-- ---------------------------


colorBorder : Color
colorBorder =
    rgba255 33 34 36 0.15


view : Model -> Html Msg
view model =
    Element.layout []
        modalOverlay


modalOverlay : Element msg
modalOverlay =
    row
        [ width fill
        , height fill
        , Background.color (rgba255 33 34 36 0.65)
        , clip
        ]
        [ modal
        ]


modal : Element msg
modal =
    column
        [ Background.color (rgb255 255 255 255)
        , width (px 640)
        , centerX
        , centerY
        , Border.rounded 3
        , height
            (fill
                |> maximum 500
            )
        ]
        [ modalHeader
        , modalBody
        , modalFooter
        ]


modalHeader : Element msg
modalHeader =
    el
        [ paddingXY 24 0
        , height (px 64)
        , Border.color colorBorder
        , Border.widthEach { bottom = 1, left = 0, right = 0, top = 0 }
        , width fill
        ]
        (el
            [ centerY, Font.bold ]
            (text "Modal header")
        )


modalBody : Element msg
modalBody =
    el
        [ padding 24
        , height fill
        , width fill
        , scrollbarY
        ]
        (Element.textColumn []
            [ Element.paragraph
                []
                [ text "All modals have a fixed width of 640px. A modal’s height is dynamic but not more than 640px, after which the content part of the modal will become vertically scrollabale. The confirmation action must always reinforce the title of the modal (i.e., Title: “Configure a new car” and confirmation action label: “Configure”). Scrollbar symbol should only be enabled if full height modal is being demonstrated. Design example is a native macOS webkit scrollbar, live version will be native to platform." ]
            , Element.paragraph
                []
                [ text "All modals have a fixed width of 640px. A modal’s height is dynamic but not more than 640px, after which the content part of the modal will become vertically scrollabale. The confirmation action must always reinforce the title of the modal (i.e., Title: “Configure a new car” and confirmation action label: “Configure”). Scrollbar symbol should only be enabled if full height modal is being demonstrated. Design example is a native macOS webkit scrollbar, live version will be native to platform."
                ]
            , Element.paragraph
                []
                [ text "All modals have a fixed width of 640px. A modal’s height is dynamic but not more than 640px, after which the content part of the modal will become vertically scrollabale. The confirmation action must always reinforce the title of the modal (i.e., Title: “Configure a new car” and confirmation action label: “Configure”). Scrollbar symbol should only be enabled if full height modal is being demonstrated. Design example is a native macOS webkit scrollbar, live version will be native to platform."
                ]
            , Element.paragraph
                []
                [ text "All modals have a fixed width of 640px. A modal’s height is dynamic but not more than 640px, after which the content part of the modal will become vertically scrollabale. The confirmation action must always reinforce the title of the modal (i.e., Title: “Configure a new car” and confirmation action label: “Configure”). Scrollbar symbol should only be enabled if full height modal is being demonstrated. Design example is a native macOS webkit scrollbar, live version will be native to platform."
                ]
            ]
        )


button : String -> Element msg
button copy =
    el
        [ Border.rounded 3
        ]
        (text copy)


modalFooter : Element msg
modalFooter =
    row
        [ paddingXY 24 0
        , height (px 80)
        , Border.color colorBorder
        , Border.widthEach { bottom = 0, left = 0, right = 0, top = 1 }
        , width fill
        , spaceEvenly
        ]
        [ el
            [ centerY ]
            (button "Cancel")
        , el
            [ centerY ]
            (button "Confirm")
        ]



-- ---------------------------
-- MAIN
-- ---------------------------


main : Program Int Model Msg
main =
    Browser.document
        { init = init
        , update = update
        , view =
            \m ->
                { title = "Elm 0.19 starter"
                , body = [ view m ]
                }
        , subscriptions = \_ -> Sub.none
        }
