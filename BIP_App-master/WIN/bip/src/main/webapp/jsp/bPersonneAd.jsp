<%@ taglib uri="/WEB-INF/struts-bean.tld" prefix="bean" %>
<%@ taglib uri="/WEB-INF/struts-html.tld" prefix="html" %>
<%@ taglib uri="/WEB-INF/struts-logic.tld" prefix="logic" %>
<!-- #BeginEditable "imports" --> 
<%@ page language="java" import="org.owasp.esapi.ESAPI,java.sql.*,java.io.*,javax.servlet.*,javax.servlet.http.*,com.socgen.ich.ihm.*"    errorPage="../jsp/erreur.jsp"  %>
<jsp:useBean id="personneForm" scope="request" class="com.socgen.bip.form.PersonneForm" />
<html:html locale="true"> 
<!-- #EndEditable --> <!-- #BeginTemplate "/Templates/Page_bip.dwt" --> 
<head>
 

<%@ taglib uri="/WEB-INF/bip.tld" prefix="bip" %>
 <!-- #BeginEditable "doctitle" --> 
<title>Page BIP</title>
<!-- #EndEditable --> 
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<!-- #BeginEditable "fichier" --> 
<bip:VerifUser page="jsp/bPersonneAd.jsp"/> 
<script language="JavaScript" src="../js/function.cjs"></script>
<script language="JavaScript" src="../js/jquery.js"></script>
<link rel="stylesheet" href="../css/style_bip_new.css" type="text/css">
<script language="JavaScript">
$(document).ready(function() {
	$( "input[type=text]" ).focus(function() {
		$(this).css('border-color','#EFD242');
	});

	$( "input[type=text]" ).blur(function() {
		$(this).css('border-color','');
	});

});
var blnVerification = true;
<%
	String arborescence = ESAPI.encoder().encodeForJavaScript(ESAPI.encoder().canonicalize(request.getParameter("arborescence")));
String sPageAide = ESAPI.encoder().encodeForJavaScript(ESAPI.encoder().canonicalize(request.getParameter("pageAide")));
	String sSoccode = ESAPI.encoder().encodeForJavaScript(ESAPI.encoder().canonicalize(request.getParameter("soccode")));
	String Rtype = ESAPI.encoder().encodeForJavaScript(ESAPI.encoder().canonicalize(request.getParameter("rtype")));
	String ident = ESAPI.encoder().encodeForJavaScript(ESAPI.encoder().canonicalize(request.getParameter("ident")));
	String sRtype="";
	String Titre="Gestion des Agents SG";
		
    if(Rtype.equals("A"))
		   sRtype = " un agent SG ";
    else if(Rtype.equals("P")) {
		   sRtype = " une prestation ";
		   sSoccode = "";
		   Titre = "Gestion des Prestations"; 
    }
	
%>
var pageAide = "<%= sPageAide %>";
var soccode = "<%= sSoccode %>";
var rtype= "<%= Rtype %>";
var ident = "<bean:write name="personneForm"  property="ident" />";
var rafraichiEnCours = false;

function MessageInitial()
{
   var Message="<bean:write filter="false"  name="personneForm"  property="msgErreur" />";
   var Focus = "<bean:write name="personneForm"  property="focus" />";
   
   if (Message != "") {
      alert(Message);
   }
    
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
                         
}

function Verifier(form, action, mode,flag,etape)
{
   blnVerification = flag;
   form.mode.value = mode;
   form.action.value = action;
   form.etape.value = etape;
}

function ValiderEcran(form)
{  
   
   if (blnVerification) {

   	if (form.action.value=="modifier" || form.action.value=="edition" || form.action.value=="suite" ) {
	 	
		if(rtype=="A")
	 	{
		    if (!ChampObligatoire(form.ident, "l'identifiant d'un agent SG")) return false;
		}
		else
		{
	     	if (!ChampObligatoire(form.ident, "l'identifiant d'une prestation")) return false;
		}
				
		form.keyList0.value = form.ident.value;	
	}
    else {
  		form.ident.value = "";
			
	}
	
   }

   return true;
}


function rechercheID(){
  
  if(rtype=="A")
  	   window.open("/recupIdPersonneType.do?action=initialiser&rtype=<%= Rtype %>&nomChampDestinataire=ident&windowTitle=Recherche Identifiant Agent SG&habilitationPage=HabilitationLigneBip"  ,"", "toolbar=no, directories=no, location=no, status=no, menubar=no, resizable=yes, scrollbars=yes, width=450, height=450") ;
  else
	   window.open("/recupIdPersonneType.do?action=initialiser&rtype=<%= Rtype %>&nomChampDestinataire=ident&windowTitle=Recherche Identifiant Prestation&habilitationPage=HabilitationLigneBip"  ,"", "toolbar=no, directories=no, location=no, status=no, menubar=no, resizable=yes, scrollbars=yes, width=450, height=450") ;

  return ;
}   

