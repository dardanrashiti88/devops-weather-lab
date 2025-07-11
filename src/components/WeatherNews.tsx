import React, { useState } from 'react';
import { Newspaper, AlertTriangle, TrendingUp, Globe } from 'lucide-react';

interface NewsItem {
  id: number;
  title: string;
  summary: string;
  category: 'weather' | 'climate' | 'alert';
  timestamp: string;
  read: boolean;
}

const WeatherNews: React.FC = () => {
  const [selectedCategory, setSelectedCategory] = useState<'all' | 'weather' | 'climate' | 'alert'>('all');

  const newsData: NewsItem[] = [
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

  const getCategoryIcon = (category: string) => {
    switch (category) {
      case 'alert': return AlertTriangle;
      case 'climate': return TrendingUp;
      case 'weather': return Globe;
      default: return Newspaper;
    }
  };

  const getCategoryColor = (category: string) => {
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
              onClick={() => setSelectedCategory(cat.id as any)}
            >
              {cat.label}
            </button>
          ))}
        </div>
      </div>

      <div className="news-list">
        {filteredNews.map((item) => {
          const IconComponent = getCategoryIcon(item.category);
          return (
            <div key={item.id} className={`news-item ${!item.read ? 'unread' : ''}`}>
              <div className="news-icon" style={{ color: getCategoryColor(item.category) }}>
                <IconComponent size={20} />
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
          );
        })}
      </div>
    </div>
  );
};

export default WeatherNews; 