class ConvertString:
    @staticmethod
    def convert_string_to_money(price):
        if '$' in price:
            price = price.replace('$', '')
            return float(price)

    @staticmethod
    def conver_data_to_search_product(input_string):
        lower_case_string = input_string.lower()
        result_string = lower_case_string.capitalize()
        return result_string