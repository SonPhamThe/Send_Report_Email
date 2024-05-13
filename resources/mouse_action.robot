*** Settings ***
Library     RPA.Browser.Selenium


*** Keywords ***
Mouse Over Element
    [Arguments]    ${element_locator}    ${message_errors}
    ${element_visible}=    Run Keyword And Return Status    Wait Until Element Is Visible    id=${element_locator}
    IF    not ${element_visible}    Log And Exit    ${message_errors}
    Mouse Over    id=${element_locator}

Mouse Over And Click Element
    [Arguments]    ${element_locator}    ${message_errors}
    ${element_visible}=    Run Keyword And Return Status    Wait Until Element Is Visible    id=${element_locator}
    IF    not ${element_visible}    Log And Exit    ${message_errors}
    Mouse Over    id=${element_locator}
    Click Element    id=${element_locator}

Log And Exit
    [Arguments]    ${message}
    Log    ${message}    level=ERROR
    RETURN