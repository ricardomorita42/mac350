DROP VIEW view_students;
CREATE VIEW view_students AS
SELECT a.nusp, a.pnome, b.us_login, b.us_email, c.perfil_Nome
FROM b01_pessoa a, b10_usuario b, b09_perfil c,
	b13a_rel_pe_us d, b13b_rel_us_pf e
WHERE a.nusp = d.rel_peus_nusp AND
	b.us_ID = d.rel_peus_us_ID AND
	b.us_ID = e.rel_uspf_perfil_ID AND
	c.perfil_ID = e.rel_uspf_perfil_ID;

DROP VIEW view_teste;
CREATE VIEW view_teste AS
SELECT a.nusp, b.us_login, d.perfil_Nome 
FROM b01_pessoa a, b10_usuario b, b13a_rel_pe_us c,
	b09_perfil d, b13b_rel_us_pf e
WHERE a.nusp = c.rel_peus_nusp AND
	b.us_ID = c.rel_peus_us_ID AND
	b.us_ID = e.rel_uspf_us_ID AND
	e.rel_uspf_perfil_ID = d.perfil_ID;

