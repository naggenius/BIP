 
<%@ taglib uri="/WEB-INF/struts-bean.tld" prefix="bean" %>
<%@ taglib uri="/WEB-INF/struts-html.tld" prefix="html" %>
<%@ taglib uri="/WEB-INF/struts-logic.tld" prefix="logic" %>

<%@ page language="java" import="org.owasp.esapi.ESAPI,java.sql.*,java.io.*,java.lang.*,java.util.*,javax.servlet.*,javax.servlet.http.*,com.socgen.ich.ihm.*" errorPage="../jsp/erreur.jsp"  %>
<jsp:useBean id="saisieReesForm" scope="request" class="com.socgen.bip.form.SaisieReesForm" />
<jsp:useBean id="listeDynamique" scope="request" class="com.socgen.bip.commun.liste.ListeDynamique" />
<html:html locale="true"> 
 
<head>
 

<%@ taglib uri="/WEB-INF/bip.tld" prefix="bip" %>

<title>Outil de r&eacute;estim&eacute;</title>

<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">

<bip:VerifUser page="/saisieRees.do"/> 
<script language="JavaScript" src="../js/function.cjs"></script>
<link rel="stylesheet" href="../css/base_style.css" type="text/css">
<link rel="stylesheet" href="../css/style_bip.css" type="text/css">
<script language="JavaScript">
var blnVerification = true;
<%
	String arborescence = ESAPI.encoder().encodeForJavaScript(ESAPI.encoder().canonicalize(request.getParameter("arborescence")));
String sPageAide = ESAPI.encoder().encodeForJavaScript(ESAPI.encoder().canonicalize(request.getParameter("pageAide")));  
	String sIndexMenu = ESAPI.encoder().encodeForJavaScript(ESAPI.encoder().canonicalize(request.getParameter("indexMenu")));
%>
var pageAide = "<%= sPageAide %>";

<%

    String codsg;
	String codsg_defaut=((com.socgen.bip.user.UserBip)session.getAttribute("UserBip")).getDpg_Defaut();
	
	if(codsg_defaut.substring(5,7).equals("00"))  
		        codsg_defaut = ""; 

	Hashtable hKeyList= new Hashtable();
	/* si on a dans l'url le paramÃ¨tre CODSG c'est qu'on vient de recharger la page suite Ã  un changement de DPG */	
	
	if ( (ESAPI.encoder().encodeForJavaScript(ESAPI.encoder().canonicalize(request.getParameter("codsg"))) != null) && (!ESAPI.encoder().encodeForJavaScript(ESAPI.encoder().canonicalize(request.getParameter("codsg"))).trim().equals("")) ) {
		saisieReesForm.setCodsg(ESAPI.encoder().encodeForJavaScript(ESAPI.encoder().canonicalize(request.getParameter("codsg"))));
		/* on repositionne les 2 listes ressource et scÃ©nario au dÃ©but de la liste */
		session.setAttribute("POSSCEN", "0");
		session.setAttribute("POSITION", "0");
	} else if ((session.getAttribute("CODSG")!=null) && (!session.getAttribute("CODSG").equals(""))) {
		try {
			saisieReesForm.setCodsg((String) session.getAttribute("CODSG"));
		} catch (Exception e) {}
		
	}
	
	if((saisieReesForm.getCodsg() != null)&&(!(saisieReesForm.getCodsg().trim().equals("")))) {
		codsg = saisieReesForm.getCodsg();
		hKeyList.put("codsg", ""+saisieReesForm.getCodsg());
	} else {
		codsg = codsg_defaut;
		hKeyList.put("codsg", ""+codsg_defaut);
	}
	
	hKeyList.put("userid", ""+((com.socgen.bip.user.UserBip)session.getAttribute("UserBip")).getInfosUser());
	
	try {	
		
	    ArrayList listeScenario = listeDynamique.getListeDynamique("scenariossaisie", hKeyList);
	    pageContext.setAttribute("choixScenario", listeScenario);
	    	    
	    ArrayList listeRessource = listeDynamique.getListeDynamique("ressdpg", hKeyList);
	    pageContext.setAttribute("choixRessource", listeRessource);
	  	        
	}   
      catch (Exception e) {
	    pageContext.setAttribute("choixScenario", new ArrayList());
	    pageContext.setAttribute("choixRessource", new ArrayList());
	    if(!codsg.equals(""))
         {
                   codsg_defaut = codsg_defaut;
                   %>alert("<%= listeDynamique.getErrorBaseMsg()%>");<%
         }
	   
    }
    
%>

