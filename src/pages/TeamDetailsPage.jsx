import React from 'react';
import { ChevronRight, MapPin, User, Calendar } from 'lucide-react';

const TeamDetailsPage = ({ team, onBack, darkMode }) => {
  if (!team) return null;

  return (
    <div className="space-y-6">
      <button onClick={onBack} className={`flex items-center space-x-2 ${darkMode ? 'text-gray-400 hover:text-white' : 'text-gray-600 hover:text-gray-900'}`}>
        <ChevronRight size={20} className="rotate-180" />
        <span>Powrót do drużyn</span>
      </button>

      <div className={`${darkMode ? 'bg-gradient-to-br from-[#141b2d] to-[#0d1117] border-gray-800' : 'bg-gradient-to-br from-gray-50 to-white border-gray-200'} rounded-2xl border p-6 md:p-8`}>
        <div className="flex flex-col md:flex-row items-center md:items-start space-y-4 md:space-y-0 md:space-x-6">
          <div className="w-24 h-24 md:w-32 md:h-32 rounded-2xl flex items-center justify-center" 
               style={{backgroundColor: `${team.color}15`, border: `3px solid ${team.color}40`}}>
            <div className="text-5xl md:text-6xl" style={{color: team.color}}>{team.logo}</div>
          </div>
          <div className="flex-1 text-center md:text-left">
            <h1 className={`text-2xl md:text-4xl font-bold ${darkMode ? 'text-white' : 'text-gray-900'} mb-2`} style={{fontFamily: 'Oswald, sans-serif'}}>{team.name}</h1>
            <div className="flex flex-wrap justify-center md:justify-start gap-4 text-sm">
              <div className={`flex items-center space-x-2 ${darkMode ? 'text-gray-400' : 'text-gray-600'}`}>
                <MapPin size={16} />
                <span>{team.stadium}</span>
              </div>
              <div className={`flex items-center space-x-2 ${darkMode ? 'text-gray-400' : 'text-gray-600'}`}>
                <User size={16} />
                <span>Trener: {team.manager}</span>
              </div>
              <div className={`flex items-center space-x-2 ${darkMode ? 'text-gray-400' : 'text-gray-600'}`}>
                <Calendar size={16} />
                <span>Założono: {team.founded}</span>
              </div>
            </div>
          </div>
          <div className={`px-6 py-4 rounded-xl ${darkMode ? 'bg-gray-800/50' : 'bg-gray-100'}`}>
            <div className="text-center">
              <div className="text-4xl font-bold text-green-400 mb-1">{team.position}</div>
              <div className={`text-xs ${darkMode ? 'text-gray-500' : 'text-gray-600'}`}>Pozycja w tabeli</div>
            </div>
          </div>
        </div>
      </div>

      <div className="grid grid-cols-2 md:grid-cols-4 gap-4">
        <div className={`${darkMode ? 'bg-[#0d1117] border-gray-800' : 'bg-white border-gray-200'} rounded-xl border p-6 text-center`}>
          <div className="text-3xl font-bold text-green-400 mb-2">{team.points}</div>
          <div className={`text-sm ${darkMode ? 'text-gray-400' : 'text-gray-600'}`}>Punkty</div>
        </div>
        <div className={`${darkMode ? 'bg-[#0d1117] border-gray-800' : 'bg-white border-gray-200'} rounded-xl border p-6 text-center`}>
          <div className="text-3xl font-bold text-blue-400 mb-2">{team.wins}</div>
          <div className={`text-sm ${darkMode ? 'text-gray-400' : 'text-gray-600'}`}>Wygrane</div>
        </div>
        <div className={`${darkMode ? 'bg-[#0d1117] border-gray-800' : 'bg-white border-gray-200'} rounded-xl border p-6 text-center`}>
          <div className="text-3xl font-bold text-yellow-400 mb-2">{team.draws}</div>
          <div className={`text-sm ${darkMode ? 'text-gray-400' : 'text-gray-600'}`}>Remisy</div>
        </div>
        <div className={`${darkMode ? 'bg-[#0d1117] border-gray-800' : 'bg-white border-gray-200'} rounded-xl border p-6 text-center`}>
          <div className="text-3xl font-bold text-red-400 mb-2">{team.losses}</div>
          <div className={`text-sm ${darkMode ? 'text-gray-400' : 'text-gray-600'}`}>Porażki</div>
        </div>
      </div>

      <div className="grid grid-cols-1 md:grid-cols-2 gap-6">
        <div className={`${darkMode ? 'bg-[#0d1117] border-gray-800' : 'bg-white border-gray-200'} rounded-xl border p-6`}>
          <h3 className={`text-lg font-bold ${darkMode ? 'text-white' : 'text-gray-900'} mb-4`}>Ostatnie 5 meczów</h3>
          <div className="flex items-center justify-center space-x-2">
            {team.form.map((result, idx) => (
              <div key={idx} className={`w-12 h-12 rounded-lg flex items-center justify-center font-bold ${
                result === 'W' ? 'bg-green-500/20 text-green-400' :
                result === 'D' ? 'bg-yellow-500/20 text-yellow-400' :
                'bg-red-500/20 text-red-400'
              }`}>{result}</div>
            ))}
          </div>
        </div>

        <div className={`${darkMode ? 'bg-[#0d1117] border-gray-800' : 'bg-white border-gray-200'} rounded-xl border p-6`}>
          <h3 className={`text-lg font-bold ${darkMode ? 'text-white' : 'text-gray-900'} mb-4`}>Bramki</h3>
          <div className="grid grid-cols-2 gap-4">
            <div className="text-center">
              <div className="text-3xl font-bold text-green-400 mb-1">{team.goalsFor}</div>
              <div className={`text-sm ${darkMode ? 'text-gray-400' : 'text-gray-600'}`}>Strzelone</div>
            </div>
            <div className="text-center">
              <div className="text-3xl font-bold text-red-400 mb-1">{team.goalsAgainst}</div>
              <div className={`text-sm ${darkMode ? 'text-gray-400' : 'text-gray-600'}`}>Stracone</div>
            </div>
          </div>
        </div>
      </div>
    </div>
  );
};

export default TeamDetailsPage;
