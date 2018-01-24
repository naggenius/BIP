<!DOCTYPE html>
<%@ taglib uri="/WEB-INF/struts-bean.tld" prefix="bean" %>
<%@ taglib uri="/WEB-INF/struts-html.tld" prefix="html" %>
<%@ taglib uri="/WEB-INF/struts-logic.tld" prefix="logic" %>

<!-- #BeginEditable "imports" --> 
<%@ page language="java" import="org.owasp.esapi.ESAPI,java.sql.*,java.io.*,javax.servlet.*,javax.servlet.http.*,com.socgen.ich.ihm.*,java.lang.reflect.InvocationTargetException,com.socgen.bip.metier.Reestime"    errorPage="../jsp/erreur.jsp"  %>
<jsp:useBean id="budgMassForm" scope="request" class="com.socgen.bip.form.BudgMassForm" />
<jsp:useBean id="listeReestimes" scope="session"	class="com.socgen.ich.ihm.menu.PaginationVector" />

<%@page import="com.socgen.bip.form.BudgMassForm"%>
<html:html locale="true"> 
<!-- #EndEditable --> <!-- #BeginTemplate "/Templates/Page_bip.dwt" --> 
<head>
 

<%@ taglib uri="/WEB-INF/bip.tld" prefix="bip" %>
 <!-- #BeginEditable "doctitle" --> 
<title>Page BIP</title>
<!-- #EndEditable --> 
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<!-- #BeginEditable "fichier" --> 
<bip:VerifUser page="jsp/fBudgMassMEAd.jsp"/> 
<script language="JavaScript" src="../js/function.cjs"></script>
<!-- <link rel="stylesheet" href="../css/base_style.css" type="text/css"> -->
<link rel="stylesheet" href="../css/style_bip_new.css" type="text/css">
<script language="JavaScript">
var blnVerification = true;

<%
	String arborescence = ESAPI.encoder().encodeForJavaScript(ESAPI.encoder().canonicalize(request.getParameter("arborescence")));
String sPageAide = ESAPI.encoder().encodeForJavaScript(ESAPI.encoder().canonicalize(request.getParameter("pageAide")));
	
%>
var pageAide = "<%= sPageAide %>";


function MessageInitial()
{
   var Message="<bean:write filter="false"  name="budgMassForm"  property="msgErreur" />";
   var Focus = "<bean:write name="budgMassForm"  property="focus" />";
   
   if (Message != "") {
      alert(Message);
   }
  if (Focus != "") (eval( "document.forms[0]."+Focus )).focus();
   else if (document.forms[0].preesancou_1){
	  document.forms[0].preesancou_1.focus();
   }
   
  }

function Verifier(form, action, flag, save)
{
  blnVerification = flag;
  form.action.value = action;
  form.save.value = save;
}
function ValiderEcran(form)
{
   	if (blnVerification==true) {
		if (VerifierChampsComm()) {
			if (!confirm("Voulez-vous modifier le réestimé de l'année courante pour cette ligne BIP ?")) {
				return false;
			}
   		}
		else {
			return false;
		}
   }
   return true;
}
function VerifierChampsComm(name) {
	var elementErrone; 
	
	if (document.getElementById(name) && ContientCarSpec(document.getElementById(name))) {
		elementErrone = document.getElementById(name); 
	}
	
	// Si un champ commentaire n'est pas valide
	if (elementErrone != null) {
		// Afficher une popup d'erreur
		alert("Vous avez saisi des caractères non autorisés, veuillez les enlever\n\nListe des caractères interdits : äëïöüÄË$%²\"&!?;@§/<>~+=#{[|`^]}°¤£µ¨\'");
		// Mettre le focus sur le champ erroné
		elementErrone.focus();
		return false;
	} else {
		return true;
	}
}

function ContientCarSpec(elementTextarea) {
	// Si l'élément existe
	if (elementTextarea) {
		// Expression régulière contenant l'ensemble des catactères spéciaux à interdire
		var exprCarSpec=new RegExp("\\ä|\\ë|\\ï|\\ö|\\ü|\\Ä|\\Ë|\\\$|\\%|\\²|\\\"|\\&|\\!|\\?|\\;|\\@|\\§|\\/|\\<|\\>|\\~|\\+|\\=|\\#|\\{|\\[|\\||\\`|\\^|\\]|\\}|\\°|\\¤|\\£|\\µ|\\¨|\\\\|\\'");
		
		// Si le champ correspond à l'expression régulière
		return exprCarSpec.test(elementTextarea.value);
	}
	else {
		return false;
	}
}

