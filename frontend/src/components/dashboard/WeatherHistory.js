import React from 'react';
import { motion } from 'framer-motion';
import { LineChart, Line, XAxis, YAxis, CartesianGrid, Tooltip, ResponsiveContainer } from 'recharts';
import { TrendingUp, Calendar } from 'lucide-react';
import './WeatherHistory.css';

const WeatherHistory = ({ data }) => {
  // Sample historical data - in a real app, this would come from the API
  const historicalData = [
    { date: 'Mon', temp: 22, humidity: 65, pressure: 1013 },
    { date: 'Tue', temp: 24, humidity: 60, pressure: 1012 },
    { date: 'Wed', temp: 26, humidity: 55, pressure: 1010 },
    { date: 'Thu', temp: 23, humidity: 70, pressure: 1014 },
    { date: 'Fri', temp: 21, humidity: 75, pressure: 1015 },
    { date: 'Sat', temp: 19, humidity: 80, pressure: 1016 },
    { date: 'Sun', temp: 18, humidity: 85, pressure: 1017 },
  ];

  const CustomTooltip = ({ active, payload, label }) => {
    if (active && payload && payload.length) {
      return (
        <div className="custom-tooltip">
          <p className="label">{`Date: ${label}`}</p>
          <p className="temp">{`Temperature: ${payload[0].value}°C`}</p>
          <p className="humidity">{`Humidity: ${payload[1].value}%`}</p>
          <p className="pressure">{`Pressure: ${payload[2].value} hPa`}</p>
        </div>
      );
    }
    return null;
  };

  return (
    <motion.div
      className="weather-history-card"
      initial={{ opacity: 0, y: 24 }}
      animate={{ opacity: 1, y: 0 }}
      exit={{ opacity: 0, y: 24 }}
      transition={{ duration: 0.5, ease: 'easeInOut' }}
    >
      <div className="card-header">
        <h3>Weather History</h3>
        <div className="history-indicator">
          <TrendingUp size={20} />
        </div>
      </div>
      
      <div className="chart-container">
        <ResponsiveContainer width="100%" height={200}>
          <LineChart data={historicalData}>
            <CartesianGrid strokeDasharray="3 3" stroke="rgba(255, 255, 255, 0.1)" />
            <XAxis 
              dataKey="date" 
              stroke="rgba(255, 255, 255, 0.6)"
              fontSize={12}
            />
            <YAxis 
              stroke="rgba(255, 255, 255, 0.6)"
              fontSize={12}
            />
            <Tooltip content={<CustomTooltip />} />
            <Line 
              type="monotone" 
              dataKey="temp" 
              stroke="#00d4ff" 
              strokeWidth={3}
              dot={{ fill: '#00d4ff', strokeWidth: 2, r: 4 }}
              activeDot={{ r: 6, stroke: '#00d4ff', strokeWidth: 2, fill: '#ffffff' }}
            />
            <Line 
              type="monotone" 
              dataKey="humidity" 
              stroke="#10B981" 
              strokeWidth={2}
              dot={{ fill: '#10B981', strokeWidth: 2, r: 3 }}
              activeDot={{ r: 5, stroke: '#10B981', strokeWidth: 2, fill: '#ffffff' }}
            />
            <Line 
              type="monotone" 
              dataKey="pressure" 
              stroke="#F59E0B" 
              strokeWidth={2}
              dot={{ fill: '#F59E0B', strokeWidth: 2, r: 3 }}
              activeDot={{ r: 5, stroke: '#F59E0B', strokeWidth: 2, fill: '#ffffff' }}
            />
          </LineChart>
        </ResponsiveContainer>
      </div>
      
      <div className="chart-legend">
        <div className="legend-item">
          <div className="legend-color" style={{ backgroundColor: '#00d4ff' }}></div>
          <span>Temperature (°C)</span>
        </div>
        <div className="legend-item">
          <div className="legend-color" style={{ backgroundColor: '#10B981' }}></div>
          <span>Humidity (%)</span>
        </div>
        <div className="legend-item">
          <div className="legend-color" style={{ backgroundColor: '#F59E0B' }}></div>
          <span>Pressure (hPa)</span>
        </div>
      </div>
      
      <div className="history-summary">
        <div className="summary-item">
          <Calendar size={16} />
          <span>7-day trend</span>
        </div>
        <div className="summary-item">
          <span>Avg Temp: 22°C</span>
        </div>
        <div className="summary-item">
          <span>Avg Humidity: 70%</span>
        </div>
      </div>
    </motion.div>
  );
};

export default WeatherHistory; 