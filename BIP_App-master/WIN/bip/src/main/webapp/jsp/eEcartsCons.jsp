<%@ taglib uri="/WEB-INF/struts-bean.tld" prefix="bean" %>
<%@ taglib uri="/WEB-INF/struts-html.tld" prefix="html" %>
<%@ taglib uri="/WEB-INF/struts-logic.tld" prefix="logic" %>

<%@ page language="java" import="org.owasp.esapi.ESAPI,java.sql.*,java.io.*,javax.servlet.*,javax.servlet.http.*,com.socgen.ich.ihm.*,com.socgen.bip.user.UserBip"    errorPage="../jsp/erreur.jsp"  %>
<jsp:useBean id="extractionForm" scope="request" class="com.socgen.bip.commun.form.ExtractionForm" />
<html:html locale="true">

<head>


<%@ taglib uri="/WEB-INF/bip.tld" prefix="bip" %>


<title>Edition</title>

<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">

<bip:VerifUser page="jsp/eEcarts.jsp"/>
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
	String menuCourant = ((UserBip) session.getAttribute("UserBip")).getCurrentMenu().getId();
	String sTitre;
	String sInitial;
	String sJobId="eEcartsCons";
	
	// si menu Responsable d'�tudes controle different jobid = eEcartsCons_me
	if ("ME".equals(menuCourant)) {
		sJobId="eEcartsCons_me";
	} else {
		sJobId="eEcartsCons";
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
	var Message="<bean:write filter="false"  name="extractionForm"  property="msgErreur" />";
	var Focus = "<bean:write name="extractionForm"  property="focus" />";
	
	if (Message != "") {
		alert(Message);
	}
	else
	{
		document.extractionForm.p_param6.value = Replace_DoubleZero_by_DoubleEtoile( "<bean:write name="UserBip"  property="dpg_Defaut" />" );
		if (Focus != "")
		{ 
			(eval( "document.extractionForm."+Focus )).focus();
		}
   		else 
   		{
	  		document.extractionForm.p_param6.focus();
   		}
	}
	document.extractionForm.p_param6.focus();
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
	document.extractionForm.submit.disabled = true;
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

<input type="hidden" name="listeReports" value="1">

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
          <html:form action="/extract.do"  onsubmit="return ValiderEcran(this);">
		  		
             
<html:hidden property="arborescence" value="<%= arborescence %>"/>
<input type="hidden" name="jobId" value="<%=sJobId%>">
				
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
                      
                      
					<tr>
						<td class="lib"><B>Code DPG :</B></td>
						<td><html:text property="p_param6" styleClass="input"  size="7" maxlength="7" onchange="return Ctrl_dpg_generique(this);"/>
						&nbsp;&nbsp;<a href="javascript:rechercheDPG();" onFocus="javascript:nextFocusCodeDPG();"><img border=0 src="/images/p_zoom_blue.gif" alt="Rechercher Code DPG" title="Rechercher Code DPG" align="absbottom"></a>   
                        </td>
					</tr>
					
					<tr> 
                     <td>&nbsp;</td>
                     <td>&nbsp;</td>
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
                           
            </table>
             <table  border="0" width=100%>
                      
                 <tr> 
                  <td>  
                  <div align="center">
				  <html:submit value="Extraire" styleClass="input" onclick="Verifier(this.form, 'liste', true);"/>
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
