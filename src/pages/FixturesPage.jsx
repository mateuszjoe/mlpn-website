import React from 'react';
import { fixtures } from '../data/mockData';

const FixturesPage = ({ darkMode, onMatchClick }) => {
  return (
    <div className="space-y-6">
      <div className="flex items-center space-x-2 mb-6">
        <div className="w-1 h-6 bg-green-500 rounded-full"></div>
        <h2 className="text-lg md:text-xl font-bold" style={{fontFamily: 'Oswald, sans-serif'}}>Terminarz Meczów</h2>
      </div>

      <div className="space-y-4">
        {fixtures.map((match) => (
          <div 
            key={match.id} 
            onClick={() => onMatchClick(match.id)}
            className={`${darkMode ? 'bg-[#0d1117] border-gray-800 hover:bg-gray-800/50' : 'bg-white border-gray-200 hover:bg-gray-50'} rounded-xl border p-4 md:p-6 hover-lift cursor-pointer transition-all`}
          >
            <div className="flex items-center justify-between mb-4">
              <div className={`px-3 py-1 rounded-lg ${darkMode ? 'bg-gray-800' : 'bg-gray-100'} text-xs font-medium ${darkMode ? 'text-gray-400' : 'text-gray-600'}`}>
                Kolejka {match.round}
              </div>
              <div className={`text-sm ${darkMode ? 'text-gray-400' : 'text-gray-600'}`}>{match.date} • {match.time}</div>
            </div>

            <div className="grid grid-cols-7 gap-4 items-center">
              <div className="col-span-3 flex items-center justify-end space-x-3">
                <span className={`text-sm md:text-base font-semibold ${darkMode ? 'text-white' : 'text-gray-900'} truncate`}>{match.homeTeam}</span>
                <div className="w-10 h-10 md:w-12 md:h-12 rounded-xl flex items-center justify-center flex-shrink-0" 
                     style={{backgroundColor: `${match.homeColor}15`, border: `2px solid ${match.homeColor}40`}}>
                  <span className="text-lg md:text-xl" style={{color: match.homeColor}}>🛡️</span>
                </div>
              </div>

              <div className="col-span-1 flex items-center justify-center">
                <div className={`text-lg md:text-2xl font-bold ${darkMode ? 'text-gray-600' : 'text-gray-400'}`}>VS</div>
              </div>

              <div className="col-span-3 flex items-center justify-start space-x-3">
                <div className="w-10 h-10 md:w-12 md:h-12 rounded-xl flex items-center justify-center flex-shrink-0" 
                     style={{backgroundColor: `${match.awayColor}15`, border: `2px solid ${match.awayColor}40`}}>
                  <span className="text-lg md:text-xl" style={{color: match.awayColor}}>🛡️</span>
                </div>
                <span className={`text-sm md:text-base font-semibold ${darkMode ? 'text-white' : 'text-gray-900'} truncate`}>{match.awayTeam}</span>
              </div>
            </div>
          </div>
        ))}
      </div>
    </div>
  );
};

export default FixturesPage;
