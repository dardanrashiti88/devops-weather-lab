import React from 'react';
import { NavLink } from 'react-router-dom';
import { motion } from 'framer-motion';
import { Search, Settings, Moon, Sun } from 'lucide-react';
import Logo from './Logo';
import './Header.css';

const Header = () => {
  const [isDarkMode, setIsDarkMode] = React.useState(false);

  const toggleTheme = () => {
    setIsDarkMode(!isDarkMode);
    document.body.classList.toggle('dark-mode');
  };

  return (
    <motion.header 
      className="header glass"
      initial={{ y: -100 }}
      animate={{ y: 0 }}
      transition={{ duration: 0.5 }}
    >
      <div className="header-left">
        <Logo size={45} className="logo-image" />
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
        <motion.button
          onClick={toggleTheme}
          className="theme-toggle"
          whileHover={{ scale: 1.1 }}
          whileTap={{ scale: 0.9 }}
        >
          {isDarkMode ? <Sun size={20} /> : <Moon size={20} />}
        </motion.button>
        <NavLink to="/settings" className="nav-link">
          <Settings size={22} />
        </NavLink>
      </div>
    </motion.header>
  );
};

export default Header; 