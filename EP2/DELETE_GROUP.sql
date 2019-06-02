-- apaga perfil e sua ligação com us_pf
-- ligação com pf_se também cai por cascade
CREATE OR REPLACE FUNCTION delete_perfil 
(nome text)
RETURNS INTEGER AS $$
BEGIN
	DELETE FROM us_pf
	WHERE us_pf_perfil_nome = nome;	

	DELETE FROM perfil
	WHERE perfil_nome = nome;

	RETURN 1;
END;
$$ LANGUAGE plpgsql;

-- apaga serviço e sua ligação em pf_se
CREATE OR REPLACE FUNCTION delete_service
(nome text)
RETURNS INTEGER AS $$
BEGIN
	DELETE FROM pf_se
	WHERE pf_se_service_nome = nome;	

	DELETE FROM service 
	WHERE service_nome = nome;

	RETURN 1;
END;
$$ LANGUAGE plpgsql;

--apaga ligação entre usuario e perfil em us_pf
CREATE OR REPLACE FUNCTION delete_perfil_from_user
(login text, perfil text)
RETURNS INTEGER AS $$
BEGIN
	DELETE FROM us_pf 
	WHERE	us_pf_user_login = login AND
		us_pf_perfil_nome = perfil;

	RETURN 1;
END;
$$ LANGUAGE plpgsql;

--apaga ligação entre perfil e serviço em pf_se 
CREATE OR REPLACE FUNCTION delete_service_from_perfil
(perfil text, service text)
RETURNS INTEGER AS $$
BEGIN
	DELETE FROM pf_se
	WHERE	pf_se_perfil_nome  = perfil AND
		pf_se_service_nome = service;

	RETURN 1;
END;
$$ LANGUAGE plpgsql;

-- apaga usuario e as ligacoes em pe_us e us_pf
-- nusp em pessoa nao é alterado
CREATE OR REPLACE FUNCTION delete_user
(login text)
RETURNS INTEGER AS $$
BEGIN
	DELETE FROM us_pf 
	WHERE us_pf_user_login = login;

	DELETE FROM usuario
	WHERE user_login = login;

	RETURN 1;
END;
$$ LANGUAGE plpgsql;

/*Apaga uma pessoa. O usuário ligado a este código NUSP 
também vai para o vazio, com as conexões deste usuário
 a perfis. Suas ligações com aluno,professor e admin também
 explodem.*/
CREATE OR REPLACE FUNCTION delete_pessoa
(num_usp int)
RETURNS INTEGER AS $$
DECLARE
	user_login text := (SELECT pe_us_user_login 
			   FROM pe_us
			   WHERE pe_us_nusp = num_usp);
BEGIN
	DELETE FROM pessoa WHERE nusp = num_usp;

	PERFORM delete_user(user_login);

	RETURN 1;
END;
$$ LANGUAGE plpgsql;


/* Apaga a entrada em aluno ligado à uma pessoa. As relações em
cursa e planeja também se vão.*/
CREATE OR REPLACE FUNCTION delete_aluno
(num_usp int, curso text)
RETURNS INTEGER AS $$
BEGIN
	DELETE 	FROM aluno
		WHERE 	aluno_nusp = num_usp AND
			aluno_curso = curso;

	RETURN 1;
END;
$$ LANGUAGE plpgsql;

/* Apaga a entrada em professor ligado à uma pessoa. As relações
em ministra e oferecimento também se vão. */
CREATE OR REPLACE FUNCTION delete_professor
(num_usp int, unidade text)
RETURNS INTEGER AS $$
BEGIN
	DELETE 	FROM professor
		WHERE 	prof_nusp = num_usp AND
			prof_unidade = unidade;

	RETURN 1;
END;
$$ LANGUAGE plpgsql;

/* Apaga a entrada em adminstrador ligado à uma pessoa. As relações
em ministra e oferecimento também se vão. */
CREATE OR REPLACE FUNCTION delete_admin
(num_usp int, unidade text)
RETURNS INTEGER AS $$
BEGIN
	DELETE 	FROM admnistrador
		WHERE 	admin_nusp = num_usp AND
			admin_unidade = unidade;

	RETURN 1;
END;
$$ LANGUAGE plpgsql;

