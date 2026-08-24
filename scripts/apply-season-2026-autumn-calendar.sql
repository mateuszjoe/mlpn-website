-- Idempotentna korekta jesiennego terminarza MLPN, sezon 2026.
--
-- Zakres:
--   * I liga K12-K20: start 5/6 wrzesnia, przerwa 31.10-02.11,
--     mecze Al Mar/Starszaki/Rebelianci od pazdziernika i zero ich meczow
--     z 1 WBP we wrzesniu;
--   * II liga K11-K20: wykorzystanie wolnego weekendu 5/6 wrzesnia;
--   * III liga K14-K26: przesuniecie po wczesniej rozegranej K13 oraz
--     naprawa podwojnych weekendow K21/K23 i K22/K24;
--   * zalegly III-ligowy mecz K22 z 31.08 pozostaje bez zmian.
--
-- Skrypt zachowuje ID, pary, statusy, wyniki, notes, media, eventy, sklady
-- i statystyki. Aktualizuje wylacznie round/match_date/match_time.
-- Mozna uruchomic ponownie: stan docelowy daje bezpieczny no-op.

BEGIN ISOLATION LEVEL SERIALIZABLE;

SET LOCAL lock_timeout = '5s';
SET LOCAL statement_timeout = '120s';

SELECT pg_advisory_xact_lock(
  hashtextextended('mlpn:season-2026:autumn-calendar-20260824', 0)
);

LOCK TABLE public.matches IN ACCESS EXCLUSIVE MODE;
LOCK TABLE public.standings IN SHARE ROW EXCLUSIVE MODE;
LOCK TABLE public.player_season_stats IN SHARE MODE;

CREATE TEMP TABLE mlpn_autumn_map (
  match_id uuid PRIMARY KEY,
  league_code text NOT NULL,
  expected_home_team_id uuid NOT NULL,
  expected_away_team_id uuid NOT NULL,
  source_round integer NOT NULL,
  source_date date NOT NULL,
  source_time time NOT NULL,
  target_round integer NOT NULL,
  target_date date NOT NULL,
  target_time time NOT NULL
);

INSERT INTO mlpn_autumn_map (
  match_id, league_code, expected_home_team_id, expected_away_team_id,
  source_round, source_date, source_time,
  target_round, target_date, target_time
)
VALUES
 ('b4e06d37-2ca7-4308-8e93-68554dd8043a'::uuid, '1st', '3e478adc-016c-49c0-b252-f3353d68190e'::uuid, 'f078a02a-8bdc-4081-a600-6fdb35c8d712'::uuid, 12, DATE '2026-08-29', TIME '19:20', 16, DATE '2026-10-03', TIME '19:20')
