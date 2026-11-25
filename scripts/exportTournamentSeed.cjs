// Emits idempotent SQL for the curated archives and upcoming tournaments.
// Does not connect to a database; existing administrator changes are preserved.
const path = require('node:path');
const fs = require('node:fs');
const Module = require('node:module');
const babel = require('@babel/core');
const source = path.resolve(__dirname, '../src') + path.sep;
const original = Module._extensions['.js'];
Module._extensions['.js'] = (module, filename) => {
  if (!filename.startsWith(source)) return original(module, filename);
  const output = babel.transformSync(fs.readFileSync(filename, 'utf8'), {
    filename, configFile: false, babelrc: false,
    plugins: ['@babel/plugin-transform-modules-commonjs'],
  });
  module._compile(output.code, filename);
};
const { tournamentCatalog } = require('../src/data/tournamentDemo');
const { validateManagedTournament } = require('../src/lib/tournamentManagement');
const selected = process.argv[2] ? tournamentCatalog.filter(t => t.slug === process.argv[2]) : tournamentCatalog;
if (!selected.length) throw new Error('Unknown tournament');
const documents = selected.map(validateManagedTournament);
const json = JSON.stringify(documents);
if (json.includes('$tournaments$')) throw new Error('Invalid SQL delimiter');
process.stdout.write(`INSERT INTO public.tournament_documents(slug,document) SELECT value->>'slug',value FROM jsonb_array_elements($tournaments$${json}$tournaments$::jsonb) ON CONFLICT(slug) DO NOTHING RETURNING slug,revision;\n`);
