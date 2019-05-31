DROP VIEW view_students;
CREATE VIEW view_students AS
SELECT a.nusp, a.pnome, b.us_login, b.us_email, c.perfil_Nome
FROM b01_pessoa a, b10_usuario b, b09_perfil c,
	b13a_rel_pe_us d, b13b_rel_us_pf e
WHERE c.perfil_Nome = 'student' AND
	a.nusp = d.rel_peus_nusp AND
	b.us_id = d.rel_peus_us_id;
