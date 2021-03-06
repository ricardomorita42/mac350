\c modulo_curriculo
SET ROLE dba;

CREATE EXTENSION postgres_fdw;

-------- fdw config ------------
-- Config para inter_mod_pes_cur
CREATE SERVER pes_cur_server
	FOREIGN DATA WRAPPER postgres_fdw
	OPTIONS (host 'localhost', port '5432', dbname 'inter_mod_pes_cur');

CREATE USER MAPPING FOR dba
	SERVER pes_cur_server
	OPTIONS (user 'dba', password 'dba1234');

CREATE USER MAPPING FOR admin
	SERVER pes_cur_server
	OPTIONS (user 'admin', password 'admin');

CREATE FOREIGN TABLE administra(
	administra_nusp			INTEGER,
	administra_curriculo_sigla	TEXT,
	administra_inicio		date
)
	SERVER pes_cur_server
	OPTIONS (schema_name 'public',table_name 'administra');

CREATE FOREIGN TABLE planeja (
	planeja_aluno_nusp		INTEGER,
	planeja_disciplina_sigla	TEXT
)
	SERVER pes_cur_server
	OPTIONS (schema_name 'public',table_name 'planeja');

CREATE FOREIGN TABLE ministra(
	ministra_prof_nusp			INTEGER,
	ministra_disciplina_sigla		TEXT
)
	SERVER pes_cur_server
	OPTIONS (schema_name 'public',table_name 'ministra');

-- Config para modulo_pessoa
CREATE SERVER pessoa_server
	FOREIGN DATA WRAPPER postgres_fdw
	OPTIONS (host 'localhost', port '5432', dbname 'modulo_pessoa');

CREATE USER MAPPING FOR dba
	SERVER pessoa_server 
	OPTIONS (user 'dba', password 'dba1234');

CREATE USER MAPPING FOR admin
	SERVER pessoa_server 
	OPTIONS (user 'admin', password 'admin');

CREATE FOREIGN TABLE cursa (
	cursa_aluno_nusp		INTEGER,
	cursa_prof_nusp			INTEGER,
	cursa_disciplina_sigla		TEXT
)
	SERVER pessoa_server
	OPTIONS (schema_name 'public',table_name 'cursa');

-------- CREATE TYPE FUNCTIONS ------------
BEGIN;
--Insere um curriculo novo.
CREATE OR REPLACE FUNCTION insert_curriculo
(curriculo_sigla text, curriculo_unidade text, curriculo_nome text, curriculo_cred_obrig int,
 curriculo_cred_opt_elet int, curriculo_opt_liv int)
RETURNS INTEGER AS $$
BEGIN
	INSERT into curriculo VALUES ($1,$2,$3,$4,$5,$6) ON CONFLICT DO NOTHING;

	IF FOUND THEN
		RETURN 1;
	ELSE
		RETURN -1;
	END IF;
END;
$$ LANGUAGE plpgsql;
REVOKE ALL ON FUNCTION insert_curriculo(text,text,text,int,int,int)
	FROM PUBLIC;
GRANT EXECUTE ON FUNCTION insert_curriculo(text,text,text,int,int,int)
	TO dba,admin;
COMMIT;

BEGIN;
--Insere uma trilha.
CREATE OR REPLACE FUNCTION insert_trilha
(trilha_nome text, trilha_descricao text)
RETURNS INTEGER AS $$
BEGIN
	INSERT INTO trilha VALUES ($1,$2) ON CONFLICT DO NOTHING;

	IF FOUND THEN
		RETURN 1;
	ELSE
		RETURN -1;
	END IF;
END;
$$ LANGUAGE plpgsql;
REVOKE ALL ON FUNCTION insert_trilha(text,text)
	FROM PUBLIC;
GRANT EXECUTE ON FUNCTION insert_trilha(text,text)
	TO dba,admin;
COMMIT;

BEGIN;
--Insere um modulo.
CREATE OR REPLACE FUNCTION insert_modulo
(modulo_nome text, modulo_descricao text,
 modulo_trilha_nome text DEFAULT NULL)
RETURNS INTEGER AS $$
BEGIN
	INSERT INTO modulo VALUES ($1,$2,$3) ON CONFLICT DO NOTHING;

	IF FOUND THEN
		RETURN 1;
	ELSE
		RETURN -1;
	END IF;
