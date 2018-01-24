<%@ taglib uri="/WEB-INF/struts-bean.tld" prefix="bean" %>
<%@ taglib uri="/WEB-INF/struts-html.tld" prefix="html" %>
<%@ taglib uri="/WEB-INF/struts-logic.tld" prefix="logic" %>
<!-- #BeginEditable "imports" --> 
<%@ page language="java" import="org.owasp.esapi.ESAPI,java.sql.*,java.io.*,javax.servlet.*,javax.servlet.http.*,com.socgen.ich.ihm.*"    errorPage="../jsp/erreur.jsp"  %>
<jsp:useBean id="notificationForm" scope="request" class="com.socgen.bip.form.NotificationForm" />
<html:html locale="true"> <!-- #EndEditable --> <!-- #BeginTemplate "/Templates/Page_maj.dwt" --> 
<head>
 

<%@ taglib uri="/WEB-INF/bip.tld" prefix="bip" %>
 <!-- #BeginEditable "doctitle" --> 
<title>Page BIP</title>
<!-- #EndEditable --> 
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<!-- #BeginEditable "fichier" --> 
<bip:VerifUser page="jsp/fNotificationAd.jsp"/>
<%
 com.socgen.bip.commun.liste.ListeDynamique listeDynamique = new com.socgen.bip.commun.liste.ListeDynamique();
 try
 {
  java.util.ArrayList list1 = listeDynamique.getListeDynamique("dprojet_notif",notificationForm.getHParams()); 
  java.util.ArrayList list2 = listeDynamique.getListeDynamique("projet_notif",notificationForm.getHParams()); 
  java.util.ArrayList list3 = listeDynamique.getListeDynamique("metier_tous",notificationForm.getHParams()); 
  java.util.ArrayList list4 = listeDynamique.getListeDynamique("dirmo_notif",notificationForm.getHParams()); 
  java.util.ArrayList list5 = listeDynamique.getListeDynamique("dirme_notif",notificationForm.getHParams()); 
  java.util.ArrayList list6 = listeDynamique.getListeDynamique("code_mo_notif",notificationForm.getHParams()); 
  java.util.ArrayList list7 = com.socgen.bip.commun.liste.ListeStatique.getListeStatique("typeProjetNotif"); 
  
  pageContext.setAttribute("choixDprojet", list1);
  pageContext.setAttribute("choixProjet", list2);
  pageContext.setAttribute("choixMetier", list3);
  pageContext.setAttribute("choixDirmo",  list4);
  pageContext.setAttribute("choixDirme", list5);
  pageContext.setAttribute("choixCodeMo",list6);
  pageContext.setAttribute("choixTypeProjet",list7);

 }
 catch (Exception e) 
 { 
    %>alert("<%= listeDynamique.getErrorBaseMsg()%>");<%
 }
%>
<script language="JavaScript" src="../js/function.cjs"></script>
<link rel="stylesheet" href="../css/base_style.css" type="text/css">
<link rel="stylesheet" href="../css/style_bip.css" type="text/css">
<script language="JavaScript">
var blnVerification = true;
<%
	String arborescence = ESAPI.encoder().encodeForJavaScript(ESAPI.encoder().canonicalize(request.getParameter("arborescence")));
String sPageAide = ESAPI.encoder().encodeForJavaScript(ESAPI.encoder().canonicalize(request.getParameter("pageAide")));
%>
var pageAide = "<%= sPageAide %>";

var blnVerifFormat  = true;
var tabVerif = new Object();

