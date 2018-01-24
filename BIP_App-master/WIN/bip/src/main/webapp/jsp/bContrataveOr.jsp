 
<%@ taglib uri="/WEB-INF/struts-bean.tld" prefix="bean" %>
<%@ taglib uri="/WEB-INF/struts-html.tld" prefix="html" %>
<%@ taglib uri="/WEB-INF/struts-logic.tld" prefix="logic" %>
<!-- #BeginEditable "imports" --> 
<%@ page language="java" import="org.owasp.esapi.ESAPI,java.sql.*,java.io.*,javax.servlet.*,javax.servlet.http.*,com.socgen.ich.ihm.*"    errorPage="../jsp/erreur.jsp"  %>
<jsp:useBean id="contratAveForm" scope="request" class="com.socgen.bip.form.ContratAveForm" />
<html:html locale="true"> <!-- #EndEditable --> <!-- #BeginTemplate "/Templates/Page_bip.dwt" --> 
<head>
 

<%@ taglib uri="/WEB-INF/bip.tld" prefix="bip" %>
 <!-- #BeginEditable "doctitle" --> 
<title>Page BIP</title>
<!-- #EndEditable --> 
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<!-- #BeginEditable "fichier" --> 
<bip:VerifUser page="jsp/bContrataveOr.jsp"/>
<%
java.util.ArrayList list1 = com.socgen.bip.commun.liste.ListeStatique.getListeStatique("test"); 
pageContext.setAttribute("choixTest", list1);
%>
<script language="JavaScript" src="../js/function.cjs"></script>
<link rel="stylesheet" href="../css/base_style.css" type="text/css">
<link rel="stylesheet" href="../css/style_bip.css" type="text/css">
<script language="JavaScript">
var blnVerification = true;
<%
	String arborescence = ESAPI.encoder().encodeForJavaScript(ESAPI.encoder().canonicalize(request.getParameter("arborescence")));
String sPageAide = ESAPI.encoder().encodeForJavaScript(ESAPI.encoder().canonicalize(request.getParameter("pageAide")));
	com.socgen.bip.user.UserBip user = (com.socgen.bip.user.UserBip)session.getAttribute("UserBip") ;
	String ssmenu = user.getSousMenus();
	// recherche sous menu ACH30
	String ach30 = "Oui";
	if (ssmenu.indexOf("ach30") == -1)
		ach30 = "Non";
	
	
	String numco= ESAPI.encoder().encodeForJavaScript(ESAPI.encoder().canonicalize(request.getParameter("numcont")));

	
%>
var pageAide = "<%= sPageAide %>";
var ssmenu = "<%= ssmenu %>";
var blnVerifFormat  = true;
var tabVerif        = new Object();
var ach30 = "<%= ach30 %>";
var numco= "<%= numco %>";
var arborescence = "<%=arborescence%>";

