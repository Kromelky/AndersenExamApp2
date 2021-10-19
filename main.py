from flask import Flask, request, jsonify
import argparse


app = Flask(__name__)
app.config.update(
    SESSION_COOKIE_SECURE=True,
    SESSION_COOKIE_HTTPONLY=True,
    SESSION_COOKIE_SAMESITE='Lax',
)


def get_AuthorMessage(ser_name, name):
    return f"Made with {ser_name} by {name}"


def processRequest(req):
    response = jsonify(id=1, message="HelloWorld From Python")
    return response


@app.route("/", methods=['GET', 'POST'])
def httpRoot():
    return processRequest(request)


def runHttp():
    print("Running http")
    app.run(host=args.host, port=args.port, threaded=True, debug=Flase)


if __name__ == '__main__':
    parser = argparse.ArgumentParser(prog="AwesomeZoo Flask Application")
    parser.add_argument('-s', '--source', help=' Change emogipedia data source. ', type=str, default='https://emojipedia.org/nature/')
    parser.add_argument('-H', '--host', help=' Change application host ', type=str, default='0.0.0.0')
    parser.add_argument('-p', '--port', help=' Change listening post', type=int,
                        default=8080)
    args = parser.parse_args()
    runHttp()


