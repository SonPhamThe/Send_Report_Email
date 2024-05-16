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
Library             ConvertString
Library             CheckStatusCode
Library             String
Library             RPA.Windows
Library             RPA.HTTP
Library             RPA.JSON
Library             DateTime
Resource            resources/login_page.robot
Resource            resources/mouse_action.robot

Suite Teardown      Close All Browsers


*** Variables ***
${order_info}                   ${EMPTY}
${global_product_info}          ${EMPTY}
${color_product}                ${EMPTY}
${size_product}                 ${EMPTY}
${url_product}                  ${EMPTY}

${EXCEL_FILE_NAME}              data_magento.xlsx
${DIRECTORY_PATH}               ${CURDIR}

${current_time}                 ${EMPTY}

${MAGENTO_URL}                  https://magento.softwaretestingboard.com/

# Men's Category IDs
${MEN_CATEGORY_ID}              ui-id-5
${TOPS_MEN_CATEGORY_ID}         ui-id-17
${BOTTOMS_MEN_CATEGORY_ID}      ui-id-18

# Women's Category IDs
${WOMEN_CATEGORY_ID}            ui-id-4
${TOPS_WOMEN_CATEGORY_ID}       ui-id-9
${BOTTOMS_WOMEN_CATEGORY_ID}    ui-id-10

# Gear Category IDs
${GEAR_CATEGORY_ID}             ui-id-6
${BAGS_GEAR_CATEGORY_ID}        ui-id-25
${FITNESS_GEAR_CATEGORY_ID}     ui-id-26
${WATCHES_GEAR_CATEGORY_ID}     ui-id-27


*** Tasks ***
Automated E-commerce Shopping
    Open Website Magento
    Login With Magento Credentials
    Choose Each Product
    Add Product To Cart By Color, Size And Price
    Go To Cart And Make A Payment


*** Keywords ***
Open Website Magento
    Open Available Browser    ${MAGENTO_URL}    maximized=${True}    headless=${False}

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
    ...    ${meganto_account_credentials}[username]
    ...    ${meganto_account_credentials}[password]
    ...    css=span.customer-name

Choose Each Product
    [Documentation]    Clicks on the product link based on the product category, wearables and type product.

    ${category}=    Get In Arg    category
    ${category_value}=    Set Variable    ${category}[value]
    ${category_value}=    Conver Data To Search Product    ${category_value}

    ${wearables}=    Get In Arg    wearables
    ${wearables_value}=    Set Variable    ${wearables}[value]
    ${wearables_value}=    Conver Data To Search Product    ${wearables_value}

    ${product_type}=    Get In Arg    product_type
    ${product_type_value}=    Set Variable    ${product_type}[value]
    ${product_type_value}=    Conver Data To Search Product    ${product_type_value}

    IF    '${category_value}' == 'Men'
        Mouse Over Element    ${MEN_CATEGORY_ID}    Id men not found
        IF    '${wearables_value}' == 'Tops'
            Wait Until Element Is Visible    xpath=//a[@id="${TOPS_MEN_CATEGORY_ID}"]
            Mouse Over And Click Element    ${TOPS_MEN_CATEGORY_ID}    Id tops men not found
        END

        IF    '${wearables_value}' == 'Bottoms'
            Wait Until Element Is Visible    xpath=//a[@id="${BOTTOMS_MEN_CATEGORY_ID}]
            Mouse Over And Click Element    ${BOTTOMS_MEN_CATEGORY_ID}    Id bottoms men not found
        END
    END

    IF    '${category_value}' == 'Women'
        Mouse Over Element    ${WOMEN_CATEGORY_ID}    Id women not found
        IF    '${wearables_value}' == 'Tops'
            Wait Until Element Is Visible    xpath=//a[@id="${TOPS_WOMEN_CATEGORY_ID}"]
            Mouse Over And Click Element    ${TOPS_WOMEN_CATEGORY_ID}    Id top women not found
        END

        IF    '${wearables_value}' == 'Bottoms'
            Wait Until Element Is Visible    xpath=//a[@id="${BOTTOMS_WOMEN_CATEGORY_ID}"]
            Mouse Over And Click Element    ${BOTTOMS_WOMEN_CATEGORY_ID}    Id bottoms women not found
        END
    END

    IF    '${category_value}' == 'Gear'
        Mouse Over Element    ${GEAR_CATEGORY_ID}    Id gear not found
        IF    '${product_type_value}' == 'Bags'
            Wait Until Element Is Visible    xpath=//a[@id="${BAGS_GEAR_CATEGORY_ID}"]
            Mouse Over And Click Element    ${BAGS_GEAR_CATEGORY_ID}    Id bags not found
        END
        IF    '${product_type_value}' == 'Fitness Equipment'
            Wait Until Element Is Visible    xpath=//a[@id="${FITNESS_GEAR_CATEGORY_ID}"]
            Mouse Over And Click Element    ${FITNESS_GEAR_CATEGORY_ID}    Id fitness equipment not found
        END
        IF    '${product_type_value}' == 'Watches'
            Wait Until Element Is Visible    xpath=//a[@id="${WATCHES_GEAR_CATEGORY_ID}"]
            Mouse Over And Click Element    ${WATCHES_GEAR_CATEGORY_ID}    Id watches not found
        END
    END

