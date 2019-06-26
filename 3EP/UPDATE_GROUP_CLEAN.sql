DROP FUNCTION update_nome
(IN num_usp int,  new_pnome text,  new_snome text);

DROP FUNCTION update_datanasc
(IN num_usp int,  new_datanasc date);

DROP FUNCTION update_sexo
(IN num_usp int,  new_sexo varchar(1));

DROP FUNCTION update_email
( login TEXT,  new_email text);

DROP FUNCTION update_password
(IN login TEXT, IN new_password text, OUT success boolean);

DROP FUNCTION update_perfil_descricao
( nome text,  new_descricao text);

DROP FUNCTION update_service
( nome text,  new_descricao text);

DROP FUNCTION update_prof_unidade
( nusp int,  new_unidade text);

DROP FUNCTION update_admin_unidade
( nusp int,  new_unidade text);

DROP FUNCTION update_aluno_curso
( nusp int,  new_curso text);

DROP FUNCTION update_ofer_data
( nusp int,  disc_sigla text,  new_data date);

DROP FUNCTION update_cursa_nota
( al_nusp int,  prof_nusp int,  disc_sigla text,  new_nota NUMERIC);

DROP FUNCTION update_cursa_presenca
( al_nusp int,  prof_nusp int,  disc_sigla text,  new_presenca NUMERIC);

DROP FUNCTION update_planeja_disciplina
( nusp int,  new_sigla text);

DROP FUNCTION update_disciplina_unidade
( sigla text,  new_unidade text);

DROP FUNCTION update_disciplina_nome
( sigla text,  new_nome text);

DROP FUNCTION update_disciplina_cred_aula
( sigla text,  new_cred_aula int);

DROP FUNCTION update_disciplina_cred_trabalho
( sigla text,  new_cred_trabalho int);

DROP FUNCTION update_administra_data_inicio
( nusp int,  curriculo_sigla text,  new_data date);

DROP FUNCTION update_curriculo_unidade
( sigla text,  new_unidade text);

DROP FUNCTION update_curriculo_nome
( sigla text,  new_nome text);

DROP FUNCTION update_curriculo_cred_obrig
( sigla text,  new_cred_obrig int);

DROP FUNCTION update_curriculo_cred_opt_elet
( sigla text,  new_cred_opt_elet int);

DROP FUNCTION update_curriculo_cred_opt_liv
( sigla text,  new_cred_opt_liv int);

DROP FUNCTION update_trilha_descricao
( nome text,  new_descricao text);

DROP FUNCTION update_modulo_descricao
( nome text,  new_descricao text);

DROP FUNCTION update_disc_biblio_descricao
( disc_sigla text,  new_descricao text);
