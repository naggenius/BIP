 
<%@ taglib uri="/WEB-INF/struts-bean.tld" prefix="bean" %>
<%@ taglib uri="/WEB-INF/struts-html.tld" prefix="html" %>
<%@ taglib uri="/WEB-INF/struts-logic.tld" prefix="logic" %>
<!-- #BeginEditable "imports" --> 
<%@ page language="java" import="org.owasp.esapi.ESAPI,java.sql.*,java.io.*,javax.servlet.*,javax.servlet.http.*,com.socgen.ich.ihm.*"    errorPage="../jsp/erreur.jsp"  %>
<jsp:useBean id="forfaitForm" scope="request" class="com.socgen.bip.form.ForfaitForm" />
<jsp:useBean id="UserBip" scope="session" class="com.socgen.bip.user.UserBip" />
<html:html locale="true"> 
<!-- #EndEditable --> <!-- #BeginTemplate "/Templates/Page_bip.dwt" --> 
<head>
 

<%@ taglib uri="/WEB-INF/bip.tld" prefix="bip" %>
 <!-- #BeginEditable "doctitle" --> 
<title>Page BIP</title>
<!-- #EndEditable --> 
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<!-- #BeginEditable "fichier" --> 
<bip:VerifUser page="jsp/bForfaitAd.jsp"/> 
<%
  java.util.ArrayList list1 = com.socgen.bip.commun.liste.ListeStatique.getListeStatique("typeForfait"); 
  pageContext.setAttribute("choixTypeForfait", list1);
%>
<script language="JavaScript" src="../js/function.cjs"></script>
<!-- <link rel="stylesheet" href="../css/base_style.css" type="text/css"> -->
<link rel="stylesheet" href="../css/style_bip_new.css" type="text/css">
<script language="JavaScript">
var blnVerification = true;
<%
	String arborescence = ESAPI.encoder().encodeForJavaScript(ESAPI.encoder().canonicalize(request.getParameter("arborescence")));
String sPageAide = ESAPI.encoder().encodeForJavaScript(ESAPI.encoder().canonicalize(request.getParameter("pageAide")));
	String ident = ESAPI.encoder().encodeForJavaScript(ESAPI.encoder().canonicalize(request.getParameter("ident")));
	
	
%>
var pageAide = "<%= sPageAide %>";


function MessageInitial()
{
   var Message="<bean:write filter="false"  name="forfaitForm"  property="msgErreur" />";
   var Focus = "<bean:write name="forfaitForm"  property="focus" />";
   var ident = "<bean:write name="forfaitForm"  property="ident" />";
   
     
   if (Message != "") {
      alert(Message);
   }
   
 
   
  if (Focus != "") (eval( "document.forms[0]."+Focus )).focus();
   else {
	  document.forms[0].rnom.focus();
   }
   document.forms[0].rnom.value="";
   //document.forms[0].typeForfait.selectedIndex=0;
               
   if(ident!="")
   {
         document.forms[0].ident.value=ident;  
         document.forms[0].ident.focus();  
   }
   else if("<%= ident %>"!="null")
   {
         document.forms[0].ident.value="<%= ident %>";  
         document.forms[0].ident.focus();  
   }
   else
         document.forms[0].ident.value="";
   
   
   if(("<%= ident %>"=="null")||("<%= ident %>"==""))
          document.forms[0].rnom.focus(); 
  
   if(("<%= ident %>"!="null")||(ident!=""))
         document.forms[0].ident.focus();  
   else
         document.forms[0].rnom.focus();           
                   
   
   document.forms[0].codsg.value= "<bean:write name="UserBip"  property="dpg_Defaut" />";
}

function Verifier(form, action, mode,flag)
{
  blnVerification = flag;
  form.action.value = action;
  form.mode.value = mode;

}
function ValiderEcran(form)
{  
   if (blnVerification) {
	
	if (form.mode.value=="insert") {
	   		form.ident.value = "";
			if (!ChampObligatoire(form.rnom, "le nom d'un forfait")) return false;
            if (!ChampObligatoire(form.codsg, "un code DPG")) return false;
   		    if (form.codsg.value==0) {
    		    alert("Le code DPG doit être différent de 0");
    		    form.codsg.focus();
    		    return false;
    		}
	}
    else {
			form.rnom.value = "";
			if (!ChampObligatoire(form.ident, "l'identifiant d'un  forfait")) return false;
			form.keyList0.value = form.ident.value;
					
	}
   }
 
   return true;
}
function rechercheDPG()
{
	window.open("/recupDPG.do?action=initialiser&nomChampDestinataire=codsg&windowTitle=Recherche Code DPG&habilitationPage=HabilitationLigneBip"  ,"", "toolbar=no, directories=no, location=no, status=no, menubar=no, resizable=yes, scrollbars=yes, width=450, height=450") ;
	return ;
}
function rechercheID(){
	window.open("/recupIdPersonneType.do?action=initialiser&rtype=F&nomChampDestinataire=ident&windowTitle=Recherche Identifiant Forfait&habilitationPage=HabilitationLigneBip"  ,"", "toolbar=no, directories=no, location=no, status=no, menubar=no, resizable=yes, scrollbars=yes, width=450, height=450") ;
	return ;
}
</script>
<!-- #EndEditable --> 
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
          <td height="20" class="TitrePage"><!-- #BeginEditable "titre_page" -->Gestion des Forfaits<!-- #EndEditable --></td>
        </tr>
        <tr> 
          <td background="../images/ligne.gif"></td>
        </tr>
        <tr> 
          <td> </td>
        </tr>
        <tr> 
          <td> <!-- #BeginEditable "debut_form" --><html:form action="/forfait"  onsubmit="return ValiderEcran(this);"><!-- #EndEditable --> 
            <table width="100%" border="0">
              <tr> 
                <td> 
                  <div align="center"><!-- #BeginEditable "contenu" -->