function nextFocusLoupePersonne(){
document.forms[0].boutonModifier.focus();
}

function refresh(focus) {
document.forms[0].focus.value = focus;
 if(!rafraichiEnCours)
	      {
		     rafraichir(document.forms[0]);
		     rafraichiEnCours = true;
	       }

}
</script>
<!-- #EndEditable --> 
</head>
<body bgcolor="#FFFFFF" text="#000000" topmargin="0" leftmargin="0" onLoad="MessageInitial();" onKeyPress="if (event.keyCode == 13) Verifier(document.forms[0], 'modifier', 'update', true, '');">
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
        <tr> 
          <td>&nbsp;</td>
        </tr>
        <tr> 
          <td height="20" class="TitrePage"><div id="titre" ><!-- #BeginEditable "titre_page" --><%= Titre %><!-- #EndEditable --></div></td>
        </tr>
        <tr> 
          <td> </td>
        </tr>
        <tr> 
          <td> <!-- #BeginEditable "debut_form" --><html:form action="/personne"  onsubmit="return ValiderEcran(this);"><!-- #EndEditable --> 
            <table width="100%" border="0">
              <tr> 
                <td> 
                  <div id="content">
				  <div align="center"><!-- #BeginEditable "contenu" -->
                  <input type="hidden" name="pageAide" value="<%= sPageAide %>">
                  <html:hidden property="action"/>
                  <html:hidden property="mode"/>
				  <html:hidden property="arborescence" value="<%= arborescence %>"/>
                  <html:hidden property="focus"/> 
                  <input type="hidden" name="rtype" value="<%= Rtype %>">
                  <input type="hidden" name="soccode" value="<%= sSoccode %>">
                  <html:hidden property="etape"/>
                  
                  
                  <!-- paramètres pour la liste dynamique -->
                  
                  <html:hidden property="keyList0"/>                  

					<br>                            
   					<table border="0" cellspacing="3" cellpadding="2" class="tableBleu">
                      <tr>                      
                        <td colspan="4" class="texteGras" align="center"><b>Modifier et MAJ situation</b></td>						
                      </tr>
                      <tr><td>&nbsp;</td></tr>
                      <tr>
                      	<td width="85">&nbsp;</td> 
                        <td class="texteGras">Identifiant :</td>
                        <td >
                          <html:text property="ident" styleClass="input" size="6" maxlength="5" onchange="return VerifierNum(this,5,0); rafraichir(document.forms[0]);"/>&nbsp;&nbsp;                           
                          <a href="javascript:rechercheID();" onFocus="javascript:nextFocusLoupePersonne();"><img border=0 src="/images/p_zoom_blue.gif" alt="Rechercher Identifiant" title="Rechercher Identifiant"></a>
                        </td>
                        <td width="85">&nbsp;</td>                       
                      </tr>
                    </table>
                    
                    <br><br><br>
                    
                    <table  border="0" width=60%>
                      <tr> 
                        <td align="center" width=20%> <html:submit property="boutonModifier" value="Modifier" styleClass="input" onclick="Verifier(this.form, 'modifier', 'update', true, '');"/> 
                        </td>
                        <td align="center" width=20%> <html:submit property="boutonEdition" value="Imprimer" styleClass="input" onclick="Verifier(this.form, 'edition', '', true, '');"/> 
                        </td>
                        <td  align="center" width=20%> <html:submit property="boutonSituation" value="Situation" styleClass="input" onclick="Verifier(this.form, 'suite','suite', true, '');"/> 
                        </td>
                      </tr>
                    </table>
                    
                    <br><br><br>
                                        
                    <table class="tableBleu">
                      <tr>               
                        <td align=center height="40" class="texte"><u>OU</u></td>
                      </tr>
                                           
                      <tr> 					   
                        <td class="texteGras" align="center"><b>Cr&eacute;ation de ressources</b></td> 						
                      </tr>
                      <tr><td>&nbsp;</td></tr>
                      <tr>
                      	<td align="center" width="340"> <html:submit property="boutonCreer" value="Cr&#233er" styleClass="input" onclick="Verifier(this.form, 'suite1', 'insert' ,true, 'recherche');"/> 
					  </tr>	
					  <tr><td>&nbsp;</td></tr>
                    </table>

                    <!-- #EndEditable --></div>
                </td>
              </tr>
            </table>
            <!-- #BeginEditable "fin_form" --></html:form><!-- #EndEditable --> </div>
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

