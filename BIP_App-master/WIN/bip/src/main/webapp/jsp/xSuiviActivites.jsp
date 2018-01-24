<%@ taglib uri="/WEB-INF/struts-bean.tld" prefix="bean" %>
<%@ taglib uri="/WEB-INF/struts-html.tld" prefix="html" %>
<%@ taglib uri="/WEB-INF/struts-logic.tld" prefix="logic" %>

<%@ page language="java" import="org.owasp.esapi.ESAPI,java.sql.*,java.io.*,javax.servlet.*,java.util.*,javax.servlet.http.*,com.socgen.ich.ihm.*,java.util.Hashtable,com.socgen.bip.commun.liste.ListeOption"    errorPage="../jsp/erreur.jsp"  %>
<jsp:useBean id="extractionForm" scope="request" class="com.socgen.bip.commun.form.ExtractionForm" />
<jsp:useBean id="listeDynamique" scope="request" class="com.socgen.bip.commun.liste.ListeDynamique" />
<html:html locale="true">

<head>


<%@ taglib uri="/WEB-INF/bip.tld" prefix="bip" %>


<title>Edition</title>

<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">

<bip:VerifUser page="jsp/xSuiviActivites.jsp"/>
<script language="JavaScript" src="../js/function.cjs"></script>
<jsp:useBean id="UserBip" scope="session" class="com.socgen.bip.user.UserBip" />
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

<%
	String sTitre;
	String sInitial;
	String sJobId="xSuiviActivites";
	String codsg;
	String codsg_defaut=((com.socgen.bip.user.UserBip)session.getAttribute("UserBip")).getDpg_Defaut();
	String p_global=((com.socgen.bip.user.UserBip)session.getAttribute("UserBip")).getInfosUser();
	
	if(codsg_defaut.substring(5,7).equals("00"))  
		        codsg_defaut = "";
%>
<%
	Hashtable hKeyList= new Hashtable();
	java.util.ArrayList	listeScenario;
	
    if(extractionForm.getP_param6() != null)
	{
		codsg = extractionForm.getP_param6();
		if(codsg.equals(""))  
		{
		  pageContext.setAttribute("listeScenario", new ArrayList());
		}
		else  
		{     
		        
		
	     	hKeyList.put("codsg", ""+codsg);
		    hKeyList.put("userid", ""+((com.socgen.bip.user.UserBip)session.getAttribute("UserBip")).getInfosUser());
		
		    try { 
	            listeScenario = listeDynamique.getListeDynamique("scenarios", hKeyList);
	            pageContext.setAttribute("listeScenario", listeScenario);
            } catch (Exception e) {
               pageContext.setAttribute("listeScenario", new ArrayList());
               %>alert("<%= listeDynamique.getErrorBaseMsg()%>");<%
                  
            }
		}
	}
	else
	{
		if(codsg_defaut.equals(""))
		{
	    	 pageContext.setAttribute("listeScenario", new ArrayList());
		}
		else
		{
		   hKeyList.put("codsg", ""+codsg_defaut);
	   	   hKeyList.put("userid", ""+((com.socgen.bip.user.UserBip)session.getAttribute("UserBip")).getInfosUser());
		
		   try { 
	        listeScenario = listeDynamique.getListeDynamique("scenarios", hKeyList);
	            pageContext.setAttribute("listeScenario", listeScenario);
           } catch (Exception e) {
               pageContext.setAttribute("listeScenario", new ArrayList());
               if(!codsg_defaut.equals(""))
               {
                   codsg_defaut = codsg_defaut;
                   %>alert("<%= listeDynamique.getErrorBaseMsg()%>");<%
               }
           }
		
		}
		
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
	
	
		if (Message != "") 
	{
		alert(Message);
	}
	else
	{
		var p_param6Form = "<bean:write name="extractionForm"  property="p_param6" />";
		if(p_param6Form == "")
		{
			document.forms[0].p_param6.value = "<%= codsg_defaut %>";
			
		}
		
		if (Focus != "")
		{ 
			(eval( "document.forms[0]."+Focus )).focus();
		}
   		else 
   		{
	  		document.forms[0].p_param6.focus();
   		}
   	}

}
function Verifier(form, bouton, flag)
{
form.action.value=bouton;
}

function ValiderEcran(form)
{
	if (!ChampObligatoire(form.p_param6, "un code DPG")) return false;
	if (!ChampScenario(form.p_param7))
    { 
	     // document.forms[0].submit();
	      return false;
	}
	      	
	document.forms[0].submit.disabled = true;
	return true;
}


function ChangeDpg(codsg)
{

	if ((codsg==""))
	{
	     alert("code dpg vide" + codsg);
	    // document.extractionForm.p_param6.value = document.forms[0].p_param8.value;
	     return false;
	 }
	else
	{
    	if(VerifierCDDPG(codsg))
	    {
   		   urlReload ="/xDetailReestime.do?action=refresh&jobId=<%= sJobId %>&p_global=<%=p_global%>&pageAide=<%= sPageAide %>&indexMenu=<%= sPageAide %>&p_param6="+document.forms[0].p_param6.value;
		   location.replace(urlReload);
		}
		else
		{ 
			document.extractionForm.p_param6.value = document.forms[0].p_param8.value;
	    	return false;
		}
	}
	
}</script>

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
		  <html:form action="/extract"  onsubmit="return ValiderEcran(this);">
		  		
            
<html:hidden property="arborescence" value="<%= arborescence %>"/>
<input type="hidden" name="jobId" value="<%=sJobId%>">
				
            <input type="hidden" name="initial" value="<%= sInitial %>">
            <input type="hidden" name="p_param8" value="<%= codsg_defaut %>">
            <input type="hidden" name="p_global" value="<%= p_global %>">
            <input type="hidden" name="action" value="refresh">
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
						<td class="lib"><B>Code DPG :</B></td>
						<td><html:text property="p_param6" styleClass="input"  size="7" maxlength="7" onchange="return ChangeDpg(this);"/></td>
					</tr>
                <tr> 
                  <td>&nbsp;</td>
                  <td>&nbsp;</td>
                </tr>
                <tr>
                	<td class="lib"><B>Sc&eacute;nario : </B></td>
                    <td align=left>
                    	<html:select property="p_param7" styleClass="input" size="1"> 
                    			<html:options collection="listeScenario" property="cle" labelProperty="libelle" />
                      	</html:select>	
					</td>
                </tr>
                <tr> 
                  <td>&nbsp;</td>
                  <td>&nbsp;</td>
                </tr>
              </table>
             </div>
          </td>
        </tr>
        <tr> 
          <td align="center"> 
            <table width="100%" border="0">
              <tr> 
                <td align="center"> 
                	<input type="submit" name="valider" value="Valider" styleClass="input" onclick="Verifier(this.form, 'liste', true);" > 
                </td>
              </tr>
            </table>
            </html:form>
          </td>
        </tr>
        <tr> 
          <td>&nbsp; </td>
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