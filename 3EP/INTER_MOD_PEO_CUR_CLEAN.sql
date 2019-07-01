\c inter_mod_pes_cur
SET ROLE dba;

DROP TABLE IF EXISTS administra CASCADE;
DROP TABLE IF EXISTS ministra CASCADE;
DROP TABLE IF EXISTS planeja CASCADE;

DROP FUNCTION IF EXISTS insert_administra;
DROP FUNCTION IF EXISTS insert_ministra;
DROP FUNCTION IF EXISTS insert_planeja;

DROP FUNCTION IF EXISTS update_administra;
DROP FUNCTION IF EXISTS update_administra_data_inicio;
DROP FUNCTION IF EXISTS update_ministra;
DROP FUNCTION IF EXISTS update_planeja;

DROP FUNCTION IF EXISTS delete_administra;
DROP FUNCTION IF EXISTS delete_ministra;
DROP FUNCTION IF EXISTS delete_planeja;

DROP FUNCTION IF EXISTS return_all_administra;
DROP FUNCTION IF EXISTS return_all_ministra;
DROP FUNCTION IF EXISTS return_all_planeja;
DROP FUNCTION IF EXISTS return_administra_of_admin;
DROP FUNCTION IF EXISTS return_ministra_of_prof;
DROP FUNCTION IF EXISTS return_planeja_of_aluno;
