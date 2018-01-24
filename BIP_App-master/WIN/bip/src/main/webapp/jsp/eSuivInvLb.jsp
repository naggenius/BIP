
<%@ taglib uri="/WEB-INF/struts-bean.tld" prefix="bean" %>
<%@ taglib uri="/WEB-INF/struts-html.tld" prefix="html" %>
<%@ taglib uri="/WEB-INF/struts-logic.tld" prefix="logic" %>
<!-- #BeginEditable "imports" --> 
<%@ page language="java" import="org.owasp.esapi.ESAPI,java.sql.*,java.util.*,java.io.*,javax.servlet.*,javax.servlet.http.*,com.socgen.ich.ihm.*"    errorPage="../jsp/erreur.jsp"  %>
<jsp:useBean id="suivInvEditionForm" scope="request" class="com.socgen.bip.form.SuivInvEditionForm" />
<jsp:useBean id="listeCA" scope="request" class="com.socgen.bip.commun.liste.ListeCentreActivite" />
<html:html locale="true">
<!-- #EndEditable --> 

<!-- #BeginTemplate "/Templates/Page_edition.dwt" --><head>


<%@ taglib uri="/WEB-INF/bip.tld" prefix="bip" %>

<!-- #BeginEditable "doctitle" --> 
<title>Edition</title>
<!-- #EndEditable -->
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">

<!-- #BeginEditable "fichier" --> 
<bip:VerifUser page="jsp/eSuivInvLb.jsp"/>
<jsp:useBean id="UserBip" scope="session" class="com.socgen.bip.user.UserBip" />
<script language="JavaScript" src="../js/function.cjs"></script>
<link rel="stylesheet" href="../css/base_style.css" type="text/css">
<link rel="stylesheet" href="../css/style_bip.css" type="text/css">
<script language="JavaScript">
var pageAide = "aide/hvide.htm";
var blnVerification = true;
var anneeCourante = '<bip:value champ="to_char(datdebex, 'YYYY')" table="datdebex" clause1="1" clause2="1" />';
<%
	String arborescence = ESAPI.encoder().encodeForJavaScript(ESAPI.encoder().canonicalize(request.getParameter("arborescence")));
String sPageAide = ESAPI.encoder().encodeForJavaScript(ESAPI.encoder().canonicalize(request.getParameter("pageAide")));
%>
var pageAide = "<%= sPageAide %>";

var blnVerifFormat  = true;
var tabVerif        = new Object();
var sListe = "";


<%
	String sTitre;
	String sInitial;
	String sJobId="eSuivInvLb";
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
	
	
	
	var Message="<bean:write filter="false"  name="suivInvEditionForm"  property="msgErreur" />";
	var Focus = "<bean:write name="suivInvEditionForm"  property="focus" />";
	
	if (Message != "") {
		alert(Message);
	}

	if (Focus != "") {
		if (eval( "document.forms[0]."+Focus )){
			(eval( "document.forms[0]."+Focus )).focus();
		}
	}
	
	//document.forms[0].p_param7.value = anneeCourante;
}

function Verifier(form, bouton, flag)
{
  blnVerification = flag;
  //form.BOUTON.value = bouton;
}

