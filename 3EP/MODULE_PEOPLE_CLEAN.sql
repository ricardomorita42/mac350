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

DROP FUNCTION update_pessoa_nusp;
DROP FUNCTION update_pessoa_nome;
DROP FUNCTION update_pessoa_datanasc;
DROP FUNCTION update_pessoa_sexo;
DROP FUNCTION update_aluno_curso;
DROP FUNCTION update_prof_unidade;
DROP FUNCTION update_admin_unidade;
DROP FUNCTION update_cursa_nota;
DROP FUNCTION update_cursa_presenca;
DROP FUNCTION update_oferecimento;
DROP FUNCTION update_oferecimento_data;

DROP FUNCTION delete_pessoa;
DROP FUNCTION delete_aluno;
DROP FUNCTION delete_professor;
DROP FUNCTION delete_administrador;
DROP FUNCTION delete_oferecimento;
DROP FUNCTION delete_cursa;

DROP FUNCTION return_all_pessoas;
DROP FUNCTION return_pessoa_with_nusp;

DROP FUNCTION return_all_alunos;
DROP FUNCTION return_all_professores;
DROP FUNCTION return_all_administradores;
DROP FUNCTION return_aluno;
DROP FUNCTION return_prof;
DROP FUNCTION return_admin;

DROP FUNCTION return_all_cursas;
DROP FUNCTION return_all_cursas_of_aluno;
DROP FUNCTION return_all_cursas_of_prof;
DROP FUNCTION return_all_cursas_of_disciplina;
DROP FUNCTION return_all_oferecimentos;
DROP FUNCTION return_all_oferecimentos_of_prof;
DROP FUNCTION return_all_oferecimentos_of_disciplina;