, ('8614420a-05c0-4154-9d75-6571ffbebab9'::uuid, '1st', 'bf258102-428d-4fa6-8730-23ce8740cbe6'::uuid, '764a8908-a15c-4043-9c02-0cb2eaa1d1dd'::uuid, 12, DATE '2026-08-30', TIME '17:10', 12, DATE '2026-09-06', TIME '17:10')
, ('44530415-1cb5-4272-9909-b6e2fe278acb'::uuid, '1st', '28709fe1-fcf5-4d51-a76a-3978790bfdcc'::uuid, '299c234a-da18-454f-956e-d536aec09ef4'::uuid, 12, DATE '2026-08-30', TIME '18:20', 12, DATE '2026-09-06', TIME '18:20')
, ('080781fa-9ceb-424e-ab5e-1c8e36b30140'::uuid, '1st', '51a943c3-229b-445e-a691-34c842b49c50'::uuid, '7581775c-7745-4fdf-b794-5772300b417b'::uuid, 12, DATE '2026-08-30', TIME '19:30', 12, DATE '2026-09-05', TIME '19:20')
, ('eb1e63be-1f7d-4342-af55-d58880c35471'::uuid, '1st', '73c96db7-15fa-4602-8796-8a12f684ee75'::uuid, 'a9d145fc-3c14-49e8-ba6c-d3103939626b'::uuid, 12, DATE '2026-08-31', TIME '21:00', 13, DATE '2026-09-13', TIME '19:30')
, ('57be604c-e576-466d-a95c-58384ecaa662'::uuid, '1st', '3e478adc-016c-49c0-b252-f3353d68190e'::uuid, '51a943c3-229b-445e-a691-34c842b49c50'::uuid, 13, DATE '2026-09-05', TIME '19:20', 18, DATE '2026-10-17', TIME '19:20')
, ('8bde8969-868d-4c09-8604-b2981a4145fa'::uuid, '1st', '28709fe1-fcf5-4d51-a76a-3978790bfdcc'::uuid, '73c96db7-15fa-4602-8796-8a12f684ee75'::uuid, 13, DATE '2026-09-06', TIME '17:10', 18, DATE '2026-10-18', TIME '17:10')
, ('05c0eb10-d876-4078-9476-830afb830cb7'::uuid, '1st', '299c234a-da18-454f-956e-d536aec09ef4'::uuid, '7581775c-7745-4fdf-b794-5772300b417b'::uuid, 13, DATE '2026-09-06', TIME '18:20', 19, DATE '2026-10-25', TIME '17:10')
, ('6127c623-aa3b-43a7-b2a7-bf74467b1222'::uuid, '1st', 'a9d145fc-3c14-49e8-ba6c-d3103939626b'::uuid, '764a8908-a15c-4043-9c02-0cb2eaa1d1dd'::uuid, 13, DATE '2026-09-06', TIME '19:30', 18, DATE '2026-10-19', TIME '21:00')
, ('68a070fd-c1b4-45b5-8efa-d1d7789b0c54'::uuid, '1st', 'f078a02a-8bdc-4081-a600-6fdb35c8d712'::uuid, 'bf258102-428d-4fa6-8730-23ce8740cbe6'::uuid, 13, DATE '2026-09-07', TIME '21:00', 19, DATE '2026-10-25', TIME '19:30')
, ('b4b3f0ce-777e-413c-8b11-ac2367faeba4'::uuid, '1st', '299c234a-da18-454f-956e-d536aec09ef4'::uuid, '3e478adc-016c-49c0-b252-f3353d68190e'::uuid, 14, DATE '2026-09-12', TIME '19:20', 14, DATE '2026-09-19', TIME '19:20')
, ('6635be33-a9a1-46ae-aef8-9ed31084e2bb'::uuid, '1st', 'a9d145fc-3c14-49e8-ba6c-d3103939626b'::uuid, 'bf258102-428d-4fa6-8730-23ce8740cbe6'::uuid, 14, DATE '2026-09-13', TIME '17:10', 14, DATE '2026-09-20', TIME '17:10')
, ('21de3a8c-172f-40e4-b68b-9d06a9014588'::uuid, '1st', '764a8908-a15c-4043-9c02-0cb2eaa1d1dd'::uuid, '28709fe1-fcf5-4d51-a76a-3978790bfdcc'::uuid, 14, DATE '2026-09-13', TIME '18:20', 14, DATE '2026-09-20', TIME '18:20')
, ('222c56de-8736-4de5-9ba1-b92c343f7359'::uuid, '1st', '7581775c-7745-4fdf-b794-5772300b417b'::uuid, '73c96db7-15fa-4602-8796-8a12f684ee75'::uuid, 14, DATE '2026-09-13', TIME '19:30', 14, DATE '2026-09-20', TIME '19:30')
, ('5fcbf392-9c0c-4b89-b173-155ab5540dae'::uuid, '1st', 'f078a02a-8bdc-4081-a600-6fdb35c8d712'::uuid, '51a943c3-229b-445e-a691-34c842b49c50'::uuid, 14, DATE '2026-09-14', TIME '21:00', 14, DATE '2026-09-21', TIME '21:00')
, ('68899486-122c-4645-8101-7b9754453328'::uuid, '1st', 'bf258102-428d-4fa6-8730-23ce8740cbe6'::uuid, '28709fe1-fcf5-4d51-a76a-3978790bfdcc'::uuid, 15, DATE '2026-09-19', TIME '19:20', 15, DATE '2026-09-26', TIME '19:20')
, ('b4fabebd-7230-4998-b430-ff61b505147e'::uuid, '1st', '299c234a-da18-454f-956e-d536aec09ef4'::uuid, '51a943c3-229b-445e-a691-34c842b49c50'::uuid, 15, DATE '2026-09-20', TIME '17:10', 15, DATE '2026-09-27', TIME '17:10')
, ('2d44ad76-be82-4de4-a929-5d4fffdd342e'::uuid, '1st', '764a8908-a15c-4043-9c02-0cb2eaa1d1dd'::uuid, '7581775c-7745-4fdf-b794-5772300b417b'::uuid, 15, DATE '2026-09-20', TIME '18:20', 15, DATE '2026-09-27', TIME '18:20')
, ('d855a392-d75d-4393-9baa-095506077cd0'::uuid, '1st', '73c96db7-15fa-4602-8796-8a12f684ee75'::uuid, '3e478adc-016c-49c0-b252-f3353d68190e'::uuid, 15, DATE '2026-09-20', TIME '19:30', 15, DATE '2026-09-27', TIME '19:30')
, ('2149ad0f-4b7e-4418-b520-2645af5ae708'::uuid, '1st', 'f078a02a-8bdc-4081-a600-6fdb35c8d712'::uuid, 'a9d145fc-3c14-49e8-ba6c-d3103939626b'::uuid, 15, DATE '2026-09-21', TIME '21:00', 15, DATE '2026-09-28', TIME '21:00')
, ('473a7bc6-4ca6-4c9b-bc4b-04f492fb3184'::uuid, '1st', '3e478adc-016c-49c0-b252-f3353d68190e'::uuid, '764a8908-a15c-4043-9c02-0cb2eaa1d1dd'::uuid, 16, DATE '2026-09-26', TIME '19:20', 13, DATE '2026-09-12', TIME '21:10')
, ('b9cdb8fb-387a-46f9-9e11-e002e2bd8625'::uuid, '1st', '28709fe1-fcf5-4d51-a76a-3978790bfdcc'::uuid, 'a9d145fc-3c14-49e8-ba6c-d3103939626b'::uuid, 16, DATE '2026-09-27', TIME '17:10', 16, DATE '2026-10-04', TIME '17:10')
, ('542853d7-4781-4d2f-b1ec-9aa54a6fcda1'::uuid, '1st', '7581775c-7745-4fdf-b794-5772300b417b'::uuid, 'bf258102-428d-4fa6-8730-23ce8740cbe6'::uuid, 16, DATE '2026-09-27', TIME '18:20', 16, DATE '2026-10-04', TIME '18:20')
, ('01db8d90-02df-4f59-a233-f3a5dce8a6dd'::uuid, '1st', '73c96db7-15fa-4602-8796-8a12f684ee75'::uuid, '51a943c3-229b-445e-a691-34c842b49c50'::uuid, 16, DATE '2026-09-27', TIME '19:30', 16, DATE '2026-10-04', TIME '19:30')
, ('48b8b90d-5a8c-4817-a6bb-a082a2c75a95'::uuid, '1st', 'f078a02a-8bdc-4081-a600-6fdb35c8d712'::uuid, '299c234a-da18-454f-956e-d536aec09ef4'::uuid, 16, DATE '2026-09-28', TIME '21:00', 13, DATE '2026-09-13', TIME '18:20')
, ('48b1700c-7325-4b15-adc7-dadf31cd06f2'::uuid, '1st', 'bf258102-428d-4fa6-8730-23ce8740cbe6'::uuid, '3e478adc-016c-49c0-b252-f3353d68190e'::uuid, 17, DATE '2026-10-03', TIME '19:20', 17, DATE '2026-10-10', TIME '19:20')
, ('d49fb494-0c23-4b62-9d2d-96e53c504134'::uuid, '1st', '28709fe1-fcf5-4d51-a76a-3978790bfdcc'::uuid, 'f078a02a-8bdc-4081-a600-6fdb35c8d712'::uuid, 17, DATE '2026-10-04', TIME '17:10', 17, DATE '2026-10-11', TIME '17:10')
, ('7de1baac-3158-4d44-be73-6c03c89dc3b6'::uuid, '1st', '51a943c3-229b-445e-a691-34c842b49c50'::uuid, '764a8908-a15c-4043-9c02-0cb2eaa1d1dd'::uuid, 17, DATE '2026-10-04', TIME '18:20', 17, DATE '2026-10-11', TIME '18:20')
, ('cd9f0d30-a28a-4c2c-aead-b6f7392d6bbe'::uuid, '1st', 'a9d145fc-3c14-49e8-ba6c-d3103939626b'::uuid, '7581775c-7745-4fdf-b794-5772300b417b'::uuid, 17, DATE '2026-10-04', TIME '19:30', 17, DATE '2026-10-11', TIME '19:30')
, ('116fd57d-3711-4b28-883c-2e3941ee9466'::uuid, '1st', '73c96db7-15fa-4602-8796-8a12f684ee75'::uuid, '299c234a-da18-454f-956e-d536aec09ef4'::uuid, 17, DATE '2026-10-05', TIME '21:00', 17, DATE '2026-10-12', TIME '21:00')
, ('6495d952-f701-405d-a116-807598e87bf5'::uuid, '1st', '28709fe1-fcf5-4d51-a76a-3978790bfdcc'::uuid, '7581775c-7745-4fdf-b794-5772300b417b'::uuid, 18, DATE '2026-10-10', TIME '19:20', 13, DATE '2026-09-14', TIME '21:00')
, ('aaf10b3e-ab8f-457f-8921-e92a4074a279'::uuid, '1st', '51a943c3-229b-445e-a691-34c842b49c50'::uuid, 'bf258102-428d-4fa6-8730-23ce8740cbe6'::uuid, 18, DATE '2026-10-11', TIME '17:10', 13, DATE '2026-09-13', TIME '17:10')
, ('99508582-eba6-4418-852f-a87c028faa8e'::uuid, '1st', 'a9d145fc-3c14-49e8-ba6c-d3103939626b'::uuid, '3e478adc-016c-49c0-b252-f3353d68190e'::uuid, 18, DATE '2026-10-11', TIME '18:20', 12, DATE '2026-09-06', TIME '19:30')
, ('d2801e3d-2214-46cb-a84e-9a3da1f0534d'::uuid, '1st', '764a8908-a15c-4043-9c02-0cb2eaa1d1dd'::uuid, '299c234a-da18-454f-956e-d536aec09ef4'::uuid, 18, DATE '2026-10-11', TIME '19:30', 16, DATE '2026-10-05', TIME '21:00')
, ('77dfe378-ab53-45c2-b195-3c06c91bb940'::uuid, '1st', '73c96db7-15fa-4602-8796-8a12f684ee75'::uuid, 'f078a02a-8bdc-4081-a600-6fdb35c8d712'::uuid, 18, DATE '2026-10-12', TIME '21:00', 12, DATE '2026-09-05', TIME '20:30')
, ('e02304a9-e0f6-4d7b-939f-170f00558206'::uuid, '1st', '3e478adc-016c-49c0-b252-f3353d68190e'::uuid, '28709fe1-fcf5-4d51-a76a-3978790bfdcc'::uuid, 19, DATE '2026-10-17', TIME '19:20', 19, DATE '2026-10-24', TIME '19:20')
, ('099984d2-af17-43bb-97a3-066f0e2bd55f'::uuid, '1st', '299c234a-da18-454f-956e-d536aec09ef4'::uuid, 'bf258102-428d-4fa6-8730-23ce8740cbe6'::uuid, 19, DATE '2026-10-18', TIME '17:10', 18, DATE '2026-10-18', TIME '18:20')
, ('08286ad0-e5f9-4a2a-a0d3-352f605de763'::uuid, '1st', 'a9d145fc-3c14-49e8-ba6c-d3103939626b'::uuid, '51a943c3-229b-445e-a691-34c842b49c50'::uuid, 19, DATE '2026-10-18', TIME '18:20', 19, DATE '2026-10-25', TIME '18:20')
, ('35363263-13fc-4d78-98c1-95da2218b6f6'::uuid, '1st', '7581775c-7745-4fdf-b794-5772300b417b'::uuid, 'f078a02a-8bdc-4081-a600-6fdb35c8d712'::uuid, 19, DATE '2026-10-18', TIME '19:30', 18, DATE '2026-10-18', TIME '19:30')
, ('f674abac-7025-459a-93c8-3efb57366f38'::uuid, '1st', '73c96db7-15fa-4602-8796-8a12f684ee75'::uuid, '764a8908-a15c-4043-9c02-0cb2eaa1d1dd'::uuid, 19, DATE '2026-10-19', TIME '21:00', 19, DATE '2026-10-26', TIME '21:00')
, ('f3b40028-7c9a-420a-9be0-db0175cbcc96'::uuid, '1st', '3e478adc-016c-49c0-b252-f3353d68190e'::uuid, '7581775c-7745-4fdf-b794-5772300b417b'::uuid, 20, DATE '2026-10-24', TIME '19:20', 20, DATE '2026-11-07', TIME '19:20')
, ('d80776cf-99d4-4691-9dea-320b689adaa8'::uuid, '1st', '51a943c3-229b-445e-a691-34c842b49c50'::uuid, '28709fe1-fcf5-4d51-a76a-3978790bfdcc'::uuid, 20, DATE '2026-10-25', TIME '17:10', 20, DATE '2026-11-08', TIME '17:10')
, ('5d7d8a22-98a8-4460-b57d-11e93b0be5ed'::uuid, '1st', 'a9d145fc-3c14-49e8-ba6c-d3103939626b'::uuid, '299c234a-da18-454f-956e-d536aec09ef4'::uuid, 20, DATE '2026-10-25', TIME '18:20', 20, DATE '2026-11-08', TIME '18:20')
, ('a0cca4d9-b04e-46fe-a349-93feb3beb528'::uuid, '1st', '764a8908-a15c-4043-9c02-0cb2eaa1d1dd'::uuid, 'f078a02a-8bdc-4081-a600-6fdb35c8d712'::uuid, 20, DATE '2026-10-25', TIME '19:30', 20, DATE '2026-11-08', TIME '19:30')
, ('25793879-7ef4-4e98-92bb-a8904df45d76'::uuid, '1st', '73c96db7-15fa-4602-8796-8a12f684ee75'::uuid, 'bf258102-428d-4fa6-8730-23ce8740cbe6'::uuid, 20, DATE '2026-10-26', TIME '21:00', 20, DATE '2026-11-09', TIME '21:00')
, ('40b8c2c4-91cb-4a79-b2fa-dfd7413fe6e9'::uuid, '2nd', '7631e392-d4fd-4b7e-8fd1-f3b6513087ca'::uuid, '7d4d6fdc-c4fc-4120-8953-189c08e00106'::uuid, 11, DATE '2026-09-12', TIME '18:10', 11, DATE '2026-09-05', TIME '18:10')
, ('72d45e1a-0dc3-4b6f-bcec-3425a5d8f9d2'::uuid, '2nd', '074ed17f-e2e8-4b47-b70c-e9922f813407'::uuid, 'c02b7728-ab92-4889-91ab-f0a1726ebe39'::uuid, 11, DATE '2026-09-13', TIME '13:40', 11, DATE '2026-09-06', TIME '13:40')
, ('1cf00202-24ba-49a5-94cf-96c8b01d5083'::uuid, '2nd', '2d8df861-c02d-43ad-b6b4-dd4c2288940e'::uuid, '4cdb4a72-db68-4774-bd0a-aac0338ac1ea'::uuid, 11, DATE '2026-09-13', TIME '14:50', 11, DATE '2026-09-06', TIME '14:50')
, ('1723420c-bc89-440b-a90e-ddae44524c24'::uuid, '2nd', '2c57c925-c479-40e6-85be-362c78ab43af'::uuid, '51b657ca-44dd-485a-9287-d48dfca482c7'::uuid, 11, DATE '2026-09-13', TIME '16:00', 11, DATE '2026-09-06', TIME '16:00')
, ('6de992f0-eecc-45be-a375-4d6b1ada027c'::uuid, '2nd', '58829f1d-c80e-4feb-8918-6d76d1d84489'::uuid, 'b89fa62d-d77b-45af-a2c0-9df8672b7f63'::uuid, 11, DATE '2026-09-14', TIME '19:50', 11, DATE '2026-09-06', TIME '20:40')
, ('ee39907f-9602-4b65-8983-213d23efc0a4'::uuid, '2nd', '7d4d6fdc-c4fc-4120-8953-189c08e00106'::uuid, '51b657ca-44dd-485a-9287-d48dfca482c7'::uuid, 12, DATE '2026-09-19', TIME '18:10', 12, DATE '2026-09-12', TIME '20:00')
, ('4a95d23e-1350-41e2-9e68-1c35aedd1222'::uuid, '2nd', '2d8df861-c02d-43ad-b6b4-dd4c2288940e'::uuid, '7631e392-d4fd-4b7e-8fd1-f3b6513087ca'::uuid, 12, DATE '2026-09-20', TIME '13:40', 12, DATE '2026-09-13', TIME '13:40')
, ('0adb3c90-7560-48d1-8809-09d0ea1ed50c'::uuid, '2nd', 'b89fa62d-d77b-45af-a2c0-9df8672b7f63'::uuid, '2c57c925-c479-40e6-85be-362c78ab43af'::uuid, 12, DATE '2026-09-20', TIME '14:50', 12, DATE '2026-09-13', TIME '14:50')
, ('2f4e7d41-463f-4519-a946-2e39d997ad60'::uuid, '2nd', '4cdb4a72-db68-4774-bd0a-aac0338ac1ea'::uuid, '074ed17f-e2e8-4b47-b70c-e9922f813407'::uuid, 12, DATE '2026-09-20', TIME '16:00', 12, DATE '2026-09-13', TIME '16:00')
, ('7e2daccf-4763-485a-8813-7534a99d3d6f'::uuid, '2nd', '777e2624-6a7b-44c9-8948-488ab6e41f41'::uuid, '58829f1d-c80e-4feb-8918-6d76d1d84489'::uuid, 12, DATE '2026-09-21', TIME '19:50', 12, DATE '2026-09-13', TIME '20:40')
, ('cb208e9f-b64a-4911-a213-f5469d93f5da'::uuid, '2nd', '51b657ca-44dd-485a-9287-d48dfca482c7'::uuid, 'b89fa62d-d77b-45af-a2c0-9df8672b7f63'::uuid, 13, DATE '2026-09-26', TIME '18:10', 13, DATE '2026-09-19', TIME '18:10')
, ('bfd65587-bd37-4182-8162-3ca47a4170b9'::uuid, '2nd', '7d4d6fdc-c4fc-4120-8953-189c08e00106'::uuid, '2d8df861-c02d-43ad-b6b4-dd4c2288940e'::uuid, 13, DATE '2026-09-27', TIME '13:40', 13, DATE '2026-09-20', TIME '13:40')
, ('3acac7bb-c9cc-4448-b0bd-6d2f9bb0b559'::uuid, '2nd', '7631e392-d4fd-4b7e-8fd1-f3b6513087ca'::uuid, '074ed17f-e2e8-4b47-b70c-e9922f813407'::uuid, 13, DATE '2026-09-27', TIME '14:50', 13, DATE '2026-09-20', TIME '14:50')
, ('04f0f199-aefc-4d6e-8fc5-b1f2c2474ce7'::uuid, '2nd', 'c02b7728-ab92-4889-91ab-f0a1726ebe39'::uuid, '58829f1d-c80e-4feb-8918-6d76d1d84489'::uuid, 13, DATE '2026-09-27', TIME '16:00', 13, DATE '2026-09-20', TIME '16:00')
, ('cee22b17-c650-4732-aba5-9dc8453e79fc'::uuid, '2nd', '2c57c925-c479-40e6-85be-362c78ab43af'::uuid, '777e2624-6a7b-44c9-8948-488ab6e41f41'::uuid, 13, DATE '2026-09-28', TIME '19:50', 13, DATE '2026-09-21', TIME '19:50')
, ('4ba8a24d-8b42-4086-ac91-934a782c9732'::uuid, '2nd', '777e2624-6a7b-44c9-8948-488ab6e41f41'::uuid, 'b89fa62d-d77b-45af-a2c0-9df8672b7f63'::uuid, 14, DATE '2026-10-03', TIME '18:10', 14, DATE '2026-09-26', TIME '18:10')
, ('5f49059d-43cb-42aa-8087-d4625d6d9ba4'::uuid, '2nd', '7d4d6fdc-c4fc-4120-8953-189c08e00106'::uuid, '074ed17f-e2e8-4b47-b70c-e9922f813407'::uuid, 14, DATE '2026-10-04', TIME '13:40', 14, DATE '2026-09-27', TIME '13:40')
, ('eeb65f4c-2cea-4799-a78d-226dcdab9fd1'::uuid, '2nd', '2c57c925-c479-40e6-85be-362c78ab43af'::uuid, 'c02b7728-ab92-4889-91ab-f0a1726ebe39'::uuid, 14, DATE '2026-10-04', TIME '14:50', 14, DATE '2026-09-27', TIME '14:50')
, ('691fd433-ab30-4ce9-83bf-164c04528a93'::uuid, '2nd', '4cdb4a72-db68-4774-bd0a-aac0338ac1ea'::uuid, '58829f1d-c80e-4feb-8918-6d76d1d84489'::uuid, 14, DATE '2026-10-04', TIME '16:00', 14, DATE '2026-09-27', TIME '16:00')
, ('34cf81fc-93be-49c6-b0a0-0105a0ad5447'::uuid, '2nd', '2d8df861-c02d-43ad-b6b4-dd4c2288940e'::uuid, '51b657ca-44dd-485a-9287-d48dfca482c7'::uuid, 14, DATE '2026-10-05', TIME '19:50', 14, DATE '2026-09-28', TIME '19:50')
, ('bfc1c00d-3aee-4fef-bff2-de7c6f4d4de1'::uuid, '2nd', '7631e392-d4fd-4b7e-8fd1-f3b6513087ca'::uuid, '58829f1d-c80e-4feb-8918-6d76d1d84489'::uuid, 15, DATE '2026-10-10', TIME '18:10', 15, DATE '2026-10-03', TIME '18:10')
, ('1183ae25-4c32-43e4-a3e4-10e07b6d84c0'::uuid, '2nd', 'c02b7728-ab92-4889-91ab-f0a1726ebe39'::uuid, 'b89fa62d-d77b-45af-a2c0-9df8672b7f63'::uuid, 15, DATE '2026-10-11', TIME '13:40', 15, DATE '2026-10-04', TIME '13:40')
, ('770bfac5-2795-4078-b25f-a8ad6365dfef'::uuid, '2nd', '074ed17f-e2e8-4b47-b70c-e9922f813407'::uuid, '2d8df861-c02d-43ad-b6b4-dd4c2288940e'::uuid, 15, DATE '2026-10-11', TIME '14:50', 15, DATE '2026-10-04', TIME '14:50')
, ('57307d03-8263-4629-817e-0255d269111e'::uuid, '2nd', '2c57c925-c479-40e6-85be-362c78ab43af'::uuid, '4cdb4a72-db68-4774-bd0a-aac0338ac1ea'::uuid, 15, DATE '2026-10-11', TIME '16:00', 15, DATE '2026-10-04', TIME '16:00')
, ('f15478ba-0f28-476d-9196-dfa2c34115a4'::uuid, '2nd', '777e2624-6a7b-44c9-8948-488ab6e41f41'::uuid, '51b657ca-44dd-485a-9287-d48dfca482c7'::uuid, 15, DATE '2026-10-12', TIME '19:50', 15, DATE '2026-10-05', TIME '19:50')
, ('73bed1d3-7159-41be-8ec9-ae4483e81e7d'::uuid, '2nd', 'b89fa62d-d77b-45af-a2c0-9df8672b7f63'::uuid, '4cdb4a72-db68-4774-bd0a-aac0338ac1ea'::uuid, 16, DATE '2026-10-17', TIME '18:10', 16, DATE '2026-10-10', TIME '18:10')
, ('0ccd9f72-e0b8-484f-971d-ba4c3b190cc0'::uuid, '2nd', '7d4d6fdc-c4fc-4120-8953-189c08e00106'::uuid, '58829f1d-c80e-4feb-8918-6d76d1d84489'::uuid, 16, DATE '2026-10-18', TIME '13:40', 16, DATE '2026-10-11', TIME '13:40')
, ('09ca9cbc-5e41-4c72-a2a8-80cc47199334'::uuid, '2nd', 'c02b7728-ab92-4889-91ab-f0a1726ebe39'::uuid, '777e2624-6a7b-44c9-8948-488ab6e41f41'::uuid, 16, DATE '2026-10-18', TIME '14:50', 16, DATE '2026-10-11', TIME '14:50')
, ('e7f2c095-607a-43b0-a828-71fa3b3b1dc3'::uuid, '2nd', '2c57c925-c479-40e6-85be-362c78ab43af'::uuid, '7631e392-d4fd-4b7e-8fd1-f3b6513087ca'::uuid, 16, DATE '2026-10-18', TIME '16:00', 16, DATE '2026-10-11', TIME '16:00')
, ('32457f5d-04ee-499e-b7e0-360855d4a71d'::uuid, '2nd', '51b657ca-44dd-485a-9287-d48dfca482c7'::uuid, '074ed17f-e2e8-4b47-b70c-e9922f813407'::uuid, 16, DATE '2026-10-19', TIME '19:50', 16, DATE '2026-10-12', TIME '19:50')
, ('176ff9eb-28ce-424b-98bb-0202df0f8a3a'::uuid, '2nd', '7631e392-d4fd-4b7e-8fd1-f3b6513087ca'::uuid, 'b89fa62d-d77b-45af-a2c0-9df8672b7f63'::uuid, 17, DATE '2026-10-24', TIME '18:10', 17, DATE '2026-10-17', TIME '18:10')
, ('f08f3d57-2bb3-4221-8446-1c5c52d76d70'::uuid, '2nd', '7d4d6fdc-c4fc-4120-8953-189c08e00106'::uuid, '2c57c925-c479-40e6-85be-362c78ab43af'::uuid, 17, DATE '2026-10-25', TIME '13:40', 17, DATE '2026-10-18', TIME '13:40')
, ('af7d6e48-a297-482c-b39d-3ce19148a543'::uuid, '2nd', '58829f1d-c80e-4feb-8918-6d76d1d84489'::uuid, '2d8df861-c02d-43ad-b6b4-dd4c2288940e'::uuid, 17, DATE '2026-10-25', TIME '14:50', 17, DATE '2026-10-18', TIME '14:50')
, ('5c78faf6-1d2f-4ea0-b5a9-cc64c87caaa9'::uuid, '2nd', '51b657ca-44dd-485a-9287-d48dfca482c7'::uuid, 'c02b7728-ab92-4889-91ab-f0a1726ebe39'::uuid, 17, DATE '2026-10-25', TIME '16:00', 17, DATE '2026-10-18', TIME '16:00')
, ('bb82a449-d25a-40b0-b153-a00283124650'::uuid, '2nd', '777e2624-6a7b-44c9-8948-488ab6e41f41'::uuid, '4cdb4a72-db68-4774-bd0a-aac0338ac1ea'::uuid, 17, DATE '2026-10-26', TIME '19:50', 17, DATE '2026-10-19', TIME '19:50')
, ('eeffdfa0-c9a3-4439-8c0f-e9a14eaf52cb'::uuid, '2nd', '7d4d6fdc-c4fc-4120-8953-189c08e00106'::uuid, 'b89fa62d-d77b-45af-a2c0-9df8672b7f63'::uuid, 18, DATE '2026-11-07', TIME '18:10', 18, DATE '2026-10-24', TIME '18:10')
, ('e3f81b3f-76f5-42e5-9a4c-1a6688ff597f'::uuid, '2nd', '2c57c925-c479-40e6-85be-362c78ab43af'::uuid, '2d8df861-c02d-43ad-b6b4-dd4c2288940e'::uuid, 18, DATE '2026-11-08', TIME '13:40', 18, DATE '2026-10-25', TIME '13:40')
, ('ca621dea-1e9b-492d-8e32-ea577f7edefc'::uuid, '2nd', '58829f1d-c80e-4feb-8918-6d76d1d84489'::uuid, '074ed17f-e2e8-4b47-b70c-e9922f813407'::uuid, 18, DATE '2026-11-08', TIME '14:50', 18, DATE '2026-10-25', TIME '14:50')
, ('78421f69-d467-45ed-b96b-eaf23a198b9a'::uuid, '2nd', '4cdb4a72-db68-4774-bd0a-aac0338ac1ea'::uuid, 'c02b7728-ab92-4889-91ab-f0a1726ebe39'::uuid, 18, DATE '2026-11-08', TIME '16:00', 18, DATE '2026-10-25', TIME '16:00')
, ('323c5be2-9c4f-4b94-8361-f517408ecd8b'::uuid, '2nd', '777e2624-6a7b-44c9-8948-488ab6e41f41'::uuid, '7631e392-d4fd-4b7e-8fd1-f3b6513087ca'::uuid, 18, DATE '2026-11-09', TIME '19:50', 18, DATE '2026-10-26', TIME '19:50')
, ('316c939d-0793-4ece-9628-ea106e59c9b9'::uuid, '2nd', '2d8df861-c02d-43ad-b6b4-dd4c2288940e'::uuid, 'b89fa62d-d77b-45af-a2c0-9df8672b7f63'::uuid, 19, DATE '2026-11-14', TIME '18:10', 19, DATE '2026-11-07', TIME '18:10')
, ('6280d2d3-f619-4121-87c7-a5ef449ffbe2'::uuid, '2nd', '7d4d6fdc-c4fc-4120-8953-189c08e00106'::uuid, '777e2624-6a7b-44c9-8948-488ab6e41f41'::uuid, 19, DATE '2026-11-15', TIME '13:40', 19, DATE '2026-11-08', TIME '13:40')
, ('64de2af8-83a4-405b-ba85-9a18b3334821'::uuid, '2nd', 'c02b7728-ab92-4889-91ab-f0a1726ebe39'::uuid, '7631e392-d4fd-4b7e-8fd1-f3b6513087ca'::uuid, 19, DATE '2026-11-15', TIME '14:50', 19, DATE '2026-11-08', TIME '14:50')
, ('64b06c51-22f2-4073-bce2-3f1d1be266c3'::uuid, '2nd', '074ed17f-e2e8-4b47-b70c-e9922f813407'::uuid, '2c57c925-c479-40e6-85be-362c78ab43af'::uuid, 19, DATE '2026-11-15', TIME '16:00', 19, DATE '2026-11-08', TIME '16:00')
, ('09b2fbc1-73b3-4484-8641-9708567d55bc'::uuid, '2nd', '51b657ca-44dd-485a-9287-d48dfca482c7'::uuid, '4cdb4a72-db68-4774-bd0a-aac0338ac1ea'::uuid, 19, DATE '2026-11-16', TIME '19:50', 19, DATE '2026-11-09', TIME '19:50')
, ('6e6fc1b4-857a-4939-a4e2-709847c623ec'::uuid, '2nd', '7d4d6fdc-c4fc-4120-8953-189c08e00106'::uuid, 'c02b7728-ab92-4889-91ab-f0a1726ebe39'::uuid, 20, DATE '2026-11-21', TIME '18:10', 20, DATE '2026-11-14', TIME '18:10')
, ('c4b2a4c3-434e-417b-bc2f-d5c28b34aff2'::uuid, '2nd', '074ed17f-e2e8-4b47-b70c-e9922f813407'::uuid, 'b89fa62d-d77b-45af-a2c0-9df8672b7f63'::uuid, 20, DATE '2026-11-22', TIME '13:40', 20, DATE '2026-11-15', TIME '13:40')
, ('d351de35-1211-4eb4-b20a-b206a130661c'::uuid, '2nd', '4cdb4a72-db68-4774-bd0a-aac0338ac1ea'::uuid, '7631e392-d4fd-4b7e-8fd1-f3b6513087ca'::uuid, 20, DATE '2026-11-22', TIME '14:50', 20, DATE '2026-11-15', TIME '14:50')
, ('01fe46b1-13e2-4145-b935-c5d3db799d89'::uuid, '2nd', '51b657ca-44dd-485a-9287-d48dfca482c7'::uuid, '58829f1d-c80e-4feb-8918-6d76d1d84489'::uuid, 20, DATE '2026-11-22', TIME '16:00', 20, DATE '2026-11-15', TIME '16:00')
, ('d3480e75-cc7d-40ac-a616-a150e612a003'::uuid, '2nd', '2d8df861-c02d-43ad-b6b4-dd4c2288940e'::uuid, '777e2624-6a7b-44c9-8948-488ab6e41f41'::uuid, 20, DATE '2026-11-23', TIME '19:50', 20, DATE '2026-11-16', TIME '19:50')
, ('82c4a5ea-4599-49df-ba72-3bb7f4aa63c0'::uuid, '3rd', 'c251d749-9bde-4ccd-b25c-146d303e5561'::uuid, 'b02789a9-2cb8-4552-b3af-e26c08eeb3f5'::uuid, 14, DATE '2026-09-12', TIME '15:50', 14, DATE '2026-09-05', TIME '15:50')
, ('7f62aafb-0278-455b-a68a-26494278fa49'::uuid, '3rd', '869c7297-89f8-4282-9d48-080ed955bfa9'::uuid, '95658bd2-803b-45c1-946b-ddc9f993530a'::uuid, 14, DATE '2026-09-12', TIME '17:00', 14, DATE '2026-09-05', TIME '17:00')
, ('af4ac3dc-c112-4bd1-934f-340a5ff78498'::uuid, '3rd', 'baafce1c-23c0-4f8c-82a2-9a5c9d6bc13d'::uuid, '98efcdd7-c265-47e0-9a1d-d4fb8cb378e5'::uuid, 14, DATE '2026-09-13', TIME '09:00', 14, DATE '2026-09-06', TIME '09:00')
, ('c032ba48-58bd-4480-8aed-8005dfa7ca1e'::uuid, '3rd', 'f52073a5-25a4-4f02-a9b9-9e719f4abb00'::uuid, 'd5d7f7d2-97cf-484e-b8ef-0f356282f2c7'::uuid, 14, DATE '2026-09-13', TIME '10:10', 14, DATE '2026-09-06', TIME '10:10')
, ('90452878-5e8a-4a9b-9057-1b739b5d7958'::uuid, '3rd', '64f15e1a-494a-410c-a7c1-d4a4e5e182ef'::uuid, '9e90de4e-9a80-4587-8d2c-ba7d3a06c74d'::uuid, 14, DATE '2026-09-13', TIME '11:20', 14, DATE '2026-09-06', TIME '11:20')
, ('43d3e131-33d1-4c00-9995-8f7f368fa554'::uuid, '3rd', '4d190bab-7418-44f6-a385-116d41603410'::uuid, '2a266186-41f8-4092-8958-fb786df33a1c'::uuid, 14, DATE '2026-09-13', TIME '12:30', 14, DATE '2026-09-06', TIME '12:30')
, ('3ba1ef38-9ae0-4cec-b27b-33ed5d154964'::uuid, '3rd', 'c251d749-9bde-4ccd-b25c-146d303e5561'::uuid, '98efcdd7-c265-47e0-9a1d-d4fb8cb378e5'::uuid, 15, DATE '2026-09-19', TIME '15:50', 15, DATE '2026-09-12', TIME '15:50')
, ('6de0a060-e3c1-4008-a974-918eec3c8688'::uuid, '3rd', '869c7297-89f8-4282-9d48-080ed955bfa9'::uuid, 'd5d7f7d2-97cf-484e-b8ef-0f356282f2c7'::uuid, 15, DATE '2026-09-19', TIME '17:00', 15, DATE '2026-09-12', TIME '17:00')
, ('b1870ed8-133f-4e4d-b247-b532de85cbc5'::uuid, '3rd', '95658bd2-803b-45c1-946b-ddc9f993530a'::uuid, 'baafce1c-23c0-4f8c-82a2-9a5c9d6bc13d'::uuid, 15, DATE '2026-09-20', TIME '09:00', 15, DATE '2026-09-13', TIME '09:00')
, ('05df065e-08b4-495b-bb01-9bca9aad39e6'::uuid, '3rd', '9e90de4e-9a80-4587-8d2c-ba7d3a06c74d'::uuid, '2a266186-41f8-4092-8958-fb786df33a1c'::uuid, 15, DATE '2026-09-20', TIME '10:10', 15, DATE '2026-09-13', TIME '10:10')
, ('3c975bbf-4ac7-4b89-a7c6-4864ccebf69c'::uuid, '3rd', '64f15e1a-494a-410c-a7c1-d4a4e5e182ef'::uuid, 'f52073a5-25a4-4f02-a9b9-9e719f4abb00'::uuid, 15, DATE '2026-09-20', TIME '11:20', 15, DATE '2026-09-13', TIME '11:20')
, ('f220abb7-32d1-4474-abe1-addb90a5df6a'::uuid, '3rd', 'ca63f639-c878-4001-9d2b-c212419e79fd'::uuid, 'b02789a9-2cb8-4552-b3af-e26c08eeb3f5'::uuid, 15, DATE '2026-09-20', TIME '12:30', 15, DATE '2026-09-13', TIME '12:30')
, ('13e2af67-fa57-4174-9ff2-eb379ab600b1'::uuid, '3rd', 'c251d749-9bde-4ccd-b25c-146d303e5561'::uuid, '64f15e1a-494a-410c-a7c1-d4a4e5e182ef'::uuid, 16, DATE '2026-09-26', TIME '15:50', 16, DATE '2026-09-19', TIME '15:50')
, ('63c47448-bb87-4a57-b116-4baf01cb10c1'::uuid, '3rd', '869c7297-89f8-4282-9d48-080ed955bfa9'::uuid, 'baafce1c-23c0-4f8c-82a2-9a5c9d6bc13d'::uuid, 16, DATE '2026-09-26', TIME '17:00', 16, DATE '2026-09-19', TIME '17:00')
, ('85b782a4-0c4e-422b-916c-55fe2bd8b8a2'::uuid, '3rd', '98efcdd7-c265-47e0-9a1d-d4fb8cb378e5'::uuid, 'ca63f639-c878-4001-9d2b-c212419e79fd'::uuid, 16, DATE '2026-09-27', TIME '09:00', 16, DATE '2026-09-20', TIME '09:00')
, ('90494bab-ce1d-4a46-8b27-45c8c8325de2'::uuid, '3rd', 'f52073a5-25a4-4f02-a9b9-9e719f4abb00'::uuid, '4d190bab-7418-44f6-a385-116d41603410'::uuid, 16, DATE '2026-09-27', TIME '10:10', 16, DATE '2026-09-20', TIME '10:10')
, ('52292581-d24a-4a67-a061-73dcc7f0c705'::uuid, '3rd', 'd5d7f7d2-97cf-484e-b8ef-0f356282f2c7'::uuid, '2a266186-41f8-4092-8958-fb786df33a1c'::uuid, 16, DATE '2026-09-27', TIME '11:20', 16, DATE '2026-09-20', TIME '11:20')
, ('100a5366-eba0-4400-b5ae-68286b8ae031'::uuid, '3rd', '9e90de4e-9a80-4587-8d2c-ba7d3a06c74d'::uuid, 'b02789a9-2cb8-4552-b3af-e26c08eeb3f5'::uuid, 16, DATE '2026-09-27', TIME '12:30', 16, DATE '2026-09-20', TIME '12:30')
, ('6e3fca33-a5d6-4b2b-94ed-62a5bbe760ea'::uuid, '3rd', 'baafce1c-23c0-4f8c-82a2-9a5c9d6bc13d'::uuid, 'd5d7f7d2-97cf-484e-b8ef-0f356282f2c7'::uuid, 17, DATE '2026-10-03', TIME '15:50', 17, DATE '2026-09-26', TIME '15:50')
, ('e4f7c580-6295-4386-8a1e-dfa02e894ed4'::uuid, '3rd', '95658bd2-803b-45c1-946b-ddc9f993530a'::uuid, 'f52073a5-25a4-4f02-a9b9-9e719f4abb00'::uuid, 17, DATE '2026-10-03', TIME '17:00', 17, DATE '2026-09-26', TIME '17:00')
, ('2931befc-5024-474f-9839-49209dd180ad'::uuid, '3rd', '9e90de4e-9a80-4587-8d2c-ba7d3a06c74d'::uuid, '4d190bab-7418-44f6-a385-116d41603410'::uuid, 17, DATE '2026-10-04', TIME '09:00', 17, DATE '2026-09-27', TIME '09:00')
, ('31cd5991-b647-47e4-a281-38195cf2c5d1'::uuid, '3rd', 'b02789a9-2cb8-4552-b3af-e26c08eeb3f5'::uuid, '98efcdd7-c265-47e0-9a1d-d4fb8cb378e5'::uuid, 17, DATE '2026-10-04', TIME '10:10', 17, DATE '2026-09-27', TIME '10:10')
, ('7a705226-0fbd-4518-87e6-2d55e274684c'::uuid, '3rd', '2a266186-41f8-4092-8958-fb786df33a1c'::uuid, '64f15e1a-494a-410c-a7c1-d4a4e5e182ef'::uuid, 17, DATE '2026-10-04', TIME '11:20', 17, DATE '2026-09-27', TIME '11:20')
, ('149d47e4-23f4-4b78-81b9-75ae4e193d59'::uuid, '3rd', 'ca63f639-c878-4001-9d2b-c212419e79fd'::uuid, '869c7297-89f8-4282-9d48-080ed955bfa9'::uuid, 17, DATE '2026-10-04', TIME '12:30', 17, DATE '2026-09-27', TIME '12:30')
, ('9485e20c-5eab-4646-ba26-45f2cb224fb2'::uuid, '3rd', 'c251d749-9bde-4ccd-b25c-146d303e5561'::uuid, 'f52073a5-25a4-4f02-a9b9-9e719f4abb00'::uuid, 18, DATE '2026-10-10', TIME '15:50', 18, DATE '2026-10-03', TIME '15:50')
, ('9bd318c1-7c3c-4ae7-8db6-3dae25294148'::uuid, '3rd', 'd5d7f7d2-97cf-484e-b8ef-0f356282f2c7'::uuid, '64f15e1a-494a-410c-a7c1-d4a4e5e182ef'::uuid, 18, DATE '2026-10-10', TIME '17:00', 18, DATE '2026-10-03', TIME '17:00')
, ('6336e5a7-1437-472e-9b9c-2f7b0480e659'::uuid, '3rd', '9e90de4e-9a80-4587-8d2c-ba7d3a06c74d'::uuid, '869c7297-89f8-4282-9d48-080ed955bfa9'::uuid, 18, DATE '2026-10-11', TIME '09:00', 18, DATE '2026-10-04', TIME '09:00')
, ('72d241c6-893b-486d-ad8c-3f21e6aa38d3'::uuid, '3rd', 'b02789a9-2cb8-4552-b3af-e26c08eeb3f5'::uuid, 'baafce1c-23c0-4f8c-82a2-9a5c9d6bc13d'::uuid, 18, DATE '2026-10-11', TIME '10:10', 18, DATE '2026-10-04', TIME '10:10')
, ('95eea0fa-c348-4fb5-a1a6-e4e074636252'::uuid, '3rd', '2a266186-41f8-4092-8958-fb786df33a1c'::uuid, '98efcdd7-c265-47e0-9a1d-d4fb8cb378e5'::uuid, 18, DATE '2026-10-11', TIME '11:20', 18, DATE '2026-10-04', TIME '11:20')
, ('68f6c453-2c00-457a-bc48-122f4370bf06'::uuid, '3rd', '4d190bab-7418-44f6-a385-116d41603410'::uuid, '95658bd2-803b-45c1-946b-ddc9f993530a'::uuid, 18, DATE '2026-10-11', TIME '12:30', 18, DATE '2026-10-04', TIME '12:30')
, ('942ff42b-a4d5-4ceb-8afd-8ddcf15896c3'::uuid, '3rd', 'c251d749-9bde-4ccd-b25c-146d303e5561'::uuid, '95658bd2-803b-45c1-946b-ddc9f993530a'::uuid, 19, DATE '2026-10-17', TIME '15:50', 19, DATE '2026-10-10', TIME '15:50')
, ('7dc69464-7f9d-4767-a6fe-eba5e58d9946'::uuid, '3rd', '98efcdd7-c265-47e0-9a1d-d4fb8cb378e5'::uuid, '4d190bab-7418-44f6-a385-116d41603410'::uuid, 19, DATE '2026-10-17', TIME '17:00', 19, DATE '2026-10-10', TIME '17:00')
, ('973cd1e6-bcb9-4707-acb4-f342b5dad3ae'::uuid, '3rd', 'd5d7f7d2-97cf-484e-b8ef-0f356282f2c7'::uuid, '9e90de4e-9a80-4587-8d2c-ba7d3a06c74d'::uuid, 19, DATE '2026-10-18', TIME '09:00', 19, DATE '2026-10-11', TIME '09:00')
, ('6dd6e8e1-6b89-42d2-ac05-ffadd07418e0'::uuid, '3rd', '64f15e1a-494a-410c-a7c1-d4a4e5e182ef'::uuid, 'b02789a9-2cb8-4552-b3af-e26c08eeb3f5'::uuid, 19, DATE '2026-10-18', TIME '10:10', 19, DATE '2026-10-11', TIME '10:10')
, ('32500964-64d6-4576-b8de-8fc5384a036e'::uuid, '3rd', '2a266186-41f8-4092-8958-fb786df33a1c'::uuid, '869c7297-89f8-4282-9d48-080ed955bfa9'::uuid, 19, DATE '2026-10-18', TIME '11:20', 19, DATE '2026-10-11', TIME '11:20')
, ('0cc72740-220a-4a2c-a148-00e9f4babf55'::uuid, '3rd', 'ca63f639-c878-4001-9d2b-c212419e79fd'::uuid, 'f52073a5-25a4-4f02-a9b9-9e719f4abb00'::uuid, 19, DATE '2026-10-18', TIME '12:30', 19, DATE '2026-10-11', TIME '12:30')
, ('74330561-1c3b-440d-aa6c-0f2ff980310a'::uuid, '3rd', 'c251d749-9bde-4ccd-b25c-146d303e5561'::uuid, '4d190bab-7418-44f6-a385-116d41603410'::uuid, 20, DATE '2026-10-24', TIME '15:50', 20, DATE '2026-10-17', TIME '15:50')
, ('03e15cc9-4c02-4624-8338-bae7e08a4ebb'::uuid, '3rd', '869c7297-89f8-4282-9d48-080ed955bfa9'::uuid, 'b02789a9-2cb8-4552-b3af-e26c08eeb3f5'::uuid, 20, DATE '2026-10-24', TIME '17:00', 20, DATE '2026-10-17', TIME '17:00')
, ('e8484cb4-32de-4ecc-8b22-a601f9769474'::uuid, '3rd', '95658bd2-803b-45c1-946b-ddc9f993530a'::uuid, 'd5d7f7d2-97cf-484e-b8ef-0f356282f2c7'::uuid, 20, DATE '2026-10-25', TIME '09:00', 20, DATE '2026-10-18', TIME '09:00')
, ('6e9e3807-a53e-4d2b-9dad-a84f0d088da1'::uuid, '3rd', '9e90de4e-9a80-4587-8d2c-ba7d3a06c74d'::uuid, 'f52073a5-25a4-4f02-a9b9-9e719f4abb00'::uuid, 20, DATE '2026-10-25', TIME '10:10', 20, DATE '2026-10-18', TIME '10:10')
, ('53d45a07-1d7e-4297-83be-d9fb18d4d5c3'::uuid, '3rd', '64f15e1a-494a-410c-a7c1-d4a4e5e182ef'::uuid, '98efcdd7-c265-47e0-9a1d-d4fb8cb378e5'::uuid, 20, DATE '2026-10-25', TIME '11:20', 20, DATE '2026-10-18', TIME '11:20')
, ('c8681ed3-afd6-496d-b0f3-9b9f5fc55b4b'::uuid, '3rd', 'ca63f639-c878-4001-9d2b-c212419e79fd'::uuid, 'baafce1c-23c0-4f8c-82a2-9a5c9d6bc13d'::uuid, 20, DATE '2026-10-25', TIME '12:30', 20, DATE '2026-10-18', TIME '12:30')
, ('55a6a89c-56dc-4da2-b4d7-ddd8609ea54d'::uuid, '3rd', 'baafce1c-23c0-4f8c-82a2-9a5c9d6bc13d'::uuid, '2a266186-41f8-4092-8958-fb786df33a1c'::uuid, 21, DATE '2026-11-07', TIME '15:50', 21, DATE '2026-10-24', TIME '15:50')
, ('fac992e7-190d-4968-9aa0-62ef4102f734'::uuid, '3rd', '98efcdd7-c265-47e0-9a1d-d4fb8cb378e5'::uuid, '95658bd2-803b-45c1-946b-ddc9f993530a'::uuid, 21, DATE '2026-11-07', TIME '17:00', 21, DATE '2026-10-24', TIME '17:00')
, ('17123298-c713-401f-8fa6-fdca40dc5dfe'::uuid, '3rd', 'f52073a5-25a4-4f02-a9b9-9e719f4abb00'::uuid, '869c7297-89f8-4282-9d48-080ed955bfa9'::uuid, 21, DATE '2026-11-08', TIME '09:00', 21, DATE '2026-10-25', TIME '09:00')
, ('4ce831ba-9ae1-4fb2-86a1-94344e8cc2c5'::uuid, '3rd', 'd5d7f7d2-97cf-484e-b8ef-0f356282f2c7'::uuid, 'b02789a9-2cb8-4552-b3af-e26c08eeb3f5'::uuid, 21, DATE '2026-11-08', TIME '10:10', 21, DATE '2026-10-25', TIME '10:10')
, ('17692c13-92d0-448b-9647-45cd1d4f9927'::uuid, '3rd', '64f15e1a-494a-410c-a7c1-d4a4e5e182ef'::uuid, '4d190bab-7418-44f6-a385-116d41603410'::uuid, 21, DATE '2026-11-08', TIME '11:20', 21, DATE '2026-10-25', TIME '11:20')
, ('36c5634d-5304-43eb-ab0c-c1a17cb62455'::uuid, '3rd', 'ca63f639-c878-4001-9d2b-c212419e79fd'::uuid, 'c251d749-9bde-4ccd-b25c-146d303e5561'::uuid, 21, DATE '2026-11-08', TIME '12:30', 21, DATE '2026-10-25', TIME '12:30')
, ('68d334ee-294e-4214-bab0-26ee813c7ed8'::uuid, '3rd', '9e90de4e-9a80-4587-8d2c-ba7d3a06c74d'::uuid, '95658bd2-803b-45c1-946b-ddc9f993530a'::uuid, 22, DATE '2026-08-31', TIME '19:40', 22, DATE '2026-08-31', TIME '19:40')
, ('f01735af-2765-422c-a256-ec6c5e0e4bc1'::uuid, '3rd', '869c7297-89f8-4282-9d48-080ed955bfa9'::uuid, '64f15e1a-494a-410c-a7c1-d4a4e5e182ef'::uuid, 22, DATE '2026-11-14', TIME '15:50', 22, DATE '2026-11-07', TIME '15:50')
, ('3f098c5d-75ed-4cc8-a154-7222dae93594'::uuid, '3rd', 'baafce1c-23c0-4f8c-82a2-9a5c9d6bc13d'::uuid, 'f52073a5-25a4-4f02-a9b9-9e719f4abb00'::uuid, 22, DATE '2026-11-14', TIME '17:00', 22, DATE '2026-11-07', TIME '17:00')
, ('08c8fec5-2b3e-4a97-a8aa-8c3690abf6e5'::uuid, '3rd', 'd5d7f7d2-97cf-484e-b8ef-0f356282f2c7'::uuid, '98efcdd7-c265-47e0-9a1d-d4fb8cb378e5'::uuid, 22, DATE '2026-11-15', TIME '09:00', 22, DATE '2026-11-08', TIME '09:00')
, ('886b0d15-ab9f-4104-97e4-539bc3383aef'::uuid, '3rd', '2a266186-41f8-4092-8958-fb786df33a1c'::uuid, 'c251d749-9bde-4ccd-b25c-146d303e5561'::uuid, 22, DATE '2026-11-15', TIME '11:20', 22, DATE '2026-11-08', TIME '11:20')
, ('2485acbd-ab35-4d09-8c21-26f72f7391f0'::uuid, '3rd', '4d190bab-7418-44f6-a385-116d41603410'::uuid, 'ca63f639-c878-4001-9d2b-c212419e79fd'::uuid, 22, DATE '2026-11-15', TIME '12:30', 22, DATE '2026-11-08', TIME '12:30')
, ('1c62ed21-3f71-4e9f-8996-48c6abd91d4d'::uuid, '3rd', 'c251d749-9bde-4ccd-b25c-146d303e5561'::uuid, 'baafce1c-23c0-4f8c-82a2-9a5c9d6bc13d'::uuid, 23, DATE '2026-11-07', TIME '15:50', 23, DATE '2026-11-14', TIME '15:50')
, ('632f0c08-156c-4908-8427-a5f96bd84e9d'::uuid, '3rd', 'd5d7f7d2-97cf-484e-b8ef-0f356282f2c7'::uuid, 'f52073a5-25a4-4f02-a9b9-9e719f4abb00'::uuid, 23, DATE '2026-11-07', TIME '17:00', 23, DATE '2026-11-14', TIME '17:00')
, ('5a3453a7-7fca-4695-871c-275aad2672d0'::uuid, '3rd', '95658bd2-803b-45c1-946b-ddc9f993530a'::uuid, '64f15e1a-494a-410c-a7c1-d4a4e5e182ef'::uuid, 23, DATE '2026-11-08', TIME '09:00', 23, DATE '2026-11-15', TIME '09:00')
, ('70f0aaf7-3ede-4099-a3f1-d4d7c7504ce1'::uuid, '3rd', '9e90de4e-9a80-4587-8d2c-ba7d3a06c74d'::uuid, 'ca63f639-c878-4001-9d2b-c212419e79fd'::uuid, 23, DATE '2026-11-08', TIME '10:10', 23, DATE '2026-11-15', TIME '10:10')
, ('d6eb15f4-575e-46e4-b33b-05e4bb28e2a7'::uuid, '3rd', '2a266186-41f8-4092-8958-fb786df33a1c'::uuid, 'b02789a9-2cb8-4552-b3af-e26c08eeb3f5'::uuid, 23, DATE '2026-11-08', TIME '11:20', 23, DATE '2026-11-15', TIME '11:20')
, ('fd76acf6-7f3f-4da9-9325-8b9c43cbdcaa'::uuid, '3rd', '4d190bab-7418-44f6-a385-116d41603410'::uuid, '869c7297-89f8-4282-9d48-080ed955bfa9'::uuid, 23, DATE '2026-11-08', TIME '12:30', 23, DATE '2026-11-15', TIME '12:30')
, ('3db431a1-464a-4250-8a98-2c74ebc36c9b'::uuid, '3rd', 'f52073a5-25a4-4f02-a9b9-9e719f4abb00'::uuid, '98efcdd7-c265-47e0-9a1d-d4fb8cb378e5'::uuid, 24, DATE '2026-11-14', TIME '15:50', 24, DATE '2026-11-21', TIME '15:50')
, ('2a8a6050-a5b1-4e33-a1d3-ed5b333701c1'::uuid, '3rd', '95658bd2-803b-45c1-946b-ddc9f993530a'::uuid, 'b02789a9-2cb8-4552-b3af-e26c08eeb3f5'::uuid, 24, DATE '2026-11-14', TIME '17:00', 24, DATE '2026-11-21', TIME '17:00')
, ('27a5af64-6ce7-41be-94f8-7d08bef133c5'::uuid, '3rd', '9e90de4e-9a80-4587-8d2c-ba7d3a06c74d'::uuid, 'c251d749-9bde-4ccd-b25c-146d303e5561'::uuid, 24, DATE '2026-11-15', TIME '09:00', 24, DATE '2026-11-22', TIME '09:00')
, ('f97c56af-ea1b-4501-b395-f3b1ad3877a2'::uuid, '3rd', '64f15e1a-494a-410c-a7c1-d4a4e5e182ef'::uuid, 'baafce1c-23c0-4f8c-82a2-9a5c9d6bc13d'::uuid, 24, DATE '2026-11-15', TIME '10:10', 24, DATE '2026-11-22', TIME '10:10')
, ('a202b2c0-4ee7-4ca0-9a15-776e76645323'::uuid, '3rd', '4d190bab-7418-44f6-a385-116d41603410'::uuid, 'd5d7f7d2-97cf-484e-b8ef-0f356282f2c7'::uuid, 24, DATE '2026-11-15', TIME '11:20', 24, DATE '2026-11-22', TIME '11:20')
, ('187b10f2-8fd5-40fb-b5af-5f8539a365b1'::uuid, '3rd', 'ca63f639-c878-4001-9d2b-c212419e79fd'::uuid, '2a266186-41f8-4092-8958-fb786df33a1c'::uuid, 24, DATE '2026-11-15', TIME '12:30', 24, DATE '2026-11-22', TIME '12:30')
, ('a14fc906-aeb7-4c4a-b3d7-a577fcc1fe4e'::uuid, '3rd', 'c251d749-9bde-4ccd-b25c-146d303e5561'::uuid, '869c7297-89f8-4282-9d48-080ed955bfa9'::uuid, 25, DATE '2026-11-21', TIME '15:50', 25, DATE '2026-11-28', TIME '15:50')
, ('da68d099-7d42-4e42-9524-27414360c1f1'::uuid, '3rd', 'baafce1c-23c0-4f8c-82a2-9a5c9d6bc13d'::uuid, '4d190bab-7418-44f6-a385-116d41603410'::uuid, 25, DATE '2026-11-21', TIME '17:00', 25, DATE '2026-11-28', TIME '17:00')
, ('436c99f8-fe9b-4d0f-86fb-70ee4b3b0124'::uuid, '3rd', '95658bd2-803b-45c1-946b-ddc9f993530a'::uuid, '2a266186-41f8-4092-8958-fb786df33a1c'::uuid, 25, DATE '2026-11-22', TIME '09:00', 25, DATE '2026-11-29', TIME '09:00')
, ('41ba04d8-245f-4540-ac95-8c344c92f8f8'::uuid, '3rd', '9e90de4e-9a80-4587-8d2c-ba7d3a06c74d'::uuid, '98efcdd7-c265-47e0-9a1d-d4fb8cb378e5'::uuid, 25, DATE '2026-11-22', TIME '10:10', 25, DATE '2026-11-29', TIME '10:10')
, ('588eda97-776c-496e-afc1-103a9ef63dbb'::uuid, '3rd', 'b02789a9-2cb8-4552-b3af-e26c08eeb3f5'::uuid, 'f52073a5-25a4-4f02-a9b9-9e719f4abb00'::uuid, 25, DATE '2026-11-22', TIME '11:20', 25, DATE '2026-11-29', TIME '11:20')
, ('be187436-2384-47bc-a33a-1631dfc4f95d'::uuid, '3rd', '64f15e1a-494a-410c-a7c1-d4a4e5e182ef'::uuid, 'ca63f639-c878-4001-9d2b-c212419e79fd'::uuid, 25, DATE '2026-11-22', TIME '12:30', 25, DATE '2026-11-29', TIME '12:30')
, ('65171ff7-c226-4c56-820c-f7e6855d6d73'::uuid, '3rd', 'c251d749-9bde-4ccd-b25c-146d303e5561'::uuid, 'd5d7f7d2-97cf-484e-b8ef-0f356282f2c7'::uuid, 26, DATE '2026-11-28', TIME '15:50', 26, DATE '2026-12-05', TIME '15:50')
, ('64c22b0d-bdd6-4613-ab16-2aa41b5a7c1d'::uuid, '3rd', 'baafce1c-23c0-4f8c-82a2-9a5c9d6bc13d'::uuid, '9e90de4e-9a80-4587-8d2c-ba7d3a06c74d'::uuid, 26, DATE '2026-11-28', TIME '17:00', 26, DATE '2026-12-05', TIME '17:00')
, ('0ee17139-8710-4edb-9cbc-4f68fc6634e6'::uuid, '3rd', '98efcdd7-c265-47e0-9a1d-d4fb8cb378e5'::uuid, '869c7297-89f8-4282-9d48-080ed955bfa9'::uuid, 26, DATE '2026-11-29', TIME '09:00', 26, DATE '2026-12-06', TIME '09:00')
, ('3153bda1-553f-4a05-9ba9-ea721d8927e0'::uuid, '3rd', 'f52073a5-25a4-4f02-a9b9-9e719f4abb00'::uuid, '2a266186-41f8-4092-8958-fb786df33a1c'::uuid, 26, DATE '2026-11-29', TIME '10:10', 26, DATE '2026-12-06', TIME '10:10')
, ('d6d3ec8d-a0b3-46a5-a346-69e011ab8fd3'::uuid, '3rd', '95658bd2-803b-45c1-946b-ddc9f993530a'::uuid, 'ca63f639-c878-4001-9d2b-c212419e79fd'::uuid, 26, DATE '2026-11-29', TIME '11:20', 26, DATE '2026-12-06', TIME '11:20')
, ('4921ab98-62bc-4433-9262-478c86fb83fa'::uuid, '3rd', 'b02789a9-2cb8-4552-b3af-e26c08eeb3f5'::uuid, '4d190bab-7418-44f6-a385-116d41603410'::uuid, 26, DATE '2026-11-29', TIME '12:30', 26, DATE '2026-12-06', TIME '12:30');

