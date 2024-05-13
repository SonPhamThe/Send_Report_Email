*** Settings ***
Library     RPA.Browser.Selenium


*** Keywords ***
Open Browser And Maximize Window
    [Arguments]    ${URL_BROWSER}
    Open Available Browser    ${URL_BROWSER}
    Maximize Browser Window

Login With Credentials
    [Arguments]    ${id_input_username}    ${username}    ${id_input_password}    ${password}    ${element_page}
    Wait Until Element Is Visible    id=${id_input_username}    10s
    Input Text    ${id_input_username}    ${username}
    Wait Until Element Is Visible    id=${id_input_password}    10s
    Input Password    ${id_input_password}    ${password}
    Click Button When Visible    css=button.action.login.primary
    Assert Logged In    ${element_page}

Assert Logged In
    [Arguments]    ${element_page}
    Wait Until Element Is Visible    ${element_page}