END;
$$ LANGUAGE plpgsql;
REVOKE ALL ON FUNCTION insert_modulo(text,text,text)
	FROM PUBLIC;
GRANT EXECUTE ON FUNCTION insert_modulo(text,text,text)
	TO dba,admin;
COMMIT;

BEGIN;
--Insere uma disciplina.
CREATE OR REPLACE FUNCTION insert_disciplina
(disciplina_sigla text, disciplina_unidade text, disciplina_nome text,
disciplina_cred_aula int, disciplina_cred_trabalho int)
RETURNS INTEGER AS $$
BEGIN
	INSERT INTO disciplina VALUES ($1,$2,$3,$4,$5) ON CONFLICT DO NOTHING;

	IF FOUND THEN
		RETURN 1;
	ELSE
		RETURN -1;
	END IF;
END;
$$ LANGUAGE plpgsql;
REVOKE ALL ON FUNCTION insert_disciplina(text,text,text,int,int)
	FROM PUBLIC;
GRANT EXECUTE ON FUNCTION insert_disciplina(text,text,text,int,int)
	TO dba,admin;
COMMIT;

BEGIN;
--Insere uma relação entre curriculo e trilha em cur_tril.
CREATE OR REPLACE FUNCTION insert_cur_tril
(curriculo_sigla text, trilha_nome text)
RETURNS INTEGER AS $$
BEGIN
	INSERT 	INTO cur_tril
		VALUES ($1,$2) ON CONFLICT DO NOTHING;

	IF FOUND THEN
		RETURN 1;
	ELSE
		RETURN -1;
	END IF;
END;
$$ LANGUAGE plpgsql;
REVOKE ALL ON FUNCTION insert_cur_tril(text,text)
	FROM PUBLIC;
GRANT EXECUTE ON FUNCTION insert_cur_tril(text,text)
	TO dba,admin;
COMMIT;

BEGIN;
--Insere uma relação entre disciplina e modulo.
CREATE OR REPLACE FUNCTION insert_dis_mod
(disc_sigla text, mod_nome text)
RETURNS INTEGER AS $$
BEGIN
	INSERT 	INTO dis_mod
		VALUES ($1,$2) ON CONFLICT DO NOTHING;

	IF FOUND THEN
		RETURN 1;
	ELSE
		RETURN -1;
	END IF;
END;
$$ LANGUAGE plpgsql;
REVOKE ALL ON FUNCTION insert_dis_mod(text,text)
	FROM PUBLIC;
GRANT EXECUTE ON FUNCTION insert_dis_mod(text,text)
	TO dba,admin;
COMMIT;

BEGIN;
/* Insere uma relação entre modulo e trilha.
Como cada trilha x modulo é 1 : N, esta relação está
dentro da tabela módulo (que diz qual a trilha dona
deste módulo). Apenas age sobre módulos que não 
estão atrelados a uma trilha.*/
CREATE OR REPLACE FUNCTION insert_tril_mod
(mod_nome text, new_trilha text)
RETURNS INTEGER AS $$
DECLARE
	var_check TEXT;
BEGIN
	SELECT 	modulo_trilha_nome 
		FROM modulo
		WHERE modulo_nome = mod_nome
		INTO var_check;

	--raise notice 'var_check = %',var_check;
	
	IF var_check IS NULL THEN
		UPDATE modulo
		SET modulo_trilha_nome = new_trilha
		WHERE modulo_nome = mod_nome;
	END IF;

	IF FOUND THEN
		RETURN 1;
	ELSE
		RETURN -1;
	END IF;
END;
$$ LANGUAGE plpgsql;
REVOKE ALL ON FUNCTION insert_tril_mod(text,text)
	FROM PUBLIC;
GRANT EXECUTE ON FUNCTION insert_tril_mod(text,text)
	TO dba,admin;
COMMIT;

/* As funções a seguir são usadas para adicionar atributos multi-valorados
às entidades correspondentes.*/
BEGIN;
CREATE OR REPLACE FUNCTION insert_trilha_extrareq
(INOUT trilha_nome text, INOUT requisito text)
AS
$$
	INSERT INTO trilha_extrareqs 
	VALUES ($1,$2)
	RETURNING trilha_nome, requisito 
$$
LANGUAGE sql;
REVOKE ALL ON FUNCTION insert_trilha_extrareq(text,text)
	FROM PUBLIC;
GRANT EXECUTE ON FUNCTION insert_trilha_extrareq(text,text)
	TO dba,admin;
