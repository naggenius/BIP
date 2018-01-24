<%@ taglib uri="/WEB-INF/struts-bean.tld" prefix="bean" %>
<%@ taglib uri="/WEB-INF/struts-html.tld" prefix="html" %>
<%@ taglib uri="/WEB-INF/struts-logic.tld" prefix="logic" %>
<!-- #BeginEditable "imports" --> 
<%@ page language="java" import="org.owasp.esapi.ESAPI,java.util.*,java.sql.*,java.io.*,javax.servlet.*,javax.servlet.http.*,com.socgen.ich.ihm.*"   errorPage="../jsp/erreur.jsp"  %>
<jsp:useBean id="extractionForm" scope="request" class="com.socgen.bip.commun.form.ExtractionForm" />
<html:html locale="true"> 
<!-- #EndEditable --> <!-- #BeginTemplate "/Templates/Page_filtre_maj.dwt" --><head>


<%@ taglib uri="/WEB-INF/bip.tld" prefix="bip" %>



<!-- #BeginEditable "doctitle" --> 
<title>Suivi Global des prestations en cours</title>
<!-- #EndEditable -->
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<!-- #BeginEditable "fichier" --> 
<bip:VerifUser page="jsp/xSuiviFactOrd.jsp"/> 
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

var anneeCourante = '<bip:value champ="to_char(datdebex, 'YYYY')" table="datdebex" clause1="1" clause2="1" />';

<%
	String sTitre;
	String sInitial;
	String sJobId=ESAPI.encoder().encodeForJavaScript(ESAPI.encoder().canonicalize(request.getParameter("jobId")));
	String filcode = ((com.socgen.bip.user.UserBip)session.getAttribute("UserBip")).getFilCode();
	
%>

function MessageInitial()
{
	<%
		sTitre = com.socgen.bip.metier.Report.getTitre(sJobId);
		if (sTitre == null)	sTitre = "Pas de titre";

		sInitial=request.getQueryString();
		if (sInitial == null) sInitial = request.getRequestURI();
		else sInitial = request.getRequestURI() + "?" + sInitial;
		sInitial = sInitial.substring(request.getContextPath().length());
	%>
	var Message="<bean:write filter="false"  name="extractionForm"  property="msgErreur" />";
	var Focus = "<bean:write name="extractionForm"  property="focus" />";
	
	
    document.extractionForm.p_param6.value = anneeCourante;
    document.extractionForm.p_param7.value = Replace_DoubleZero_by_DoubleEtoile( "<bean:write name="UserBip" property="dpg_Defaut" />" );
    //document.extractionForm.p_param8.value = <%= filcode %>;
    

	if (Message != "") {
		alert(Message);
	}

	if (Focus != "")
		(eval( "document.extractionForm."+Focus )).focus();
	else {
		document.extractionForm.p_param6.focus();
	}
}

function Verifier(form) {
	
	
}

function ValiderEcran(form) {

	b_validate = Ctrl_dpg_generique(document.extractionForm.p_param7);
	
	
	if (b_validate){
	
	    if (!ChampObligatoire(document.extractionForm.p_param6, "une année")) return false;
	    if (!ChampObligatoire(document.extractionForm.p_param7, "un code DPG")) return false;	        
	    
	    //document.extractionForm.p_param7.value = Replace_DoubleEtoile_by_DoubleZero(document.extractionForm.p_param7.value);
	    
		document.extractionForm.submit.disabled = true;
	}
	return b_validate;
}

function rechercheDPG() {
	window.open("/recupDPG.do?action=initialiser&nomChampDestinataire=p_param7&windowTitle=Recherche Code DPG Fournisseur&habilitationPage=HabilitationLigneBip"  ,"", "toolbar=no, directories=no, location=no, status=no, menubar=no, resizable=yes, scrollbars=yes, width=450, height=450") ;
}

function nextFocusDPG() {
	document.forms[0].p_param7.focus();
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
          <td height="20" class="TitrePage"><%=sTitre%></td>
        </tr>
        <tr> 
          <td background="../images/ligne.gif"></td>
        </tr>
        <tr> 
          <td>
		  <!-- #BeginEditable "debut_form" -->
		  <html:form action="/extract" onsubmit="return ValiderEcran(this);">
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
                  <td class="lib"><b>Ann&eacute;e :</b></td>
                  <td> 
                    <html:text property="p_param6" styleClass="input" size="4" maxlength="4" onchange="return VerifierDate(this,'aaaa');"/>
      
                  </td>
                </tr>
                
                <tr> 
                  <td class="lib"><b>Code DPG : &nbsp </b></td>
                  <td> 
					<html:text property="p_param7" styleClass="input"  size="7" maxlength="7" />
					&nbsp;&nbsp;<a href="javascript:rechercheDPG();" onFocus="javascript:nextFocusDPG();"><img border=0 src="/images/p_zoom_blue.gif" alt="Rechercher Code DPG" title="Rechercher Code DPG" align="absbottom"></a>
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
                	<html:submit value="Valider" styleClass="input" onclick="Verifier(this.form);"/> 
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