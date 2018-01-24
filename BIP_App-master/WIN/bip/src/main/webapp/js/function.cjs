function ChargeCa(CA,champ,form)
{	eval('currentInput=form.'+champ);

	if (CA != 'null' && CA != '')
	
	for (loop1=0 ; loop1 < currentInput.length;loop1++)
	{ 			
		if (currentInput[loop1].value == CA){
		currentInput.value = CA;
		break;
		}
	}
}
function Replace_DoubleZero_by_DoubleEtoile(str)
{
   var RE = /0000000/;
   if ( str.match(RE) ) return "*******";

   RE = /([0-9][0-9][0-9])0000/;
   if ( str.match(RE) ) return str.replace(RE,"$1****");

   RE = /([0-9][0-9][0-9][0-9][0-9])00/;
   if ( str.match(RE) ) return str.replace(RE,"$1**");

   RE = /00000/;
   if ( str.match(RE) ) return "*****";

   RE = /([0-9][0-9][0-9])00/;
   if ( str.match(RE) ) return str.replace(RE,"$1**");

   return str;
}


function Replace_DoubleEtoile_by_DoubleZero(str)
{
   var RE = /\*\*\*\*\*\*\*/;
   if ( str.match(RE) ) return "0000000";

   RE = /([0-9][0-9][0-9])\*\*\*\*/;
   if ( str.match(RE) ) return str.replace(RE,"$10000");

   RE = /([0-9][0-9][0-9][0-9][0-9])\*\*/;
   if ( str.match(RE) ) return str.replace(RE,"$100");

   return str;
}


function VerifierRegExp(EF, re, msg)
{
   var RE = new RegExp(re);

   if (EF.value.length == 0) return true;

   if ( !RE.test(EF.value) ) {
	alert(msg);
	EF.value="";
	EF.focus();
	return false;
   }
   return true;
}



function VerifFormat(fieldName)
{
   if (fieldName!=null) {
	blnVerifFormat = eval( tabVerif[fieldName] );
	return blnVerifFormat;
   }

   if (!blnVerifFormat) {
	blnVerifFormat = true;
	return false;
   }

   for (i in tabVerif) {
	//
	// if( !eval(tabVerif[i]) ) return false;	
	//
	blnVerifFormat = eval( tabVerif[i] );
	if( !blnVerifFormat ) return false;
   }   
   return true;
}


function Left( EF )
{
   var Cpt = 0;

   if (EF.value.length > 0) {
	for (Cpt=EF.value.length-1; Cpt >=0; Cpt-- ) {
	   if (EF.value.charAt(Cpt) != ' ') {
		EF.value = EF.value.substring(0, Cpt+1);
		return;
	   }
	}
   }
   EF.value = "";
}


function ChampObligatoire( EF, strLibelle)
{
   Left(EF);
   if (EF.value.length == 0) {
	alert("Entrez "+strLibelle);
	EF.focus();
	return false;
   }
   else return true;
}

function ChampObligatoirePersonnalise( EF, strLibelle)
{
   Left(EF);
   if (EF.value.length == 0) {
	alert(strLibelle);
	EF.focus();
	return false;
   }
   else return true;
}


function ChampObligatoireLibelle( EF)
{
   Left(EF);
   if (EF.value.length == 0) {
	alert("Entrez le libellÈ");
	EF.focus();
	return false;
   }
   else return true;
}



function ListeObligatoire( EF, strLibelle)
{
   if ((EF.value == "") || (EF.value==" ")) {
	alert("Entrez "+strLibelle);
	EF.focus();
	return false;
   }
   else return true;
}

function ListeObligatoireDBS( EF, strLibelle)
{
   if ((EF.value == "") || (EF.value==" ")) {
	alert("SÈlectionnez "+strLibelle);
	EF.focus();
	return false;
   }
   else return true;
}




function DoubleChamp( EF1 , EF2 , strLibelle )
{
   var ln1;
   var ln2;

   Left(EF1);
   ln1 = EF1.value.length;
   Left(EF2);
   ln2 = EF2.value.length;

   if ( (ln1*ln2 == 0) && (ln1+ln2 > 0) )
   {
      alert("Pour " + strLibelle + " il faut saisir les deux valeurs ou aucune.");
      EF1.focus;
      return false;
   }
   return true;
}

function isLowerCase(valeur){
	var regExpression=new RegExp("[a-z‡‚‰ÁÈËÍÎÓÔÙˆ˘˚¸]");
	var caractere;
   	for (Cpt=0; Cpt < valeur.length; Cpt++ ) {
		caractere = valeur.charAt(Cpt);
		if (regExpression.test(caractere)) {
			return true;
		}
	}
	return false;
}

function verif_numeric(variable)
{
	var exp = new RegExp("^[0-9]+$","g");
	return exp.test(variable);
} 

function checkAlphanum(valeur){
	var regExpression=/[^A-Za-z0-9 ]+/;
	if (regExpression.test(valeur)) {
		return false;
	}
	return true;
}

function VerifierAlphanum( EF )
{
   var restrict = '$";';
   var Caractere;

   for (Cpt=0; Cpt < EF.value.length; Cpt++ ) {
	Caractere = EF.value.charAt(Cpt);
	if (restrict.indexOf(Caractere) != -1) {
	   alert( "Saisie invalide");
	   EF.focus();
	   //EF.value="";
	   return false;
	}
   }
   return true;
}


function VerifierAlphanumExclusionEtCommercial( EF )
{
   var restrict = '$";';
   var Caractere;

   for (Cpt=0; Cpt < EF.value.length; Cpt++ ) {
	Caractere = EF.value.charAt(Cpt);
	if (restrict.indexOf(Caractere) != -1) {
	   alert( "Saisie invalide");
	   EF.focus();
	   //EF.value="";
	   return false;
	}
	if(Caractere=='&'){
	   alert( "Le caractËre ''&'' n'est pas autorisÈ sur ces Ècrans pour cause d'appel ‡ une fenÍtre popup pour la modification !");	
	   EF.focus();
	   //EF.value="";
	   return false;
	}	
   }
 
   return true;
}

function VerifierAlphanumExclusion( EF )
{
   var restrict = ';,.';
   var Caractere;

   for (Cpt=0; Cpt < EF.value.length; Cpt++ ) {
	Caractere = EF.value.charAt(Cpt);
	if (restrict.indexOf(Caractere) != -1) {
	   alert( "Saisie invalide des caractËres suivants ;,.");
	   EF.focus();
	   //EF.value="";
	   return false;
	}
		
   }
 
   return true;
}



