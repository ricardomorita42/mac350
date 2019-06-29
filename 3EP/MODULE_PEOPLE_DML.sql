\c modulo_pessoa
SET ROLE DBA;

--Students
select * from insert_person(227705861,'579.652.564-14','Tonya','Thibault','15-3-1974','F');
select * from insert_person(386930905,'290.027.844-46','Felipe','Derby','27-8-1986','M');
select * from insert_person(859852130,'100.538.773-74','Danny','Gaston','28-6-1978'	,'M');
select * from insert_person(310554114,'205.904.185-04','Lauryn','Slattery','1-7-1950'	,'F');
select * from insert_person(613923368,'948.503.790-51','Lillian','Moilanen','16-4-1963'	,'F');
select * from insert_person(311285463,'642.726.481-09','Jessica','Beck','30-1-1993'	,'F');
select * from insert_person(991002548,'343.678.948-39','Joann','Demmons','13-6-1992'	,'F');
select * from insert_person(158298846,'291.962.071-14','Robert','Hogan','7-11-1963'	,'M');
select * from insert_person(761213416,'467.354.008-36','Rodney','Twombley','16-1-1951'	,'M');
select * from insert_person(702391605,'927.817.720-15','James','Sims','11-10-1960'	,'M');
select * from insert_person(559853740,'315.581.410-54','Jeana','Hinman','2-7-1958'	,'F');
select * from insert_person(994567006,'193.565.251-02','Heather','Obrien','10-2-1958'	,'F');
select * from insert_person(230057892,'655.514.390-88','Otis','Sumner','30-4-1953'	,'M');
select * from insert_person(961065297,'773.246.643-22','Gregory','Exum','10-3-1996'	,'M');
select * from insert_person(162109146,'292.436.018-99','Kelly','Grant','17-2-1964'	,'F');
select * from insert_person(939847659,'672.773.696-97','Marie','Harris','8-6-1981'	,'F');
select * from insert_person(489997003,'894.893.268-76','Elliott','Jones','30-6-1959'	,'M');
select * from insert_person(365513041,'483.551.084-52','David','Rodgers','12-8-1955'	,'M');
select * from insert_person(300606205,'343.742.070-97','Chester','Madril','1-8-1991'	,'M');
select * from insert_person(815705605,'375.709.244-84','David','Turner','2-9-1951'	,'M');

--Teachers
select * from insert_person(588508512,'610.661.507-97','Ismael'	,'Brown','7-10-1950','M');
select * from insert_person(217525199,'705.516.821-01','Virginia','Mattingly','22-2-1959','F');
select * from insert_person(403856584,'614.793.727-54','Virginia','Phillips','24-2-1957','F');
select * from insert_person(629091676,'718.883.731-33','Roland','Cox','23-9-1977','M');
select * from insert_person(914806276,'935.664.937-77','Charles','Mishar','1-8-1965','M');
select * from insert_person(442932985,'489.656.198-67','Michelle','Grawe','7-11-1966','F');
select * from insert_person(292003247,'255.625.153-09','Laurence','Gibson','5-9-1980','M');
select * from insert_person(388414429,'271.414.864-10','Ray','Cromer','16-8-1983','M');
select * from insert_person(886902161,'823.449.865-83','Shane','Atkins','25-3-1959','M');
select * from insert_person(344149328,'774.313.118-03','Raymond','Ho','14-2-1992','M');

--Admins
select * from insert_person(933545064,'157.039.387-49','Ellen','Denney','28-3-1956','F');
select * from insert_person(169779300,'341.805.458-23','Ronald','Goyette','12-1-1996','M');
select * from insert_person(180318059,'879.023.781-32','Brenda','Cruz','12-3-1956','F');
select * from insert_person(813824779,'843.666.950-35','Jean','Mullis','25-4-1950','F');
select * from insert_person(704437879,'364.834.511-48','Katherine','Hayslip','2-4-1989','F');
select * from insert_person(773718543,'121.708.156-99','Zachary','Garrett','25-3-1958','M');
select * from insert_person(377913230,'497.067.626-10','Elizabeth','Mease','1-2-1975','F');
select * from insert_person(306625659,'444.190.340-59','Melanie','Parker','21-1-1969','F');
select * from insert_person(295230948,'237.426.428-81','Christy','Hinsley','13-8-1974','F');
select * from insert_person(897719693,'862.691.319-32','Karen','Mcraney','28-9-1950','F');

