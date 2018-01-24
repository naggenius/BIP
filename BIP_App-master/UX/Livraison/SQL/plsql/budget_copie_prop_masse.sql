-- 
-- Cr le 03/01/2011 par ABA
--
-- 22/11/2011   BSA : QC 1268 - extension du user_rtfe de 7 a 30
--*******************************************************************

CREATE OR REPLACE PACKAGE     pack_budget_copie_propo_masse IS

 TYPE ListeViewType IS RECORD(code      VARCHAR2(5),
                                        libelle VARCHAR2(30)
                                        );
   TYPE listeCurType IS REF CURSOR RETURN ListeViewType;

/* recherche annee par défault */
PROCEDURE recherche_annee(p_annee  IN OUT VARCHAR2,
                           p_message IN OUT VARCHAR2
                              );


/* liste les types de lignes */
PROCEDURE liste_type_ligne(p_userid  IN VARCHAR2,
                           p_curseur IN OUT listeCurType
                              );

/* liste des code dossiers projet en fonction des habilitations l'utilisateur */
PROCEDURE liste_dossier_projet(p_userid  IN VARCHAR2,
                               p_annee IN VARCHAR2,
                               p_curseur IN OUT listeCurType
                              );

/* liste des code clients en fonction des habilitations de l'utilisateur */
PROCEDURE liste_client(p_userid  IN VARCHAR2,
                       p_curseur IN OUT listeCurType
                       );

TYPE RefCurTyp IS REF CURSOR;

/* liste des directions en fonction du type de ligne du client et du dossier projet */
PROCEDURE liste_direction(p_userid  IN VARCHAR2,
                       p_typeligne IN VARCHAR2,
                       p_dossproj IN VARCHAR2,
                       p_client IN VARCHAR2,
                       p_annee IN VARCHAR2,
                       p_curseur IN OUT RefCurTyp
                       );

PROCEDURE simulation_copie(p_userid  IN VARCHAR2,
                       p_typeligne IN VARCHAR2,
                       p_libelletypeligne IN VARCHAR2,
                       p_dossproj IN VARCHAR2,
                       p_libelledossproj IN VARCHAR2,
                       p_client IN VARCHAR2,
                       p_libelleclient IN VARCHAR2,
                       p_annee IN VARCHAR2,
                       p_direction IN VARCHAR2,
                       p_libelledirection IN VARCHAR2,
                       p_message_simulation IN OUT VARCHAR2,
                       p_message IN OUT VARCHAR2
                       );

FUNCTION nbre_ligne(p_userid  IN VARCHAR2,
                    p_annee IN VARCHAR2,
                    p_typeligne IN VARCHAR2,
                    p_dossproj IN VARCHAR2,
                    p_client IN VARCHAR2,
                    p_direction IN VARCHAR2) RETURN NUMBER ;

FUNCTION nbre_JH(p_userid  IN VARCHAR2,
                    p_annee IN VARCHAR2,
                    p_typeligne IN VARCHAR2,
                    p_dossproj IN VARCHAR2,
                    p_client IN VARCHAR2,
                    p_direction IN VARCHAR2) RETURN NUMBER ;

PROCEDURE validation_copie(p_userid  IN VARCHAR2,
                       p_typeligne IN VARCHAR2,
                       p_dossproj IN VARCHAR2,
                       p_client IN VARCHAR2,
                       p_annee IN VARCHAR2,
                       p_direction IN VARCHAR2,
                       p_message IN OUT VARCHAR2
                       );
END pack_budget_copie_propo_masse;
/


CREATE OR REPLACE PACKAGE BODY     pack_budget_copie_propo_masse IS

PROCEDURE recherche_annee(p_annee  IN OUT VARCHAR2,
                           p_message IN OUT VARCHAR2
                              ) IS

mois number;

BEGIN

    begin
    select to_char(datdebex,'YYYY') into p_annee from datdebex;
   --select to_number(to_char(sysdate,'MM')) into mois from dual;
   -- ABN - HP PPM 63174
   select to_number(to_char(moismens,'MM')) into mois from datdebex;
    --DBMS_OUTPUT.PUT_LINE('mois: ' || mois);
    IF (mois > 6 and p_annee >= to_char(sysdate,'YYYY') ) THEN
        p_annee := to_char(to_number(p_annee)+1)||'_DS';
    END IF;
    -- ABN - HP PPM 63174
    exception when
    others then
        p_message := sqlerrm;
     end;

