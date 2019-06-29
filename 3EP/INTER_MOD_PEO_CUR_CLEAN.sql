\c inter_mod_pes_cur
SET ROLE dba;

DROP TABLE IF EXISTS oferecimento CASCADE;
DROP TABLE IF EXISTS planeja CASCADE;

DROP FUNCTION IF EXISTS insert_into_administra;
DROP FUNCTION IF EXISTS insert_into_ministra;
DROP FUNCTION IF EXISTS insert_into_planeja;
