/*
After creating the extensions, lets create a domain for valid emails
Valid emails follows a specific Request for Comment defined in RFC5322
For more info, see: https://tools.ietf.org/html/rfc5322
*/
DROP DOMAIN IF EXISTS email CASCADE;
CREATE DOMAIN email AS citext
  CHECK ( value ~ '^[a-zA-Z0-9.!#$%&''*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?)*$' );

--b01_pessoa (NUSP, CPF, PNome, SNome, DataNasc, Sexo)
--alunos
INSERT INTO b01_pessoa VALUES (227705861,'579.652.564-14','Tonya','Thibault','15-3-1974','F');
INSERT INTO b01_pessoa VALUES (386930905,'290.027.844-46','Felipe','Derby','27-8-1986','M');
INSERT INTO b01_pessoa VALUES (859852130,'100.538.773-74','Danny','Gaston','28-6-1978','M');
INSERT INTO b01_pessoa VALUES (310554114,'205.904.185-04','Lauryn','Slattery','1-7-1950','F');
INSERT INTO b01_pessoa VALUES (613923368,'948.503.790-51','Lillian','Moilanen','16-4-1963','F');
INSERT INTO b01_pessoa VALUES (311285463,'642.726.481-09','Jessica','Beck','30-1-1993','F');
INSERT INTO b01_pessoa VALUES (991002548,'343.678.948-39','Joann','Demmons','13-6-1992','F');
INSERT INTO b01_pessoa VALUES (158298846,'291.962.071-14','Robert','Hogan','7-11-1963','M');
INSERT INTO b01_pessoa VALUES (761213416,'467.354.008-36','Rodney','Twombley','16-1-1951','M');
INSERT INTO b01_pessoa VALUES (702391605,'927.817.720-15','James','Sims','11-10-1960','M');
INSERT INTO b01_pessoa VALUES (559853740,'315.581.410-54','Jeana','Hinman','2-7-1958','F');
INSERT INTO b01_pessoa VALUES (994567006,'193.565.251-02','Heather','Obrien','10-2-1958','F');
INSERT INTO b01_pessoa VALUES (230057892,'655.514.390-88','Otis','Sumner','30-4-1953','M');
INSERT INTO b01_pessoa VALUES (961065297,'773.246.643-22','Gregory','Exum','10-3-1996','M');
INSERT INTO b01_pessoa VALUES (162109146,'292.436.018-99','Kelly','Grant','17-2-1964','F');
INSERT INTO b01_pessoa VALUES (939847659,'672.773.696-97','Marie','Harris','8-6-1981','F');
INSERT INTO b01_pessoa VALUES (489997003,'894.893.268-76','Elliott','Jones','30-6-1959','M');
INSERT INTO b01_pessoa VALUES (365513041,'483.551.084-52','David','Rodgers','12-8-1955','M');
INSERT INTO b01_pessoa VALUES (300606205,'343.742.070-97','Chester','Madril','1-8-1991','M');
INSERT INTO b01_pessoa VALUES (815705605,'375.709.244-84','David','Turner','2-9-1951','M');

--professores
INSERT INTO b01_pessoa VALUES (588508512,'610.661.507-97','Ismael','Brown','7-10-1950','M');
INSERT INTO b01_pessoa VALUES (217525199,'705.516.821-01','Virginia','Mattingly','22-2-1959','F');
INSERT INTO b01_pessoa VALUES (403856584,'614.793.727-54','Virginia','Phillips','24-2-1957','F');
INSERT INTO b01_pessoa VALUES (629091676,'718.883.731-33','Roland','Cox','23-9-1977','M');
INSERT INTO b01_pessoa VALUES (914806276,'935.664.937-77','Charles','Mishar','1-8-1965','M');
INSERT INTO b01_pessoa VALUES (442932985,'489.656.198-67','Michelle','Grawe','7-11-1966','F');
INSERT INTO b01_pessoa VALUES (292003247,'255.625.153-09','Laurence','Gibson','5-9-1980','M');
INSERT INTO b01_pessoa VALUES (388414429,'271.414.864-10','Ray','Cromer','16-8-1983','M');
INSERT INTO b01_pessoa VALUES (886902161,'823.449.865-83','Shane','Atkins','25-3-1959','M');
INSERT INTO b01_pessoa VALUES (344149328,'774.313.118-03','Raymond','Ho','14-2-1992','M');