COMMIT;

BEGIN;
CREATE OR REPLACE FUNCTION insert_disciplina_requisito
(INOUT disciplina_sigla text, INOUT disciplina_requisito text)
AS
$$
	INSERT INTO disciplina_requisitos 
	VALUES ($1,$2)
	RETURNING disciplina_sigla, disciplina_requisito 
$$
LANGUAGE sql;
REVOKE ALL ON FUNCTION insert_disciplina_requisito(text,text)
	FROM PUBLIC;
GRANT EXECUTE ON FUNCTION insert_disciplina_requisito(text,text)
	TO dba,admin;
COMMIT;

BEGIN;
CREATE OR REPLACE FUNCTION insert_disciplina_biblio
(INOUT disciplina_sigla text, INOUT requisito text)
AS
$$
	INSERT INTO disciplina_biblio
	VALUES ($1,$2)
	RETURNING disciplina_sigla, requisito 
$$
LANGUAGE sql;
REVOKE ALL ON FUNCTION insert_disciplina_biblio(text,text)
	FROM PUBLIC;
GRANT EXECUTE ON FUNCTION insert_disciplina_biblio(text,text)
	TO dba,admin;
COMMIT;


-------- UPDATE TYPE FUNCTIONS ------------

BEGIN;
CREATE OR REPLACE FUNCTION update_disciplina_unidade
(INOUT sigla text, INOUT new_unidade text)
AS $$
	UPDATE disciplina
	SET disciplina_unidade = new_unidade
	WHERE disciplina_sigla = sigla
	RETURNING disciplina_sigla, disciplina_unidade
$$ LANGUAGE sql;
REVOKE ALL ON FUNCTION update_disciplina_unidade(text,text)
	FROM PUBLIC;
GRANT EXECUTE ON FUNCTION update_disciplina_unidade(text,text)
	TO dba,admin;
COMMIT;

BEGIN;
CREATE OR REPLACE FUNCTION update_disciplina_nome
(INOUT sigla text, INOUT new_nome text)
AS $$
	UPDATE disciplina
	SET disciplina_nome = new_nome
	WHERE disciplina_sigla = sigla
	RETURNING disciplina_sigla, disciplina_nome
$$ LANGUAGE sql;
REVOKE ALL ON FUNCTION update_disciplina_nome(text,text)
	FROM PUBLIC;
GRANT EXECUTE ON FUNCTION update_disciplina_nome(text,text)
	TO dba,admin;
COMMIT;

BEGIN;
CREATE OR REPLACE FUNCTION update_disciplina_cred_aula
(INOUT sigla text, INOUT new_cred_aula int)
AS $$
	UPDATE disciplina
	SET disciplina_cred_aula = new_cred_aula
	WHERE disciplina_sigla = sigla
	RETURNING disciplina_sigla, disciplina_cred_aula
$$ LANGUAGE sql;
REVOKE ALL ON FUNCTION update_disciplina_cred_aula(text,int)
	FROM PUBLIC;
GRANT EXECUTE ON FUNCTION update_disciplina_cred_aula(text,int)
	TO dba,admin;
COMMIT;

BEGIN;
CREATE OR REPLACE FUNCTION update_disciplina_cred_trabalho
(INOUT sigla text, INOUT new_cred_trabalho int)
AS $$
	UPDATE disciplina
	SET disciplina_cred_trabalho = new_cred_trabalho
	WHERE disciplina_sigla = sigla
	RETURNING disciplina_sigla, disciplina_cred_trabalho
$$ LANGUAGE sql;
REVOKE ALL ON FUNCTION update_disciplina_cred_trabalho(text,int)
	FROM PUBLIC;
GRANT EXECUTE ON FUNCTION update_disciplina_cred_trabalho(text,int)
	TO dba,admin;
COMMIT;


BEGIN;
CREATE OR REPLACE FUNCTION update_curriculo_unidade
(INOUT sigla text, INOUT new_unidade text)
AS $$
	UPDATE curriculo
	SET curriculo_unidade = new_unidade
	WHERE curriculo_sigla = sigla
	RETURNING curriculo_sigla, curriculo_unidade
$$ LANGUAGE sql;
REVOKE ALL ON FUNCTION update_curriculo_unidade(text,text)
	FROM PUBLIC;
GRANT EXECUTE ON FUNCTION update_curriculo_unidade(text,text)
	TO dba,admin;
