import React, { useState, useEffect } from 'react';
import { BrowserRouter as Router, Routes, Route, useLocation } from 'react-router-dom';
import { motion, AnimatePresence } from 'framer-motion';
import Header from './components/Header';
import Dashboard from './components/Dashboard';
import { WeatherMap, Forecast, Analytics, Settings } from './components/placeholders';
import { WeatherProvider } from './context/WeatherContext';
import './App.css';
import Login from './pages/Login';
import Register from './pages/Register';

function AppContent() {
  const location = useLocation();
  const [isLoading, setIsLoading] = useState(true);

  useEffect(() => {
    // Simulate loading time
    const timer = setTimeout(() => {
      setIsLoading(false);
    }, 2000);

    return () => clearTimeout(timer);
  }, []);

  if (isLoading) {
    return (
      <div className="loading-screen">
        <motion.div
          initial={{ opacity: 0, scale: 0.8 }}
          animate={{ opacity: 1, scale: 1 }}
          transition={{ duration: 0.5 }}
          className="loading-content"
        >
          <div className="gradient-text" style={{ fontSize: '2rem', fontWeight: 'bold' }}>
            WeatherTech
          </div>
          <div className="loading" style={{ marginTop: '2rem' }}></div>
          <div style={{ marginTop: '1rem', opacity: 0.7 }}>
            Initializing advanced weather systems...
          </div>
        </motion.div>
      </div>
    );
  }

  // Only show bare routes for login/register
  if (location.pathname === '/login' || location.pathname === '/register') {
    return (
      <Routes>
        <Route path="/login" element={<Login />} />
        <Route path="/register" element={<Register />} />
      </Routes>
    );
  }

  // Main layout for all other routes
  return (
    <div className="App">
      <Header />
      <main className="main-content">
        <AnimatePresence mode="wait">
          <Routes>
            <Route path="/" element={<Dashboard />} />
            <Route path="/map" element={<WeatherMap />} />
            <Route path="/forecast" element={<Forecast />} />
            <Route path="/analytics" element={<Analytics />} />
            <Route path="/settings" element={<Settings />} />
          </Routes>
        </AnimatePresence>
      </main>
    </div>
  );
}

function App() {
  return (
    <WeatherProvider>
      <Router>
        <AppContent />
      </Router>
    </WeatherProvider>
  );
}

export default App; 