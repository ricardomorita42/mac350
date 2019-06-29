\c modulo_acesso
CREATE EXTENSION IF NOT EXISTS postgres_fdw;
CREATE EXTENSION IF NOT EXISTS pgcrypto;
CREATE EXTENSION IF NOT EXISTS citext;
SET ROLE dba;

-------- fdw config ------------
-- Config para intermod_ace_pes
CREATE SERVER ace_pes_server
	FOREIGN DATA WRAPPER postgres_fdw
	OPTIONS (host 'localhost', port '5432', dbname 'inter_mod_ace_pes');

CREATE USER MAPPING FOR dba
	SERVER ace_pes_server
	OPTIONS (user 'dba', password 'dba1234');

CREATE FOREIGN TABLE pe_us (
	pe_us_nusp		SERIAL,
	pe_us_user_login 	TEXT
)
	SERVER ace_pes_server
	OPTIONS (schema_name 'public',table_name 'pe_us');

-------- CREATE TYPE FUNCTIONS ------------
BEGIN;
/* 
Insere um usuário, ligando este a um perfil, criando uma entrada em us_pf.
Também envia solicitação para criar relação entre usuário e pessoa pelo
IM inter_ace_pes.
*/
CREATE OR REPLACE FUNCTION insert_user
(nusp int, curso_ou_unidade text, nickname text, email text, password text, role text)
RETURNS INTEGER AS $$
DECLARE
	role_ok INTEGER := (SELECT count(*) FROM perfil
			    WHERE perfil_nome = role);
BEGIN
	INSERT INTO usuario (user_login,user_email,user_password)
	VALUES (nickname,email,crypt(password,gen_salt('bf')))
       	ON CONFLICT DO NOTHING; --quando a pessoa já tem outro perfil
	
	--Adicionando perfil guest ao usuario
	PERFORM insert_user_into_role(nickname,'guest');

	--Adicionando perfil 'role' ao usuario caso este perfil exista
	IF role_ok = 1 THEN
		PERFORM insert_user_into_role(nickname, role);
	END IF;

	--raise notice 'Value %', idperf;
	RETURN 1;
END;
$$ LANGUAGE plpgsql;
REVOKE ALL ON FUNCTION insert_user(int,text,text,text,text,text)
	FROM PUBLIC;
GRANT EXECUTE ON FUNCTION insert_user(int,text,text,text,text,text)
	TO guest;
COMMIT;

BEGIN;
--Cria um perfil
CREATE OR REPLACE FUNCTION insert_role 
(INOUT perfil_nome text, INOUT perfil_descricao text DEFAULT NULL)
AS
$$
	INSERT INTO perfil
	VALUES ($1,$2)
	RETURNING perfil_nome, perfil_descricao
$$
LANGUAGE sql;
REVOKE ALL ON FUNCTION insert_role(text,text)
	FROM PUBLIC;
GRANT EXECUTE ON FUNCTION insert_role(text,text)
	TO dba;
COMMIT;

BEGIN;
/* Caso se queira ligar um servico existente a outro perfil pode-se usar
esta funcao tambem pois basta add outra entrada em pf_se.
Caso $1 seja nulo, um serviço será criado sem ser relacionado a um perfil.*/
CREATE OR REPLACE FUNCTION insert_service
(perfil_nome text, service_nome text, service_descricao text)
RETURNS INTEGER AS $$
BEGIN
	IF $1 IS NULL THEN
		INSERT into service VALUES ($2,$3);
	ELSE
		INSERT into service VALUES ($2,$3) ON CONFLICT DO NOTHING;
		INSERT into pf_se VALUES ($1,$2);
	END IF;

	RETURN 1;
END;
$$ LANGUAGE plpgsql;
REVOKE ALL ON FUNCTION insert_service(text,text,text)
	FROM PUBLIC;
GRANT EXECUTE ON FUNCTION insert_service(text,text,text)
	TO dba;
COMMIT;