COMMIT;

BEGIN;
CREATE OR REPLACE FUNCTION update_curriculo_nome
(INOUT sigla text, INOUT new_nome text)
AS $$
	UPDATE curriculo
	SET curriculo_nome = new_nome
	WHERE curriculo_sigla = sigla
	RETURNING curriculo_sigla, curriculo_nome
$$ LANGUAGE sql;
REVOKE ALL ON FUNCTION update_curriculo_nome(text,text)
	FROM PUBLIC;
GRANT EXECUTE ON FUNCTION update_curriculo_nome(text,text)
	TO dba,admin;
COMMIT;

BEGIN;
CREATE OR REPLACE FUNCTION update_curriculo_cred_obrig
(INOUT sigla text, INOUT new_cred_obrig int)
AS $$
	UPDATE curriculo
	SET curriculo_cred_obrig = new_cred_obrig
	WHERE curriculo_sigla = sigla
	RETURNING curriculo_sigla, curriculo_cred_obrig
$$ LANGUAGE sql;
REVOKE ALL ON FUNCTION update_curriculo_cred_obrig(text,int)
	FROM PUBLIC;
GRANT EXECUTE ON FUNCTION update_curriculo_cred_obrig(text,int)
	TO dba,admin;
COMMIT;

BEGIN;
CREATE OR REPLACE FUNCTION update_curriculo_cred_opt_elet
(INOUT sigla text, INOUT new_cred_opt_elet int)
AS $$
	UPDATE curriculo
	SET curriculo_cred_opt_elet = new_cred_opt_elet
	WHERE curriculo_sigla = sigla
	RETURNING curriculo_sigla, curriculo_cred_opt_elet
$$ LANGUAGE sql;
REVOKE ALL ON FUNCTION update_curriculo_cred_opt_elet(text,int)
	FROM PUBLIC;
GRANT EXECUTE ON FUNCTION update_curriculo_cred_opt_elet(text,int)
	TO dba,admin;
COMMIT;

BEGIN;
CREATE OR REPLACE FUNCTION update_curriculo_cred_opt_liv
(INOUT sigla text, INOUT new_cred_opt_liv int)
AS $$
	UPDATE curriculo
	SET curriculo_cred_opt_liv = new_cred_opt_liv
	WHERE curriculo_sigla = sigla
	RETURNING curriculo_sigla, curriculo_cred_opt_liv
$$ LANGUAGE sql;
REVOKE ALL ON FUNCTION update_curriculo_cred_opt_liv(text,int)
	FROM PUBLIC;
GRANT EXECUTE ON FUNCTION update_curriculo_cred_opt_liv(text,int)
	TO dba,admin;
COMMIT;

BEGIN;
-- Muda descrição de uma trilha
CREATE OR REPLACE FUNCTION update_trilha_descricao
(INOUT nome text, INOUT new_descricao text)
AS $$
	UPDATE trilha
	SET trilha_descricao = new_descricao
	WHERE trilha_nome = nome 
	RETURNING trilha_nome , trilha_descricao
$$ LANGUAGE sql;
REVOKE ALL ON FUNCTION update_trilha_descricao(text,text)
	FROM PUBLIC;
GRANT EXECUTE ON FUNCTION update_trilha_descricao(text,text)
	TO dba,admin;
COMMIT;

BEGIN;
-- Muda descrição de um modulo 
CREATE OR REPLACE FUNCTION update_modulo_descricao
(INOUT nome text, INOUT new_descricao text)
AS $$
	UPDATE modulo
	SET modulo_descricao = new_descricao
	WHERE modulo_nome = nome 
	RETURNING modulo_nome , modulo_descricao
$$ LANGUAGE sql;
REVOKE ALL ON FUNCTION update_modulo_descricao(text,text)
	FROM PUBLIC;
GRANT EXECUTE ON FUNCTION update_modulo_descricao(text,text)
	TO dba,admin;
COMMIT;

BEGIN;
-- Muda a trilha ao qual este modulo esta ligado
CREATE OR REPLACE FUNCTION update_tril_mod
(INOUT mod_nome text, INOUT new_trilha text)
AS $$
	UPDATE modulo
	SET modulo_trilha_nome = new_trilha
	WHERE modulo_nome = mod_nome 
	RETURNING modulo_nome , modulo_trilha_nome
