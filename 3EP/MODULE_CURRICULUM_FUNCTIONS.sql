\c modulo_curriculo
SET ROLE dba;

BEGIN;
--Insere um curriculo novo.
CREATE OR REPLACE FUNCTION insert_curriculum
(curriculo_sigla text, curriculo_unidade text, curriculo_nome text, curriculo_cred_obrig int,
 curriculo_cred_opt_elet int, curriculo_opt_liv int)
RETURNS INTEGER AS $$
BEGIN
	INSERT into curriculo VALUES ($1,$2,$3,$4,$5,$6) ON CONFLICT DO NOTHING;

	RETURN 1;
END;
$$ LANGUAGE plpgsql;
REVOKE ALL ON FUNCTION insert_curriculum(text,text,text,int,int,int)
	FROM PUBLIC;
GRANT EXECUTE ON FUNCTION insert_curriculum(text,text,text,int,int,int)
	TO dba,admin;
COMMIT;

BEGIN;
--Insere uma trilha.
CREATE OR REPLACE FUNCTION insert_trilha
(trilha_nome text, trilha_descricao text)
RETURNS INTEGER AS $$
BEGIN
	INSERT INTO trilha VALUES ($1,$2) ON CONFLICT DO NOTHING;

	RETURN 1;
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

	RETURN 1;
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

	RETURN 1;
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

	RETURN 1;
END;
$$ LANGUAGE plpgsql;
REVOKE ALL ON FUNCTION insert_cur_tril(text,text)
	FROM PUBLIC;
GRANT EXECUTE ON FUNCTION insert_cur_tril(text,text)
	TO dba,admin;
COMMIT;

BEGIN;
--Insere uma relação entre disciplina e modulo em .
CREATE OR REPLACE FUNCTION insert_dis_mod
(disc_sigla text, mod_nome text)
RETURNS INTEGER AS $$
BEGIN
	INSERT 	INTO dis_mod
		VALUES ($1,$2) ON CONFLICT DO NOTHING;

	RETURN 1;
END;
$$ LANGUAGE plpgsql;
REVOKE ALL ON FUNCTION insert_dis_mod(text,text)
	FROM PUBLIC;
GRANT EXECUTE ON FUNCTION insert_dis_mod(text,text)
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