--admnistradores
INSERT INTO b01_pessoa VALUES (933545064,'157.039.387-49','Ellen','Denney','28-3-1956','F');
INSERT INTO b01_pessoa VALUES (169779300,'341.805.458-23','Ronald','Goyette','12-1-1996','M');
INSERT INTO b01_pessoa VALUES (180318059,'879.023.781-32','Brenda','Cruz','12-3-1956','F');
INSERT INTO b01_pessoa VALUES (813824779,'843.666.950-35','Jean','Mullis','25-4-1950','F');
INSERT INTO b01_pessoa VALUES (704437879,'364.834.511-48','Katherine','Hayslip','2-4-1989','F');
INSERT INTO b01_pessoa VALUES (773718543,'121.708.156-99','Zachary','Garrett','25-3-1958','M');
INSERT INTO b01_pessoa VALUES (377913230,'497.067.626-10','Elizabeth','Mease','1-2-1975','F');
INSERT INTO b01_pessoa VALUES (306625659,'444.190.340-59','Melanie','Parker','21-1-1969','F');
INSERT INTO b01_pessoa VALUES (295230948,'237.426.428-81','Christy','Hinsley','13-8-1974','F');
INSERT INTO b01_pessoa VALUES (897719693,'862.691.319-32','Karen','Mcraney','28-9-1950','F');

--b02_aluno (al_NUSP, al_Curso)
INSERT INTO b02_aluno VALUES (227705861,'BCC');
INSERT INTO b02_aluno VALUES (386930905,'BCC');
INSERT INTO b02_aluno VALUES (859852130,'BCC');
INSERT INTO b02_aluno VALUES (310554114,'BCC');
INSERT INTO b02_aluno VALUES (613923368,'BCC');
INSERT INTO b02_aluno VALUES (311285463,'BCC');
INSERT INTO b02_aluno VALUES (991002548,'BCC');
INSERT INTO b02_aluno VALUES (158298846,'BCC');
INSERT INTO b02_aluno VALUES (761213416,'BCC');
INSERT INTO b02_aluno VALUES (702391605,'BCC');
INSERT INTO b02_aluno VALUES (559853740,'BCC');
INSERT INTO b02_aluno VALUES (994567006,'BCC');
INSERT INTO b02_aluno VALUES (230057892,'BMAT');
INSERT INTO b02_aluno VALUES (961065297,'BMAT');
INSERT INTO b02_aluno VALUES (162109146,'BMAE');
INSERT INTO b02_aluno VALUES (939847659,'BMAE');
INSERT INTO b02_aluno VALUES (489997003,'BMAE');
INSERT INTO b02_aluno VALUES (365513041,'BMAE');
INSERT INTO b02_aluno VALUES (300606205,'BMAE');
INSERT INTO b02_aluno VALUES (815705605,'BMAE');

--b03_professor (prof_NUSP,prof_Unidade)
INSERT INTO b03_professor VALUES (588508512,'IME');
INSERT INTO b03_professor VALUES (217525199,'IME');
INSERT INTO b03_professor VALUES (403856584,'IME');
INSERT INTO b03_professor VALUES (629091676,'IME');
INSERT INTO b03_professor VALUES (914806276,'IME');
INSERT INTO b03_professor VALUES (442932985,'IME');
INSERT INTO b03_professor VALUES (292003247,'EACH');
INSERT INTO b03_professor VALUES (388414429,'FEA');
INSERT INTO b03_professor VALUES (886902161,'POLI');
INSERT INTO b03_professor VALUES (344149328,'POLI');

--b04_admnistrador (adm_NUSP, adm_Unidade)
INSERT INTO b04_admnistrador VALUES (933545064,'IME');
INSERT INTO b04_admnistrador VALUES (169779300,'IME');
INSERT INTO b04_admnistrador VALUES (180318059,'IME');
INSERT INTO b04_admnistrador VALUES (813824779,'IME');
INSERT INTO b04_admnistrador VALUES (704437879,'IME');
INSERT INTO b04_admnistrador VALUES (773718543,'POLI');
INSERT INTO b04_admnistrador VALUES (377913230,'POLI');
INSERT INTO b04_admnistrador VALUES (306625659,'IME');
INSERT INTO b04_admnistrador VALUES (295230948,'POLI');
INSERT INTO b04_admnistrador VALUES (897719693,'IME');

--b05_curriculo (cur_ID, cur_Unidade, cur_Nome, cur_cred_Obrig,cur_Cred_OptElet,cur_Cred_OptLiv)
INSERT INTO b05_curriculo VALUES (1,'IME','Bacharelado em Ciencia da Computacao',111,52,24);
INSERT INTO b05_curriculo VALUES (2,'IME','Bacharelado em Estatistica',121,40,20);
INSERT INTO b05_curriculo VALUES (3,'IME','Bacharelado em Matematica',131,42,28);
INSERT INTO b05_curriculo VALUES (4,'IME','Licenciatura em Matematica ',110,32,19);
INSERT INTO b05_curriculo VALUES (5,'IME','Bacharelado em Matematica Aplicada ',150,23,45);
INSERT INTO b05_curriculo VALUES (6,'IME','Bacharelado em Matematica Aplicada e Computacional',90,22,44);
INSERT INTO b05_curriculo VALUES (7,'IME','Bacharelado em Engenharia de Software',100,52,14);
INSERT INTO b05_curriculo VALUES (8,'IME','Bacharelado em Tecnologia da Informacao',123,22,40);
INSERT INTO b05_curriculo VALUES (9,'IME','Bacharelado em Sistemas',91,52,50);
INSERT INTO b05_curriculo VALUES (10,'IME','Bacharelado em Biologia Computacional',141,22,64);