Add Product To Cart By Color, Size And Price
    [Documentation]    Add the product to the cart based on the specified color and size

    ${value_visible}=    Run Keyword And Return Status    Get List Items    css:#limiter    values=True
    IF    not ${value_visible}    Fatal Error    Product Not Found

    ${values_webelement}=    Get WebElements    css:ul.items.pages-items li.item a.page
    ${values_list}=    Create List
    FOR    ${element}    IN    @{values_webelement}
        ${link}=    Get Element Attribute    ${element}    href
        Append To List    ${values_list}    ${link}
    END

    FOR    ${value}    IN    @{values_list}
        ${product_links}=    Get Product Links
        ${total_links}=    Get Length    ${product_links}

        ${count_empty_link}=    Set Variable    0

        FOR    ${index}    ${link}    IN ENUMERATE    @{product_links}
            ${status_code}=    Check Url Status    ${link}
            IF    '${link}' != ''
                IF    ${status_code}
                    Log    Link Product errors 404
                ELSE
                    Process To Product    ${link}
                END
            ELSE
                ${count_empty_link}=    Evaluate    ${count_empty_link}+1
            END

            IF    ${index} == ${total_links - 1}
                Go To    https://magento.softwaretestingboard.com/men/tops-men.html
            END
        END

        IF    ${count_empty_link} != 0
            Log    Have ${count_empty_link} Empty Link
        END

        Wait Until Element Is Visible    xpath://div[@class='toolbar toolbar-products']    10s
        Wait Until Element Is Visible    xpath://div[@class='toolbar toolbar-products']//div[@class='pages']    10s
        Wait Until Element Is Visible
        ...    xpath://div[@class='toolbar toolbar-products']//ul[contains(@class, 'items pages-items')]
        ...    10s
        ${check_last_page}=    Run Keyword And Return Status
        ...    Wait Until Element Is Visible    
        ...    xpath://div[@class='toolbar toolbar-products']//ul[contains(@class, 'items pages-items')]//li[contains(@class, 'pages-item-next')]
        ...    10s
        IF    not ${check_last_page}
            BREAK
        END
        Go To    ${value} 
    END

Process To Product
    [Documentation]    Go To Detail Product And Check Product By Size, Color And Price Then Add Product
    [Arguments]    ${link}
    Go To    ${link}
    ${check_product_to_cart}=    Check Product By Size, Color And Price
    IF    ${check_product_to_cart}
        Input Quantity Product
        Click Element    id:product-addtocart-button
    END

