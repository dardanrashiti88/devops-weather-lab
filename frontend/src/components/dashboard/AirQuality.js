import React from 'react';
import { motion } from 'framer-motion';
import { Wind, AlertTriangle, CheckCircle } from 'lucide-react';
import './AirQuality.css';

const AirQuality = ({ data }) => {
  const getAQICategory = (aqi) => {
    if (aqi <= 50) return { level: 'Good', color: '#10B981', icon: <CheckCircle size={20} />, description: 'Air quality is satisfactory' };
    if (aqi <= 100) return { level: 'Moderate', color: '#F59E0B', icon: <Wind size={20} />, description: 'Some pollutants may be present' };
    if (aqi <= 150) return { level: 'Unhealthy for Sensitive Groups', color: '#F97316', icon: <AlertTriangle size={20} />, description: 'Members of sensitive groups may experience health effects' };
    if (aqi <= 200) return { level: 'Unhealthy', color: '#EF4444', icon: <AlertTriangle size={20} />, description: 'Everyone may begin to experience health effects' };
    if (aqi <= 300) return { level: 'Very Unhealthy', color: '#8B5CF6', icon: <AlertTriangle size={20} />, description: 'Health warnings of emergency conditions' };
    return { level: 'Hazardous', color: '#7F1D1D', icon: <AlertTriangle size={20} />, description: 'Health alert: everyone may experience more serious health effects' };
  };

  const getRecommendations = (aqi) => {
    if (aqi <= 50) return ['Enjoy outdoor activities', 'Good time for outdoor exercise', 'No restrictions needed'];
    if (aqi <= 100) return ['Consider reducing outdoor activities', 'Sensitive individuals should limit outdoor time', 'Monitor air quality updates'];
    if (aqi <= 150) return ['Limit outdoor activities', 'Sensitive groups should stay indoors', 'Consider wearing a mask outdoors'];
    if (aqi <= 200) return ['Avoid outdoor activities', 'Stay indoors as much as possible', 'Use air purifiers indoors'];
    if (aqi <= 300) return ['Stay indoors', 'Avoid all outdoor activities', 'Consider evacuation if necessary'];
    return ['Stay indoors', 'Emergency conditions', 'Follow local health advisories'];
  };

  const category = getAQICategory(data?.aqi || 0);
  const recommendations = getRecommendations(data?.aqi || 0);

  return (
    <motion.div
      className="air-quality-card"
      initial={{ opacity: 0, y: 24 }}
      animate={{ opacity: 1, y: 0 }}
      exit={{ opacity: 0, y: 24 }}
      transition={{ duration: 0.5, ease: 'easeInOut' }}
    >
      <div className="card-header">
        <h3>Air Quality</h3>
        <div className="aqi-indicator" style={{ backgroundColor: category.color }}>
          {category.icon}
        </div>
      </div>
      
      <div className="aqi-main">
        <div className="aqi-value" style={{ color: category.color }}>
          {data?.aqi || 'N/A'}
        </div>
        <div className="aqi-level">{category.level}</div>
      </div>
      
      <div className="aqi-description">
        {category.description}
      </div>
      
      <div className="aqi-details">
        <div className="detail-item">
          <span>PM2.5:</span>
          <span>{data?.pm25 || 'N/A'} µg/m³</span>
        </div>
        <div className="detail-item">
          <span>PM10:</span>
          <span>{data?.pm10 || 'N/A'} µg/m³</span>
        </div>
        <div className="detail-item">
          <span>O₃:</span>
          <span>{data?.o3 || 'N/A'} ppb</span>
        </div>
        <div className="detail-item">
          <span>NO₂:</span>
          <span>{data?.no2 || 'N/A'} ppb</span>
        </div>
      </div>
      
      <div className="recommendations">
        <h4>Recommendations:</h4>
        <ul>
          {recommendations.map((rec, index) => (
            <motion.li
              key={index}
              initial={{ opacity: 0, x: -10 }}
              animate={{ opacity: 1, x: 0 }}
              transition={{ delay: index * 0.1 }}
            >
              {rec}
            </motion.li>
          ))}
        </ul>
      </div>
    </motion.div>
  );
};

export default AirQuality; 