END;

PROCEDURE liste_type_ligne(p_userid  IN VARCHAR2,
                           p_curseur IN OUT listeCurType
                              ) IS
BEGIN

      OPEN p_curseur FOR

         SELECT arctype code ,
             'T1 / '||rpad( arctype, 3, ' ')|| ' - ' || libarc libelle
    FROM type_activite, lien_types_proj_act
    WHERE type_act = arctype
     AND type_proj=RPAD('1', 2, ' ')
      -- Type d'activit actif
      AND actif='O'

        UNION
        SELECT typproj code,
               'T' || rpad( typproj, 3, ' ') || ' - ' || libtyp libelle
    FROM type_projet
    where   (  typproj != '1' and  typproj != '7')

    ORDER BY libelle;

END;


PROCEDURE liste_dossier_projet(p_userid  IN VARCHAR2,
                            p_annee  IN VARCHAR2,
                           p_curseur IN OUT ListeCurType
                              ) IS


    l_perimo VARCHAR2(5000);
BEGIN

    -- CMA 1176 menu client utilise perim_mcli
    l_perimo := pack_global.lire_perimcli(p_userid );

      OPEN p_curseur FOR     
 -- Update by SZ 09/02/2017 ==> when l_perimo > 1 value the select return null 
/*       select tmp.code, tmp.libelle
  from(
     select distinct
      l.dpcode  code,
      lpad(l.dpcode,5,0) || ' - ' || dp.dplib libelle,
      dp.dplib from ligne_bip l, budget b, datdebex d, dossier_projet dp
where l.pid = b.PID(+)
and l.dpcode=dp.dpcode
and (b.BPMONTMO = 0 or b.BPMONTMO is null)
and (l.ADATESTATUT is null or l.ADATESTATUT >= d.datdebex)
--and l.arctype = 'T1' --PPM 59288 : ne PAS filtrer sur les lignes GT1
and l.dpcode !=0 --PPM 59288 : exclure du résultat uniquement le DP 0
--PPM 59288 : On retire les dossier projet provisoire 88xxx
AND dp.dpcode NOT LIKE '88%'
and b.annee(+) = p_annee
and l.clicode in (select clicode from vue_clicode_perimo where BDCLICODE in (l_perimo) )
order by dp.dplib) tmp; */


  select tmp.code, tmp.libelle
  from(
     select distinct
      l.dpcode  code,
      lpad(l.dpcode,5,0) || ' - ' || dp.dplib libelle,
      dp.dplib from ligne_bip l, budget b, datdebex d, dossier_projet dp ,vue_clicode_perimo cpmo
where l.pid = b.PID(+)
and l.dpcode=dp.dpcode
and (b.BPMONTMO = 0 or b.BPMONTMO is null)
and (l.ADATESTATUT is null or l.ADATESTATUT >= d.datdebex)
--and l.arctype = 'T1' --PPM 59288 : ne PAS filtrer sur les lignes GT1
and l.dpcode !=0 --PPM 59288 : exclure du résultat uniquement le DP 0
--PPM 59288 : On retire les dossier projet provisoire 88xxx
AND dp.dpcode NOT LIKE '88%'
and b.annee(+) = 2016
and l.clicode = cpmo.clicode
and (INSTR(l_perimo, cpmo.bdclicode) > 0)
order by dp.dplib) tmp;
END;

PROCEDURE liste_client(p_userid  IN VARCHAR2,
                           p_curseur IN OUT ListeCurType
                              ) IS
    l_perimo VARCHAR2(5000);