$$ LANGUAGE sql;
REVOKE ALL ON FUNCTION update_tril_mod(text,text)
	FROM PUBLIC;
GRANT EXECUTE ON FUNCTION update_tril_mod(text,text)
	TO dba,admin;
COMMIT;

BEGIN;
-- Muda a relacao entre curriculo e trilha
CREATE OR REPLACE FUNCTION update_cur_tril
(IN old_curriculo text, IN old_trilha text,
 INOUT new_curriculo text, INOUT new_trilha text)
AS $$
	UPDATE cur_tril 
	SET 	cur_tril_curriculo_sigla  = new_curriculo,
		cur_tril_trilha_nome = new_trilha
	WHERE	cur_tril_curriculo_sigla = old_curriculo AND
		cur_tril_trilha_nome = old_trilha
	RETURNING new_curriculo, new_trilha
$$ LANGUAGE sql;
REVOKE ALL ON FUNCTION update_cur_tril(text,text,text,text)
	FROM PUBLIC;
GRANT EXECUTE ON FUNCTION update_cur_tril(text,text,text,text)
	TO dba,admin;
COMMIT;

BEGIN;
-- Muda a relacao entre disciplina e modulo
CREATE OR REPLACE FUNCTION update_dis_mod
(IN old_disciplina text, IN old_modulo text,
 INOUT new_disciplina text, INOUT new_modulo text)
AS $$
	UPDATE dis_mod 
	SET 	disc_mod_disciplina_sigla  = new_disciplina,
		disc_mod_modulo_nome = new_modulo
	WHERE	disc_mod_disciplina_sigla = old_disciplina AND
		disc_mod_modulo_nome = old_modulo
	RETURNING disc_mod_disciplina_sigla, disc_mod_modulo_nome 
$$ LANGUAGE sql;
REVOKE ALL ON FUNCTION update_dis_mod(text,text,text,text)
	FROM PUBLIC;
GRANT EXECUTE ON FUNCTION update_dis_mod(text,text,text,text)
	TO dba,admin;
COMMIT;

BEGIN;
-- Muda bibliografia de uma disciplina
CREATE OR REPLACE FUNCTION update_disc_biblio_descricao
(INOUT disc_sigla text, INOUT new_descricao text)
AS $$
	UPDATE disciplina_biblio
	SET disc_biblio_descricao = new_descricao
	WHERE disc_biblio_disciplina_sigla = disc_sigla
	RETURNING disc_biblio_disciplina_sigla, disc_biblio_descricao
$$ LANGUAGE sql;
REVOKE ALL ON FUNCTION update_disc_biblio_descricao(text,text)
	FROM PUBLIC;
GRANT EXECUTE ON FUNCTION update_disc_biblio_descricao(text,text)
	TO dba,admin;
COMMIT;

-------- DELETE TYPE FUNCTIONS ------------
BEGIN;
/* Apaga um currículo.*/
CREATE OR REPLACE FUNCTION delete_curriculo
(sigla text)
RETURNS INTEGER AS $$
BEGIN
	-- Elimina relação admin x curriculo
	--tabela estrangeira
	DELETE 	FROM administra
		WHERE administra_curriculo_sigla = sigla;

	-- Finalmente pode-se apagar o curriculo.
	DELETE 	FROM curriculo 
		WHERE curriculo_sigla = sigla;

	IF FOUND THEN
		RETURN 1;
	ELSE
		RETURN -1;
	END IF;
END;
$$ LANGUAGE plpgsql;
REVOKE ALL ON FUNCTION delete_curriculo(text)
	FROM PUBLIC;
GRANT EXECUTE ON FUNCTION delete_curriculo(text)
	TO dba,admin;
COMMIT;

BEGIN;
-- Apaga uma trilha
CREATE OR REPLACE FUNCTION delete_trilha
(nome text)
RETURNS INTEGER AS $$
BEGIN
	-- Apagando relação trilha x mod
	-- Modulo continua existindo mas nao aponta mais para a trilha
	UPDATE	modulo 
	SET 	modulo_trilha_nome = NULL
	WHERE	modulo_trilha_nome = nome;

	DELETE 	FROM trilha 
		WHERE trilha_nome = nome;

	IF FOUND THEN
		RETURN 1;
	ELSE
		RETURN -1;
	END IF;
END;
$$ LANGUAGE plpgsql;
REVOKE ALL ON FUNCTION delete_trilha(text)
	FROM PUBLIC;
