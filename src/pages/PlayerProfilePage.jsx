import React from 'react';
import { ChevronRight, Trophy, Shield } from 'lucide-react';

const PlayerProfilePage = ({ player, onBack, darkMode }) => {
  if (!player) return null;

  return (
    <div className="space-y-6">
      <button onClick={onBack} className={`flex items-center space-x-2 ${darkMode ? 'text-gray-400 hover:text-white' : 'text-gray-600 hover:text-gray-900'}`}>
        <ChevronRight size={20} className="rotate-180" />
        <span>Powrót do statystyk</span>
      </button>

      <div className={`${darkMode ? 'bg-gradient-to-br from-[#141b2d] to-[#0d1117] border-gray-800' : 'bg-gradient-to-br from-gray-50 to-white border-gray-200'} rounded-2xl border p-6 md:p-8`}>
        <div className="flex flex-col md:flex-row items-center md:items-start space-y-4 md:space-y-0 md:space-x-6">
          <div className={`w-24 h-24 md:w-32 md:h-32 rounded-full ${darkMode ? 'bg-gradient-to-br from-green-500/20 to-blue-500/20' : 'bg-gradient-to-br from-green-100 to-blue-100'} flex items-center justify-center text-4xl md:text-5xl font-bold ${darkMode ? 'text-green-400' : 'text-green-600'}`}>
            {player.name.charAt(0)}
          </div>
          <div className="flex-1 text-center md:text-left">
            <h1 className={`text-2xl md:text-4xl font-bold ${darkMode ? 'text-white' : 'text-gray-900'} mb-2`} style={{fontFamily: 'Oswald, sans-serif'}}>{player.name}</h1>
            <div className="flex flex-wrap justify-center md:justify-start gap-4 text-sm">
              <div className="flex items-center space-x-2">
                <div className="w-6 h-6 rounded flex items-center justify-center" style={{backgroundColor: `${player.teamColor}15`}}>
                  <span className="text-xs" style={{color: player.teamColor}}>🛡️</span>
                </div>
                <span className={darkMode ? 'text-gray-400' : 'text-gray-600'}>{player.team}</span>
              </div>
              <div className={`flex items-center space-x-2 ${darkMode ? 'text-gray-400' : 'text-gray-600'}`}>
                <Trophy size={16} />
                <span>{player.position}</span>
              </div>
              <div className={`flex items-center space-x-2 ${darkMode ? 'text-gray-400' : 'text-gray-600'}`}>
                <Shield size={16} />
                <span>Nr {player.number}</span>
              </div>
            </div>
          </div>
        </div>
      </div>

      <div className="grid grid-cols-2 md:grid-cols-4 gap-4">
        <div className={`${darkMode ? 'bg-[#0d1117] border-gray-800' : 'bg-white border-gray-200'} rounded-xl border p-6 text-center`}>
          <div className="text-3xl font-bold text-green-400 mb-2">{player.goals}</div>
          <div className={`text-sm ${darkMode ? 'text-gray-400' : 'text-gray-600'}`}>Bramki</div>
        </div>
        <div className={`${darkMode ? 'bg-[#0d1117] border-gray-800' : 'bg-white border-gray-200'} rounded-xl border p-6 text-center`}>
          <div className="text-3xl font-bold text-blue-400 mb-2">{player.assists}</div>
          <div className={`text-sm ${darkMode ? 'text-gray-400' : 'text-gray-600'}`}>Asysty</div>
        </div>
        <div className={`${darkMode ? 'bg-[#0d1117] border-gray-800' : 'bg-white border-gray-200'} rounded-xl border p-6 text-center`}>
          <div className="text-3xl font-bold text-purple-400 mb-2">{player.matches}</div>
          <div className={`text-sm ${darkMode ? 'text-gray-400' : 'text-gray-600'}`}>Mecze</div>
        </div>
        <div className={`${darkMode ? 'bg-[#0d1117] border-gray-800' : 'bg-white border-gray-200'} rounded-xl border p-6 text-center`}>
          <div className="text-3xl font-bold text-yellow-400 mb-2">{(player.goals / player.matches).toFixed(2)}</div>
          <div className={`text-sm ${darkMode ? 'text-gray-400' : 'text-gray-600'}`}>Średnia/mecz</div>
        </div>
      </div>

      <div className={`${darkMode ? 'bg-[#0d1117] border-gray-800' : 'bg-white border-gray-200'} rounded-xl border p-6`}>
        <h3 className={`text-lg font-bold ${darkMode ? 'text-white' : 'text-gray-900'} mb-4`}>Występy w sezonie</h3>
        <div className="grid grid-cols-3 md:grid-cols-6 gap-2">
          {Array(20).fill(0).map((_, idx) => (
            <div key={idx} className={`h-12 rounded-lg ${
              idx < player.goals ? 'bg-green-500/20' :
              idx < player.goals + player.assists ? 'bg-blue-500/20' :
              darkMode ? 'bg-gray-800' : 'bg-gray-100'
            } flex items-center justify-center text-xs font-medium ${
              idx < player.goals ? 'text-green-400' :
              idx < player.goals + player.assists ? 'text-blue-400' :
              darkMode ? 'text-gray-600' : 'text-gray-400'
            }`}>
              {idx + 1}
            </div>
          ))}
        </div>
        <div className="flex items-center justify-center space-x-4 mt-4 text-xs">
          <div className="flex items-center space-x-2">
            <div className="w-3 h-3 rounded bg-green-500/20"></div>
            <span className={darkMode ? 'text-gray-400' : 'text-gray-600'}>Bramka</span>
          </div>
          <div className="flex items-center space-x-2">
            <div className="w-3 h-3 rounded bg-blue-500/20"></div>
            <span className={darkMode ? 'text-gray-400' : 'text-gray-600'}>Asysta</span>
          </div>
        </div>
      </div>
    </div>
  );
};

export default PlayerProfilePage;