function VerifierAlphaMax( EF )
{
   var Alphamin = 'abcdefghijklmnopqrstuvwxyz';
   var Alphamax = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ';
   var Accents = '‡‚‰ÁÈËÍÎÓÔÙˆ˘˚¸¬ƒ À»$";'

   var Champ = "";
   var Caractere;
   for (Cpt=0; Cpt < EF.value.length; Cpt++ ) {
	Caractere = EF.value.charAt(Cpt);
	if (Accents.indexOf(Caractere,0) != -1) {
	   alert( "Saisie invalide");
	   EF.focus();
	   EF.value="";
	   return false;
	}
	else if (Alphamin.indexOf(Caractere,0) != -1) {
	   Champ += Alphamax.charAt(Alphamin.indexOf(Caractere,0));
	}
	else
	   Champ += Caractere;
   }
   EF.value = Champ;
   return true;
}

//fonction creee pour empecher la saisie de caracteres speciaux dans le numero de facture

function VerifierAlphaMaxCarSpec( EF )
{
   var Alphamin = 'abcdefghijklmnopqrstuvwxyz';
   var Alphamax = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ';
   var Accents = '‡‚‰ÁÈËÍÎÓÔÙˆ˘˚¸¬ƒ À»$"; *&(@)!:?ß/<>+-.~#{[|`\\_^]}=∞§£µ®\''

   var Champ = "";
   var Caractere;
   for (Cpt=0; Cpt < EF.value.length; Cpt++ ) {
	Caractere = EF.value.charAt(Cpt);
	if (Accents.indexOf(Caractere,0) != -1) {
	   alert( "Saisie invalide");
	   EF.focus();
	   EF.value="";
	   return false;
	}
	else if (Alphamin.indexOf(Caractere,0) != -1) {
	   Champ += Alphamax.charAt(Alphamin.indexOf(Caractere,0));
	}
	else
	   Champ += Caractere;
   }
   EF.value = Champ;
   return true;
}

//fonction creee pour empecher la saisie de caracteres speciaux dans un champ sans effacer celui-ci ‡ la suite du message

function VerifAlphaMaxCarSpecSansEff( EF, champTest )
{
   var Accents = '‚‰ÎÓÔÙˆ˚¸¬ƒ À»$ß~`∞§£µ®'

   var Champ = "";
   var Caractere;
   for (Cpt=0; Cpt < EF.value.length; Cpt++ ) {
	Caractere = EF.value.charAt(Cpt);
	if (Accents.indexOf(Caractere,0) != -1) {
	   alert( "Champ "+champTest+" : Èvitez les caractËres spÈciaux");
	   EF.focus();
	   return false;
	}
	
	else
	   Champ += Caractere;
   }
   EF.value = Champ;
   return true;
}

//KRA PPM 58087 : fonction, pour les champs clÈs, creee pour empecher la saisie de caracteres speciaux dans un champ sans effacer celui-ci ‡ la suite du message

function VerifAlphaMaxCarSpecSansEffCle( EF, champTest )
{
   var Accents = '‡‚‰ÁÈËÍÎÓÔÙˆ˘˚¸¬ƒ À»$";*&(@)!:?ß/<>+.~#{[|`\\_^]}=∞§£µ®\í¿¬ƒ«…» ÀŒœ‘÷Ÿ€‹¬ƒ À»'

   var Champ = "";
   var Caractere;
   for (Cpt=0; Cpt < EF.value.length; Cpt++ ) {
	Caractere = EF.value.charAt(Cpt);
	if (Accents.indexOf(Caractere,0) != -1) {
	   alert( "Vous avez saisi des caractËres non autorisÈs, veuillez les enlever\n\nListe des caractËres interdits : ‡‚‰ÁÈËÍÎÓÔÙˆ˘˚¸¬ƒ À»$\";*&(@)!:?ß/<>+.~#{[|`\\_^]}=∞§£µ®\'¿¬ƒ«…» ÀŒœ‘÷Ÿ€‹¬ƒ À»");
	   EF.focus();
	   return false;
	}
	
	else
	   Champ += Caractere;
   }
   EF.value = Champ;
   return true;
}
//Fin KRA PPM 58087


// PPM 60709 : controleCarSpec pour empecher les carac speciaux  NEWWWW
function controleCarSpec( EF, champTest )
{

   var Alphamin = 'abcdefghijklmnopqrstuvwxyz';
   var Alphamax = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ';
   var Accents = '‡‚‰ÁÈËÍÎÓÔÙˆ˘˚¸¬ƒ À»$";*&(@)!:?ß/<>+.~#{[|`\\_^]}=∞§£µ®\'¿¬ƒ«…» ÀŒœ‘÷Ÿ€‹¬ƒ À»'

   var Champ = "";
   var Caractere;
   for (Cpt=0; Cpt < EF.value.length; Cpt++ ) {
	Caractere = EF.value.charAt(Cpt);
	if (Accents.indexOf(Caractere,0) != -1) {
	 alert("le code saisi ne doit pas contenir de caractËres parmi la liste suivante ‡‚‰ÁÈËÍÎÓÔÙˆ˘˚¸¬ƒ À»$\";*&(@)!:?ß/<>+.~#{[|`\\_^]}=∞§£µ®\'¿¬ƒ«…» ÀŒœ‘÷Ÿ€‹¬ƒ À» \nVeuillez corriger");
	   EF.focus();
	   return false;
	}

else if (Alphamin.indexOf(Caractere,0) != -1) {
	   Champ += Alphamax.charAt(Alphamin.indexOf(Caractere,0));
	}
	

	else
	   Champ += Caractere;
   }
   EF.value = Champ;
   return true;
}


// FIN controleCarSpec

function VerifierAlphaMaxCarSpecContrat( EF )
{
   var Alphamin = 'abcdefghijklmnopqrstuvwxyz';
   var Alphamax = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ';
   var Accents = '‡‚‰ÁÈËÍÎÓÔÙˆ˘˚¸¬ƒ À»$"; *&(@)!:?ß/<>+.~#{[|`\\_^]}=∞§£µ®\''

   var Champ = "";
   var Caractere;
   for (Cpt=0; Cpt < EF.value.length; Cpt++ ) {
	Caractere = EF.value.charAt(Cpt);
	if (Accents.indexOf(Caractere,0) != -1) {
	   alert( "Saisie invalide");
	   EF.focus();
	   EF.value="";
	   return false;
	}
	else if (Alphamin.indexOf(Caractere,0) != -1) {
	   Champ += Alphamax.charAt(Alphamin.indexOf(Caractere,0));
	}
	else
	   Champ += Caractere;
   }
   EF.value = Champ;
   return true;
}

function VerifierAlphaMaxCarSpecScenario( EF )
{
   var Alphamin = 'abcdefghijklmnopqrstuvwxyz';
   var Alphamax = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ';
   var Accents = '‡‚‰ÁÈËÍÎÓÔÙˆ˘˚¸¬ƒ À»$"; *&(@)!:?ß/<>+-.~#{[|`\\_^]}=∞§£µ®\''

   var Champ = "";
   var Caractere;
   for (Cpt=0; Cpt < EF.value.length; Cpt++ ) {
	Caractere = EF.value.charAt(Cpt);
	if (Accents.indexOf(Caractere,0) != -1) {
	   alert( "Le code du scÈnario ne doit pas comporter d'accent ou de caractËre spÈcial");
	   EF.focus();
	   EF.value="";
	   return false;
	}
	else if (Alphamin.indexOf(Caractere,0) != -1) {
	   Champ += Alphamax.charAt(Alphamin.indexOf(Caractere,0));
	}
	else
	   Champ += Caractere;
   }
   EF.value = Champ;
   return true;
}

