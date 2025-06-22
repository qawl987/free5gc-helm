from flask import Flask
import requests

url = "http://10.0.2.7/v1/register"

headers = {
    "accept": "application/json",
    "Content-Type": "application/json"
}

payload = {
    "uid": "second_mec_app_uid",
    "description": "This is a service of the second mec app.",
    "host": "10.0.2.107",
    "name": "second_mec_app",
    "path": "/v1",
    "port": 80,
    "type": "Traffic",
    "endpoints": [
        {
            "method": "GET",
            "name": "first_web_page_api",
            "path": "/first_web_page"
        },
        {
            "method": "GET",
            "name": "second_web_page_api",
            "path": "/second_web_page"
        }
    ]
}

response = requests.post(url, headers = headers, json = payload)

app = Flask(__name__)

@app.route('/v1/ui')
def GetUi():
    return '''
        <html>
            <head><title>My Simple Server</title></head>
            <body>
                <h1>Second MEC App</h1>
                <p>The Second MEC App UI</p>
            </body>
        </html>
    '''

@app.route('/v1/first_web_page')
def GetFirstWebPage():
    return '''
        <html>
            <head><title>My Simple Server</title></head>
            <body>
                <h1>Second MEC App</h1>
                <p>You have already used the API of the first web page.</p>
            </body>
        </html>
    '''

@app.route('/v1/second_web_page')
def GetSecondWebPage():
    return '''
        <html>
            <head><title>My Simple Server</title></head>
            <body>
                <h1>Second MEC App</h1>
                <p>You have already used the API of the second web page.</p>
            </body>
        </html>
    '''

if __name__ == '__main__':
    app.run(host = '10.0.2.107', port = 80)