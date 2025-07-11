import React, { useState } from 'react';
import { motion, AnimatePresence } from 'framer-motion';
import { MapPin, Plus, Star, Trash2, Navigation } from 'lucide-react';
import './FavoriteLocations.css';

const FavoriteLocations = ({ favorites = [], onLocationSelect, onAddFavorite, onRemoveFavorite }) => {
  const [isAdding, setIsAdding] = useState(false);
  const [newLocation, setNewLocation] = useState('');

  const handleAddFavorite = () => {
    if (newLocation.trim()) {
      onAddFavorite(newLocation.trim());
      setNewLocation('');
      setIsAdding(false);
    }
  };

  const handleKeyPress = (e) => {
    if (e.key === 'Enter') {
      handleAddFavorite();
    } else if (e.key === 'Escape') {
      setIsAdding(false);
      setNewLocation('');
    }
  };

  return (
    <motion.div
      className="favorite-locations-card"
      initial={{ opacity: 0, y: 24 }}
      animate={{ opacity: 1, y: 0 }}
      exit={{ opacity: 0, y: 24 }}
      transition={{ duration: 0.5, ease: 'easeInOut' }}
    >
      <div className="card-header">
        <h3>Favorite Locations</h3>
        <motion.button
          className="add-favorite-btn"
          onClick={() => setIsAdding(true)}
          whileHover={{ scale: 1.05 }}
          whileTap={{ scale: 0.95 }}
        >
          <Plus size={20} />
        </motion.button>
      </div>
      
      <div className="favorites-list">
        <AnimatePresence>
          {favorites.map((favorite, index) => (
            <motion.div
              key={favorite.id || index}
              className="favorite-item"
              initial={{ opacity: 0, x: -20 }}
              animate={{ opacity: 1, x: 0 }}
              exit={{ opacity: 0, x: 20 }}
              transition={{ delay: index * 0.1 }}
              whileHover={{ scale: 1.02 }}
            >
              <div className="favorite-info" onClick={() => onLocationSelect(favorite.name)}>
                <div className="location-icon">
                  <MapPin size={16} />
                </div>
                <div className="location-details">
                  <h4>{favorite.name}</h4>
                  <span className="location-country">{favorite.country}</span>
                </div>
                <div className="favorite-actions">
                  <motion.button
                    className="action-btn navigate"
                    onClick={(e) => {
                      e.stopPropagation();
                      onLocationSelect(favorite.name);
                    }}
                    whileHover={{ scale: 1.1 }}
                    whileTap={{ scale: 0.9 }}
                    title="Navigate to location"
                  >
                    <Navigation size={16} />
                  </motion.button>
                  <motion.button
                    className="action-btn remove"
                    onClick={(e) => {
                      e.stopPropagation();
                      onRemoveFavorite(favorite.id || index);
                    }}
                    whileHover={{ scale: 1.1 }}
                    whileTap={{ scale: 0.9 }}
                    title="Remove from favorites"
                  >
                    <Trash2 size={16} />
                  </motion.button>
                </div>
              </div>
              
              {favorite.currentWeather && (
                <div className="current-weather-preview">
                  <div className="weather-icon">
                    {favorite.currentWeather.icon}
                  </div>
                  <div className="weather-temp">
                    {favorite.currentWeather.temp}°C
                  </div>
                  <div className="weather-condition">
                    {favorite.currentWeather.condition}
                  </div>
                </div>
              )}
            </motion.div>
          ))}
        </AnimatePresence>
        
        {isAdding && (
          <motion.div
            className="add-location-form"
            initial={{ opacity: 0, height: 0 }}
            animate={{ opacity: 1, height: 'auto' }}
            exit={{ opacity: 0, height: 0 }}
          >
            <div className="form-input">
              <MapPin size={16} />
              <input
                type="text"
                placeholder="Enter city name..."
                value={newLocation}
                onChange={(e) => setNewLocation(e.target.value)}
                onKeyPress={handleKeyPress}
                autoFocus
              />
            </div>
            <div className="form-actions">
              <motion.button
                className="btn-cancel"
                onClick={() => {
                  setIsAdding(false);
                  setNewLocation('');
                }}
                whileHover={{ scale: 1.05 }}
                whileTap={{ scale: 0.95 }}
              >
                Cancel
              </motion.button>
              <motion.button
                className="btn-add"
                onClick={handleAddFavorite}
                whileHover={{ scale: 1.05 }}
                whileTap={{ scale: 0.95 }}
              >
                Add
              </motion.button>
            </div>
          </motion.div>
        )}
        
        {favorites.length === 0 && !isAdding && (
          <div className="empty-state">
            <div className="empty-icon">⭐</div>
            <h4>No Favorite Locations</h4>
            <p>Add your favorite cities to quickly check their weather</p>
            <motion.button
              className="btn-add-first"
              onClick={() => setIsAdding(true)}
              whileHover={{ scale: 1.05 }}
              whileTap={{ scale: 0.95 }}
            >
              <Plus size={16} />
              Add First Location
            </motion.button>
          </div>
        )}
      </div>
    </motion.div>
  );
};

export default FavoriteLocations; 