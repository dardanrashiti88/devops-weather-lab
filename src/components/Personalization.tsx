import React, { useState } from 'react';
import { Settings, Bell, Palette, User, Shield, Globe } from 'lucide-react';

interface PersonalizationProps {
  onSettingsChange: (settings: any) => void;
}

const Personalization: React.FC<PersonalizationProps> = ({ onSettingsChange }) => {
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

  const handleSettingChange = (category: string, key: string, value: any) => {
    const newSettings = {
      ...settings,
      [category]: {
        ...settings[category as keyof typeof settings],
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
                            checked={settings[section.id as keyof typeof settings][setting.key as keyof any]}
                            onChange={(e) => handleSettingChange(section.id, setting.key, e.target.checked)}
                          />
                          <span className="slider"></span>
                        </label>
                      ) : setting.type === 'select' ? (
                        <select
                          value={settings[section.id as keyof typeof settings][setting.key as keyof any]}
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
                            checked={settings[section.id as keyof typeof settings][setting.key as keyof any]}
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

export default Personalization; 