import React from 'react';
import { Sun, Moon, Cloud, CloudSun, CloudMoon, CloudRain, CloudSnow, CloudLightning, Wind } from 'lucide-react';

const iconMap = {
  '01d': Sun,
  '01n': Moon,
  '02d': CloudSun,
  '02n': CloudMoon,
  '03d': Cloud,
  '03n': Cloud,
  '04d': Cloud,
  '04n': Cloud,
  '09d': CloudRain,
  '09n': CloudRain,
  '10d': CloudRain,
  '10n': CloudRain,
  '11d': CloudLightning,
  '11n': CloudLightning,
  '13d': CloudSnow,
  '13n': CloudSnow,
  '50d': Wind,
  '50n': Wind,
};

const WeatherIcon = ({ iconCode, size = 24, ...props }) => {
  const Icon = iconMap[iconCode] || Sun; // Default to Sun icon
  return <Icon size={size} {...props} />;
};

export default WeatherIcon; 