GRANT EXECUTE ON FUNCTION delete_trilha(text)
	TO dba,admin;
COMMIT;

BEGIN;
--Apaga um módulo
CREATE OR REPLACE FUNCTION delete_modulo
(nome text) 
RETURNS INTEGER AS $$
BEGIN
	DELETE 	FROM modulo 
		WHERE modulo_nome = nome;

	IF FOUND THEN
		RETURN 1;
	ELSE
		RETURN -1;
	END IF;
END;
$$ LANGUAGE plpgsql;
REVOKE ALL ON FUNCTION delete_modulo(text)
	FROM PUBLIC;
GRANT EXECUTE ON FUNCTION delete_modulo(text)
	TO dba,admin;
COMMIT;

BEGIN;
-- Apaga uma disciplina.
CREATE OR REPLACE FUNCTION delete_disciplina
(sigla text) 
RETURNS INTEGER AS $$
BEGIN
	DELETE 	FROM disciplina
		WHERE disciplina_sigla = sigla;

	--tabela estrangeira
	DELETE 	FROM planeja
		WHERE planeja_disciplina_sigla = sigla;

	--tabela estrangeira
	DELETE 	FROM ministra
		WHERE ministra_disciplina_sigla = sigla;

	--tabela estrangeira
	DELETE 	FROM cursa
		WHERE cursa_disciplina_sigla = sigla;

	IF FOUND THEN
		RETURN 1;
	ELSE
		RETURN -1;
	END IF;
END;
$$ LANGUAGE plpgsql;
REVOKE ALL ON FUNCTION delete_disciplina(text)
	FROM PUBLIC;
GRANT EXECUTE ON FUNCTION delete_disciplina(text)
	TO dba,admin;
COMMIT;

BEGIN;
--Apaga uma relação entre disciplina e módulo.
CREATE OR REPLACE FUNCTION delete_dis_mod
(sigla text, modulo text) 
RETURNS INTEGER AS $$
BEGIN
	DELETE 	FROM dis_mod 
		WHERE	disc_mod_disciplina_sigla = sigla AND
			disc_mod_modulo_nome = modulo;

	IF FOUND THEN
		RETURN 1;
	ELSE
		RETURN -1;
	END IF;
END;
$$ LANGUAGE plpgsql;
REVOKE ALL ON FUNCTION delete_dis_mod(text,text)
	FROM PUBLIC;
GRANT EXECUTE ON FUNCTION delete_dis_mod(text,text)
	TO dba,admin;
COMMIT;

BEGIN;
--Apaga uma relação entre trilha e currículo.
CREATE OR REPLACE FUNCTION delete_cur_tril
(sigla text, nome text) 
RETURNS INTEGER AS $$
BEGIN
	DELETE 	FROM cur_tril
		WHERE 	cur_tril_trilha_nome = nome AND
			cur_tril_curriculo_sigla = sigla;

	IF FOUND THEN
		RETURN 1;
	ELSE
		RETURN -1;
	END IF;
END;
$$ LANGUAGE plpgsql;
REVOKE ALL ON FUNCTION delete_cur_tril(text,text)
	FROM PUBLIC;
GRANT EXECUTE ON FUNCTION delete_cur_tril(text,text)
	TO dba,admin;
COMMIT;

BEGIN;
-- Apaga uma bibliografia de uma disciplina.
CREATE OR REPLACE FUNCTION delete_disc_biblio
(sigla text) 
RETURNS INTEGER AS $$
BEGIN
	DELETE 	FROM 	disciplina_biblio
		WHERE 	disc_biblio_disciplina_sigla = sigla;

	IF FOUND THEN
		RETURN 1;
	ELSE
		RETURN -1;
	END IF;
END;
$$ LANGUAGE plpgsql;
REVOKE ALL ON FUNCTION delete_disc_biblio(text)
	FROM PUBLIC;
GRANT EXECUTE ON FUNCTION delete_disc_biblio(text)
	TO dba,admin;
COMMIT;

BEGIN;
--Apaga um extra requisito de uma trilha.
CREATE OR REPLACE FUNCTION delete_trilha_requisito
(trilha text, requisito text) 
RETURNS INTEGER AS $$
BEGIN
	DELETE 	FROM 	trilha_extrareqs
		WHERE 	tril_extrareqs_trilha_nome = trilha AND
			tril_extrareqs_requisito = requisito;

	IF FOUND THEN
		RETURN 1;
	ELSE
		RETURN -1;
	END IF;