CREATE TEMP TABLE mlpn_autumn_before AS
SELECT m.*
FROM public.matches m
JOIN mlpn_autumn_map plan ON plan.match_id = m.id;

CREATE TEMP TABLE mlpn_autumn_protected_before AS
SELECT m.id, to_jsonb(m) AS row_data
FROM public.matches m
JOIN public.seasons s ON s.id = m.season_id AND s.year = 2026
JOIN public.leagues l ON l.id = m.league_id
WHERE (
    l.code = '3rd'
    AND m.round = 13
  )
  OR m.id IN (
    '9e341955-d763-402c-82a0-04c6b3365101'::uuid,
    '316c2f14-5539-4212-b3a2-552aa0145750'::uuid,
    '45a23d66-5e40-49ba-b2df-c33513366ec6'::uuid,
    '97ddd278-c708-4aa0-a07d-16d1ec376074'::uuid
  );

CREATE TEMP TABLE mlpn_autumn_stats_before AS
SELECT
  l.code AS league_code,
  md5(COALESCE((
    SELECT string_agg(to_jsonb(st)::text, E'\n' ORDER BY st.id)
    FROM public.standings st
    WHERE st.season_id = s.id AND st.league_id = l.id
  ), '')) AS standings_hash,
  md5(COALESCE((
    SELECT string_agg(to_jsonb(ps)::text, E'\n' ORDER BY ps.id)
    FROM public.player_season_stats ps
    WHERE ps.season_id = s.id AND ps.league_id = l.id
  ), '')) AS player_stats_hash
