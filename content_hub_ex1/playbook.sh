#!/bin/bash

: "${API_KEY:=889543c8-8e1a0583-d895af11-183205330bf}"
: "${BASE_URL:=https://w1waoh1clk.execute-api.us-east-1.amazonaws.com/semantex-qa}"
: "${SAMPLES_DIR:=$HOME/Desktop/pdfs}"


function sem_create_app() {

    local app_name="$1"
    if ! [[ -v 1 ]] ; then
        app_name="Test Application by $USER-$(date +%Y/%m/%d)"
    fi    
    
    echo "Creating application: $app_name"

    payload=$(jq -nr --arg name "$app_name" '{ "name": $name}')
    response=$(curl -s -XPOST "$BASE_URL/hub/apps" -H 'Content-Type: application/json' -H "x-api-key: $API_KEY" -d "$payload")
    echo $response | jq
    
    export APP_ID=$(echo $response | jq -r '.result."app-id"')
    
}

function sem_delete_app() {
    if ! [[ -v 1 ]] ; then
        echo "No application id specified to delete."
        echo "Usage: sem_delete_app <app-id>"
        return 1
    fi    

    curl -s -XDELETE "$BASE_URL/hub/apps/$1" -H 'Content-Type: application/json' -H "x-api-key: $API_KEY" | jq 
    unset APP_ID > /dev/null 2>&1
}

function sem_list_apps() {
    curl -s -XGET "$BASE_URL/hub/apps" -H 'Content-Type: application/json' -H "x-api-key: $API_KEY" | jq
}

function sem_add_pdf() {

    if !  validate_appid ; then 
        return 10
    fi

    # Check to see if a file is provided
    if ! [[ -v 1 ]] ; then
        echo "No application id specified to delete."
        echo "Usage: sem_delete_app <app-id>"
        return 1
    fi

    # Check to see if file exists
    if [ ! -f "$1" ]; then
      echo "$1 does not exist."
      return 1
    fi        

    curl -s -X POST -H 'Content-Type: application/pdf' -H "x-api-key: $API_KEY" "$BASE_URL/hub/apps/$APP_ID/ingestion/pdf" --upload-file "$1" | jq 

}

function sem_list_docs() {
    if !  validate_appid ; then 
        return 10
    fi

    curl -s -XGET "$BASE_URL/hub/apps/$APP_ID/documents" -H 'Content-Type: application/json' -H "x-api-key: $API_KEY" | jq
}

function sem_get_doc() {
    if !  validate_appid ; then 
        return 10
    fi

    # Check to see if a file is provided
    if ! [[ -v 1 ]] ; then
        echo "No document id specified to retrieve."
        echo "Usage: sem_get_doc <did>"
        return 1
    fi

    curl -s -X GET "$BASE_URL/hub/apps/$APP_ID/documents/$1" -H 'Content-Type: application/json' -H "x-api-key: $API_KEY" | jq
}


function sem_delete_doc() {
    if !  validate_appid ; then 
        return 10
    fi

    # Check to see if a file is provided
    if ! [[ -v 1 ]] ; then
        echo "No document id specified to delete."
        echo "Usage: sem_delete_doc <did>"
        return 1
    fi

    curl -s -X DELETE "$BASE_URL/hub/apps/$APP_ID/documents/$1" -H 'Content-Type: application/json' -H "x-api-key: $API_KEY" | jq
}

function sem_list_contents() {
    
    if !  validate_appid ; then 
        return
    fi

    curl -s -XGET "$BASE_URL/hub/apps/$APP_ID/contents" -H 'Content-Type: application/json' -H "x-api-key: $API_KEY" | jq
}


function sem_get_content() {
    
    if !  validate_appid ; then 
        return
    fi

    # Check to see if a file is provided
    if ! [[ -v 1 ]] ; then
        echo "No content id specified to retrieve."
        echo "Usage: sem_get_content <cid>"
        return 1
    fi

    curl -s -XGET "$BASE_URL/hub/apps/$APP_ID/contents/$1" -H 'Content-Type: application/json' -H "x-api-key: $API_KEY" | jq
}

function sem_delete_content() {
    if !  validate_appid ; then 
        return 10
    fi

    # Check to see if a file is provided
    if ! [[ -v 1 ]] ; then
        echo "No content id specified to delete."
        echo "Usage: sem_delete_doc <cid>"
        return 1
    fi

    curl -s -X DELETE "$BASE_URL/hub/apps/$APP_ID/contents/$1" -H 'Content-Type: application/json' -H "x-api-key: $API_KEY" | jq
}



