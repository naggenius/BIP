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

<bip:VerifUser page="jsp/eRefAd.jsp"/>
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
	String sInitial;
	String sJobId="eRefAd";
%>

function MessageInitial()
{
	<%
		sTitre = com.socgen.bip.metier.Report.getTitre(sJobId);
		if (sTitre == null)	{
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
	
	tabVerif["p_param6"] = "VerifierAlphaMax(document.editionForm.p_param6)";
	
	var Message="<bean:write filter="false"  name="editionForm"  property="msgErreur" />";
	var Focus = "<bean:write name="editionForm"  property="focus" />";
	
	if (Message != "") {
		alert(Message);
	}
	 if (Focus != "") (eval( "document.forms[0]."+Focus )).focus();
	else {
		document.forms[0].p_param6.focus();
	}
}

function Verifier(form, bouton, flag)
{
  blnVerification = flag;
}

function ValiderEcran(form)
{
var choix;
var coche = false;
   if (blnVerification) {
   
   for(i = 0; i < document.forms[0].choix.length; i++){
	if(document.forms[0].choix[i].checked) 
	{
		choix = document.forms[0].choix[i].value;
		coche = true;
	}
	
	}
	
	if (coche == false)
	{
		choix = "non";
	}
	
   	switch (choix) {
 		case "1":
 			 if (!ChampObligatoire(form.p_param6, "un code projet")) return false;
 			break;
 		case "2":
 			 if (!ChampObligatoire(form.p_param7, "un code application")) return false;
 		break;
 		case "3":
 			 if (!ChampObligatoire(form.p_param8, "un code dossier projet")) return false;
	break;
	case "non" :
		alert("Veuillez selectionner un référentiel");
		return false;
	break;
}
   
   
        if ( !VerifFormat(null) ) return false;
        
        
       
        
   }
	document.editionForm.submit.disabled = true;
   return true;
}

function ChangeAff(newAff){
	document.forms[0].p_param6.style.display="none";
	document.forms[0].p_param7.style.display="none";
	document.forms[0].p_param8.style.display="none";
	document.forms[0].p_param6.value="";
	document.forms[0].p_param7.value="";
	document.forms[0].p_param8.value="";
	if (newAff=="1") document.forms[0].p_param6.style.display="";
	if (newAff=="2") document.forms[0].p_param7.style.display="";
	if (newAff=="3") document.forms[0].p_param8.style.display="";
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
            <table width="100%" border="0" >
                  <div align="center">
					<table border=0 cellspacing=2 cellpadding=2 class="tableBleu" align="center">
						<input type="hidden" name="pageAide" value="<%= sPageAide %>">
					               
                 <tr> 
                  <td> 
                     <tr>
                        <td colspan=5 align="center">&nbsp;</td>
                      </tr>
					  <tr>
						<td>
							<input type="radio" name="choix" styleClass="input" value="1" onclick="ChangeAff(this.value);" >	
						</td>
						<td class="lib"><B>&nbsp;Edition Projet :&nbsp;</B></td>
						<td colspan=3 width="60%">
							<html:text property="p_param6" styleClass="input" style="display='none'" size="8" maxlength="5" onchange="return VerifierAlphaMax(this);"/>
						</td>
					  </tr>
					  <tr>
						<td>
							<input type="radio" name="choix" styleClass="input" value="2" onclick="ChangeAff(this.value);" >	
						</td>
						<td class="lib"><B>&nbsp;Edition Application :&nbsp;</B></td>
						<td colspan=3 width="60%">
							<html:text property="p_param7" styleClass="input" style="display='none'" size="8" maxlength="5" onchange="return VerifierAlphaMax(this);"/>
						
						</td>
					  </tr>
					  <tr>
						<td>
							<input type="radio" name="choix" styleClass="input" value="3" onclick="ChangeAff(this.value);" >	
						</td>
						<td class="lib"><B>&nbsp;Edition Dossier Projet :&nbsp;</B></td>
						<td colspan=3 width="60%">
							<html:text property="p_param8" styleClass="input" style="display='none'" size="8" maxlength="5" onchange="return VerifierAlphaMax(this);"/>
						</td>
					  </tr>
					  <tr>
					  	<td colspan=5 align="center">&nbsp;</td>
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