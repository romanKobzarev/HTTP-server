*** Settings ***
Documentation    Tests for HTTP server
Library  Process
Library	 RequestsLibrary
Suite Teardown    Terminate All Processes    kill=True
Suite Setup       Start Server

*** Test Cases ***
Test With Incorrect Header Key
    ${header}    create dictionary  ImSI  dfgghjk
    ${response}  get request     localhost  /
    should be equal as Strings  ${response.status_code}  500

Test Without Header
    ${response}  get request     localhost  /
    should be equal as Strings  ${response.status_code}  500

Test With Correct Header
    ${header}    create dictionary  IMSI  dfg88_4hjk
    ${response}  get request     localhost  /   headers=${header}
    should be equal as Strings  ${response.status_code}  200

Test With Only Alphabet
    ${header}    create dictionary  IMSI  abcdf
    ${response}  get request     localhost  /   headers=${header}
    should be equal as Strings  ${response.status_code}  200


Test With Only Number
    ${header}=    create dictionary  IMSI  12345
    ${response}=  get request     localhost  /   headers=${header}
    should be equal as Strings  ${response.status_code}  200

Test With Long Header Value
    ${header}=    create dictionary  IMSI  dfghgfututu6w8e62_6tgdysjk
    ${response}=  get request     localhost  /   headers=${header}
    should be equal as Strings  ${response.status_code}  500

Test With Empty Header Value
    ${header}=    create dictionary  IMSI  ${EMPTY}
    ${response}=  get request     localhost  /   headers=${header}
    should be equal as Strings  ${response.status_code}  500

Test With Space In Header
    ${header}=    create dictionary  IMSI  ghgghg${SPACE}567
    ${response}=  get request     localhost  /   headers=${header}
    should be equal as Strings  ${response.status_code}  500

Test With Other Symbol In Header
    ${header}=    create dictionary  ISMI  ghg;ghg:567
    ${response}=  get request     localhost  /   headers=${header}
    should be equal as Strings  ${response.status_code}  500

Test WIth Different Headers
    ${header}=  create dictionary  RomaNika  status sratus  FlexKex  WeloveGames  IMSI  RightISMI
    ${response}=  get request  localhost  /  headers=${header}
    should be equal as strings  ${response.status_code}  200

*** Keywords ***
Start Server
    Start Process  python3  ./http_server.py
    create session  localhost  http://localhost:8585
