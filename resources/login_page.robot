*** Settings ***
Library     RPA.Browser.Selenium
Library     RPA.Desktop


*** Keywords ***
Login With Credentials
    [Arguments]    ${username}    ${password}    ${element_page}

   ${emailVisible}=    Run Keyword And Return Status    Wait Until Element Is Visible    id=email    10s
    Run Keyword If    not ${emailVisible}    Log And Exit    Id email input not found
    Input Text    id=email    ${username}
    
    ${passVisible}=    Run Keyword And Return Status    Wait Until Element Is Visible    id=pass    10s
    Run Keyword If    not ${passVisible}    Log And Exit    Id password input not found
    Input Password    id=pass    ${password}
    Click Button When Visible    id:send2
    ${login_success}=    Run Keyword And Return Status    Assert Logged In    ${element_page}
    Run Keyword Unless    ${login_success}    Handle Login Failure
    Assert Logged In    ${element_page}

Handle Login Failure
    Log    Login failed, please check your credentials and try again.    level=ERROR
    Fail    Stopping execution due to login failure.

Assert Logged In
    [Arguments]    ${element_page}
    Wait Until Element Is Visible    ${element_page}    timeout=10s

Log And Exit
    [Arguments]    ${message}
    Log    ${message}    level=ERROR
    Return From Keyword
    