<!DOCTYPE html>
<%@ taglib uri="/WEB-INF/struts-bean.tld" prefix="bean" %>
<%@ taglib uri="/WEB-INF/struts-html.tld" prefix="html" %>
<%@ taglib uri="/WEB-INF/struts-logic.tld" prefix="logic" %>
<!-- #BeginEditable "imports" --> 
<%@ page language="java" import="org.owasp.esapi.ESAPI,java.sql.*,java.io.*,javax.servlet.*,javax.servlet.http.*,com.socgen.ich.ihm.*,com.socgen.bip.commun.liste.*,java.util.Hashtable, com.socgen.bip.commun.liste.ListeOption, java.util.ArrayList, com.socgen.bip.commun.*, com.socgen.bip.*, java.util.*"    errorPage="../jsp/erreur.jsp"  %>
<jsp:useBean id="etapeForm" scope="request" class="com.socgen.bip.form.EtapeForm" />
<html:html locale="true"> 
<!-- #EndEditable --> <!-- #BeginTemplate "/Templates/Page_maj.dwt" --> 
<head>
 

<%@ taglib uri="/WEB-INF/bip.tld" prefix="bip" %>
 <!-- #BeginEditable "doctitle" --> 
<title>Page BIP</title>
<!-- #EndEditable --> 
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<!-- #BeginEditable "fichier" --> 
<bip:VerifUser page="/structLb.do"/> 
<%  
		//HMI - PPM 60709 : $5.3 
	java.util.ArrayList list1;
	java.util.ArrayList list2 = new ArrayList();
	Hashtable hKeyList= new Hashtable();
	hKeyList.put("pid", ""+etapeForm.getPid());
	hKeyList.put("userid", ""+((com.socgen.bip.user.UserBip)session.getAttribute("UserBip")).getInfosUser());
	hKeyList.put("etape", ""+etapeForm.getEtape());
	hKeyList.put("typetape", ""+etapeForm.getTypetape());
	hKeyList = etapeForm.getHParams();
	
%>
<script language="JavaScript" src="../js/function.cjs"></script>
<link rel="stylesheet" href="../css/style_bip_new.css" type="text/css">
<script language="JavaScript">	
<%
		
	   
	//ZAA / HMI - HP PPM 62379
	try {
	Hashtable hKeyListjeu= etapeForm.getHParams();
	
	if (etapeForm.getMode() != null && etapeForm.getMode().equals("update")) {
		hKeyListjeu.put("mode", "update");
		hKeyListjeu.put("etape", etapeForm.getEtape());  
		hKeyListjeu.put("jeu", etapeForm.getJeu());
		hKeyListjeu.put("typetape", etapeForm.getTypetape());
		
		hKeyList.put("mode", "update");
		hKeyList.put("etape", etapeForm.getEtape());  
		hKeyList.put("jeu", etapeForm.getJeu());
		hKeyList.put("typetape", etapeForm.getTypetape());
		
	}
		
	list1 = new com.socgen.bip.commun.liste.ListeDynamique().getListeDynamique("jeu",hKeyListjeu);
	pageContext.setAttribute("jeu", list1);
	
	//	HMI - PPM 60709 : $5.3
	hKeyList.put("jeu", etapeForm.getJeu());
	list2 = new com.socgen.bip.commun.liste.ListeDynamique().getListeDynamique("type_etape_jeu",hKeyList);
	pageContext.setAttribute("typetap", list2);
	} catch (Exception e){
		System.out.println("Exception mEtapeSr : " + e.getMessage());
	}
	
%>

var blnVerification = true;
<%
	String arborescence = ESAPI.encoder().encodeForJavaScript(ESAPI.encoder().canonicalize(request.getParameter("arborescence")));
String sPageAide = ESAPI.encoder().encodeForJavaScript(ESAPI.encoder().canonicalize(request.getParameter("pageAide")));
%>
var pageAide = "<%= sPageAide %>";
var rafraichiEnCours = false;


function MessageInitial()
{
document.getElementById("wait").style.display = "none";
   var Message="<bean:write filter="false"  name="etapeForm"  property="msgErreur" />";
   
   if (Message != "") {
      alert(Message);
   }

   <%// Si mode différent de suppression %>
   <logic:notEqual name="etapeForm" property="mode" value="delete">
	   var Focus = "<bean:write name="etapeForm"  property="focus" />";
	   if (Focus != "") (eval( "document.forms[0]."+Focus )).focus();
	   else if (document.forms[0].libetape){
		  document.forms[0].libetape.focus();
	   }
	</logic:notEqual>
}