function sem_sim_by_cid() {

    if ! validate_appid ; then 
        return 10
    fi

    if ! [[ -v 1 ]] ; then
        echo "No content defined."
        exit 1
    fi    

    #echo "cid: $1"

    payload=$(jq -nr --arg aid "$APP_ID" --arg cid "$1" '{ "aid": $aid, "cid": $cid, "min":0.50, "max":1.0 }')

    curl -s -XPOST "$BASE_URL/hub/apps/search/text/mlt" -H 'Content-Type: application/json' -H "x-api-key: $API_KEY" -d "$payload" | jq

}   


function sem_sim_by_text() {

    if !  validate_appid ; then 
        return 10
    fi

    if ! [[ -v 1 ]] ; then
        echo "No query text."
        return 2
    fi    

    #echo "text: $1"

    payload=$(jq -nr --arg aid "$APP_ID" --arg text "$1" '{ "aid": $aid, "text": $text, "min":0.50, "max":1.0 }')
    
    curl -s -XPOST "$BASE_URL/hub/apps/search/text/mlt" -H 'Content-Type: application/json' -H "x-api-key: $API_KEY" -d "$payload" | jq

}

function sem_search_text() {

    if ! validate_appid ; then 
        return 10
    fi

    if ! [[ -v 1 ]] ; then
        echo "No query defined."
        return 11
    fi    

    #echo "Query: $1"

    payload=$(jq -nr --arg aid "$APP_ID" --arg q "$1" '{ "aid": $aid, "query": $q }')

    curl -s -XPOST "$BASE_URL/hub/apps/search/text/keyword" -H 'Content-Type: application/json' -H "x-api-key: $API_KEY" -d "$payload" | jq
    
}

function validate_appid() {
    #check to see if APP_ID is set
    if ! [[ -v APP_ID ]] ; then
        echo_error "No application id found."
        echo_error "Please create an application first, or set the APP_ID variable."
        return 1000
    fi
    #echo -e "\e[01;32mAPP_ID:\e[0m $APP_ID"  >&2

}

function echo_error() {
    if ! [[ -v 1 ]] ; then
        return
    fi
    echo -e "\e[01;31m$1\e[0m"  >&2
}


function sem_display_config() {
    echo "API_KEY: $API_KEY"
    echo "BASE URL: $BASE_URL"
}

function sem_cleanup() {
  echo "Cleaning up..."

  unset API_KEY > /dev/null 2>&1
  unset BASE_URL > /dev/null 2>&1
  unset APP_ID > /dev/null 2>&1


  unset -f sem_create_app > /dev/null 2>&1
  unset -f sem_delete_app > /dev/null 2>&1
  unset -f sem_list_apps > /dev/null 2>&1

  unset -f sem_add_pdf > /dev/null 2>&1
  unset -f sem_list_docs > /dev/null 2>&1
  unset -f sem_get_doc > /dev/null 2>&1
  unset -f sem_delete_doc > /dev/null 2>&1

  unset -f sem_list_contents > /dev/null 2>&1
  unset -f sem_get_content > /dev/null 2>&1
  unset -f sem_delete_content > /dev/null 2>&1

  unset -f sem_sim_by_cid > /dev/null 2>&1
  unset -f sem_sim_by_text > /dev/null 2>&1
  unset -f sem_search_text > /dev/null 2>&1

  unset -f sem_help > /dev/null 2>&1
  unset -f sem_dep_check > /dev/null 2>&1
  unset -f sem_display_config > /dev/null 2>&1
  unset -f sem_cleanup > /dev/null 2>&1

  unset -f validate_appid
  unset -f echo_error

  echo "Cleaned up."
}

function sem_dep_check() {

    if ! [ -x "$(command -v jq)" ]; then
        echo 'Error: Missing dependency [jq]' >&2
        return 10
    fi

  echo "Dependencies OK."

}

function sem_help() {
  echo "-) sem_display_config -> Display the current configuration."
  echo
  echo "-) sem_create_app     -> Create a new application."
  echo "-) sem_delete_app     -> Delete an existing application."
  echo "-) sem_list_apps      -> Lists all applications."
  echo
  echo "-) sem_add_pdf        -> Add a single PDF file to an application via PDF ingestion API."
  echo "-) sem_list_docs      -> Lists all documents for a given application."
  echo "-) sem_get_doc        -> GET a document by document id for a given application."
  echo "-) sem_delete_doc     -> Delete a document for a given application."
  echo  
  echo "-) sem_list_contents  -> Lists all content items for a given application."
  echo "-) sem_get_content    -> GET the content by content id for a given application."
  echo "-) sem_delete_content -> Delete a content item for a given application."
  echo
  echo "-) sem_sim_by_cid     -> Finds similar items given a content id across a given application."
  echo "-) sem_sim_by_text    -> Finds similar items given a text across a given application."
  echo "-) sem_text_search    -> Simple keyword based search."
  echo "-) sem_search_text    -> Simple keyword based search."
  echo
  echo "-) sem_dep_check      -> Check for dependencies."
  echo "-) sem_cleanup        -> Cleanup the environment variables and functions."
}