function MessageInitial()
{
   var Message="<bean:write filter="false"  name="notificationForm"  property="msgErreur" />";
   var Focus = "<bean:write name="notificationForm"  property="focus" />";
   if (Message != "") {
      alert(Message);
   }
   if (document.forms[0].test.value=="2") {
  	document.forms[0].dirmo_entier.disabled=true;
	document.forms[0].dirmo_partie.disabled=false;
	document.forms[0].code_mo.disabled=false;
	}
	//HPPM 58337 : nombre des notifiés mises à jour
	if (document.forms[0].test.value == "1" || document.forms[0].test.value == "2"){ 
			var NombreNotifs="<bean:write filter="false"  name="notificationForm"  property="nbNotif" />";
		   var Focus = "<bean:write name="notificationForm"  property="focus" />";
		   if (NombreNotifs != "" && NombreNotifs != "-1" ) {
		      alert("Nombre de lignes ayant eu au moins leur Notifié mis à jour : " + NombreNotifs);
		   }
	}
	//Fin HPPM 58337 
}

function Verifier(form, action,mode, flag)
{
   blnVerification = flag;
   form.action.value = action;
   form.mode.value = form.test.value;
}


function desactiver (choix_client)
{
if (choix_client=="entier")
	{
	document.forms[0].dirmo_partie.selectedIndex=0;
	document.forms[0].dirmo_partie.disabled=true;
	document.forms[0].code_mo.disabled=true;
	document.forms[0].dirmo_entier.disabled=false;
	
	return true;
    }
if (choix_client=="partie")
	{
	document.forms[0].dirmo_entier.selectedIndex=0;
	document.forms[0].dirmo_entier.disabled=true;
	document.forms[0].dirmo_partie.disabled=false;
	document.forms[0].code_mo.disabled=false;
	return true;
    }
}

