\c modulo_pessoa
SET ROLE dba;

DROP TABLE IF EXISTS pessoa CASCADE;
DROP TABLE IF EXISTS aluno CASCADE;
DROP TABLE IF EXISTS professor CASCADE;
DROP TABLE IF EXISTS administrador CASCADE;
DROP TABLE IF EXISTS cursa CASCADE;
DROP TABLE IF EXISTS oferecimento CASCADE;

DROP FUNCTION insert_person;
DROP FUNCTION insert_into_role_student;
DROP FUNCTION insert_into_role_teacher;
DROP FUNCTION insert_into_role_admin;
DROP FUNCTION insert_cursa;
DROP FUNCTION insert_oferecimento;

DROP FUNCTION update_pessoa_nome;
DROP FUNCTION update_pessoa_datanasc;
DROP FUNCTION update_pessoa_sexo;
DROP FUNCTION update_aluno_curso;
DROP FUNCTION update_prof_unidade;
DROP FUNCTION update_ofer_data;
DROP FUNCTION update_cursa_nota;
DROP FUNCTION update_cursa_presenca;
DROP FUNCTION update_planeja_disciplina;