END;
$$ LANGUAGE plpgsql;
REVOKE ALL ON FUNCTION delete_trilha_requisito(text,text)
	FROM PUBLIC;
GRANT EXECUTE ON FUNCTION delete_trilha_requisito(text,text)
	TO dba,admin;
COMMIT;

BEGIN;
--Apaga um extra requisito de uma trilha usando id.
CREATE OR REPLACE FUNCTION delete_trilha_requisito_by_id
(id INTEGER) 
RETURNS INTEGER AS $$
BEGIN
	DELETE 	FROM 	trilha_extrareqs
		WHERE 	tril_extrareqs_id = id;

	IF FOUND THEN
		RETURN 1;
	ELSE
		RETURN -1;
	END IF;
END;
$$ LANGUAGE plpgsql;
REVOKE ALL ON FUNCTION delete_trilha_requisito_by_id(INTEGER)
	FROM PUBLIC;
GRANT EXECUTE ON FUNCTION delete_trilha_requisito_by_id(INTEGER)
	TO dba,admin;
COMMIT;

BEGIN;
--Apaga um extra requisito de uma disciplina.
CREATE OR REPLACE FUNCTION delete_disciplina_requisito
(sigla text, requisito text) 
RETURNS INTEGER AS $$
BEGIN
	DELETE 	FROM 	disciplina_requisitos
		WHERE 	disc_reqs_disciplina_sigla = sigla AND
			disc_reqs_disciplina_requisito = requisito;

	IF FOUND THEN
		RETURN 1;
	ELSE
		RETURN -1;
	END IF;
END;
$$ LANGUAGE plpgsql;
REVOKE ALL ON FUNCTION delete_disciplina_requisito(text,text)
	FROM PUBLIC;
GRANT EXECUTE ON FUNCTION delete_disciplina_requisito(text,text)
	TO dba,admin;
COMMIT;

-------- RETRIEVAL TYPE FUNCTIONS ------------
BEGIN;
-- retorna todos os curriculos
CREATE OR REPLACE FUNCTION return_all_curriculos()
RETURNS TABLE(	
	curriculo_sigla			TEXT,
	curriculo_unidade		TEXT,
	curriculo_nome			TEXT,
	curriculo_cred_obrig		INTEGER,
	curriculo_cred_opt_elet		INTEGER,
	curriculo_cred_opt_liv		INTEGER
)
AS $$
BEGIN
	RETURN QUERY
	SELECT * FROM curriculo;
END;
$$ LANGUAGE plpgsql;
REVOKE ALL ON FUNCTION return_all_curriculos()
	FROM PUBLIC;
GRANT EXECUTE ON FUNCTION return_all_curriculos()
	TO dba,admin;
COMMIT;

BEGIN;
-- retorna todas as trilhas
CREATE OR REPLACE FUNCTION return_all_trilhas()
RETURNS TABLE(	
	trilha_nome			TEXT,
	trilha_descricao		TEXT
)
AS $$
BEGIN
	RETURN QUERY
	SELECT * FROM trilha;
END;
$$ LANGUAGE plpgsql;
REVOKE ALL ON FUNCTION return_all_trilhas()
	FROM PUBLIC;
GRANT EXECUTE ON FUNCTION return_all_trilhas()
	TO dba,admin;
COMMIT;

BEGIN;
-- retorna todos os modulos
CREATE OR REPLACE FUNCTION return_all_modulos()
RETURNS TABLE(	
	modulo_nome			TEXT,
	modulo_descricao		TEXT,
	modulo_trilha_nome		TEXT
)
AS $$
BEGIN
	RETURN QUERY
	SELECT * FROM modulo;
END;
$$ LANGUAGE plpgsql;
REVOKE ALL ON FUNCTION return_all_modulos()
	FROM PUBLIC;
GRANT EXECUTE ON FUNCTION return_all_modulos()
	TO dba,admin;
COMMIT;

BEGIN;
-- retorna todas as disciplinas
CREATE OR REPLACE FUNCTION return_all_disciplinas()
RETURNS TABLE(	
	disciplina_sigla		TEXT,
	disciplina_unidade		TEXT,
	disciplina_nome			TEXT,
	disciplina_cred_aula		INTEGER,
	disciplina_cred_trabalho	INTEGER
)
AS $$
BEGIN
	RETURN QUERY
	SELECT * FROM disciplina;
