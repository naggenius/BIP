<!DOCTYPE html>
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

<bip:VerifUser page="jsp/eEcarts.jsp"/>
<script language="JavaScript" src="../js/function.cjs"></script>
<!-- <link rel="stylesheet" href="../css/base_style.css" type="text/css"> -->
<!-- <link rel="stylesheet" href="../css/style_bip.css" type="text/css"> -->
<link rel="stylesheet" href="../css/style_bip_new.css" ="text/css">
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
	String sJobId;
%>

function MessageInitial()
{
	<%
		sJobId = ESAPI.encoder().encodeForJavaScript(ESAPI.encoder().canonicalize(request.getParameter("jobId")));
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
	else
	{
		document.editionForm.p_param6.value = Replace_DoubleZero_by_DoubleEtoile( "<bean:write name="UserBip"  property="dpg_Defaut" />" );
		if (Focus != "")
		{ 
			(eval( "document.editionForm."+Focus )).focus();
		}
   		else 
   		{
	  		document.editionForm.p_param6.focus();
   		}
	}
	document.editionForm.p_param6.focus();
}

function Verifier(form, bouton, flag)
{
  blnVerification = flag;
}

function ValiderEcran(form)
{
   if (blnVerification) {
        if (!ChampObligatoire(form.p_param6, "Code DPG")) return false;
   }
	document.editionForm.submit.disabled = true;
   return true;
}

function rechercheDPG()
{
	window.open("/recupDPG.do?action=initialiser&nomChampDestinataire=p_param6&windowTitle=Recherche Code DPG&habilitationPage=HabilitationLigneBip"  ,"", "toolbar=no, directories=no, location=no, status=no, menubar=no, resizable=yes, scrollbars=yes, width=450, height=450") ;
	return ;
}

function nextFocusCodeDPG(){
	document.forms[0].p_param6.focus();
}


</script>

</head>

<body bgcolor="#FFFFFF" text="#000000" topmargin="0" leftmargin="0" onLoad="MessageInitial();">
<div id="mainContainer">
<div id="topContainer" style="min-height:98%;">
<div id="entete"></div>
<div id="logo">
		<div id="logo_sg"><img src="../images/logo_SG.gif" width="162" height="33" border="0" /></div>
		<div id="nomdusite"><img src="../images/bip_logo.png" width="78" height="46" border="0" /></div>
</div>
<table width="100%" border="0" cellpadding="0" cellspacing="0">
  <tr> 
    <td> 
      <table width="100%" border="0" cellspacing="0" cellpadding="0">
       <tr> 
          <td>&nbsp;</td>
        </tr>
		<tr > 
		  <td> 
            &nbsp;
          </td>
        </tr>
        <tr> 
          <td><div id="outils" align="center"><!-- #BeginEditable "barre_haut" -->
              <%ToolBarNew tb = new com.socgen.ich.ihm.ToolBarNew("bip_ihm",false,false,true,true,false,false,false,false,false,request) ;%>
				<%=tb.printHtml()%><!-- #EndEditable -->
		</div></td>
        </tr>
        <tr> 
<!--           <td background="../images/ligne.gif"></td> -->
        </tr>
        <tr> 
          <td height="20" class="TitrePage"><%=sTitre%></td>
        </tr>
        <tr> 
<!--           <td background="../images/ligne.gif"></td> -->
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
		           
                 
                              
            <table width="100%" border="0">
              <tr><td height="20"></td></tr>
                <tr> 
                  <td> 
                    <div align="center">
					<table border=0 cellspacing=2 cellpadding=2 class="tableBleu">
						<input type="hidden" name="pageAide" value="<%= sPageAide %>">
					  <tr>
                        <td colspan=5 align="center">&nbsp;</td>
                      </tr>
                  <tr> 
                     <td>&nbsp;</td>
                     <td>&nbsp;</td>
                  </tr>
                      
                  <tr> 
                     <td>&nbsp;</td>
                     <td>&nbsp;</td>
                  </tr>
                  
                  <tr> 
                     <td>&nbsp;</td>
                     <td>&nbsp;</td>
                  </tr>    
                      
                      
					<tr align="left">
						<td class="texte"><B>Code DPG :</B></td>
						<td class="texte"><html:text property="p_param6" styleClass="input"  size="7" maxlength="7" onchange="return Ctrl_dpg_generique(this);"/>
						&nbsp;<a href="javascript:rechercheDPG();" onFocus="javascript:nextFocusCodeDPG();"><img border=0 src="/images/p_zoom_blue.gif" alt="Rechercher Code DPG" title="Rechercher Code DPG" style="vertical-align : middle;"></a>   
                        </td>
					</tr>
					
					<tr> 
                     <td>&nbsp;</td>
                     <td>&nbsp;</td>
                    </tr>
					
					<tr align="left">
					<td class="texte"><B>Ecarts valid&eacute;s &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</B></td>
					   <td align=left>
                    	   <select name="p_param7" size="1" class="input">
                    		   <option value="N">NON</option>
                               <option value="O">OUI</option>
                           </select>	
					   </td>
					</tr>
					
					 <tr>
                        <td colspan=5 align="center" height="15">&nbsp;</td>
                      </tr>
			   		</table>
					</div>
                  </td>
                </tr>
				<tr> 
          		  <td>&nbsp;  
          		  </td>
        		</tr>
                           
            </table>
             <table  border="0" width=100%>
                      
                 <tr> 
                  <td>  
                  <div align="center">
				  <html:submit value="Valider" styleClass="input" onclick="Verifier(this.form, 'liste', true);"/>
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
</div>
	<div id="bottomContainer">
			<div>&nbsp;</div>
	</div>
</div>
</body>
</html:html>
