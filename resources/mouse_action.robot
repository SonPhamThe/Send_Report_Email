*** Settings ***
Library     RPA.Browser.Selenium


*** Keywords ***
Mouse Over Element
    [Arguments]    ${element_locator}
    Wait Until Element Is Visible    id=${element_locator}    10s
    Mouse Over    id=${element_locator}

Mouse Over And Click Element
    [Arguments]    ${element_locator}
    Wait Until Element Is Visible    ${element_locator}
    Mouse Over    id=${element_locator}
    Click Element    id=${element_locator}