BEGIN

    -- CMA 1176 menu client utilise perim_mcli
    l_perimo := pack_global.lire_perimcli(p_userid );

   OPEN p_curseur FOR
 -- Update by SZ 09/02/2017 ==> when l_perimo > 1 value the select return null
 /*   select tmp.code, tmp.libelle from(
     select distinct
      c.clicode  code,
      lpad(trim(c.clicode),5,'0') || ' - ' || c.clilib libelle, c.clilib  from client_mo c
      where
       c.clicode in (select clicode from vue_clicode_perimo where BDCLICODE in (l_perimo) )

order by c.clilib) tmp;*/

select tmp.code, tmp.libelle from
( SELECT DISTINCT LPAD(RTRIM(LTRIM(c.clicode)), 5, '0') AS code,
         	 lpad(trim(c.clicode),5,'0') || ' - ' || c.clilib  as libelle,c.clilib
         FROM client_mo c, vue_clicode_perimo cpmo
         WHERE c.clicode = cpmo.clicode
           AND (INSTR(l_perimo, cpmo.bdclicode) > 0)
	 ORDER BY c.clilib) tmp;

END;

PROCEDURE liste_direction(p_userid  IN VARCHAR2,
                       p_typeligne IN VARCHAR2,
                       p_dossproj IN VARCHAR2,
                       p_client IN VARCHAR2,
                       p_annee IN VARCHAR2,
                       p_curseur IN OUT RefCurTyp
                       ) IS

l_typeligne VARCHAR2(5);
req VARCHAR2(5000);
l_from VARCHAR2(2000);
l_where VARCHAR2(2000);
l_perimo VARCHAR2(5000);
BEGIN

-- CMA 1176 menu client utilise perim_mcli
l_perimo := pack_global.lire_perimcli(p_userid );

req := 'select code, libelle from (SELECT distinct s.coddir code , lpad(s.coddir,2,0) || '' - '' || br.LIBBR || ''/'' || dir.libdir libelle, br.LIBBR || ''/'' || dir.libdir';

l_from :=  ' from ligne_bip l, struct_info s, directions dir ,branches br , datdebex d, budget b ';

l_where := 'where l.codsg = s.codsg
and s.coddir = dir.coddir
and dir.codbr = br.codbr
and (l.ADATESTATUT is null or l.ADATESTATUT >= d.datdebex)
and l.pid = b.pid(+)
and b.annee(+) = ''' || p_annee || ''''  ;

--  prise en compte du type ligne
  IF (p_typeligne = 'ENV') THEN
        l_where := l_where || 'AND ((l.typproj=''1'' and l.arctype = ''P1'') or l.typproj in (''2'',''3'',''4''))';
  ELSIF (p_typeligne = 'P1') THEN
      l_where := l_where ||'AND (l.typproj=''1'' and l.arctype = ''P1'')';
  ELSIF (p_typeligne = 'T1') THEN
       l_where := l_where ||'AND (l.typproj=''1'' and l.arctype = ''T1'')' ;
  ELSIF  (p_typeligne <> 'TOUS') THEN
       l_where := l_where ||'AND l.typproj=' || p_typeligne ;
  END IF;


-- prise en compte du dossier projet qd le type de ligne est T1
IF (p_typeligne = 'T1' or p_typeligne = 'TOUS') THEN
    IF (p_dossproj = 'TOUS') THEN
         l_where := l_where || ' and (b.BPMONTMO = 0 or b.BPMONTMO is null)';

             ELSIF (p_dossproj is not null) THEN
             l_where := l_where || ' and (b.BPMONTMO = 0 or b.BPMONTMO is null)
             AND l.dpcode =' || p_dossproj || '';
            END IF;
END IF;

-- prise en compte du code client
IF (p_client = 'TOUS') THEN
 l_where := l_where || ' AND trim(l.clicode) in (select trim(clicode) from vue_clicode_perimo where BDCLICODE in ('|| l_perimo || '))order by br.LIBBR || ''/'' || dir.libdir ) tmp';
