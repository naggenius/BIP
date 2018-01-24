<%@ taglib uri="/WEB-INF/struts-bean.tld" prefix="bean" %>
<%@ taglib uri="/WEB-INF/struts-html.tld" prefix="html" %>
<%@ taglib uri="/WEB-INF/struts-logic.tld" prefix="logic" %>

<%@ page language="java" import="org.owasp.esapi.ESAPI,java.util.*,java.sql.*,java.io.*,javax.servlet.*,javax.servlet.http.*,com.socgen.ich.ihm.*"    errorPage="../jsp/erreur.jsp"  %>
<jsp:useBean id="budgMassForm" scope="request" class="com.socgen.bip.form.BudgMassForm" />
<jsp:useBean id="listeDynamique" scope="request" class="com.socgen.bip.commun.liste.ListeDynamique" />
<html:html locale="true"> 

<head>


<%@ taglib uri="/WEB-INF/bip.tld" prefix="bip" %>

<title>Page BIP</title>

<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">

<bip:VerifUser page="jsp/fBudgMassMEAd.jsp"/> 
<script language="JavaScript" src="../js/function.cjs"></script>
<!-- <link rel="stylesheet" href="../css/base_style.css" type="text/css">  -->
<!-- <link rel="stylesheet" href="../css/style_bip.css" type="text/css"> -->
<link rel="stylesheet" href="../css/style_bip_new.css" type="text/css"> 
<script language="JavaScript">
var blnVerification = true;
<%
	String arborescence = ESAPI.encoder().encodeForJavaScript(ESAPI.encoder().canonicalize(request.getParameter("arborescence")));
	String sPageAide = ESAPI.encoder().encodeForJavaScript(ESAPI.encoder().canonicalize(request.getParameter("pageAide")));
	String dpg_defau = ((com.socgen.bip.user.UserBip)session.getAttribute("UserBip")).getDpg_Defaut();
	
	Hashtable hKeyList= new Hashtable();
	
//	if(dpg_defau.equals("0000000"))
//		   dpg_defau="";
		   
//	else if(dpg_defau.substring(3,7).equals("0000"))  
//		        dpg_defau = dpg_defau.substring(0,3)+"****";
//		        
//	else if(dpg_defau.substring(5,7).equals("00"))  
//		        dpg_defau = dpg_defau.substring(0,5)+"**";        
			
//	hKeyList.put("codsg", ""+dpg_defau);

	
	/* si on a dans l'url le paramtre CODSG c'est qu'on vient de recharger la page suite à un changement de DPG */	
	/* if ( (ESAPI.encoder().encodeForJavaScript(ESAPI.encoder().canonicalize(request.getParameter("codsg") != null) && (ESAPI.encoder().encodeForJavaScript(ESAPI.encoder().canonicalize(request.getParameter("chgDPG").equals("true")) ) {*/
	 if ( request.getParameter("codsg") != null && !request.getParameter("codsg").equals("")) {
	
		budgMassForm.setCodsg(request.getParameter("codsg"));
		session.setAttribute("POSITIONCLIENT", "-1");
		session.setAttribute("POSITIONAPPLI", "-1");
	} 
	 //else if ((session.getAttribute("CODSG")!=null) && (!session.getAttribute("CODSG").equals(""))) {
	//	try {
	//		budgMassForm.setCodsg((String) session.getAttribute("CODSG"));
	//	} catch (Exception e) {}
	//}
  
	
	if(budgMassForm.getCodsg() != null)	{
		dpg_defau = budgMassForm.getCodsg();
	} 
				
	if(dpg_defau.equals("0000000"))
	   dpg_defau="";
	   
	else if(dpg_defau.substring(3,7).equals("0000"))  
	        dpg_defau = dpg_defau.substring(0,3)+"****";
	        
	else if(dpg_defau.substring(5,7).equals("00"))  
	        dpg_defau = dpg_defau.substring(0,5)+"**";        
	
	
	hKeyList.put("codsg", ""+dpg_defau);
		
	hKeyList.put("userid", ""+((com.socgen.bip.user.UserBip)session.getAttribute("UserBip")).getInfosUser());
	
	try {	
	    ArrayList listeClient = listeDynamique.getListeDynamique("clientBudMass", hKeyList);
	    if(listeClient==null){
	    	pageContext.setAttribute("choixClient", new ArrayList());
	    }else
	    	pageContext.setAttribute("choixClient", listeClient);
	    
	    ArrayList listeAppli = listeDynamique.getListeDynamique("appliBudMass", hKeyList);
	    if(listeAppli==null){
	    	pageContext.setAttribute("choixAppli", new ArrayList());
	    }else
	    	pageContext.setAttribute("choixAppli", listeAppli);
	    
	    if(listeClient==null || listeAppli==null){
	    	%>alert("<%= listeDynamique.getErrorBaseMsg()%>");<%
	    }
	    
    } catch (Exception e) {
    	
	    pageContext.setAttribute("choixClient", new ArrayList());
	    pageContext.setAttribute("choixAppli", new ArrayList());
    	%>alert("<%= listeDynamique.getErrorBaseMsg()%>");<%
    }
 