function ValiderEcran(form)
{ 
   if (blnVerification == true) {
   
	if ( !VerifFormat(null) ) return false;
		
	if (form.test.value == "1") {
		form.dpcode.value=form.dpcode.value;
		if (form.dpcode.selectedIndex==1) { 
			alert("Choisissez un dossier projet");
		    return false;
			}
		if (form.icpi.selectedIndex==1) { 
			alert("Choisissez un projet");
		    return false;
			}
		if (form.metier.selectedIndex==1) { 
			alert("Choisissez un métier");
		    return false;
		    }
		if (form.dirme.selectedIndex==0) { 
			alert("Choisissez une direction fournisseur");
		    return false;
		    }
		if (form.dirmo.selectedIndex==0) { 
			alert("Choisissez une direction client");
		    return false;
		    }
		if (!confirm("Voulez-vous vraiment initialiser les BUDGETS DES GRANDS PROJETS ?")) return false;
		}
	if (form.test.value == "2") {
		if (form.typeprojet.selectedIndex==1) { 
			alert("Choisissez un type de projet");
		    return false;
			}
		if (form.metier.selectedIndex==1) { 
			alert("Choisissez un metier");
		    return false;
			}
		if (form.dirme.selectedIndex==0) { 
			alert("Choisissez une direction fournisseur");
		    return false;
			}
		if ((form.dirmo_entier.selectedIndex==0) && ((form.dirmo_partie.selectedIndex==0) || (form.code_mo.selectedIndex==0))) { 
			alert("Définissez la direction client à notifier");
		    return false;
			}
			
		if (!confirm("Voulez-vous vraiment initialiser les BUDGETS HORS GRANDS PROJETS ?\nType de projet : "
				 + form.typeprojet.value)) return false;
  			}
		if (form.test.value == "3") {
			if (form.dirme.selectedIndex==0) { 
			alert("Choisissez une direction fournisseur");
		    return false;
			}
			if (!confirm("Voulez-vous vraiment initialiser les BUDGETS DES LIGNES DE TYPE 9 ?")) return false;
	
	}
	}
  
   return true;
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
          <td height="20" class="TitrePage"><!-- #BeginEditable "titre_page" -->Initialisation 
            des budgets<!-- #EndEditable --></td>
        </tr>
        <tr> 
          <td background="../images/ligne.gif"></td>
        </tr>
        <tr> 
          <td> <!-- #BeginEditable "debut_form" --> <html:form action="/notification"  onsubmit="return ValiderEcran(this);"><!-- #EndEditable --> 
            <div align="center"><!-- #BeginEditable "contenu" -->
			<input type="hidden" name="pageAide" value="<%= sPageAide %>"> 
			<html:hidden property="action"/>
			<html:hidden property="mode"/>
<html:hidden property="arborescence" value="<%= arborescence %>"/>
			<html:hidden property="test"/>
									
              <table cellspacing="2" cellpadding="2" class="tableBleu">
			    <tr> 
                  <td colspan="3">&nbsp;</td>
                </tr>
                <tr> 
                  <td colspan="3">&nbsp;</td>
                </tr>
                <tr> 
                  <td align=center colspan="3"><b> 
                    <H1><font color="purple"><A><font color="#B980BF">A T T E 
                      N T I O N</font></a></font></H1>
                    </b></td>
                </tr>
                <tr> 
                  <td align=center colspan="3"><b><font color="#B980BF">CETTE 
                    PROCEDURE EST IRREVERSIBLE</font></b></td>
                </tr>
                <tr> 
                  <td align=center colspan="3">&nbsp;</td>
                </tr>
                
                <tr>
				<logic:equal parameter="test" value="1"> 
                  <td colspan="3"><u><b>NOTIFICATION DES GRANDS PROJETS</b></u></td>
				</logic:equal>
				<logic:equal parameter="test" value="2"> 
                  <td colspan="3"><u><b>NOTIFICATION HORS GRANDS PROJETS</b></u></td>
				</logic:equal>
				<logic:equal parameter="test" value="3"> 
                  <td colspan="3"><u><b>NOTIFICATION DES LIGNES DE TYPE 9</b></u></td>
				</logic:equal>
				
				</tr>
				<tr></tr>
              </table>
              <table cellspacing="2" cellpadding="2" class="tableBleu">
              	<logic:notEqual parameter="test" value="3">
                <!-- Pour les grands projets -->
                <logic:notEqual parameter="test" value="2">
                <tr> 
                  
				  <td class=lib><b>Code dossier projet : </b></td>
                  <td>
				   <html:select property="dpcode" styleClass="input" onchange="rafraichir(document.forms[0]);">
                     		<option value="TOUS" SELECTED>Tous</option><!-- HPPM 58337-->
				 <html:options collection="choixDprojet" property="cle" labelProperty="libelle" /> 
                    </html:select> 
				   </td>
				  
				</tr>
                
				<tr>
				  
				  <td class=lib><b>Code sous projet :</b></td>
                  <td> 
				  <html:select property="icpi" styleClass="input" size="1">
                                <option value="TOUS" SELECTED>Tous</option> <!-- HPPM 58337-->
                      <html:options collection="choixProjet" property="cle" labelProperty="libelle" /> 
                    </html:select> 
				  </td>
				  
				</tr>
				
				<tr>
				  
				  <td class=lib><b>M&eacute;tier :</b></td>
                  <td> 
				  <html:select property="metier" styleClass="input" size="1">
                                <option value="TOUS" SELECTED>Tous</option><!-- HPPM 58337--> 
                      <html:options collection="choixMetier" property="cle" labelProperty="libelle" /> 
                    </html:select> 
				  </td>
				  
				</tr>
				<tr>
				  
				  <td class=lib><b>Direction du fournisseur :</b></td>
                  <td> 
				  <html:select property="dirme" styleClass="input" size="1">
                      <html:options collection="choixDirme" property="cle" labelProperty="libelle" /> 
                    </html:select> 
				  </td>
				  
				</tr>
				<tr>
				  
				  <td class=lib><b>Direction du client :</b></td>
                  <td> 
				  <html:select property="dirmo" styleClass="input" size="1"> 
                      <html:options collection="choixDirmo" property="cle" labelProperty="libelle" /> 
                    </html:select> 
				  </td>
				  
				</tr>
				</logic:notEqual>
				<!--Hors grands projets -->
				
				  <logic:equal parameter="test" value="2">
				<tr>
				  <td class=lib><b>Type de lignes : </b></td>
                  <td> 
                    <html:select property="typeprojet" size="1" styleClass="input">
			   			<html:options collection="choixTypeProjet" property="cle" labelProperty="libelle" /> 
                    </html:select> 
                  </td>
                </tr>
                <tr>
				  
				  <td class=lib><b>M&eacute;tier :</b></td>
                  <td> 
				  <html:select property="metier" styleClass="input" size="1">
						<option value="TOUS" SELECTED>Tous</option><!-- HPPM 58337--> 				  
                      <html:options collection="choixMetier" property="cle" labelProperty="libelle" /> 
                    </html:select> 
				  </td>
				<tr></tr>  
				
				<tr>
				  
				  <td class=lib><b>Direction du fournisseur :</b></td>
                  <td> 
				  <html:select property="dirme" styleClass="input" size="1">
                      <html:options collection="choixDirme" property="cle" labelProperty="libelle" /> 
                    </html:select> 
				  </td>
				  
				</tr>
				<tr><td><BR></td></tr>
				<tr><td><u><b>Client :</b></u></td></tr>
				
                <tr> 
                  <td class="lib"><b>Une partie d'une direction : </b></td>
                  <td> 
                   <input type=radio name="choix_client" value="partie" checked onClick="desactiver(this.value);">
	              </td>
                  <td> 
                   <html:select property="dirmo_partie" styleClass="input" size="1" onchange="rafraichir(document.forms[0]);"> 
                      <html:options collection="choixDirmo" property="cle" labelProperty="libelle" /> 
                    </html:select>
                  </td>
                </tr>
                <tr>
                	<td></td>
                  <td align="right" colspan="1">Code MO </td>
                  <td> 
                   <html:select property="code_mo" styleClass="input" size="1"> 
                      <html:options collection="choixCodeMo" property="cle" labelProperty="libelle" /> 
                    </html:select>
                  </td>
                  </tr>
				<tr>
                	<td class="lib"><b>Direction entière : </b></td>
                  	<td> 
                   	<input type=radio name="choix_client" value="entier"  onClick="desactiver(this.value);">
	            	</td>
		    	    <td> 
                   <html:select property="dirmo_entier" styleClass="input" size="1"> 
                      <html:options collection="choixDirmo" property="cle" labelProperty="libelle" /> 
                    </html:select>
                  </td>
            
                </tr>
				
				  </logic:equal>
				  
				</logic:notEqual>  
				
				<!-- type 9-->
				<logic:equal parameter="test" value="3">
				
				  <tr>
				  
				  <td class=lib><b>Direction du fournisseur :</b></td>
                  <td> 
				  <html:select property="dirme" styleClass="input" size="1"> 
                      <html:options collection="choixDirme" property="cle" labelProperty="libelle" /> 
                    </html:select> 
				  </td>
				  
				</tr>
                
				</logic:equal>  			
                <tr> 
                  <td colspan="2">&nbsp;</td>
                </tr>
                <tr> 
                  <td colspan="2">&nbsp;</td>
                </tr>
                <tr> 
                  <td colspan="2">&nbsp;</td>
                </tr>
                
              </table>
              <!-- #EndEditable --></div>
          </td>
        </tr>
        <tr> 
          <td align="center"> 
            <table width="100%" border="0">
              <tr> 
                <td width="25%">&nbsp;</td>
                <td width="25%"> 
                  <div align="center"> <html:submit property="boutonValider" value="Valider" styleClass="input" onclick="Verifier(this.form, 'valider', this.form.mode.value,true);"/> 
                  </div>
                </td>
                <td width="25%"> 
                  <div align="center"> <html:submit property="boutonAnnuler" value="Annuler" styleClass="input" onclick="Verifier(this.form, 'annuler', null, false);"/> 
                  </div>
                </td>
                <td width="25%">&nbsp;</td>
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
</body>
<% 
Integer id_webo_page = new Integer("1051"); 
com.socgen.bip.commun.form.AutomateForm formWebo = notificationForm ;
%>
<%@ include file="/incWebo.jsp" %>
</html:html>
<!-- #EndTemplate -->