ELSE
l_where := l_where || ' AND trim(l.clicode) =trim(''' || p_client ||''') order by br.LIBBR || ''/'' || dir.libdir ) tmp';
END IF;

req := req || l_from ||l_where;

OPEN p_curseur FOR req;

END;


PROCEDURE simulation_copie(p_userid  IN VARCHAR2,
                       p_typeligne IN VARCHAR2,
                       p_libelletypeligne IN VARCHAR2,
                       p_dossproj IN VARCHAR2,
                       p_libelledossproj IN VARCHAR2,
                       p_client IN VARCHAR2,
                       p_libelleclient IN VARCHAR2,
                       p_annee IN VARCHAR2,
                       p_direction IN VARCHAR2,
                       p_libelledirection IN VARCHAR2,
                       p_message_simulation IN OUT VARCHAR2,
                       p_message IN OUT VARCHAR2
                       ) IS

nbre number(12);
l_total_ligne NUMBER(12);
 l_total_JH NUMBER(12,2);
    format_num VARCHAR2(100);
    l_type char(5);
    l_test NUMBER(12);
BEGIN

begin

 format_num:= 'alter session set nls_numeric_characters='',.''';
   execute immediate (format_num);
end;

p_message_simulation := 'A partir des critères que vous avez choisis :';
p_message_simulation := p_message_simulation ||'<ul>';
p_message_simulation := p_message_simulation || '<li>Année : ' || p_annee ||'</li>';
p_message_simulation := p_message_simulation || '<li>Types de lignes : ' || p_libelletypeligne ||'</li>';

--PPM 59288 : Elargissement DP pour tous les types de lignes
--IF (p_typeligne = 'T1' or p_typeligne = 'TOUS') THEN
    p_message_simulation := p_message_simulation || '<li>Dossier projet : ' || p_libelledossproj ||'</li>';
--END IF;

p_message_simulation := p_message_simulation || '<li>Client : ' || p_libelleclient ||'</li>';
p_message_simulation := p_message_simulation || '<li>Direction du fournisseur : ' ||p_libelledirection ||'</li>';
p_message_simulation := p_message_simulation ||'</ul>';
p_message_simulation := p_message_simulation || 'La simulation de copie donne les résultats suivants, à cet instant :<br>';


-- calcul total nbre de lignes
IF (p_typeligne = 'TOUS') THEN

    l_total_ligne := nbre_ligne(p_userid,p_annee,'T1', p_dossproj,p_client,p_direction);
    l_total_ligne := l_total_ligne + nbre_ligne(p_userid,p_annee,'P1', p_dossproj,p_client,p_direction);

     For i in 2..9
         Loop
          -- on exclut les T7
          IF (i != 7) THEN
             l_total_ligne := l_total_ligne + nbre_ligne(p_userid,p_annee,i, p_dossproj,p_client,p_direction);
          END IF;
     End loop ;

ELSIF (p_typeligne = 'ENV') THEN

  l_total_ligne := nbre_ligne(p_userid,p_annee,'P1', p_dossproj,p_client,p_direction);

     For i in 2..4
             Loop
                l_total_ligne := l_total_ligne + nbre_ligne(p_userid,p_annee,i, p_dossproj,p_client,p_direction);

         End loop ;

ELSE
 l_total_ligne := nbre_ligne(p_userid,p_annee,p_typeligne, p_dossproj,p_client,p_direction);

END IF;
p_message_simulation := p_message_simulation ||'<ul>';
 p_message_simulation := p_message_simulation ||  '<li><b>' || to_char(l_total_ligne,'FM99G999G999')   || '</b> Lignes sont concernées, réparties en';
p_message_simulation := p_message_simulation ||'<ul>';

-- calcul repartition nbre lignes
IF (p_typeligne = 'TOUS') THEN

    p_message_simulation := p_message_simulation ||  '<li><b>' || to_char(nbre_ligne(p_userid,p_annee,'T1', p_dossproj,p_client,p_direction),'99G999G990')    ||' </b>Lignes de type T1/T1';
    p_message_simulation := p_message_simulation ||  ' et <b>' || to_char(nbre_ligne(p_userid,p_annee,'P1', p_dossproj,p_client,p_direction),'FM99G999G990')    ||'</b> Lignes de type T1/P1 </li>';

     For i in 2..9
         Loop
         -- on exclut les T7
          IF (i != 7) THEN
             p_message_simulation := p_message_simulation ||  '<li><b>' || to_char(nbre_ligne(p_userid,p_annee,i, p_dossproj,p_client,p_direction),'99G999G990')    ||'</b> Lignes de type T' || i || '</li>';
           END IF;
     End loop ;


