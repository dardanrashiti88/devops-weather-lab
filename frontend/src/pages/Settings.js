import React, { useState } from 'react';
import { Settings, Bell, Palette, Shield, Globe, MapPin, Newspaper } from 'lucide-react';

const UnitToggle = ({ unit, onUnitChange }) => {
  return (
    <div className="unit-toggle">
      <div className="toggle-container">
        <button
          className={`toggle-btn ${unit === 'metric' ? 'active' : ''}`}
          onClick={() => onUnitChange('metric')}
          title="Metric (°C, km/h, mm)"
        >
          <span>°C</span>
        </button>
        <button
          className={`toggle-btn ${unit === 'imperial' ? 'active' : ''}`}
          onClick={() => onUnitChange('imperial')}
          title="Imperial (°F, mph, in)"
        >
          <span>°F</span>
        </button>
      </div>
    </div>
  );
};

const WeatherRadar = ({ location }) => {
  const [selectedLayer, setSelectedLayer] = useState('precipitation');

  const layers = [
    { id: 'precipitation', name: 'Precipitation', color: 'blue' },
    { id: 'wind', name: 'Wind', color: 'green' },
    { id: 'temperature', name: 'Temperature', color: 'red' }
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
              onClick={() => setSelectedLayer(layer.id)}
              style={{ '--layer-color': layer.color }}
            >
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
                  }}
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

const WeatherNews = () => {
  const [selectedCategory, setSelectedCategory] = useState('all');

  const newsData = [
    {
      id: 1,
      title: "Severe Storm Warning for Eastern Region",
      summary: "Heavy rainfall and strong winds expected across the eastern coastal areas. Residents advised to stay indoors.",
      category: 'alert',
      timestamp: '2 hours ago',
      read: false
    },
    {
      id: 2,
      title: "Record-Breaking Heat Wave Continues",
      summary: "Temperatures reaching unprecedented levels across multiple states. Climate scientists warn of increasing frequency.",
      category: 'climate',
      timestamp: '4 hours ago',
      read: true
    },
    {
      id: 3,
      title: "New Weather Prediction Model Released",
      summary: "Advanced AI-powered forecasting system promises 95% accuracy for 7-day predictions.",
      category: 'weather',
      timestamp: '6 hours ago',
      read: false
    },
    {
      id: 4,
      title: "Hurricane Season Forecast Updated",
      summary: "NOAA revises hurricane predictions for the Atlantic basin. Above-average activity expected.",
      category: 'climate',
      timestamp: '1 day ago',
      read: true
    },
    {
      id: 5,
      title: "Flash Flood Watch in Effect",
      summary: "Heavy rainfall causing rapid water accumulation. Avoid low-lying areas and water crossings.",
      category: 'alert',
      timestamp: '3 hours ago',
      read: false
    }
  ];

  const filteredNews = selectedCategory === 'all' 
    ? newsData 
    : newsData.filter(item => item.category === selectedCategory);

  const getCategoryColor = (category) => {
    switch (category) {
      case 'alert': return 'var(--alert-color)';
      case 'climate': return 'var(--climate-color)';
      case 'weather': return 'var(--weather-color)';
      default: return 'var(--text-secondary)';
    }
  };

  return (
    <div className="weather-news">
      <div className="news-header">
        <h3>Weather News & Alerts</h3>
        <div className="category-filters">
          {[
            { id: 'all', label: 'All' },
            { id: 'weather', label: 'Weather' },
            { id: 'climate', label: 'Climate' },
            { id: 'alert', label: 'Alerts' }
          ].map(cat => (
            <button
              key={cat.id}
              className={`category-btn ${selectedCategory === cat.id ? 'active' : ''}`}
              onClick={() => setSelectedCategory(cat.id)}
            >
              {cat.label}
            </button>
          ))}
        </div>
      </div>

      <div className="news-list">
        {filteredNews.map((item) => (
          <div key={item.id} className={`news-item ${!item.read ? 'unread' : ''}`}>
            <div className="news-icon" style={{ color: getCategoryColor(item.category) }}>
              <span>📰</span>
            </div>
            <div className="news-content">
              <h4>{item.title}</h4>
              <p>{item.summary}</p>
              <div className="news-meta">
                <span className="timestamp">{item.timestamp}</span>
                <span className="category">{item.category}</span>
              </div>
            </div>
            {!item.read && <div className="unread-indicator"></div>}
          </div>
        ))}
      </div>
    </div>
  );
};

