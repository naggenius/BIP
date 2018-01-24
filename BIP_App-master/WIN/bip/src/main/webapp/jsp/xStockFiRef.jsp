<%@ taglib uri="/WEB-INF/struts-bean.tld" prefix="bean" %>
<%@ taglib uri="/WEB-INF/struts-html.tld" prefix="html" %>
<%@ taglib uri="/WEB-INF/struts-logic.tld" prefix="logic" %>
<!-- #BeginEditable "imports" --> 
<%@ page language="java" import="org.owasp.esapi.ESAPI,java.sql.*,java.io.*,javax.servlet.*,javax.servlet.http.*,com.socgen.ich.ihm.*,java.util.Vector,com.socgen.bip.commun.BIPActionMapping,com.socgen.bip.commun.BipConstantes,com.socgen.bip.commun.form.BipForm,com.socgen.bip.log4j.BipUsersAppender,com.socgen.bip.user.UserBip,com.socgen.cap.fwk.ServiceManager,com.socgen.cap.fwk.log.Log"    errorPage="../jsp/erreur.jsp"  %>
<jsp:useBean id="extractionForm" scope="request" class="com.socgen.bip.commun.form.ExtractionForm" />
<%@page import="org.owasp.esapi.ESAPI,org.apache.commons.lang.StringUtils"%>
<html:html locale="true">
<!-- #EndEditable --> 

<head>


<%@ taglib uri="/WEB-INF/bip.tld" prefix="bip" %>

<!-- #BeginEditable "doctitle" --> 
<title>Extraction</title>
<!-- #EndEditable -->
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">

<!-- #BeginEditable "fichier" -->
<bip:VerifUser page="jsp/xStockFiRef.jsp"/>
<%
	com.socgen.bip.user.UserBip userbip = (com.socgen.bip.user.UserBip)session.getAttribute("UserBip");  

	java.util.Hashtable hP = new java.util.Hashtable();
	java.util.Hashtable hP1 = new java.util.Hashtable();
	java.util.Hashtable hP2 = new java.util.Hashtable();
	
	String sLogCat = "BipUser";
	Log logBipUser = ServiceManager.getInstance().getLogManager().getLogInstance(sLogCat);
//	int role = 0; // role = 0 => client ,role = 1 => fournisseur
	String ca_payeur="";
	String ca_da="";
	String ca_fi="";
	Vector v = new Vector();
	//Vector Vperimo = new Vector();
	String perimo = "";
	//Vector Vperime = new Vector();
	String sListeId = "";
	String sMenuId = "";
	
	//Vperime = userbip.getPerim_ME();
	//Vperimo = userbip.getPerim_MO();

	sListeId = userbip.getsListeMenu();
	//int etape = 2; //------numéro étape-------

	
	
	
	if(!StringUtils.isEmpty(userbip.getCAPayeur())){
		ca_payeur = userbip.getCAPayeur();
	}
	if(!StringUtils.isEmpty(userbip.getCAFI())){
		ca_fi = userbip.getCAFI(); 
	}
	
	
	hP.put("userid", userbip.getInfosUser());
	hP1.put("ca_payeur", ca_payeur);
	hP2.put("ca_payeur", ca_fi);
	
	java.util.ArrayList dossProj = new com.socgen.bip.commun.liste.ListeDynamique().getListeDynamique("dprojet_limitation_ref",hP); 
	pageContext.setAttribute("choixDProjet", dossProj);
	
	java.util.ArrayList projet = new com.socgen.bip.commun.liste.ListeDynamique().getListeDynamique("projet_limitation_ref",hP); 
	pageContext.setAttribute("choixProjet", projet);
	
	java.util.ArrayList appli = new com.socgen.bip.commun.liste.ListeDynamique().getListeDynamique("appli_limitation_ref",hP); 
	pageContext.setAttribute("choixAppli", appli);

	java.util.ArrayList liste = new com.socgen.bip.commun.liste.ListeDynamique().getListeDynamique("ca_utilisateur_rtfe_ref",hP1); 
	pageContext.setAttribute("choixCA", liste); 
	
	java.util.ArrayList liste2 = new com.socgen.bip.commun.liste.ListeDynamique().getListeDynamique("ca_utilisateur_rtfe_ref",hP2); 
	pageContext.setAttribute("choixCAFI", liste2);
