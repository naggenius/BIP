/* 	
	weboscope.js
	Weboscope version 5.0 copyright Weborama 22-03-2005
	Version : Boîte Noire V2
	Fonctionnalités :
		- groupe
		- contenu
		- alphanum
*/

/* ------------------ Variables ------------------------- */
var NB_MAX_CONTENU_ = 20;
var NB_CONTENUS_ = 0;
var TAILLE_MAX_CONTENU_ = 100;
var WEBO_CONTENU = new String();
var TAILLE_MAX_ALPHANUM_ = 30;
var WEBO_ALPHANUM = new String();
var WEBO_ID_GROUPE = 105;
var _DEBUG_ = 0;

/* ------------------ Générales ------------------------- */

function _traite_chaine (chaine,taille_max) {
	var contenu = new String();
	var _chaine_ = new String(chaine);
/*	var re = new RegExp("[^a-z0-9\-.,;:_ %]*", "gi");
	contenu = _chaine_.replace(re,'');*/
	return encodeURIComponent(_chaine_.substr(0,taille_max));
}

function get_webo_arg_zpi(_WEBOID,_ACC,_WEBOID2)
{
        var wbs_da=new Date();
        wbs_da=parseInt(wbs_da.getTime()/1000 - 60*wbs_da.getTimezoneOffset());
	var wbs_ref=''+escape(document.referrer);
	var wbs_ta='0x0';
	var wbs_co=0;
	var wbs_nav=navigator.appName;
	if (parseInt(navigator.appVersion)>=4)
	{
		wbs_ta=screen.width+"x"+screen.height;
		wbs_co=(wbs_nav!="Netscape")?screen.colorDepth:screen.pixelDepth;
	}
	if((_ACC != null)&&(wbs_nav!="Netscape"))
	{
		var reftmp = 'parent.document.referrer';
		if((_ACC<5)&&(_ACC>0))
		{
			for(_k=_ACC;_k>1;_k--) reftmp = 'parent.' + reftmp;
		}
		var mon_ref = eval(reftmp);
		
		if(document.referrer == parent.location || document.referrer=='') wbs_ref=''+escape(mon_ref)

	}
	var wbs_arg = "/fcgi-bin/comptage_bn2.fcgi?ID="+_WEBOID;
	if ( location.protocol == 'https:'){
	 	wbs_arg = "https://collecte.statistiques.si.socgen" + wbs_arg;
	}
	else {
		wbs_arg =  "http://collecte.statistiques.si.socgen" + wbs_arg; 
	}
	
	if (_WEBOID2 != null) wbs_arg+="&ID2="+_WEBOID2;

	if(WEBO_ALPHANUM.length) wbs_arg+=WEBO_ALPHANUM;
	if(WEBO_CONTENU.length) wbs_arg+="&CONTENU="+WEBO_CONTENU;
	
	wbs_arg+="&ver=2&da2="+wbs_da+"&ta="+wbs_ta+"&co="+wbs_co+"&ref="+wbs_ref;
	return wbs_arg;
}

function webo_affiche (wbs_arg)
{
	if (_DEBUG_) {
		document.write('\n<br><b>WEBOSCOPE : </b><i>'+wbs_arg+'</i><br>\n');
		return false;
	}
	if (parseInt(navigator.appVersion)>=3)
	{
		var webo_compteur_bn2 = new Image(1,1);
		webo_compteur_bn2.src=wbs_arg;
	}
	else
	{
		document.write('<IMG SRC="'+wbs_arg+'" border="0" height="1" width="1" alt="">');
	}
	return true;
}

function ajout_webo_contenu (chaine)
{
	if (chaine == null) return 0;
	NB_CONTENUS_++;

	if ( NB_CONTENUS_ > NB_MAX_CONTENU_ ) return 0;
	if ( NB_CONTENUS_ > 1 ) WEBO_CONTENU = WEBO_CONTENU.concat('%7C');
	chaine = chaine.replace('|',' ');
	WEBO_CONTENU = WEBO_CONTENU.concat(_traite_chaine(chaine,TAILLE_MAX_CONTENU_));
	return 1;
}

function webo_bn2(_WEBO_RUBRIQUE,_WEBO_SOUS_RUBRIQUE,_WEBOID,_ACC)
{
	_WEBO_RUBRIQUE =_traite_chaine(_WEBO_RUBRIQUE,TAILLE_MAX_ALPHANUM_)
	_WEBO_SOUS_RUBRIQUE =_traite_chaine(_WEBO_SOUS_RUBRIQUE,TAILLE_MAX_ALPHANUM_)
	WEBO_ALPHANUM = "&RUBRIQUE="+_WEBO_RUBRIQUE+"&SOUS_RUBRIQUE="+_WEBO_SOUS_RUBRIQUE;
	for(a=4;a<arguments.length;a++){
		ajout_webo_contenu(arguments[a]);
	}
	var mes_wbs_arg = get_webo_arg_zpi (_WEBOID,_ACC);
	webo_affiche (mes_wbs_arg);
}

function webo_bn2_groupe(_WEBO_RUBRIQUE,_WEBO_SOUS_RUBRIQUE,_WEBOID,_WEBO_RUBRIQUE_GROUPE,_WEBO_SOUS_RUBRIQUE_GROUPE,_ACC)
{
	_WEBO_RUBRIQUE =_traite_chaine(_WEBO_RUBRIQUE,TAILLE_MAX_ALPHANUM_)
	_WEBO_SOUS_RUBRIQUE =_traite_chaine(_WEBO_SOUS_RUBRIQUE,TAILLE_MAX_ALPHANUM_)
	_WEBO_RUBRIQUE_GROUPE =_traite_chaine(_WEBO_RUBRIQUE_GROUPE,TAILLE_MAX_ALPHANUM_)
	_WEBO_SOUS_RUBRIQUE_GROUPE =_traite_chaine(_WEBO_SOUS_RUBRIQUE_GROUPE,TAILLE_MAX_ALPHANUM_)
	WEBO_ALPHANUM = "&RUBRIQUE="+_WEBO_RUBRIQUE+"&SOUS_RUBRIQUE="+_WEBO_SOUS_RUBRIQUE;
	WEBO_ALPHANUM += "&RUBRIQUE2="+_WEBO_RUBRIQUE_GROUPE+"&SOUS_RUBRIQUE2="+_WEBO_SOUS_RUBRIQUE_GROUPE;

	var mes_wbs_arg;
	for(a=6;a<arguments.length;a++){
		ajout_webo_contenu(arguments[a]);
	}
	if (	(_WEBO_RUBRIQUE_GROUPE != null) && (_WEBO_SOUS_RUBRIQUE_GROUPE != null) )
	{
		mes_wbs_arg = get_webo_arg_zpi(_WEBOID,_ACC,WEBO_ID_GROUPE);
	}
	else {
		mes_wbs_arg = get_webo_arg_zpi(_WEBOID,_ACC);
	}
	webo_affiche (mes_wbs_arg);
}

webo_ok	= 1;
