-- pack_mail PL/SQL
--
-- equipe TEAM PARTNERS
--
-- crée le 18/09/2009
-- Package de gestion de l'envoi des mail
--
--
-- Quand      Qui    Quoi
-- --------   ---    ----------------------------------------
-- 18/06/2009 EVI    TD 792: création du package

CREATE OR REPLACE PACKAGE     pack_mail AS

   TYPE codremonte_ListeViewType IS RECORD( id      contact_mail.codremonte%TYPE,
                    libelle contact_mail.libelle%TYPE
                                        );

   TYPE codremonte_listeCurType IS REF CURSOR RETURN codremonte_ListeViewType;

   TYPE mail_ViewType IS RECORD (  codremonte    contact_mail.codremonte%TYPE,
                                   mail1         contact_mail.mail1%TYPE,
                                   mail2         contact_mail.mail2%TYPE,
                                   mail3         contact_mail.mail3%TYPE
                    );


   TYPE mailCurType_Char IS REF CURSOR RETURN mail_ViewType;

   PROCEDURE select_mail (     p_codremonte     IN VARCHAR2,
                                       p_curseur     IN OUT mailCurType_Char ,
                                       p_message     	OUT VARCHAR2
                                	);

   PROCEDURE update_mail (     p_codremonte     IN VARCHAR2,
                                       p_mail1  IN VARCHAR2 ,
                                       p_mail2  IN VARCHAR2 ,
                                       p_mail3  IN VARCHAR2 ,
                                       p_message out VARCHAR2
                                	);

   PROCEDURE lister_codremonte(p_userid  IN VARCHAR2,
                           p_curseur IN OUT codremonte_listeCurType
                          );

/*   PROCEDURE envoi_mail (p_codremonte IN contact_mail.codremonte%TYPE,
                         p_frep IN VARCHAR2,
                         p_fname IN VARCHAR2
                         );*/
END pack_mail;
/


CREATE OR REPLACE PACKAGE BODY     pack_mail AS


   PROCEDURE select_mail (     p_codremonte     IN VARCHAR2,
                               p_curseur     IN OUT mailCurType_Char ,
                               p_message     	OUT VARCHAR2
                                      ) IS

    l_msg VARCHAR2(1024);

   BEGIN
      -- Initialiser le message retour
          p_message := '';


	BEGIN
        	OPEN   p_curseur FOR
              	SELECT 	codremonte,mail1, mail2, mail3
              	FROM  contact_mail
              	WHERE codremonte=p_codremonte;

      		EXCEPTION
			WHEN OTHERS THEN
         		raise_application_error( -20997, SQLERRM);
       END;

     p_message := l_msg;

   END select_mail;


   PROCEDURE update_mail (     p_codremonte     IN VARCHAR2,
                                       p_mail1  IN VARCHAR2 ,
                                       p_mail2  IN VARCHAR2 ,
                                       p_mail3  IN VARCHAR2 ,
                                       p_message OUT VARCHAR2
                                	) IS

   BEGIN

   -- Initialiser le message retour
          p_message := '';

    BEGIN

        update contact_mail set mail1= p_mail1,
                                mail2= p_mail2,
                                mail3= p_mail3
                                where codremonte= p_codremonte;

   EXCEPTION
			WHEN OTHERS THEN
         		raise_application_error( -20997, SQLERRM);
   END;

   p_message := 'Mise à jour du code remontée ' ||p_codremonte ||' effectuée';

   END update_mail;


   PROCEDURE lister_codremonte (p_userid  IN VARCHAR2,
                            p_curseur IN OUT codremonte_listeCurType
                           ) IS
   BEGIN

      OPEN p_curseur FOR
      	SELECT codremonte, libelle
	    FROM contact_mail
      ORDER BY libelle ASC;

   END lister_codremonte;

  /*
    PROCEDURE envoi_mail (p_codremonte IN contact_mail.codremonte%TYPE,
                         p_frep IN VARCHAR2,
                         p_fname IN VARCHAR2
                         ) IS
   vInHandle utl_file.file_type;
   rfile     RAW(32767);
   flen      NUMBER;
   bsize     NUMBER;
   ex        BOOLEAN;

   vSender   VARCHAR2(30) := 'liste.BIP@socgen.com';
   vRecipients VARCHAR2(600);
   vSubj     VARCHAR2(50) ;
   vMesg     VARCHAR2(4000);
   vMType    VARCHAR2(30) := 'text/plain; charset=us-ascii';

   l_libelle contact_mail.libelle%TYPE;

  BEGIN

  -- On Test la presence du fichier
  utl_file.fgetattr(p_frep, p_fname, ex, flen, bsize);
  -- On ouvre le fichier
  vInHandle := utl_file.fopen(p_frep, p_fname, 'R');
  utl_file.get_raw(vInHandle, rfile, flen);
  utl_file.fclose(vInHandle);

  -- Construction de la liste des adresses mail et du sujet
  Select mail1 || decode(mail2,NULL,'',';'||mail2) || decode(mail3,NULL,'',';'||mail3), libelle INTO vRecipients, l_libelle
  From contact_mail
  Where codremonte=p_codremonte;

  vSubj := 'BIP - Compte Rendu - '|| l_libelle;
  -- Construction du corps du message
  vMesg := 'Bonjour, '|| CHR(10) || CHR(10)
            ||'Ceci est un compte rendu automatique émis par la BIP dans le cadre du '|| l_libelle ||' ('||p_codremonte||')'
            || CHR(10) || CHR(10) || 'Cordialement';

    -- On effectue l'envoi du fichier par mail
    utl_mail.send_attach_raw(
      sender => vSender,
      recipients => vRecipients,
      cc => vSender,
      subject => vSubj,
      message => vMesg,
      attachment => rfile,
      att_inline => FALSE,
      att_filename => p_fname);

   EXCEPTION
			WHEN OTHERS THEN
         		raise_application_error( -20997, SQLERRM);

   END envoi_mail;*/

END pack_mail;
/




