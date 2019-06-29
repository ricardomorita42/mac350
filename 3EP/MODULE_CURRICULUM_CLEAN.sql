\c modulo_curriculo
SET ROLE dba;

DROP TABLE IF EXISTS curriculo CASCADE;
DROP TABLE IF EXISTS trilha CASCADE;
DROP TABLE IF EXISTS modulo CASCADE;
DROP TABLE IF EXISTS disciplina CASCADE;
DROP TABLE IF EXISTS cur_tril CASCADE;
DROP TABLE IF EXISTS dis_mod CASCADE;
DROP TABLE IF EXISTS trilha_extrareqs CASCADE;
DROP TABLE IF EXISTS disciplina_requisitos  CASCADE;
DROP TABLE IF EXISTS disciplina_biblio CASCADE;

DROP FUNCTION insert_curriculum;
DROP FUNCTION insert_trilha;
DROP FUNCTION insert_modulo;
DROP FUNCTION insert_disciplina;
DROP FUNCTION insert_cur_tril;
DROP FUNCTION insert_dis_mod;
DROP FUNCTION insert_trilha_extrareq;
DROP FUNCTION insert_disciplina_requisito;
DROP FUNCTION insert_disciplina_biblio;
