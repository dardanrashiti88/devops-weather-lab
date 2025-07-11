import React from 'react';
import { motion } from 'framer-motion';
import { LineChart, Line, XAxis, YAxis, Tooltip, ResponsiveContainer, AreaChart, Area } from 'recharts';
import WeatherIcon from './WeatherIcon';
import './HourlyForecast.css';

const cardVariants = {
  hidden: { opacity: 0, y: 24 },
  visible: { opacity: 1, y: 0, transition: { duration: 0.5, ease: 'easeInOut' } },
  exit: { opacity: 0, y: 24, transition: { duration: 0.3, ease: 'easeInOut' } },
};

const CustomTooltip = ({ active, payload, label }) => {
  if (active && payload && payload.length) {
    return (
      <div className="custom-tooltip glass">
        <p className="label">{`${label}`}</p>
        <p className="intro">{`Temp: ${payload[0].value.toFixed(1)}°`}</p>
        <p className="desc">{payload[0].payload.description}</p>
      </div>
    );
  }
  return null;
};

const HourlyForecast = ({ data }) => {
  return (
    <motion.div className="hourly-forecast-card dashboard-card glass glow" variants={cardVariants} initial="hidden" animate="visible" exit="exit">
      <h3 className="chart-title">Hourly Forecast</h3>
      <ResponsiveContainer width="100%" height={200}>
        <AreaChart data={data} margin={{ top: 20, right: 30, left: -10, bottom: 0 }}>
          <defs>
            <linearGradient id="colorTemp" x1="0" y1="0" x2="0" y2="1">
              <stop offset="5%" stopColor="#00d4ff" stopOpacity={0.8}/>
              <stop offset="95%" stopColor="#00d4ff" stopOpacity={0}/>
            </linearGradient>
          </defs>
          <XAxis dataKey="time" stroke="rgba(255, 255, 255, 0.7)" tick={{ fontSize: 12 }} />
          <YAxis stroke="rgba(255, 255, 255, 0.7)" tick={{ fontSize: 12 }} />
          <Tooltip content={<CustomTooltip />} />
          <Area type="monotone" dataKey="temp" stroke="#00d4ff" strokeWidth={2} fillOpacity={1} fill="url(#colorTemp)" />
        </AreaChart>
      </ResponsiveContainer>
    </motion.div>
  );
};

export default HourlyForecast; 