function MessageInitial()
{
   tabVerif["soccont"] = "VerifierAlphaMax(document.forms[0].soccont)";
   tabVerif["numcont"] = "VerifierAlphaMaxCarSpecContrat(document.forms[0].numcont)";
  tabVerif["cav"] = "VerifierAlphaMaxCarSpec(document.forms[0].cav)";
   
   var Message="<bean:write filter="false"  name="contratAveForm"  property="msgErreur" />";
   var Focus = "<bean:write name="contratAveForm"  property="focus" />";
   if (Focus != "") (eval( "document.forms[0]."+Focus )).focus();
   else if (document.forms[0].soccont){
	document.forms[0].soccont.focus();
	}



	if(document.forms[0].test[1].checked == true)
	     document.forms[0].test[1].checked = true;
	else
	      document.forms[0].test[0].checked = true;       
	 // permet de cacher le numéro d'avenant lorsque nous arrivons sur la page


	if (document.forms[0].action.value == "annuler" && (document.forms[0].cav.value.length != 0 && document.forms[0].cav.value != "00" && document.forms[0].cav.value.length != "000") )
 		document.forms[0].test[1].checked = true;
  	
   	
   	affiche_cav();
   	   	   	

   if (Message != "") {
      alert(Message);
      if (Message=="Contrat inexistant") 
		{ 
			if (!confirm("Voulez-vous voir la liste des contrats de la société ? " )) return false;
			else {
			
			
	        	chaine=	''
	        			+'<form name="editionForm" method="POST" action="/edition.do" >'	  		
						+'<input type="hidden" name="jobId" value="e_aecont">'
						+'<input type="hidden" name="p_param6" value="inutilisé">'
						+'<input type="hidden" name="arborescence" value="'+arborescence+'">'
						+'<input type="hidden" name="initial" value="/jsp/eContOr.jsp?pageAide=/jsp/aide/hvide.htm">'
						+'<input type="hidden" name="desformat" value="PDF">'
						+'<input type="hidden" name="p_param7" value="<bean:write name="contratAveForm"  property="soccont" />" > '
						+'<input type="hidden" name="listeReports" value="1">'
						+'<table border=0 cellspacing=2 cellpadding=2 width="100%">'
						+'<tr> <td>&nbsp;</td> </tr>'
	 					+'<tr><td>&nbsp;</td></tr>   '         	 
 	 					+'<tr><td>&nbsp;</td></tr>'
	 					+'<tr>  <td>&nbsp;</td></tr>  '
	 					+'<tr> <td>&nbsp;</td> </tr>'
	 					+'<tr><td>&nbsp;</td></tr>   '         	 
						+'<tr><td align=center><FONT color=#000066 face=Verdana size=2><b>Edition de la liste des contrats en cours </b></FONT></td></tr>'
						+'</table>'
						+'</form>';
				document.write(chaine);		
				document.editionForm.submit();
	        }
	    }
   }
   

   
}

function Verifier(form, action,mode, flag)
{
  blnVerification = flag;
 form.mode.value=mode;
    form.action.value=action;
   
}

function ValiderEcran(form)
{
   if (blnVerification == true) {
	if ( !VerifFormat(null) ) return false;
	if (!ChampObligatoire(form.soccont, "un code société")) return false;
	if (!ChampObligatoire(form.numcont, "un numéro de contrat")) return false;
    if (ach30 == "Non")
    {
    	if  (form.action.value=='creer')
    	{
    		if (form.numcont.value.length > 15)
    		{
    			alert("Vous êtes habilité à saisir des contrats sur 15 caractères uniquement");
				return false;
    		}
    		if (form.test[1].checked == true)
    		{	
    			if (!ChampObligatoire(form.cav, "un numéro d'avenant")) return false;
    			if (form.cav.value.length > 2)
    			{
    				alert("Vous devez saisir un numéro d'avenant sur 2 caractères maxi");
					return false;
    			}
    				if (form.cav.value == '00')
    			{     
    			    alert("Le N° d'avenant doit être différent de 00");
           			return false;
        		}
    		}
    	}
    	if ( (form.action.value=='modifier') || (form.action.value=='supprimer') ) 
    	{
    		if (form.test[1].checked == true)
    		{
    			if (!ChampObligatoire(form.cav, "un numéro d'avenant")) return false;
    			if (form.cav.value == '00')
    			{     
    			    alert("Le N° d'avenant doit être différent de 00");
           			return false;
        		}
        			if (form.cav.value == '000' )
    			{     
    				alert("Le N° d'avenant doit être différent de 000");
           			return false;
        		}
    		}
    	}
    }
    else
    {
    	if  (form.action.value=='creer')
    	{
    		if (form.numcont.value.lastIndexOf("C")!= (form.numcont.value.length)-1)
    		{
    			alert("Un numéro de contrat sur 27 caractères doit obligatoirement se terminer par le caractère C")
    			return false;
    		}
    		
    		if (form.test[1].checked == true)
    		{	
    			if (!ChampObligatoire(form.cav, "un numéro d'avenant")) return false;
    			if (form.cav.value.length < 3)
        		{
        			alert("Le N° d'avenant doit être sur 3 caractères");
           			return false;
        		}
    			if (form.cav.value == '000' )
    			{     
    				alert("Le N° d'avenant doit être différent de 000");
           			return false;
        		}
        			if (form.cav.value == '00' )
    			{     
    				alert("Le N° d'avenant doit être différent de 00");
           			return false;
        		}
        		
    		}
    	}
    	if ( (form.action.value=='modifier') || (form.action.value=='supprimer') ) 
    	{
    		if (form.test[1].checked == true)
    		{
    			if (!ChampObligatoire(form.cav, "un numéro d'avenant")) return false;
    			if (form.cav.value == '000' )
    			{     
    				alert("Le N° d'avenant doit être différent de 000");
           			return false;
        		}
        	}
    	}
    }
    
    

 
  if (  (form.test[0].checked == true) && (form.action.value=='supprimer') ) {
      alert("Attention, tous les avenants vont être supprimés !");
       }


	 if (form.action.value=='suite') {	   
	

    	form.keyList0.value = form.soccont.value;
   	 	form.keyList1.value  = form.numcont.value;
    	form.keyList2.value = form.cav.value;
  
	}
  } 
  
return true;
}

