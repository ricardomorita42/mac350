import os
from flask import Flask,request
from flask_sqlalchemy import SQLAlchemy

app = Flask(__name__)

app.config.from_object(os.environ['APP_SETTINGS'])
app.config['SQLALCHEMY_TRACK_MODIFICATIONS'] = False
db = SQLAlchemy(app)

import models 

@app.route('/')
def main():
    return 'hello world!'

#if __name__ == '__main__':
#    app.run(debug=True)
