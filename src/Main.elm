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


sendUser : String -> Cmd Msg
sendUser search =
    Http.send LoadData (getData search)


createLink : String -> String
createLink search =
    String.concat [ "https://api.github.com/search/users?q=", search ]


toImages : List User -> List String
toImages list =
    List.map .avatar_url list


type alias RepoInfo =
    { name : String
    , language : String
    , watchers : Int
    , url : String
    }


decodeRepo : JD.Decoder RepoInfo
decodeRepo =
    JD.map4 RepoInfo
        (JD.field "name" JD.string)
        (JD.field "language" JD.string)
        (JD.field "watchers" JD.int)
        (JD.field "url" JD.string)


decodeRepoList : JD.Decoder (List RepoInfo)
decodeRepoList =
    JD.list decodeRepo


getRepoData : String -> Http.Request (List RepoInfo)
getRepoData repoLink =
    Http.get (repoLink) (decodeRepoList)


sendRepo : String -> Cmd Msg
sendRepo repoLink =
    Http.send LoadRepoData (getRepoData repoLink)


type alias Model =
    { search : String
    , users : List User
    , images : List String
    , userRepos : List RepoInfo
    }


initModel : Model
initModel =
    { search = ""
    , users = []
    , images = []
    , userRepos = []
    }


init : ( Model, Cmd Msg )
init =
    ( initModel, Cmd.none )



---- UPDATE ----


type Msg
    = Search String
    | Submit
    | LoadData (Result Http.Error (List User))
    | ChooseUser String
    | LoadRepoData (Result Http.Error (List RepoInfo))


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        Search search ->
            ( { model | search = search }, Cmd.none )

        Submit ->
            ( model, sendUser model.search )

        LoadData (Ok users) ->
            ( { model | users = users }, Cmd.none )

        LoadData (Err something) ->
            let
                _ =
                    Debug.log "" something
            in
                ( model, Cmd.none )

        ChooseUser repositories ->
            ( model, sendRepo repositories )

        LoadRepoData (Ok userRepos) ->
            ( { model | userRepos = userRepos }, Cmd.none )

        LoadRepoData (Err something) ->
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

        --        , a [ href "https://api.github.com/users/omegaphoenix/repos" ]
        --            [ img [ src "https://avatars2.githubusercontent.com/u/10361461?v=4" ] []
        --            ]
        , viewRepoList model.userRepos
        ]


viewImage : User -> Html Msg
viewImage { name, avatar_url, repositories } =
    button [ onClick (ChooseUser repositories) ]
        [ img [ src avatar_url ] [] ]


viewImageList : List User -> Html Msg
viewImageList userList =
    userList
        |> List.map viewImage
        |> div []


viewRepo : RepoInfo -> Html Msg
viewRepo { name, language, watchers, url } =
    div []
        [ a [ href url ] [ h2 [] [ text name ] ]
        , div [] [ text "Primary Language: " ]
        , text language
        , div [] [ text "Watchers: " ]
        ]


viewRepoList : List RepoInfo -> Html Msg
viewRepoList repoList =
    repoList
        |> List.map viewRepo
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