FROM public.seasons s
CROSS JOIN public.leagues l
WHERE s.year = 2026
  AND l.code IN ('1st', '2nd', '3rd');

CREATE TEMP TABLE mlpn_autumn_refs_before (
  relation_name text PRIMARY KEY,
  row_count bigint NOT NULL
);

INSERT INTO mlpn_autumn_refs_before (relation_name, row_count)
SELECT 'active_match_assignments', count(*) FROM public.active_match_assignments WHERE match_id IN (SELECT match_id FROM mlpn_autumn_map)
UNION ALL SELECT 'gallery_albums', count(*) FROM public.gallery_albums WHERE match_id IN (SELECT match_id FROM mlpn_autumn_map)
UNION ALL SELECT 'match_events', count(*) FROM public.match_events WHERE match_id IN (SELECT match_id FROM mlpn_autumn_map)
UNION ALL SELECT 'match_lineups', count(*) FROM public.match_lineups WHERE match_id IN (SELECT match_id FROM mlpn_autumn_map)
UNION ALL SELECT 'match_result_edits', count(*) FROM public.match_result_edits WHERE match_id IN (SELECT match_id FROM mlpn_autumn_map)
UNION ALL SELECT 'news', count(*) FROM public.news WHERE related_match_id IN (SELECT match_id FROM mlpn_autumn_map)
UNION ALL SELECT 'typer_aggregates', count(*) FROM public.typer_aggregates WHERE match_id IN (SELECT match_id FROM mlpn_autumn_map)
UNION ALL SELECT 'typer_predictions', count(*) FROM public.typer_predictions WHERE match_id IN (SELECT match_id FROM mlpn_autumn_map)
UNION ALL SELECT 'typer_round_config_matches', count(*) FROM public.typer_round_config_matches WHERE match_id IN (SELECT match_id FROM mlpn_autumn_map)
UNION ALL SELECT 'typer_picks', count(*) FROM public.typer_picks WHERE match_id IN (SELECT match_id::text FROM mlpn_autumn_map);

