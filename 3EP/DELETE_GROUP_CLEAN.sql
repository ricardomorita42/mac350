DROP FUNCTION delete_perfil 
(nome text);

DROP FUNCTION delete_service
(nome text);

DROP FUNCTION delete_perfil_from_user
(login text, perfil text);

DROP FUNCTION delete_service_from_perfil
(perfil text, service text);

DROP FUNCTION delete_user
(login text);

DROP FUNCTION delete_pessoa
(num_usp int);

DROP FUNCTION delete_aluno
(num_usp int, curso text);

DROP FUNCTION delete_professor
(num_usp int, unidade text);

DROP FUNCTION delete_admin
(num_usp int, unidade text);

DROP FUNCTION delete_from_administra
(nusp int, sigla text); 

DROP FUNCTION delete_curriculo
(sigla text);

DROP FUNCTION delete_from_cur_tril
(sigla text, nome text);

DROP FUNCTION delete_trilha
(nome text);

DROP FUNCTION delete_modulo
(nome text);

DROP FUNCTION delete_from_ministra
(num_usp int, sigla text);

DROP FUNCTION delete_from_oferecimento
(num_usp int, sigla text, data date);

DROP FUNCTION delete_from_dis_mod
(sigla text, modulo text);

DROP FUNCTION delete_disciplina
(sigla text);