function Verifier(form, action, mode, flag)
{
   blnVerification = flag;
   form.action.value = action;
   form.mode.value = mode;
} 
function ValiderEcran(form) {
  if (blnVerification == true) {
      if ((form.action.value!="valider")&&(form.action.value!="annuler"))
  		form.action.value ="valider";
  	  
  	  if (!ChampObligatoire(form.libetape, "le libelle de l'étape")) return false;
  	  if (!ChampObligatoire(form.typetape, "le type de l'étape")) return false;
 
	  if (form.typetape.value == "XX") {
		 alert("Veuillez choisir un autre type d'étape");
		 form.typetape.focus();
		 return false;
	  }	
  	  
      if (form.action.value == 'valider' && form.mode.value == 'update' ) {
        if (!ChampObligatoire(form.ecet, "le numéro de l'étape")) return false;
		Replace_Double_Chiffre("ecet");	//Mettre le n° sur 2 chiffres si bug onChange
		if ((form.ecet.value=="00")|(form.ecet.value=="0")){
			alert("Entrez un autre numéro d'étape");
			form.ecet.focus();
			return false;
		}
		
        if (!confirm("Voulez-vous modifier cette étape ?")) return false;
     }
  }
  // On désactive le bouton valider pour éviter un double click
  form.boutonValider.disabled=true;
  return true;
}

function refreshEcran() {
	if(!rafraichiEnCours)
	{     
        rafraichir(document.forms[0]);
       		rafraichiEnCours = true;
		 document.getElementById("wait").style.display = "block";
	}
}
</script>
<!-- #EndEditable --> 
</head>
<body bgcolor="#FFFFFF" text="#000000" topmargin="0" leftmargin="0" onLoad="MessageInitial();">
<div id="mainContainer">
<div id="topContainer">
<div id="entete"></div>
<div id="logo">
		<div id="logo_sg"><img src="../images/logo_SG.gif" width="162" height="33" border="0" /></div>
		<div id="nomdusite"><img src="../images/bip_logo.png" width="78" height="46" border="0" /></div>
</div>
<div id="wait" class="tableBleu" style="font : normal 8pt Verdana, Helvetica, sans-serif;top:50%;left:40%;position:absolute;padding:5px;display:none"><img src="../images/indicator.gif" /> Veuillez patienter...</div>