<input type="hidden" name="pageAide" value="<%= sPageAide %>">
                  <html:hidden property="action"/>
                  <html:hidden property="mode"/>
<html:hidden property="arborescence" value="<%= arborescence %>"/>
                  <html:hidden property="keyList0"/> 
                    <table cellspacing="2" cellpadding="2" class="tableBleu">
                      <tr> 
                        <td colspan=4>&nbsp;</td>
                      </tr>
                      <tr> 
                        <td colspan="5" align="center" class="texte"> <b>Cr&eacute;er</b></td>
                      </tr>
                      
                      <tr> 
                        <td>Nom :</td>
                        <td>
                           <html:text property="rnom" styleClass="input" size="32" maxlength="30" onchange="return VerifierAlphaMax(this);"/>  
                        </td>
						<td >&nbsp;</td>
                        <td>DPG :</td>
                        <td>
                        	<html:text property="codsg" styleClass="input" size="7" maxlength="7" onchange="return VerifierNum(this,7,0);"/>&nbsp;
                        	<a href="javascript:rechercheDPG();" ><img border=0 src="/images/p_zoom_blue.gif" alt="Rechercher Code DPG" title="Rechercher Code DPG" align="absbottom"></a>
                        </td>
                      
                      <tr> 
                        <td>&nbsp;</td>
                        <td colspan="4">&nbsp;</td>
                      </tr>
                      <tr> 
                        <td>&nbsp;</td>
                        <td colspan="4">&nbsp;</td>
                      </tr>
                      <tr> 
                        <td colspan="5" align="center"> <html:submit property="boutonCreer" value="Cr&#233er" styleClass="input" onclick="Verifier(this.form, 'creer', 'insert' ,true);"/> 
                        </td>
                      </tr>
                      <tr> 

                        <td colspan="5" align="center" height="40"><u>OU</u></td>
                      </tr>
                      <tr> 
                      
                        <td colspan="5" align="center" class="texte"><b>Modifier en-tête ou situation</b></td>
                      </tr>

                      <tr> 
                        <td>Identifiant :</td>
                        <td colspan="3"> 
                        	<html:text property="ident" styleClass="input" size="6" maxlength="5" onchange="return VerifierNum(this,5,0);"/>&nbsp;
                        	<a href="javascript:rechercheID();" ><img border=0 src="/images/p_zoom_blue.gif"  alt="Rechercher Identifiant Forfait" title="Rechercher Identifiant Forfait" align="absbottom"></a>
                        </td>
                      </tr>
                      <tr> 
                        <td>&nbsp;</td>
                        <td colspan="3">&nbsp;</td>
                      </tr>
                      <tr> 
                        <td>&nbsp;</td>
                        <td colspan="3">&nbsp;</td>
                       </tr>
                     <!-- <tr> 
                        <td>&nbsp;</td>
                        <td colspan="3">&nbsp;</td> </tr>-->
                    </table>



					<table  border="0" width=100%>
                      <tr> 
                        <td width=20%>&nbsp;</td>
                        <td align="center" width=20%> <html:submit property="boutonModifier" value="Modifier" styleClass="input" onclick="Verifier(this.form, 'modifier', 'update', true);"/> 
                        </td>
                        </td>
                        <td align="center" width=20%> <html:submit property="boutonEdition" value="Imprimer" styleClass="input" onclick="Verifier(this.form, 'edition', '', true);"/> 
                        </td>
                        <td align="center" width=20%> <html:submit property="boutonSituation" value="Situation" styleClass="input" onclick="Verifier(this.form, 'suite','suite', true);"/> 
                        </td>
                         <td width=20%>&nbsp;</td>
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
</div>
	<div id="bottomContainer">
			<div>&nbsp;</div>
	</div>
</div>
</body></html:html>
<!-- #EndTemplate -->