ELSIF (p_typeligne = 'ENV') THEN

 p_message_simulation := p_message_simulation ||  '<li><b>' || to_char(nbre_ligne(p_userid,p_annee,'P1', p_dossproj,p_client,p_direction),'99G999G990')    ||'</b> Lignes de type T1/P1</li>';

  For i in 2..4
         Loop
             p_message_simulation := p_message_simulation ||  '<li><b>' || to_char(nbre_ligne(p_userid,p_annee,i, p_dossproj,p_client,p_direction),'99G999G990')    ||' </b>Lignes de type T' || i || '</li>';
     End loop ;

ELSE


begin
    select decode(p_typeligne,'P1','T1/P1','T1','T1/T1','T'||p_typeligne) into l_type from dual;

end;

 p_message_simulation := p_message_simulation ||  '<li><b>' || to_char(nbre_ligne(p_userid,p_annee,p_typeligne, p_dossproj,p_client,p_direction),'99G999G990')    ||'</b> Lignes de type ' || l_type || '</li>';

END IF;
p_message_simulation := p_message_simulation ||'</ul></li>';

-- calcul de la sommes des proposé fournisseur
IF (p_typeligne = 'TOUS') THEN

l_test := nbre_JH(p_userid,p_annee,'T1', p_dossproj,p_client,p_direction);

    l_total_JH := nbre_JH(p_userid,p_annee,'T1', p_dossproj,p_client,p_direction);
    l_total_JH := l_total_JH + nbre_JH(p_userid,p_annee,'P1', p_dossproj,p_client,p_direction);

     For i in 2..9
         Loop
          -- on exclut les T7
          IF (i != 7) THEN
             l_total_JH := l_total_JH + nbre_JH(p_userid,p_annee,i, p_dossproj,p_client,p_direction);
          END IF;



     End loop ;


ELSIF (p_typeligne = 'ENV') THEN

  l_total_JH := nbre_JH(p_userid,p_annee,'P1', p_dossproj,p_client,p_direction);

     For i in 2..4
             Loop
                l_total_JH := l_total_JH + nbre_JH(p_userid,p_annee,i, p_dossproj,p_client,p_direction);

         End loop ;

ELSE
 l_total_JH := nbre_JH(p_userid,p_annee,p_typeligne, p_dossproj,p_client,p_direction);

END IF;

 p_message_simulation := p_message_simulation ||  '<li> pour un cumul du Proposé fournisseur de <b>' || to_char(nvl(l_total_JH,0),'FM99G999G990D00') || '</b> JH </li>';
 p_message_simulation := p_message_simulation ||'</ul>';

EXCEPTION
WHEN OTHERS THEN
                p_message := SQLERRM;
              RAISE_APPLICATION_ERROR( -20997, SQLERRM);


END;

FUNCTION nbre_ligne(p_userid  IN VARCHAR2,
                    p_annee IN VARCHAR2,
                    p_typeligne IN VARCHAR2,
                    p_dossproj IN VARCHAR2,
                    p_client IN VARCHAR2,
                    p_direction IN VARCHAR2) RETURN NUMBER IS

nbre NUMBEr(12);
req VARCHAR2(4000);
l_where VARCHAR2(4000);
l_perimo VARCHAR2(5000);

BEGIN

-- CMA 1176 menu client utilise perim_mcli
l_perimo := pack_global.lire_perimcli(p_userid );

req := 'select count(l.pid) from budget b, ligne_bip l, datdebex d, struct_info s ';
l_where :=   'where l.pid = b.pid(+)
               and s.codsg = l.codsg
               and (b.BPMONTMO = 0 or b.BPMONTMO is null)
               and (l.ADATESTATUT is null or l.ADATESTATUT >= d.datdebex)
                and b.annee(+) =' || p_annee;

IF (p_typeligne = 'T1') THEN

   l_where := l_where ||' AND (l.typproj=''1'' and l.arctype = ''T1'')'  ;