CREATE TEMP TABLE mlpn_autumn_mode (
  mode text PRIMARY KEY CHECK (mode IN ('apply', 'already_applied'))
);

DO $checks_before$
DECLARE
  v_source_count integer;
  v_target_count integer;
  v_wbp uuid := 'bf258102-428d-4fa6-8730-23ce8740cbe6'::uuid;
  v_almar uuid := '3e478adc-016c-49c0-b252-f3353d68190e'::uuid;
  v_starszaki uuid := 'f078a02a-8bdc-4081-a600-6fdb35c8d712'::uuid;
  v_rebelianci uuid := '7581775c-7745-4fdf-b794-5772300b417b'::uuid;
BEGIN
  IF (SELECT count(*) FROM mlpn_autumn_map) <> 173
     OR (SELECT count(*) FROM mlpn_autumn_before) <> 173 THEN
    RAISE EXCEPTION 'Plan lub snapshot nie ma 173 meczow.';
  END IF;

  IF (SELECT count(*) FROM mlpn_autumn_protected_before) <> 10 THEN
    RAISE EXCEPTION 'Nie znaleziono 6 meczow III K13 i 4 chronionych zaleglosci.';
  END IF;

  IF EXISTS (
    SELECT 1
    FROM mlpn_autumn_map plan
    LEFT JOIN public.matches m ON m.id = plan.match_id
    LEFT JOIN public.seasons s ON s.id = m.season_id
    LEFT JOIN public.leagues l ON l.id = m.league_id
    WHERE m.id IS NULL
       OR s.year IS DISTINCT FROM 2026
       OR l.code IS DISTINCT FROM plan.league_code
       OR m.home_team_id IS DISTINCT FROM plan.expected_home_team_id
       OR m.away_team_id IS DISTINCT FROM plan.expected_away_team_id
       OR m.status IS DISTINCT FROM 'scheduled'
       OR m.home_goals IS NOT NULL
       OR m.away_goals IS NOT NULL
  ) THEN
    RAISE EXCEPTION 'Tozsamosc, status albo wynik co najmniej jednego meczu odbiega od audytu.';
  END IF;

  SELECT count(*) INTO v_source_count
  FROM mlpn_autumn_map plan
  JOIN public.matches m ON m.id = plan.match_id
  WHERE (m.round, m.match_date, m.match_time)
        IS NOT DISTINCT FROM
        (plan.source_round, plan.source_date, plan.source_time);

  SELECT count(*) INTO v_target_count
  FROM mlpn_autumn_map plan
  JOIN public.matches m ON m.id = plan.match_id
  WHERE (m.round, m.match_date, m.match_time)
        IS NOT DISTINCT FROM
        (plan.target_round, plan.target_date, plan.target_time);

  IF v_source_count = 173 THEN
    INSERT INTO mlpn_autumn_mode VALUES ('apply');
  ELSIF v_target_count = 173 THEN
    INSERT INTO mlpn_autumn_mode VALUES ('already_applied');
  ELSE
    RAISE EXCEPTION
      'Terminarz ma stan posredni lub zmienil sie od audytu (source %, target %).',
      v_source_count, v_target_count;
  END IF;

  IF (SELECT count(*) FROM mlpn_autumn_map WHERE league_code = '1st') <> 45
     OR (SELECT count(*) FROM mlpn_autumn_map WHERE league_code = '2nd') <> 50
     OR (SELECT count(*) FROM mlpn_autumn_map WHERE league_code = '3rd') <> 78
     OR (SELECT count(*) FROM mlpn_autumn_map
         WHERE (source_round, source_date, source_time)
               IS DISTINCT FROM
               (target_round, target_date, target_time)) <> 172 THEN
    RAISE EXCEPTION 'Liczby meczow lub zmian w planie sa nieprawidlowe.';
  END IF;

  IF (SELECT count(DISTINCT target_round) FROM mlpn_autumn_map WHERE league_code = '1st') <> 9
     OR EXISTS (
       SELECT 1 FROM mlpn_autumn_map
       WHERE league_code = '1st'
       GROUP BY target_round HAVING count(*) <> 5
     )
     OR (SELECT count(DISTINCT target_round) FROM mlpn_autumn_map WHERE league_code = '2nd') <> 10
     OR EXISTS (
       SELECT 1 FROM mlpn_autumn_map
       WHERE league_code = '2nd'
       GROUP BY target_round HAVING count(*) <> 5
     )
     OR (SELECT count(DISTINCT target_round) FROM mlpn_autumn_map WHERE league_code = '3rd') <> 13
     OR EXISTS (
       SELECT 1 FROM mlpn_autumn_map
       WHERE league_code = '3rd'
       GROUP BY target_round HAVING count(*) <> 6
     ) THEN
    RAISE EXCEPTION 'Nieprawidlowa liczba kolejek lub meczow w kolejce.';
  END IF;

  IF EXISTS (
    WITH appearances AS (
      SELECT league_code, target_round, expected_home_team_id AS team_id
      FROM mlpn_autumn_map
      UNION ALL
      SELECT league_code, target_round, expected_away_team_id
      FROM mlpn_autumn_map
    )
    SELECT 1
    FROM appearances
    GROUP BY league_code, target_round, team_id
    HAVING count(*) > 1
  ) THEN
    RAISE EXCEPTION 'Druzyna wystepuje wiecej niz raz w tej samej kolejce.';
  END IF;

  IF (SELECT min(target_date) FROM mlpn_autumn_map WHERE league_code = '1st')
       <> DATE '2026-09-05'
     OR (SELECT min(target_date) FROM mlpn_autumn_map WHERE league_code = '2nd')
       <> DATE '2026-09-05'
     OR (SELECT min(target_date) FROM mlpn_autumn_map
         WHERE league_code = '3rd' AND target_round = 14)
       <> DATE '2026-09-05' THEN
    RAISE EXCEPTION 'Co najmniej jedna liga nie zaczyna skorygowanego etapu 5 wrzesnia.';
  END IF;

  IF EXISTS (
    SELECT 1
    FROM mlpn_autumn_map
    WHERE target_date IN (DATE '2026-10-31', DATE '2026-11-01', DATE '2026-11-02')
  ) THEN
    RAISE EXCEPTION 'Plan zawiera mecz w weekend Wszystkich Swietych.';
  END IF;

  IF (
    SELECT count(*)
    FROM mlpn_autumn_map
    WHERE league_code = '1st'
      AND expected_home_team_id IN (v_almar, v_starszaki, v_rebelianci)
      AND expected_away_team_id IN (v_almar, v_starszaki, v_rebelianci)
  ) <> 3
  OR EXISTS (
    SELECT 1
    FROM mlpn_autumn_map
    WHERE league_code = '1st'
      AND expected_home_team_id IN (v_almar, v_starszaki, v_rebelianci)
      AND expected_away_team_id IN (v_almar, v_starszaki, v_rebelianci)
      AND target_date < DATE '2026-10-01'
  ) THEN
    RAISE EXCEPTION 'Trzy mecze wielkiej trojki nie trafily w calosci na pazdziernik lub pozniej.';
  END IF;

  IF EXISTS (
    SELECT 1
    FROM mlpn_autumn_map
    WHERE league_code = '1st'
      AND target_date BETWEEN DATE '2026-09-01' AND DATE '2026-09-30'
      AND (
        (expected_home_team_id = v_wbp
         AND expected_away_team_id IN (v_almar, v_starszaki, v_rebelianci))
        OR
        (expected_away_team_id = v_wbp
         AND expected_home_team_id IN (v_almar, v_starszaki, v_rebelianci))
      )
  ) THEN
    RAISE EXCEPTION '1 WBP ma we wrzesniu mecz z wielka trojka.';
  END IF;

  IF EXISTS (
    WITH final_matches AS (
      SELECT
        m.id,
        COALESCE(plan.target_date, m.match_date) AS final_date,
        COALESCE(plan.target_time, m.match_time) AS final_time,
        m.venue,
        m.home_team_id,
        m.away_team_id
      FROM public.matches m
      LEFT JOIN mlpn_autumn_map plan ON plan.match_id = m.id
      WHERE m.status NOT IN ('cancelled', 'unplayed')
        AND COALESCE(plan.target_date, m.match_date)
            BETWEEN DATE '2026-08-24' AND DATE '2026-12-06'
        AND COALESCE(plan.target_time, m.match_time) IS NOT NULL
    ),
    ordered_slots AS (
      SELECT
        *,
        lag(final_time) OVER (
          PARTITION BY final_date, COALESCE(venue, '')
          ORDER BY final_time, id
        ) AS previous_time
      FROM final_matches
    )
    SELECT 1
    FROM ordered_slots
    WHERE previous_time IS NOT NULL
      AND final_time - previous_time < INTERVAL '60 minutes'
  ) THEN
    RAISE EXCEPTION 'Plan ma kolizje obiektu: odstep pomiedzy meczami jest krotszy niz 60 minut.';
  END IF;

  IF EXISTS (
    WITH final_matches AS (
      SELECT
        m.id,
        COALESCE(plan.target_date, m.match_date) AS final_date,
        m.home_team_id,
        m.away_team_id
      FROM public.matches m
      LEFT JOIN mlpn_autumn_map plan ON plan.match_id = m.id
      WHERE m.status NOT IN ('cancelled', 'unplayed')
        AND COALESCE(plan.target_date, m.match_date)
            BETWEEN DATE '2026-08-24' AND DATE '2026-12-06'
    ),
    appearances AS (
      SELECT id, final_date, home_team_id AS team_id FROM final_matches
      UNION ALL
      SELECT id, final_date, away_team_id FROM final_matches
    )
    SELECT 1
    FROM appearances
    GROUP BY final_date, team_id
    HAVING count(*) > 1
  ) THEN
    RAISE EXCEPTION 'Druzyna ma dwa mecze tego samego dnia.';
  END IF;
