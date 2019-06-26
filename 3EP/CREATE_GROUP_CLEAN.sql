DROP FUNCTION insert_person 
( nusp int,  cpf text,  pnome text, snome text,  datanasc date,  sexo VARCHAR(1));

DROP FUNCTION insert_role 
( perfil_nome text,  perfil_descricao text);

DROP FUNCTION insert_user_into_role 
( user_login text,  perfil_nome text);

DROP FUNCTION guest_insert_into_role_student
(nusp int, user_login text, curso text);

DROP FUNCTION guest_insert_into_role_teacher
(nusp int, user_login text, unidade text);

DROP FUNCTION guest_insert_into_role_admin
(nusp int, user_login text, unidade text);

DROP FUNCTION insert_user
(nusp int, curso_ou_unidade text, nickname text, email text, password text, role text);

DROP FUNCTION insert_service
(perfil_nome text, service_nome text, service_descricao text);

DROP FUNCTION insert_into_administra
( admin_nusp int,  administra_curriculo_sigla text,
  adminstra_data_inicio date);

DROP FUNCTION insert_curriculum
(curriculo_sigla text, curriculo_unidade text,
 curriculo_nome text, curriculo_cred_obrig int,
 curriculo_cred_opt_elet int, curriculo_opt_liv int,
 admin_nusp int);

DROP FUNCTION insert_trilha
(trilha_nome text, trilha_descricao text, curriculo_sigla text );

DROP FUNCTION insert_modulo
(modulo_nome text, modulo_descricao text, trilha_nome text);

DROP FUNCTION insert_disciplina
(disciplina_sigla text, disciplina_unidade text, disciplina_nome text,
disciplina_cred_aula int, disciplina_cred_trabalho int, modulo_nome text);

DROP FUNCTION insert_ministra
(ofer_prof_nusp int, ofer_disciplina_sigla text);

DROP FUNCTION insert_oferecimento
(ofer_prof_nusp int, ofer_disciplina_sigla text, ofer_ministra_data date);

DROP FUNCTION insert_planeja (planeja_aluno_nusp int, planeja_disciplina_sigla text);

DROP FUNCTION insert_cursa
(cursa_aluno_nusp int, cursa_prof_nusp int, cursa_disciplina_sigla text,
cursa_nota numeric, cursa_presenca numeric);

DROP FUNCTION insert_trilha_extrareqs
( trilha_nome text,  requisito text);

DROP FUNCTION insert_disciplina_requisitos
( disciplina_sigla text,  disciplina_requisito text);

DROP FUNCTION insert_disciplina_biblio
( disciplina_sigla text,  requisito text);
