import React, { createContext, useContext, useReducer, useEffect } from 'react';
import { useQuery } from 'react-query';
import axios from 'axios';

const WeatherContext = createContext();

// Mock weather data for demonstration
const mockWeatherData = {
  current: {
    temp: 22,
    feels_like: 24,
    humidity: 65,
    wind_speed: 12,
    description: 'Partly Cloudy',
    icon: '02d',
    pressure: 1013,
    visibility: 10000,
    uv_index: 5,
    sunrise: '06:30',
    sunset: '18:45'
  },
  hourly: Array.from({ length: 24 }, (_, i) => ({
    time: `${i}:00`,
    temp: 20 + Math.sin(i * 0.3) * 5,
    icon: i < 6 || i > 18 ? '01n' : '02d',
    description: i < 6 || i > 18 ? 'Clear' : 'Partly Cloudy'
  })),
  daily: Array.from({ length: 7 }, (_, i) => ({
    date: new Date(Date.now() + i * 24 * 60 * 60 * 1000).toLocaleDateString(),
    temp_max: 25 + Math.random() * 10,
    temp_min: 15 + Math.random() * 5,
    icon: '02d',
    description: 'Partly Cloudy',
    humidity: 60 + Math.random() * 20,
    wind_speed: 8 + Math.random() * 8
  })),
  location: {
    name: 'New York',
    country: 'US',
    lat: 40.7128,
    lon: -74.0060
  }
};

const initialState = {
  currentLocation: 'New York',
  weatherData: null,
  isLoading: false,
  error: null,
  units: 'metric', // metric or imperial
  theme: 'dark'
};

function weatherReducer(state, action) {
  switch (action.type) {
    case 'SET_LOADING':
      return { ...state, isLoading: action.payload };
    case 'SET_WEATHER_DATA':
      return { ...state, weatherData: action.payload, isLoading: false };
    case 'SET_ERROR':
      return { ...state, error: action.payload, isLoading: false };
    case 'SET_LOCATION':
      return { ...state, currentLocation: action.payload };
    case 'SET_UNITS':
      return { ...state, units: action.payload };
    case 'SET_THEME':
      return { ...state, theme: action.payload };
    default:
      return state;
  }
}

export function WeatherProvider({ children }) {
  const [state, dispatch] = useReducer(weatherReducer, initialState);

  // Simulate weather API call
  const fetchWeatherData = async (location) => {
    // In a real app, this would be an actual API call
    // const response = await axios.get(`/api/weather?location=${location}`);
    // return response.data;
    
    // For demo, return mock data with some randomization
    await new Promise(resolve => setTimeout(resolve, 1000)); // Simulate API delay
    
    return {
      ...mockWeatherData,
      location: {
        ...mockWeatherData.location,
        name: location
      },
      current: {
        ...mockWeatherData.current,
        temp: 20 + Math.random() * 15,
        humidity: 50 + Math.random() * 30
      }
    };
  };

  const { data: weatherData, isLoading, error } = useQuery(
    ['weather', state.currentLocation],
    () => fetchWeatherData(state.currentLocation),
    {
      refetchInterval: 300000, // Refetch every 5 minutes
      staleTime: 300000,
      cacheTime: 600000,
    }
  );

  useEffect(() => {
    if (weatherData) {
      dispatch({ type: 'SET_WEATHER_DATA', payload: weatherData });
    }
  }, [weatherData]);

  useEffect(() => {
    if (error) {
      dispatch({ type: 'SET_ERROR', payload: error.message });
    }
  }, [error]);

  const setLocation = (location) => {
    dispatch({ type: 'SET_LOCATION', payload: location });
  };

  const setUnits = (units) => {
    dispatch({ type: 'SET_UNITS', payload: units });
  };

  const setTheme = (theme) => {
    dispatch({ type: 'SET_THEME', payload: theme });
  };

  const value = {
    ...state,
    weatherData,
    isLoading,
    error,
    setLocation,
    setUnits,
    setTheme
  };

  return (
    <WeatherContext.Provider value={value}>
      {children}
    </WeatherContext.Provider>
  );
}

export function useWeather() {
  const context = useContext(WeatherContext);
  if (!context) {
    throw new Error('useWeather must be used within a WeatherProvider');
  }
  return context;
} 