const Personalization = ({ onSettingsChange }) => {
  const [settings, setSettings] = useState({
    notifications: {
      weatherAlerts: true,
      dailyForecast: true,
      severeWeather: true,
      airQuality: false
    },
    display: {
      theme: 'auto',
      units: 'metric',
      language: 'en',
      compactMode: false
    },
    privacy: {
      locationSharing: false,
      dataCollection: true,
      personalizedAds: false
    }
  });

  const handleSettingChange = (category, key, value) => {
    const newSettings = {
      ...settings,
      [category]: {
        ...settings[category],
        [key]: value
      }
    };
    setSettings(newSettings);
    onSettingsChange(newSettings);
  };

  const sections = [
    {
      id: 'notifications',
      title: 'Notifications',
      icon: Bell,
      settings: [
        { key: 'weatherAlerts', label: 'Weather Alerts', description: 'Get notified about severe weather' },
        { key: 'dailyForecast', label: 'Daily Forecast', description: 'Receive daily weather updates' },
        { key: 'severeWeather', label: 'Severe Weather', description: 'Critical weather warnings' },
        { key: 'airQuality', label: 'Air Quality', description: 'Air quality index updates' }
      ]
    },
    {
      id: 'display',
      title: 'Display',
      icon: Palette,
      settings: [
        { key: 'theme', label: 'Theme', type: 'select', options: ['auto', 'light', 'dark'] },
        { key: 'units', label: 'Units', type: 'select', options: ['metric', 'imperial'] },
        { key: 'language', label: 'Language', type: 'select', options: ['en', 'es', 'fr', 'de'] },
        { key: 'compactMode', label: 'Compact Mode', type: 'toggle', description: 'Use less space' }
      ]
    },
    {
      id: 'privacy',
      title: 'Privacy & Security',
      icon: Shield,
      settings: [
        { key: 'locationSharing', label: 'Location Sharing', type: 'toggle', description: 'Share location for better forecasts' },
        { key: 'dataCollection', label: 'Data Collection', type: 'toggle', description: 'Help improve weather predictions' },
        { key: 'personalizedAds', label: 'Personalized Ads', type: 'toggle', description: 'Show relevant advertisements' }
      ]
    }
  ];

  return (
    <div className="personalization">
      <div className="settings-header">
        <h3>Personalization & Settings</h3>
        <p>Customize your weather experience</p>
      </div>

      <div className="settings-sections">
        {sections.map((section) => {
          const IconComponent = section.icon;
          return (
            <div key={section.id} className="settings-section">
              <div className="section-header">
                <IconComponent size={20} />
                <h4>{section.title}</h4>
              </div>
              
              <div className="section-content">
                {section.settings.map((setting) => (
                  <div key={setting.key} className="setting-item">
                    <div className="setting-info">
                      <label>{setting.label}</label>
                      {setting.description && <p>{setting.description}</p>}
                    </div>
                    
                    <div className="setting-control">
                      {setting.type === 'toggle' ? (
                        <label className="toggle-switch">
                          <input
                            type="checkbox"
                            checked={settings[section.id][setting.key]}
                            onChange={(e) => handleSettingChange(section.id, setting.key, e.target.checked)}
                          />
                          <span className="slider"></span>
                        </label>
                      ) : setting.type === 'select' ? (
                        <select
                          value={settings[section.id][setting.key]}
                          onChange={(e) => handleSettingChange(section.id, setting.key, e.target.value)}
                        >
                          {setting.options?.map((option) => (
                            <option key={option} value={option}>
                              {option.charAt(0).toUpperCase() + option.slice(1)}
                            </option>
                          ))}
                        </select>
                      ) : (
                        <label className="toggle-switch">
                          <input
                            type="checkbox"
                            checked={settings[section.id][setting.key]}
                            onChange={(e) => handleSettingChange(section.id, setting.key, e.target.checked)}
                          />
                          <span className="slider"></span>
                        </label>
                      )}
                    </div>
                  </div>
                ))}
              </div>
            </div>
          );
        })}
      </div>
    </div>
  );
};

