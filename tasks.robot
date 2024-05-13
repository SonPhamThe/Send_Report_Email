*** Settings ***
Documentation
...                 The goal of this project is to develop a web automation tool capable of performing various tasks on an e-commerce website.
...                 The automation process includes logging into the website, searching for products based on user input,
...                 adding selected products to the shopping cart, and simulating the checkout process.

Library             RPA.Browser.Selenium
Library             DOP.RPA.Log
Library             DOP.RPA.Asset
Library             DOP.RPA.ProcessArgument
Library             RPA.Excel.Files
Library             Collections
Library             String
Library             RPA.Windows
Resource            resources/login_page.robot
Resource            resources/mouse_action.robot

Suite Setup         Open Browser And Maximize Window    ${MAGENTO_URL}


*** Variables ***
${MAGENTO_URL}                  https://magento.softwaretestingboard.com/
${HOME_PAGE_PRODUCT}            https://magento.softwaretestingboard.com/men/tops-men/jackets-men.html

# Men's Category IDs
${MEN_CATEGORY_ID}              ui-id-5
${TOPS_MEN_CATEGORY_ID}         ui-id-17
${JACKETS_MEN_CATEGORY_ID}      ui-id-19
${HOODIES_MEN_CATEGORY_ID}      ui-id-20
${TEES_MEN_CATEGORY_ID}         ui-id-21
${TANKS_MEN_CATEGORY_ID}        ui-id-22
${BOTTOMS_MEN_CATEGORY_ID}      ui-id-18
${PANTS_MEN_CATEGORY_ID}        ui-id-23
${SHORTS_MEN_CATEGORY_ID}       ui_id_24

# Women's Category IDs
${WOMEN_CATEGORY_ID}            ui-id-4
${TOPS_WOMEN_CATEGORY_ID}       ui-id-9
${JACKETS_WOMEN_CATEGORY_ID}    ui-id-11
${HOODIES_WOMEN_CATEGORY_ID}    ui-id-12
${TEES_WOMEN_CATEGORY_ID}       ui-id-13
${TANKS_WOMEN_CATEGORY_ID}      ui-id-14
${BOTTOMS_WOMEN_CATEGORY_ID}    ui-id-10
${PANTS_WOMEN_CATEGORY_ID}      ui-id-15
${SHORTS_WOMEN_CATEGORY_ID}     ui_id_16

# Gear Category IDs
${GEAR_CATEGORY_ID}             ui-id-6
${BAGS_GEAR_CATEGORY_ID}        ui-id-25
${FITNESS_GEAR_CATEGORY_ID}     ui-id-26
${WATCHES_GEAR_CATEGORY_ID}     ui-id-27


*** Tasks ***
Automated E-commerce Shopping
    Login With Magento Credentials
    Choose Each Product
    Add Product To Cart By Color And Size
    Close All Browsers


*** Keywords ***
Login With Magento Credentials
    [Documentation]    Logging into the Magento website using stored credentials. It clicks on the "Sign In" link,
    ...    retrieves the username and password from the available data file, and fills in the login form.
    ...    Finally, it verifies the successful login by waiting for the appearance of the customer name component.

    Click Link    link:Sign In
    ${meganto_account_credentials}=    Get Asset    meganto_account
    ${meganto_account_credentials}=    Set Variable    ${meganto_account_credentials}[value]

    Wait Until Keyword Succeeds
    ...    3x
    ...    1s
    ...    Login With Credentials
    ...    email
    ...    ${meganto_account_credentials}[username_meganto]
    ...    pass
    ...    ${meganto_account_credentials}[password_meganto]
    ...    css=span.customer-name