BEGIN;
--Insere um usuario existente em um perfil existente
CREATE OR REPLACE FUNCTION insert_user_into_role 
(user_login text, perfil_nome text)
RETURNS INTEGER AS $$
BEGIN
	INSERT INTO us_pf
	VALUES ($1,$2,current_date) ON CONFLICT DO NOTHING;
	RETURN 1;
END;
$$ LANGUAGE plpgsql;
REVOKE ALL ON FUNCTION insert_user_into_role(text,text)
	FROM PUBLIC;
GRANT EXECUTE ON FUNCTION insert_user_into_role(text,text)
	TO dba;
COMMIT;

BEGIN;
/*Insere um perfil existente em um servico existente.
 É possível usar insert_service no lugar desta, mas
 fica mais intuitivo deste jeito.*/
CREATE OR REPLACE FUNCTION insert_role_into_service
(INOUT perfil_nome text, INOUT service_nome text)
AS
$$
	INSERT INTO pf_se
	VALUES ($1,$2) ON CONFLICT DO NOTHING
	RETURNING $1,$2 
$$ LANGUAGE sql;
REVOKE ALL ON FUNCTION insert_role_into_service(text,text)
	FROM PUBLIC;
GRANT EXECUTE ON FUNCTION insert_role_into_service(text,text)
	TO dba;
COMMIT;

-------- UPDATE TYPE FUNCTIONS ------------
BEGIN;
/* dado um user_login, atualiza o email.
Limitar o acesso à esta função para dba pq não é
seguro permitir que guests tentem adivinhar
e-mails cadastrados. */
CREATE OR REPLACE FUNCTION update_user_email
(INOUT login TEXT, INOUT new_email text)
AS $$
	UPDATE usuario
	SET user_email = new_email 
	WHERE user_login = login 
	RETURNING user_login,user_email
$$ LANGUAGE sql;
REVOKE ALL ON FUNCTION update_user_email(text,text)
	FROM PUBLIC;
GRANT EXECUTE ON FUNCTION update_user_email(text,text)
	TO dba;
COMMIT;

BEGIN;
--dado um user_login, atualiza o password.
CREATE OR REPLACE FUNCTION update_user_password
(IN login TEXT, IN new_password text, OUT success boolean)
AS $$
	UPDATE usuario
	SET user_password = crypt(new_password,gen_salt('bf'))
	WHERE user_login = login 
	RETURNING TRUE 
$$ LANGUAGE sql;
REVOKE ALL ON FUNCTION update_user_password(text,text)
	FROM PUBLIC;
GRANT EXECUTE ON FUNCTION update_user_password(text,text)
	TO guest;
COMMIT;

BEGIN;
-- Atualiza a descrição de um perfil. 
CREATE OR REPLACE FUNCTION update_perfil_descricao
(INOUT nome text, INOUT new_descricao text)
AS $$
	UPDATE perfil 
	SET perfil_descricao =  new_descricao
	WHERE perfil_nome = nome 
	RETURNING nome, new_descricao
$$ LANGUAGE sql;
REVOKE ALL ON FUNCTION update_perfil_descricao(text,text)
	FROM PUBLIC;
GRANT EXECUTE ON FUNCTION update_perfil_descricao(text,text)
	TO dba;
COMMIT;

BEGIN;
-- Atualiza a descrição de um serviço.
CREATE OR REPLACE FUNCTION update_service_descricao
(INOUT nome text, INOUT new_descricao text)
AS $$
	UPDATE service 
	SET service_descricao =  new_descricao
	WHERE service_nome = nome 
	RETURNING nome, new_descricao
$$ LANGUAGE sql;
REVOKE ALL ON FUNCTION update_service_descricao(text,text)
	FROM PUBLIC;
GRANT EXECUTE ON FUNCTION update_service_descricao(text,text)
	TO dba;
COMMIT;

BEGIN;
--Atualiza uma determinada relação us_pf.
--Esta funcao me parece bem perigosa.
CREATE OR REPLACE FUNCTION update_us_pf
(IN old_user_login text, IN old_perf_nome text,
 INOUT new_user_login text, INOUT new_perf_nome text)
