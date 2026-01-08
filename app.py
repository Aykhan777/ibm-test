from flask import Flask
app = Flask(__name__)

@app.route("/")
def home():
    return "<h1>Hello from Flask App12345</h1><p>Index3 page</p>"

if __name__ == "__main__":
    app.run(host="0.0.0.0", port=5000)