%>
var pageAide = "<%= sPageAide %>";

var blnVerifFormat  = true;
var tabVerif = new Object();
var anneeCourante = '<bip:value champ="to_char(datdebex, 'YYYY')" table="datdebex" clause1="1" clause2="1" />';
var anneePlusUn = parseInt(anneeCourante) + 1;
var moisCourant = '<bip:value champ="to_number(to_char(sysdate, 'MM'))" table="dual" clause1="1" clause2="1" />';

function MessageInitial()
{
    var posCli ="<%=session.getAttribute("POSITIONCLIENT")%>";
    var posApp ="<%=session.getAttribute("POSITIONAPPLI")%>";

    tabVerif["codsg"]	= "VerifierRegExp(document.forms[0].codsg,'[0-9]{7}|[0-9]{6}\\*{1}|[0-9]{5}\\*{2}|[0-9]{4}\\*{3}|[0-9]{3}\\*{4}|[0-9]{2}\\*{5}|[0-9]{1}\\*{6}|\\*{7}','Code DPG invalide')";
    var Message="<bean:write filter="false"  name="budgMassForm"  property="msgErreur" />";
    var Focus = "<bean:write name="budgMassForm"  property="focus" />";
    if (Message != "") {
    	alert(Message);
	} else {
		var p_codsg = "<bean:write name="budgMassForm"  property="codsg" />";
		if ((p_codsg == "") && (document.forms[0].codsg.value == "") ) {
			//document.forms[0].codsg.value = "<bean:write name="UserBip" property="dpg_Defaut" />";
			document.forms[0].codsg.value = "<%= dpg_defau %>";
		}
		
	}

	if (document.forms[0].clicode.length-1>=parseInt(posCli))
		document.forms[0].clicode.selectedIndex=parseInt(posCli);
	else
		document.forms[0].clicode.selectedIndex=-1;

	if (document.forms[0].airt.length-1>=parseInt(posApp))
		document.forms[0].airt.selectedIndex=parseInt(posApp);
	else
		document.forms[0].airt.selectedIndex=-1;

    if (moisCourant >= 7) {
         document.forms[0].annee.value = anneePlusUn;
   }
   else
   {
   document.forms[0].annee.value = anneeCourante;
   }

	document.forms[0].old_codsg.value = document.forms[0].codsg.value;
}

function VerifPropose(form, action,flag) {
	
	form.action.value = action;
	form.codsg.value = document.forms[0].codsg.value;
	form.blocksize.value = document.forms[0].blocksize.value;
		
	MajOrdreTri(form);
	
	
}

function VerifReestime(form, action,flag) {
	form.action.value = action;
	form.codsg.value = document.forms[0].codsg.value;
	form.blocksize.value = document.forms[0].blocksize.value;
		
	MajOrdreTri(form);
	
}

function ValiderEcran(form) {
	if (form.annee) {
		if (!EntrerAnnee(form.annee)) return false;
	}
	if (!ChampObligatoire(document.forms[0].codsg, "un code Departement/Pole/Groupe")) return false;

	form.clicode.value = document.forms[0].clicode.value;
	form.airt.value    = document.forms[0].airt.value;
	
	
	form.posClient.value = document.forms[0].clicode.selectedIndex;
	form.posAppli.value  = document.forms[0].airt.selectedIndex;
	
	form.blocksize.value    = document.forms[0].blocksize.value;
	MajOrdreTri(form);
	if(document.forms[0].codsg.value=="0000000"){
		   document.forms[0].codsg.value="";
		   }

	else if(document.forms[0].codsg.value.substring(3,7)=="0000")  {
	        document.forms[0].codsg.value = document.forms[0].codsg.value.substring(0,3)+"****";
	        }
  
	else if(document.forms[0].codsg.value.substring(5,7)=="00")  {
	        document.forms[0].codsg.value = document.forms[0].codsg.value.substring(0,5)+"**";     
	        }

   	return true;
}


