module Main exposing (..)

import Html exposing (..)
import Models exposing (..)
import Update exposing (..)
import View exposing (..)


----PROGRAM----


init : ( Model, Cmd Msg )
init =
    ( initModel, Cmd.none )


main : Program Never Model Msg
main =
    Html.program
        { view = view
        , init = init
        , update = update
        , subscriptions = always Sub.none
        }
