*** Settings ***
Documentation    Tests for HTTP server

Metadata     Ubuntu  Version               19.04
Metadata     Python Version                3.7.3
Metadata     Robot Framework Version       3.1.2

Library   Process
Library	  RequestsLibrary

Force Tags  http-server-test    owner-romanKobzarev

Test Template     Send Request And Compare Status Code

Suite Setup       Start Server
Suite Teardown    Terminate All Processes    kill=True

*** Variables ***
${STATUS_OK}        200
${STATUS_NOT_OK}    500
${HEADER_KEY}       IMSI

# TODO:
# change names of boundery conditions TC
# change suite teardown

*** Test Cases ***                                  HEADER_VALUE        STATUS_CODE             HEADER_KEY

Test With Correct Header                            gjdhtyk_1235        ${STATUS_OK}
Test With Only Alphabet                             acgfhd              ${STATUS_OK}
Test With Only Number                               123123141           ${STATUS_OK}
Test With Long Header Value                         asdkljsalkasjdlask  ${STATUS_NOT_OK}
Test With Space In Header                           asdk${SPACE}sda     ${STATUS_NOT_OK}
Test With Other Symbol In Header                    asd:asd;sad         ${STATUS_NOT_OK}
Boundary Conditions Test With No Symbols            ${EMPTY}            ${STATUS_NOT_OK}
Boundary Conditions Test With 1 Symbol              1                   ${STATUS_OK}
Boundary Conditions Test With 2 Symbols             bb                  ${STATUS_OK}
Boundary Conditions Test With 14 Symbols            dfhgn__3571824      ${STATUS_OK}
Boundary Conditions Test With 15 Symbols            891122284567516     ${STATUS_OK}
Boundary Conditions Test With 16 Symbols            1293138193812938    ${STATUS_NOT_OK}
Test With Incorrect Header Key                      abc_123             ${STATUS_NOT_OK}        header_key=ISMI
Test Without Header                                 ${null}             ${STATUS_NOT_OK}        header_key=${null}


*** Keywords ***
Start Server
    Start Process  python3  ./http_server.py
    create session  localhost  http://localhost:8585

Send Request And Compare Status Code
    [Arguments]  ${header_value}  ${expected_code}  ${header_key}=${HEADER_KEY}
    ${header}   run keyword if  '${header_key}'!='${null}'   create dictionary  ${header_key}    ${header_value}
    ${response}  get request  localhost  ${EMPTY}  headers=${header}
    should be equal as strings  ${response.status_code}  ${expected_code}