END
$checks_before$;

ALTER TABLE public.matches DISABLE TRIGGER trg_recalculate_standings;

CREATE TEMP TABLE mlpn_autumn_updated_ids AS
WITH updated AS (
  UPDATE public.matches live
  SET
    round = plan.target_round,
    match_date = plan.target_date,
    match_time = plan.target_time
  FROM mlpn_autumn_map plan
  CROSS JOIN mlpn_autumn_mode execution
  WHERE execution.mode = 'apply'
    AND live.id = plan.match_id
    AND live.status = 'scheduled'
    AND live.home_goals IS NULL
    AND live.away_goals IS NULL
    AND (live.round, live.match_date, live.match_time)
        IS DISTINCT FROM
        (plan.target_round, plan.target_date, plan.target_time)
  RETURNING live.id
)
SELECT id FROM updated;

ALTER TABLE public.matches ENABLE TRIGGER trg_recalculate_standings;

CREATE TEMP TABLE mlpn_autumn_stats_after AS
SELECT
  l.code AS league_code,
  md5(COALESCE((
    SELECT string_agg(to_jsonb(st)::text, E'\n' ORDER BY st.id)
    FROM public.standings st
    WHERE st.season_id = s.id AND st.league_id = l.id
  ), '')) AS standings_hash,
  md5(COALESCE((
    SELECT string_agg(to_jsonb(ps)::text, E'\n' ORDER BY ps.id)
    FROM public.player_season_stats ps
    WHERE ps.season_id = s.id AND ps.league_id = l.id
  ), '')) AS player_stats_hash
