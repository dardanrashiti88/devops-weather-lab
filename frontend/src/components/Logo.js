import React from 'react';
import { motion } from 'framer-motion';

const Logo = ({ size = 40, className = '' }) => {
  return (
    <motion.div
      className={`logo-container ${className}`}
      style={{ width: size, height: size }}
      whileHover={{ scale: 1.1 }}
      whileTap={{ scale: 0.95 }}
    >
      <svg
        width={size}
        height={size}
        viewBox="0 0 100 100"
        fill="none"
        xmlns="http://www.w3.org/2000/svg"
      >
        {/* Background circle with gradient */}
        <defs>
          <linearGradient id="logoGradient" x1="0%" y1="0%" x2="100%" y2="100%">
            <stop offset="0%" stopColor="#4F46E5" />
            <stop offset="50%" stopColor="#7C3AED" />
            <stop offset="100%" stopColor="#06B6D4" />
          </linearGradient>
          <linearGradient id="sunGradient" x1="0%" y1="0%" x2="100%" y2="100%">
            <stop offset="0%" stopColor="#F59E0B" />
            <stop offset="100%" stopColor="#F97316" />
          </linearGradient>
        </defs>
        
        {/* Main circle */}
        <motion.circle
          cx="50"
          cy="50"
          r="45"
          fill="url(#logoGradient)"
          initial={{ scale: 0, opacity: 0 }}
          animate={{ scale: 1, opacity: 1 }}
          transition={{ duration: 0.6, ease: "easeOut" }}
        />
        
        {/* Sun rays */}
        <motion.g
          initial={{ rotate: 0 }}
          animate={{ rotate: 360 }}
          transition={{ duration: 20, repeat: Infinity, ease: "linear" }}
        >
          {[...Array(8)].map((_, i) => (
            <motion.rect
              key={i}
              x="50"
              y="15"
              width="2"
              height="8"
              fill="url(#sunGradient)"
              transform={`rotate(${i * 45} 50 50)`}
              initial={{ scaleY: 0 }}
              animate={{ scaleY: 1 }}
              transition={{ delay: i * 0.1, duration: 0.3 }}
            />
          ))}
        </motion.g>
        
        {/* Cloud */}
        <motion.g
          initial={{ x: -20, opacity: 0 }}
          animate={{ x: 0, opacity: 1 }}
          transition={{ delay: 0.3, duration: 0.5 }}
        >
          <motion.path
            d="M25 60 Q20 55 15 60 Q10 65 15 70 Q20 75 25 70 Q30 65 25 60"
            fill="white"
            opacity="0.9"
            animate={{ 
              d: [
                "M25 60 Q20 55 15 60 Q10 65 15 70 Q20 75 25 70 Q30 65 25 60",
                "M25 62 Q20 57 15 62 Q10 67 15 72 Q20 77 25 72 Q30 67 25 62",
                "M25 60 Q20 55 15 60 Q10 65 15 70 Q20 75 25 70 Q30 65 25 60"
              ]
            }}
            transition={{ duration: 3, repeat: Infinity, ease: "easeInOut" }}
          />
          <motion.path
            d="M70 45 Q65 40 60 45 Q55 50 60 55 Q65 60 70 55 Q75 50 70 45"
            fill="white"
            opacity="0.7"
            animate={{ 
              d: [
                "M70 45 Q65 40 60 45 Q55 50 60 55 Q65 60 70 55 Q75 50 70 45",
                "M70 47 Q65 42 60 47 Q55 52 60 57 Q65 62 70 57 Q75 52 70 47",
                "M70 45 Q65 40 60 45 Q55 50 60 55 Q65 60 70 55 Q75 50 70 45"
              ]
            }}
            transition={{ duration: 4, repeat: Infinity, ease: "easeInOut", delay: 1 }}
          />
        </motion.g>
        
        {/* Lightning bolt */}
        <motion.path
          d="M50 25 L45 40 L55 35 L50 50"
          stroke="#FCD34D"
          strokeWidth="3"
          fill="none"
          strokeLinecap="round"
          strokeLinejoin="round"
          initial={{ pathLength: 0, opacity: 0 }}
          animate={{ pathLength: 1, opacity: 1 }}
          transition={{ delay: 0.8, duration: 0.4 }}
        />
      </svg>
    </motion.div>
  );
};

export default Logo; 