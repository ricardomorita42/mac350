-- devolve a nota de um aluno cursa
CREATE OR REPLACE FUNCTION select_nota 
(IN al_nusp int, IN prof_nusp int, IN sigla text, OUT nota numeric)
AS $$
	SELECT cursa_nota FROM cursa
	WHERE 	cursa_aluno_nusp = al_nusp AND
		cursa_prof_nusp = prof_nusp AND
		cursa_disciplina_sigla = sigla
$$
LANGUAGE sql;

-- devolve a presenca de um aluno em cursa
CREATE OR REPLACE FUNCTION select_presenca
(IN al_nusp int, IN prof_nusp int, IN sigla text, OUT presenca numeric)
AS $$
	SELECT cursa_presenca FROM cursa
	WHERE 	cursa_aluno_nusp = al_nusp AND
		cursa_prof_nusp = prof_nusp AND
		cursa_disciplina_sigla = sigla
$$
LANGUAGE sql;

--devolve o numero de cursos que um aluno tem em planeja
--e que estao disponiveis em oferecimento
CREATE OR REPLACE FUNCTION select_disc_disponiveis
(aluno_nusp int)
RETURNS TABLE(al_nusp int, disc_sigla text, prof_nusp int )AS 
$$
BEGIN
	RETURN QUERY
	SELECT 	planeja_aluno_nusp,planeja_disciplina_sigla,ofer_prof_nusp
		FROM planeja,oferecimento
	WHERE 	planeja_disciplina_sigla = ofer_disciplina_sigla AND
		planeja_aluno_nusp= aluno_nusp;
END;
$$
LANGUAGE plpgsql;

--devolve o numero de alunos que cursam uma disciplina em cursa com nota e presença
CREATE OR REPLACE FUNCTION select_alunos_numa_disciplina
(prof_nusp int, disciplina_sigla text)
RETURNS TABLE(al_nusp int, nota numeric, presenca numeric)AS 
$$
BEGIN
	RETURN QUERY
	SELECT 	cursa_aluno_nusp,cursa_nota,cursa_presenca
		FROM cursa 
	WHERE 	cursa_disciplina_sigla = disciplina_sigla AND
		cursa_prof_nusp = prof_nusp;
END;
$$
LANGUAGE plpgsql;

--devolve o numero de matérias que um professor pode ministrar
CREATE OR REPLACE FUNCTION select_materias_de_professor
(nusp int)
RETURNS TABLE(prof_nusp int,disc_sigla text )AS 
$$
BEGIN
	RETURN QUERY
	SELECT * FROM ministra
	WHERE ministra_prof_nusp = nusp;	
END;
$$
LANGUAGE plpgsql;

--retorna todos os currículos cuidados por um determinado admin
CREATE OR REPLACE FUNCTION select_curriculos_de_um_admin
(nusp int)
RETURNS TABLE(admin_nusp int, curr_sigla text, data date)AS 
$$
BEGIN
	RETURN QUERY
	SELECT * FROM administra 
	WHERE administra_nusp = nusp;
END;
$$
LANGUAGE plpgsql;

--retorna todos as disciplinas de um certo módulo 
CREATE OR REPLACE FUNCTION select_disciplinas_de_um_modulo
(nome text)
RETURNS TABLE(disciplina_sigla text, modulo_nome text)AS 
$$
BEGIN
	RETURN QUERY
	SELECT * FROM dis_mod 
	WHERE disc_mod_modulo_nome = nome;
END;
$$
LANGUAGE plpgsql;

--retorna todos os modulos de uma trilha 
CREATE OR REPLACE FUNCTION select_modulos_de_uma_trilha
(nome text)
RETURNS TABLE(mod_nome text, mod_descricao text) AS 
$$
BEGIN
	RETURN QUERY
	SELECT modulo_nome,modulo_descricao FROM modulo
	WHERE modulo_trilha_nome = nome;
END;
$$
LANGUAGE plpgsql;

--retorna todos as trilhas de um currículo
CREATE OR REPLACE FUNCTION select_trilhas_de_um_curriculo
(sigla text)
RETURNS TABLE(trilha_nome text) AS 
$$
BEGIN
	RETURN QUERY
	SELECT cur_tril_trilha_nome FROM cur_tril
	WHERE cur_tril_curriculo_sigla = sigla;
END;
$$
LANGUAGE plpgsql;

--retorna todos as disciplinas de um currículo
CREATE OR REPLACE FUNCTION select_disciplinas_de_um_curriculo
(sigla text)
RETURNS TABLE(disc_sigla text) AS 
$$
BEGIN
	RETURN QUERY
	SELECT 	disc_mod_disciplina_sigla 
	FROM 	cur_tril,modulo,dis_mod
	WHERE	cur_tril_trilha_nome = modulo_trilha_nome AND
		modulo_nome = disc_mod_modulo_nome AND
		cur_tril_curriculo_sigla = sigla;
END;
$$
LANGUAGE plpgsql;
