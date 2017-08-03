module Update exposing (..)

import Http
import Json.Decode as JD
import Json.Decode.Pipeline as JDP
import Models exposing (..)


---- UPDATE ----


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

        ChooseUser repositories userName ->
            ( { model | userName = userName, clicked = True }, sendRepo repositories )

        LoadRepoData (Ok userRepos) ->
            ( { model | userRepos = userRepos }, Cmd.none )

        LoadRepoData (Err something) ->
            let
                _ =
                    Debug.log "" something
            in
                ( model, Cmd.none )


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


decodeRepo : JD.Decoder RepoInfo
decodeRepo =
    JDP.decode RepoInfo
        |> JDP.required "name" JD.string
        |> JDP.optional "language" JD.string ""
        |> JDP.required "watchers" JD.int
        |> JDP.required "url" JD.string


decodeRepoList : JD.Decoder (List RepoInfo)
decodeRepoList =
    JD.list decodeRepo


getRepoData : String -> Http.Request (List RepoInfo)
getRepoData repoLink =
    Http.get (repoLink) (decodeRepoList)


sendRepo : String -> Cmd Msg
sendRepo repoLink =
    Http.send LoadRepoData (getRepoData repoLink)