//YNI FDT 970 Methode pour empecher la saisie de caracteres speciaux et caracteres accentuÈ dans les dates effets
function VerifierAlphaMaxCarSpecDateEffet( EF )
{
   var Alphamin = 'abcdefghijklmnopqrstuvwxyz';
   var Alphamax = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ';
   var Accents = '‡‚‰ÁÈËÍÎÓÔÙˆ˘˚¸¬ƒ À»$"; *&(@)!:?ß/<>+.~#{[|`\\^]}=∞§£µ®\''
   				 

   var Champ = "";
   var Caractere;
   for (Cpt=0; Cpt < EF.value.length; Cpt++ ) {
	Caractere = EF.value.charAt(Cpt);
	if (Accents.indexOf(Caractere,0) != -1) {
	   alert( "Vous ne pouvez saisir que des lettres non accentuÈes, des chiffres, le tiret (-) ou le tiret bas (_) ");
	   EF.focus();
	   EF.value="";
	   return false;
	}
	else if (Alphamin.indexOf(Caractere,0) != -1) {
	   Champ += Alphamax.charAt(Alphamin.indexOf(Caractere,0));
	}
	else
	   Champ += Caractere;
   }
   EF.value = Champ;
   return true;
}

//YNI FDT 970 Methode pour empecher la saisie de caracteres speciaux et caracteres accentuÈ dans les codes localisation
function VerifierAlphaMaxCarSpecLocalisation( EF )
{
   var Alphamin = 'abcdefghijklmnopqrstuvwxyz';
   var Alphamax = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ';
   var Accents = '‡‚‰ÁÈËÍÎÓÔÙˆ˘˚¸¬ƒ À»$"; *&(@)!:?ß/<>+-.~#{[|`\\_^]}=∞§£µ®\''
   				 

   var Champ = "";
   var Caractere;
   for (Cpt=0; Cpt < EF.value.length; Cpt++ ) {
	Caractere = EF.value.charAt(Cpt);
	if (Accents.indexOf(Caractere,0) != -1) {
	   alert( "Vous ne pouvez saisir dans le Code localisation que des lettres non accentuÈes ou des chiffres");
	   EF.focus();
	   EF.value="";
	   return false;
	}
	else if (Alphamin.indexOf(Caractere,0) != -1) {
	   Champ += Alphamax.charAt(Alphamin.indexOf(Caractere,0));
	}
	else
	   Champ += Caractere;
   }
   EF.value = Champ;
   return true;
}

//YNI FDT 970 Methode pour empecher la saisie de caracteres speciaux et caracteres accentuÈ dans les codes contractuels
function VerifierAlphaMaxCarSpecModeContractuel( EF )
{
   var Alphamin = 'abcdefghijklmnopqrstuvwxyz';
   var Alphamax = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ';
   //var Accents = '‡‚‰ÁÈËÍÎÓÔÙˆ˘˚¸¬ƒ À»$"; *&(@)!:?ß/<>+-.~#{[|`\\_^]}=∞§£µ®\''

   var Accents = '‡‚‰ÁÈËÍÎÓÔÙˆ˘˚¸¿¬ƒ«…» ÀŒœ‘÷Ÿ€‹$'          
   				 

   var Champ = "";
   var Caractere;
   for (Cpt=0; Cpt < EF.value.length; Cpt++ ) {
	Caractere = EF.value.charAt(Cpt);
	if (Accents.indexOf(Caractere,0) != -1) {
	   alert( "Vous ne pouvez PAS saisir de minuscules accentuÈes dans un Code mode contractuel");
	   EF.focus();
	   EF.value="";
	   return false;
	}
	else if (Alphamin.indexOf(Caractere,0) != -1) {
	   Champ += Alphamax.charAt(Alphamin.indexOf(Caractere,0));
	}
	else
	   Champ += Caractere;
   }
   EF.value = Champ;
   return true;
}

function VerifAlphaMaxCar_profil_Lib( EF, champTest )
{
   
   var Accents = '‰ÎÔˆ¸ƒÀ$%≤"*&!?;@ß/<>~+=#{[|`\\^]}∞§£µ®\''
   var Champ = "";
   var Caractere;
   for (Cpt=0; Cpt < EF.value.length; Cpt++ ) {
	Caractere = EF.value.charAt(Cpt);
	if (Accents.indexOf(Caractere,0) != -1) {
	   alert( "Champ "+champTest+" : Èvitez les caractËres spÈciaux");
	   EF.focus();
	   return false;
	}
	
	else
	   Champ += Caractere;
   }
   EF.value = Champ;
   EF.value=EF.value.toUpperCase();
   return true;
}

function VerifAlphaMaxCar_profil_Comm( EF, champTest )
{
   var Accents = ';‰ÎÔˆ¸ƒÀ$≤"*&@ß/<>~#{[|`\\^]}∞§£µ®'
   var Champ = "";
   var Caractere;
   for (Cpt=0; Cpt < EF.value.length; Cpt++ ) {
	Caractere = EF.value.charAt(Cpt);
	if (Accents.indexOf(Caractere,0) != -1) {
	   alert( "Champ "+champTest+" : Èvitez les caractËres spÈciaux");
	   EF.focus();
	   return false;
	}
	else
	   Champ += Caractere;
   }
   EF.value = Champ;
   return true;
}

function VerifierNumMessage( EF, longueur, decimale, message )
{
 var posSeparateur = -1;
 var Chiffre = "1234567890";
 var champ   = "";
 var deb     = 0;
 var debut   = 0;

   while (EF.value.charAt(debut)=='0' && debut <= EF.value.length)  {
      debut++;
   }

   if (EF.value.length == (debut) && EF.value.charAt(0)=='0')
         deb = 0;
   else if ((EF.value.charAt(1)==',' || EF.value.charAt(1)=='.') && EF.value.charAt(0)=='0')
        deb = 0;
   else if (EF.value.charAt(0)==',' || EF.value.charAt(0)=='.') {
        deb = 0;
        champ += '0';
   }
   else
      deb = debut;

   while (deb <= EF.value.length)  {
      if (Chiffre.indexOf(EF.value.charAt(deb))== -1) {
         switch (EF.value.charAt(deb)) {
              case '.' :
              case ',' : champ += ',';
                         posSeparateur = deb;
                         if ( (deb <= (longueur-decimale+debut)) && ((EF.value.length-posSeparateur-1) <= decimale) )
                               break;
              default  : alert( message);
                         EF.focus();
                         return false;
         }
      }
      else champ += EF.value.charAt(deb);
      deb++;
   }

   if (posSeparateur==-1) {
	if (EF.value.length > (longueur-decimale+debut)) {
	   alert( message);
	   EF.focus();
	   return false;
	}
      if(decimale !=0) {
         champ += ',';
      }
      nbDecimales=0;
   }
   else if (decimale != 0) {
	nbDecimales = EF.value.length-posSeparateur-1;
   }
   else {alert( message);
	   EF.focus();
	   return false;
   }

   for (Cpt=1; Cpt <= (decimale-nbDecimales); Cpt++ ) {
      champ += '0';
   }

   EF.value=champ;
   return true;
}   
//KRA PPM 61776 : fonction de contrÙle d'un champ numÈrique contenant une Ètoile ‡ la fin (codeRess*)
function VerifierNumEtoile( EF, longueur, decimale )
{
var len = EF.value.length -1;
var ET = EF.value.charAt(len);
if (ET == '*' && EF.value.length >1 ) {
		 VerifierNumEt( EF, longueur, decimale ) 
	}
	else{
		VerifierNum( EF, longueur, decimale )
	} 
}