Choose Each Product
    [Documentation]    Clicks on the product link based on the product category, wearables and type product.

    ${category}=    Get In Arg    category
    ${category_value}=    Set Variable    ${category}[value]

    ${wearables}=    Get In Arg    wearables
    ${wearables_value}=    Set Variable    ${wearables}[value]

    ${product_type}=    Get In Arg    product_type
    ${product_type_value}=    Set Variable    ${product_type}[value]

    IF    '${category_value}' == 'Men'
        Mouse Over Element    ${MEN_CATEGORY_ID}
        IF    '${wearables_value}' == 'Tops'
            Wait Until Element Is Visible    xpath=//a[@id="${TOPS_MEN_CATEGORY_ID}"]
            Mouse Over Element    ${TOPS_MEN_CATEGORY_ID}
            IF    '${product_type_value}' == 'Jackets'
                Wait Until Element Is Visible    xpath=//a[@id="${JACKETS_MEN_CATEGORY_ID}"]
                Mouse Over And Click Element    ${JACKETS_MEN_CATEGORY_ID}
            END
            IF    '${product_type_value}' == 'Hoodies & Sweatshirts'
                Wait Until Element Is Visible    xpath=//a[@id="${HOODIES_MEN_CATEGORY_ID}"]
                Mouse Over And Click Element    ${HOODIES_MEN_CATEGORY_ID}
            END
            IF    '${product_type_value}' == 'Tees'
                Wait Until Element Is Visible    xpath=//a[@id="${TEES_MEN_CATEGORY_ID}"]
                Mouse Over And Click Element    ${TEES_MEN_CATEGORY_ID}
            END
            IF    '${product_type_value}' == 'Tanks'
                Wait Until Element Is Visible    xpath=//a[@id="${TANKS_MEN_CATEGORY_ID}"]
                Mouse Over And Click Element    ${TANKS_MEN_CATEGORY_ID}
            END
        END

        IF    '${wearables_value}' == 'Bottoms'
            Mouse Over Element    ${BOTTOMS_MEN_CATEGORY_ID}
            IF    '${product_type_value}' == 'Pants'
                Wait Until Element Is Visible    xpath=//a[@id="${PANTS_MEN_CATEGORY_ID}"]
                Mouse Over And Click Element    ${PANTS_MEN_CATEGORY_ID}
            END
            IF    '${product_type_value}' == 'Shorts'
                Wait Until Element Is Visible    xpath=//a[@id="${SHORTS_MEN_CATEGORY_ID}"]
                Mouse Over And Click Element    ${SHORTS_MEN_CATEGORY_ID}
            END
        END
    END

    IF    '${category_value}' == 'Women'
        Mouse Over Element    ${WOMEN_CATEGORY_ID}
        IF    '${wearables_value}' == 'Tops'
            Wait Until Element Is Visible    xpath=//a[@id="${TOPS_WOMEN_CATEGORY_ID}"]
            Mouse Over Element    ${TOPS_WOMEN_CATEGORY_ID}
            IF    '${product_type_value}' == 'Jackets'
                Wait Until Element Is Visible    xpath=//a[@id="${JACKETS_WOMEN_CATEGORY_ID}"]
                Mouse Over And Click Element    ${JACKETS_WOMEN_CATEGORY_ID}
            END
            IF    '${product_type_value}' == 'Hoodies & Sweatshirts'
                Wait Until Element Is Visible    xpath=//a[@id="${HOODIES_WOMEN_CATEGORY_ID}"]
                Mouse Over And Click Element    ${HOODIES_WOMEN_CATEGORY_ID}
            END
            IF    '${product_type_value}' == 'Tees'
                Wait Until Element Is Visible    xpath=//a[@id="${TEES_WOMEN_CATEGORY_ID}"]
                Mouse Over And Click Element    ${TEES_WOMEN_CATEGORY_ID}
            END
            IF    '${product_type_value}' == 'Bras & Tanks'
                Wait Until Element Is Visible    xpath=//a[@id="${TANKS_WOMEN_CATEGORY_ID}"]
                Mouse Over And Click Element    ${TANKS_WOMEN_CATEGORY_ID}
            END
        END

        IF    '${wearables_value}' == 'Bottoms'
            Wait Until Element Is Visible    xpath=//a[@id="${BOTTOMS_WOMEN_CATEGORY_ID}"]
            Mouse Over Element    ${BOTTOMS_WOMEN_CATEGORY_ID}
            IF    '${product_type_value}' == 'Pants'
                Wait Until Element Is Visible    xpath=//a[@id="${PANTS_WOMEN_CATEGORY_ID}"]
                Mouse Over And Click Element    ${PANTS_WOMEN_CATEGORY_ID}
            END
            IF    '${product_type_value}' == 'Shorts'
                Wait Until Element Is Visible    xpath=//a[@id="${SHORTS_WOMEN_CATEGORY_ID}"]
                Mouse Over And Click Element    ${SHORTS_WOMEN_CATEGORY_ID}
            END
        END
    END

    IF    '${category_value}' == 'Gear'
        Mouse Over Element    ${GEAR_CATEGORY_ID}
        IF    '${product_type_value}' == 'Bags'
            Wait Until Element Is Visible    xpath=//a[@id="${BAGS_GEAR_CATEGORY_ID}"]
            Mouse Over And Click Element    ${BAGS_GEAR_CATEGORY_ID}
        END
        IF    '${product_type_value}' == 'Fitness Equipment'
            Wait Until Element Is Visible    xpath=//a[@id="${FITNESS_GEAR_CATEGORY_ID}"]
            Mouse Over And Click Element    ${FITNESS_GEAR_CATEGORY_ID}
        END
        IF    '${product_type_value}' == 'Watches'
            Wait Until Element Is Visible    xpath=//a[@id="${WATCHES_GEAR_CATEGORY_ID}"]
            Mouse Over And Click Element    ${WATCHES_GEAR_CATEGORY_ID}
        END
    END

