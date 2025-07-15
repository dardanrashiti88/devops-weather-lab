import React, { useState } from 'react';
import { motion } from 'framer-motion';
import { useWeather } from '../context/WeatherContext';
import CurrentWeather from './dashboard/CurrentWeather';
import HourlyForecast from './dashboard/HourlyForecast';
import DailyForecast from './dashboard/DailyForecast';
import WeatherDetails from './dashboard/WeatherDetails';
import AirQuality from './dashboard/AirQuality';
import UVIndex from './dashboard/UVIndex';
import WeatherAlerts from './dashboard/WeatherAlerts';
import FavoriteLocations from './dashboard/FavoriteLocations';
import WeatherHistory from './dashboard/WeatherHistory';
import './Dashboard.css';
import { jwtDecode } from 'jwt-decode';

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
  const [favorites, setFavorites] = useState([
    { id: 1, name: 'Pristina', country: 'Kosovo', currentWeather: { temp: 22, condition: 'Sunny', icon: '☀️' } },
    { id: 2, name: 'Gjilan', country: 'Kosovo', currentWeather: { temp: 20, condition: 'Partly Cloudy', icon: '⛅' } }
  ]);

  const handleCityChange = (e) => {
    setLocation(e.target.value);
  };

  const handleAddFavorite = (locationName) => {
    const newFavorite = {
      id: Date.now(),
      name: locationName,
      country: 'Kosovo',
      currentWeather: { temp: Math.floor(Math.random() * 30) + 10, condition: 'Unknown', icon: '🌤️' }
    };
    setFavorites([...favorites, newFavorite]);
  };

  const handleRemoveFavorite = (id) => {
    setFavorites(favorites.filter(fav => fav.id !== id));
  };

  const handleLocationSelect = (locationName) => {
    setLocation(locationName);
  };

  let username = 'Guest';
  const token = localStorage.getItem('token');
  if (token) {
    try {
      const decoded = jwtDecode(token);
      username = decoded.username;
    } catch {}
  }

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
    hidden: { opacity: 0, y: 24 },
    visible: {
      opacity: 1,
      y: 0,
      transition: {
        staggerChildren: 0.08,
        duration: 0.5,
        ease: 'easeInOut',
      },
    },
    exit: { opacity: 0, y: 24, transition: { duration: 0.3, ease: 'easeInOut' } },
  };

  return (
    <motion.div 
      className="dashboard"
      variants={containerVariants}
      initial="hidden"
      animate="visible"
      exit="exit"
    >
      <div style={{ marginBottom: '1rem', textAlign: 'left', fontWeight: 'bold', fontSize: '1.2rem' }}>
        Welcome, {username}!
      </div>
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
        <AirQuality data={weatherData.airQuality} />
        <UVIndex data={weatherData.uv} />
        <WeatherAlerts alerts={weatherData.alerts} />
        <FavoriteLocations 
          favorites={favorites}
          onLocationSelect={handleLocationSelect}
          onAddFavorite={handleAddFavorite}
          onRemoveFavorite={handleRemoveFavorite}
        />
        <WeatherHistory data={weatherData.history} />
      </div>
    </motion.div>
  );
};

export default Dashboard; 