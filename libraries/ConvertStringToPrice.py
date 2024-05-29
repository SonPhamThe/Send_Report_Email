class ConvertStringToPrice:
    @staticmethod
    def convert_string_to_price(price):
        if '$' in price:
            price = price.replace('$', '')
            return float(price)
