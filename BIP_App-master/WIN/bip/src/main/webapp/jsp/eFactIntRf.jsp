<%@ taglib uri="/WEB-INF/struts-bean.tld" prefix="bean" %>
<%@ taglib uri="/WEB-INF/struts-html.tld" prefix="html" %>
<%@ taglib uri="/WEB-INF/struts-logic.tld" prefix="logic" %>

<%@ page language="java" import="org.owasp.esapi.ESAPI,java.sql.*,java.io.*,javax.servlet.*,javax.servlet.http.*,com.socgen.ich.ihm.*,java.util.Vector,java.util.StringTokenizer"    errorPage="../jsp/erreur.jsp"  %>
<jsp:useBean id="editionForm" scope="request" class="com.socgen.bip.commun.form.EditionForm" />
<jsp:useBean id="listeCA" scope="request" class="com.socgen.bip.commun.liste.ListeCentreActivite" />
<html:html locale="true">
<head>


<%@ taglib uri="/WEB-INF/bip.tld" prefix="bip" %>


<title>Edition</title>

<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<bip:VerifUser page="jsp/eFactIntRf.jsp"/>
<%
	com.socgen.bip.user.UserBip userbip = (com.socgen.bip.user.UserBip)session.getAttribute("UserBip");  

	java.util.Hashtable hP = new java.util.Hashtable();
	java.util.Hashtable hP1 = new java.util.Hashtable();
	java.util.Hashtable hP2 = new java.util.Hashtable();
	
	String ca_payeur="";
	String ca_fi="";

	if(userbip.getCAPayeur() != null){
		ca_payeur = userbip.getCAPayeur();
	}
	if(userbip.getCAFI() != null){
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
var pageAide = "aide/hvide.htm";
var choixEffectue = false;
<%
	String arborescence = ESAPI.encoder().encodeForJavaScript(ESAPI.encoder().canonicalize(request.getParameter("arborescence")));
String sPageAide = ESAPI.encoder().encodeForJavaScript(ESAPI.encoder().canonicalize(request.getParameter("pageAide")));
%>
var pageAide = "<%= sPageAide %>";

<%
	String sTitre;
	String sInitial;
	String sJobId="eFactIntRf";
%>

function MessageInitial(){
	<%
		sTitre = com.socgen.bip.metier.Report.getTitre(sJobId);
		if (sTitre == null){
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
}

function ChangeRef2(){
	choixEffectue=true;
}

function Verifier(form, bouton, flag){
  
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
function ValiderEcran(form){
	
	if (!choixEffectue) {
		alert("Effectuez un choix de présentation");
		return false;
	}
	
	if ((document.forms[0].p_param7.value == "Pas de limitation")&&(document.forms[0].p_param8.value == "Pas de limitation")&&
	    (document.forms[0].p_param9.value == "Pas de limitation")&&(document.forms[0].p_param10.value == "Pas de limitation")&&
	    (document.forms[0].p_param11.value == "Pas de limitation") ) {
		alert("Choisir au moins une valeur ");
		return false;
	}
	
	if(selectHabil()){
		alert('les choix « --- Habil Directe --- » et « --- Habil par DP --- » ne sont pas des valeurs fonctionnelles. \n Merci de sélectionner un code projet');
		return false;
	}
	
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
          <td> 
            
          </td>
        </tr>
        <tr> 
          <td>
		  <html:form action="/edition"  onsubmit="return ValiderEcran(this);">
            
<html:hidden property="arborescence" value="<%= arborescence %>"/>
<input type="hidden" name="jobId" value="<%=sJobId%>">
            <input type="hidden" name="initial" value="<%= sInitial %>">
            <table  border="0">
	            <tr>
		        	<td colspan=5>
			        	<table border=0 class="tableBleu">
				        	<tr>
		                      <td colspan=5 align="center">&nbsp;</td>
		                      </tr> 
		                    <tr>
		                      <td colspan=5 align="left"><b>Cet état prend en compte votre périmètre Dossier projet, projet, application, CAFI et CA payeur . <br>Vous pouvez limiter la demande aux éléments ci-dessous :</b></td>
		                    </tr>
							<tr>
		                      <td colspan=5 align="center">&nbsp;</td>
		                    </tr>	
			        	</table>
		        	</td>
	        	</tr>
                <tr> 
                  <td width ="50%"> 
					<table border=0 class="tableBleu">
					<input type="hidden" name="pageAide" value="<%= sPageAide %>">
                    <tr>
                    	<td colspan=5 align="left">
					     <table>
					     <tr valign="middle">
			                  <td colspan=5 align="center">
			                            <table>
			                            <tr>
											<td class="lib" align=left width="130px"><b>Limitation à un dossier projet : </b></td>
											<td>
												<html:select property="p_param7" styleClass="input"> 
													<option value="TOUS" SELECTED>Tous</option>
													<option value="Pas de limitation">Pas de limitation</option>
													<html:options collection="choixDProjet" property="cle" labelProperty="libelle" />
												</html:select>
											</td>
										</tr>
										<tr>
				                        	<td colspan=5 align="center">&nbsp;</td>
				                    	</tr>
						     			<tr>
					                    	<td class="lib" align=left width="130px"><b>Limitation à un projet : </b></td>
											<td>
												<html:select property="p_param8" styleClass="input"> 
													<option value="TOUS" SELECTED>Tous</option>
													<option value="Pas de limitation">Pas de limitation</option>
													<html:options collection="choixProjet" property="cle" labelProperty="libelle"/>
												</html:select>
											</td>
						    			</tr>
				                    	<tr>
				                        	<td colspan=5 align="center">&nbsp;</td>
				                    	</tr>
				                    	<tr>
					                     	<td class="lib" align=left width="130px"><b>Limitation à une application : </b></td>
											<td>
												<html:select property="p_param9" styleClass="input"> 
													<option value="TOUS" SELECTED>Toutes</option>
													<option value="Pas de limitation">Pas de limitation</option>
													<html:options collection="choixAppli" property="cle" labelProperty="libelle" />
												</html:select>
											</td>
										</tr>
										
									 <tr>
				                         <td colspan=5 align="center">&nbsp;</td>
				                        </tr>
				                     <tr>
				                     	<td class="lib" align=left width="130px"><b>Limitation à un CAFI : </b>
				                     	<br>(les niveaux inférieurs sont pris en compte)
										</td>				    
										<td>
											<html:select property="p_param10" styleClass="input"> 
												<option value="TOUS" SELECTED>Tous</option>
												<option value="Pas de limitation">Pas de limitation</option>
												<html:options collection="choixCAFI" property="cle" labelProperty="libelle" />
											</html:select>
										</td>
									 </tr>
									 <tr>
				                        <td colspan=5 align="center">&nbsp;</td>
				                     </tr>
				                     <tr>
				                     	<td class="lib" align=left width="130px"><b>Limitation à un CA Payeur : </b>
				                     	<br>(les niveaux inférieurs sont pris en compte)</td>
										<td>
											<html:select property="p_param11" styleClass="input"> 
												<option value="TOUS" SELECTED>Tous</option>
												<option value="Pas de limitation">Pas de limitation</option>
												<html:options collection="choixCA" property="cle" labelProperty="libelle" />
											</html:select>
										</td>
									  </tr>
				                 </table>
			                    </td>
			                    <td align="center" width="200px">
			                        	<!--  fieldset><legend><font size="2">Explications sur les choix :</font></legend>-->
							        		<fieldset>
							        		<table>
							          		<tr>
								          	<td class="lib" width="200px">
								          		<b>Explications sur les choix :</b></br></br>
								          		<i>Tous ou Toutes</i></br>
								          		indique que vous souhaitez</br>
								          		retenir toutes les valeurs </br>
								          		du périmètre RTFE concerné;</br></br>
								          		<i>Pas de limitation</i></br>
								          		indique que vous ne souhaitez</br>
								          		pas prendre en compte le</br>
								          		périmètre RTFE concerné.
								          	</td>
							          		</tr>
							        		</table>
							        		</fieldset>
							        	<!--  /fieldset>-->
			                    </td>
			                    </tr>
			                    </table>
                        </td>
                    </tr>
                    
				      <tr>
                        <td align="right"> &nbsp;</td>
                      </tr>   
                      <tr>
                        <td align="left">
	                        <table>
	                          <tr>
	                            <td class="libNoBackGround" align="left"><b>Mode de présentation :</b></td>
		                    	<td class="libNoBackGround" align="right"> 
		                    		<html:radio property="p_param12" styleClass="input" value="MO" onclick="ChangeRef2();"/>
								</td>
								<td class="libNoBackGround" align=left><b>Classement par client</b></td>
							  </tr>
		                      <tr>
		                      	<td class="libNoBackGround" align="left">&nbsp;</td>
		                     	<td class="libNoBackGround" align="right"> 
		                     		<html:radio property="p_param12" styleClass="input" value="CA" onclick="ChangeRef2();"/>
								</td>
								<td class="libNoBackGround" align=left><b>Classement par CA payeur</b></td>
							 </tr>           
	                        </table>
                        </td>                      
                      </tr>
					  <tr>
                        <td colspan=5 align="center">&nbsp;</td>
                      </tr>
			   		</table>
                  </td>
		        </tr>
                <tr> 
                  <td>  
                  <div align="center">
				  <html:submit value="Edition" styleClass="input" onclick="Verifier(this.form, 'liste', true);"/>
                  </div>
                  </td>
                </tr>            
            </table>
			</html:form>
          </td>
        </tr>
        <tr> 
          <td> 
            <div align="center"><html:errors/></div>
          </td>
        </tr>
      </table>
    </td>
  </tr>
</table>
</body>
</html:html>