import React from 'react';
import { motion } from 'framer-motion';
import WeatherIcon from './WeatherIcon';
import './DailyForecast.css';

const cardVariants = {
  hidden: { opacity: 0, y: 20 },
  visible: { opacity: 1, y: 0, transition: { duration: 0.5 } },
};

const DailyForecast = ({ data }) => {
  return (
    <motion.div className="daily-forecast-card dashboard-card glass glow" variants={cardVariants}>
      <h3 className="daily-title">7-Day Forecast</h3>
      <div className="daily-list">
        {data.map((day, index) => (
          <motion.div 
            className="day-item" 
            key={index}
            initial={{ opacity: 0, x: -20 }}
            animate={{ opacity: 1, x: 0 }}
            transition={{ delay: index * 0.1 }}
          >
            <span className="day-name">{new Date(day.date).toLocaleDateString('en-US', { weekday: 'short' })}</span>
            <WeatherIcon iconCode={day.icon} size={28} />
            <div className="day-temp">
              <span>{Math.round(day.temp_max)}°</span>
              <span className="temp-min">{Math.round(day.temp_min)}°</span>
            </div>
          </motion.div>
        ))}
      </div>
    </motion.div>
  );
};

export default DailyForecast; 