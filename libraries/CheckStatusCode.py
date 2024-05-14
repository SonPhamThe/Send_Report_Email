import requests

class CheckStatusCode:
    @staticmethod
    def check_url_status(url):
        response = requests.get(url)
        if response.status_code == 404:
            return True
        else:
            return False