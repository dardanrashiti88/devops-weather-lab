import React from 'react';
import { motion } from 'framer-motion';
import { Sun, Shield, AlertTriangle } from 'lucide-react';
import './UVIndex.css';

const UVIndex = ({ data }) => {
  const getUVCategory = (uv) => {
    if (uv <= 2) return { 
      level: 'Low', 
      color: '#10B981', 
      icon: <Shield size={20} />, 
      description: 'No protection required',
      protection: 'No protection needed. You can safely stay outside.'
    };
    if (uv <= 5) return { 
      level: 'Moderate', 
      color: '#F59E0B', 
      icon: <Shield size={20} />, 
      description: 'Some protection required',
      protection: 'Take precautions such as covering up, and seek shade during midday hours.'
    };
    if (uv <= 7) return { 
      level: 'High', 
      color: '#F97316', 
      icon: <AlertTriangle size={20} />, 
      description: 'Protection required',
      protection: 'Reduce time in the sun between 10 a.m. and 4 p.m. If outdoors, seek shade and cover up.'
    };
    if (uv <= 10) return { 
      level: 'Very High', 
      color: '#EF4444', 
      icon: <AlertTriangle size={20} />, 
      description: 'Extra protection required',
      protection: 'Minimize sun exposure during midday hours. Protection against skin and eye damage is essential.'
    };
    return { 
      level: 'Extreme', 
      color: '#8B5CF6', 
      icon: <AlertTriangle size={20} />, 
      description: 'Avoid sun exposure',
      protection: 'Take all precautions. Unprotected skin and eyes can burn in minutes.'
    };
  };

  const getProtectionTips = (uv) => {
    const tips = [];
    
    if (uv > 2) {
      tips.push('Apply broad-spectrum sunscreen (SPF 30+)');
      tips.push('Wear protective clothing and wide-brimmed hat');
    }
    
    if (uv > 5) {
      tips.push('Seek shade during peak hours (10 AM - 4 PM)');
      tips.push('Wear UV-blocking sunglasses');
    }
    
    if (uv > 7) {
      tips.push('Limit outdoor activities during peak hours');
      tips.push('Reapply sunscreen every 2 hours');
    }
    
    if (uv > 10) {
      tips.push('Avoid outdoor activities during peak hours');
      tips.push('Stay indoors or in deep shade');
    }
    
    return tips;
  };

  const category = getUVCategory(data?.uv || 0);
  const protectionTips = getProtectionTips(data?.uv || 0);

  return (
    <motion.div
      className="uv-index-card"
      initial={{ opacity: 0, y: 24 }}
      animate={{ opacity: 1, y: 0 }}
      exit={{ opacity: 0, y: 24 }}
      transition={{ duration: 0.5, ease: 'easeInOut' }}
    >
      <div className="card-header">
        <h3>UV Index</h3>
        <motion.div 
          className="uv-indicator"
          style={{ backgroundColor: category.color }}
          animate={{ rotate: 360 }}
          transition={{ duration: 20, repeat: Infinity, ease: "linear" }}
        >
          <Sun size={20} />
        </motion.div>
      </div>
      
      <div className="uv-main">
        <div className="uv-value" style={{ color: category.color }}>
          {data?.uv || 'N/A'}
        </div>
        <div className="uv-level">{category.level}</div>
      </div>
      
      <div className="uv-description">
        {category.description}
      </div>
      
      <div className="uv-protection">
        <h4>Protection Advice:</h4>
        <p>{category.protection}</p>
      </div>
      
      <div className="uv-details">
        <div className="detail-item">
          <span>Current UV:</span>
          <span>{data?.uv || 'N/A'}</span>
        </div>
        <div className="detail-item">
          <span>Max UV Today:</span>
          <span>{data?.maxUv || 'N/A'}</span>
        </div>
        <div className="detail-item">
          <span>Peak Time:</span>
          <span>{data?.peakTime || 'N/A'}</span>
        </div>
        <div className="detail-item">
          <span>Burn Time:</span>
          <span>{data?.burnTime || 'N/A'} min</span>
        </div>
      </div>
      
      <div className="protection-tips">
        <h4>Protection Tips:</h4>
        <ul>
          {protectionTips.map((tip, index) => (
            <motion.li
              key={index}
              initial={{ opacity: 0, x: -10 }}
              animate={{ opacity: 1, x: 0 }}
              transition={{ delay: index * 0.1 }}
            >
              {tip}
            </motion.li>
          ))}
        </ul>
      </div>
    </motion.div>
  );
};

export default UVIndex; 