const SettingsPage = () => {
  const [activeTab, setActiveTab] = useState('personalization');
  const [unit, setUnit] = useState('metric');

  const tabs = [
    { id: 'personalization', label: 'Personalization', icon: Palette },
    { id: 'notifications', label: 'Notifications', icon: Bell },
    { id: 'radar', label: 'Weather Radar', icon: MapPin },
    { id: 'news', label: 'Weather News', icon: Newspaper },
    { id: 'units', label: 'Units', icon: Globe },
    { id: 'privacy', label: 'Privacy', icon: Shield }
  ];

  const handleSettingsChange = (settings) => {
    console.log('Settings changed:', settings);
    // Here you would typically save to localStorage or send to backend
  };

  const renderTabContent = () => {
    switch (activeTab) {
      case 'personalization':
        return <Personalization onSettingsChange={handleSettingsChange} />;
      case 'radar':
        return <WeatherRadar location="New York" />;
      case 'news':
        return <WeatherNews />;
      case 'units':
        return (
          <div className="settings-card">
            <div className="card-header">
              <Globe size={24} />
              <h3>Unit Preferences</h3>
            </div>
            <div className="card-content">
              <p>Choose your preferred measurement units for temperature, wind speed, and precipitation.</p>
              <div className="unit-section">
                <h4>Temperature & Wind</h4>
                <UnitToggle unit={unit} onUnitChange={setUnit} />
              </div>
            </div>
          </div>
        );
      case 'notifications':
        return (
          <div className="settings-card">
            <div className="card-header">
              <Bell size={24} />
              <h3>Notification Settings</h3>
            </div>
            <div className="card-content">
              <div className="notification-item">
                <div className="notification-info">
                  <h4>Weather Alerts</h4>
                  <p>Get notified about severe weather conditions</p>
                </div>
                <label className="toggle-switch">
                  <input type="checkbox" defaultChecked />
                  <span className="slider"></span>
                </label>
              </div>
              <div className="notification-item">
                <div className="notification-info">
                  <h4>Daily Forecast</h4>
                  <p>Receive daily weather updates at 8 AM</p>
                </div>
                <label className="toggle-switch">
                  <input type="checkbox" defaultChecked />
                  <span className="slider"></span>
                </label>
              </div>
              <div className="notification-item">
                <div className="notification-info">
                  <h4>Air Quality Updates</h4>
                  <p>Get alerts when air quality changes significantly</p>
                </div>
                <label className="toggle-switch">
                  <input type="checkbox" />
                  <span className="slider"></span>
                </label>
              </div>
            </div>
          </div>
        );
      case 'privacy':
        return (
          <div className="settings-card">
            <div className="card-header">
              <Shield size={24} />
              <h3>Privacy & Security</h3>
            </div>
            <div className="card-content">
              <div className="privacy-item">
                <div className="privacy-info">
                  <h4>Location Sharing</h4>
                  <p>Allow precise location access for accurate forecasts</p>
                </div>
                <label className="toggle-switch">
                  <input type="checkbox" />
                  <span className="slider"></span>
                </label>
              </div>
              <div className="privacy-item">
                <div className="privacy-info">
                  <h4>Data Collection</h4>
                  <p>Help improve weather predictions with anonymous data</p>
                </div>
                <label className="toggle-switch">
                  <input type="checkbox" defaultChecked />
                  <span className="slider"></span>
                </label>
              </div>
              <div className="privacy-item">
                <div className="privacy-info">
                  <h4>Personalized Content</h4>
                  <p>Show weather information relevant to your location</p>
                </div>
                <label className="toggle-switch">
                  <input type="checkbox" defaultChecked />
                  <span className="slider"></span>
                </label>
              </div>
            </div>
          </div>
        );
      default:
        return <Personalization onSettingsChange={handleSettingsChange} />;
    }
  };

  return (
    <div className="settings-page">
      <div className="settings-container">
        <div className="settings-sidebar">
          <div className="sidebar-header">
            <Settings size={24} />
            <h2>Settings</h2>
          </div>
          <nav className="settings-nav">
            {tabs.map((tab) => {
              const IconComponent = tab.icon;
              return (
                <button
                  key={tab.id}
                  className={`nav-item ${activeTab === tab.id ? 'active' : ''}`}
                  onClick={() => setActiveTab(tab.id)}
                >
                  <IconComponent size={20} />
                  <span>{tab.label}</span>
                </button>
              );
            })}
          </nav>
        </div>
        
        <div className="settings-content">
          <div className="content-header">
            <h1>{tabs.find(tab => tab.id === activeTab)?.label}</h1>
            <p>Customize your weather experience</p>
          </div>
          
          <div className="content-body">
            {renderTabContent()}
          </div>
        </div>
      </div>
    </div>
  );
};

export default SettingsPage; 