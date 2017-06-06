module Main exposing (..)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Http
import Json.Decode as Decode
import Dict


main =
    Html.program
        { init = init
        , view = view
        , update = update
        , subscriptions = \_ -> Sub.none
        }


type alias Model =
    { value : String
    }


init : ( Model, Cmd Msg )
init =
    ( Model "waiting..."
    , doLogin "foo" "bar"
    )


type Msg
    = Login (Result Http.Error String)


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        Login (Ok header) ->
            ( Model ("The header value is " ++ header), Cmd.none )

        Login (Err err) ->
            ( { model | value = toString err }, Cmd.none )


view : Model -> Html Msg
view model =
    div []
        [ text model.value
        ]


doLogin : String -> String -> Cmd Msg
doLogin username password =
    let
        url =
            "/login"
    in
        Http.send Login (getHeader "Authorization" url)


getHeader : String -> String -> Http.Request String
getHeader name url =
    Http.request
        { method = "GET"
        , headers = []
        , url = url
        , body = Http.emptyBody
        , expect = Http.expectStringResponse (extractHeader name)
        , timeout = Nothing
        , withCredentials = False
        }


extractHeader : String -> Http.Response String -> Result String String
extractHeader name resp =
    Dict.get name (Debug.log "headers" resp.headers)
        |> Result.fromMaybe ("header " ++ name ++ " not found")