/**
	Traitement effectué après saisie d'un caractère dans un champ commentaire
*/
function TraiterComm(elementTextarea) {
	TraiterLongueurChaineComm(elementTextarea);
	//AlimenterCompteurNbCarRestants(elementTextarea, divCompteur);
}

/**
	Tronquer chaine commentaire
*/
function TraiterLongueurChaineComm(elementTextarea) {
	// Si la taille max autorisée est dépassée
	if (parseInt(elementTextarea.value.length) > parseInt(<%= BudgMassForm.longueurMaxCommentaire %>)) {
		// Tronquer
		elementTextarea.value=elementTextarea.value.substring(0, parseInt(<%= BudgMassForm.longueurMaxCommentaire %>));
	}
}


function paginer(page, index , action){
	document.forms[0].action.value =action;
	document.forms[0].page.value=page;
    document.forms[0].index.value=index;
    document.forms[0].submit();
}


function CalculerTotMois(Obj,EF)
{
 if (!CalculerTotaux(Obj,EF)) { 
 EF.focus;
 return false;
 }
 return true; 
}

function CalculerTotaux(Obj,EF)
{
  
  
  tab = Obj.split('_');
  i=tab[1];
  
   
  PREE = eval("document.forms[0].preesancou_"+i).value;
  OLD_PREE = eval("document.forms[0].oldpreesancou_"+i).value;
  totalpreesancou = eval("document.forms[0].tot_preesancou").value;
  
     
  nombre='';
  if (!VerifierDecOLD( EF,7,2,EF.value)) return false;
  
     
  if (PREE=="") PREE=0;
  if (OLD_PREE=="") OLD_PREE=0;
  if (totalpreesancou=="") totalpreesancou=0;
  
  virgule=totalpreesancou.toString().split(',');
  totalpreesancou=parseFloat(virgule[0]+'.'+virgule[1]);
  
  virgule=PREE.toString().split(',');
  totalpreesancou=parseFloat(virgule[0]+'.'+virgule[1])+parseFloat(totalpreesancou); 
  
  virgule=OLD_PREE.toString().split(',');
  totalpreesancou=parseFloat(totalpreesancou)-parseFloat(virgule[0]+'.'+virgule[1]);
  
  virgule=totalpreesancou.toString().split('.');
  if(virgule[1])
  totalpreesancou=virgule[0]+','+virgule[1];
  else
     totalpreesancou=virgule[0];
  
  eval("document.forms[0].tot_preesancou").value=(totalpreesancou==0?"":totalpreesancou);
  eval("document.forms[0].oldpreesancou_"+i).value = PREE;
  
  EF.focus;
  return true;
  
  

}


</script>
<!-- #EndEditable --> 
</head>
<body bgcolor="#FFFFFF" text="#000000" topmargin="0" leftmargin="0" onLoad="MessageInitial();">
<div id="mainContainer">
<div id="topContainer" style="height: 180%;">
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
          <td background="../images/ligne.gif"></td>
        </tr>
        <tr> 
          <td height="20" class="TitrePage">Saisie en masse des r&eacute;estim&eacute;s pour un DPG</td>
        </tr>
        <tr> 
          <td background="../images/ligne.gif"></td>
        </tr>
        <tr> 
          <td height="20"> </td>
        </tr>
        <tr> 
          <td> <!-- #BeginEditable "debut_form" --><html:form action="/reestMass"  ><!-- #EndEditable --> 
            <table width="100%" border="0">
              <tr> 
                <td> 
                  <div align="center"><!-- #BeginEditable "contenu" -->
					<input type="hidden" name="pageAide" value="<%= sPageAide %>">
                    <html:hidden property="action"/>
<html:hidden property="arborescence" value="<%= arborescence %>"/>
                    <html:hidden property="save"/>
                     <html:hidden property="page" value="modifier"/>
                     <input type="hidden" name="index" value="modifier">
		             <html:hidden property="posClient"/> <!--position du client dans la liste-->
        		     <html:hidden property="posAppli"/> <!--position de l'application dans la liste-->
        		     
				    <table border=0 cellspacing=2 cellpadding=2 class="TableBleu">
                      <tr align="left">
                        <td class="texte"><b>DPG :</b></td>
                        <td colspan=3 class="texte"><bean:write name="budgMassForm" property="libcodsg"/>
                        	<html:hidden property="codsg"/>
                            <html:hidden property="libcodsg"/>
                        </td>
                      </tr>
