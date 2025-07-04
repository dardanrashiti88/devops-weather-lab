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

export const Forecast = () => <Placeholder title="Forecast" />;
export const Analytics = () => <Placeholder title="Analytics" />;
export const Settings = () => <Placeholder title="Settings" />; 