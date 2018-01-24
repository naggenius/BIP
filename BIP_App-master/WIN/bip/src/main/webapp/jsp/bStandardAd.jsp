 
<%@ taglib uri="/WEB-INF/struts-bean.tld" prefix="bean" %>
<%@ taglib uri="/WEB-INF/struts-html.tld" prefix="html" %>
<%@ taglib uri="/WEB-INF/struts-logic.tld" prefix="logic" %>
<!-- #BeginEditable "imports" --> 
<%@ page language="java" import="org.owasp.esapi.ESAPI,java.sql.*,java.io.*,javax.servlet.*,javax.servlet.http.*,com.socgen.ich.ihm.*"    errorPage="../jsp/erreur.jsp"  %>
<jsp:useBean id="standardForm" scope="request" class="com.socgen.bip.form.StandardForm" />
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
  java.util.ArrayList list1 = new com.socgen.bip.commun.liste.ListeDynamique().getListeDynamique("coutstandard_sg",standardForm.getHParams()); 
  java.util.ArrayList list2 = new com.socgen.bip.commun.liste.ListeDynamique().getListeDynamique("coutstandard",standardForm.getHParams()); 
  pageContext.setAttribute("choixStandard_SG", list1);
  pageContext.setAttribute("choixStandard_AUTRE", list2);
%>
<script language="JavaScript" src="../js/function.cjs"></script>
<link rel="stylesheet" href="../css/base_style.css" type="text/css">
<link rel="stylesheet" href="../css/style_bip.css" type="text/css">
<script language="JavaScript">
var blnVerification = true;
<%
	String arborescence = ESAPI.encoder().encodeForJavaScript(ESAPI.encoder().canonicalize(request.getParameter("arborescence")));
	String sPageAide = ESAPI.encoder().encodeForJavaScript(ESAPI.encoder().canonicalize(request.getParameter("pageAide")));
	String sChoix = ESAPI.encoder().encodeForJavaScript(ESAPI.encoder().canonicalize(request.getParameter("choix")));
%>
var pageAide = "<%= sPageAide %>";


function MessageInitial()
{
   var Message="<bean:write filter="false"  name="standardForm"  property="msgErreur" />";
   var Focus = "<bean:write name="standardForm"  property="focus" />";

	//alert(document.forms[0].codsg_bas.selectedIndex);

   if (Message != "") {
      alert(Message);
   }
   
   <% if (sChoix==null || sChoix.equals("SG")) {%>
   		document.forms[0].choix[0].checked=true;
   		zone_affichage.innerHTML =SG.innerHTML;
   		document.forms[0].SGValue.value = SG.innerText;
   <%} else {%>
   		document.forms[0].choix[1].checked=true;
   		zone_affichage.innerHTML =AUTRE.innerHTML;
   		document.forms[0].SGValue.value = AUTRE.innerText;
   <%}%>
	
	//document.forms[0].codsg_bas.selectedIndex = 0;   
	//HPPM 33134 Gestion Liste
	Ligne0 = "<%= standardForm.getCdeDPG() %>";

	if (Ligne0 == 'null'){
		document.forms[0].codsg_bas.selectedIndex = 0;
	}
	if (document.forms[0].codsg_bas.selectedIndex < 0){
		document.forms[0].codsg_bas.selectedIndex = 0;
	}
	
	if (document.forms[0].mode.value == 'delete' ) {
		Ligne = "<%= standardForm.getCdeDPG() %>" -1 ;
		if ((Ligne < 1) || (Ligne == null)){
			document.forms[0].codsg_bas.selectedIndex = 0;
		}else{
			document.forms[0].codsg_bas.selectedIndex = Ligne;
		}
	}
	
	//alert(document.forms[0].codsg_bas.selectedIndex);
}