function majListe()
{
	sListe = "";
	
	if (document.ckF.ck1.checked)
	{
		sListe="1";
	}
	
	if (document.ckF.ck2.checked)
	{
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
	if (document.ckF.ck4.checked)
	{
		if (sListe == "")
			sListe="4";
		else
			sListe = sListe + ";4";
	}
	if (document.ckF.ck5.checked)
	{
		if (sListe == "")
			sListe="5";
		else
			sListe = sListe + ";5";
	}
	document.suivInvEditionForm.listeReports.value = sListe;
}

function ValiderEcran(form)
{ 
	form.codcamo.value = form.p_param6.value;
	if (blnVerification)
	{
		if ( !VerifFormat(null) ) return false;
		if (!ChampObligatoire(form.p_param7, "l'année d'exercice")) return false;		
		if (sListe == "")
		{
			alert("Vous devez cocher au moins une case") ;
			return false;
		}
		if (form.chk8.checked) { 
		form.p_param8.value='O';
		}
		else { form.p_param8.value='N';}


	}
	//form.VerifExecJS.value = 1;
	document.editionForm.submit.disabled = true;
	return true;
}

</script>
<!-- #EndEditable --> 


</head>
<%
  String annee = com.socgen.bip.commun.Tools.getStrDateAAAA(0);
  request.setAttribute("p_param7", annee);
  
  com.socgen.bip.user.UserBip userbip = (com.socgen.bip.user.UserBip)session.getAttribute("UserBip");  

	String ca_suivi="";
	Vector v = new Vector();
	v=userbip.getCa_suivi();

	for (Enumeration e = v.elements(); e.hasMoreElements();) {
		ca_suivi +=',' +(String) e.nextElement();
	}
	java.util.Hashtable hP = new java.util.Hashtable();
	hP.put("ca_suivi", ca_suivi);

  java.util.ArrayList liste = new com.socgen.bip.commun.liste.ListeDynamique().getListeDynamique("ca_inv_g",hP); 
  pageContext.setAttribute("choixCA", liste); 
%>

<body bgcolor="#FFFFFF" text="#000000" topmargin="0" leftmargin="0" onLoad="MessageInitial();ChargeCa('<%=userbip.getCodcamoCourant()%>','p_param6',document.forms[1])">
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
          <td height="20" class="TitrePage"><!-- #BeginEditable "titre_page" --><%=sTitre%><!-- #EndEditable --></td>
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
		  <!-- #BeginEditable "debut_form" -->
			<div align=center>
				<form name ="ckF" action="">
				<table border=0 cellspacing=5 cellpadding=0 class="tableBleu">
						<tr><td colspan=5 align="center">&nbsp;</td></tr>
						<tr>
							<td class="lib" nowrap><B>Synth&egrave;se par poste :</B></td>
							<td><input type="checkbox" name="ck1" value="1" onChange="majListe();"></td>
						</tr>
						<tr>
							<td class="lib" nowrap><B>Synth&egrave;se par projet :</B></td>
							<td><input type="checkbox" name="ck2" value="2" onChange="majListe();"></td>
						</tr>
						<tr>
							<td class="lib" nowrap><B>Synth&egrave;se par nature :</B></td>
							<td><input type="checkbox" name="ck3" value="3" onChange="majListe();"></td>
						</tr>
						<tr>
							<td class="lib" nowrap><B>D&eacute;tail engagement :</B></td>
							<td><input type="checkbox" name="ck4" value="4" onChange="majListe();"></td>
						</tr>
						<tr>
							<td class="lib" nowrap><B>Proposition de budget :</B></td>
							<td><input type="checkbox" name="ck5" value="5" onChange="majListe();"></td>
						</tr>
					</table>
				</form>
			</div>
		 
		<html:form action="/suivinvedition"  onsubmit="return ValiderEcran(this);"><!-- #EndEditable -->
			<!-- #BeginEditable "debut_hidden" -->
            
<html:hidden property="arborescence" value="<%= arborescence %>"/>
<input type="hidden" name="jobId" value="<%=sJobId%>">
			<input type="hidden" name="listeReports">
			<input type="hidden" name="p_param8" value="N"/>
            <input type="hidden" name="initial" value="<%= sInitial %>">
			<!-- #EndEditable -->
            <table width="100%" border="0">
              
                <tr> 
                  <td> 
                    <div align="center">
					<table border=0 cellspacing=5 cellpadding=0 class="tableBleu">
					<!-- #BeginEditable "contenu" -->
<input type="hidden" name="pageAide" value="<%= sPageAide %>">
					<tr>
                        <td colspan=5 align="center">&nbsp;</td>
                    		</tr>
                    		<tr>
				<td class="lib"><b>Centre d'activit&eacute; :</b></td>
				<td> <html:select property="p_param6" styleClass="input"> 
				<html:options collection="choixCA" property="cle" labelProperty="libelle" />
				</html:select>  <html:hidden property="codcamo"/>   
				</td>
				</tr>
				<tr>
				<td class="lib"><b>Exercice :</b></td>
				<td>                        	
				 <html:text property="p_param7" styleClass="input" size="4" maxlength="4" onchange="return VerifierDate(this,'aaaa');"/>                  			
				</td>
				</tr>
				<tr><td class="lib"><b>D&eacute;tail : </b></td>
					<td colspan=1><input type=checkbox name="chk8"></td>
				</tr>
				
					

					<tr><td colspan=5 align="center">&nbsp;</td></tr>
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
				  <html:submit value="Liste" styleClass="input" onclick="Verifier(this.form, 'liste', true);"/>
                  </div>
                  </td>
                </tr>
            
            </table>
			  <!-- #BeginEditable "fin_form" --></html:form><!-- #EndEditable -->
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

<!-- #EndTemplate -->