%>
<script language="JavaScript" src="../js/function.cjs"></script>
<link rel="stylesheet" href="../css/base_style.css" type="text/css">
<link rel="stylesheet" href="../css/style_bip.css" type="text/css">
<script language="JavaScript">
var blnVerification = true;
var tabVerif = new Object();
<%
	String arborescence = ESAPI.encoder().encodeForJavaScript(ESAPI.encoder().canonicalize(request.getParameter("arborescence")));
String sPageAide = ESAPI.encoder().encodeForJavaScript(ESAPI.encoder().canonicalize(request.getParameter("pageAide")));
%>
var pageAide = "<%= sPageAide %>";
<%
	String sTitre;
	String sInitial;
	String sJobId;
%>


function MessageInitial()
{
<%	
	// La gestion de l affichage des colonnes se fait dans le rdf
	// par le biais du p_param0
	sJobId = "xStockFiAd";
	
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

	var Message="<bean:write filter="false"  name="extractionForm"  property="msgErreur" />";
	var Focus = "<bean:write name="extractionForm"  property="focus" />";

   
   if (Message != "") {
      alert(Message);
   }

	if (Focus != "") {
		if (eval( "document.forms[0]."+Focus )){
			(eval( "document.forms[0]."+Focus )).focus();
		}
	}
	
}

function Verifier(form, flag)
{
  blnVerification = flag;
}
// PPM 58162 - fonction pour empêcher le choix des valeurss --- Habil Directe --- ou --- Habil par DP ---
function selectHabil(){
 if(document.forms[0].p_param8.value == '--- Habil Directe ---' || 
	document.forms[0].p_param8.value == '--- Habil par DP ---' ){
	document.forms[0].p_param8.value = 'TOUS';
	return true;
	}
	return false;
}
// PPM 58162 - Modification de la fonction pour intégrer le contrôle selectHabil() et affichage du message d'erreur
function ValiderEcran(form) {
	
	if ( document.extractionForm.p_param7.value == 'Pas de limitation' 
		&& document.extractionForm.p_param8.value == 'Pas de limitation'
		&& document.extractionForm.p_param9.value == 'Pas de limitation'
		&& document.extractionForm.p_param10.value == 'Pas de limitation'
		&& document.extractionForm.p_param11.value == 'Pas de limitation'							
	) {
		alert('Choisir "Tous", "Toutes", ou un code pour au moins un des critères');
		return false;
	}		
	if(selectHabil()){
		alert('les choix « --- Habil Directe --- » et « --- Habil par DP --- » ne sont pas des valeurs fonctionnelles. \n Merci de sélectionner un code projet');
		return false;
	}
	if ( !confirm("Confirmez-vous la demande d'extraction ?") ) return false;
	document.extractionForm.submit.disabled = true;
	return true;
}

function MAJTypeExtract(typeExtract){
	if (typeExtract == "1"){
		document.extractionForm.p_param6.value=".TXT";
	}
	else document.extractionForm.p_param6.value=".CSV";

	return true;
}
</script>

<!-- #EndEditable --> 


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
            <!-- #BeginEditable "debut_hidden" -->	
            