-- exclui um curriculo da relação admnistra
CREATE OR REPLACE FUNCTION delete_from_admnistra
(nusp int, sigla text) 
RETURNS INTEGER AS $$
BEGIN
	DELETE 	FROM admnistra
		WHERE 	admnistra_curriculo_sigla = sigla AND
			admnistra_nusp = nusp;

	RETURN 1;
END;
$$ LANGUAGE plpgsql;

/* Não apaga os alunos que estão neste currículo. É importante
tomar uma providência caso um currículo seja apagado! */
CREATE OR REPLACE FUNCTION delete_curriculo
(sigla text)
RETURNS INTEGER AS $$
BEGIN
	DELETE 	FROM admnistra
		WHERE 	admnistra_curriculo_sigla = sigla AND
			admnistra_nusp = nusp;

	DELETE 	FROM curriculo 
		WHERE curriculo_sigla = sigla;

	RETURN 1;
END;
$$ LANGUAGE plpgsql;

--Apaga uma relação entre trilha e currículo.
CREATE OR REPLACE FUNCTION delete_from_cur_tril
(sigla text, nome text) 
RETURNS INTEGER AS $$
BEGIN
	DELETE 	FROM cur_tril
		WHERE 	cur_tril_trilha_nome = nome AND
			cur_tril_curriculo_sigla = sigla;

	RETURN 1;
END;
$$ LANGUAGE plpgsql;

/* Apagar a trilha deixa as disciplinas que estão relacionadas
ao módulo atrelada à trilha solta. Se estas disciplinas não
estiverem num outro módulo, elas podem ficar soltas! */
CREATE OR REPLACE FUNCTION delete_trilha
(nome text)
RETURNS INTEGER AS $$
BEGIN
	DELETE 	FROM cur_tril
		WHERE cur_tril_trilha_nome = nome;

	DELETE 	FROM trilha 
		WHERE trilha_nome = nome;

	RETURN 1;
END;
$$ LANGUAGE plpgsql;

/* Apagar o modulo deixa as disciplinas que estão relacionadas
ao módulo soltas. Se estas disciplinas não estiverem num outro
módulo, elas podem ficar soltas! */
CREATE OR REPLACE FUNCTION delete_modulo
(nome text) 
RETURNS INTEGER AS $$
BEGIN
	DELETE 	FROM modulo 
		WHERE modulo_nome = nome;

	RETURN 1;
END;
$$ LANGUAGE plpgsql;

/* Apaga uma disciplina que um  professor se oferece para dar. */
CREATE OR REPLACE FUNCTION delete_from_ministra
(num_usp int, sigla text) 
RETURNS INTEGER AS $$
BEGIN
	DELETE 	FROM ministra
		WHERE 	ministra_disciplina_sigla = sigla AND
			ministra_prof_nusp = num_usp;
	
	RETURN 1;
END;
$$ LANGUAGE plpgsql;

-- Apaga um oferecimento de uma disciplina por um professor numa certa data
CREATE OR REPLACE FUNCTION delete_from_oferecimento
(num_usp int, sigla text, data date) 
RETURNS INTEGER AS $$
BEGIN
	DELETE 	FROM oferecimento
		WHERE 	ofer_disciplina_sigla = sigla AND
			ofer_prof_nusp = num_usp AND
			ofer_ministra_data = data;

	RETURN 1;
END;
$$ LANGUAGE plpgsql;

--Apaga uma relação entre disciplina e módulo.
CREATE OR REPLACE FUNCTION delete_from_dis_mod
(sigla text, modulo text) 
RETURNS INTEGER AS $$
BEGIN
	DELETE 	FROM dis_mod 
		WHERE	disc_mod_disciplina_sigla = sigla AND
			disc_mod_modulo_nome = modulo;

	RETURN 1;
END;
$$ LANGUAGE plpgsql;

/* Apaga uma disciplina. Apaga túplas e planeja, cursa e oferecimento!
Você tem certeza que quer fazer isso? considere apagar de ministra ou de
oferecimento e manter a disciplina antiga. */
CREATE OR REPLACE FUNCTION delete_disciplina
(sigla text) 
RETURNS INTEGER AS $$
BEGIN
	DELETE 	FROM dis_mod 
		WHERE disc_mod_disciplina_sigla = sigla;

	DELETE 	FROM disciplina
		WHERE disciplina_sigla = sigla;

	RETURN 1;
END;
$$ LANGUAGE plpgsql;
