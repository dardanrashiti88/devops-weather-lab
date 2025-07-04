import React from 'react';
import { NavLink } from 'react-router-dom';
import { motion } from 'framer-motion';
import { Search, Settings } from 'lucide-react';
import './Header.css';

const Header = () => {
  return (
    <motion.header 
      className="header glass"
      initial={{ y: -100 }}
      animate={{ y: 0 }}
      transition={{ duration: 0.5 }}
    >
      <div className="header-left">
        <img src="/logo.png" alt="WeatherTech Logo" className="logo-image" />
        <h1 className="logo-text gradient-text">WeatherTech</h1>
      </div>
      <nav className="header-nav">
        <NavLink to="/" className="nav-link">Dashboard</NavLink>
        <NavLink to="/map" className="nav-link">Map</NavLink>
        <NavLink to="/forecast" className="nav-link">Forecast</NavLink>
        <NavLink to="/analytics" className="nav-link">Analytics</NavLink>
      </nav>
      <div className="header-right">
        <div className="search-bar">
          <Search size={18} className="search-icon" />
          <input type="text" placeholder="Search city..." className="search-input" />
        </div>
        <NavLink to="/settings" className="nav-link">
          <Settings size={22} />
        </NavLink>
      </div>
    </motion.header>
  );
};

export default Header; 