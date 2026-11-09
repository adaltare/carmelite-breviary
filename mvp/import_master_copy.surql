-- Import a JSON master copy into SurrealDB as one `office` record holding
-- an ordered list of `fragment` records.
--
-- 1. Paste the whole contents of the JSON file (e.g. dominica-lauds.json)
--    in place of PASTE_JSON_HERE below.
-- 2. Set the office id, title and first page.
-- 3. Run it, e.g.:
--      surreal sql --endpoint http://127.0.0.1:8000 --user root --pass root \
--        --ns breviary --db breviary1938 < import_master_copy.surql
--
-- Running it again for the same office replaces that office and its
-- fragments rather than duplicating them.

-- ---------------------------------------------------------------- schema

DEFINE TABLE IF NOT EXISTS office SCHEMAFULL;
DEFINE FIELD IF NOT EXISTS title      ON office TYPE string;
DEFINE FIELD IF NOT EXISTS first_page ON office TYPE int;
DEFINE FIELD IF NOT EXISTS version    ON office TYPE string;
DEFINE FIELD IF NOT EXISTS fragments  ON office TYPE array<record<fragment>>;

DEFINE TABLE IF NOT EXISTS fragment SCHEMAFULL;
DEFINE FIELD IF NOT EXISTS office ON fragment TYPE record<office>;
DEFINE FIELD IF NOT EXISTS type   ON fragment TYPE string ASSERT $value IN [
  "part_title", "hour", "nocturn", "pater_ave", "antiphon", "v_line", "r_line",
  "line_of", "versicle", "invitatory", "hymn", "psalm", "canticle", "capitulum",
  "rubric", "double_rule", "end_columns", "blank"
];
DEFINE FIELD IF NOT EXISTS attributes ON fragment TYPE option<object> FLEXIBLE;
DEFINE FIELD IF NOT EXISTS text       ON fragment TYPE option<string | array | object> FLEXIBLE;

-- ---------------------------------------------------------------- import

LET $office = office:dominica_laudes;
LET $data = PASTE_JSON_HERE;

BEGIN TRANSACTION;

-- Clear a previous import of this office.
DELETE fragment WHERE office = $office;

-- One record per fragment. INSERT returns them in input order, so their
-- ids give the office's fragment order.
LET $ids = (INSERT INTO fragment (
  SELECT type, attributes, text, $office AS office FROM $data.fragments
)).id;

UPSERT $office CONTENT {
  title: "Dominica ad Matutinum et ad Laudes",
  first_page: 21,
  version: $data.version,
  fragments: $ids,
};

COMMIT TRANSACTION;

-- ---------------------------------------------------------------- check

-- Fragments per type.
SELECT type, count() AS n FROM fragment WHERE office = $office GROUP BY type;

-- Export back to the master-copy JSON shape (what render-master reads).
SELECT VALUE { version: version, fragments: fragments.{ type, attributes, text } }
FROM ONLY $office;
