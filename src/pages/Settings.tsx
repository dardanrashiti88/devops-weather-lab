import React, { useState } from 'react';
import { Settings, Bell, Palette, Shield, Globe, MapPin, Newspaper, BarChart3 } from 'lucide-react';
import UnitToggle from '../components/UnitToggle';
import WeatherRadar from '../components/WeatherRadar';
import WeatherNews from '../components/WeatherNews';
import Personalization from '../components/Personalization';

const Settings: React.FC = () => {
  const [activeTab, setActiveTab] = useState('personalization');
  const [unit, setUnit] = useState<'metric' | 'imperial'>('metric');

  const tabs = [
    { id: 'personalization', label: 'Personalization', icon: Palette },
    { id: 'notifications', label: 'Notifications', icon: Bell },
    { id: 'radar', label: 'Weather Radar', icon: MapPin },
    { id: 'news', label: 'Weather News', icon: Newspaper },
    { id: 'units', label: 'Units', icon: Globe },
    { id: 'privacy', label: 'Privacy', icon: Shield }
  ];

  const handleSettingsChange = (settings: any) => {
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

export default Settings; 