/* Adding inter_ace_pes DML because to insert a person into a role
it requires an account. This also means that DDL and Functions
for access and the inter module must've been executed already.*/
\i INTER_MOD_ACC_PEO_DML.sql

\c modulo_pessoa
SET ROLE DBA;
select * from insert_into_role_student(227705861,'BCC');
select * from insert_into_role_student(386930905,'BMAT');
select * from insert_into_role_student(859852130,'BCC');
select * from insert_into_role_student(310554114,'BCC');
select * from insert_into_role_student(613923368,'BCC');
select * from insert_into_role_student(311285463,'BCC');
select * from insert_into_role_student(991002548,'BCC');
select * from insert_into_role_student(158298846,'BCC');
select * from insert_into_role_student(761213416,'BCC');
select * from insert_into_role_student(702391605,'BCC');
select * from insert_into_role_student(559853740,'BCC');
select * from insert_into_role_student(994567006,'BCC');
select * from insert_into_role_student(230057892,'BMAT');
select * from insert_into_role_student(961065297,'BMAT');
select * from insert_into_role_student(162109146,'BMAT');
select * from insert_into_role_student(939847659,'BMAT');
select * from insert_into_role_student(489997003,'BMAE');
select * from insert_into_role_student(365513041,'BMAE');
select * from insert_into_role_student(300606205,'BMAE');
select * from insert_into_role_student(815705605,'BMAE');

select * from insert_into_role_teacher(588508512,'POLI');
select * from insert_into_role_teacher(217525199,'IME');
select * from insert_into_role_teacher(403856584,'IME');
select * from insert_into_role_teacher(629091676,'IME');
select * from insert_into_role_teacher(914806276,'IME');
select * from insert_into_role_teacher(442932985,'EACH');
select * from insert_into_role_teacher(292003247,'POLI');
select * from insert_into_role_teacher(388414429,'IME');
select * from insert_into_role_teacher(886902161,'IME');
select * from insert_into_role_teacher(344149328,'IME');

select * from insert_into_role_admin(933545064,'IME');
select * from insert_into_role_admin(169779300,'IME');
select * from insert_into_role_admin(180318059,'IME');
select * from insert_into_role_admin(813824779,'IME');
select * from insert_into_role_admin(704437879,'POLI');
select * from insert_into_role_admin(773718543,'IME');
select * from insert_into_role_admin(377913230,'IME');
select * from insert_into_role_admin(306625659,'IME');
select * from insert_into_role_admin(295230948,'POLI');
select * from insert_into_role_admin(897719693,'IME');

----!! Inserting oferecimentos !!----
select * from insert_oferecimento(588508512,'MAC0101',NULL);
select * from insert_oferecimento(217525199,'MAC0102',NULL);
select * from insert_oferecimento(403856584,'MAC0110',NULL);
select * from insert_oferecimento(629091676,'MAC0350',NULL);
select * from insert_oferecimento(914806276,'MAC0210',NULL);
select * from insert_oferecimento(442932985,'MAC0420',NULL);
select * from insert_oferecimento(292003247,'MAT0101',NULL);
select * from insert_oferecimento(388414429,'MAT0102',NULL);
select * from insert_oferecimento(886902161,'MAT0103',NULL);
select * from insert_oferecimento(344149328,'7974123',NULL);

----!! Inserting cursa !!----
select * from insert_cursa(815705605,588508512,'MAC0101',0.0,100.0);
select * from insert_cursa(559853740,217525199,'MAC0102',9.0,50.0);
select * from insert_cursa(994567006,403856584,'MAC0110',8.5,70.0);
select * from insert_cursa(230057892,629091676,'MAC0350',7.2,80.0);
select * from insert_cursa(961065297,914806276,'MAC0210',6.0,70.0);
select * from insert_cursa(162109146,442932985,'MAC0420',5.3,70.0);
select * from insert_cursa(939847659,292003247,'MAT0101',4.0,100.0);
select * from insert_cursa(489997003,388414429,'MAT0102',3.6,100.0);
select * from insert_cursa(365513041,886902161,'MAT0103',2.0,100.0);
select * from insert_cursa(300606205,344149328,'7974123',0.1,100.0);