END;
$$ LANGUAGE plpgsql;
REVOKE ALL ON FUNCTION return_all_disciplinas()
	FROM PUBLIC;
GRANT EXECUTE ON FUNCTION return_all_disciplinas()
	TO dba,admin;
COMMIT;

BEGIN;
-- retorna todas os cur_tril 
CREATE OR REPLACE FUNCTION return_all_cur_tril()
RETURNS TABLE(	
	cur_tril_curriculo_sigla	TEXT,
	cur_tril_trilha_nome		TEXT
)
AS $$
BEGIN
	RETURN QUERY
	SELECT * FROM cur_tril;
END;
$$ LANGUAGE plpgsql;
REVOKE ALL ON FUNCTION return_all_cur_tril()
	FROM PUBLIC;
GRANT EXECUTE ON FUNCTION return_all_cur_tril()
	TO dba,admin;
COMMIT;

BEGIN;
-- retorna todas os dis_mod
CREATE OR REPLACE FUNCTION return_all_dis_mod()
RETURNS TABLE(	
	disc_mod_disciplina_sigla	TEXT,
	disc_mod_modulo_nome		TEXT
)
AS $$
BEGIN
	RETURN QUERY
	SELECT * FROM dis_mod;
END;
$$ LANGUAGE plpgsql;
REVOKE ALL ON FUNCTION return_all_dis_mod()
	FROM PUBLIC;
GRANT EXECUTE ON FUNCTION return_all_dis_mod()
	TO dba,admin;
COMMIT;

BEGIN;
-- retorna todas os tril_mod
CREATE OR REPLACE FUNCTION return_all_tril_mod()
RETURNS TABLE(	
	tril_mod_trilha_nome		TEXT,
	tril_mod_modulo_nome		TEXT
)
AS $$
BEGIN
	RETURN QUERY
	SELECT modulo_trilha_nome, modulo_nome FROM modulo;
END;
$$ LANGUAGE plpgsql;
REVOKE ALL ON FUNCTION return_all_tril_mod()
	FROM PUBLIC;
GRANT EXECUTE ON FUNCTION return_all_tril_mod()
	TO dba,admin;
COMMIT;

BEGIN;
-- retorna a bibliografia de uma matéria
CREATE OR REPLACE FUNCTION return_disciplina_biblio(sigla TEXT)
RETURNS TABLE(	
	bibliografia TEXT
)
AS $$
BEGIN
	RETURN QUERY
	SELECT 	disc_biblio_descricao 
		FROM disciplina_biblio
		WHERE disc_biblio_disciplina_sigla = sigla;
END;
$$ LANGUAGE plpgsql;
REVOKE ALL ON FUNCTION return_disciplina_biblio(text)
	FROM PUBLIC;
GRANT EXECUTE ON FUNCTION return_disciplina_biblio(text)
	TO dba,admin;
COMMIT;

BEGIN;
-- retorna todas as disciplinas que são requisitos para uma outra disciplina
CREATE OR REPLACE FUNCTION return_disciplina_requisitos(sigla TEXT)
RETURNS TABLE(	
	requisitos TEXT
)
AS $$
BEGIN
	RETURN QUERY
	SELECT 	disc_reqs_disciplina_requisito
		FROM disciplina_requisitos
		WHERE disc_reqs_disciplina_sigla = sigla;
END;
$$ LANGUAGE plpgsql;
REVOKE ALL ON FUNCTION return_disciplina_requisitos(text)
	FROM PUBLIC;
GRANT EXECUTE ON FUNCTION return_disciplina_requisitos(text)
	TO dba,admin;
COMMIT;

BEGIN;
-- retorna os requisitos de uma trilha
CREATE OR REPLACE FUNCTION return_trilha_requisitos(sigla TEXT)
RETURNS TABLE(	
	requisitos TEXT
)
AS $$
BEGIN
	RETURN QUERY
	SELECT 	tril_extrareqs_requisito
		FROM trilha_extrareqs
		WHERE tril_extrareqs_trilha_nome = sigla;
END;
$$ LANGUAGE plpgsql;
REVOKE ALL ON FUNCTION return_trilha_requisitos(text)
	FROM PUBLIC;
GRANT EXECUTE ON FUNCTION return_trilha_requisitos(text)
	TO dba,admin;
COMMIT;
