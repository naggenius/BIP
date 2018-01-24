<%@ page language="java" import="java.util.*,org.owasp.esapi.ESAPI,com.socgen.bip.commun.*" %>
<%@ page errorPage="jsp/erreur.jsp" %>
<%@ taglib uri="/WEB-INF/struts-bean.tld" prefix="bean" %>
<%@ taglib uri="/WEB-INF/struts-html.tld" prefix="html" %>
<%@ taglib uri="/WEB-INF/struts-logic.tld" prefix="logic" %>

<%@ taglib uri="/WEB-INF/bip.tld" prefix="bip" %>


<bip:VerifUser page="frameAccueil.jsp"/>
<jsp:useBean id="UserBip" type="com.socgen.bip.user.UserBip" scope="session"/>
<html:html locale="true">


<head>
 
<title>
<% java.util.ResourceBundle rb = java.util.ResourceBundle.getBundle("log"); %>
<%=rb.getString("env.titrepage")%>	
</title>

<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<meta http-equiv="Expires" content="0">

<script language="JavaScript" src="js/lib_dhtml.js"></script>
<script language="JavaScript" src="js/scroll.js"></script>
<link rel="stylesheet" href="css/style_graph.css" type="text/css">
<link rel="stylesheet" href="css/style_data.css" type="text/css">
<link rel="stylesheet" href="css/style_cap.css" type="text/css">
<link rel="stylesheet" href="css/style_bip.css" type="text/css">
<STYLE type=text/css>
.titre {color: #A51852;}
.posrelative {POSITION: relative}
#cooteneur {LEFT: 5px; OVERFLOW: hidden; WIDTH: 100%; CLIP: rect(0px 200px 200px 0px); POSITION: relative; TOP: 1px; HEIGHT:65px}
#conteneur {LEFT: 5px; OVERFLOW: hidden; WIDTH: 100%; CLIP: rect(0px 200px 200px 0px); POSITION: relative; TOP: 1px; HEIGHT:285px}
</STYLE>
 
<script language="JavaScript">
var MyBox = null;
var rtfeOK = true;

function submitForm(id){
	
	document.forms[0].menuId.value=id;
	document.forms[0].submit();
}

function BoxInit()
	{
	if (document.getElementById("conteneur")!=null)
		{
		MyBox = new Box('MyBox', 'conteneur', 1, 25, 500, 10);
		}
	}

function initLayer() {
	
	var message ="<bean:write name="UserBip"  property="message" />";
	message = message.replace(/&#39;/g,"'");
	
	if(message!="")
		{
		alert(message);
		<% UserBip.setMessage(""); %>
		}
	

<%
 BipConfigRTFE configRTFE = BipConfigRTFE.getInstance();
 if(configRTFE.getErreurRTFE()!=null && !"".equals(configRTFE.getErreurRTFE())){
%>
	alert("<%=configRTFE.getErreurRTFE()%>");
<%}else if(!UserBip.verifRTFE()){%>
	rtfeOK = false;
	window.open("/contacts.do?action=rtfe"  ,"", "toolbar=no, directories=no, location=no, status=no, menubar=no, resizable=no, scrollbars=no, width=730, height=430") ;
<%}%>

  //cocher une option par défaut pour le menu
  /*
  if (document.forms[0].menuId[0]) 
  	document.forms[0].menuId[0].checked=true;
  else
  	{ 
  	  document.forms[0].menuId.checked=true;
  	}
  */
  //Message si session applicative terminée
  redirect ="<%=ESAPI.encoder().encodeForJavaScript(ESAPI.encoder().canonicalize(request.getParameter("redirect")))%>";

  //ABN - HP PPM 57527 - DEBUT
 //if (redirect=="O")
  //alert("Vous avez été déconnecté suite à un dépassement du délai d'inactivité.");
  //ABN - HP PPM 57527 - FIN
  //Message si BIP bloquée
  bloquee ="<%=ESAPI.encoder().encodeForJavaScript(ESAPI.encoder().canonicalize(request.getParameter("bloquee")))%>"; 
  if (bloquee=="O") alert("La BIP est actuellement bloquée\nConsultez les brêves sur cette page d'accueil");

}

<% if (UserBip.getExisteAlerte()== "EXIST") { %> 

popUpPage(0.50, 0.50, "<html:rewrite page="/popupActualite.do"/>?action=modifier"); 

<% }%> 

function openContacts(){
	window.open("/contacts.do?action=initialiser"  ,"", "toolbar=no, directories=no, location=no, status=no, menubar=no, resizable=no, scrollbars=no, width=730, height=430") ;
	return ;
}

function checkRTFE(){
	if (rtfeOK == false){
		window.open("/contacts.do?action=rtfe"  ,"", "toolbar=no, directories=no, location=no, status=no, menubar=no, resizable=no, scrollbars=no, width=730, height=430") ;
		return false;
	}
	return true;
}

function popUpPage(numRelWidth, numRelHeight, strURL, strName){


var numWidth = screen.Width*numRelWidth;

var numHeight = screen.Height*numRelHeight;

var numLeft = (screen.Width - numWidth)/2;

var numTop = (screen.Height - numHeight)/2;

var strParams = "menubar=0,location=0,directories=0, status=0,"

+ "toolbar=0, resizable=1, scrollbars=1,"

+ "height=" + numHeight + ", width=" + numWidth 

+ ",left=" + numLeft + " ,top="+ numTop;

var objWnd = window.open(strURL, strName, strParams);

objWnd.focus(); 

}


</script>
<style>
#bChemin {position:absolute; left:0; top:2; width:100%; height:20 ; z-index: 0}
#bMenu   {position:absolute; left:0; top:24; width:100%; height:42 ;z-index: 0}
#bPage   {position:absolute; left:0; top:66; width:100%; height:320;z-index: 0}
#bBas   {position:absolute;  left:0; top:386; width:100%; height:25; z-index: 0}
</style>
</head>

<body bgcolor="#FFFFFF" topmargin="0" leftmargin="0" marginheight="0" marginwidth="0" onLoad="initLayer();BoxInit();">
<a name="haut"></a>
<div id="bChemin"> 
  <table width="100%" border="0" cellspacing="0" cellpadding="0">
    <tr> 
      <td class="barrecouleur" nowrap> 
        <table width="100%" border="0" cellspacing="0" cellpadding="0">
          <tr> 
            <td nowrap width="80"> <img src="images/bip_logo.jpg" border="0">
              <img src="images/blanc.gif" width="10" height="1"></td>
            <td nowrap class="titreaccueil">ACCUEIL</td>
            <td nowrap width="80" class="titreaccueil" align="right" style="padding-right:100px;"><a href="javascript:openContacts();">Contact</a></td>
          </tr>
        </table>
      </td>
    </tr>
  </table>
</div>
<div id="bMenu">
  <table width="100%" border="0" cellspacing="0" cellpadding="0">
    <tr> 
      <td> 
        <table width="100%" border="0" cellspacing="0" cellpadding="0">
          <tr> 
            <td class="barrechemin" nowrap> 
              <table width="100%" border="0" cellspacing="0" cellpadding="0">
                <tr> 
                  <td width="80"><img src="images/blanc.gif" width="80" height="1" border="0"></td>
                  <td nowrap class="titreaccueil" height="20">
                     <marquee bgcolor="#B980BF" scrolldelay="100" height="15" border="0" width="350" align="middle">
						Bienvenue sur l'application Base d'Information Projets
					 </marquee>
                  </td>
                  <td width="80" class="titreaccueil"></td>
                </tr>
              </table>
            </td>
          </tr>
        </table>
      </td>
    </tr>
    <tr> 
      <td><img src="images/blanc.gif" border="0" width="1" height="2"></td>
    </tr>
  </table>
</div>
<div id="bPage"> 
  <table border="0" cellspacing="0" cellpadding="10">
    <tr> 
      <td colspan="2" align=center> </td>
    </tr>
    <tr> 
      <td valign="top">
      	<table cellSpacing=0 cellPadding=5 border=0 >
      		<tr><td align="left">&nbsp; <img src="images/bip.jpg" width="351" height="210"></td></tr>
      		<tr><td align="left" width="800" valign="top" height="10">
					<bip:ListeMsgPerso /><br>	
					<bip:ListeActu derniereMinute="O" /><br>	
					<bip:ListeActu derniereMinute="N" />	
			</td></tr>
		</table>
	  </td>
	  <td>
		&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
	  </td>
	  <td align="left" valign="top" style="padding-top:15px;">
        <table border="0" cellspacing="0" cellpadding="0" align="left" >
          <tr>
            <td></td>
          </tr>
          <tr>
            <td align="left">
            	<html:form action="/chgmenu" styleClass="contenu">
				<html:hidden property="action" value="valider" />
				<html:hidden property="menuId" value=""/>
				<table border="0" width="300" class="tableLogin" align="left" cellspacing="0">
					<tr>
						<td class="lib" align="center"><b>Choix du menu </b></td>
					</tr>
					<tr>	
						<td>&nbsp;</td>
					</tr>
					<tr>
						<td>
  							<logic:iterate id="choix" type="com.socgen.bip.menu.item.BipItemMenu" collection="<%= UserBip.getListeMenu()%>">
  								&nbsp;
								<a href="javascript:submitForm('<bean:write name="choix" property="id" />');" onclick="if(checkRTFE())return true;else return false;"><bean:write name="choix" property="libelle" /></a>
	  							<br>
	  							<br>
  							</logic:iterate>
						</td>
					</tr>
					<!-- 
					<tr>
						<td class="tableLoginBoutons" align="center">
							<html:submit property="action" value="OK"/>&nbsp;
						</td>
					</tr>
					-->
				</table>
				</html:form>

				<table class="erreurs" border="0" align="center" cellspacing="0">
					<tr><td>
						<html:errors/>
					</td></tr>
				</table>
			</td>
          </tr>
        </table>
     </td>
	 
    </tr>
  </table>
</div>
<div id="bBas">
</div>
</body>
<% 
Integer id_webo_page = new Integer("1"); 
com.socgen.bip.commun.form.AutomateForm formWebo = null ;
%>

<script type="text/javascript">

//SEL PPM 59158

function $(obj){ return document.getElementById(obj); }

var h_conteneur = $('conteneur').offsetHeight;
var n_elt_conteneur = $('conteneur').childNodes.length;
var h_espace_entre_elt = 10;
var h_texte=0;
BoxInit();

for(var i=0;i<n_elt_conteneur;i++)
{
var element = $('conteneur').childNodes[i];
var h_element = element.offsetHeight;
h_texte=h_texte+h_element;
}	


var h_texte_reel = h_texte+((n_elt_conteneur-1)*h_espace_entre_elt);

var h_diff = h_conteneur-h_texte_reel;

if(h_diff < 0)
{
window.setTimeout("MyBox.start()",2000);
$('conteneur').onmouseover = function() {MyBox.stop();};
$('conteneur').onmouseout = function() {MyBox.start();};
}


</script>


<%@ include file="/incWebo.jsp" %>
</html:html>