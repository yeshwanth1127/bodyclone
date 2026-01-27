from flask import Flask, jsonify, request
from flask_cors import CORS
from datetime import datetime, timedelta
import random

app = Flask(__name__)
CORS(app)

# Sample health data storage (in production, use a database)
health_data = {
    'vitals': {
        'heart_rate': 72,
        'blood_pressure': {'systolic': 120, 'diastolic': 80},
        'temperature': 98.6,
        'oxygen_saturation': 98,
        'last_updated': datetime.now().isoformat()
    },
    'reports': [
        {
            'id': 1,
            'type': 'Blood Test',
            'date': (datetime.now() - timedelta(days=7)).isoformat(),
            'status': 'Normal',
            'summary': 'All parameters within normal range'
        },
        {
            'id': 2,
            'type': 'ECG',
            'date': (datetime.now() - timedelta(days=14)).isoformat(),
            'status': 'Normal',
            'summary': 'Regular rhythm, no abnormalities detected'
        }
    ],
    'medication': [
        {
            'id': 1,
            'name': 'Vitamin D',
            'dosage': '1000 IU',
            'frequency': 'Once daily',
            'next_dose': (datetime.now() + timedelta(hours=8)).isoformat(),
            'status': 'active'
        },
        {
            'id': 2,
            'name': 'Multivitamin',
            'dosage': '1 tablet',
            'frequency': 'Once daily',
            'next_dose': (datetime.now() + timedelta(hours=8)).isoformat(),
            'status': 'active'
        }
    ],
    'consultations': [
        {
            'id': 1,
            'doctor': 'Dr. Sarah Johnson',
            'specialty': 'General Medicine',
            'date': (datetime.now() + timedelta(days=5)).isoformat(),
            'status': 'scheduled',
            'notes': 'Annual checkup'
        }
    ],
    'avatar_mood': 'calm'
}

@app.route('/')
def health_check():
    return jsonify({'status': 'ok', 'message': 'BodyClone API is running'})

@app.route('/api/health')
def api_health():
    return jsonify({'status': 'healthy'})

# Health Metrics Endpoints
@app.route('/api/vitals', methods=['GET'])
def get_vitals():
    """Get current vital signs"""
    # Simulate slight variations in real-time data
    vitals = health_data['vitals'].copy()
    vitals['heart_rate'] = random.randint(68, 76)
    vitals['temperature'] = round(random.uniform(98.2, 98.8), 1)
    vitals['last_updated'] = datetime.now().isoformat()
    return jsonify(vitals)

@app.route('/api/reports', methods=['GET'])
def get_reports():
    """Get medical reports"""
    return jsonify({
        'reports': health_data['reports'],
        'count': len(health_data['reports'])
    })

@app.route('/api/medication', methods=['GET'])
def get_medication():
    """Get medication schedule"""
    return jsonify({
        'medications': health_data['medication'],
        'count': len(health_data['medication'])
    })

@app.route('/api/consultations', methods=['GET'])
def get_consultations():
    """Get upcoming consultations"""
    return jsonify({
        'consultations': health_data['consultations'],
        'count': len(health_data['consultations'])
    })

@app.route('/api/avatar/mood', methods=['GET'])
def get_avatar_mood():
    """Get current avatar mood state"""
    return jsonify({
        'mood': health_data['avatar_mood'],
        'timestamp': datetime.now().isoformat()
    })

@app.route('/api/avatar/mood', methods=['POST'])
def set_avatar_mood():
    """Update avatar mood state"""
    data = request.get_json()
    if 'mood' in data:
        health_data['avatar_mood'] = data['mood']
        return jsonify({
            'mood': health_data['avatar_mood'],
            'message': 'Avatar mood updated successfully'
        })
    return jsonify({'error': 'Mood parameter required'}), 400

@app.route('/api/health/summary', methods=['GET'])
def get_health_summary():
    """Get overall health summary"""
    return jsonify({
        'vitals': health_data['vitals'],
        'reports_count': len(health_data['reports']),
        'medications_count': len(health_data['medication']),
        'consultations_count': len(health_data['consultations']),
        'avatar_mood': health_data['avatar_mood'],
        'overall_status': 'Good',
        'last_updated': datetime.now().isoformat()
    })

if __name__ == '__main__':
    app.run(debug=True, host='0.0.0.0', port=5000)