function VerifierNumEt( EF, longueur, decimale )
{
 var Chiffre = "1234567890";
 var champ   = "";
 var deb     = 0;

   while (deb < EF.value.length-1)  {
      if (Chiffre.indexOf(EF.value.charAt(deb))== -1 ) {	   
			alert("Nombre invalide");
            EF.focus();
            EF.value = "";
            return false;
      }
      else champ += EF.value.charAt(deb);
      deb++;
   }
	champ += EF.value.charAt(deb);
   EF.value=champ;
   return true;
}

//Fin PPM 61776

function VerifierNum( EF, longueur, decimale )
{
	 var posSeparateur = -1;
 var Chiffre = "1234567890";
 var champ   = "";
 var deb     = 0;
 var debut   = 0;

   while (EF.value.charAt(debut)=='0' && debut <= EF.value.length)  {
      debut++;
   }

   if (EF.value.length == (debut) && EF.value.charAt(0)=='0')
         deb = 0;
   else if ((EF.value.charAt(1)==',' || EF.value.charAt(1)=='.') && EF.value.charAt(0)=='0')
        deb = 0;
   else if (EF.value.charAt(0)==',' || EF.value.charAt(0)=='.') {
        deb = 0;
        champ += '0';
   }
   else
      deb = debut;

   while (deb <= EF.value.length)  {
      if (Chiffre.indexOf(EF.value.charAt(deb))== -1) {
         switch (EF.value.charAt(deb)) {
              case '.' :
              case ',' : champ += ',';
                         posSeparateur = deb;
                         if ( (deb <= (longueur-decimale+debut)) && ((EF.value.length-posSeparateur-1) <= decimale) )
                               break;
              default  : alert("Nombre invalide");
                         EF.focus();
                         EF.value = "";
                         return false;
         }
      }
      else champ += EF.value.charAt(deb);
      deb++;
   }

   if (posSeparateur==-1) {
	if (EF.value.length > (longueur-decimale+debut)) {
	   alert("Nombre invalide");
	   EF.focus();
	   EF.value = "";
	   return false;
	}
      if(decimale !=0) {
         champ += ',';
      }
      nbDecimales=0;
   }
   else if (decimale != 0) {
	nbDecimales = EF.value.length-posSeparateur-1;
   }
   else {alert("Nombre invalide");
	   EF.focus();
	   EF.value = "";
	   return false;
   }

   for (Cpt=1; Cpt <= (decimale-nbDecimales); Cpt++ ) {
      champ += '0';
   }

   EF.value=champ;
   return true;
} 


function VerifierCout( EF, longueur, decimale )
{
	 var posSeparateur = -1;
 var Chiffre = "1234567890";
 var champ   = "";
 var deb     = 0;
 var debut   = 0;

   while (EF.value.charAt(debut)=='0' && debut <= EF.value.length)  {
      debut++;
   }

   if (EF.value.length == (debut) && EF.value.charAt(0)=='0')
         deb = 0;
   else if ((EF.value.charAt(1)==',' || EF.value.charAt(1)=='.') && EF.value.charAt(0)=='0')
        deb = 0;
   else if (EF.value.charAt(0)==',' || EF.value.charAt(0)=='.') {
        deb = 0;
        champ += '0';
   }
   else
      deb = debut;

   while (deb <= EF.value.length)  {
      if (Chiffre.indexOf(EF.value.charAt(deb))== -1) {
         switch (EF.value.charAt(deb)) {
              case '.' :
              case ',' : champ += ',';
                         posSeparateur = deb;
                         if ( (deb <= (longueur-decimale+debut)) && ((EF.value.length-posSeparateur-1) <= decimale) )
                               break;
              default  : alert("Co˚t invalide");
                         EF.focus();
                         
                         return false;
         }
      }
      else champ += EF.value.charAt(deb);
      deb++;
   }

   if (posSeparateur==-1) {
	if (EF.value.length > (longueur-decimale+debut)) {
	   alert("Co˚t invalide");
	   EF.focus();
	   
	   return false;
	}
      if(decimale !=0) {
         champ += ',';
      }
      nbDecimales=0;
   }
   else if (decimale != 0) {
	nbDecimales = EF.value.length-posSeparateur-1;
   }
   else {alert("Co˚t invalide");
	   EF.focus();
	   
	   return false;
   }

   for (Cpt=1; Cpt <= (decimale-nbDecimales); Cpt++ ) {
      champ += '0';
   }

   EF.value=champ;
   return true;
}     

function VerifierNum2( EF, longueur, decimale )
{
   return (EF.value == '') ? true : VerifierNum(EF, longueur, decimale);
}

