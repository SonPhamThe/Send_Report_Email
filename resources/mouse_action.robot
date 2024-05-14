*** Settings ***
Library     RPA.Browser.Selenium
Library    RPA.Email.ImapSmtp


*** Keywords ***
Mouse Over Element
    [Arguments]    ${element_locator}    ${message_errors}
    ${element_visible}=    Run Keyword And Return Status    Wait Until Element Is Visible    id=${element_locator}
    IF    not ${element_visible}    Fatal Error    ${message_errors}
    Mouse Over    id=${element_locator}

Mouse Over And Click Element
    [Arguments]    ${element_locator}    ${message_errors}
    ${element_visible}=    Run Keyword And Return Status    Wait Until Element Is Visible    id=${element_locator}
    IF    not ${element_visible}    Fatal Error    ${message_errors}
    Mouse Over    id=${element_locator}
    Click Element    id=${element_locator}