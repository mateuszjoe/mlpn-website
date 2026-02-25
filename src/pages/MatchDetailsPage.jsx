import React from 'react';
import { ChevronRight, Users, Clock } from 'lucide-react';

const MatchDetailsPage = ({ match, onBack, darkMode }) => {
  if (!match) return null;
  
  const isResult = 'homeScore' in match;

  return (
    <div className="space-y-6">
      <button onClick={onBack} className={`flex items-center space-x-2 ${darkMode ? 'text-gray-400 hover:text-white' : 'text-gray-600 hover:text-gray-900'}`}>
        <ChevronRight size={20} className="rotate-180" />
        <span>Powrót</span>
      </button>

      <div className={`${darkMode ? 'bg-gradient-to-br from-[#141b2d] to-[#0d1117] border-gray-800' : 'bg-gradient-to-br from-gray-50 to-white border-gray-200'} rounded-2xl border p-6 md:p-8`}>
        <div className="text-center mb-6">
          <div className={`inline-block px-4 py-2 rounded-lg ${darkMode ? 'bg-gray-800' : 'bg-gray-100'} mb-4`}>
            <span className={`text-sm font-medium ${darkMode ? 'text-gray-400' : 'text-gray-600'}`}>
              Kolejka {match.round} • {match.date} • {match.time}
            </span>
          </div>
        </div>

        <div className="grid grid-cols-3 gap-4 md:gap-8 items-center">
          <div className="text-center">
            <div className="w-20 h-20 md:w-32 md:h-32 mx-auto mb-4 rounded-2xl flex items-center justify-center" 
                 style={{backgroundColor: `${match.homeColor}15`, border: `2px solid ${match.homeColor}40`}}>
              <div className="text-3xl md:text-5xl" style={{color: match.homeColor}}>🛡️</div>
            </div>
            <h3 className={`text-base md:text-xl font-bold ${darkMode ? 'text-white' : 'text-gray-900'}`}>{match.homeTeam}</h3>
          </div>

          <div className="text-center">
            {isResult ? (
              <div className="flex items-center justify-center space-x-2 md:space-x-4">
                <span className="text-4xl md:text-6xl font-bold text-green-400">{match.homeScore}</span>
                <span className={`text-2xl md:text-4xl ${darkMode ? 'text-gray-600' : 'text-gray-400'}`}>:</span>
                <span className="text-4xl md:text-6xl font-bold text-green-400">{match.awayScore}</span>
              </div>
            ) : (
              <div className={`text-3xl md:text-5xl font-bold ${darkMode ? 'text-gray-600' : 'text-gray-400'}`}>VS</div>
            )}
          </div>

          <div className="text-center">
            <div className="w-20 h-20 md:w-32 md:h-32 mx-auto mb-4 rounded-2xl flex items-center justify-center" 
                 style={{backgroundColor: `${match.awayColor}15`, border: `2px solid ${match.awayColor}40`}}>
              <div className="text-3xl md:text-5xl" style={{color: match.awayColor}}>🛡️</div>
            </div>
            <h3 className={`text-base md:text-xl font-bold ${darkMode ? 'text-white' : 'text-gray-900'}`}>{match.awayTeam}</h3>
          </div>
        </div>

        {isResult && match.attended && (
          <div className={`mt-6 pt-6 border-t ${darkMode ? 'border-gray-800' : 'border-gray-200'} text-center`}>
            <div className={`flex items-center justify-center space-x-2 ${darkMode ? 'text-gray-400' : 'text-gray-600'}`}>
              <Users size={18} />
              <span>Frekwencja: {match.attended} kibiców</span>
            </div>
          </div>
        )}
      </div>

      {!isResult && (
        <div className={`${darkMode ? 'bg-[#0d1117] border-gray-800' : 'bg-white border-gray-200'} rounded-xl border p-6 text-center`}>
          <Clock size={48} className={`mx-auto mb-4 ${darkMode ? 'text-gray-600' : 'text-gray-400'}`} />
          <p className={`text-lg ${darkMode ? 'text-gray-400' : 'text-gray-600'}`}>Mecz jeszcze się nie odbył</p>
        </div>
      )}
    </div>
  );
};

export default MatchDetailsPage;
