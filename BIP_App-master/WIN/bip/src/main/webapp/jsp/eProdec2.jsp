
<%@ taglib uri="/WEB-INF/struts-bean.tld" prefix="bean" %>
<%@ taglib uri="/WEB-INF/struts-html.tld" prefix="html" %>
<%@ taglib uri="/WEB-INF/struts-logic.tld" prefix="logic" %>
<!-- #BeginEditable "imports" --> 
<%@ page language="java" import="org.owasp.esapi.ESAPI,java.sql.*,java.io.*,javax.servlet.*,javax.servlet.http.*,com.socgen.ich.ihm.*"    errorPage="../jsp/erreur.jsp"  %>
<jsp:useBean id="editionForm" scope="request" class="com.socgen.bip.commun.form.EditionForm" />
<html:html locale="true">
<!-- #EndEditable --> 

<!-- #BeginTemplate "/Templates/Page_edition.dwt" --><head>


<%@ taglib uri="/WEB-INF/bip.tld" prefix="bip" %>

<!-- #BeginEditable "doctitle" --> 
<title>Edition</title>
<!-- #EndEditable -->
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">

<!-- #BeginEditable "fichier" --> 
<bip:VerifUser page="jsp/eProdec2.jsp"/>
<script language="JavaScript" src="../js/function.cjs"></script>
<link rel="stylesheet" href="../css/base_style.css" type="text/css">
<link rel="stylesheet" href="../css/style_bip.css" type="text/css">
<script language="JavaScript">
var pageAide = "aide/hvide.htm";

var blnVerification = true;
<%
	String arborescence = ESAPI.encoder().encodeForJavaScript(ESAPI.encoder().canonicalize(request.getParameter("arborescence")));
String sPageAide = ESAPI.encoder().encodeForJavaScript(ESAPI.encoder().canonicalize(request.getParameter("pageAide")));
%>
var pageAide = "<%= sPageAide %>";

var blnVerifFormat  = true;
var tabVerif        = new Object();

<%
	String sTitre;
	String sJobId;
	String sInitial;
	
	String sParam6;
	boolean bParam7=false;
	boolean bParam8=false;
	boolean bParam9=false;
	boolean bParam10=false;
	boolean bParam11=false;
%>

function MessageInitial()
{
	<%
		sJobId = ESAPI.encoder().encodeForJavaScript(ESAPI.encoder().canonicalize(request.getParameter("jobId")));
		sTitre = com.socgen.bip.metier.Report.getTitre(sJobId);
		
		if (sTitre == null)
		{
			//redirect sur la page d'erreur
			sTitre = "Pas de titre";
		}
		
		sParam6 = ESAPI.encoder().encodeForJavaScript(ESAPI.encoder().canonicalize(request.getParameter("p_param6")));
		if (sParam6 == null) sParam6 ="";
		
		if (ESAPI.encoder().encodeForJavaScript(ESAPI.encoder().canonicalize(request.getParameter("p_param7"))) != null)
			bParam7=true;
		if (ESAPI.encoder().encodeForJavaScript(ESAPI.encoder().canonicalize(request.getParameter("p_param8"))) != null)
			bParam8=true;
		if (ESAPI.encoder().encodeForJavaScript(ESAPI.encoder().canonicalize(request.getParameter("p_param9"))) != null)
			bParam9=true;
		if (ESAPI.encoder().encodeForJavaScript(ESAPI.encoder().canonicalize(request.getParameter("p_param10"))) != null)
			bParam10=true;
	    if (ESAPI.encoder().encodeForJavaScript(ESAPI.encoder().canonicalize(request.getParameter("p_param11"))) != null) {
	    	java.util.Hashtable hP = new java.util.Hashtable();
			hP.put("userid", ((com.socgen.bip.user.UserBip)session.getAttribute("UserBip")).getInfosUser());
			java.util.ArrayList listeIsacPid = new com.socgen.bip.commun.liste.ListeDynamique().getListeDynamique("isac_pid", hP); 
			pageContext.setAttribute("choixIsacPid", listeIsacPid);
			bParam11=true;
			}
			
		sInitial=ESAPI.encoder().encodeForJavaScript(ESAPI.encoder().canonicalize(request.getQueryString()));
		if (sInitial == null)
			sInitial = request.getRequestURI();
		else
			sInitial = request.getRequestURI() + "?" + sInitial;
		sInitial = sInitial.substring(request.getContextPath().length());
	%>
	
	if (<%=bParam7%>)
		tabVerif["p_param7"]  = "VerifierDate2(document.editionForm.p_param7,'mmaaaa')";
	if (<%=bParam8%>)
		tabVerif["p_param8"]  = "Ctrl_dpg_generique(document.editionForm.p_param8)";
	if (<%=bParam9%>)
		tabVerif["p_param9"]  = "VerifierAlphaMax(document.editionForm.p_param9)";
	if (<%=bParam10%>)
		tabVerif["p_param10"]  = "VerifierAlphaMax(document.editionForm.p_param10)";

	
	var Message="<bean:write filter="false"  name="editionForm"  property="msgErreur" />";
	var Focus = "";
	
	if (<%=bParam11%>) {
	document.editionForm.p_param11.options[document.editionForm.p_param11.length] = new Option("Tous", "Tout", true, true);
	document.editionForm.p_param11.selectedIndex=parseInt(9)-1;
	tabVerif["p_param11"]  = "verifToutIsac(document.editionForm.p_param7, document.editionForm.p_param11)";
	}	
	
	if (Message != "") {
		alert(Message);
	}
	else if (<%=bParam7%>) {
	    document.editionForm.p_param7.value = "<%= com.socgen.bip.commun.Tools.getStrDateMMAAAA(-1,0) %>";
		document.editionForm.p_param7.focus();}
	else if (<%=bParam8%>) {
		document.editionForm.p_param8.focus();}
	else if (<%=bParam9%>) {
		document.editionForm.p_param9.focus();}
	else if (<%=bParam10%>) {
	
	}
	
}

