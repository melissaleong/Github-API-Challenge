module Models exposing (..)

import Http


---- MODEL ----


type alias User =
    { name : String
    , avatar_url : String
    , repositories : String
    }


type alias RepoInfo =
    { name : String
    , language : String
    , watchers : Int
    , url : String
    }


type alias Model =
    { search : String
    , users : List User
    , images : List String
    , userRepos : List RepoInfo
    , userName : String
    , clicked : Bool
    }


initModel : Model
initModel =
    { search = ""
    , users = []
    , images = []
    , userRepos = []
    , userName = ""
    , clicked = False
    }


type Msg
    = Search String
    | Submit
    | LoadData (Result Http.Error (List User))
    | ChooseUser String String
    | LoadRepoData (Result Http.Error (List RepoInfo))
