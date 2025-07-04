import React from 'react';
import { motion } from 'framer-motion';
import { useWeather } from '../context/WeatherContext';
import CurrentWeather from './dashboard/CurrentWeather';
import HourlyForecast from './dashboard/HourlyForecast';
import DailyForecast from './dashboard/DailyForecast';
import WeatherDetails from './dashboard/WeatherDetails';
import './Dashboard.css';

const cities = [
  { name: 'Gjilan', country: 'XK' },
  { name: 'Pristina', country: 'XK' },
  { name: 'Prizren', country: 'XK' },
  { name: 'Peja', country: 'XK' },
  { name: 'Ferizaj', country: 'XK' },
  { name: 'Mitrovica', country: 'XK' },
];

const Dashboard = () => {
  const { weatherData, isLoading, error, currentLocation, setLocation } = useWeather();

  const handleCityChange = (e) => {
    setLocation(e.target.value);
  };

  if (isLoading) {
    return <div className="loading">Loading dashboard...</div>;
  }

  if (error) {
    return <div className="error">Error: {error}</div>;
  }

  if (!weatherData) {
    return <div>No weather data available.</div>;
  }

  const containerVariants = {
    hidden: { opacity: 0 },
    visible: {
      opacity: 1,
      transition: {
        staggerChildren: 0.1,
      },
    },
  };

  return (
    <motion.div 
      className="dashboard"
      variants={containerVariants}
      initial="hidden"
      animate="visible"
    >
      <div style={{ marginBottom: '1rem', textAlign: 'right' }}>
        <select value={currentLocation} onChange={handleCityChange} style={{ padding: '0.5rem', borderRadius: '8px', fontSize: '1rem' }}>
          {cities.map(city => (
            <option key={city.name} value={city.name}>{city.name}</option>
          ))}
        </select>
      </div>
      <div className="main-grid">
        <CurrentWeather data={weatherData.current} location={weatherData.location} />
        <HourlyForecast data={weatherData.hourly} />
        <DailyForecast data={weatherData.daily} />
        <WeatherDetails data={weatherData.current} />
      </div>
    </motion.div>
  );
};

export default Dashboard; 