function Verifier(form, bouton, flag)
{
  blnVerification = flag;
}

function ValiderEcran(form)
{
	if (blnVerification)
	{
		if (<%=bParam7%>) {
			if (!ChampObligatoire(form.p_param7, "un mois de traitement")) return false;
		}
		if ( (<%=bParam8%>) && (<%=bParam9%>) ) {
			if ( (form.p_param8.value!="") && (form.p_param9.value!="") ){
				alert("Une seule sélection possible");
				return false;
        	}
			Left(form.p_param9);
			if ( (form.p_param8.value.length == 0) && (form.p_param9.value.length == 0) )
			{
				alert("Sélection obligatoire (DPG ou ligne BIP)");
				return false;
			}
        }
		if (<%=bParam10%>) {
			if (form.p_param10.value.length == 0 && form.p_param12.value.length == 0) {
			alert("Entrez un code projet ou un code application");
			return false;
			}
		}
		if (form.p_param11) {
			//pour bonne excécution de la procédure de vérification P_param11 devient P_param9
			form.p_param9.value = form.p_param11.value ;
		}
	}
	document.editionForm.submit.disabled = true;
	return true;
}

function rechercheDPG()
{
	window.open("/recupDPG.do?action=initialiser&nomChampDestinataire=p_param8&windowTitle=Recherche Code DPG&habilitationPage=HabilitationLigneBip"  ,"", "toolbar=no, directories=no, location=no, status=no, menubar=no, resizable=yes, scrollbars=yes, width=450, height=450") ;
	return ;
}

function nextFocusCodeDPG(champs){
	document.forms[0].elements[champs].focus();
}

function recherchePID(champs){
	window.open("/recupPID.do?action=initialiser&nomChampDestinataire="+champs+"&windowTitle=Recherche Code Ligne BIP"  ,"", "toolbar=no, directories=no, location=no, status=no, menubar=no, resizable=yes, scrollbars=yes, width=450, height=450") ;
	return ;
} 