AS $$
	UPDATE us_pf
	SET	us_pf_user_login = new_user_login,
		us_pf_perfil_nome = new_perf_nome
	WHERE	us_pf_user_login = old_user_login AND
		us_pf_perfil_nome = old_perf_nome
	RETURNING us_pf_user_login, us_pf_perfil_nome
$$ LANGUAGE sql;
REVOKE ALL ON FUNCTION update_us_pf(text,text,text,text)
	FROM PUBLIC;
GRANT EXECUTE ON FUNCTION update_us_pf(text,text,text,text)
	TO dba;
COMMIT;

BEGIN;
--Atualiza uma determinada relação pf_se.
--Esta funcao me parece bem perigosa.
CREATE OR REPLACE FUNCTION update_pf_se
(IN old_perf_nome text, IN old_serv_nome text,
 INOUT new_perf_nome text, INOUT new_serv_nome text)
AS $$
	UPDATE pf_se 
	SET	pf_se_perfil_nome =  new_perf_nome,
		pf_se_service_nome = new_serv_nome
	WHERE	pf_se_perfil_nome = old_perf_nome AND
		pf_se_service_nome = old_serv_nome
	RETURNING pf_se_perfil_nome, pf_se_service_nome
$$ LANGUAGE sql;
REVOKE ALL ON FUNCTION update_pf_se(text,text,text,text)
	FROM PUBLIC;
GRANT EXECUTE ON FUNCTION update_pf_se(text,text,text,text)
	TO dba;
COMMIT;


-------- DELETE TYPE FUNCTIONS ------------
BEGIN;
-- apaga usuario, a ligacao em us_pf
-- precisa solicitar ao db inter_ace_pes que apague 
-- relacoes pe_us com o login fornecido
CREATE OR REPLACE FUNCTION delete_user
(login text)
RETURNS INTEGER AS $$
DECLARE
	ace_pes_ok INTEGER := (	SELECT count(*) FROM pe_us 
				WHERE login = pe_us_user_login);
BEGIN
	IF ace_pes_ok = 1 THEN
		DELETE 	FROM pe_us
			WHERE login = pe_us_user_login;
	END IF;

	DELETE FROM us_pf 
	WHERE us_pf_user_login = login;

	DELETE FROM usuario
	WHERE user_login = login;

	RETURN 1;
END;
$$ LANGUAGE plpgsql;
REVOKE ALL ON FUNCTION delete_user(text)
	FROM PUBLIC;
GRANT EXECUTE ON FUNCTION delete_user(text)
	TO dba;
COMMIT;

BEGIN;
-- apaga perfil e sua ligação com us_pf
CREATE OR REPLACE FUNCTION delete_role 
(nome text)
RETURNS INTEGER AS $$
BEGIN
	DELETE FROM us_pf
	WHERE us_pf_perfil_nome = nome;	

	DELETE FROM perfil
	WHERE perfil_nome = nome;

	DELETE FROM pf_se
	WHERE pf_se_perfil_nome = nome;	

	RETURN 1;
END;
$$ LANGUAGE plpgsql;
REVOKE ALL ON FUNCTION delete_role(text)
	FROM PUBLIC;
GRANT EXECUTE ON FUNCTION delete_role(text)
	TO dba;
COMMIT;

BEGIN;
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
REVOKE ALL ON FUNCTION delete_service(text)
	FROM PUBLIC;
GRANT EXECUTE ON FUNCTION delete_service(text)
	TO dba;
COMMIT;

BEGIN;
--apaga ligação entre usuario e perfil em us_pf
CREATE OR REPLACE FUNCTION delete_rel_us_pf
(login text, perfil text)
RETURNS INTEGER AS $$
BEGIN
	DELETE FROM us_pf 
	WHERE	us_pf_user_login = login AND
		us_pf_perfil_nome = perfil;

	RETURN 1;
END;
$$ LANGUAGE plpgsql;
REVOKE ALL ON FUNCTION delete_rel_us_pf(text,text)
	FROM PUBLIC;
