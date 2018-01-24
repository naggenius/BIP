	<%@ taglib uri="/WEB-INF/struts-bean.tld" prefix="bean" %>
<%@ taglib uri="/WEB-INF/struts-html.tld" prefix="html" %>
<%@ taglib uri="/WEB-INF/struts-logic.tld" prefix="logic" %>
<!-- #BeginEditable "imports" --> 
<%@ page language="java" import="org.owasp.esapi.ESAPI,java.util.*,java.sql.*,java.io.*,javax.servlet.*,javax.servlet.http.*,com.socgen.ich.ihm.*"   errorPage="../jsp/erreur.jsp"  %>
<jsp:useBean id="editionForm" scope="request" class="com.socgen.bip.commun.form.EditionForm" />
<html:html locale="true"> 
<!-- #EndEditable --> <!-- #BeginTemplate "/Templates/Page_filtre_maj.dwt" --><head>


<%@ taglib uri="/WEB-INF/bip.tld" prefix="bip" %>



<!-- #BeginEditable "doctitle" --> 
<title>Table de répartition JH</title>
<!-- #EndEditable -->
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<!-- #BeginEditable "fichier" --> 
<bip:VerifUser page="jsp/eTableRepartJH.jsp"/> 
<script language="JavaScript" src="../js/function.cjs"></script>
<link rel="stylesheet" href="../css/base_style.css" type="text/css">
<link rel="stylesheet" href="../css/style_bip.css" type="text/css">
<script language="JavaScript">
var pageAide = "aide/hvide.htm";
var blnVerification = true;
<%	String arborescence = ESAPI.encoder().encodeForJavaScript(ESAPI.encoder().canonicalize(request.getParameter("arborescence")));
String sPageAide = ESAPI.encoder().encodeForJavaScript(ESAPI.encoder().canonicalize(request.getParameter("pageAide"))); %>
var pageAide = "<%= sPageAide %>";

var blnVerifFormat  = true;
var tabVerif		= new Object();

<%
	String sTitre;
	String sInitial;
	String sJobId="eTableRepartJH";

	Hashtable hKeyList= new Hashtable();
	hKeyList.put("userid", ""+((com.socgen.bip.user.UserBip)session.getAttribute("UserBip")).getInfosUser());
	
	com.socgen.bip.commun.liste.ListeDynamique listeDynamique = new com.socgen.bip.commun.liste.ListeDynamique();
 	try {
  		java.util.ArrayList listR = listeDynamique.getListeDynamique("table_repart", hKeyList);
  		listR.add(0, new com.socgen.bip.commun.liste.ListeOption("", ""));
  		pageContext.setAttribute("choixCodrep", listR);

	    ArrayList listeDirection = listeDynamique.getListeDynamique("dirme_peri", hKeyList);
  		listeDirection.add(0, new com.socgen.bip.commun.liste.ListeOption("", ""));
	    pageContext.setAttribute("choixDirection", listeDirection);

  		java.util.ArrayList listEtat = new java.util.ArrayList();
  		listEtat.add(new com.socgen.bip.commun.liste.ListeOption("", ""));
  		listEtat.add(new com.socgen.bip.commun.liste.ListeOption("O", "Active"));
  		listEtat.add(new com.socgen.bip.commun.liste.ListeOption("N", "Inactive"));
  		pageContext.setAttribute("choixEtat", listEtat);
 	} catch (Exception e) { 
    	%>alert("<%= listeDynamique.getErrorBaseMsg()%>");<%
 	}
%>

function MessageInitial()
{
	<%
		sTitre = com.socgen.bip.metier.Report.getTitre(sJobId);
		if (sTitre == null)	sTitre = "Pas de titre";

		sInitial=ESAPI.encoder().encodeForJavaScript(ESAPI.encoder().canonicalize(request.getQueryString()));
		if (sInitial == null) sInitial = request.getRequestURI();
		else sInitial = request.getRequestURI() + "?" + sInitial;
		sInitial = sInitial.substring(request.getContextPath().length());
	%>
	var Message="<bean:write filter="false"  name="editionForm"  property="msgErreur" />";
	var Focus = "<bean:write name="editionForm"  property="focus" />";
	
	if (Message != "") {
		alert(Message);
	}

	if (Focus != "")
		(eval( "document.editionForm."+Focus )).focus();
	else {
		document.editionForm.p_param6.focus();
	}
}

function Verifier(form, bouton, flag)
{
form.action.value=bouton;
}

function ValiderEcran(form)
{
  	if (!VerifierDate2(form.p_param8, 'mmaaaa')) return false;
	
	document.editionForm.submit.disabled = true;
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
              <%=tb.printHtml()%> <!-- #EndEditable --></div>
          </td>
        </tr>
        <tr> 
          <td>&nbsp;</td>
        </tr>
        <tr> 
          <td background="../images/ligne.gif"></td>
        </tr>
        <tr> 
          <td height="20" class="TitrePage"><!-- #BeginEditable "titre_page" -->Edition des tables de répartition JH<!-- #EndEditable --></td>
        </tr>
        <tr> 
          <td background="../images/ligne.gif"></td>
        </tr>
        <tr> 
          <td>
		  <!-- #BeginEditable "debut_form" -->
		  <html:form action="/edition" onsubmit="return ValiderEcran(this);">
		  <div align="center"><!-- #BeginEditable "contenu" -->
            <input type="hidden" name="jobId" value="<%=sJobId%>">
            <input type="hidden" name="initial" value="<%= sInitial %>">
            
<html:hidden property="arborescence" value="<%= arborescence %>"/>
<html:hidden property="action" value="refresh"/>
            <input type="hidden" name="pageAide" value="<%= sPageAide %>">

			<table border=0  cellpadding=2 cellspacing=2 class="tableBleu">
                
                <tr> 
                  <td colspan="2">&nbsp;</td>
                </tr>
                <tr> 
                  <td colspan="2">&nbsp;</td>
                </tr>
                <tr> 
                  <td class="lib">Direction : &nbsp </td>
                  <td> 
					   <html:select property="p_param6" styleClass="input" > 
                	        <html:options collection="choixDirection" property="cle" labelProperty="libelle" />
					   </html:select>
				  </td>
                </tr>
                <tr> 
                  <td class="lib">Code Table de r&eacute;partition : &nbsp </td>
                  <td> 
                  	  <html:select property="p_param7" styleClass="input" size="1" onchange=""> 
                    	<html:options collection="choixCodrep" property="cle" labelProperty="libelle" /> 
                      </html:select> 
				  </td>
                </tr>
                <tr> 
                  <td class="lib">Mois : &nbsp </td>
                  <td> 
					  <html:text property="p_param8" styleClass="input" size="9" maxlength="7"/>
				  </td>
                </tr>
                <tr> 
                  <td class="lib">Etat : &nbsp </td>
                  <td> 
                  	  <html:select property="p_param9" styleClass="input" size="1" onchange=""> 
                    	<html:options collection="choixEtat" property="cle" labelProperty="libelle" /> 
                      </html:select> 
				  </td>
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
                <td align="center"> 
                	<html:submit value="Valider" styleClass="input" onclick="Verifier(this.form, 'liste', true);"/> 
                </td>
              </tr>
            
            </table>
		
			  <!-- #BeginEditable "fin_form" -->
			  </html:form>
			  <!-- #EndEditable -->
			  
          </td>
        </tr>
		<tr> 
          <td>&nbsp;  
          </td>
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
</html:html> 

<!-- #EndTemplate -->