function ChangeAff(newAff){
	document.forms[0].p_param10.style.display="none";
	document.forms[0].p_param12.style.display="none";
	document.forms[0].p_param10.value="";
	document.forms[0].p_param12.value="";
	if (newAff=="1") document.forms[0].p_param10.style.display="";
	if (newAff=="2") document.forms[0].p_param12.style.display="";

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
          <td height="20" class="TitrePage"><!-- #BeginEditable "titre_page" --><%=sTitre%><!-- #EndEditable --></td>
        </tr>
        <tr> 
          <td background="../images/ligne.gif"></td>
        </tr>
        <tr> 
          <td> 
            
          </td>
        </tr>
        <tr> 
          <td>
		  <!-- #BeginEditable "debut_form" --><html:form action="/edition"  onsubmit="return ValiderEcran(this);"><!-- #EndEditable -->
			<!-- #BeginEditable "debut_hidden" -->
		  	<input type="hidden" name="p_param6" value="<%=sParam6%>">
		  	<input type="hidden" name="initial" value="<%= sInitial %>">
            
<html:hidden property="arborescence" value="<%= arborescence %>"/>
<input type="hidden" name="jobId" value="<%=sJobId%>">
			<!-- #EndEditable -->
            <table width="100%" border="0">
              
                <tr> 
                  <td> 
                    <div align="center">
					<table border=0 cellspacing=2 cellpadding=2 class="tableBleu">
					<!-- #BeginEditable "contenu" -->
<input type="hidden" name="pageAide" value="<%= sPageAide %>">
					  <tr>
                        <td colspan=5 align="center">&nbsp;</td>
                      </tr>
                      
					<% if (bParam7)
					{
					%>
						 <tr>
							<td class="lib"><B> Mois de traitement : </B></td>
							<td><html:text property="p_param7" styleClass="input"  size="7" maxlength="7" onchange="return VerifFormat(this.name);"/></td>
						</tr>
					<%
					}
					if (bParam8)
					{
					%>
						<tr>
							<td class="lib"> Code DPG : </td>
							<td><html:text property="p_param8" styleClass="input"  size="7" maxlength="7" onchange="return VerifFormat(this.name);"/>
							<a href="javascript:rechercheDPG();" ><img border=0 src="/images/p_zoom_blue.gif" alt="Rechercher Code DPG" title="Rechercher Code DPG" align="absbottom"></a>   
                        </td>
						</tr>
					<%
					}
					if (bParam9)
					{
					%>
						<tr>
							<td class="lib"> Code ligne BIP : </td>
							<td><html:text property="p_param9" styleClass="input"  size="4" maxlength="4" onchange="return VerifFormat(this.name);"/>
							&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<a href="javascript:recherchePID('p_param9');" ><img border=0 src="/images/p_zoom_blue.gif"  alt="Rechercher Code Ligne BIP" title="Rechercher Code Ligne BIP" align="absbottom"></a>
                            </td>
						</tr>
					<%
					}
					if (bParam10)
					{
					%>
			
						
					<tr>
						<td>
							<input type="radio" name="choix" styleClass="input" value="2" onclick="ChangeAff(this.value);" >	
						</td>
						<td class="lib"><B>&nbsp;Edition Projet :&nbsp;</B></td>
						<td colspan=3 width="60%">
							<html:text property="p_param12" styleClass="input" style="display='none'" size="8" maxlength="5" onchange="return VerifierAlphaMax(this);"/>
						</td>
					  </tr>
					<tr>
						<td>
							<input type="radio" name="choix" styleClass="input" value="1" onclick="ChangeAff(this.value);" >	
						</td>
						<td class="lib"><B>&nbsp;Edition Application :&nbsp;</B></td>
						<td colspan=3 width="60%">
							<html:text property="p_param10" styleClass="input" style="display='none'" size="8" maxlength="5" onchange="return VerifierAlphaMax(this);"/>
						</td>
					  </tr>
					
						
					<%
					}
					%>
					<%
					if (bParam11)
					{
					%>
						<tr>
							<td class="lib"> Code ligne BIP : </td>
							<td><html:select property="p_param11" styleClass="input" onchange="return VerifFormat(this.name);"> 
							<html:options collection="choixIsacPid" property="cle" labelProperty="libelle" />
							</html:select> <input type="hidden" name="p_param9"/></td>
						</tr>
					<%
					}%>
					  <tr>
                        <td colspan=5 align="center">&nbsp;</td>
                      </tr>					
					<!-- #EndEditable -->
			   		</table>
					</div>
                  </td>
                </tr>
				<tr> 
          		  <td>&nbsp;  
          		  </td>
        		</tr>
                <tr> 
                  <td>  
                  <div align="center">
				  <html:submit value="Liste" styleClass="input" onclick="Verifier(this.form, 'liste', true);"/>
                  </div>
                  </td>
                </tr>
            
            </table>
			  <!-- #BeginEditable "fin_form" --></html:form><!-- #EndEditable -->
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