function VerifierNumNegatif( EF, longueur, decimale )
{
 var posSeparateur = -1;
 var Chiffre = "1234567890";
 var champ   = "";
 var deb     = 0;
 var debut   = 0;
 var valeur = EF.value; 
  //si le nombre est nÈgatif
 if (valeur.charAt(0)=="-") {
 	EF.value=valeur.substring(1,valeur.length);
 }

   while (EF.value.charAt(debut)=='0' && debut <= EF.value.length)  {
      debut++;
   }

   if (EF.value.length == (debut) && EF.value.charAt(0)=='0')
         deb = 0;
   else if ((EF.value.charAt(1)==',' || EF.value.charAt(1)=='.') && EF.value.charAt(0)=='0')
        deb = 0;
   else if (EF.value.charAt(0)==',' || EF.value.charAt(0)=='.') {
        deb = 0;
        champ += '0';
   }
   else
      deb = debut;

   while (deb <= EF.value.length)  {
      if (Chiffre.indexOf(EF.value.charAt(deb))== -1) {
         switch (EF.value.charAt(deb)) {
              case '.' :
              case ',' : champ += ',';
                         posSeparateur = deb;
                         if ( (deb <= (longueur-decimale+debut)) && ((EF.value.length-posSeparateur-1) <= decimale) )
                               break;
              default  : alert( "Nombre invalide");
                         EF.focus();
                         EF.value = "";
                         return false;
         }
      }
      else champ += EF.value.charAt(deb);
      deb++;
   }

   if (posSeparateur==-1) {
	if (EF.value.length > (longueur-decimale+debut)) {
	   alert( "Nombre invalide");
	   EF.focus();
	   EF.value = "";
	   return false;
	}
      if(decimale !=0) {
         champ += ',';
      }
      nbDecimales=0;
   }
   else if (decimale != 0) {
	nbDecimales = EF.value.length-posSeparateur-1;
   }
   else {alert( "Nombre invalide");
	   EF.focus();
	   EF.value = "";
	   return false;
   }

   for (Cpt=1; Cpt <= (decimale-nbDecimales); Cpt++ ) {
      champ += '0';
   }
   if (valeur.charAt(0)=="-") {
 		EF.value="-"+champ;
   }
   else
   {
   if (champ.charAt(0)!=",") {
   		
   		EF.value=champ;
   	}
   	}
   return true;
}


function nbJoursAnnee( Annee )
{
   var reste;
   this[1] = 31;
   this[2]= (Annee % 4)==0?29:28;
   this[3] = 31;
   this[4] = 30;
   this[5] = 31;
   this[6] = 30;
   this[7] = 31;
   this[8] = 31;
   this[9] = 30;
   this[10] = 31;
   this[11] = 30;
   this[12] = 31;
}


function VerifierDate( EF, formatDate )
{
   var Chiffre = "1234567890/";
   var separateur = '/';
   var nbJours;
   var Jpos = 0;
   var err = 0;
   var strJJ = "02";

   if (EF.value == '') return true;

   if (formatDate == 'aaaa') {
	aaaa = parseInt( EF.value, 10);
	if ((isNaN(aaaa) == true) || (aaaa < 1900) || (aaaa > 2100) ) {
	   alert( "AnnÈe invalide" );
	   EF.focus();
	   EF.value = "";
	   return false;
	}
	else return true;
   }

   if (EF.value.charAt(2) == separateur) {
	if (formatDate == 'jj/mm/aaaa') {
	   if (EF.value.charAt(5) != separateur) {
		alert( "Date invalide (format "+formatDate+")" );
		EF.focus();
		EF.value = "";
		return false;
	   }
	   else {
		Jpos = formatDate.indexOf('jj') + 3;
		strJJ = EF.value.substring( Jpos -3 , Jpos -1);
	   }
	}
	strMM = EF.value.substring( Jpos , Jpos + 2);
	strAA = EF.value.substring( Jpos + 3 , Jpos + 7);
   }
   else {alert( "Date invalide (format "+formatDate+")" );
	EF.focus();
	EF.value = "";
	return false;
   }

   jj = parseInt( strJJ, 10);
   mm = parseInt( strMM, 10);
   aaaa = parseInt( strAA, 10);

   if (isNaN(jj) == true) err = 1;
   else if (isNaN(mm) == true) err = 2;
   else if (isNaN(aaaa) == true) err = 3;

   if (err != 0) {
	switch(err) {
	   case 1  : alert( "Jour invalide" );  break;
	   case 2  : alert( "Mois invalide" );  break;
	   case 3  : alert( "AnnÈe invalide" ); break;
	   default : alert( "Date invalide (format "+formatDate+")" );
	}
	EF.focus();
	EF.value = "";
	return false;
   }

   if ( (mm < 1) || (mm > 12) ) {
	alert( "Mois invalide" );
	EF.focus();
	EF.value = "";
	return false;
   }
   else {
	nbJours = new nbJoursAnnee(aaaa);
	if ((jj > nbJours[mm]) || (jj < 1)) {
	   alert( "Jour invalide" );
	   EF.focus();
	   EF.value = "";
 	   return false;
	}
   }
   if ( (aaaa < 1900) || (aaaa > 2100) ) {
	alert( "AnnÈe invalide" );
	EF.focus();
	EF.value = ""; 
	return false;
   }
   return true;
}

function VerifierDateT9( EF, formatDate )
{
   var Chiffre = "1234567890/";
   var separateur = '/';
   var nbJours;
   var Jpos = 0;
   var err = 0;
   var strJJ = "02";

   if (EF.value == '') return true;

   if (formatDate == 'aaaa') {
	aaaa = parseInt( EF.value, 10);
	if ((isNaN(aaaa) == true) || (aaaa < 2006) || (aaaa > 2100) ) {
	   alert( "AnnÈe invalide" );
	   EF.focus();
	   EF.value = "";
	   return false;
	}
	else return true;
   }

   if (EF.value.charAt(2) == separateur) {
	if (formatDate == 'jj/mm/aaaa') {
	   if (EF.value.charAt(5) != separateur) {
		alert( "Date invalide (format "+formatDate+")" );
		EF.focus();
		EF.value = "";
		return false;
	   }
	   else {
		Jpos = formatDate.indexOf('jj') + 3;
		strJJ = EF.value.substring( Jpos -3 , Jpos -1);
	   }
	}
	strMM = EF.value.substring( Jpos , Jpos + 2);
	strAA = EF.value.substring( Jpos + 3 , Jpos + 7);
   }
   else {alert( "Date invalide (format "+formatDate+")" );
	EF.focus();
	EF.value = "";
	return false;
   }

   jj = parseInt( strJJ, 10);
   mm = parseInt( strMM, 10);
   aaaa = parseInt( strAA, 10);

   if (isNaN(jj) == true) err = 1;
   else if (isNaN(mm) == true) err = 2;
   else if (isNaN(aaaa) == true) err = 3;

   if (err != 0) {
	switch(err) {
	   case 1  : alert( "Jour invalide" );  break;
	   case 2  : alert( "Mois invalide" );  break;
	   case 3  : alert( "AnnÈe invalide" ); break;
	   default : alert( "Date invalide (format "+formatDate+")" );
	}
	EF.focus();
	EF.value = "";
	return false;
   }

   if ( (mm < 1) || (mm > 12) ) {
	alert( "Mois invalide" );
	EF.focus();
	EF.value = "";
	return false;
   }
   else {
	nbJours = new nbJoursAnnee(aaaa);
	if ((jj > nbJours[mm]) || (jj < 1)) {
	   alert( "Jour invalide" );
	   EF.focus();
	   EF.value = "";
 	   return false;
	}
   }
   if ( (aaaa < 2006) || (aaaa > 2100) ) {
	alert( "AnnÈe invalide" );
	EF.focus();
	EF.value = ""; 
	return false;
   }
   return true;
}