GRANT EXECUTE ON FUNCTION delete_rel_us_pf(text,text)
	TO dba;
COMMIT;

BEGIN;
--apaga ligação entre perfil e serviço em pf_se 
CREATE OR REPLACE FUNCTION delete_rel_pf_se
(perfil text, service text)
RETURNS INTEGER AS $$
BEGIN
	DELETE FROM pf_se
	WHERE	pf_se_perfil_nome  = perfil AND
		pf_se_service_nome = service;

	RETURN 1;
END;
$$ LANGUAGE plpgsql;
REVOKE ALL ON FUNCTION delete_rel_pf_se(text,text)
	FROM PUBLIC;
GRANT EXECUTE ON FUNCTION delete_rel_pf_se(text,text)
	TO dba;
COMMIT;

-------- RETRIEVAL TYPE FUNCTIONS ------------
BEGIN;
-- retorna todos os usuarios do db 
CREATE OR REPLACE FUNCTION return_all_users()
RETURNS TABLE(logins text, emails email) AS $$
BEGIN
	RETURN QUERY
	SELECT user_login, user_email FROM usuario;
END;
$$ LANGUAGE plpgsql;
REVOKE ALL ON FUNCTION return_all_users()
	FROM PUBLIC;
GRANT EXECUTE ON FUNCTION return_all_users()
	TO dba;
COMMIT;

BEGIN;
-- retorna todos os perfis do db 
CREATE OR REPLACE FUNCTION return_all_roles()
RETURNS TABLE(perfis text, descricoes text) AS $$
BEGIN
	RETURN QUERY
	SELECT perfil_nome, perfil_descricao FROM perfil;
END;
$$ LANGUAGE plpgsql;
REVOKE ALL ON FUNCTION return_all_roles()
	FROM PUBLIC;
GRANT EXECUTE ON FUNCTION return_all_roles()
	TO dba;
COMMIT;

BEGIN;
-- retorna todos os servicos do db 
CREATE OR REPLACE FUNCTION return_all_services()
RETURNS TABLE(servicos text, descricoes text) AS $$
BEGIN
	RETURN QUERY
	SELECT service_nome, service_descricao FROM service;
END;
$$ LANGUAGE plpgsql;
REVOKE ALL ON FUNCTION return_all_services()
	FROM PUBLIC;
GRANT EXECUTE ON FUNCTION return_all_services()
	TO dba;
COMMIT;

BEGIN;
-- retorna todos os servicos do db 
CREATE OR REPLACE FUNCTION return_all_us_pf()
RETURNS TABLE(usuarios text, perfis text) AS $$
BEGIN
	RETURN QUERY
	SELECT us_pf_user_login, us_pf_perfil_nome FROM us_pf;
END;
$$ LANGUAGE plpgsql;
REVOKE ALL ON FUNCTION return_all_us_pf()
	FROM PUBLIC;
GRANT EXECUTE ON FUNCTION return_all_us_pf()
	TO dba;
COMMIT;

BEGIN;
-- retorna todos os servicos do db 
CREATE OR REPLACE FUNCTION return_all_pf_se()
RETURNS TABLE(perfis text, servicos text) AS $$
BEGIN
	RETURN QUERY
	SELECT pf_se_service_nome, pf_se_service_nome FROM pf_se;
END;
$$ LANGUAGE plpgsql;
REVOKE ALL ON FUNCTION return_all_pf_se()
	FROM PUBLIC;
GRANT EXECUTE ON FUNCTION return_all_pf_se()
	TO dba;
COMMIT;

BEGIN;
-- dado um login, retorna um usuario 
-- nao inclui password por seguranca
CREATE OR REPLACE FUNCTION return_user
(INOUT login text, OUT email text)
AS $$
	SELECT user_login,user_email FROM usuario
	WHERE user_login = login
$$
LANGUAGE sql;
REVOKE ALL ON FUNCTION return_user(text)
	FROM PUBLIC;
GRANT EXECUTE ON FUNCTION return_user(text)
	TO guest;
COMMIT;