--b06_trilha (trilha_ID, trilha_Nome, trilha_Curriculo_Codigo)
INSERT INTO b06_trilha VALUES (1,'Sistemas',10);
INSERT INTO b06_trilha VALUES (2,'Redes',9);
INSERT INTO b06_trilha VALUES (3,'Ciencia de dadods',8);
INSERT INTO b06_trilha VALUES (4,'Inteligencia Artificial',7);
INSERT INTO b06_trilha VALUES (5,'Teoria da Computacao',6);
INSERT INTO b06_trilha VALUES (6,'Big Data',5);
INSERT INTO b06_trilha VALUES (7,'Fisica Computacional',4);
INSERT INTO b06_trilha VALUES (8,'Metereologia',3);
INSERT INTO b06_trilha VALUES (9,'Astronomia',2);
INSERT INTO b06_trilha VALUES (10,'Teoria dos Jogos',1);

--b07_modulo (mod_ID,mod_Curriculo,mod_Nome,mod_Trilha_Codigo)
INSERT INTO b07_modulo VALUES (1,1,'modulo bcc',1);
INSERT INTO b07_modulo VALUES (2,2,'modulo estatistica',2);
INSERT INTO b07_modulo VALUES (3,3,'modulo matematica',3);
INSERT INTO b07_modulo VALUES (4,4,'modulo licenciatura',4);
INSERT INTO b07_modulo VALUES (5,5,'modulo mat. aplicada',5);
INSERT INTO b07_modulo VALUES (6,6,'modulo mat. comp.',6);
INSERT INTO b07_modulo VALUES (7,7,'modulo engsoft',7);
INSERT INTO b07_modulo VALUES (8,8,'modulo ti',8);
INSERT INTO b07_modulo VALUES (9,9,'modulo sistemas',9);
INSERT INTO b07_modulo VALUES (10,10,'modulo biocomp',10);

--b08_disciplina (disc_ID, disc_Unidade, disc_Sigla, disc_Nome, disc_CredAula, disc_CredTrabalho)
INSERT INTO b08_disciplina VALUES (1,'IME',  'MAC0101','Topicos basicos de computação',4,0);
INSERT INTO b08_disciplina VALUES (2,'IME',  'MAC0102','Teoria de computação',4,0);
INSERT INTO b08_disciplina VALUES (3,'IME',  'MAC0110','Computação intermediario',4,2);
INSERT INTO b08_disciplina VALUES (4,'IME',  'MAC0350','Banco de Dados',4,2);
INSERT INTO b08_disciplina VALUES (5,'IME',  'MAC0210','Laboratório de Programação',4,0);
INSERT INTO b08_disciplina VALUES (6,'IME',  'MAC0420','Autômatos',4,1);
INSERT INTO b08_disciplina VALUES (7,'MAT',  'MAT0101','Calculo I',4,0);
INSERT INTO b08_disciplina VALUES (8,'MAT',  'MAT0102','Calculo II',4,0);
INSERT INTO b08_disciplina VALUES (9,'MAT',  'MAT0103','Calculo III',4,0);
INSERT INTO b08_disciplina VALUES (10,'EACH','7974123','Leitura Dramatica',2,2);

--b09_perfil (perfil_id, perfil_Nome)
--admin handles curriculum-related stuff
--superadmin can do everything
INSERT INTO b09_perfil VALUES (1,'guest');
INSERT INTO b09_perfil VALUES (2,'student');
INSERT INTO b09_perfil VALUES (3,'teacher');
INSERT INTO b09_perfil VALUES (6,'exchange_student');
INSERT INTO b09_perfil VALUES (7,'intern');
INSERT INTO b09_perfil VALUES (4,'admin');
INSERT INTO b09_perfil VALUES (5,'superadmin');

--b10_usuario (us_id, us_login, us_email, us_password)
INSERT INTO b10_usuario VALUES (1,'decio','decio@mail.com', crypt('deciopassword', gen_salt('bf')));
INSERT INTO b10_usuario VALUES (2,'alberto','alberto@mail.com', crypt('albertopassword', gen_salt('bf')));
INSERT INTO b10_usuario VALUES (3,'roberto','roberto@mail.com', crypt('robertopassword', gen_salt('bf')));
INSERT INTO b10_usuario VALUES (4,'manuel','manuel@mail.com', crypt('manuelpassword', gen_salt('bf')));
INSERT INTO b10_usuario VALUES (5,'laura','laura@mail.com', crypt('laurapassword', gen_salt('bf')));
INSERT INTO b10_usuario VALUES (6,'lecia','lecia@mail.com', crypt('leciapassword', gen_salt('bf')));
INSERT INTO b10_usuario VALUES (7,'sara','sara@mail.com', crypt('sarapassword', gen_salt('bf')));
INSERT INTO b10_usuario VALUES (8,'ricardo','ricardo@mail.com', crypt('ricardopassword', gen_salt('bf')));
INSERT INTO b10_usuario VALUES (9,'clara','clara@mail.com', crypt('clarapassword', gen_salt('bf')));
INSERT INTO b10_usuario VALUES (10,'edinaldo','edinaldo@mail.com', crypt('edinaldopassword', gen_salt('bf')));