function formatHeure(date){
	if(date.length!=5){
		return false;
	}
	var heure=date.substr(0,2);
	var minute=date.substr(3,2);
	var separateur=date.substr(2,1);
	if(isNaN(heure)||isNaN(minute)){
		return false;
	}
	if(parseInt(heure)>23 || parseInt(heure)<0){
		return false;
	}
	if(parseInt(minute)>59 || parseInt(minute)<0){
		return false;
	}
	if(separateur!=":"){
		return false;
	}
	return true;
}

function VerifierDate2( EF, formatDate )
{
   if (EF.value == '') return true;

   var date = EF.value;

   if (formatDate=='aaaa') return VerifierDate(EF, 'aaaa');

   if ( date.indexOf('/') < 0 ) {
	switch(formatDate) {
	   case 'jjmmaaaa' :	EF.value = date.substr(0,2) + '/' + date.substr(2,2) + '/' + date.substr(4,4) ;
					break;

	   case 'mmaaaa' :	EF.value = date.substr(0,2) + '/' + date.substr(2,4) ;
					break;
	}
   }
   switch(formatDate) {
	case 'jjmmaaaa' :	return VerifierDate(EF, 'jj/mm/aaaa'); 	break;
	case 'mmaaaa' :	return VerifierDate(EF, 'mm/aaaa');		break;
   }
}

function VerifierDateIsac(EF)
{

 date = EF.value.split('/');
if (EF.value.length!=0) {
//Date: jjmmyyyy => jj/mm/yyyy

	if ((EF.value.length==8)&&(date[0].length==8)) {
		 return VerifierDate2( EF, 'jjmmaaaa' );
	}
	else {
//Date: j/m/yy => jj/mm/yyyy

		if ( (date[1]==undefined)||(date[2]==undefined) ) {
			alert( "Date invalide" );
			EF.focus();
			EF.value = "";
			return false;
		}
		else {
			strJJ = date[0];	
			strMM = date[1];	
			strAA = date[2];	
			
			if (strAA.length<5)
			strAA=strAA.length==3?'2'+strAA : (strAA.length==2?'20'+strAA : (strAA.length==1?'200'+strAA : strAA));
			else
				{
					alert( "AnnÈe invalide" );
					EF.focus();
					EF.value = "";
					return false;
				}
		
			jj=parseInt( strJJ, 10);
			mm = parseInt( strMM, 10);
   			aaaa = parseInt( strAA, 10);
			
		      if ((mm>12)||(mm<1))
				{
					alert("Mois invalide");
					EF.focus();
					EF.value = "";
					return false;
				}
			 else {
				nbJours = new nbJoursAnnee(aaaa);
				
				if ((jj > nbJours[mm]) || (jj < 1)) 
					{
	  				 	alert( "Jour invalide" );
	  				 	EF.focus();
	   					EF.value = "";
 	   					return false;
					}

				}
			 if ( (aaaa < 1900) || (aaaa > 2100) ) 
				{
					alert( "AnnÈe invalide" );
					EF.focus();
					EF.value = ""; 
					return false;
   				}
			
			strJJ = (strJJ.length==1 ? '0'+strJJ : strJJ);	
			strMM = (strMM.length==1 ? '0'+strMM : strMM);		
			EF.value = strJJ + '/' + strMM + '/' + strAA ;

		}   

	}
}
return EF.value;
}

function VerifierCDDPG(EF)
{
	return	VerifierRegExp(EF, '[0-9]{7}|[0-9]{5}\\*{2}|[0-9]{3}\\*{4}|\\*{7}', 'Saisie invalide - Attention le code DPG est sur 7 caractËres');
}
 
function Ctrl_dpg_generique(EF)
{
	return	VerifierRegExp(EF, '[0-9]{7}|[0-9]{6}\\*{1}|[0-9]{5}\\*{2}|[0-9]{4}\\*{3}|[0-9]{3}\\*{4}|[0-9]{2}\\*{5}|[0-9]{1}\\*{6}|\\*{7}', 'Saisie invalide - Attention le code DPG est sur 7 caractËres ( N******, ... , NNNNNN* , NNNNNNN )');
} 
 
function Replace_Double_Chiffre(obj)
{
var res="";
re = /[0-9][0-9]/; 
re1=/[0-9]/; 
EF=(eval( "document.forms[0]."+obj ));

str=EF.value;

if (str.match(re)) 
	res=str;
else {
	if (str.length==1) {
		if (str.match(re1)) {	
		//un seul chiffre	
			res="0"+str;
			
		}
		else {
		//un caractËre ‡ proscrire
			alert("Saisie invalide");	
			EF.focus();
			EF.value="";
			return false;		
		}
	}
	else if (str.length==2){
		alert("Saisie invalide");	
		EF.focus();
		EF.value="";
		return false;
	}
}
EF.focus();		
EF.value=res;

return true;
}

function ouvrirAide()
{
    if (pageAide)
    {
	    if (pageAide.substr(0,1) != "/")
	    {
	    	//alert(pageAide);
	    	pageAide = "/"+pageAide;
	   	}
	   	//alert(">" + pageAide);
		window.open(pageAide, 'Aide', 'toolbar=no, directories=no, location=no, status=no, menubar=no, resizable=yes, scrollbars=yes, width=500, height=400') ;
	}
	else
		alert("Aucune aide disponible");
	return ;
}

/******************************************************
** Fonction qui contÙle le format d'un DPG en fonction
** De la date d'historique demandÈe pour les pages 
** eHistresAd.jsp, eHisbipAd.jsp, eProdec2.jsp, eDetprjAd.jsp 
** Cette fonction n'est a conserver que durant la pÈriode
** O˘ il y a encore des historiques d'avant octobre 2003
** Ensuite remplacer cette fonction par VerifierCDDPG
** Dans les pages JSP citÈes ci-dessus.
******************************************************/
function verifDpgEtDate(dateHist, codDPG){
	if (dateHist.value == ""){
		alert("Merci de commencer par saisir un mois de traitement");
		codDPG.value = "";
		dateHist.focus();
		return false;
	}

	var mm = Number((dateHist.value).substr(0,2));
	var aaaa = Number((dateHist.value).substr(3,4));

	// Si avant 10/2003 DPG sur 6
	if (((mm < 10) && (aaaa == 2003)) || (aaaa < 2003)){
		return VerifierRegExp(codDPG, '^([0-9]{6}|[0-9]{4}\\*{2}|[0-9]{2}\\*{4}|\\*{6})$', 'Saisie invalide - Attention, avant le 10/2003, le code DPG est sur 6 caractËres');
	}
	// Si aprËs 10/2003 DPG sur 7
	else {
		return VerifierRegExp(codDPG, '^([0-9]{7}|[0-9]{5}\\*{2}|[0-9]{3}\\*{4}|\\*{7})$', 'Saisie invalide - Attention, ‡ partir du 10/2003, le code DPG est sur 7 caractËres');
	}
}

