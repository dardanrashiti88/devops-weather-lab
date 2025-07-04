import React from 'react';
import { motion } from 'framer-motion';
import { MapPin } from 'lucide-react';
import WeatherIcon from './WeatherIcon';
import './CurrentWeather.css';

const cardVariants = {
  hidden: { opacity: 0, y: 20 },
  visible: { opacity: 1, y: 0, transition: { duration: 0.5 } },
};

const CurrentWeather = ({ data, location }) => {
  return (
    <motion.div className="current-weather-card dashboard-card glass glow" variants={cardVariants}>
      <div className="location-header">
        <MapPin size={18} />
        <h2>{location.name}, {location.country}</h2>
      </div>
      <div className="weather-main">
        <WeatherIcon iconCode={data.icon} size={80} />
        <div className="temperature">
          {Math.round(data.temp)}°
        </div>
      </div>
      <div className="weather-description">
        <h3>{data.description}</h3>
        <p>Feels like {Math.round(data.feels_like)}°</p>
      </div>
    </motion.div>
  );
};

export default CurrentWeather; 