function MessageInitial()
{

   var Message="<bean:write filter="false"  name="saisieReesForm"  property="msgErreur" />";
   var Focus = "<bean:write name="saisieReesForm"  property="focus" />";
   var position ="<%=session.getAttribute("POSITION")%>";
   var posscen ="<%=session.getAttribute("POSSCEN")%>";
	
	if (document.forms[0].code_scenario.value == "ERREUR")
		alert("Code/département/pôle/groupe par defaut inexistant");
	
	
	if (Message != "") 
	{
		alert(Message);
		
	}
	else
	{
		var p_codsg = "<bean:write name="saisieReesForm"  property="codsg" />";
		if ((p_codsg == "") && (document.forms[0].codsg.value == "") )
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
   
   
	if (document.forms[0].ident.length-1>=parseInt(position))
		document.forms[0].ident.selectedIndex=parseInt(position)+1;

	if (document.forms[0].code_scenario.length-1>=parseInt(posscen))
		document.forms[0].code_scenario.selectedIndex=parseInt(posscen);

	document.forms[0].old_codsg.value = document.forms[0].codsg.value;
   
}

function Verifier(form, action, flag)
{
  blnVerification = flag;
  form.action.value = "modifier";
}


function ValiderEcran(form)
{

	if (!ChampObligatoire(form.codsg, "un code DPG")) return false;
	if (!ChampScenario(form.code_scenario,form.codsg)) return false;
	if (!ChampIdent(form.ident,form.codsg)) return false;
		if (document.forms[0].code_scenario.value == "ERREUR")
		{
		alert("Code/département/pôle/groupe par defaut inexistant");
		return false;
		}
	
	form.type_ress.value = form.ident.value;
	form.position.value = form.ident.selectedIndex;
	form.posScen.value = form.code_scenario.selectedIndex;
	
	return true;
	
}

function ChangeDpg(codsg)
{

    if(VerifierCDDPG(codsg))
    {
    	//alert("dpg change");
    	//document.forms[0].action.value="initialiser";
        //document.forms[0].submit();
        
      
	   urlReload ="/saisieRees.do?action=initialiser&pageAide=<%= sPageAide %>&indexMenu=<%= sPageAide %>&codsg="+document.forms[0].codsg.value;
	    
	    //alert("apres"+urlReload);
        location.replace(urlReload);
	    
       
        
	    return true;
	}
	else
	{ 
		document.forms[0].codsg.value = document.forms[0].old_codsg.value;
	    return false;
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
            <div align="center">
              <%ToolBar tb = new com.socgen.ich.ihm.ToolBar("bip_ihm",false,false,true,false,false,false,false,false,false,request) ;%>
              <%=tb.printHtml()%></div>
          </td>
        </tr>
        <tr> 
          <td>&nbsp;</td>
        </tr>
        <tr> 
          <td background="../images/ligne.gif"></td>
        </tr>
        <tr> 
          <td height="20" class="TitrePage">
          	Saisie du R&eacute;estim&eacute;
          </td>
        </tr>
        <tr> 
          <td background="../images/ligne.gif"></td>
        </tr>
        <tr> 
          <td>
          <html:form action="/saisieRees"  onsubmit="return ValiderEcran(this);" target="_top"><!-- #EndEditable --> 
            <div align="center">
            <input type="hidden" name="pageAide" value="<%= sPageAide %>">
            <input type="hidden" name="indexMenu" value="<%= sIndexMenu %>">
			<input type="hidden" name="action" value="suite"> 
			<input type="hidden" name="old_codsg" value="">
			
<html:hidden property="arborescence" value="<%= arborescence %>"/> 
            <html:hidden property="type_ress"/> <!--type de la ressource-->
            <html:hidden property="position"/> <!--position de la ressource dans la liste-->
            <html:hidden property="posScen"/> <!--position du sÃ©nario dans la liste-->
			
			<table border="0"  cellpadding="2" cellspacing="2" class="TableBleu" >
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
                    <td align="left"><html:text property="codsg" styleClass="input" size="7" maxlength="7" onchange="return ChangeDpg(this);"/></td>
                </tr>
                <tr> 
                  <td>&nbsp;</td>
                  <td>&nbsp;</td>
                </tr>
	            <tr>
					<td class="lib"><b>Sc&eacute;nario : </b></td>
                    <td align="left">
	               		<html:select property="code_scenario" size="1" styleClass="input">
							<html:options collection="choixScenario" property="cle" labelProperty="libelle"/>
						</html:select>
					</td>		
				</tr>	
                <tr> 
                  <td>&nbsp;</td>
                  <td>&nbsp;</td>
                </tr>
	            <tr>
					<td class="lib"><b>Ressource : </b></td>
					<td align="left">
	               		<html:select property="ident" size="1" styleClass="input">
							<html:options collection="choixRessource" property="cle" labelProperty="libelle"/>
						</html:select>
					</td>		
				</tr>	
                <tr> 
                  <td>&nbsp;</td>
                  <td>&nbsp;</td>
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
</body></html:html>