FROM public.seasons s
CROSS JOIN public.leagues l
WHERE s.year = 2026
  AND l.code IN ('1st', '2nd', '3rd');

CREATE TEMP TABLE mlpn_autumn_refs_after (
  relation_name text PRIMARY KEY,
  row_count bigint NOT NULL
);

INSERT INTO mlpn_autumn_refs_after (relation_name, row_count)
SELECT 'active_match_assignments', count(*) FROM public.active_match_assignments WHERE match_id IN (SELECT match_id FROM mlpn_autumn_map)
UNION ALL SELECT 'gallery_albums', count(*) FROM public.gallery_albums WHERE match_id IN (SELECT match_id FROM mlpn_autumn_map)
UNION ALL SELECT 'match_events', count(*) FROM public.match_events WHERE match_id IN (SELECT match_id FROM mlpn_autumn_map)
UNION ALL SELECT 'match_lineups', count(*) FROM public.match_lineups WHERE match_id IN (SELECT match_id FROM mlpn_autumn_map)
UNION ALL SELECT 'match_result_edits', count(*) FROM public.match_result_edits WHERE match_id IN (SELECT match_id FROM mlpn_autumn_map)
UNION ALL SELECT 'news', count(*) FROM public.news WHERE related_match_id IN (SELECT match_id FROM mlpn_autumn_map)
UNION ALL SELECT 'typer_aggregates', count(*) FROM public.typer_aggregates WHERE match_id IN (SELECT match_id FROM mlpn_autumn_map)
UNION ALL SELECT 'typer_predictions', count(*) FROM public.typer_predictions WHERE match_id IN (SELECT match_id FROM mlpn_autumn_map)
UNION ALL SELECT 'typer_round_config_matches', count(*) FROM public.typer_round_config_matches WHERE match_id IN (SELECT match_id FROM mlpn_autumn_map)
UNION ALL SELECT 'typer_picks', count(*) FROM public.typer_picks WHERE match_id IN (SELECT match_id::text FROM mlpn_autumn_map);

