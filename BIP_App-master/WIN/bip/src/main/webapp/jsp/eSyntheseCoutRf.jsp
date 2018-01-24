<%@ taglib uri="/WEB-INF/struts-bean.tld" prefix="bean" %>
<%@ taglib uri="/WEB-INF/struts-html.tld" prefix="html" %>
<%@ taglib uri="/WEB-INF/struts-logic.tld" prefix="logic" %>

<%@ page language="java" import="org.owasp.esapi.ESAPI,java.sql.*,java.io.*,javax.servlet.*,javax.servlet.http.*,com.socgen.ich.ihm.*,java.util.Vector,java.util.StringTokenizer"    errorPage="../jsp/erreur.jsp"  %>
<jsp:useBean id="editionForm" scope="request" class="com.socgen.bip.commun.form.EditionForm" />
<jsp:useBean id="extractionForm" scope="request" class="com.socgen.bip.commun.form.ExtractionForm" />
<jsp:useBean id="listeCA" scope="request" class="com.socgen.bip.commun.liste.ListeCentreActivite" />
	<html:html locale="true">
<head>


<%@ taglib uri="/WEB-INF/bip.tld" prefix="bip" %>


<title>Edition</title>

<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<bip:VerifUser page="jsp/eFactIntRf.jsp"/>
<%
	com.socgen.bip.user.UserBip userbip = (com.socgen.bip.user.UserBip)session.getAttribute("UserBip");  

	java.util.Hashtable hP = new java.util.Hashtable();
	hP.put("userid", userbip.getInfosUser());
  	
	java.util.ArrayList dossProj = new com.socgen.bip.commun.liste.ListeDynamique().getListeDynamique("dprojet_ref",hP); 
	pageContext.setAttribute("choixDProjet", dossProj);

    java.util.ArrayList liste = new com.socgen.bip.commun.liste.ListeDynamique().getListeDynamique("ca_utilisateur",hP); 
	pageContext.setAttribute("choixCA", liste);

//	Vector listeCaPayeur = new Vector();
//	String caPayeur = userbip.getCAPayeur();
//	if (caPayeur.equals("TOUS")){
//		if (!listeCaPayeur.contains("TOUS")) 
//		{
//			listeCaPayeur.addElement("TOUS");
//		}
//		
//		java.util.ArrayList liste = listeCA.recupererListeGlobale(listeCaPayeur);
//	    pageContext.setAttribute("choixCA", liste);
//	    } 
//	else
//	{
//	StringTokenizer strtkCA_Payeur = new StringTokenizer(caPayeur, ",");
//	while (strtkCA_Payeur.hasMoreTokens())
//		{
//		String leCA = strtkCA_Payeur.nextToken();
//		if (!listeCaPayeur.contains(leCA)) 
//		{
//			listeCaPayeur.addElement(leCA);
//		}
//		}
//		java.util.ArrayList liste = listeCA.recupererListeGlobale(listeCaPayeur);
//	}
	 
	
%>
<script language="JavaScript" src="../js/function.cjs"></script>
<link rel="stylesheet" href="../css/base_style.css" type="text/css">
<link rel="stylesheet" href="../css/style_bip.css" type="text/css">
<script language="JavaScript">
var pageAide = "aide/hvide.htm";
var choixEffectue = false;
<%
	String arborescence = ESAPI.encoder().encodeForJavaScript(ESAPI.encoder().canonicalize(request.getParameter("arborescence")));
String sPageAide = ESAPI.encoder().encodeForJavaScript(ESAPI.encoder().canonicalize(request.getParameter("pageAide")));
%>
var pageAide = "<%= sPageAide %>";
<%
	String sTitre;
	String sInitial;
	String sJobId="eSyntheseCoutRf";
%>

