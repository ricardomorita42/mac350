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