Add Product To Cart By Color And Size
    [Documentation]    Add the product to the cart based on the specified color and size.
    ${values}=    Get List Items    css:#limiter    values=True
    FOR    ${value}    IN    @{values}
        IF    ${value} > 12    Go To    ${HOME_PAGE_PRODUCT}
        Select From List By Value    (//select[@id='limiter'])[2]    ${value}
        ${product_links}=    Get Product Links
        FOR    ${link}    IN    @{product_links}
            Go To Product Detail Page    ${link}
            Wait Until Page Contains Element    css:.price-wrapper    timeout=15
            ${data-price-amount}=    Get Element Attribute    css:.price-wrapper    data-price-amount
            # ${data-price-amount}=    Convert To Number    ${data-price-amount}
            # IF    ${data-price-amount} > 30    Log    True
            Log    ${data-price-amount}
            Wait Until Element Is Visible    id:product-addtocart-button
            ${check_product_to_cart}=    Check Product By Size And Color
            IF    ${check_product_to_cart}
                Click Element    id:product-addtocart-button
            END
        END
    END

Get Product Links
    [Documentation]    Retrieve the links of all products listed on the current page.
    @{product_elements}=    Get WebElements    css:ol.products li.item.product a.product-item-link
    @{product_links}=    Create List
    FOR    ${element}    IN    @{product_elements}
        ${link}=    Get Element Attribute    ${element}    href
        Append To List    ${product_links}    ${link}
    END
    RETURN    ${product_links}

Go To Product Detail Page
    [Documentation]    Navigate to the detail page of the specified product link.
    [Arguments]    ${product_link}
    Go To    ${product_link}

Check Product By Size And Color
    ${size}=    Get In Arg    size
    ${size_value}=    Set Variable    ${size}[value]
    ${size_exists}=    Check Size Exists    ${size_value}

    ${color}=    Get In Arg    color
    ${color_value}=    Set Variable    ${color}[value]
    ${color_exists}=    Check Color Exists    ${color_value}

    IF    not ${size_exists} or not ${color_exists}    RETURN    ${False}
    RETURN    ${True}

Check Size Exists
    [Documentation]    Verify if the specified size exists for the product.
    [Arguments]    ${size}
    Log    Checking product size: ${size}
    ${sizes}=    Get WebElements    css:.swatch-option.text
    ${size_found}=    Set Variable    ${FALSE}
    FOR    ${elem}    IN    @{sizes}
        ${value}=    Get Element Attribute    ${elem}    option-label
        Log    Found size option: ${value}
        IF    '${size}' == '${value}'
            ${size_found}=    Set Variable    ${TRUE}
            Click Element    ${elem}
            BREAK
        END
    END
    RETURN    ${size_found}

Check Price Product
    No Operation
    ${below_price}=    Get In Arg    below_price
    ${below_price_value}=    Set Variable    ${below_price}[value]

    ${above_price}=    Get In Arg    above_price
    ${above_price_value}=    Set Variable    ${above_price}[value]

Check Color Exists
    [Documentation]    Verify if the specified color exists for the product.
    [Arguments]    ${color}
    Log    Checking product color: ${color}
    ${colors}=    Get WebElements    css:.swatch-option.color
    ${color_found}=    Set Variable    ${FALSE}
    FOR    ${elem}    IN    @{colors}
        ${value}=    Get Element Attribute    ${elem}    option-label
        Log    Found color option: ${value}
        IF    '${color}' == '${value}'
            ${color_found}=    Set Variable    ${TRUE}
            Click Element    ${elem}
            BREAK
        END
    END
    RETURN    ${color_found}
