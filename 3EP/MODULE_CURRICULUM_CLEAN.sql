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

DROP FUNCTION insert_curriculo;
DROP FUNCTION insert_trilha;
DROP FUNCTION insert_modulo;
DROP FUNCTION insert_disciplina;
DROP FUNCTION insert_cur_tril;
DROP FUNCTION insert_dis_mod;
DROP FUNCTION insert_tril_mod;
DROP FUNCTION insert_trilha_extrareq;
DROP FUNCTION insert_disciplina_requisito;
DROP FUNCTION insert_disciplina_biblio;

DROP FUNCTION update_disciplina_unidade;
DROP FUNCTION update_disciplina_nome;
DROP FUNCTION update_disciplina_cred_aula;
DROP FUNCTION update_disciplina_cred_trabalho;
DROP FUNCTION update_curriculo_unidade;
DROP FUNCTION update_curriculo_nome;
DROP FUNCTION update_curriculo_cred_obrig;
DROP FUNCTION update_curriculo_cred_opt_elet;
DROP FUNCTION update_curriculo_cred_opt_liv;
DROP FUNCTION update_trilha_descricao;
DROP FUNCTION update_modulo_descricao;
DROP FUNCTION update_tril_mod;
DROP FUNCTION update_cur_tril;
DROP FUNCTION update_dis_mod;
DROP FUNCTION update_disc_biblio_descricao;

DROP FUNCTION delete_curriculo;
DROP FUNCTION delete_disciplina;
DROP FUNCTION delete_trilha;
DROP FUNCTION delete_modulo;
DROP FUNCTION delete_dis_mod;
DROP FUNCTION delete_cur_tril;
DROP FUNCTION delete_disc_biblio;
DROP FUNCTION delete_trilha_requisito;
DROP FUNCTION delete_trilha_requisito_by_id;
DROP FUNCTION delete_disciplina_requisito;

DROP FUNCTION return_all_curriculos;
DROP FUNCTION return_all_trilhas;
DROP FUNCTION return_all_modulos;
DROP FUNCTION return_all_disciplinas;
DROP FUNCTION return_all_dis_mod;
DROP FUNCTION return_all_cur_tril;
DROP FUNCTION return_all_tril_mod;
DROP FUNCTION return_disciplina_biblio;
DROP FUNCTION return_disciplina_requisitos;
DROP FUNCTION return_trilha_requisitos;