DO $checks_after$
DECLARE
  v_expected_updates integer;
BEGIN
  SELECT CASE WHEN mode = 'apply' THEN 172 ELSE 0 END
  INTO v_expected_updates
  FROM mlpn_autumn_mode;

  IF (SELECT count(*) FROM mlpn_autumn_updated_ids) <> v_expected_updates THEN
    RAISE EXCEPTION 'Zaktualizowano % meczow zamiast %.',
      (SELECT count(*) FROM mlpn_autumn_updated_ids),
      v_expected_updates;
  END IF;

  IF EXISTS (
    SELECT 1
    FROM mlpn_autumn_map plan
    JOIN public.matches live ON live.id = plan.match_id
    WHERE (live.round, live.match_date, live.match_time)
          IS DISTINCT FROM
          (plan.target_round, plan.target_date, plan.target_time)
  ) THEN
    RAISE EXCEPTION 'Nie wszystkie mecze maja docelowa runde, date i godzine.';
  END IF;

  IF EXISTS (
    SELECT 1
    FROM mlpn_autumn_before before
    JOIN public.matches live ON live.id = before.id
    WHERE (
      to_jsonb(live)
        - 'round' - 'match_date' - 'match_time' - 'updated_at'
    ) IS DISTINCT FROM (
      to_jsonb(before)
        - 'round' - 'match_date' - 'match_time' - 'updated_at'
    )
  ) THEN
    RAISE EXCEPTION 'Poza runda/data/godzina zmienilo sie inne pole meczu.';
  END IF;

  IF EXISTS (
    SELECT 1
    FROM mlpn_autumn_protected_before before
    JOIN public.matches live ON live.id = before.id
    WHERE to_jsonb(live) IS DISTINCT FROM before.row_data
  ) THEN
    RAISE EXCEPTION 'K13 III ligi albo chroniona zaleglosc zostala zmieniona.';
  END IF;

  IF EXISTS (
    SELECT 1
    FROM mlpn_autumn_stats_before before
    JOIN mlpn_autumn_stats_after after USING (league_code)
    WHERE (before.standings_hash, before.player_stats_hash)
          IS DISTINCT FROM
          (after.standings_hash, after.player_stats_hash)
  ) THEN
    RAISE EXCEPTION 'Tabela ligowa albo statystyki zawodnikow ulegly zmianie.';
  END IF;

  IF EXISTS (
    (SELECT * FROM mlpn_autumn_refs_before
     EXCEPT SELECT * FROM mlpn_autumn_refs_after)
    UNION ALL
    (SELECT * FROM mlpn_autumn_refs_after
     EXCEPT SELECT * FROM mlpn_autumn_refs_before)
  ) THEN
    RAISE EXCEPTION 'Liczba rekordow powiazanych z meczami ulegla zmianie.';
  END IF;
END
$checks_after$;

COMMIT;

SELECT jsonb_build_object(
  'status', 'ok',
  'execution_mode', (SELECT mode FROM mlpn_autumn_mode),
  'target_rows', 173,
  'changed_rows_on_first_run', 172,
  'changed_rows_this_run', (
    SELECT CASE WHEN mode = 'apply' THEN 172 ELSE 0 END
    FROM mlpn_autumn_mode
  ),
  'first_league_start', '2026-09-05',
  'second_league_shifted_rounds', '11-20',
  'third_league_shifted_rounds', '14-26',
  'holiday_break', '2026-10-31..2026-11-02'
) AS applied_summary;