<html:hidden property="arborescence" value="<%= arborescence %>"/>
<input type="hidden" name="jobId" value="<%=sJobId%>">
            <input type="hidden" name="initial" value="<%= sInitial %>">
            <input type="hidden" name="pageAide" value="<%= sPageAide %>">
            <input type="hidden" name="p_param6" value=".CSV">
			<!-- #EndEditable -->
			

	<table width="80%" border="0" cellspacing="0" cellpadding="0" class="tableBleu" align="center">
		<tr>
			<td align="center">&nbsp;</td>
		</tr>
		<tr>
			<td align="left"><b>Cette extraction prend en compte votre périmètre Dossier projet, projet, application, CAFI et CA payeur.
			</td>
		</tr> 
		<tr>
			<td align="center">&nbsp;</td>
		</tr>
		<tr>
			<td align="left">
			Vous pouvez limiter la demande aux éléments ci-dessous :
			</td>
		</tr>
		<tr>
			<td align="center">&nbsp;</td>
		</tr>
	</table>			
			
	
	<table border=0 class="tableBleu" width="90%" cellspacing="1" align="center" cellpadding="1">
		<input type="hidden" name="pageAide" value="<%= sPageAide %>">
		<tr>
			<td class="lib" align=left width=30%><b>Limitation à un dossier projet : </b></td>
			<td>
				<html:select property="p_param7" styleClass="input"> 
					<option value="TOUS" SELECTED>Tous</option>
					<option value="Pas de limitation">Pas de limitation</option>
					<html:options collection="choixDProjet" property="cle" labelProperty="libelle" />
				</html:select>
			</td>
			<td align="center" width="30%" rowspan=7>
		<table>
			<tr>
				<td class="lib" width="200px" ><b>Explications sur les choix
				:</b><br>
				<br>
				<i>Tous ou Toutes</i><br>
				indique que vous souhaitez<br>
				retenir toutes les valeurs<br>
				du périmètre RTFE concerné;<br>
				<br>
				<i>Pas de limitation</i><br>
				indique que vous ne souhaitez<br>
				pas prendre en compte le<br>
				périmètre RTFE concerné.</td>
			</tr>
		</table>
		</td>
		</tr>
		<tr>
			<td colspan=2 align="center">&nbsp;</td>
		</tr>
		<tr>
            <td class="lib"  align=left><b>Limitation à un projet : </b></td>
			<td>
				<html:select property="p_param8" styleClass="input"> 
					<option value="TOUS" SELECTED>Tous</option>
					<option value="Pas de limitation">Pas de limitation</option>
					<html:options collection="choixProjet" property="cle" labelProperty="libelle"/>
				</html:select>
			</td>
		
		</tr>
		<tr>
			<td colspan=2 align="center">&nbsp;</td>
		</tr>
		<tr>
            <td class="lib" align=left><b>Limitation à une application : </b></td>
			<td>
				<html:select property="p_param9" styleClass="input"> 
					<option value="TOUS" SELECTED>Toutes</option>
					<option value="Pas de limitation">Pas de limitation</option>
					<html:options collection="choixAppli" property="cle" labelProperty="libelle" />
				</html:select>
			</td>
		</tr>
		<tr>
			<td colspan=2 align="center">&nbsp;</td>
		</tr>		
		<tr>
			<td class="lib" align=left><b>Limitation à un CAFI :</b></br>
			(les niveaux inférieurs sont pris en compte)</td>
			<td><html:select property="p_param10" styleClass="input">
				<option value="TOUS" SELECTED>Tous</option>
				<option value="Pas de limitation">Pas de limitation</option>
				<html:options collection="choixCAFI" property="cle"
					labelProperty="libelle" />
			</html:select></td>
			
		</tr>
		<tr>
			<td colspan=2 align="center">&nbsp;</td>
		</tr>
		<tr>
	        <td class="lib" align=left><b>Limitation à un CA Payeur : </b>
	                 	<br>(les niveaux inférieurs </br>sont pris en compte)</td>
			<td>
				<html:select property="p_param11" styleClass="input"> 
					<option value="TOUS" SELECTED>Tous</option>
					<option value="Pas de limitation">Pas de limitation</option>
					<html:options collection="choixCA" property="cle" labelProperty="libelle" />
				</html:select>
			</td>

		</tr>
		<tr>
			<td colspan=3 align="center">&nbsp;</td>
		</tr>
		<tr>
				<td class="lib" align="left"><b>Extension du fichier :</b>&nbsp;</td>
				<td colspan=2>
					<select name="listeReports" class="input" onChange="return MAJTypeExtract(this.value)">
						<option value="1">.TXT</option>
						<option value="2" SELECTED>.CSV</option>
					</select></td>
		</tr>
		<tr>
			<td colspan=3 align="center">&nbsp;</td>
		</tr>
	</table>

<!-- debut ancien code -->		
			
            <table border=0 class="tableBleu" width="90%" cellspacing="1" align="center" cellpadding="1">
                <tr> 
                  <td width ="50%"> 
					<table border=0 class="tableBleu">
					<input type="hidden" name="pageAide" value="<%= sPageAide %>">
                   
			   		</table>
                  </td>
		        </tr>
                <tr> 
                  <td>  
                  <div align="center">
				  <html:submit value="Extraire" styleClass="input" onclick="Verifier(this.form, true);"/>
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