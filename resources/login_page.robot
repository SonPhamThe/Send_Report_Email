*** Settings ***
Library     RPA.Browser.Selenium
Library     RPA.Desktop


*** Keywords ***
Login With Credentials
    [Arguments]    ${username}    ${password}    ${element_page}

    ${emailVisible}=    Run Keyword And Return Status    Wait Until Element Is Visible    id=email    10s
    Run Keyword If    not ${emailVisible}    Fatal Error    Id email input not found
    Input Text    id=email    ${username}
    
    ${passVisible}=    Run Keyword And Return Status    Wait Until Element Is Visible    id=pass    10s
    Run Keyword If    not ${passVisible}    Fatal Error    Id password input not found
    Input Password    id=pass    ${password}
    Click Button When Visible    id:send2

    ${login_success}=    Run Keyword And Return Status    Wait Until Element Is Visible    ${element_page}
    Run Keyword Unless    ${login_success}    Handle Login Failure

Handle Login Failure
    Log    Login failed, please check your credentials and try again.    level=ERROR
    Fail    Stopping execution due to login failure.
    