/******************************************************
** Fonction qui controle la liste des ressources (ou des pid)
** De la date d'historique demandÈe pour les pages 
** eHisresSr.jsp
******************************************************/
function verifToutIsac(dateHist, codRess){
	if (dateHist.value == ""){
		alert("Merci de saisir un mois de traitement");
		dateHist.focus();
		return false;
	}

	var mm = Number((dateHist.value).substr(0,2));
	var aaaa = Number((dateHist.value).substr(3,4));
			
	// Si avant 01/2005 pas de Tous autorisÈ
	if ((aaaa < 2005) && (codRess.value=="Toute" || codRess.value=="Tout")){
		alert ("Saisie invalide - Attention, avant le 01/2005, vous ne pouvez pas saisir Tous");
		codRess.focus();
		codRess.value ="";
		return false;
		}
		else {
		return true;
		}
	
}

/********************************************
** Fonction pour rafraÓchir une page 	   **
** en conservant les donnÈes du formulaire **
** mais sans mettre ‡ jour la base		   **
*********************************************/
function rafraichir(form){

 form.action.value="refresh";
 form.submit();
}


function Rapsyntvalidedate(EF,datencours){

        if (EF.value=="") 
		{
			alert("Vous devez saisir une date.");
			EF.value=datencours;
			EF.focus();
			return false;
		}
		
		else if(!VerifierDate2(EF,'jjmmaaaa'))
		{
		    EF.value=datencours;
		    EF.focus();
		    return false;
		
		}
		else if(EF.value.substring(6,10)!=datencours.substring(6,10))
		{		    		
		   alert("L'annÈe doit Ítre Ègale ‡ l'annÈe en cours.");
		   EF.focus();
		   return false;
		 }
		 else
	           return true;



}



function VerifierDecOLD( EF, longueur, decimale, OLDEF )
{
 var posSeparateur = -1;
 var Chiffre = "1234567890";
 var champ   = "";
 var deb     = 0;
 var debut   = 0;

   while (EF.value.charAt(debut)=='0' && debut <= EF.value.length)  {
      debut++;
   }

   if (EF.value.length == (debut) && EF.value.charAt(0)=='0')
         deb = 0;
   else if ((EF.value.charAt(1)==',' || EF.value.charAt(1)=='.') && EF.value.charAt(0)=='0')
        deb = 0;
   else if (EF.value.charAt(0)==',' || EF.value.charAt(0)=='.') {
        deb = 0;
        champ += '0';
   }
   else
      deb = debut;

   while (deb <= EF.value.length)  {
      if (Chiffre.indexOf(EF.value.charAt(deb))== -1) {
         switch (EF.value.charAt(deb)) {
              case '.' :
              case ',' : champ += ',';
                         posSeparateur = deb;
                         if ( (deb <= (longueur-decimale+debut)) && ((EF.value.length-posSeparateur-1) <= decimale) )
                               break;
              default  : alert( "Nombre invalide");
                         EF.focus();
                         EF.value = OLDEF;
                         return false;
         }
      }
      else champ += EF.value.charAt(deb);
      deb++;
   }

   if (posSeparateur==-1) {
	if (EF.value.length > (longueur-decimale+debut)) {
	   alert( "Nombre invalide");
	   EF.focus();
	   EF.value = OLDEF;
	   return false;
	}
      
      nbDecimales=0;
   }
   else if (decimale != 0) {
	nbDecimales = EF.value.length-posSeparateur-1;
   }
   else {alert( "Nombre invalide");
	   EF.focus();
	   EF.value = OLDEF;
	   return false;
   }


   EF.value=champ;
   

return true;
}   


function verifierExistanceActivite()
{
	for (j=0; j<allCodeActivite.length; j++) {
		if (document.forms[0].newCodeActivite.value == allCodeActivite[j]) {
			alert("Cette activitÈ est dÈj‡ rattachÈe ‡ la ressource.");
			return false;
		}
	}
	return true;
}

function VerifierSaisieRees(form, action, flag)
{
	bOK = 1;
	if (action=='refresh') {
		if (confirm('Tous les rÈestimÈs vont Ítre rÈinitialisÈs.\nVoulez-vous continuer ?')) bOK = 1;
		else bOK = 0;
	}
	if (action=='creer') {
		if (verifierExistanceActivite()) {
			if (document.forms[0].modifRees.value=='true') {
				if (!confirm("Le rÈestimÈ a ÈtÈ modifiÈ. Voulez-vous enregistrer ces modifications\navant d'ajouter l'activitÈ ?")) {
					document.forms[0].modifRees.value = 'false';
				}
			}
		} else {
			bOK = 0;
		}
	}

	if (bOK==1) {
		blnVerification = flag;
  		form.action.value = action;
		document.forms[0].bloquerEnvoi.value = 'false';
  	} else {
		document.forms[0].bloquerEnvoi.value = 'true';
  	}
}


function Valider_sstache_ident(form)
{
        if (form.sous_tache.selectedIndex==-1)
		{
			alert("Choisissez une sous-t‚che");
			return (false);
		}
		if ((form.sous_tache.value.length==1)&&(form.sous_tache.selectedIndex!=-1))
		{
			alert("Vous devez crÈer une sous t‚che avant d'effectuer une affectation.");
			return (false);
		}
		return true;
}	

function EntrerAnnee(EF)
{
   
   Left(EF);
   if (EF.value.length == 0) {
	alert("Entrez une annÈe de proposition de budget");
	EF.focus();
	return false;
   }
   else return true;   
      

}

function ChampScenario( EF)
{
   Left(EF);
   if (EF.value.length == 0) {
	alert("Le code scÈnario inexistant");
	return false;
   }
   else return true;
}


function ChampIdent( EF)
{
   Left(EF);
   if (EF.value.length == 0) {
	alert("La ressource inexistante");
	return false;
   }
   else return true;
}


function confirmAffectation(ident1,ident2)
{
  return confirm("Voulez-vous copier les affectations de la ressource "+ident1.value+" ‡ la ressource "+ident2.value+"?");
	
}	

function alertAffectation(ident1,ident2)
{
 if(ident1.value == ident2.value)
  {
    alert("Veuillez choisir deux ressources diffÈrentes");
    return false;
  
  } 
 return true; 
}  

function showtip(current,e,text){
	if (document.all||document.getElementById){
		thetitle=text.split("<br>");
		if (thetitle.length>1){
			thetitles='';
			   for (i=0;i<thetitle.length;i++)	
				    thetitles+=thetitle[i];
			current.title=thetitles;
		} else current.title=text;
	} else 
	if (document.layers){
			document.tooltip.document.write('<layer bgColor="white" style="border:1px solid black;font-size:12px;">'+text+'</layer>')
			document.tooltip.document.close();
			document.tooltip.left=e.pageX+5;
			document.tooltip.top=e.pageY+5;
			document.tooltip.visibility="show";
    }
}

function hidetip(){ 
    if (document.layers) 
        document.tooltip.visibility="hidden";
}


