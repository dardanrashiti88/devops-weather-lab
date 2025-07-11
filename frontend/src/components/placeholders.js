import React from 'react';
import { motion } from 'framer-motion';
import { MapContainer, TileLayer, Marker, Popup } from 'react-leaflet';
import 'leaflet/dist/leaflet.css';
import L from 'leaflet';

// Fix default icon issue with Leaflet in React
import iconUrl from 'leaflet/dist/images/marker-icon.png';
import iconShadow from 'leaflet/dist/images/marker-shadow.png';

const DefaultIcon = L.icon({
  iconUrl,
  shadowUrl: iconShadow,
  iconAnchor: [12, 41],
});
L.Marker.prototype.options.icon = DefaultIcon;

// Kosovo cities with mock temperatures
const kosovoCities = [
  { name: 'Pristina', lat: 42.6629, lon: 21.1655, temp: 25 },
  { name: 'Peja', lat: 42.6591, lon: 20.2883, temp: 23 },
  { name: 'Gjakova', lat: 42.3803, lon: 20.4300, temp: 24 },
  { name: 'Mitrovica', lat: 42.8900, lon: 20.8667, temp: 22 },
  { name: 'Ferizaj', lat: 42.3706, lon: 21.1550, temp: 26 },
  { name: 'Gjilan', lat: 42.4637, lon: 21.4691, temp: 24 },
  { name: 'Prizren', lat: 42.2139, lon: 20.7417, temp: 27 },
  { name: 'Vushtrri', lat: 42.8231, lon: 20.9675, temp: 23 },
  { name: 'Podujeva', lat: 42.9106, lon: 21.1925, temp: 22 },
  { name: 'Suhareka', lat: 42.3586, lon: 20.8250, temp: 25 },
  { name: 'Rahovec', lat: 42.4000, lon: 20.6547, temp: 24 },
  { name: 'Malisheva', lat: 42.4833, lon: 20.7456, temp: 23 },
  { name: 'Drenas', lat: 42.6131, lon: 20.8022, temp: 24 },
  { name: 'Kamenica', lat: 42.5747, lon: 21.5806, temp: 23 },
  { name: 'Dragash', lat: 42.0667, lon: 20.6500, temp: 21 },
];

const Placeholder = ({ title }) => {
  return (
    <motion.div
      initial={{ opacity: 0 }}
      animate={{ opacity: 1 }}
      exit={{ opacity: 0 }}
    >
      <h1 className="gradient-text">{title}</h1>
      <p>This is the {title} page. Content coming soon!</p>
    </motion.div>
  );
};

import HourlyForecast from './dashboard/HourlyForecast';
import DailyForecast from './dashboard/DailyForecast';
import { LineChart, Line, XAxis, YAxis, CartesianGrid, Tooltip, ResponsiveContainer, BarChart, Bar, Legend } from 'recharts';
import { TrendingUp, Wind, Droplet } from 'lucide-react';

const mockHourly = [
  { time: '09:00', temp: 18.5, icon: '01d', description: 'Sunny' },
  { time: '10:00', temp: 19.2, icon: '01d', description: 'Sunny' },
  { time: '11:00', temp: 20.1, icon: '02d', description: 'Partly Cloudy' },
  { time: '12:00', temp: 21.0, icon: '02d', description: 'Partly Cloudy' },
  { time: '13:00', temp: 22.3, icon: '03d', description: 'Cloudy' },
  { time: '14:00', temp: 23.1, icon: '03d', description: 'Cloudy' },
  { time: '15:00', temp: 23.7, icon: '01d', description: 'Sunny' },
  { time: '16:00', temp: 23.2, icon: '01d', description: 'Sunny' },
  { time: '17:00', temp: 22.0, icon: '01d', description: 'Sunny' },
  { time: '18:00', temp: 20.5, icon: '01d', description: 'Sunny' },
];

const mockDaily = [
  { date: new Date(), temp_max: 24, temp_min: 15, icon: '01d' },
  { date: new Date(Date.now() + 86400000), temp_max: 23, temp_min: 14, icon: '02d' },
  { date: new Date(Date.now() + 2*86400000), temp_max: 22, temp_min: 13, icon: '03d' },
  { date: new Date(Date.now() + 3*86400000), temp_max: 21, temp_min: 12, icon: '10d' },
  { date: new Date(Date.now() + 4*86400000), temp_max: 20, temp_min: 11, icon: '09d' },
  { date: new Date(Date.now() + 5*86400000), temp_max: 19, temp_min: 10, icon: '13d' },
  { date: new Date(Date.now() + 6*86400000), temp_max: 18, temp_min: 9, icon: '01d' },
];

export const Forecast = () => (
  <div style={{ maxWidth: '900px', margin: '2rem auto', display: 'flex', flexDirection: 'column', gap: '2.5rem' }}>
    <div style={{ textAlign: 'left', marginBottom: '0.5rem' }}>
      <h1 className="gradient-text" style={{ fontSize: '2.5rem', fontWeight: 800, marginBottom: '0.5rem' }}>Forecast</h1>
      <p style={{ color: 'var(--text-secondary)', fontSize: '1.2rem', marginBottom: '1.5rem' }}>
        Get a detailed look at the weather for the next 24 hours and 7 days. All data is beautifully visualized for quick insights.
      </p>
    </div>
    <HourlyForecast data={mockHourly} />
    <DailyForecast data={mockDaily} />
  </div>
);

