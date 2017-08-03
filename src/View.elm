module View exposing (..)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Models exposing (..)


---- VIEW ----


view : Model -> Html Msg
view model =
    div []
        [ text "Search users names: "
        , input [ type_ "search", onInput Search ] []
        , div [] []
        , button [ onClick Submit ] [ text "SUBMIT" ]
        , viewImageList model.users
        , div [] [ Html.cite [] [ text (displayText model.userName model.clicked) ] ]
        , viewRepoList model.userRepos
        ]


viewImage : User -> Html Msg
viewImage { name, avatar_url, repositories } =
    menuitem [ onClick (ChooseUser repositories name) ]
        [ img [ src avatar_url ] [] ]


viewImageList : List User -> Html Msg
viewImageList userList =
    userList
        |> List.map viewImage
        |> div []


displayText : String -> Bool -> String
displayText userName clicked =
    if clicked == True then
        userName ++ "'s repositories"
    else
        ""


viewRepo : RepoInfo -> Html Msg
viewRepo { name, language, watchers, url } =
    fieldset []
        [ a [ href url ] [ strong [] [ text name ] ]
        , div [] [ text ("Primary Language: " ++ language) ]
        , div [] [ text ("Watchers: " ++ (viewWatchers watchers)) ]
        ]


viewRepoList : List RepoInfo -> Html Msg
viewRepoList repoList =
    repoList
        |> List.map viewRepo
        |> div []


viewWatchers : Int -> String
viewWatchers watchers =
    if watchers == 0 then
        "None"
    else
        viewNumWatchers watchers


viewNumWatchers : Int -> String
viewNumWatchers watchers =
    case watchers of
        0 ->
            ""

        n ->
            "😃" ++ (viewNumWatchers (n - 1))
