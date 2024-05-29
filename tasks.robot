*** Settings ***
Documentation       Sending plain text email via gmail

Library             RPA.Email.ImapSmtp    smtp_server=smtp.gmail.com    smtp_port=587
Library             DOP.RPA.ProcessArgument
Library             Collections
Library             DOP.RPA.Log
Library             DOP.RPA.Asset
Library             OperatingSystem
Library             RPA.Excel.Files
Library             String
Library             ConvertStringToPrice
Library             RPA.JSON


*** Variables ***
@{REPLACE_VARIABLES}                    total_quantity_purchased    total_amount    payment_order    where_buy
${total_quantity_purchased_value}       ${EMPTY}
${total_amount_value}                   ${EMPTY}
${payment_order_value}                  ${EMPTY}
${where_buy_value}                      "Magento Website"


*** Tasks ***
Send Email
    [Documentation]    Send Result Report Via Email To Recipients Address Email

    ${gmail_account_credentials}=    Get Asset    gmail_account
    ${gmail_account_credentials}=    Set Variable    ${gmail_account_credentials}[value]
    ${gmail_account_credentials}=    Convert String to JSON    ${gmail_account_credentials}
    ${username}=    Set Variable    ${gmail_account_credentials}[username]
    ${password}=    Set Variable    ${gmail_account_credentials}[password]

    Authorize    account=${username}    password=${password}

    ${recipients}=    Get In Arg    recipients_email_address
    ${recipients_value}=    Set Variable    ${recipients}[value]
    ${recipient_value_list}=    Split String    ${recipients_value}    ,
    @{list_recipient}=    Create List    
    FOR    ${recipient}    IN    @{recipient_value_list}
        Append To List    ${list_recipient}    ${recipient}
    END

    ${url_file_excel}=    Get In Arg    file_output
    ${url_file_excel_value}=    Set Variable    ${url_file_excel}[value]

    Open Workbook    ${url_file_excel_value}
    ${excel_data}=    Read Worksheet As Table    header=True
    Close Workbook

    ${quantity_product}=    Set Variable    0
    ${price_product}=    Set Variable    0
    FOR    ${excel}    IN    @{excel_data}
        ${quantity}=    Get From Dictionary    ${excel}    Quantity
        ${price}=    Get From Dictionary    ${excel}    Price
        ${order_number}=    Get From Dictionary    ${excel}    Order Number
        Set Global Variable    ${payment_order_value}    ${order_number}
        ${price_value}=    Convert String To Price    ${price}
        ${quantity_product}=    Evaluate    ${quantity_product} + ${quantity}
        ${price_product}=    Evaluate    ${price_product} + ${price_value}
    END
    Set Global Variable    ${total_quantity_purchased_value}    ${quantity_product}
    Set Global Variable    ${total_amount_value}    ${price_product}

    ${url_file_text}=    Get In Arg    email_body
    ${url_file_text_value}=    Set Variable    ${url_file_text}[value]
    ${email_body}=    Get File    ${url_file_text_value}

    ${replacements}=    Create Dictionary
    ...    total_quantity_purchased=${total_quantity_purchased_value}
    ...    total_amount=${total_amount_value}
    ...    payment_order=${payment_order_value}
    ...    where_buy=${where_buy_value}

    FOR    ${key}    ${value}    IN    &{replacements}
        ${value_str}=    Convert To String    ${value}
        ${email_body}=    Replace String    ${email_body}    ${key}    ${value_str}
    END

    Create File    ${url_file_text_value}    ${email_body}

    RPA.Email.ImapSmtp.Send Message    sender=${username}
    ...    recipients=${list_recipient}
    ...    subject=Send Result Report Via Email By Infomation Of Product Magento
    ...    body=${email_body}
    ...    attachments=${url_file_excel_value}

    ${email_body}=    Get File    ${url_file_text_value}
    ${replacements}=    Create Dictionary
    ...    ${total_quantity_purchased_value}=total_quantity_purchased
    ...    ${total_amount_value}=total_amount
    ...    ${payment_order_value}=payment_order
    ...    ${where_buy_value}=where_buy

    FOR    ${key}    ${value}    IN    &{replacements}
        ${key_str}=    Convert To String    ${key}
        ${value_str}=    Convert To String    ${value}
        ${email_body}=    Replace String    ${email_body}    ${key_str}    ${value_str}
    END

    Create File    ${url_file_text_value}    ${email_body}