function MajOrdreTri(form)
{
	form.ordre_tri.value = "1";
	if (document.forms[0].ordre_tri[0].checked)
	{
	form.ordre_tri.value = "1";
	}
	if (document.forms[0].ordre_tri[1].checked)
	{
	form.ordre_tri.value = "2";
	}
	if (document.forms[0].ordre_tri[2].checked)
	{
	form.ordre_tri.value = "3";
	}
	if (document.forms[0].ordre_tri[3].checked)
	{
	form.ordre_tri.value = "4";
	}
	if (document.forms[0].ordre_tri[4].checked)
	{
	form.ordre_tri.value = "5";
	}
}

function ChangeDpg(codsg)
{


    //if(VerifFormat(codsg.name)) {
    if(Ctrl_dpg_generique(document.forms[0].codsg.value)) {
		document.forms[0].action.value = "refresh";

    	// on contruit l'url à envoyer en faisant attention de bien supprimer le paramtre CODSG si jamais
    	// on avait déjà modifié le DPG
    	var paramCodsg = "codsg=";
    	var posCodsg = location.href.indexOf(paramCodsg);
    	var urlReload = location.href;
    	if (posCodsg>-1) {
	    	urlReload = location.href.substring(0,posCodsg-1);
	    }
    	var posInterro = urlReload.indexOf('?');
    	if (posInterro>-1) {
    		urlReload = urlReload+"&";
    	} else {  
    		urlReload = urlReload+"?";
    	}
	    urlReload = urlReload+"codsg="+document.forms[0].codsg.value+"&chgDPG=true&action=annuler";
	    // on utilise location.replace à la place d'un document.forms[0].submit car comme on utilise un frame
	    // sans menu dans l'écran suivant, le filtre était rechargé dans un écran sans menu
	    location.replace(urlReload);
	    return true;
	} else { 
		document.forms[0].codsg.value = document.forms[0].old_codsg.value;
	    return false;
	}
    
}




</script>
</head>
<body bgcolor="#FFFFFF" text="#000000" topmargin="0" leftmargin="0" onLoad="MessageInitial();">
<div id="mainContainer">
<div id="topContainer">
<div id="entete"></div>
<div id="logo">
		<div id="logo_sg"><img src="../images/logo_SG.gif" width="162" height="33" border="0" /></div>
		<div id="nomdusite"><img src="../images/bip_logo.png" width="78" height="46" border="0" /></div>
</div>
<table width="100%" border="0" cellpadding="0" cellspacing="0">
  <tr> 
    <td> 
      <table width="100%" border="0" cellspacing="0" cellpadding="0">
        <tr > 
          <td> 
            <div id="outils" align="center"><!-- #BeginEditable "barre_haut" -->
              <%ToolBarNew tb = new com.socgen.ich.ihm.ToolBarNew("bip_ihm",false,false,true,true,false,false,false,false,false,request) ;%>
				<%=tb.printHtml()%><!-- #EndEditable -->
			</div>
          </td>
        </tr>
       
<!--         <tr>  -->
<!--           <td background="../images/ligne.gif"></td> -->
<!--         </tr> -->
        <tr> 
          <td height="20" class="TitrePage">Saisie en masse des Propos&eacute;s et r&eacute;estim&eacute;s</td>
        </tr>
<!--         <tr>  -->
<!--           <td background="../images/ligne.gif"></td> -->
<!--         </tr> -->
        <tr> 
          <td> <html:form action="/propoMassME" onsubmit="return ValiderEcran(this);">
            <div align="center">
			<input type="hidden" name="pageAide" value="<%= sPageAide %>">
            <input type="hidden" name="action" value="refresh">
            