<table width="100%" border="0" cellpadding="0" cellspacing="0">
  <tr> 
    <td> 
      
      <table width="100%" border="0" cellspacing="0" cellpadding="0">
        <tr > 
          <td> 
            <div id="outils" align="center"><!-- #BeginEditable "barre_haut" -->
              <%ToolBarNew tb = new com.socgen.ich.ihm.ToolBarNew("bip_ihm",false,false,true,true,false,false,false,false,false,request) ;%>
				<%=tb.printHtml()%><!-- #EndEditable -->
			</div>
          </td>
        </tr>
        <tr> 
          <td>&nbsp;</td>
        </tr>
        <tr> 
          <td height="20" class="TitrePage"><div id="titre" ><!-- #BeginEditable "titre_page" -->
          <bean:write name="etapeForm" property="titrePage"/> une  &eacute;tape <!-- #EndEditable --></div></td>
        </tr>
        <tr> 
          <td> <!-- #BeginEditable "debut_form" --> 
          	<div id="content">
          	<html:form action="/etape"  onsubmit="return ValiderEcran(this);"><!-- #EndEditable --> 
            <div align="center"><!-- #BeginEditable "contenu" -->
			<input type="hidden" name="pageAide" value="<%= sPageAide %>">
            <html:hidden property="action"/>
		    <html:hidden property="mode"/>
			<html:hidden property="arborescence" value="<%= arborescence %>"/>
		    <html:hidden property="keyList0"/>
		    <html:hidden property="etape"/>
		    <html:hidden property="flaglock"/>
		    <html:hidden property="pid"/>
		    <html:hidden property="titrePage"/>
		    <html:hidden property="direction"/>
		    <html:hidden property="typproj"/>
		    <html:hidden property="btRadioStructure"/>
           	<table border="0" cellpadding="0" cellspacing="0"   width="100%" class="tableBleu" >
	   		<tr>
				<td>&nbsp;</td>
    	   </tr>
		    <tr>
				<td>&nbsp;</td>
    	   </tr>
    	   </table>
    	   	<table border=2 cellspacing=0 cellpadding=10  class="TableBleu" bordercolor="#2E2E2E">
            <tr>
                	
                  <td align="center" height="10" class="texte"> <b>Ligne BIP </b>:<b> <bean:write name="etapeForm"  property="lib" /><html:hidden property="lib"/></b> 
                   
                </td>
            </tr> 
            </table>
            <table border="0" cellpadding="2" cellspacing="2"   class="tableBleu" >
                <tr>
				<td>&nbsp;</td>
    	   		</tr>
		   	 	<tr>
				<td>&nbsp;</td>
    	   		</tr>
                <tr align="left"> 
                  <td class="texteGras"><b>N°étape :</b> </td>
                  <td class="texte"> 
                    <logic:equal name="etapeForm"  property="mode" value="update">
                   		<html:text property="ecet" styleClass="input" size="3" maxlength="2" onchange="return Replace_Double_Chiffre(this.name);"/>
                    </logic:equal> 
                    <logic:notEqual name="etapeForm"  property="mode" value="update"> 
                    	<bean:write name="etapeForm"  property="ecet" />
                    	<html:hidden property="ecet"/>
                   </logic:notEqual>
                   
                  </td>
            
                </tr>
                <tr align="left"> 
                  <td class="texteGras" ><b>Libellé :</b> </td>
                  <td class="texte"> 
                  	<%// Si mode suppression %>
                  	<logic:equal name="etapeForm"  property="mode" value="delete">
                   		<bean:write name="etapeForm"  property="libetape" />
                    	<html:hidden property="libetape"/>
                    </logic:equal> 
                    <%// Sinon %>
                    <logic:notEqual name="etapeForm" property="mode" value="delete">
                   		<html:text property="libetape" styleClass="input" size="35" maxlength="30" />
                    </logic:notEqual> 
                  </td>
                </tr>
                
                <% 
                // Initialisation du boolean griserChamps
                etapeForm.setGriserChamps(true); %>
                <%// Si type projet différent de 7 %>
                <logic:notEqual name="etapeForm" property="typproj" value="7">                    	
                   	<%// Si mode différent de suppression %>
                   	<logic:notEqual name="etapeForm" property="mode" value="delete">
                    	<%etapeForm.setGriserChamps(false); %>
					</logic:notEqual> 
				</logic:notEqual>
				<%// Sinon %>
				<logic:equal name="etapeForm" property="typproj" value="7">
					<%etapeForm.setJeu("Sans objet"); %>
					<%etapeForm.setTypetape("ES"); %>
				</logic:equal> 
               
                <tr  align="left"> 
                   <td class="texteGras"  ><b>Jeu de types d'étapes :</b></td>
                   <td class="texte"> 
                   	 <logic:equal name="etapeForm" property="griserChamps" value="true">
                   	 	<bean:write name="etapeForm" property="jeu" />
						<html:hidden property="jeu"/>
                   	 </logic:equal>
                <logic:notEqual name="etapeForm" property="griserChamps" value="true">
                     	                    
                   	 <html:select property="jeu" styleClass="input" onchange="refreshEcran()"> 
	   					<html:options collection="jeu" property="cle" labelProperty="libelle" />
						</html:select>
						</logic:notEqual>
                   	 
                   	
                  </td>
                </tr>
                <tr align="left">
                <td class="texteGras"  ><b>Types d'étape :</b></td>
                   <td class="texte"> 
                    <logic:equal name="etapeForm" property="griserChamps" value="true">
                    	<% 
                    	// Libellé du type d'étape sélectionné
                    	String libelleTypeEtape = null;
                    	if (list2 != null) {
                    		ListeOption	listeTypesEtapeOption;
                    		int compteur = 0;
                    		boolean typeEtapeTrouve = false;
                    		while (compteur < list2.size() && !typeEtapeTrouve) {
                    			listeTypesEtapeOption = (ListeOption) list2.get(compteur);
                    			if (listeTypesEtapeOption != null) {
                    				typeEtapeTrouve = etapeForm.getTypetape() != null && etapeForm.getTypetape().equals(listeTypesEtapeOption.getCle());
										
                    				if (typeEtapeTrouve) {
                    					libelleTypeEtape = listeTypesEtapeOption.getLibelle();
                    				}
                    			}
                    			compteur ++;
                    		}
                    	}
                    	%>
                    	<% if (libelleTypeEtape != null) {
                    	%>
                    		 <%= libelleTypeEtape %>
                    	<%
                    	}
                    	%>
					<!--  HMI - PPM 60709 : $5.3 si la ligne est non productive   -->
                    	<bean:write name="etapeForm" property="typetape" />
						<html:hidden property="typetape"/>
						
                    </logic:equal> 
                    
                    <logic:notEqual name="etapeForm" property="griserChamps" value="true">
                   
                    
                    	<html:select property="typetape" styleClass="input"> 
   						<html:options collection="typetap" property="cle" labelProperty="libelle" />
						</html:select>
					</logic:notEqual>
						
               </td>
                </tr>
                <tr> 
                  <td colspan="2"  >&nbsp;</td>
                </tr>
                <tr>
                  <td colspan="2"  >&nbsp;</td>
                </tr>
                <tr> 
                  <td colspan="2"  >&nbsp;</td>
                </tr>
              </table>
				<!-- #EndEditable --></div>
          </td>
        </tr>
        <tr> 
          <td align="center"> 
            <table width="100%" border="0">
              <tr> 
                <td width="25%">&nbsp;</td>
                <td width="25%"> 
                  <div align="center"> <html:submit property="boutonValider" value="Valider" styleClass="input" onclick="Verifier(this.form, 'valider', this.form.mode.value,true);"/> 
                  </div>
                </td>
                <td width="25%"> 
                  <div align="center"> <html:submit property="boutonAnnuler" value="Annuler" styleClass="input" onclick="Verifier(this.form, 'annuler', this.form.mode.value, false);"/> 
                  </div>
                </td>
                <td width="25%">&nbsp;</td>
              </tr>
            </table>
            <!-- #BeginEditable "fin_form" --></html:form><!-- #EndEditable --> 
           	</div>
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
</html:html>
<% 
Integer id_webo_page = new Integer("6001"); 
com.socgen.bip.commun.form.AutomateForm formWebo = etapeForm ;
%>
<%@ include file="/incWebo.jsp" %>
<!-- #EndTemplate -->
