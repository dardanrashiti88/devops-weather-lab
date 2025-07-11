import React, { useState } from 'react';
import { MapPin, Layers, Wind, CloudRain } from 'lucide-react';

interface WeatherRadarProps {
  location: string;
}

const WeatherRadar: React.FC<WeatherRadarProps> = ({ location }) => {
  const [selectedLayer, setSelectedLayer] = useState<'precipitation' | 'wind' | 'temperature'>('precipitation');

  const layers = [
    { id: 'precipitation', name: 'Precipitation', icon: CloudRain, color: 'blue' },
    { id: 'wind', name: 'Wind', icon: Wind, color: 'green' },
    { id: 'temperature', name: 'Temperature', icon: MapPin, color: 'red' }
  ];

  return (
    <div className="weather-radar">
      <div className="radar-header">
        <h3>Weather Radar</h3>
        <div className="layer-controls">
          {layers.map((layer) => (
            <button
              key={layer.id}
              className={`layer-btn ${selectedLayer === layer.id ? 'active' : ''}`}
              onClick={() => setSelectedLayer(layer.id as any)}
              style={{ '--layer-color': layer.color } as React.CSSProperties}
            >
              <layer.icon size={16} />
              <span>{layer.name}</span>
            </button>
          ))}
        </div>
      </div>
      
      <div className="radar-container">
        <div className="radar-placeholder">
          <div className="radar-animation">
            <div className="radar-scan"></div>
            <div className="radar-center"></div>
          </div>
          <div className="radar-overlay">
            <div className="weather-data-points">
              {Array.from({ length: 8 }, (_, i) => (
                <div
                  key={i}
                  className="data-point"
                  style={{
                    '--angle': `${i * 45}deg`,
                    '--distance': `${20 + Math.random() * 60}%`
                  } as React.CSSProperties}
                >
                  <div className="point-indicator"></div>
                </div>
              ))}
            </div>
          </div>
          <div className="radar-legend">
            <div className="legend-item">
              <div className="legend-color precipitation"></div>
              <span>Light Rain</span>
            </div>
            <div className="legend-item">
              <div className="legend-color moderate"></div>
              <span>Moderate</span>
            </div>
            <div className="legend-item">
              <div className="legend-color heavy"></div>
              <span>Heavy</span>
            </div>
          </div>
        </div>
      </div>
    </div>
  );
};

export default WeatherRadar; 