Go To Cart And Make A Payment
    [Documentation]    Proceeds to the checkout after adding products to the cart and saves the product information into an Excel file if the payment is successful

    Wait Until Element Is Not Visible    xpath://span[@class='counter qty empty']    timeout=5s
    ${check_cart}=    Run Keyword And Return Status
    ...    Wait Until Page Contains Element
    ...    xpath://a[@class='action showcart']//span[@class='counter qty']
    ...    timeout=5s
    IF    not ${check_cart}
        Fatal Error    Not Found Product In Cart To Payment
    END
    Click Element When Visible    xpath://a[@class='action showcart']

    Wait Until Element Is Visible    xpath://a[@class='action viewcart']    timeout=10s
    Click Element When Visible    xpath://a[@class='action viewcart']

    ${global_product_info}=    Save Infomation Product

    Click Button    xpath=//button[@data-role='proceed-to-checkout']

    Wait Until Element Is Not Visible    xpath://div[@id="checkout-shipping-method-load"]    timeout=5s
    Wait Until Element Is Visible    xpath://button[@data-role='opc-continue']    timeout=5s
    FOR    ${counter}    IN RANGE    0    3    1
        Click Element When Clickable    xpath://button[@data-role='opc-continue']
        ${timeout}=    Set Variable    10
        ${status_payment}=    Run Keyword And Return Status
        ...    Wait Until Element Is Visible
        ...    xpath://*[@id="checkout-payment-method-load"]/div/div/div[2]/div[2]/div[4]/div/button
        ...    timeout=${timeout}s

        ${timeout}=    Evaluate    ${timeout}+15
        IF    ${status_payment}    BREAK
    END

    FOR    ${counter}    IN RANGE    0    3    1
        Click Element When Clickable
        ...    xpath://*[@id="checkout-payment-method-load"]/div/div/div[2]/div[2]/div[4]/div/button
        ${timeout}=    Set Variable    10
        ${status_payment}=    Run Keyword And Return Status
        ...    Wait Until Element Is Visible
        ...    xpath://*[@id="maincontent"]/div[3]/div/div[2]/div/div/a
        ...    timeout=${timeout}s

        ${timeout}=    Evaluate    ${timeout}+15

        IF    ${status_payment}
            ${current_datetime}=    Get Current Date    result_format=%H:%M:%S %Y-%m-%d
            Set Global Variable    ${current_time}    ${current_datetime}
            ${order_info}=    Check Status Payment And Get Order Number
            BREAK
        END
    END

    IF    '${order_info['STATUS_PAYMENT']}' == 'True'
        Create File Excel Data
        FOR    ${product}    IN    @{global_product_info}
            Save Infomation By Excel Files
            ...    ${product}
            ...    ${order_info}[order_number]
            ...    ${color_product}
            ...    ${size_product}
            ...    ${current_time}
        END
        Save Workbook
    END

    ${file_path}=    Catenate    SEPARATOR=    ${DIRECTORY_PATH}    /    ${EXCEL_FILE_NAME}
    Set Out Arg    file_output    ${file_path}

Get Product Links
    [Documentation]    Retrieve the links of all products listed on the current page.
    @{product_elements}=    Get WebElements
    ...    css:ol.products.list.items.product-items li.item.product.product-item a.product.photo.product-item-photo
    @{product_links}=    Create List
    FOR    ${element}    IN    @{product_elements}
        ${link}=    Get Element Attribute    ${element}    href
        Append To List    ${product_links}    ${link}
    END
    RETURN    ${product_links}

Check Product By Size, Color And Price
    [Documentation]    Checks if the product matches the specified size, color, and price

    ${size}=    Get In Arg    size
    ${size_value}=    Set Variable    ${size}[value]
    Set Global Variable    ${size_product}    ${size_value}

    ${color}=    Get In Arg    color
    ${color_value}=    Set Variable    ${color}[value]
    Set Global Variable    ${color_product}    ${color_value}

    ${price_exists}=    Check Price Exists

    IF    ${price_exists}
        ${size_exists}=    Check Size Exists    ${size_value}
        IF    ${size_exists}
            ${color_exists}=    Check Color Exists    ${color_value}
            IF    not ${color_exists}    RETURN    ${False}
        END
    ELSE
        RETURN    ${False}
    END

    RETURN    ${True}

Check Size Exists
    [Documentation]    Verify if the specified size exists for the product
    [Arguments]    ${size}
    ${sizes}=    Get WebElements    css:.swatch-option.text
    ${size_found}=    Set Variable    ${FALSE}
    FOR    ${elem}    IN    @{sizes}
        ${value}=    Get Element Attribute    ${elem}    option-label
        IF    '${size}' == '${value}'
            ${size_found}=    Set Variable    ${TRUE}
            Click Element    ${elem}
            BREAK
        END
    END
    RETURN    ${size_found}

