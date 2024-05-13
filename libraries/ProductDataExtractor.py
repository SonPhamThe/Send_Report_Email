from RPA.Excel.Files import Files
from RPA.Tables import Tables

class ProductDataExtractor:
    def extract_product_data(self, excel):
        files = Files()
        workbook = files.open_workbook(excel)
        rows = workbook.read_worksheet(header=True)

        tables = Tables()
        table = tables.create_table(rows)

        table = [row for row in table if any(row.values())]

        products_data = []
        for row in table:
            above_price, below_price = row["Price Range"].split()
            product_data = {
                "category": row["Category"],
                "products_type": row["Products Type"],
                "details_type": row["Details Type"],
                "size": row["Size"],
                "colors": row["Colors"],
                "above_price": int(above_price),
                "below_price": int(below_price)
            }
            products_data.append(product_data)

        return products_data