/*******************************************************************
** Fonction pour remplir une variable ‡ gauche du caractËre voulu **
** source  : chaine ‡ convertir                                   **
** caract  : caractËre ‡ remplir sur la gauche                    **
** long    : longueur maximal du texte                            **
** exemple : lpad('161612', '0', 7) retourne la chaine '0161612'  **
** exemple : lpad('DSIC', '*', 8)   retourne la chaine '****DSIC' **
*******************************************************************/
function lpad(source, caract, long) {
	dest='';
	for (i=source.length; i<long; i=i+caract.length) {
		dest=dest+caract;
	}
	dest=dest+source;
	return dest;
}

function ajouterFavoris(libFav, lienFav, typFav){
	window.open("/addFavoris.do?action=initialiser&libFav="+libFav+"&typFav="+typFav+"&lienFav="+lienFav ,"", "toolbar=no, directories=no, location=no, status=no, menubar=no, resizable=yes, scrollbars=no, width=650, height=210") ;
	return ;
} 

/*******************************************************************
** Fonction pour comparer 2 dates								  **
** EFdate1   : 1Ëre date                               			  **
** EFdate2   : 2Ëme date                               			  **
** exemple : compareDate('01/01/2005', null) retourne 9			  **
** exemple : compareDate(null, '01/01/2005') retourne 9			  **
** exemple : compareDate(null, null) retourne 9					  **
** exemple : compareDate('01/01/2005', '01/01/2005') retourne 0   **
** exemple : compareDate('31/12/2004', '01/01/2005') retourne 1   **
** exemple : compareDate('01/01/2005', '31/12/2004') retourne -1  **
*******************************************************************/
function compareDate(EFdate1, EFdate2) {
	if ( (EFdate1==null) || (EFdate2==null) ) {
		return 9;
	}
	if ( (EFdate1.value.length==0) || (EFdate2.value.length==0) ) {
		return 9;
	}
	annee1 = EFdate1.value.substring(6, 10);
	annee2 = EFdate2.value.substring(6, 10);
	mois1  = EFdate1.value.substring(3, 5);
	mois2  = EFdate2.value.substring(3, 5);
	jour1  = EFdate1.value.substring(0, 2);
	jour2  = EFdate2.value.substring(0, 2);
	
	if (EFdate1.value == EFdate2.value) return 0;
	
	if (annee1 < annee2) return 1;
	else {
		if (annee1 > annee2) return -1;
		else {
			// annee1 == annee2
			if (mois1 < mois2) return 1;
			else {
				if (mois1 > mois2) return -1;
				else {
					// mois1 == mois2
					if (jour1 < jour2) return 1;
					else {
						if (jour1 > jour2) return -1;
						else return 999;
					}
				}
			}
		}
	}
}

function VerifierMail(EF)
	{
	adresse = EF.value;
	var place = adresse.indexOf("@",1);
	var point = adresse.indexOf(".",place+1);
	if ( ((place > -1)&&(adresse.length >2)&&(point > 1)) || adresse.length==0 )
		{
		return(true);
		}
	else
		{
		alert('adresse mail incorrecte');
		return(false);
		}
	}
	
// Methode d'appel a une page en XmlHttpRequest en mode synchrone !
function ajaxCallRemotePage(url){
	if (window.XMLHttpRequest){
		// Non-IE browsers
		req = new XMLHttpRequest();
		req.onreadystatechange = processStateChange;
		req.open("GET", url, false);
		req.setRequestHeader("If-Modified-Since", "Sat, 1 Jan 2000 00:00:00 GMT");
		req.send(null);
	}
	else if (window.ActiveXObject){
		// IE
		req = new ActiveXObject("Microsoft.XMLHTTP");
		req.onreadystatechange = processStateChange;
		req.open("GET", url, false);
		req.setRequestHeader("If-Modified-Since", "Sat, 1 Jan 2000 00:00:00 GMT");
		req.send();
	}
	else {
		return; // Navigateur non compatible
	}
}

 // Methode private qui traite le retour de l'appel de "ajaxCallRemotePage"
function processStateChange(){
	if (req.readyState == 4){ 
		// Complete
		if (req.status == 200){
			// OK response
		    document.getElementById("ajaxResponse").innerHTML = req.responseText;
			} else {
		    alert("Erreur Ajax - Problem: " + req.statusText);
		    alert("Erreur Ajax - status: " + req.status);
		}
	} 
}

// Methode d'appel a une page en XmlHttpRequest en mode synchrone spÈcifique ‡ eSuiviCopiRef !
function ajaxCallRemotePageCopiRef(url){
	if (window.XMLHttpRequest){
		// Non-IE browsers
		req = new XMLHttpRequest();
		req.onreadystatechange = processStateChangeCopiRef;
		req.open("GET", url, false);
		req.setRequestHeader("If-Modified-Since", "Sat, 1 Jan 2000 00:00:00 GMT");
		req.send(null);
	}
	else if (window.ActiveXObject){
		// IE
		req = new ActiveXObject("Microsoft.XMLHTTP");
		req.onreadystatechange = processStateChangeCopiRef;
		req.open("GET", url, false);
		req.setRequestHeader("If-Modified-Since", "Sat, 1 Jan 2000 00:00:00 GMT");
		req.send();
	}
	else {
		return; // Navigateur non compatible
	}
}

 // Methode private qui traite le retour de l'appel de "ajaxCallRemotePageCopiRef"
function processStateChangeCopiRef(){
	if (req.readyState == 4){ 
		// Complete
		if (req.status == 200){
			// OK response
		    document.getElementById("ajaxResponse").innerHTML = req.responseText;
			if (req.responseText.length < 30){
			alert(req.responseText); 
			}
			} else {
		    alert("Erreur Ajax - Problem: " + req.statusText);
		    alert("Erreur Ajax - status: " + req.status);
		}
	} 
}

function limite( this_,  max_){
  var Longueur = this_.value.length;

  if ( Longueur > max_){
    this_.value = this_.value.substring( 0, max_);
    Longueur = max_;
   }
  document.getElementById('reste').innerHTML = (max_ - Longueur) +" sur 300 caractËres restant";
}

function dynamicTable(collect){
var content = "";
content=content+'<tbody>';
 for (var i = 0; i < collect.length; i++) {
      content= content+ '<tr>';
       for (var j = 0; j < collect[i].length; j++){
       content= content+ '<td>' +collect[i][j]+'</td>';
      }
        content= content+'</tr>';
        }
    content= content+'</tbody>';
        return content;
}

function loadPageIdent(id){
alert(id);
	// Appel ajax de la m√©thode de l'action 
	//QC 2008 chnages to add typproj,arctype,clicode,codsg,pzone
	ajaxCallRemotePage('/consultRess.do?action=modifier&ident='+id);
	alert("after the function");
	document.forms[0].submit();
	// Si la r√©ponse ajax est non vide :
	/* var ajaxres = document.getElementById("ajaxResponse").innerHTML;
	return ajaxres; */
	
}
