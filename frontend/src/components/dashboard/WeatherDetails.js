import React from 'react';
import { motion } from 'framer-motion';
import { Droplet, Wind, Compass, Eye, Sunrise, Sunset, Thermometer } from 'lucide-react';
import './WeatherDetails.css';

const cardVariants = {
  hidden: { opacity: 0, y: 20 },
  visible: { opacity: 1, y: 0, transition: { duration: 0.5 } },
};

const InfoCard = ({ icon, title, value, unit }) => (
  <div className="info-card glass">
    <div className="info-card-header">
      {icon}
      <span>{title}</span>
    </div>
    <div className="info-card-value">
      {value} <span className="unit">{unit}</span>
    </div>
  </div>
);

const WeatherDetails = ({ data }) => {
  return (
    <motion.div className="weather-details-card dashboard-card" variants={cardVariants}>
      <h3 className="details-title">Weather Details</h3>
      <div className="details-grid">
        <InfoCard icon={<Droplet size={20} />} title="Humidity" value={data.humidity} unit="%" />
        <InfoCard icon={<Wind size={20} />} title="Wind Speed" value={data.wind_speed} unit="km/h" />
        <InfoCard icon={<Compass size={20} />} title="Pressure" value={data.pressure} unit="hPa" />
        <InfoCard icon={<Eye size={20} />} title="Visibility" value={data.visibility / 1000} unit="km" />
        <InfoCard icon={<Thermometer size={20} />} title="UV Index" value={data.uv_index} unit="" />
        <InfoCard icon={<Sunrise size={20} />} title="Sunrise" value={data.sunrise} unit="AM" />
        <InfoCard icon={<Sunset size={20} />} title="Sunset" value={data.sunset} unit="PM" />
      </div>
    </motion.div>
  );
};

export default WeatherDetails; 