function Verifier(form, action, mode, flag)
{
  //HPPM 33134 Gestion Liste
  saveLigne = document.forms[0].codsg_bas.selectedIndex;
  document.forms[0].cdeDPG.value = saveLigne;
  blnVerification = flag;
  form.action.value = action;
  form.mode.value=mode;
}
function ValiderEcran(form)
{
 /*var index = form.codsg_bas.selectedIndex;

	if  ((index==-1)&&((form.action.value=='modifier') || (form.action.value=='supprimer')))  {
	   alert("Choisissez une tranche de code DPG");
	   return false;
	}*/
	
	//contrôler
   	/*if (form.boutonControler.value=='Contrôler') {
   		form.mode.value='controler';
    }
	if (form.choix.value=="SG") {
		form.codsg_bas.value = form.codsg_bas_sg.value;
		}
	else {
		form.codsg_bas.value = form.codsg_bas_autre.value;
	}*/
	if (form.mode.value == 'delete') {
	 	if (!confirm("Voulez-vous vraiment supprimer les coûts standards pour cette plage de DPG ?")) return false;
	 	//form.mode.value="delete";
	 }
	

return true;
}
function chargerListe(choix) {
	

	if (choix=="SG") {

		zone_affichage.innerHTML =SG.innerHTML;
		document.forms[0].SGValue.value = SG.innerText;
		
	}
	else {

		zone_affichage.innerHTML =AUTRE.innerHTML;
		document.forms[0].SGValue.value = AUTRE.innerText;
	
	}
	document.forms[0].codsg_bas.selectedIndex = 0;
}


</script>
<!-- #EndEditable --> 
</head>
<body bgcolor="#FFFFFF" text="#000000" topmargin="0" leftmargin="0" onLoad="MessageInitial();" style="overflow-y: hidden;">
<table width="100%" border="1" cellpadding="0" cellspacing="0">
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
          <td height="20" class="TitrePage"><!-- #BeginEditable "titre_page" -->Mise à jour des coûts standards<!-- #EndEditable --></td>
        </tr>
        <tr> 
          <td background="../images/ligne.gif"></td>
        </tr>
        <tr> 
          <td> </td>
        </tr>
        <tr> 
          <td> <!-- #BeginEditable "debut_form" --><html:form action="/standard"  onsubmit="return ValiderEcran(this);" ><!-- #EndEditable --> 
            <table width="100%" border="0">
              <tr> 
                <td> 
                  <div align="center"><!-- #BeginEditable "contenu" -->
<input type="hidden" name="pageAide" value="<%= sPageAide %>">
                  <html:hidden property="action"/>
                  <html:hidden property="mode"/>
<html:hidden property="arborescence" value="<%= arborescence %>"/>
          		  <html:hidden property="cdeDPG"/>
		          <html:hidden property="keyList0"/>
		          <html:hidden property="SGValue"/>
                    <table cellspacing="2" cellpadding="2" class="tableBleu" border=0 >
                      <tr > 
                        <td align=center colspan="2"><b>Année : <bean:write name="standardForm"  property="couann" /></b> 
                    		<html:hidden property="couann"/> 
                          </td>
                      </tr>
                      <tr> 
                        <td align=center>  
                          <input type=radio name="choix" value="SG" onClick="chargerListe('SG');">SG
                        </td>
                    
                        <td align=center>
							<input type=radio name="choix" value="AUTRE"  onClick="chargerListe('AUTRE');"> Autre
                        </td>
                      </tr>
                      <tr> 
                        <td class="lib"align="center"><b>DPG Bas </b></td>
                        <td class="lib"align="center"><b>DPG Haut </b></td>
                      </tr>
                      <tr> 
                        <TD ALIGN="center" colspan=4 >
                        <div id="zone_affichage"></div>
                         
                         
                        </TD>
                      </TR>
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
				 <html:submit property="boutonControler" value="Contrôler" styleClass="input" onclick="Verifier(this.form, 'valider', 'controler',true);"/>
                </td>
              </tr>
			  </table> <!-- #EndEditable --></div>
                </td>
              </tr>
            </table> 
            <!-- #BeginEditable "fin_form" --></html:form><html:form action="/standard" >
						  <script language="JavaScript">
						  
						  </script>
						  <div id="SG" style="position:relative;top:0;left:0;visibility:hidden">
						  <html:select property="codsg_bas" styleClass="input" size="30" STYLE="width:135" value='<%= standardForm.getCodsg_bas() %>'> 
   						  <html:options collection="choixStandard_SG" property="cle" labelProperty="libelle" /> 
						  </html:select>
						  </div>
						   <div id="AUTRE" style="position:relative;top:0;left:0;visibility:hidden">
						   <html:select property="codsg_bas" styleClass="input" size="30" STYLE="width:135" value='<%= standardForm.getCodsg_bas() %>'> 
   						  <html:options collection="choixStandard_AUTRE" property="cle" labelProperty="libelle" /> 
						  </html:select>
                         </div>
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
