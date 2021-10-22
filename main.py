import argparse
from flask import Flask, jsonify

app = Flask(__name__)
app.config.update(
    SESSION_COOKIE_SECURE=True,
    SESSION_COOKIE_HTTPONLY=True,
    SESSION_COOKIE_SAMESITE='Lax',
)


def get_authormessage(ser_name, name):
    return f"Made with {ser_name} by {name}"


def processrequest():
    response = jsonify(id=1, message="HelloWorld from Python")
    return response


@app.route("/", methods=['GET', 'POST'])
def httproot():
    return processrequest()


def runhttp():
    print("Running http")
    app.run(host=args.host, port=args.port, threaded=True, debug=False)


if __name__ == '__main__':
    parser = argparse.ArgumentParser(prog="AwesomeZoo Flask Application")
    parser.add_argument('-s', '--source', help=' Change emogipedia data source. ',
                        type=str, default='https://emojipedia.org/nature/')
    parser.add_argument('-H', '--host', help=' Change application host ',
                        type=str, default='0.0.0.0')
    parser.add_argument('-p', '--port', help=' Change listening post', type=int,
                        default=8080)
    args = parser.parse_args()
    runhttp()