<%	if ((budgMassForm.getClicode()!=null) && (budgMassForm.getClicode().length()>0)) { %>
                      <tr align="left">
                        <td  class="texte" ><b>Client :</b></td>
                        <td colspan=3 class="texte">
                        	<bean:write name="budgMassForm" property="libclicode"/>
                        </td>
                      </tr>
<%	}
	if ((budgMassForm.getAirt()!=null) && (budgMassForm.getAirt().length()>0)) { %>
                      <tr align="left">
                  <td class="texte" ><b>Application :</b></td>
                        <td colspan=3 class="texte">
                        	<bean:write name="budgMassForm" property="libairt"/>
                        	<html:hidden property="airt"/>
                        </td>
                      </tr>
<%	} %>
                      <tr>
                        <td colspan=6>&nbsp;</td>
                      </tr>
                    </table>
                    <table border=0 cellspacing=0 cellpadding=2 class="TableBleu">
                       <tr align="left"> 
                  			<td rowspan=2 colspan=9></td>
                  			<td colspan=2 class="texte" align=center>
				    			<b>Derni&egrave;re mise &agrave; jour</b>
				  			</td>
                	   </tr>
               		   <tr> 
                	  </tr>
                      <tr align="left" class="lib">
                        <td class="texte" align="center"><B>Direct Reestimee</B></td>
                        <td class="texte" align="center"><B>Ligne</B></td>
                        <td class="texte" align="center"><B>Type</B></td>
                        <td class="texte" align="center"><B>Libell&eacute;</B></td>
                        <td class="texte" align="center"><B>Code <br> projet</B></td>
                        <td class="texte" align="center"><B>DPG</B></td>
                        <td class="texte" align="center"><B>Consomm&eacute;</B></td>
                        <td class="texte" align="center"><B>Not/Arb</B></td>
                        <td class="texte" align="center"><B>R&eacute;estim&eacute;</B></td>
                        <!-- YNI 
                        <td class="texte" align="center"><B>Date Derniere <br> modification</B></td>
                        <td class="texte" align="center"><B>Identifiant</B></td>-->
                       	<td class="texte" align=center><B>DATE</B></td>
						<td class="texte" align=center><B>PAR</B></td>
                        <!-- Fin YNI -->
                      </tr>
                      
                      	<% int i = 0;
						   int nbligne = 0;
						   String libPid="";
						   String libFlaglock="";
						   String libPreesancou="";
						   String libreescomm="";
						   String oldlibPreesancou="";
						   String preesancou="";
						   String preescomm="";
				           Object oConso=null;
				           Object oComm=null;
				           Class[] parameterString = {};
						   String[] strTabCols = new String[] {  "fond1" , "fond2" }; %>
						<logic:iterate id="element" name="listeReestimes" length="<%=  listeReestimes.getCountInBlock()  %>" 
			            			offset="<%=  listeReestimes.getOffset(0) %>"
									type="com.socgen.bip.metier.Reestime"
									indexId="index"> 
						<% if ( i == 0) i = 1; else i = 0;
						   nbligne ++;
						   libPid="pid_"+nbligne;
						   libFlaglock="flaglock_"+nbligne;
						   libPreesancou="preesancou_"+nbligne;
						   oldlibPreesancou="oldpreesancou_"+nbligne;
						   libreescomm="preescomm_"+nbligne;
						 %>
						<tr align="left" class="<%= strTabCols[i] %>">
    			  		<td class="contenu" align="center"><bean:write name="element" property="clicode" /></td>
    			  		
						<td class="contenu"><bean:write name="element" property="pid" />
						<input type="hidden" name="<%=libPid%>" value="<bean:write name="element" property="pid" />">
						<input type="hidden" name="<%=libFlaglock%>" value="<bean:write name="element" property="flaglock" />">
						</td>
						
						<td class="contenu"><bean:write name="element" property="type" /></td>
    			  		<td class="contenu"><bean:write name="element" property="pnom" /></td>
    			  		<td class="contenu" align="center"><bean:write name="element" property="icpi" /></td>
    			  		<td class="contenu"><bean:write name="element" property="codsg" /></td>
    			  		<td class="contenu" align="right"><bean:write name="element" property="xcusag0" /></td>
    			  		<td class="contenu" align="right"><bean:write name="element" property="xbnmont" /></td>
    			  		

                       
					
				      
				      
				 <% try {
                        	   Object[] param1 = {};
                     
                        	   oConso= element.getClass().getDeclaredMethod("getPreesancou",parameterString).invoke((Object) element, param1);
                        	   if (oConso!=null) preesancou=oConso.toString();
                        	   else preesancou="";
                        	   
                           	   Object[] param2 = {};
                               
                        	   oComm= element.getClass().getDeclaredMethod("getReescomm",parameterString).invoke((Object) element, param2);
                        	   if (oComm!=null) preescomm=oComm.toString();
                        	   else preescomm="";
				%>
				<td class="contenu" align="right">
					<input type="text" class="inputisac" size="9" maxlength="9" name="<%=libPreesancou%>" value="<%=preesancou%>"  onChange="return CalculerTotMois(this.name,this);">
    			  	<input type='hidden' name="<%=oldlibPreesancou%>" value="<%=preesancou%>">
				</td>
				<%} catch (NoSuchMethodException me) {
					%>
					NoSuchMethodException 
					
					<%
					} catch (SecurityException se) {
					%>SecurityException
					<%	
					} catch (IllegalAccessException ia) {
					%>IllegalAccessException
					<%
					} catch (IllegalArgumentException iae) {
					%>IllegalArgumentException
					<%
					} catch (InvocationTargetException ite) {
					%>InvocationTargetException
					<%	
					}%>
				      
				      <td class="contenu" align="center"><bean:write name="element" property="redate" /></td>
    			  	  <td class="contenu" align="left"><bean:write name="element" property="ureestime" /></td>
					</tr>
					<tr align="left" class="<%= strTabCols[i] %>">
						<td class="contenu"></td>
						<td class="contenu"></td>
						<td colspan=9 class="contenu">
						    <textarea name="<%=libreescomm%>" cols="79" rows="3" cols="53" value="<%=preescomm%>"
						    maxlength="<%= BudgMassForm.longueurMaxCommentaire %>" 
						    onkeyup="TraiterComm(this)" onblur="VerifierChampsComm(this.name)"><bean:write name="element" property="reescomm" ignore="true"/></textarea>
						</td>					
					</tr>
					<tr align="left" class="<%= strTabCols[i] %>">
						<td class="contenu" colspan=11></td>
					</tr>
			 		</logic:iterate> 
						<tr align="left" class="lib" width="100%">
						<td class="texte" colspan="3"><B>Total</B></td>
					    <td class="texte"></td>
					    <td class="texte"></td>
					    <td class="texte"></td>
					    <td class="texte"></td>
					    <td class="texte"></td>
						<td  align="right" >
						<B><html:text property="tot_xcusag0" styleClass="inputright" size="9" maxlength="9" readonly="true" /> </B>
						<html:hidden property="old_tot_xcusag0"/>
						</td>
						<td  align="right" >
						<B><html:text property="tot_xbnmont" styleClass="inputright" size="9" maxlength="9" readonly="true"  /> </B>
						<html:hidden property="old_tot_xbnmont"/>
						</td>
						<td align="right" >
						<B><html:text property="tot_preesancou" styleClass="inputgras" size="9" maxlength="9" readonly="true" /> </B>
						<html:hidden property="old_tot_preesancou"/>
						</td>					
						</tr>			  	
			  		</table>
					<table  width="100%" border="0" cellspacing="0" cellpadding="0">
					   	<tr>
							<td align="center" colspan="4" class="contenu">
								<bip:pagination beanName="listeReestimes"/>
							</td>
						</tr>
																							
			 			<tr><td colspan="4" height="15">&nbsp;</tr>
			 			<tr>
		              		<td width="20%">&nbsp;</td>
		                	<td width="20%" class="texte">
		                	 <div align="center">
		                	  <html:submit property="boutonValider" value="Valider" styleClass="input" onclick="Verifier(this.form, 'valider', true, 'NON');"/>
		                	 </div>
		               		</td> 
		               		<td width="20%" class="texte">
		                	 <div align="center">
		                	  <html:submit property="boutonSave" value="Sauvegarder" styleClass="input" onclick="Verifier(this.form, 'valider', true, 'OUI');"/>
		                	 </div>
		               		</td> 
		               		<td width="20%" class="texte"> 
		                  	 <div align="center"> 
		                	  <html:submit property="boutonAnnuler" value="Annuler" styleClass="input" onclick="Verifier(this.form, 'annuler', false, 'NON');"/>
		              		 </div>
		                </td>
		                <td width="20%">&nbsp;</td>
		            	</tr>
     
					</table>
                    <!-- #EndEditable --></div>
                </td>
              </tr>
            </table>
            <!-- #BeginEditable "fin_form" --></html:form><!-- #EndEditable --> 
          </td>
        </tr>
        <tr> 
          <td>&nbsp; </td>
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
</div>
	<div id="bottomContainer">
			<div>&nbsp;</div>
	</div>
</div>
</body>
<% 
Integer id_webo_page = new Integer("1058"); 
com.socgen.bip.commun.form.AutomateForm formWebo = budgMassForm ;
%>
<%@ include file="/incWebo.jsp" %>
</html:html>
<!-- #EndTemplate -->
