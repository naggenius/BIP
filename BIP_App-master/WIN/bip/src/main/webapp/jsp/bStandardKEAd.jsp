 
<%@ taglib uri="/WEB-INF/struts-bean.tld" prefix="bean" %>
<%@ taglib uri="/WEB-INF/struts-html.tld" prefix="html" %>
<%@ taglib uri="/WEB-INF/struts-logic.tld" prefix="logic" %>
<!-- #BeginEditable "imports" --> 
<%@ page language="java" import="org.owasp.esapi.ESAPI,java.sql.*,java.io.*,javax.servlet.*,javax.servlet.http.*,com.socgen.ich.ihm.*"    errorPage="../jsp/erreur.jsp"  %>
<jsp:useBean id="standardKEForm" scope="request" class="com.socgen.bip.form.StandardKEForm" />
<html:html locale="true">
<!-- #EndEditable --> <!-- #BeginTemplate "/Templates/Page_bip.dwt" --> 
<head>
 

<%@ taglib uri="/WEB-INF/bip.tld" prefix="bip" %>
 <!-- #BeginEditable "doctitle" --> 
<title>Page BIP</title>
<!-- #EndEditable --> 
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<!-- #BeginEditable "fichier" --> 
<bip:VerifUser page="jsp/fStandardAd.jsp"/> 
<%
  java.util.ArrayList list = new com.socgen.bip.commun.liste.ListeDynamique().getListeDynamique("coutstandard_ke",standardKEForm.getHParams()); 
  pageContext.setAttribute("LISTE_KE", list);
%>
<script language="JavaScript" src="../js/function.cjs"></script>
<link rel="stylesheet" href="../css/base_style.css" type="text/css">
<link rel="stylesheet" href="../css/style_bip.css" type="text/css">
<script language="JavaScript">
var blnVerification = true;
<%
	String arborescence = ESAPI.encoder().encodeForJavaScript(ESAPI.encoder().canonicalize(request.getParameter("arborescence")));
String sPageAide = ESAPI.encoder().encodeForJavaScript(ESAPI.encoder().canonicalize(request.getParameter("pageAide")));
	//String sChoix = ESAPI.encoder().encodeForJavaScript(ESAPI.encoder().canonicalize(request.getParameter("choix");
%>
var pageAide = "<%= sPageAide %>";


function MessageInitial()
{
   var Message="<bean:write filter="false"  name="standardKEForm"  property="msgErreur" />";
   var Focus = "<bean:write name="standardKEForm"  property="focus" />";

   
   if (Message != "") {
      alert(Message);
   }
   

   		 //document.forms[0].choix[1].checked=true; 
   		 //zone_affichage.innerHTML =AUTRE.innerHTML;
   document.forms[0].SGValue.value =  document.forms[0].codsg_bas.innerText;
    document.forms[0].codsg_bas.selectedIndex = 0;
   
    
  
}

function Verifier(form, action, mode, flag)
{
  blnVerification = flag;
  form.action.value = action;
  form.mode.value=mode;
}
function ValiderEcran(form)
{
   var index = form.codsg_bas.selectedIndex;

	if  ((index==-1)&&((form.action.value=='modifier') || (form.action.value=='supprimer')))  {
	   alert("Choisissez une tranche de code DPG");
	   return false;
	}
	
	//contrôler
   	if (form.mode =='controler') {
   		form.mode.value='controler';
    }
	
	if (form.mode.value == 'delete') {
	 	if (!confirm("Voulez-vous vraiment supprimer les coûts standards en KE pour cette plage de DPG ?")) return false;
	 	form.mode.value="delete";
	}
	

return true;
}
//function chargerListe(choix) {
	 
	//	zone_affichage.innerHTML =AUTRE.innerHTML;
	 
	//document.forms[0].codsg_bas.selectedIndex = 0;
//}


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
          <td height="20" class="TitrePage"><!-- #BeginEditable "titre_page" -->Gestion des coûts moyens complets<!-- #EndEditable --></td>
        </tr>
        <tr> 
          <td background="../images/ligne.gif"></td>
        </tr>
        <tr> 
          <td> </td>
        </tr>
        <tr> 
          <td> <!-- #BeginEditable "debut_form" --><html:form action="/standardKE"  onsubmit="return ValiderEcran(this);" ><!-- #EndEditable --> 
            <table width="100%" border="0">
              <tr> 
                <td> 
                  <div align="center"><!-- #BeginEditable "contenu" -->
<input type="hidden" name="pageAide" value="<%= sPageAide %>">
                  <html:hidden property="action"/>
                  <html:hidden property="mode"/>
<html:hidden property="arborescence" value="<%= arborescence %>"/>
		          
		          <html:hidden property="keyList0"/>
		          <html:hidden property="SGValue"/>
                    <table cellspacing="2" cellpadding="2" class="tableBleu" >
                       <tr> 
                        <td colspan=2>&nbsp; </td>    
                      </tr>
                       <tr> 
                        <td colspan=2>&nbsp; </td> 
                      </tr>
                      <tr > 
                        <td align=center colspan="2"><b>Année : <bean:write name="standardKEForm"  property="couann" /></b> 
                    		<html:hidden property="couann"/> 
                          </td>
                      </tr>
                       <tr> 
                        <td colspan=2>&nbsp; </td>
                        
                      <tr> 
                        <td class="lib"align="center"><b>DPG Bas </b></td>
                        <td class="lib"align="center"><b>DPG Haut </b></td>
                       
                      </tr>
                      <tr> 
                        <TD ALIGN="center" colspan=4 >                        											  					   
							   <html:select property="codsg_bas" styleClass="input" size="8" > 
	   						   		<html:options collection="LISTE_KE" property="cle" labelProperty="libelle"/> 
							   </html:select>	
                        </TD>
                      </TR>
                      <tr> 
                        <td colspan=2>&nbsp; </td>
                        
                      </tr>
                       <tr> 
                        <td colspan=2>&nbsp; </td>
                        
                      </tr>

                    </table> 
					
					
					<table  border="0" width=99%>
              <tr> 
                <td align="right" width=15%> 
                 <html:submit property="boutonCreer" value="Cr&#233er" styleClass="input" onclick="Verifier(this.form, 'creer',null, true);"/>
                </td>
                <td align="center" width="6%">&nbsp;</td>
                <td align="center" width=15%> 
               <html:submit property="boutonModifier" value="Modifier" styleClass="input" onclick="Verifier(this.form, 'modifier',null, true);"/>          
                </td>
                <td align="left" width=6%></td>
                <td align="center" width=15%>
              <html:submit property="boutonSupprimer" value="Supprimer" styleClass="input" onclick="Verifier(this.form, 'valider', 'delete',true);"/>
                </td>
                <td align="left" width="6%">&nbsp;</td>
                <td align="center" width=15%> 
                <html:submit property="boutonAnnuler" value="Annuler" styleClass="input" onclick="Verifier(this.form, 'annuler',null, true);"/>
                </td>
				<td align="left"  width=6%></td>
				<td align="left" width=15%>
				 <html:submit property="boutonControler" value="controler" styleClass="input" onclick="Verifier(this.form, 'valider', 'controler',true);"/>
                </td>
              </tr>
			  </table> <!-- #EndEditable --></div>
                </td>
              </tr>
            </table> 
          									                       
            </html:form>
            <!-- #EndEditable --> 
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