--b11_servico (serv_ID, serv_Codigo, serv_Nome)
INSERT INTO b11_servico VALUES (1,'insert_student','inserir um aluno');
INSERT INTO b11_servico VALUES (2,'insert_teacher','inserir um professor');
INSERT INTO b11_servico VALUES (3,'insert_admin','inserir um admin');
INSERT INTO b11_servico VALUES (4,'insert_guest','inserir um visitante');
INSERT INTO b11_servico VALUES (5,'blah','ver disciplinas feitas');
INSERT INTO b11_servico VALUES (6,'blah','postar nota');
INSERT INTO b11_servico VALUES (7,'blah','ver info de curso');
INSERT INTO b11_servico VALUES (8,'blah','ver presenca');
INSERT INTO b11_servico VALUES (9,'blah','ver info disciplina');
INSERT INTO b11_servico VALUES (10,'blah','ver disciplinas oferecidas');

--b12_oferecimento (ofer_ID, ofer_NUSP,ofer_disc_Codigo,ofer_ministra_Data)
INSERT INTO b12_oferecimento VALUES (DEFAULT, 588508512,1, '4-6-2019');
INSERT INTO b12_oferecimento VALUES (DEFAULT, 217525199,2, '23-4-2019');
INSERT INTO b12_oferecimento VALUES (DEFAULT, 403856584,3, '2-4-2019');
INSERT INTO b12_oferecimento VALUES (DEFAULT, 629091676,4, '27-9-2018');
INSERT INTO b12_oferecimento VALUES (DEFAULT, 914806276,5, '8-11-2018');
INSERT INTO b12_oferecimento VALUES (DEFAULT, 442932985,6, '7-7-2018');
INSERT INTO b12_oferecimento VALUES (DEFAULT, 292003247,7, '21-11-2018');
INSERT INTO b12_oferecimento VALUES (DEFAULT, 388414429,8, '15-3-2018');
INSERT INTO b12_oferecimento VALUES (DEFAULT, 886902161,9, '12-1-2019');
INSERT INTO b12_oferecimento VALUES (DEFAULT, 344149328,10,'30-4-2019');