<html:hidden property="arborescence" value="<%= arborescence %>"/>
			<input type="hidden" name="old_codsg" value=""> 
            <html:hidden property="posClient"/> <!--position du client dans la liste-->
            <html:hidden property="posAppli"/> <!--position de l'application dans la liste-->
              <table border=0  cellpadding=2 cellspacing=2 class="tableBleu">
                <tr> 
                  <td align=center >&nbsp;</td>
                  <td >&nbsp;</td>
                </tr>
                <tr> 
                  <td >&nbsp;</td>
                  <td>&nbsp;</td>
                </tr>
                <tr> 
                 <td align="left" class="texte" ><b>Code D&eacute;partement/P&ocirc;le/Groupe : </b></td>
                  <td align="left">
                  <html:text property="codsg" styleClass="input" size="7" maxlength="7" onchange="return Ctrl_dpg_generique(this);return ChangeDpg(this);"/>
				  </td>
                </tr>
                <tr> 
                  <td align="left" class="texte"><b>Ann&eacute;e de proposition :</b></td>
                  <td align="left" class="texte"> 
                    <html:text property="annee" styleClass="input" size="4" maxlength="4" onchange="return VerifierDate(this,'aaaa');"/>
                  Concerne uniquement le Propos&eacute; fournisseur
                  </td>
                </tr>
                <tr> 
                  <td align="left" class="texte"><b>Client :</b></td>
                  <td align="left"> 
               		<html:select property="clicode" size="1" styleClass="input">
						<html:options collection="choixClient" property="cle" labelProperty="libelle"/>
					</html:select>
                  </td>
                </tr>
                <tr> 
                  <td align="left" class="texte"><b>Application :</b></td>
                  <td align="left"> 
               		<html:select property="airt" size="1" styleClass="input">
						<html:options collection="choixAppli" property="cle" labelProperty="libelle"/>
					</html:select>
                  </td>
                </tr>
                <tr> 
                  <td align="left" class="texte"><b>Nombre de lignes par page :</b></td>
                  <td align="left"> 
               		<html:select property="blocksize" size="1" styleClass="input">
							<option value="10">10</option>
							<option value="20">20</option>
							<option value="30">30</option>
							<option value="40">40</option>
							<option value="50">50</option>
							<option value="60">60</option>
							<option value="70">70</option>
							<option value="80">80</option>
							<option value="90">90</option>
							<option value="100">100</option>
					</html:select>
			       </td>
                </tr>
                <tr>
						<td align="left" colspan=1 class="texte"><b>Ordre de tri par :</b></td>
						<td align="left" colspan=1 class="texte"><input type=radio name="ordre_tri" value="1" checked>Code du client</td>
				</tr>
				<tr>		
						<td></td>
						<td align="left" colspan=1 class="texte"><input type=radio name="ordre_tri" value="2" >Code de la ligne BIP</td>
				</tr>
                
                <tr>
                	    <td></td>
                	    <td align="left" colspan=1 class="texte"><input type=radio name="ordre_tri" value="3" >Libell&eacute; de la ligne BIP</td>
                </tr>
                
                 <tr>
                	    <td></td>
                	    <td align="left" colspan=1 class="texte"><input type=radio name="ordre_tri" value="4" >Libell&eacute; de l'application et Type de la ligne BIP</td>
                </tr>
                
                 <tr>
                	    <td></td>
                	    <td align="left" colspan=1 class="texte"><input type=radio name="ordre_tri" value="5" >Libell&eacute; de l'application et Code de la ligne BIP</td>
                </tr>
                <tr> 
                  <td align=center>&nbsp;</td>
                  <td>&nbsp;</td>
                </tr>
                <tr> 
                  <td align=center>&nbsp;</td>
                  <td>&nbsp;</td>
                </tr>
                <tr> 
                  <td align=center>&nbsp;</td>
                  <td>&nbsp;</td>
                </tr>
              </table>
              </div>
          </td>
        </tr>
        <tr> 
          <td align="center"> 
            <table width="100%" border="0">
              <tr> 
              	<td>&nbsp;</td>
                <td align="center" width="25%"> 
                	<html:submit property="boutonValider" value="Propos&eacute; Fournisseur" styleClass="input" onclick="VerifPropose(this.form, 'modifier', true);"/> 
                </td>
                </html:form>
                <html:form action="/reestMass" onsubmit="return ValiderEcran(this);">
	                <input type="hidden" name="action" value="refresh">
	                <html:hidden property="codsg"/>
		            <html:hidden property="posClient"/> <!--position du client dans la liste-->
	    	        <html:hidden property="posAppli"/> <!--position de l'application dans la liste-->
		            <html:hidden property="clicode"/> <!--position du client dans la liste-->
	    	        <html:hidden property="airt"/>
	    	        <html:hidden property="blocksize"/> <!--position de l'application dans la liste-->
	    	        <html:hidden property="ordre_tri"/> <!--position de l'application dans la liste-->
	    	        <input type="hidden" name="pageAide" value="<%= sPageAide %>">
            		<input type="hidden" name="old_codsg" value=""> 
                    <html:hidden property="posClient"/> <!--position du client dans la liste-->
                    <html:hidden property="posAppli"/> <!--position de l'application dans la liste-->
          
	    	        
	    	        
                
                <td align="center" width="25%"> 
                	<html:submit property="boutonValider" value="R&eacute;estim&eacute;" styleClass="input" onclick="VerifReestime(this.form, 'modifier', true);"/> 
                </td>
                <td>&nbsp; </td>
              </tr>
            </table>
		    </html:form>
          </td>
        </tr>
        <tr> 
          <td>&nbsp; </td>
        </tr>
        <tr> 
          <td> 
            <div align="center"><html:errors/></div>
          </td>
        </tr>
        <tr> 
          <td>&nbsp;</td>
        </tr>
      </table>
    </td>
  </tr>
</table>
</div>
	<div id="bottomContainer">
			<div>&nbsp;</div>
	</div>
</div>
</body></html:html>
