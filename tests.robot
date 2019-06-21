*** Settings ***
Documentation    Tests for HTTP server
Library  Process
Library	 RequestsLibrary
Suite Teardown    Terminate All Processes    kill=True

*** Test Cases ***
Test That Server Is Running
    Start Server
    Get Request  localhost  /


Test Without Header


Test With Correct Header


Test With Incorrect Header


*** Keywords ***
Start Server
    Start Process  python  ./http_server.py