--b13a_rel_pe_us (rel_peus_ID, rel_peus_NUSP, rel_peus_us_ID
INSERT INTO b13a_rel_pe_us VALUES (DEFAULT,588508512,1);
INSERT INTO b13a_rel_pe_us VALUES (DEFAULT,217525199,2);
INSERT INTO b13a_rel_pe_us VALUES (DEFAULT,403856584,3);
INSERT INTO b13a_rel_pe_us VALUES (DEFAULT,629091676,4);
INSERT INTO b13a_rel_pe_us VALUES (DEFAULT,914806276,5);
INSERT INTO b13a_rel_pe_us VALUES (DEFAULT,442932985,6);
INSERT INTO b13a_rel_pe_us VALUES (DEFAULT,292003247,7);
INSERT INTO b13a_rel_pe_us VALUES (DEFAULT,388414429,8);
INSERT INTO b13a_rel_pe_us VALUES (DEFAULT,886902161,9);
INSERT INTO b13a_rel_pe_us VALUES (DEFAULT,344149328,10);

--b13b_rel_us_pf (rel_uspf_ID, rel_uspf_us_ID, rel_uspf_serv_ID,perf_inicio)
INSERT INTO b13b_rel_us_pf VALUES (DEFAULT,1,2,'12-3-2018' );
INSERT INTO b13b_rel_us_pf VALUES (DEFAULT,2,3 ,'14-8-2015' );
INSERT INTO b13b_rel_us_pf VALUES (DEFAULT,3,4 ,'11-8-2012' );
INSERT INTO b13b_rel_us_pf VALUES (DEFAULT,4,7 ,'7-4-2019'  );
INSERT INTO b13b_rel_us_pf VALUES (DEFAULT,5,6 ,'24-10-2011');
INSERT INTO b13b_rel_us_pf VALUES (DEFAULT,6,5 ,'3-9-2011'  );
INSERT INTO b13b_rel_us_pf VALUES (DEFAULT,7,4 ,'9-1-2014'  );
INSERT INTO b13b_rel_us_pf VALUES (DEFAULT,8,3 ,'27-4-2002' );
INSERT INTO b13b_rel_us_pf VALUES (DEFAULT,9,2 ,'1-4-2014'  );
INSERT INTO b13b_rel_us_pf VALUES (DEFAULT,10,1,'10-6-2011' );

--b14_rel_pf_se (rel_pfse_ID,rel_pfse_perf_ID, rel_pfse_serv_ID)
INSERT INTO b14_rel_pf_se VALUES (DEFAULT,1,1);
INSERT INTO b14_rel_pf_se VALUES (DEFAULT,2,2);
INSERT INTO b14_rel_pf_se VALUES (DEFAULT,3,3);
INSERT INTO b14_rel_pf_se VALUES (DEFAULT,4,4);
INSERT INTO b14_rel_pf_se VALUES (DEFAULT,5,5);
INSERT INTO b14_rel_pf_se VALUES (DEFAULT,6,6);
INSERT INTO b14_rel_pf_se VALUES (DEFAULT,7,7);
INSERT INTO b14_rel_pf_se VALUES (DEFAULT,1,8);
INSERT INTO b14_rel_pf_se VALUES (DEFAULT,2,9);
INSERT INTO b14_rel_pf_se VALUES (DEFAULT,3,10);

--b15_rel_admnistra (rel_adm_ID, rel_adm_NUSP, rel_adm_cur_ID, admnistra_Inicio)
INSERT INTO b15_rel_admnistra VALUES (DEFAULT,933545064,1 ,'9-7-2016' );
INSERT INTO b15_rel_admnistra VALUES (DEFAULT,169779300,2 ,'14-7-2010');
INSERT INTO b15_rel_admnistra VALUES (DEFAULT,180318059,3 ,'3-5-2012' );
INSERT INTO b15_rel_admnistra VALUES (DEFAULT,813824779,4 ,'29-10-2012');
INSERT INTO b15_rel_admnistra VALUES (DEFAULT,704437879,5 ,'9-2-2015' );
INSERT INTO b15_rel_admnistra VALUES (DEFAULT,773718543,6 ,'11-9-2017');
INSERT INTO b15_rel_admnistra VALUES (DEFAULT,377913230,7 ,'2-8-2015' );
INSERT INTO b15_rel_admnistra VALUES (DEFAULT,306625659,8 ,'4-1-2010' );
INSERT INTO b15_rel_admnistra VALUES (DEFAULT,295230948,9 ,'14-9-2014');
INSERT INTO b15_rel_admnistra VALUES (DEFAULT,897719693,10,'20-5-2019');

--b16_rel_cur_tril (rel_curtril_ID, rel_curtril_cur_ID, rel_curtril_trilha_ID)
INSERT INTO b16_rel_cur_tril VALUES (DEFAULT,1,1);
INSERT INTO b16_rel_cur_tril VALUES (DEFAULT,2,2);
INSERT INTO b16_rel_cur_tril VALUES (DEFAULT,3,3);
INSERT INTO b16_rel_cur_tril VALUES (DEFAULT,4,4);
INSERT INTO b16_rel_cur_tril VALUES (DEFAULT,5,5);
INSERT INTO b16_rel_cur_tril VALUES (DEFAULT,6,6);
INSERT INTO b16_rel_cur_tril VALUES (DEFAULT,7,7);
INSERT INTO b16_rel_cur_tril VALUES (DEFAULT,8,8);
INSERT INTO b16_rel_cur_tril VALUES (DEFAULT,9,9);
INSERT INTO b16_rel_cur_tril VALUES (DEFAULT,10,10);

--b17_rel_dis_mod (rel_dismod_ID, rel_dismod_disc_ID, rel_dismod_mod_ID)
INSERT INTO b17_rel_dis_mod VALUES (DEFAULT,1,1);
INSERT INTO b17_rel_dis_mod VALUES (DEFAULT,2,2);
INSERT INTO b17_rel_dis_mod VALUES (DEFAULT,3,3);
INSERT INTO b17_rel_dis_mod VALUES (DEFAULT,4,4);
INSERT INTO b17_rel_dis_mod VALUES (DEFAULT,5,5);
INSERT INTO b17_rel_dis_mod VALUES (DEFAULT,6,6);
INSERT INTO b17_rel_dis_mod VALUES (DEFAULT,7,7);
INSERT INTO b17_rel_dis_mod VALUES (DEFAULT,8,8);
INSERT INTO b17_rel_dis_mod VALUES (DEFAULT,9,9);
INSERT INTO b17_rel_dis_mod VALUES (DEFAULT,10,10);

--b18_rel_alu_cur (rel_alucur_ID,rel_alucur_NUSP, rel_alucur_cur_ID)
INSERT INTO b18_rel_alu_cur VALUES (DEFAULT,227705861,1);
INSERT INTO b18_rel_alu_cur VALUES (DEFAULT,386930905,2);
INSERT INTO b18_rel_alu_cur VALUES (DEFAULT,859852130,3);
INSERT INTO b18_rel_alu_cur VALUES (DEFAULT,310554114,4);
INSERT INTO b18_rel_alu_cur VALUES (DEFAULT,613923368,5);
INSERT INTO b18_rel_alu_cur VALUES (DEFAULT,311285463,6);
INSERT INTO b18_rel_alu_cur VALUES (DEFAULT,991002548,7);
INSERT INTO b18_rel_alu_cur VALUES (DEFAULT,158298846,8);
INSERT INTO b18_rel_alu_cur VALUES (DEFAULT,761213416,9);
INSERT INTO b18_rel_alu_cur VALUES (DEFAULT,702391605,10);
INSERT INTO b18_rel_alu_cur VALUES (DEFAULT,559853740,10);
INSERT INTO b18_rel_alu_cur VALUES (DEFAULT,994567006,9);
INSERT INTO b18_rel_alu_cur VALUES (DEFAULT,230057892,8);
INSERT INTO b18_rel_alu_cur VALUES (DEFAULT,961065297,7);
INSERT INTO b18_rel_alu_cur VALUES (DEFAULT,162109146,6);
INSERT INTO b18_rel_alu_cur VALUES (DEFAULT,939847659,5);
INSERT INTO b18_rel_alu_cur VALUES (DEFAULT,489997003,4);
INSERT INTO b18_rel_alu_cur VALUES (DEFAULT,365513041,3);
INSERT INTO b18_rel_alu_cur VALUES (DEFAULT,300606205,2);
INSERT INTO b18_rel_alu_cur VALUES (DEFAULT,815705605,1);

--b19_rel_planeja (rel_planeja_ID,rel_planeja_NUSP, rel_planeja_disc_ID)
INSERT INTO b19_rel_planeja VALUES (DEFAULT,559853740,1);
INSERT INTO b19_rel_planeja VALUES (DEFAULT,994567006,2);
INSERT INTO b19_rel_planeja VALUES (DEFAULT,230057892,3);
INSERT INTO b19_rel_planeja VALUES (DEFAULT,961065297,4);
INSERT INTO b19_rel_planeja VALUES (DEFAULT,162109146,5);
INSERT INTO b19_rel_planeja VALUES (DEFAULT,939847659,6);
INSERT INTO b19_rel_planeja VALUES (DEFAULT,489997003,7);
INSERT INTO b19_rel_planeja VALUES (DEFAULT,365513041,8);
INSERT INTO b19_rel_planeja VALUES (DEFAULT,300606205,9);
INSERT INTO b19_rel_planeja VALUES (DEFAULT,815705605,10);

--b20_rel_ministra (rel_ministra_ID,rel_ministra_NUSP, rel_ministra_disc_ID)
INSERT INTO b20_rel_ministra VALUES (DEFAULT,588508512,10);
INSERT INTO b20_rel_ministra VALUES (DEFAULT,217525199,9);
INSERT INTO b20_rel_ministra VALUES (DEFAULT,403856584,8);
INSERT INTO b20_rel_ministra VALUES (DEFAULT,629091676,7);
INSERT INTO b20_rel_ministra VALUES (DEFAULT,914806276,6);
INSERT INTO b20_rel_ministra VALUES (DEFAULT,442932985,5);
INSERT INTO b20_rel_ministra VALUES (DEFAULT,292003247,4);
INSERT INTO b20_rel_ministra VALUES (DEFAULT,388414429,3);
INSERT INTO b20_rel_ministra VALUES (DEFAULT,886902161,2);
INSERT INTO b20_rel_ministra VALUES (DEFAULT,344149328,1);

--b21_rel_cursa (rel_cursa_ID,rel_cursa_NUSP,rel_cursa_disc_Codigo,rel_cursa_ministra_Data,rel_cursa_Nota,rel_cursa_Presenca)
INSERT INTO b21_rel_cursa VALUES (DEFAULT,158298846,1,'1-1-2019',9,95);
INSERT INTO b21_rel_cursa VALUES (DEFAULT,761213416,2,'1-1-2019',8,80);
INSERT INTO b21_rel_cursa VALUES (DEFAULT,702391605,3,'1-1-2019',4,70);
INSERT INTO b21_rel_cursa VALUES (DEFAULT,559853740,4,'1-1-2019',5,60);
INSERT INTO b21_rel_cursa VALUES (DEFAULT,994567006,5,'1-1-2019',10,95);
INSERT INTO b21_rel_cursa VALUES (DEFAULT,230057892,6,'1-8-2018',9,100);
INSERT INTO b21_rel_cursa VALUES (DEFAULT,961065297,7,'1-8-2018',7,70);
INSERT INTO b21_rel_cursa VALUES (DEFAULT,162109146,8,'1-8-2018',10,90);
INSERT INTO b21_rel_cursa VALUES (DEFAULT,939847659,9,'1-8-2018',2,95);
INSERT INTO b21_rel_cursa VALUES (DEFAULT,489997003,10,'1-8-2018',5,90);

--b22_attr_perfil_permissoes (attr_perfperm_ID, attr_perfperm_perf_ID,attr_perfperm_permissao)
INSERT INTO b22_attr_perfil_permissoes VALUES (DEFAULT,1,10);
INSERT INTO b22_attr_perfil_permissoes VALUES (DEFAULT,2,9);
INSERT INTO b22_attr_perfil_permissoes VALUES (DEFAULT,3,8);
INSERT INTO b22_attr_perfil_permissoes VALUES (DEFAULT,4,7);
INSERT INTO b22_attr_perfil_permissoes VALUES (DEFAULT,5,6);
INSERT INTO b22_attr_perfil_permissoes VALUES (DEFAULT,6,5);
INSERT INTO b22_attr_perfil_permissoes VALUES (DEFAULT,7,4);
INSERT INTO b22_attr_perfil_permissoes VALUES (DEFAULT,1,3);
INSERT INTO b22_attr_perfil_permissoes VALUES (DEFAULT,2,2);
INSERT INTO b22_attr_perfil_permissoes VALUES (DEFAULT,3,1);

--b23_attr_linguas (attr_linguas_ID,attr_linguas_NUSP,attr_linguas_lingua)
INSERT INTO b23_attr_linguas VALUES (DEFAULT,227705861,'ingles');
INSERT INTO b23_attr_linguas VALUES (DEFAULT,386930905,'ingles');
INSERT INTO b23_attr_linguas VALUES (DEFAULT,859852130,'espanhol');
INSERT INTO b23_attr_linguas VALUES (DEFAULT,310554114,'italiano');
INSERT INTO b23_attr_linguas VALUES (DEFAULT,613923368,'alemao');
INSERT INTO b23_attr_linguas VALUES (DEFAULT,311285463,'japones');
INSERT INTO b23_attr_linguas VALUES (DEFAULT,991002548,'ingles');
INSERT INTO b23_attr_linguas VALUES (DEFAULT,158298846,'ingles');
INSERT INTO b23_attr_linguas VALUES (DEFAULT,761213416,'ingles');
INSERT INTO b23_attr_linguas VALUES (DEFAULT,702391605,'russo');

--b24_attr_disc_Cursadas (attr_disccurs_ID, attr_disccurs_NUSP,attr_disccurs_cur_ID, attr_disccurs_disc_ID)
INSERT INTO b24_attr_disc_Cursadas VALUES (DEFAULT,227705861,1,3);
INSERT INTO b24_attr_disc_Cursadas VALUES (DEFAULT,386930905,3,1);
INSERT INTO b24_attr_disc_Cursadas VALUES (DEFAULT,859852130,2,2);
INSERT INTO b24_attr_disc_Cursadas VALUES (DEFAULT,310554114,4,4);
INSERT INTO b24_attr_disc_Cursadas VALUES (DEFAULT,613923368,5,5);
INSERT INTO b24_attr_disc_Cursadas VALUES (DEFAULT,311285463,6,2);
INSERT INTO b24_attr_disc_Cursadas VALUES (DEFAULT,991002548,7,6);
INSERT INTO b24_attr_disc_Cursadas VALUES (DEFAULT,158298846,8,7);
INSERT INTO b24_attr_disc_Cursadas VALUES (DEFAULT,761213416,9,8);
INSERT INTO b24_attr_disc_Cursadas VALUES (DEFAULT,702391605,10,2);

--b25_attr_trilha_extrareqs (attr_trilhextra_ID, attr_trilhextra_trilha_ID, attr_trilhextra_Requisito)
INSERT INTO b25_attr_trilha_extrareqs VALUES (DEFAULT,1,'Fazer tcc na area');
INSERT INTO b25_attr_trilha_extrareqs VALUES (DEFAULT,1,'definir um tutor');
INSERT INTO b25_attr_trilha_extrareqs VALUES (DEFAULT,1,'definir uma area de aplicacao');
INSERT INTO b25_attr_trilha_extrareqs VALUES (DEFAULT,2,'Fazer tcc na area');
INSERT INTO b25_attr_trilha_extrareqs VALUES (DEFAULT,3,'definir um tutor');
INSERT INTO b25_attr_trilha_extrareqs VALUES (DEFAULT,4,'Fazer tcc na area');
INSERT INTO b25_attr_trilha_extrareqs VALUES (DEFAULT,5,'definir uma area de aplicacao');
INSERT INTO b25_attr_trilha_extrareqs VALUES (DEFAULT,6,'definir um tutor');
INSERT INTO b25_attr_trilha_extrareqs VALUES (DEFAULT,7,'Fazer tcc na area');
INSERT INTO b25_attr_trilha_extrareqs VALUES (DEFAULT,8,'definir um tutor');

--b26_attr_disc_reqs (attr_discreqs_ID, attr_discreqs_trilha_ID, attr_discreqs_Requisito)
INSERT INTO b26_attr_disc_reqs VALUES (DEFAULT,1,10);
INSERT INTO b26_attr_disc_reqs VALUES (DEFAULT,2,9);
INSERT INTO b26_attr_disc_reqs VALUES (DEFAULT,3,8);
INSERT INTO b26_attr_disc_reqs VALUES (DEFAULT,4,7);
INSERT INTO b26_attr_disc_reqs VALUES (DEFAULT,5,6);
INSERT INTO b26_attr_disc_reqs VALUES (DEFAULT,5,5);
INSERT INTO b26_attr_disc_reqs VALUES (DEFAULT,6,4);
INSERT INTO b26_attr_disc_reqs VALUES (DEFAULT,7,3);
INSERT INTO b26_attr_disc_reqs VALUES (DEFAULT,8,2);
INSERT INTO b26_attr_disc_reqs VALUES (DEFAULT,9,2);

--retiradas de https://pt.wikipedia.org/wiki/Bibliografia
--b27_attr_disc_biblio (attr_discbibl_ID,attr_discbibl_disc_ID,attr_discbibl_Requisito)
INSERT INTO b27_attr_disc_biblio VALUES (DEFAULT,1,'BESTERMAN, Theodore. A world bibliography of bibliographies and of bibliographical catalogues, calendars, abstracts, digests, indexes, and the like. 4. ed. Rowan & Littlefield, Totwan, N.J. 1980 (5 vol.)');
INSERT INTO b27_attr_disc_biblio VALUES (DEFAULT,2,'IOS – International Organization for Standardization. Norma ISO 690');
INSERT INTO b27_attr_disc_biblio VALUES (DEFAULT,3,'IPT – Instituto Politécnico de Leiria. Serviços de Documentação. Como Elaborar Bibliografias.');
INSERT INTO b27_attr_disc_biblio VALUES (DEFAULT,4,'MALCLÈS, Louise-Noëlle. La Bibliographie. Paris: Presses Universitaires de France, 1977.');
INSERT INTO b27_attr_disc_biblio VALUES (DEFAULT,5,'NORONHA, Daisy Pires; FERREIRA, Sueli Mara S. P. "Bibliografia especializada". In: Recursos informacionais II - CBD201 (disciplina de graduação). São Paulo: ECA/USP, 1999.');
INSERT INTO b27_attr_disc_biblio VALUES (DEFAULT,6,'WALRAVENS, Hartmut (Hrsg.): Internationale Bibliographie der Bibliographien 1959–1988. IBB. Saur, München 1998–2007, ISBN 3-598-33734-5 (13 Bde; Paralleltitel: International bibliography of bibliographies).');
INSERT INTO b27_attr_disc_biblio VALUES (DEFAULT,7,'Bibliotheca universalis sive catalogus omnium scriptorum locupletissimus in tribus linguis Latina, Graeca et Hebraica: extantium & non extantium, veterum & recentiorum.');
INSERT INTO b27_attr_disc_biblio VALUES (DEFAULT,8,'HALLEWELL (2005), p. 392.');
INSERT INTO b27_attr_disc_biblio VALUES (DEFAULT,9,'PETRY, Fernando Floriani. Revista do livro: um projeto político, literário e cultural. T');
INSERT INTO b27_attr_disc_biblio VALUES (DEFAULT,10,'LIMA, João Alberto de Oliveira; CUNHA, Murilo Bastos Tratamento da Informação legislativa e Jurídica: Uma perspetiva histórica');

--b28_attr_cur_discoptelet (attr_curoptelet_ID,attr_curoptelet_cur_ID, attr_curoptelet_disc_ID)
INSERT INTO b28_attr_cur_discoptelet VALUES (DEFAULT,1,10);
INSERT INTO b28_attr_cur_discoptelet VALUES (DEFAULT,2,9);
INSERT INTO b28_attr_cur_discoptelet VALUES (DEFAULT,3,8);
INSERT INTO b28_attr_cur_discoptelet VALUES (DEFAULT,4,7);
INSERT INTO b28_attr_cur_discoptelet VALUES (DEFAULT,5,6);
INSERT INTO b28_attr_cur_discoptelet VALUES (DEFAULT,6,5);
INSERT INTO b28_attr_cur_discoptelet VALUES (DEFAULT,7,4);
INSERT INTO b28_attr_cur_discoptelet VALUES (DEFAULT,8,3);
INSERT INTO b28_attr_cur_discoptelet VALUES (DEFAULT,9,2);
INSERT INTO b28_attr_cur_discoptelet VALUES (DEFAULT,10,1);

--b29_attr_cur_discoptliv (attr_curoptliv_ID,attr_curoptliv_cur_ID, attr_curoptliv_disc_ID)
INSERT INTO b29_attr_cur_discoptliv VALUES (DEFAULT,1,1);
INSERT INTO b29_attr_cur_discoptliv VALUES (DEFAULT,1,5);
INSERT INTO b29_attr_cur_discoptliv VALUES (DEFAULT,2,1);
INSERT INTO b29_attr_cur_discoptliv VALUES (DEFAULT,2,5);
INSERT INTO b29_attr_cur_discoptliv VALUES (DEFAULT,3,1);
INSERT INTO b29_attr_cur_discoptliv VALUES (DEFAULT,5,1);
INSERT INTO b29_attr_cur_discoptliv VALUES (DEFAULT,6,4);
INSERT INTO b29_attr_cur_discoptliv VALUES (DEFAULT,7,3);
INSERT INTO b29_attr_cur_discoptliv VALUES (DEFAULT,8,1);
INSERT INTO b29_attr_cur_discoptliv VALUES (DEFAULT,9,2);