function MessageInitial(){
	<%
		sTitre = com.socgen.bip.metier.Report.getTitre(sJobId);
		if (sTitre == null){
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
	
	var Message="<bean:write filter="false"  name="editionForm"  property="msgErreur" />";
	var Focus = "<bean:write name="editionForm"  property="focus" />";
	
	if (Message != "") {
		alert(Message);
	}
}

function ChangeRef(newRef){
	document.forms[0].p_param7.style.display="none";
	document.forms[0].p_param6.style.display="none";
	if (newRef=="DP") document.forms[0].p_param7.style.display="";
	if (newRef=="CA") document.forms[0].p_param6.style.display="";
}

function Verifier(form, bouton, flag){
  
}

function ChangeReport(newRef){
	choixEffectue = true;
	if (newRef=="SE")
	{
		sJobId="eSyntheseCoutRfEuros";
		document.forms[0].jobId.value="eSyntheseCoutRfEuros";
		document.forms[0].action="/edition.do";
	} 
	if (newRef=="SJ")
	{
		sJobId="eSyntheseCoutRfJours";
		document.forms[0].jobId.value="eSyntheseCoutRfJours";
		document.forms[0].action="/edition.do";
	}
	if (newRef=="EJ")
	{
		sJobId="eSyntheseCoutRfExtractJours";
		document.forms[0].jobId.value="eSyntheseCoutRfExtractJours";
		document.forms[0].action="/extract.do";
	}
}

function ValiderEcran(form)
{
	if (!choixEffectue)
	{
		alert("Vous devez choisir un mode de présentation") ;
		return false;
	}
	document.editionForm.submit.disabled = true;
	return true;
}
</script>

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
          <td height="20" class="TitrePage"><%=sTitre%></td>
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
	<html:form action="/edition"  onsubmit="return ValiderEcran(this);">
            
<html:hidden property="arborescence" value="<%= arborescence %>"/>
<input type="hidden" name="jobId" value="<%=sJobId%>">
            <input type="hidden" name="initial" value="<%= sInitial %>">
           	<input type="hidden" name="listeReports">
            <table width="100%" border="0">
                <tr> 
                  <td> 
                    <div align="center">
					<table border=0 cellspacing=2 cellpadding=2 class="tableBleu">
					<input type="hidden" name="pageAide" value="<%= sPageAide %>">
					 <tr>
                        <td colspan=5 align="center">&nbsp;</td>
                      </tr>
                      <tr>
                      	
                        <td colspan=5 align="left"><b>Vous pouvez limiter à un élément de votre périmètre (optionnel) :</b></td>
                      </tr>
					  <tr>
                        <td colspan=5 align="center">&nbsp;</td>
                      </tr>
					<tr>
						<td align="right"> 
                    		<html:radio property="p_param8" styleClass="input" value="DP" onclick="ChangeRef(this.value);"/>
						</td>
						<td class="lib" align=left width=20%><b>Dossier Projet : </b></td>
						<td width=75%>
							<html:select property="p_param7" styleClass="input" style="display='none'"> 
								<html:options collection="choixDProjet" property="cle" labelProperty="libelle" />
							</html:select>
						</td>
					</tr>
					  <tr>
                        <td colspan=5 align="center">&nbsp;</td>
                      </tr>
                    <tr>
                     	<td align="right"> 
                     		<html:radio property="p_param8" styleClass="input" value="CA" onclick="ChangeRef(this.value);"/>
						</td>
						<td class="lib" align=left width=20%><b>Classement par CA : </b></td>
						<td>
							<html:select property="p_param6" styleClass="input" style="display='none'"> 
								<option value=" TOUS">Tous</option>
								<html:options collection="choixCA" property="cle" labelProperty="libelle" /> 
							</html:select>
						</td>
					</tr>
					<tr> 
          		  		<td>&nbsp;  
          		  		</td>
        			</tr>
        			<tr>
                		<td colspan=5 align="left"><b>Choisir le mode de présentation :</b></td>
            		</tr>
					<tr>
                		<td colspan=5 align="center">&nbsp;</td>
            		</tr>
					<tr>
						<td align="right">
							<html:radio property="p_param9" styleClass="input" value="SE" onclick="ChangeReport(this.value);"/>
						</td>
						<td class="lib" align=left width=20%><B>Suivi en €</B></td>
					</tr>
					<tr>
						<td align="right">
							<html:radio property="p_param9" styleClass="input" value="SJ" onclick="ChangeReport(this.value);"/>
						</td>
						<td class="lib" align=left width=20%><B>Suivi en JxH</B></td>
					</tr>
					<tr>
						<td align="right">
							<html:radio property="p_param9" styleClass="input" value="EJ" onclick="ChangeReport(this.value);"/>
						</td>
						<td class="lib" align=left width=20%><B>Extraction en JxH</B></td>						
					</tr>
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
				  <html:submit value="Edition" styleClass="input" onclick="Verifier(this.form, 'liste', true);"/>
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
            <div align="center"><html:errors/></div>
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