Check Price Exists
    [Documentation]    Verify if the product price falls within a specified range
    ${below_price}=    Get In Arg    below_price
    ${below_price_value}=    Set Variable    ${below_price}[value]

    ${above_price}=    Get In Arg    above_price
    ${above_price_value}=    Set Variable    ${above_price}[value]

    ${price}=    RPA.Browser.Selenium.Get Text
    ...    xpath://div[@class="product-info-main"]/div[@class="product-info-price"]/div/span/span/span/span
    ${price_value_money}=    Convert String To Money    ${price}

    ${price_found}=    Evaluate
    ...    ${below_price_value} < ${price_value_money} and ${price_value_money} < ${above_price_value}

    RETURN    ${price_found}

Check Color Exists
    [Documentation]    Verify if the specified color exists for the product
    [Arguments]    ${color}
    ${colors}=    Get WebElements    css:.swatch-option.color
    ${color_found}=    Set Variable    ${FALSE}
    FOR    ${element}    IN    @{colors}
        ${value_color}=    Get Element Attribute    ${element}    option-label
        IF    '${color}' == '${value_color}'
            ${color_found}=    Set Variable    ${TRUE}
            Click Element    ${element}
            BREAK
        END
    END
    RETURN    ${color_found}

Input Quantity Product
    [Documentation]    Enters the specified quantity of the product into the corresponding field on the webpage
    ${quantity}=    Get In Arg    quantity
    ${quantity_value}=    Set Variable    ${quantity}[value]

    Wait Until Element Is Visible    id:qty
    Input Text    id:qty    ${quantity_value}

Save Infomation Product
    [Documentation]    Temporarily stores the product information such as name, price, and quantity of each item in the shopping cart
    ${global_product_info}=    Create List
    Wait Until Element Is Visible    xpath://table[@id='shopping-cart-table']    timeout=30s
    ${tbody}=    Get Webelements    xpath://table[@id='shopping-cart-table']/tbody
    ${tbody_count}=    Get Length    ${tbody}
    FOR    ${tbody_rows}    IN RANGE    0    ${tbody_count}
        ${index}=    Evaluate    ${tbody_rows} + 1
        ${name_product}=    RPA.Browser.Selenium.Get Text
        ...    xpath://table[@id='shopping-cart-table']/tbody[${index}]/tr[1]/td[1]/div/strong

        ${price_product}=    RPA.Browser.Selenium.Get Text
        ...    xpath://table[@id='shopping-cart-table']/tbody[${index}]/tr[1]/td[2]/span/span/span

        ${quantity_product}=    Get Element Attribute
        ...    xpath://table[@id='shopping-cart-table']/tbody[${index}]/tr[1]/td[3]/div/div/label/input
        ...    value

        ${product_info}=    Create Dictionary
        ...    name_product=${name_product}
        ...    price_product=${price_product}
        ...    quantity_product=${quantity_product}
        Append To List    ${global_product_info}    ${product_info}
    END
    RETURN    ${global_product_info}

Check Status Payment And Get Order Number
    [Documentation]    Checks the payment status and retrieves the order number if the payment is successful
    ${is_visible}=    Run Keyword And Return Status
    ...    Element Should Be Visible
    ...    xpath://div[@class='checkout-success']
    ${STATUS_PAYMENT}=    Set Variable    ${is_visible}
    ${order_number}=    RPA.Browser.Selenium.Get Text    xpath=//div[@class='checkout-success']//p//a//strong
    ${order_info}=    Create Dictionary    order_number=${order_number}    STATUS_PAYMENT=${STATUS_PAYMENT}
    RETURN    ${order_info}

Create File Excel Data
    [Documentation]    Creates a new Excel file to store product information and order numbers
    Create Workbook    data_magento.xlsx
    Set Worksheet Value    1    1    Name
    Set Worksheet Value    1    2    Quantity
    Set Worksheet Value    1    3    Price
    Set Worksheet Value    1    4    Order Number
    Set Worksheet Value    1    5    Size
    Set Worksheet Value    1    6    Color
    Set Worksheet Value    1    7    Time

Save Infomation By Excel Files
    [Documentation]    Saves the information of each product along with the order number, color, and size into the Excel file
    [Arguments]    ${product}    ${order_number}    ${color}    ${size}    ${current_time}
    ${row}=    Create Dictionary
    ...    Name=${product['name_product']}
    ...    Price=${product['price_product']}
    ...    Quantity=${product['quantity_product']}
    ...    Order Number=${order_number}
    ...    Size=${size}
    ...    Color=${color}
    ...    Time=${current_time}
    Append Rows To Worksheet    ${row}    header=True
