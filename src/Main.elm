module Main exposing (..)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (onInput)


{-
   main =
       Html.beginnerProgram { model = model, view = view, update = update }
-}
---- MODEL ----


type alias Model =
    { search : String }


model : Model
model =
    Model ""


init : ( Model, Cmd Msg )
init =
    ( Model "", Cmd.none )



---- UPDATE ----


type Msg
    = Search String


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        Search search ->
            ( { model | search = search }, Cmd.none )



---- VIEW ----


view : Model -> Html Msg
view model =
    div []
        [ text "Search users names: "
        , input [ onInput Search ] []
        ]



---- PROGRAM ----
--   main : Program Never Model Msg


main =
    Html.program
        { view = view
        , init = init
        , update = update
        , subscriptions = always Sub.none
        }
