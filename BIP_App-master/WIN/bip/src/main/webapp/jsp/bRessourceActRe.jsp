<%@ taglib uri="/WEB-INF/struts-bean.tld" prefix="bean" %>
<%@ taglib uri="/WEB-INF/struts-html.tld" prefix="html" %>
<%@ taglib uri="/WEB-INF/struts-logic.tld" prefix="logic" %>

<%@ page language="java" import="org.owasp.esapi.ESAPI,java.sql.*,java.io.*,javax.servlet.*,java.util.*,javax.servlet.http.*,com.socgen.ich.ihm.*,java.util.Hashtable"    errorPage="../jsp/erreur.jsp"  %>
<jsp:useBean id="ressActForm" scope="request" class="com.socgen.bip.form.RessActForm" />
<jsp:useBean id="listeDynamique" scope="request" class="com.socgen.bip.commun.liste.ListeDynamique" />

<html:html locale="true">
<head>
 

<%@ taglib uri="/WEB-INF/bip.tld" prefix="bip" %>

<title>Outil de r&eacute;estim&eacute;</title>

<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">

<bip:VerifUser page="jsp/bRessourceActRe.jsp"/>
<script language="JavaScript" src="../js/function.cjs"></script>
<jsp:useBean id="UserBip" scope="session" class="com.socgen.bip.user.UserBip" />
<link rel="stylesheet" href="../css/base_style.css" type="text/css">
<link rel="stylesheet" href="../css/style_bip.css" type="text/css">
<script language="JavaScript">
<%
	String arborescence = ESAPI.encoder().encodeForJavaScript(ESAPI.encoder().canonicalize(request.getParameter("arborescence")));
String sPageAide = ESAPI.encoder().encodeForJavaScript(ESAPI.encoder().canonicalize(request.getParameter("pageAide")));
%>
var pageAide = "<%= sPageAide %>";
	
<%
    String codsg;
	String codsg_defaut=((com.socgen.bip.user.UserBip)session.getAttribute("UserBip")).getDpg_Defaut();
	
	
	Hashtable hKeyList= new Hashtable();
	
	if(codsg_defaut.substring(5,7).equals("00"))  
		        codsg_defaut = "";
	
	if((ressActForm.getCodsg() != null)&&(!(ressActForm.getCodsg().trim().equals(""))))
	{
		codsg = ressActForm.getCodsg();
		hKeyList.put("codsg", ""+ressActForm.getCodsg());
		
	}	
	else
	{
		codsg = codsg_defaut;
		hKeyList.put("codsg", ""+codsg_defaut);
	}
	hKeyList.put("userid", ""+((com.socgen.bip.user.UserBip)session.getAttribute("UserBip")).getInfosUser());
	
	try { 
	java.util.ArrayList listeRess = listeDynamique.getListeDynamique("ressact", hKeyList);
	
	pageContext.setAttribute("listeRess", listeRess);
	
	} catch (Exception e) {
        pageContext.setAttribute("listeRess", new ArrayList());
        if(!codsg.equals(""))
         {
                   codsg_defaut = codsg_defaut;
                   %>alert("<%= listeDynamique.getErrorBaseMsg()%>");<%
         }
	}
 %>
function MessageInitial()
{
	var Message="<bean:write filter="false"  name="ressActForm"  property="msgErreur" />";
	var Focus = "<bean:write name="ressActForm"  property="focus" />";

	if (Message != "") 
	{
		alert(Message);
	}
	else
	{
		var codsgForm = "<bean:write name="ressActForm"  property="codsg" />";
		if(codsgForm == "")
		{
			document.forms[0].codsg.value = "<%= codsg_defaut %>";
		}
		
		if (Focus != "")
		{ 
			(eval( "document.forms[0]."+Focus )).focus();
		}
   		else 
   		{
	  		document.forms[0].codsg.focus();
   		}
	}
}

function Verifier(form, bouton, flag)
{
}

function ChangeDpg(value)
{
if(VerifierCDDPG(value))
	{
	   rafraichir(document.forms[0]);
	   return true;
	}
	else
	{ 
		document.forms[0].codsg.value = "<%= codsg_defaut %>";
	    return false;
	}
	
}

function ValiderEcran(form)
{
	if (!ChampObligatoire(form.codsg, "un code DPG")) return false;
	if (!ChampObligatoire(form.code_ress, "un code ressource"))
	{ 
	      //document.forms[0].submit();
	      return false;
	}
	return true;
}

function test_touche_entree(){
	if(window.event.keyCode == 13){
				window.event.returnValue = false;	
				if(VerifierCDDPG(document.forms[0].codsg))
				{
				   rafraichir(document.forms[0]);
				   return true;
				}
				else
				{ 
					document.forms[0].codsg.value = "<%= codsg_defaut %>";
				    return false;
				}
	}
}


document.onkeypress = test_touche_entree;


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
          <td height="20" class="TitrePage">Gestion Ressources-Activit&eacute;s</td>
        </tr>
        <tr> 
          <td background="../images/ligne.gif"></td>
        </tr>
        <tr> 
          <td> 
          	<html:form action="/ressAct"  onsubmit="return ValiderEcran(this);">
            <div align="center">
			  <input type="hidden" name="pageAide" value="<%= sPageAide %>">
			<input type="hidden" name="action" value="suite">
			
<html:hidden property="arborescence" value="<%= arborescence %>"/> 
			  
              <table border=0  cellpadding=2 cellspacing=2 class="tableBleu">
                <tr> 
                  <td>&nbsp;</td>
                  <td >&nbsp;</td>
                </tr>
                <tr> 
                  <td >&nbsp;</td>
                  <td>&nbsp;</td>
                </tr>
                <tr>
					<td class="lib"><B>Code DPG : </B></td>
                    <td align=left><html:text property="codsg" styleClass="input" size="7" maxlength="7"  onchange="return ChangeDpg(this);"/></td>
                </tr>
                <tr> 
                  <td>&nbsp;</td>
                  <td>&nbsp;</td>
                </tr>
                <logic:present name="listeRess">
	                <tr>
						<td class="lib"><B>Ressource : </B></td>
	                    <td align=left>
	                    	<html:select property="code_ress" styleClass="input" size="1"> 
	                    		<html:options collection="listeRess" property="cle" labelProperty="libelle" /> 
	                      	</html:select>	
						</td>
	                </tr>
                </logic:present>
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
                <td align="center"> <html:submit property="boutonValider" value="Valider" styleClass="input" onclick="Verifier(this.form, 'suite', true);"/> 
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