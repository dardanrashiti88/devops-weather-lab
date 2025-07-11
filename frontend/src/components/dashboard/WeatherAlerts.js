import React from 'react';
import { motion } from 'framer-motion';
import { AlertTriangle, AlertCircle, Info, Bell } from 'lucide-react';
import './WeatherAlerts.css';

const WeatherAlerts = ({ alerts }) => {
  const getAlertSeverity = (severity) => {
    switch (severity?.toLowerCase()) {
      case 'extreme':
        return { color: '#DC2626', icon: <AlertTriangle size={20} />, bgColor: '#FEE2E2' };
      case 'severe':
        return { color: '#EA580C', icon: <AlertTriangle size={20} />, bgColor: '#FED7AA' };
      case 'moderate':
        return { color: '#D97706', icon: <AlertCircle size={20} />, bgColor: '#FEF3C7' };
      case 'minor':
        return { color: '#059669', icon: <Info size={20} />, bgColor: '#D1FAE5' };
      default:
        return { color: '#6B7280', icon: <Bell size={20} />, bgColor: '#F3F4F6' };
    }
  };

  const getAlertIcon = (event) => {
    const eventLower = event?.toLowerCase() || '';
    if (eventLower.includes('storm') || eventLower.includes('thunder')) return '⛈️';
    if (eventLower.includes('rain') || eventLower.includes('flood')) return '🌧️';
    if (eventLower.includes('snow') || eventLower.includes('ice')) return '❄️';
    if (eventLower.includes('wind')) return '💨';
    if (eventLower.includes('heat')) return '🔥';
    if (eventLower.includes('cold')) return '🥶';
    if (eventLower.includes('fog')) return '🌫️';
    return '⚠️';
  };

  if (!alerts || alerts.length === 0) {
    return (
      <motion.div
        className="weather-alerts-card"
        initial={{ opacity: 0, y: 24 }}
        animate={{ opacity: 1, y: 0 }}
        exit={{ opacity: 0, y: 24 }}
        transition={{ duration: 0.5, ease: 'easeInOut' }}
      >
        <div className="card-header">
          <h3>Weather Alerts</h3>
          <div className="alert-indicator no-alerts">
            <Bell size={20} />
          </div>
        </div>
        
        <div className="no-alerts-message">
          <div className="no-alerts-icon">✅</div>
          <h4>No Active Alerts</h4>
          <p>Weather conditions are normal in your area.</p>
        </div>
      </motion.div>
    );
  }

  return (
    <motion.div
      className="weather-alerts-card"
      initial={{ opacity: 0, y: 24 }}
      animate={{ opacity: 1, y: 0 }}
      exit={{ opacity: 0, y: 24 }}
      transition={{ duration: 0.5, ease: 'easeInOut' }}
    >
      <div className="card-header">
        <h3>Weather Alerts</h3>
        <div className="alert-indicator active">
          <AlertTriangle size={20} />
        </div>
      </div>
      
      <div className="alerts-list">
        {alerts.map((alert, index) => {
          const severity = getAlertSeverity(alert.severity);
          const icon = getAlertIcon(alert.event);
          
          return (
            <motion.div
              key={index}
              className="alert-item"
              style={{ borderLeftColor: severity.color }}
              initial={{ opacity: 0, x: -20 }}
              animate={{ opacity: 1, x: 0 }}
              transition={{ delay: index * 0.1 }}
            >
              <div className="alert-header">
                <div className="alert-icon">{icon}</div>
                <div className="alert-info">
                  <h4>{alert.event}</h4>
                  <span className="alert-severity" style={{ color: severity.color }}>
                    {alert.severity}
                  </span>
                </div>
                <div className="alert-severity-icon" style={{ color: severity.color }}>
                  {severity.icon}
                </div>
              </div>
              
              <div className="alert-description">
                {alert.description}
              </div>
              
              <div className="alert-details">
                <div className="detail-item">
                  <span>Effective:</span>
                  <span>{alert.effective}</span>
                </div>
                <div className="detail-item">
                  <span>Expires:</span>
                  <span>{alert.expires}</span>
                </div>
                <div className="detail-item">
                  <span>Areas:</span>
                  <span>{alert.areas}</span>
                </div>
              </div>
              
              {alert.instructions && (
                <div className="alert-instructions">
                  <h5>Instructions:</h5>
                  <p>{alert.instructions}</p>
                </div>
              )}
            </motion.div>
          );
        })}
      </div>
    </motion.div>
  );
};

export default WeatherAlerts; 