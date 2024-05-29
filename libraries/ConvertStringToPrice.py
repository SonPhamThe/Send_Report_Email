class ConvertStringToPrice:
    @staticmethod
    def convert_string_to_money(price):
        if '$' in price:
            price = price.replace('$', '')
            return float(price)