const analyticsData = [
  { day: 'Mon', temp: 22, humidity: 65, wind: 12 },
  { day: 'Tue', temp: 24, humidity: 60, wind: 14 },
  { day: 'Wed', temp: 26, humidity: 55, wind: 10 },
  { day: 'Thu', temp: 23, humidity: 70, wind: 8 },
  { day: 'Fri', temp: 21, humidity: 75, wind: 9 },
  { day: 'Sat', temp: 19, humidity: 80, wind: 11 },
  { day: 'Sun', temp: 18, humidity: 85, wind: 13 },
];

export const Analytics = () => (
  <div style={{ maxWidth: '1000px', margin: '2rem auto', display: 'flex', flexDirection: 'column', gap: '2.5rem' }}>
    <div style={{ textAlign: 'left', marginBottom: '0.5rem' }}>
      <h1 className="gradient-text" style={{ fontSize: '2.5rem', fontWeight: 800, marginBottom: '0.5rem' }}>Analytics</h1>
      <p style={{ color: 'var(--text-secondary)', fontSize: '1.2rem', marginBottom: '1.5rem' }}>
        Visualize weather trends for the past week. See temperature, humidity, and wind speed analytics in beautiful charts.
      </p>
    </div>
    <div className="glass" style={{ padding: '2rem', borderRadius: '24px', boxShadow: '0 4px 32px rgba(0,0,0,0.06)' }}>
      <h2 style={{ fontWeight: 700, fontSize: '1.3rem', marginBottom: '1.5rem', display: 'flex', alignItems: 'center', gap: '0.5rem' }}>
        <TrendingUp size={22} /> Temperature Trend
      </h2>
      <ResponsiveContainer width="100%" height={220}>
        <LineChart data={analyticsData} margin={{ top: 10, right: 30, left: 0, bottom: 0 }}>
          <CartesianGrid strokeDasharray="3 3" stroke="#e5e7eb" />
          <XAxis dataKey="day" stroke="#6b7280" fontSize={13} />
          <YAxis stroke="#6b7280" fontSize={13} />
          <Tooltip />
          <Line type="monotone" dataKey="temp" stroke="#2563eb" strokeWidth={3} dot={{ fill: '#2563eb', r: 5 }} activeDot={{ r: 7 }} />
        </LineChart>
      </ResponsiveContainer>
    </div>
    <div style={{ display: 'flex', gap: '2rem', flexWrap: 'wrap' }}>
      <div className="glass" style={{ flex: 1, minWidth: 320, padding: '2rem', borderRadius: '24px', boxShadow: '0 4px 32px rgba(0,0,0,0.06)' }}>
        <h2 style={{ fontWeight: 700, fontSize: '1.1rem', marginBottom: '1rem', display: 'flex', alignItems: 'center', gap: '0.5rem' }}>
          <Droplet size={20} /> Humidity
        </h2>
        <ResponsiveContainer width="100%" height={160}>
          <BarChart data={analyticsData} margin={{ top: 10, right: 30, left: 0, bottom: 0 }}>
            <CartesianGrid strokeDasharray="3 3" stroke="#e5e7eb" />
            <XAxis dataKey="day" stroke="#6b7280" fontSize={13} />
            <YAxis stroke="#6b7280" fontSize={13} />
            <Tooltip />
            <Bar dataKey="humidity" fill="#60a5fa" radius={[8, 8, 0, 0]} />
          </BarChart>
        </ResponsiveContainer>
      </div>
      <div className="glass" style={{ flex: 1, minWidth: 320, padding: '2rem', borderRadius: '24px', boxShadow: '0 4px 32px rgba(0,0,0,0.06)' }}>
        <h2 style={{ fontWeight: 700, fontSize: '1.1rem', marginBottom: '1rem', display: 'flex', alignItems: 'center', gap: '0.5rem' }}>
          <Wind size={20} /> Wind Speed
        </h2>
        <ResponsiveContainer width="100%" height={160}>
          <LineChart data={analyticsData} margin={{ top: 10, right: 30, left: 0, bottom: 0 }}>
            <CartesianGrid strokeDasharray="3 3" stroke="#e5e7eb" />
            <XAxis dataKey="day" stroke="#6b7280" fontSize={13} />
            <YAxis stroke="#6b7280" fontSize={13} />
            <Tooltip />
            <Line type="monotone" dataKey="wind" stroke="#a78bfa" strokeWidth={3} dot={{ fill: '#a78bfa', r: 5 }} activeDot={{ r: 7 }} />
          </LineChart>
        </ResponsiveContainer>
      </div>
    </div>
  </div>
);
import SettingsPage from '../pages/Settings';

export const Settings = SettingsPage;

export const WeatherMap = () => (
  <div style={{ height: '70vh', width: '100%' }}>
    <MapContainer center={[42.55, 20.95]} zoom={9} style={{ height: '100%', width: '100%', borderRadius: '16px', boxShadow: '0 2px 16px rgba(0,0,0,0.2)' }}>
      <TileLayer
        attribution='&copy; <a href="https://www.openstreetmap.org/copyright">OpenStreetMap</a> contributors'
        url="https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png"
      />
      {kosovoCities.map(city => (
        <Marker key={city.name} position={[city.lat, city.lon]} icon={DefaultIcon}>
          <Popup>
            <strong>{city.name}</strong><br />
            Temperature: {city.temp}&deg;C
          </Popup>
        </Marker>
      ))}
    </MapContainer>
  </div>
); 