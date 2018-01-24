<%@ taglib uri="/WEB-INF/struts-bean.tld" prefix="bean" %>
<%@ taglib uri="/WEB-INF/struts-html.tld" prefix="html" %>
<%@ taglib uri="/WEB-INF/struts-logic.tld" prefix="logic" %>

<%@ page language="java" import="org.owasp.esapi.ESAPI,java.sql.*,java.io.*,javax.servlet.*,javax.servlet.http.*,com.socgen.ich.ihm.*"    errorPage="../jsp/erreur.jsp"  %>
<jsp:useBean id="editionForm" scope="request" class="com.socgen.bip.commun.form.EditionForm" />
<html:html locale="true">

<head>


<%@ taglib uri="/WEB-INF/bip.tld" prefix="bip" %>


<title>Edition</title>

<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">

<bip:VerifUser page="jsp/eLogsContratsAd.jsp"/>
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
	String sTitre="Logs des contrats";
	String sInitial;
	String sJobId="eLogsContratsAd";

%>

function MessageInitial()
{
	<%
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
	var Message="<bean:write filter="false"  name="editionForm"  property="msgErreur" />";
	var Focus = "<bean:write name="editionForm"  property="focus" />";
	
	if (Message != "") {
		alert(Message);
	}
	document.editionForm.p_param6.focus();
}

function Verifier(form, bouton, flag)
{
  blnVerification = flag;
}

function ValiderEcran(form)
{

 return true;
}

function rechercheSocieteID(){
	window.open("/recupIdSociete.do?action=initialiser&nomChampDestinataire=p_param6&windowTitle=Recherche Identifiant Societe&habilitationPage=HabilitationLigneBip"  ,"", "toolbar=no, directories=no, location=no, status=no, menubar=no, resizable=yes, scrollbars=yes, width=450, height=450") ;
} 


function rechercheContrat(){

   var typeContrat;
   
   
   if (document.forms[0].p_param6.value == '')  {
      alert("Veuillez saisir le code de la société");
      document.form.soccont.focus();
   }
   else
   {
   		
   		if(document.forms[0].typecontrat[0].checked == true)
      		typeContrat = "contrat";
   		else
      		typeContrat = "avenant";
/* le champ destinataire2 ets inutilisé mais pour eviter la creation d'une autre loupe j'envoie la valeur de champ destinataire2 dans p_param14*/
		window.open("/recupContrat.do?action=initialiser&soccont="+document.forms[0].p_param6.value+"&typeContrat="+typeContrat+"&nomChampDestinataire=p_param7&nomChampDestinataire2=p_param10&windowTitle=Recherche "+typeContrat+"&habilitationPage=HabilitationLigneBip"  ,"", "toolbar=no, directories=no, location=no, status=no, menubar=no, resizable=yes, scrollbars=yes, width=700, height=600") ;
	}
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
			<input type="hidden" name="p_param10" value="00">
 					
            <input type="hidden" name="initial" value="<%= sInitial %>">
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
                        <td class="lib"><b>Choix contrat/avenant :</b></td>
                        <td> 
                           <INPUT type=radio name="typecontrat" value="contrat" checked>contrat<INPUT type=radio name="typecontrat" value="avenant">avenant
                        </td>
                      </tr>
                      <tr> 
                        <td class="lib"><b>Code société :</b></td>
                        <td> 
                          <html:text property="p_param6" styleClass="input" size="5" maxlength="4" onchange="return VerifierAlphaMax(this);"/>
                          &nbsp;&nbsp;<a href="javascript:rechercheSocieteID();"><img border=0 src="/images/p_zoom_blue.gif" alt="Rechercher Code Société" title="Rechercher Code Société" align="absbottom"></a>
                        </td>
                      </tr>
					<tr>
						<td class="lib"><B>N° de Contrat :</B></td>
						<td><html:text property="p_param7" styleClass="input"  size="27" maxlength="27" onchange="return VerifierAlphaMax(this);"/>
						 <a href="javascript:rechercheContrat();" ><img border=0 src="/images/p_zoom_blue.gif" alt="Rechercher Contrat" title="Rechercher Contrat" align="absbottom"></a>  
						</td>
						
					</tr>
					<tr>
						<td class="lib"><B>Date début :</B></td>
						<td><html:text property="p_param8" styleClass="input"  size="10" maxlength="10" onchange="return VerifierDate(this,'jj/mm/aaaa');"/></td>
					</tr>
					<tr>
						<td class="lib"><B>Date fin :</B></td>
						<td><html:text property="p_param9" styleClass="input"  size="10" maxlength="10" onchange="return VerifierDate(this,'jj/mm/aaaa');"/></td>
					</tr>
					  <tr>
                        <td colspan=5 align="center">&nbsp;</td>
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
				  <html:submit value="Liste" styleClass="input" onclick="Verifier(this.form, 'liste', true);"/>
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
