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
    , repositories : String
    }


decodeUser : JD.Decoder User
decodeUser =
    JD.map3 User
        (JD.field "login" JD.string)
        (JD.field "avatar_url" JD.string)
        (JD.field "repos_url" JD.string)


decodeList : JD.Decoder (List User)
decodeList =
    JD.list decodeUser


getData : String -> Http.Request (List User)
getData search =
    Http.get (createLink search) (JD.field "items" decodeList)


send : String -> Cmd Msg
send search =
    Http.send LoadData (getData search)


createLink : String -> String
createLink search =
    String.concat [ "https://api.github.com/search/users?q=", search ]


toImages : List User -> List String
toImages list =
    List.map .avatar_url list


type alias Model =
    { search : String
    , users : List User
    , images : List String
    }


initModel : Model
initModel =
    { search = ""
    , users = []
    , images = []
    }


init : ( Model, Cmd Msg )
init =
    ( initModel, Cmd.none )



---- UPDATE ----


type Msg
    = Search String
    | Submit
    | LoadData (Result Http.Error (List User))


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        Search search ->
            ( { model | search = search }, Cmd.none )

        Submit ->
            ( model, send model.search )

        LoadData (Ok users) ->
            ( { model | users = users }, Cmd.none )

        LoadData (Err something) ->
            let
                _ =
                    Debug.log "" something
            in
                ( model, Cmd.none )



---- VIEW ----


view : Model -> Html Msg
view model =
    div []
        [ text "Search users names: "
        , input [ type_ "search", onInput Search ] []
        , div [] []
        , button [ onClick Submit ] [ text "SUBMIT" ]
        , div [] [ text model.search ]
        , viewImageList model.users
        ]


viewImage : User -> Html Msg
viewImage { name, avatar_url, repositories } =
    img [ src avatar_url ] []


viewImageList : List User -> Html Msg
viewImageList userList =
    userList
        |> List.map viewImage
        |> div []



---- PROGRAM ----


main : Program Never Model Msg
main =
    Html.program
        { view = view
        , init = init
        , update = update
        , subscriptions = always Sub.none
        }
