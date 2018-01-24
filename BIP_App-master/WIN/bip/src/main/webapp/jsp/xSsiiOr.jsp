<%@ taglib uri="/WEB-INF/struts-bean.tld" prefix="bean" %>
<%@ taglib uri="/WEB-INF/struts-html.tld" prefix="html" %>
<%@ taglib uri="/WEB-INF/struts-logic.tld" prefix="logic" %>
<!-- #BeginEditable "imports" --> 
<%@ page language="java" import="org.owasp.esapi.ESAPI,java.sql.*,java.io.*,javax.servlet.*,javax.servlet.http.*,com.socgen.ich.ihm.*"    errorPage="../jsp/erreur.jsp"  %>
<jsp:useBean id="extractionForm" scope="request" class="com.socgen.bip.commun.form.ExtractionForm" />
<html:html locale="true">
<!-- #EndEditable --> 

<head>


<%@ taglib uri="/WEB-INF/bip.tld" prefix="bip" %>

<!-- #BeginEditable "doctitle" --> 
<title>Extraction</title>
<!-- #EndEditable -->
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">

<!-- #BeginEditable "fichier" -->
<bip:VerifUser page="jsp/xSsiiOr.jsp"/>
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
<%
	String sTitre;
	String sInitial;
	String sJobId;
%>


function MessageInitial()
{
	<%
		sJobId = "xSsiiOr";
		
		sTitre = com.socgen.bip.metier.Report.getTitre(sJobId);
		if (sTitre == null)
		{
			//redirect sur la page d'erreur
			sTitre = "Pas de titre";
		}		
		sInitial=ESAPI.encoder().encodeForJavaScript(ESAPI.encoder().canonicalize(request.getQueryString()));
		if (sInitial == null)
			sInitial = request.getRequestURI();
		else
			sInitial = request.getRequestURI() + "?" + sInitial;
		sInitial = sInitial.substring(request.getContextPath().length());
	%>

	var Message="<bean:write filter="false"  name="extractionForm"  property="msgErreur" />";
	var Focus = "<bean:write name="extractionForm"  property="focus" />";

   
   if (Message != "") {
      alert(Message);
   }

	if (Focus != "") {
		if (eval( "document.forms[0]."+Focus )){
			(eval( "document.forms[0]."+Focus )).focus();
		}
	}
	
}

function majListe()
{
	sListe = "";
	if (document.ckF.ck1.checked){
		sListe="1";
	}
	
	if (document.ckF.ck2.checked){
		if (sListe == "")
			sListe="2";
		else
			sListe = sListe + ";2";
	}
	if (document.ckF.ck3.checked)
	{
		if (sListe == "")
			sListe="3";
		else
			sListe = sListe + ";3";
	}
	
	if (document.ckF.ck4.checked){
		bTestGroupe = true;
		if (sListe == "")
			sListe="4";
		else
			sListe = sListe + ";4";
	}
	
	if (document.ckF.ck5.checked){
		if (sListe == "")
			sListe="5";
		else
			sListe = sListe + ";5";
	}
	
	if (document.ckF.ck6.checked){
		if (sListe == "")
			sListe="6";
		else
			sListe = sListe + ";6";
	}
	
	if (document.ckF.ck7.checked){
		if (sListe == "")
			sListe="7";
		else
			sListe = sListe + ";7";
	}
	
	if (document.ckF.ck8.checked){
		bTestGroupe = true;
		if (sListe == "")
			sListe="8";
		else
			sListe = sListe + ";8";
	}
	document.extractionForm.listeReports.value = sListe;
}

function Verifier(form, bouton, flag){
  blnVerification = flag;
}

function ValiderEcran(form){
	document.extractionForm.submit.disabled = true;
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
				<%=tb.printHtml()%><!-- #EndEditable -->
			</div>
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
          <td>&nbsp;</td>
        </tr>
        <tr> 
          <td>

            <table width="100%" border="0">
			<tr> 
				<td> 
				<div align="center">
				<form name ="ckF" action="" method="POST">
					<table border=0 cellspacing=5 cellpadding=0 class="tableBleu">
						<table border=0 cellspacing=5 cellpadding=0 width=498>
							<tr><td class="lib" nowrap><B>Consommé du mois par ressource SSII</B></td>
								<td >
									<input type="checkbox" name="ck1" value="1" onChange="majListe();">
								</td>
								<td width=10>&nbsp;</td>
								<td class="lib" nowrap><B>Consommé par ressource SSII sans contrats</B></td>
								<td>
									<input type="checkbox" name="ck2" value="2" onChange="majListe();">
								</td>
							</tr>
							<tr>
								<td class="lib" nowrap><B>Historique ressource SG</B></td>
								<td>
									<input type="checkbox" name="ck3" value="3" onChange="majListe();">
								</td>
								<td>&nbsp;</td>
								<td class="lib" nowrap><B>Jours travaillés par les agents SG</B></td>
								<td>
									<input type="checkbox" name="ck4" value="4" onChange="majListe();">
								</td>
							</tr>
							<tr>
								<td class="lib" nowrap><B>Nouveaux contrats</B></td>
								<td>
									<input type="checkbox" name="ck5" value="5" onChange="majListe();">
								</td>
								<td>&nbsp;</td>
								<td class="lib" nowrap><B>Ratios des forfaits facturés</B></td>
								<td>
									<input type="checkbox" name="ck6" value="6" onChange="majListe();">
								</td>
							</tr>
							<tr>
								<td class="lib" nowrap><B>Suivi des contrats</B></td>
								<td>
									<input type="checkbox" name="ck7" value="7" onChange="majListe();">
								</td>
								<td>&nbsp;</td>
								<td class="lib" nowrap><B>Table des codes DPG</B></td>
								<td>
									<input type="checkbox" name="ck8" value="8" onChange="majListe();">
								</td>
							</tr>
						</table>
					</table>
				</form>
				</div>
				</td>
			</tr>
			</table>
			
          	 
		  <html:form action="/extract"  onsubmit="return ValiderEcran(this);">
			<!-- #BeginEditable "debut_hidden" -->
            
<html:hidden property="arborescence" value="<%= arborescence %>"/>
<input type="hidden" name="jobId" value="<%=sJobId%>">
			<input type="hidden" name="listeReports">
            <input type="hidden" name="initial" value="<%= sInitial %>">
            <input type="hidden" name="pageAide" value="<%= sPageAide %>">
			<!-- #EndEditable -->
            <table width="100%" border="0">
              
              <tr>    
                <td> 
                    
                  <div align="center">
					<table border=0 cellspacing=5 cellpadding=0 class="tableBleu">
					<!-- #BeginEditable "contenu" -->
					  <tr>
                        <td colspan=5 align="center"></td>
                      </tr>

					  <tr>
                        <td colspan=5 align="center"></td>
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
				  <html:submit value="Extraire" styleClass="input" onclick="Verifier(this.form, 'Extraire', true);"/>
                  </div>
                </td>
              </tr>
            
             </table>
			</html:form>

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

