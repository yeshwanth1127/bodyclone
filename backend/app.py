from flask import Flask
from flask_cors import CORS

app = Flask(__name__)
CORS(app)

@app.route('/')
def health_check():
    return {'status': 'ok', 'message': 'BodyClone API is running'}

@app.route('/api/health')
def api_health():
    return {'status': 'healthy'}

if __name__ == '__main__':
    app.run(debug=True, host='0.0.0.0', port=5000)

