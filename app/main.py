from flask import Flask

# Create an instance of the Flask class
app = Flask(__name__)

# Define a "route" for the home page URL ("/")
@app.route('/')
def hello_world():
    # When a user visits the home page, return this string
    return 'Hello from inside a Kubernetes Pod!'

# This block ensures the app runs when the script is executed
if __name__ == '__main__':
    # host='0.0.0.0' makes the server accessible from outside the container
    # port=5000 is the port the server will listen on
    app.run(host='0.0.0.0', port=5000)