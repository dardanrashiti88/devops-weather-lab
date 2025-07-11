import React from 'react';
import { Thermometer, Ruler } from 'lucide-react';

interface UnitToggleProps {
  unit: 'metric' | 'imperial';
  onUnitChange: (unit: 'metric' | 'imperial') => void;
}

const UnitToggle: React.FC<UnitToggleProps> = ({ unit, onUnitChange }) => {
  return (
    <div className="unit-toggle">
      <div className="toggle-container">
        <button
          className={`toggle-btn ${unit === 'metric' ? 'active' : ''}`}
          onClick={() => onUnitChange('metric')}
          title="Metric (°C, km/h, mm)"
        >
          <Thermometer size={16} />
          <span>°C</span>
        </button>
        <button
          className={`toggle-btn ${unit === 'imperial' ? 'active' : ''}`}
          onClick={() => onUnitChange('imperial')}
          title="Imperial (°F, mph, in)"
        >
          <Ruler size={16} />
          <span>°F</span>
        </button>
      </div>
    </div>
  );
};

export default UnitToggle; 