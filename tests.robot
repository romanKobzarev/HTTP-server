*** Settings ***
Documentation    Tests for HTTP server

Metadata     Ubuntu  Version               19.04
Metadata     Python Version                3.7.3
Metadata     Robot Framework Version       3.1.2

Library   Process
Library	  RequestsLibrary

Force Tags  http-server-test    owner-romanKobzarev

Test Template     Status response with ${header_value} should be equal ${expected_code}

Suite Setup       Start Server
Suite Teardown    Terminate All Processes    kill=True

*** Variables ***
${STATUS_OK}        200
${STATUS_NOT_OK}    500
${HEADER_KEY}       IMSI

*** Test Cases ***                      HEADER_VALUE        STATUS_CODE

Test With Correct Header                gjdhtyk_1235        ${STATUS_OK}
Test With Only Alphabet                 acgfhd              ${STATUS_OK}
Test With Only Number                   123123141           ${STATUS_OK}
Test With Long Header Value             asdkljsalkasjdlask  ${STATUS_NOT_OK}
Test With Space In Header               asdk${SPACE}sda     ${STATUS_NOT_OK}
Test With Other Symbol In Header        asd:asd;sad         ${STATUS_NOT_OK}
Boundary Conditions Test 0              ${EMPTY}            ${STATUS_NOT_OK}
Boundary Conditions Test 1              1                   ${STATUS_OK}
Boundary Conditions Test 2              bb                  ${STATUS_OK}
Boundary Conditions Test 14             dfhgn__3571824      ${STATUS_OK}
Boundary Conditions Test 15             891122284567516     ${STATUS_OK}
Boundary Conditions Test 16             1293138193812938    ${STATUS_NOT_OK}

#Test With Incorrect Header Key
#    ${header}    create dictionary  ImSI  dfgghjk
#    ${response}  get request     localhost  ${EMPTY}
#    should be equal as Strings  ${response.status_code}  ${STATUS_NOT_OK}
#
#Test Without Header
#    ${response}  get request     localhost  ${EMPTY}
#    should be equal as Strings  ${response.status_code}  ${STATUS_NOT_OK}

#Test WIth Several Headers
#    ${header}  create dictionary  RomaNika  status satus  FlexKex  WeloveGames  ${HEADER_KEY}  RightISMI
#    ${response}  get request  localhost  ${EMPTY}  headers=${header}
#    should be equal as strings  ${response.status_code}  ${STATUS_OK}

*** Keywords ***
Start Server
    Start Process  python3  ./http_server.py
    create session  localhost  http://localhost:8585

Status response with ${header_value} should be equal ${expected_code}
    ${header}   create dictionary  ${HEADER_KEY}    ${header_value}
    ${response}  get request  localhost  ${EMPTY}  headers=${header}
    should be equal as strings  ${response.status_code}  ${expected_code}