function rechercheSocieteID(){
	window.open("/recupIdSociete.do?action=initialiser&nomChampDestinataire=soccont&windowTitle=Recherche Identifiant Societe&habilitationPage=HabilitationLigneBip"  ,"", "toolbar=no, directories=no, location=no, status=no, menubar=no, resizable=yes, scrollbars=yes, width=450, height=450") ;
}  

function nextFocusLoupeSociete(){
	document.forms[0].numcont.focus();
}


function rechercheContrat(){

   var typeContrat;
   
   if (document.forms[0].soccont.value == '')  {
      alert("Veuillez saisir le code de la société");
      document.forms[0].soccont.focus();
   }
   else
   {
   
   		if(document.forms[0].test[0].checked == true)
      		typeContrat = "contrat";
   		else  
      		typeContrat = "avenant";

		window.open("/recupContrat.do?action=initialiser&soccont="+document.forms[0].soccont.value+"&typeContrat="+typeContrat+"&nomChampDestinataire=numcont&nomChampDestinataire2=cav&windowTitle=Recherche "+typeContrat+"&habilitationPage=HabilitationLigneBip"  ,"", "toolbar=no, directories=no, location=no, status=no, menubar=no, resizable=yes, scrollbars=yes, width=700, height=600") ;
	}
}  

function nextFocusCav(){
	document.forms[0].cav.focus();
}


function affiche_cav()
{
	var affichecav = document.getElementById("affichecav");
	if (document.forms[0].test[0].checked == true)
   {
 affichecav.style.display = "none";
 document.forms[0].cav.value="";
 }
   else
   {
  		affichecav.style.display = "";
   }
}

</script>
<!-- #EndEditable --> 
</head>
<body bgcolor="#FFFFFF" text="#000000" topmargin="0" leftmargin="0" onLoad="MessageInitial();">
<table width="100%" border="0" cellpadding="0" cellspacing="0">
  <tr> 
    <td> 
      <table width="100%" border="0" cellspacing="0" cellpadding="0">
        <tr> 
          <td>&nbsp;</td>
        </tr>
        <tr > 
          <td> 
            <div align="center"><!-- #BeginEditable "barre_haut" --> 
              <%ToolBar tb = new com.socgen.ich.ihm.ToolBar("bip_ihm",false,false,true,false,false,false,false,false,false,request) ;%>
              <%=tb.printHtml()%><!-- #EndEditable --></div>
          </td>
        </tr>
        <tr> 
          <td>&nbsp;</td>
        </tr>
        <tr> 
          <td background="../images/ligne.gif"></td>
        </tr>
        <tr> 
          <td height="20" class="TitrePage"><!-- #BeginEditable "titre_page" -->Contrats<!-- #EndEditable --></td>
        </tr>
        <tr> 
          <td background="../images/ligne.gif"></td>
        </tr>
          <tr> 
                        <td>&nbsp;</td>
                        <td>&nbsp;</td>
                      </tr>
        <tr> 
          <td>
            <table border=0 cellspacing=2 cellpadding=2 class="TableBleu" align="center">
          	 <tr> 
          	 <% 
          	 String habil="";
          	 if (ach30.equals("Oui")) 
          	 	habil = "27+3"	;
          	 	else
          	 		habil = "15+2";
          	 %>
          		<td>Vous êtes habilité à créer des contrats avec un format <%= habil %> caractères </td>
        	</tr>
          	</table>
          </td>
        </tr>
        <tr> 
          <td> <!-- #BeginEditable "debut_form" --><html:form action="/contratAve"  onsubmit="return ValiderEcran(this);"><!-- #EndEditable --> 
            <table width="100%" border="0">
              <tr> 
                <td> 
                  <div align="center"><!-- #BeginEditable "contenu" -->
				<input type="hidden" name="pageAide" value="<%= sPageAide %>">
				  <html:hidden property="action"/>