ELSIF (p_typeligne = 'P1') THEN
 l_where := l_where ||' AND (l.typproj=''1'' and l.arctype = ''P1'')';
ELSE
           l_where := l_where ||' AND l.typproj=' || p_typeligne ;
END IF;


 IF (p_dossproj != 'TOUS') THEN
             l_where := l_where || ' AND l.dpcode =' || p_dossproj || '';

 END IF;


-- prise en compte du code client
IF (p_client = 'TOUS') THEN
 l_where := l_where || ' AND trim(l.clicode) in (select trim(clicode) from vue_clicode_perimo where BDCLICODE in ('|| l_perimo || '))';
ELSE
l_where := l_where || ' AND trim(l.clicode) =trim(''' || p_client ||''')';
END IF;


-- prise en compte du code direction
IF (p_direction != 'TOUS') THEN
   l_where := l_where || ' AND trim(s.coddir) =' || p_direction;
END IF;

req := req || l_where;

EXECUTE IMMEDIATE req INTO nbre ;
return nvl(nbre,0);

END;


FUNCTION nbre_JH(p_userid  IN VARCHAR2,
                    p_annee IN VARCHAR2,
                    p_typeligne IN VARCHAR2,
                    p_dossproj IN VARCHAR2,
                    p_client IN VARCHAR2,
                    p_direction IN VARCHAR2) RETURN NUMBER IS

nbre NUMBEr(12,2);
req VARCHAR2(4000);
l_where VARCHAR2(4000);
l_perimo VARCHAR2(5000);

BEGIN

-- CMA 1176 menu client utilise perim_mcli
l_perimo := pack_global.lire_perimcli(p_userid );

req := 'select sum(nvl(b.BPMONTME,0)) from budget b, ligne_bip l, datdebex d, struct_info s ';
l_where :=   'where l.pid = b.pid
               and s.codsg = l.codsg
               and (b.BPMONTMO = 0 or b.BPMONTMO is null)
               and (l.ADATESTATUT is null or l.ADATESTATUT >= d.datdebex)
               and b.annee =' || p_annee;

IF (p_typeligne = 'T1') THEN
    l_where := l_where ||' AND (l.typproj=''1'' and l.arctype = ''T1'')'  ;
ELSIF (p_typeligne = 'P1') THEN
 l_where := l_where ||' AND (l.typproj=''1'' and l.arctype = ''P1'')';
ELSE
           l_where := l_where ||' AND l.typproj=' || p_typeligne ;
END IF;

 IF (p_dossproj != 'TOUS') THEN
             l_where := l_where || ' AND l.dpcode =' || p_dossproj || '';
 END IF;

-- prise en compte du code client
IF (p_client = 'TOUS') THEN
 l_where := l_where || ' AND trim(l.clicode) in (select trim(clicode) from vue_clicode_perimo where BDCLICODE in ('|| l_perimo || '))';
ELSE
l_where := l_where || ' AND trim(l.clicode) =trim(''' || p_client ||''')';
END IF;

-- prise en compte du code direction
IF (p_direction != 'TOUS') THEN
   l_where := l_where || ' AND trim(s.coddir) =' || p_direction;
END IF;

req := req || l_where;


EXECUTE IMMEDIATE req INTO nbre ;

return nvl(nbre,0);

END;

PROCEDURE validation_copie(p_userid  IN VARCHAR2,
                       p_typeligne IN VARCHAR2,
                       p_dossproj IN VARCHAR2,
                       p_client IN VARCHAR2,
                       p_annee IN VARCHAR2,
                       p_direction IN VARCHAR2,
                       p_message IN OUT VARCHAR2
                       ) IS

req varchar2(4000);
l_dir number(2);
cur RefCurTyp;
TYPE rec_pid IS RECORD (pid VARCHAR2(4));
TYPE list_pid IS TABLE OF rec_pid;
t_pid list_pid;
indx PLS_INTEGER;
l_where VARCHAR2(4000);
l_perimo VARCHAR2(5000);
l_compteur number(12);

l_proposefour NUMBER(12,2);
old_BPMONTMO NUMBER(12,2);

 l_user VARCHAR2(30);
BEGIN

 l_user := SUBSTR(Pack_Global.lire_globaldata(p_userid).idarpege, 1, 30);
 -- CMA 1176 menu client utilise perim_mcli
l_perimo := pack_global.lire_perimcli(p_userid );

req := 'select b.pid from budget b, ligne_bip l, datdebex d, struct_info s ';

l_where := ' where l.pid = b.pid
               and s.codsg = l.codsg
               and (b.BPMONTMO = 0 or b.BPMONTMO is null)
               and (l.ADATESTATUT is null or l.ADATESTATUT >= d.datdebex)
               and b.annee =' || p_annee;

-- Debut PPM 59288 : Elargissement DP pour tous les types de lignes
    IF (p_dossproj != 'TOUS') THEN
             l_where := l_where || ' AND l.dpcode =' || p_dossproj || '';

    END IF;
-- Fin PPM 59288 : Elargissement DP 

IF (p_typeligne = 'TOUS') THEN
/*PPM 59288 debut 
    IF (p_dossproj != 'TOUS') THEN
             l_where := l_where || ' AND l.dpcode =' || p_dossproj || '';
    END IF;
PPM 59288 fin*/
    l_where := l_where ||' AND ((l.typproj=''1'' and l.arctype = ''T1'') or (l.typproj=''1'' and l.arctype = ''P1'') or l.typproj != 7)'  ;
ELSIF (p_typeligne = 'ENV') THEN  
    l_where := l_where ||' AND ((l.typproj=''1'' and l.arctype = ''P1'') or l.typproj in (2,3,4))'  ;
ELSIF (p_typeligne = 'T1') THEN

/*PPM 59288 debut 
    IF (p_dossproj != 'TOUS') THEN
             l_where := l_where || ' AND l.dpcode =' || p_dossproj || '';

    END IF;

PPM 59288 fin*/
    l_where := l_where ||' AND (l.typproj=''1'' and l.arctype = ''T1'')'  ;

ELSIF (p_typeligne = 'P1') THEN
 l_where := l_where ||' AND (l.typproj=''1'' and l.arctype = ''P1'')';
ELSE
           l_where := l_where ||' AND l.typproj=' || p_typeligne ;
END IF;

-- prise en compte du code client
IF (p_client = 'TOUS') THEN
 l_where := l_where || ' AND trim(l.clicode) in (select trim(clicode) from vue_clicode_perimo where BDCLICODE in ('|| l_perimo || '))';
ELSE
l_where := l_where || ' AND trim(l.clicode) =trim(''' || p_client ||''')';
END IF;

-- prise en compte du code direction
IF (p_direction != 'TOUS') THEN
   l_where := l_where || ' AND trim(s.coddir) =' || p_direction;
END IF;

req := req || l_where;

Open cur for req;
fetch cur BULK COLLECT into t_pid;
close cur;
l_compteur:= 0;

indx := t_pid.FIRST;
    LOOP
         EXIT WHEN indx IS NULL;

         select nvl(BPMONTME,0), BPMONTMO into l_proposefour, old_BPMONTMO from budget where pid = t_pid(indx).pid and annee = p_annee;

         if (l_proposefour != 0) then
            update budget set BPMONTMO=l_proposefour where pid = t_pid(indx).pid and annee = p_annee;
            Pack_Ligne_Bip.maj_ligne_bip_logs(t_pid(indx).pid, l_user, 'Proposé client ' || p_annee, old_BPMONTMO ,l_proposefour, '(MAJ MASSE) modification proposé client');
            l_compteur:= l_compteur +1;
         end if;


         indx := t_pid.NEXT (indx);
     END LOOP;


IF (l_compteur = 0) THEN
    p_message := 'Aucune mise à jour n''a été effectué compte-tenu de vos critères de sélection';
else
    p_message := 'Mise à jour effectuée : ' || l_compteur || ' lignes ont eu leur Proposé fournisseur copié';

END IF;

EXCEPTION
    WHEN OTHERS THEN
          p_message := SQLERRM;
          RAISE_APPLICATION_ERROR( -20997, SQLERRM);
END;

END pack_budget_copie_propo_masse;
/
