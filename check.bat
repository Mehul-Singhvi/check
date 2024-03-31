import requests
from bs4 import BeautifulSoup

def check_for_vulnerabilities(url):
    try:
        response = requests.get(url)
        response.raise_for_status()  

        soup = BeautifulSoup(response.text, 'html.parser')

        vulnerabilities = []

        forms = soup.find_all('form')
        if forms:
            vulnerabilities.append("Website contains forms. Consider checking for XSS, CSRF, etc.")

        meta_tags = soup.find_all('meta', {'name': 'generator'})
        for tag in meta_tags:
            if 'WordPress' in tag.get('content', ''):
                vulnerabilities.append("WordPress detected. Ensure it's updated to the latest version.")

        http_links = soup.find_all('a', href=lambda href: href and href.startswith('http://'))
        if http_links:
            vulnerabilities.append("Insecure HTTP links found. Consider switching to HTTPS.")


        if vulnerabilities:
            print("Vulnerabilities found:")
            for vuln in vulnerabilities:
                print("-", vuln)
        else:
            print("No vulnerabilities found.")

    except requests.exceptions.RequestException as e:
        print("Error:", e)
        
if __name__ == "__main__":
    website_url = input("Enter the URL of the website to check: ")
    check_for_vulnerabilities(website_url)
