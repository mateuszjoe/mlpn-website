const path = require("path");
require("dotenv").config({ path: path.join(__dirname, "..", ".env.local") });
const { createClient } = require("@supabase/supabase-js");

const sb = createClient(
  process.env.REACT_APP_SUPABASE_URL,
  process.env.SUPABASE_SERVICE_KEY
);

const sql = `
CREATE OR REPLACE FUNCTION exec_sql(query text) RETURNS void
LANGUAGE plpgsql SECURITY DEFINER AS $body$
BEGIN
  SET LOCAL statement_timeout = '300s';
  EXECUTE query;
END; $body$;
`;

sb.rpc("exec_sql", { query: sql }).then(({ error }) => {
  if (error) console.log("BŁĄD:", error.message);
  else console.log("OK - exec_sql zaktualizowany (timeout 300s)");
});