<html:hidden property="arborescence" value="<%= arborescence %>"/> 
                  <html:hidden property="mode"/>
                  <html:hidden property="keyList0"/>
				  <html:hidden property="keyList1"/>
				  <html:hidden property="keyList2"/>
                    <table border=0 cellspacing=2 cellpadding=2 class="TableBleu">
                    
                      <tr> 
                        <td>&nbsp;</td>
                        <td>&nbsp;</td>
                      </tr>
  
                      <tr> 
                        <td class="lib"><b>Choix contrat/avenant :</b></td>
                        <td> <logic:iterate id="element" name="choixTest"> <bean:define id="choix" name="element" property="cle"/> 
                          <html:radio property="test" value="<%=choix.toString()%>" onclick="affiche_cav();"/> 
                          <bean:write name="element" property="libelle"/> </logic:iterate>  
                        </td>
                      </tr>
                      <tr> 
                        <td class="lib"><b>Code société :</b></td>
                        <td> 
                          <html:text property="soccont" styleClass="input" size="5" maxlength="4" onchange="return VerifFormat(this.name);"/>
                          &nbsp;&nbsp;<a href="javascript:rechercheSocieteID();" onFocus="javascript:nextFocusLoupeSociete();"><img border=0 src="/images/p_zoom_blue.gif" alt="Rechercher Code Société" title="Rechercher Code Société" align="absbottom"></a>
                        </td>
                      </tr>
                      <tr> 
                        <td class="lib"><b>N° de contrat :</b></td>
                        <td>
							<html:text property="numcont" styleClass="input" size="30" maxlength="27" onchange="return VerifFormat(this.name);"/> 
							&nbsp;&nbsp;<a href="javascript:rechercheContrat();" onFocus="javascript:nextFocusCav();"><img border=0 src="/images/p_zoom_blue.gif" alt="Rechercher Contrat" title="Rechercher Contrat" align="absbottom"></a>  
                        </td>
                      </tr>
                      <tr id="affichecav"> 
                        <td class="lib">N° d'avenant :</td>
                        <td>
							<html:text property="cav" styleClass="input" size="4" maxlength="3" onchange="return VerifFormat(this.name);"/> 
                          </td>
                      </tr>
                      <tr> 
                        <td>&nbsp;</td>
                        <td>&nbsp;</td>
                      </tr>
                      <tr> 
                        <td>&nbsp;</td>
                        <td>&nbsp;</td>
                      </tr>
                    </table>
                    <table  border="0" width=63%>
                      <tr> 
                        <td align="right" width=15%> <html:submit property="boutonCreer" value="Cr&#233er" styleClass="input" onclick="Verifier(this.form, 'creer', 'insert', true);"/> 
                        </td>
                        <td align="center" width="7%">&nbsp;</td>
                        <td align="center" width=15%> <html:submit property="boutonModifier" value="Modifier" styleClass="input" onclick="Verifier(this.form, 'modifier', 'update', true);"/> 
                        </td>
                        <td align="left" width=7%></td>
                        <td align="center" width=15%> <html:submit property="boutonSupprimer" value="Supprimer" styleClass="input" onclick="Verifier(this.form, 'supprimer', 'delete',true);"/> 
                        </td>
                        <td align="left" width="7%">&nbsp;</td>
                        <td align="left" width=15%> <html:submit property="boutonLignes" value="Lignes" styleClass="input" onclick="Verifier(this.form, 'suite', 'next', true);"/> 
                        </td>
                      </tr>
                    </table>
                    <!-- #EndEditable --></div>
                </td>
              </tr>
            </table>
            <!-- #BeginEditable "fin_form" --></html:form><!-- #EndEditable --> 
          </td>
        </tr>
        <tr> 
          <td>&nbsp; </td>
        </tr>
        <tr> 
          <td> 
            <div align="center"><html:errors/><!-- #BeginEditable "barre_bas" --><!-- #EndEditable --></div>
          </td>
        </tr>
        <tr> 
          <td>&nbsp;</td>
        </tr>
      </table>
    </td>
  </tr>
</table>
</body></html:html>
<!-- #EndTemplate -->
