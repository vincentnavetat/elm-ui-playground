port module Main exposing (Model, Msg(..), add1, init, main, toJs, update, view)

import Browser
import Browser.Navigation as Nav
import Element exposing (..)
import Element.Background as Background
import Element.Border as Border
import Element.Font as Font
import Element.Input as Input
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


edges =
    { top = 0
    , right = 0
    , bottom = 0
    , left = 0
    }


view : Model -> Html Msg
view model =
    Element.layout [ inFront modalOverlay ]
        pageContent


modalOverlay : Element msg
modalOverlay =
    column
        [ width fill
        , height fill
        , Background.color (rgba255 33 34 36 0.65)
        , clip
        ]
        [ modal
        ]


pageContent : Element msg
pageContent =
    column
        [ centerX
        , paddingEach { edges | top = 24 }
        , width
            (fill
                |> maximum 900
            )
        , Font.size 18
        ]
        [ pageText
        ]


pageText : Element msg
pageText =
    Element.textColumn
        []
        [ Element.paragraph
            [ Font.bold
            , paddingEach { edges | bottom = 32 }
            , Font.size 24
            ]
            [ text "carwow styleguide" ]
        , Element.paragraph
            []
            [ text "It is a long established fact that a reader will be distracted by the readable content of a page when looking at its layout. The point of using Lorem Ipsum is that it has a more-or-less normal distribution of letters, as opposed to using 'Content here, content here', making it look like readable English. Many desktop publishing packages and web page editors now use Lorem Ipsum as their default model text, and a search for 'lorem ipsum' will uncover many web sites still in their infancy. Various versions have evolved over the years, sometimes by accident, sometimes on purpose (injected humour and the like)." ]
        ]


modal : Element msg
modal =
    column
        [ Background.color (rgb255 255 255 255)
        , width
            (fill
                |> maximum 640
            )
        , centerX
        , centerY
        , Border.rounded 3
        , height
            (shrink
                |> maximum 500
            )
        ]
        [ modalHeader
        , modalBody
        , modalFooter
        ]


modalHeader : Element msg
modalHeader =
    row
        [ paddingXY 24 0
        , height (px 64)
        , Border.color colorBorder
        , Border.widthEach { bottom = 1, left = 0, right = 0, top = 0 }
        , width fill
        , spaceEvenly
        , centerY
        ]
        [ el
            [ Font.semiBold
            , centerY
            , Font.size 16
            ]
            (text "Modal header")
        , el
            [ Font.size 40
            ]
            (text "×")
        ]


modalBody : Element msg
modalBody =
    el
        [ padding 24
        , height fill
        , width fill
        , scrollbarY
        , Font.size 16
        ]
        (Element.textColumn
            []
            [ Element.paragraph
                [ paddingEach { edges | bottom = 32 } ]
                [ text "All modals have a fixed width of 640px. A modal’s height is dynamic but not more than 640px, after which the content part of the modal will become vertically scrollabale. The confirmation action must always reinforce the title of the modal (i.e., Title: “Configure a new car” and confirmation action label: “Configure”). Scrollbar symbol should only be enabled if full height modal is being demonstrated. Design example is a native macOS webkit scrollbar, live version will be native to platform." ]
            , Element.paragraph
                [ paddingEach { edges | bottom = 32 } ]
                [ text "Contrary to popular belief, Lorem Ipsum is not simply random text. It has roots in a piece of classical Latin literature from 45 BC, making it over 2000 years old. Richard McClintock, a Latin professor at Hampden-Sydney College in Virginia, looked up one of the more obscure Latin words, consectetur, from a Lorem Ipsum passage, and going through the cites of the word in classical literature, discovered the undoubtable source. Lorem Ipsum comes from sections 1.10.32 and 1.10.33 of de Finibus Bonorum et Malorum (The Extremes of Good and Evil) by Cicero, written in 45 BC. This book is a treatise on the theory of ethics, very popular during the Renaissance. The first line of Lorem Ipsum, comes from a line in section 1.10.32."
                ]
            , Element.paragraph
                [ paddingEach { edges | bottom = 32 } ]
                [ text "There are many variations of passages of Lorem Ipsum available, but the majority have suffered alteration in some form, by injected humour, or randomised words which don't look even slightly believable. If you are going to use a passage of Lorem Ipsum, you need to be sure there isn't anything embarrassing hidden in the middle of text."
                ]
            , Element.paragraph
                []
                [ text "All modals have a fixed width of 640px. A modal’s height is dynamic but not more than 640px, after which the content part of the modal will become vertically scrollabale. The confirmation action must always reinforce the title of the modal (i.e., Title: “Configure a new car” and confirmation action label: “Configure”). Scrollbar symbol should only be enabled if full height modal is being demonstrated. Design example is a native macOS webkit scrollbar, live version will be native to platform."
                ]
            ]
        )


primaryButton : String -> Element msg
primaryButton copy =
    Input.button
        [ paddingXY 32 12
        , Background.color (rgb255 0 164 255)
        , Font.color (rgb255 255 255 255)
        , Border.rounded 3
        , Font.semiBold
        , Font.size 18
        ]
        { onPress = Nothing
        , label = text copy
        }


secondaryButton : String -> Element msg
secondaryButton copy =
    Input.button
        [ paddingXY 32 11
        , Border.color colorBorder
        , Border.width 1
        , Border.rounded 3
        , Font.semiBold
        , Font.size 18
        ]
        { onPress = Nothing
        , label = text copy
        }


modalFooter : Element msg
modalFooter =
    row
        [ paddingXY 24 0
        , height (px 80)
        , Border.color colorBorder
        , Border.widthEach { edges | top = 1 }
        , width fill
        , spaceEvenly
        ]
        [ el
            [ centerY ]
            (secondaryButton "Cancel")
        , el
            [ centerY ]
            (primaryButton "Confirm")
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
