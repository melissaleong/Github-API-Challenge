module Main exposing (..)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Http
import Json.Decode as JD


-- import Json.Decode.Pipeline as JDP
--import Json.Decode as Json exposing (..)
---- MODEL ----


type alias User =
    { name : String
    , avatar_url : String
    }


decodeData : JD.Decoder User
decodeData =
    JD.map2 User
        (JD.field "login" JD.string)
        (JD.field "avatar_url" JD.string)


getData : Http.Request User
getData =
    Http.get "https://api.github.com/users" decodeData



--type AMsg
--    = LoadData (Result Http.Error User)


send : Cmd Msg
send =
    Http.send LoadData getData


type alias Model =
    { search : String
    , hidden : Bool
    , user : String -> String -> User
    , image : String
    }


model : Model
model =
    Model "" True User ""


init : ( Model, Cmd Msg )
init =
    ( Model "" True User "", Cmd.none )



---- UPDATE ----


type Msg
    = Search String
    | Submit
    | LoadData (Result Http.Error User)


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        Search search ->
            ( { model | search = search }, Cmd.none )

        Submit ->
            ( { model | hidden = False }, send )

        LoadData (Ok user) ->
            ( { model | image = "https://avatars0.githubusercontent.com/u/1?v=4" }
            , Cmd.none
            )

        LoadData (Err _) ->
            ( model, Cmd.none )



---- VIEW ----


view : Model -> Html Msg
view model =
    div []
        [ text "Search users names: "
        , input [ type_ "search", onInput Search ] []
        , div [] []
        , button [ onClick Submit ] [ text "SUBMIT" ]
        , div [] []
        , img [ src model.image ] []
        ]



---- PROGRAM ----


main : Program Never Model Msg
main =
    Html.program
        { view = view
        , init = init
        , update = update
        , subscriptions = always Sub.none
        }
