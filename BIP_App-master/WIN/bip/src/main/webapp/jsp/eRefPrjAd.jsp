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

<bip:VerifUser page="jsp/eRefPrjAd.jsp"/>
<script language="JavaScript" src="../js/function.cjs"></script>
<link rel="stylesheet" href="../css/base_style.css" type="text/css">
<link rel="stylesheet" href="../css/style_bip.css" type="text/css">

<jsp:useBean id="UserBip" scope="session" class="com.socgen.bip.user.UserBip" />
<%
	java.util.Hashtable hP = new java.util.Hashtable();
	hP.put("userid", ((com.socgen.bip.user.UserBip)session.getAttribute("UserBip")).getInfosUser());
	java.util.ArrayList list1 = new com.socgen.bip.commun.liste.ListeDynamique().getListeDynamique("dprojet_par_code01",hP); 
	pageContext.setAttribute("choixDProjet01", list1);
	
	java.util.Hashtable hP2 = new java.util.Hashtable();
	hP2.put("userid", ((com.socgen.bip.user.UserBip)session.getAttribute("UserBip")).getInfosUser());
	java.util.ArrayList list2 = new com.socgen.bip.commun.liste.ListeDynamique().getListeDynamique("dprojet_par_code02",hP2); 
	pageContext.setAttribute("choixDProjet02", list2);
%>	
		
<script language="JavaScript">
var pageAide = "aide/hvide.htm";
var blnVerification = true;
var choixEffectue = false;
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
	String sJobId="eRefPrjAd";
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
}

function Verifier(form, bouton, flag)
{
  blnVerification = flag;
}

function ChangeReport(newRep){
	if (newRep=="1")
	{
		sJobId="eRefFicPrjAd";
		document.forms[0].jobId.value="eRefFicPrjAd";
	} 
	if (newRep=="2")
	{
		sJobId="eRefLisPrjAd";
		document.forms[0].jobId.value="eRefLisPrjAd";
	} 
	if (newRep=="3")
	{
		sJobId="eRefPrjAd";
		document.forms[0].jobId.value="eRefPrjAd";
	}
	choixEffectue = true;
	ChangeAff(newRep);
}

function ChangeAff(newAff){
	document.forms[0].p_param7.style.display="none";
	document.forms[0].p_param8.style.display="none";
	document.forms[0].p_param9.style.display="none";
	if (newAff=="1") document.forms[0].p_param7.style.display="";
	if (newAff=="2") document.forms[0].p_param8.style.display="";
	if (newAff=="3") document.forms[0].p_param9.style.display="";
}

function ValiderEcran(form)
{
   if (blnVerification)
   {
   		if (!choixEffectue)
		{
			alert("Vous devez choisir une édition.") ;
			return false;
		}
		
		for (var i=0; i<form.choix.length;i++)
		{
    		if (form.choix[i].checked)
    		{
    	//Contrôles de saisie des paramètres associés à l'édition	
    			if (((form.choix[i].value=="1")&&(document.forms[0].p_param7.value=="")))
				{
					alert('Vous devez saisir un code Projet.');
					return false;
				}
				if (((document.forms[0].choix[i].value=="2")&&(document.forms[0].p_param8.value=="AUCUN"))||((document.forms[0].choix[i].value=="3")&&(document.forms[0].p_param9.value=="AUCUN")))
				{
					alert('Vous devez saisir un code Dossier Projet.');
					return false;
				}
		//Contrôles de cohérence
				if ((document.forms[0].choix[i].value=="3")&&(document.forms[0].p_param9.value=="TOUS"))
				{
					alert('Vous ne pouvez pas choisir la valeur TOUS pour lancer cet état!');
					return false;
				}
        		if ( !VerifFormat(null) ) return false;
        //Alimentation des paramètres de sortie pour lancer l'édition	
        		if (document.forms[0].choix[i].value=="1")
				{
					document.forms[0].p_param6.value=document.forms[0].p_param7.value;
					document.forms[0].p_param10.value="1";
				}
				if (document.forms[0].choix[i].value=="2")
				{
					document.forms[0].p_param6.value=document.forms[0].p_param8.value;
					document.forms[0].p_param10.value="2";
				}
				if (document.forms[0].choix[i].value=="3")
				{
					document.forms[0].p_param6.value=document.forms[0].p_param9.value;
					document.forms[0].p_param10.value="3";				
				}
				if (!ChampObligatoire(form.p_param6, "un code dossier projet ou projet. ")) return false;
    		} // END - IF (form.choix[i].checked)
		} // END - FOR
   } // END - IF (blnVerification) 
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
          <td>&nbsp;</td>
        </tr>
        <tr> 
          <td>
		  <html:form action="/edition"  onsubmit="return ValiderEcran(this);">
            
<html:hidden property="arborescence" value="<%= arborescence %>"/>
<input type="hidden" name="jobId" value="<%=sJobId%>">
            <input type="hidden" name="initial" value="<%= sInitial %>">
            <html:hidden property="p_param6"/>
            <html:hidden property="p_param10"/>
            <table width="100%" border="0">
                <tr> 
                  <td> 
                    <div align="center">
					<table border="0" cellspacing=2 cellpadding=2 class="tableBleu">
						<input type="hidden" name="pageAide" value="<%= sPageAide %>">
					  <tr>
                        <td colspan=5 align="center">&nbsp;</td>
                      </tr>
					  <tr>
						<td>
							<input type="radio" name="choix" styleClass="input" value="1" onclick="ChangeReport(this.value);" >	
						</td>
						<td class="lib"><B>&nbsp;Edition Fiche Projet :&nbsp;</B></td>
						<td colspan=3 width="60%">
							<html:text property="p_param7" styleClass="input" style="display='none'" size="8" maxlength="5" onchange="return VerifierAlphaMax(this);"/>
						</td>
					  </tr>
					  <tr>
						<td>
							<input type="radio" name="choix" styleClass="input" value="2" onclick="ChangeReport(this.value);" >	
						</td>
						<td class="lib"><B>&nbsp;Edition Liste des sous projets :&nbsp;</B></td>
						<td colspan=3 width="60%">
							<html:select property="p_param8" styleClass="input" style="display='none'"> 
   								<html:options collection="choixDProjet01" property="cle" labelProperty="libelle" />
					  		</html:select>
						</td>
					  </tr>
					  <tr>
						<td>
							<input type="radio" name="choix" styleClass="input" value="3" onclick="ChangeReport(this.value);" >	
						</td>
						<td class="lib"><B>&nbsp;Edition Lignes classées par Projets :&nbsp;</B></td>
						<td colspan=3 width="60%">
							<html:select property="p_param9" styleClass="input" style="display='none'"> 
   								<html:options collection="choixDProjet02" property="cle" labelProperty="libelle" />
					  		</html:select>
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