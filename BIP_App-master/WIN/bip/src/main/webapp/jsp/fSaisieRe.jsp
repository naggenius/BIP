<%@ taglib uri="/WEB-INF/struts-bean.tld" prefix="bean" %>
<%@ taglib uri="/WEB-INF/struts-html.tld" prefix="html" %>
<%@ taglib uri="/WEB-INF/struts-logic.tld" prefix="logic" %>

<!-- "imports" --> 
<%@ page language="java" import="org.owasp.esapi.ESAPI,java.sql.*,java.io.*,java.util.*,javax.servlet.*,javax.servlet.http.*,com.socgen.ich.ihm.*,java.lang.reflect.InvocationTargetException,java.text.DecimalFormat"    errorPage="../jsp/erreur.jsp"  %>
<jsp:useBean id="saisieReesForm" scope="request" class="com.socgen.bip.form.SaisieReesForm" />
<jsp:useBean id="listeDynamique" scope="request" class="com.socgen.bip.commun.liste.ListeDynamique" />
<!-- l'ID du bean PaginationVector doit être le même que celui défini dans BipConstantes -->
<jsp:useBean id="listeReestimes" scope="session" class="com.socgen.ich.ihm.menu.PaginationVector" />
<html:html locale="true"> 

<head>
 

<%@ taglib uri="/WEB-INF/bip.tld" prefix="bip" %>


 <!--  ABN - HP PPM 57787 - DEBUT  -->
 <!-- #BeginEditable "doctitle" --> 
<title>
	<% java.util.ResourceBundle rb = java.util.ResourceBundle.getBundle("log"); %>
	<%=rb.getString("env.titrepage")%>
</title>
<!-- #EndEditable --> 
<!--  ABN - HP PPM 57787 - FIN  -->


<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">

<bip:VerifUser page="/saisieRees.do"/> 
<% 	int i = 0;
   	int j = 0;
   	int k = 0;
  	int mois=0;
	int nbligne = 0;
	String libCode_activite="";
	String nbMois = saisieReesForm.getNbmois();
	int iAnnee = saisieReesForm.getAnnee();
	int mois_depart = 13;
	String sDate_depart = saisieReesForm.getDate_depart();
	if ( (sDate_depart!=null) && (sDate_depart.length()>0) ) {
		try {
			int anneeDepart = new Integer(sDate_depart.substring(6)).intValue();
			if (anneeDepart == iAnnee) {
				mois_depart = new Integer(sDate_depart.substring(3,5)).intValue() + 1;
			} else if (anneeDepart > iAnnee) {
				mois_depart = 13;
			} else if (anneeDepart < iAnnee) {
				mois_depart = 0;
			}
		} catch (NumberFormatException nfe) {
			%> 
<script language="JavaScript">
			alert("Problème dans le formatage de la date de départ : <%=sDate_depart%>");
</script>
<%		}
	}
	int mois_arrivee = 0;
	String sDate_Arrivee = saisieReesForm.getDate_arrivee();
	if ( (sDate_Arrivee!=null) && (sDate_Arrivee.length()>0) ) {
		try {
			int anneeArrivee = new Integer(sDate_Arrivee.substring(6)).intValue();
			if (anneeArrivee == iAnnee) {
				mois_arrivee = new Integer(sDate_Arrivee.substring(3,5)).intValue();
			} else if (anneeArrivee > iAnnee) {
				mois_arrivee = 13;
			}
		} catch (NumberFormatException nfe) {
			%> 
<script language="JavaScript">
			alert("Problème dans le formatage de la date d'arrivée : <%=sDate_Arrivee%>");
</script>
<%		}
	}
	
	String libConso="";
	String libRees="";
	String libOld="";
	String libTotalCons="";
	String libTotalRees="";
	String libTotalReest="";
    String[] strTabCols = new String[] {  "fond1" , "fond2" };
%>
<script language="JavaScript" src="../js/function.cjs"></script>
<link rel="stylesheet" href="../css/base_style.css" type="text/css">
<link rel="stylesheet" href="../css/style_bip.css" type="text/css">
<script language="JavaScript">
var blnVerification = true;
<%
	String arborescence = ESAPI.encoder().encodeForJavaScript(ESAPI.encoder().canonicalize(request.getParameter("arborescence")));
String sPageAide = ESAPI.encoder().encodeForJavaScript(ESAPI.encoder().canonicalize(request.getParameter("pageAide")));
	String sIndexMenu = ESAPI.encoder().encodeForJavaScript(ESAPI.encoder().canonicalize(request.getParameter("indexMenu")));
	
	Hashtable hKeyList= new Hashtable();
	if((saisieReesForm.getCodsg() != null)||(saisieReesForm.getCodsg().trim() != "")) {
		hKeyList.put("codsg", ""+saisieReesForm.getCodsg());
	} else {
		hKeyList.put("codsg", ""+((com.socgen.bip.user.UserBip)session.getAttribute("UserBip")).getDpg_Defaut());
	}
	
	hKeyList.put("userid", ""+((com.socgen.bip.user.UserBip)session.getAttribute("UserBip")).getInfosUser());
	if((saisieReesForm.getCodsg().trim().equals(""))||(saisieReesForm.getCodsg()==null))
	    pageContext.setAttribute("choixActivite", new ArrayList());
	else
	{
		try {	
	   	 	ArrayList listeActivite = listeDynamique.getListeDynamique("activiteRessAdd", hKeyList);
	    	pageContext.setAttribute("choixActivite", listeActivite);
    	} catch (Exception e) {
	    	pageContext.setAttribute("choixActivite", new ArrayList());
    		%>alert("<%= listeDynamique.getErrorBaseMsg()%>");<%
    	}
	}
    boolean disableInit = false;
	if(saisieReesForm.getType_ress().equals("S")) {
		disableInit = true;
	}

	// On sauvegarde toutes les activités pour le test sur l'ajout
%>
	var allCodeActivite = new Array();
<%	int iCodeAct = 0; %>
	<logic:iterate id="element" name="listeReestimes" type="com.socgen.bip.metier.ReestimeOutil"> 
		allCodeActivite[<%=iCodeAct%>] = "<bean:write name="element" property="code_activite" />";
		<% iCodeAct++; %>
	</logic:iterate> 


var pageAide = "<%= sPageAide %>";


function MessageInitial()
{
	var Message="<bean:write filter="false"  name="saisieReesForm"  property="msgErreur" />";
	var Focus = "<bean:write name="saisieReesForm"  property="focus" />";
	if (Message != "") {
    	alert(Message);
    	<% saisieReesForm.setMsgErreur(""); %>
	}

}
function VerifierDec( EF, longueur, decimale )
{
	var posSeparateur = -1;
	var Chiffre = "1234567890";
	var champ   = "";
	var deb     = 0;
	var debut   = 0;

	while (EF.value.charAt(debut)=='0' && debut <= EF.value.length)  {
    	debut++;
	}

	if (EF.value.length == (debut) && EF.value.charAt(0)=='0')
    	deb = 0;
	else if ((EF.value.charAt(1)==',' || EF.value.charAt(1)=='.') && EF.value.charAt(0)=='0')
        deb = 0;
	else if (EF.value.charAt(0)==',' || EF.value.charAt(0)=='.') {
        deb = 0;
        champ += '0';
   	} 
   	else
    	deb = debut;

   	while (deb <= EF.value.length)  {
    	if (Chiffre.indexOf(EF.value.charAt(deb))== -1) {
        	switch (EF.value.charAt(deb)) {
            	case '.' :
            	case ',' : 	champ += '.';
                         	posSeparateur = deb;
                         	if ( (deb <= (longueur-decimale+debut)) && ((EF.value.length-posSeparateur-1) <= decimale) )
                            	break;
              	default  : 	alert( "Nombre invalide");
                         	EF.focus();
                         	EF.value = "";
                         	return false;
         	}
      	}
      	else champ += EF.value.charAt(deb);
      	deb++;
   	}

   	if (posSeparateur==-1) {
		if (EF.value.length > (longueur-decimale+debut)) {
	   		alert( "Nombre invalide");
	   		EF.focus();
	   		EF.value = "";
	   		return false;
		}
		//if(decimale !=0) {
			// champ += ',';
		//}
		
		nbDecimales=0;
   	}
   	else if (decimale != 0) {
		nbDecimales = EF.value.length-posSeparateur-1;
   	}
   	else {alert( "Nombre invalide");
	   	EF.focus();
	   	EF.value = "";
	   	return false;
   	}

 	//  for (Cpt=1; Cpt <= (decimale-nbDecimales); Cpt++ ) {
   		//   champ += '0';
   	//}
   	
   	EF.value=champ;

	return true;
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
	
  	if (!VerifierDec( EF,5,2))
  	{ 
  	    return false; 
  	}

	tab = Obj.split('_');
	i=tab[1];
	j=tab[2];
	
	// NE PAS SUPPRIMER LE BLOC SUIVANT : utilisé pour détecter que le réestimé a été modifié
	tab_oldconso=eval("document.forms[0].old_"+i+"_"+j).value.split(',');
	old_conso=tab_oldconso[0]+(tab_oldconso[1]==undefined?"":'.'+tab_oldconso[1]);
	old_conso_to_compare = old_conso;

    rees_p = eval("document.forms[0].rees_"+i+"_"+j).value;
    old_v = eval("document.forms[0].old_"+i+"_"+j).value;
    old_total_rees_mois_v = eval("document.forms[0].total_rees_"+i).value;
    old_tot_mois_v = eval("document.forms[0].tot_mois_"+j).value;
    old_total_rees_v = eval("document.forms[0].total_rees").value;
    
    tab_rees_v=rees_p.split('.');
    if(tab_rees_v[1]==undefined)
         rees_v = rees_p;
    else
    	 rees_v=tab_rees_v[0]+(tab_rees_v[1]==undefined?"":','+tab_rees_v[1]);
	
   
    
    tab_rees_v=rees_v.split(',');
	rees_p=tab_rees_v[0]+(tab_rees_v[1]==undefined?"":'.'+tab_rees_v[1]);
    
    
    tab_old_v=old_v.split(',');
	old_p=tab_old_v[0]+(tab_old_v[1]==undefined?"":'.'+tab_old_v[1]);
    
    
    tab_old_total_rees_mois_v=old_total_rees_mois_v.split(',');
	old_total_rees_mois_p=tab_old_total_rees_mois_v[0]+(tab_old_total_rees_mois_v[1]==undefined?"":'.'+tab_old_total_rees_mois_v[1]);
	
		
	tab_old_tot_mois_v=old_tot_mois_v.split(',');
	old_tot_mois_p=tab_old_tot_mois_v[0]+(tab_old_tot_mois_v[1]==undefined?"":'.'+tab_old_tot_mois_v[1]);
	
	
	tab_old_total_rees_v=old_total_rees_v.split(',');
	old_total_rees_p=tab_old_total_rees_v[0]+(tab_old_total_rees_v[1]==undefined?"":'.'+tab_old_total_rees_v[1]);
    
          
   
    total_rees_mois_p=parseFloat(old_total_rees_mois_p)-parseFloat(old_p)+parseFloat(rees_p);
    tot_mois_p=parseFloat(old_tot_mois_p)-parseFloat(old_p)+parseFloat(rees_p);
    total_rees_p=parseFloat(old_total_rees_p)-parseFloat(old_p)+parseFloat(rees_p);
   
      
    total_rees_mois_p=Math.round(total_rees_mois_p*100)/100;
    tot_mois_p=Math.round(tot_mois_p*100)/100;
    total_rees_p= Math.round(total_rees_p*100)/100;
      
    
    tab_total_rees_mois_p=total_rees_mois_p.toString().split('.');
	total_rees_mois_v=tab_total_rees_mois_p[0]+(tab_total_rees_mois_p[1]==undefined?"":','+tab_total_rees_mois_p[1]);
	
		
	tab_tot_mois_p=tot_mois_p.toString().split('.');
	tot_mois_v=tab_tot_mois_p[0]+(tab_tot_mois_p[1]==undefined?"":','+tab_tot_mois_p[1]);
	
	
	tab_total_rees_p=total_rees_p.toString().split('.');
	total_rees_v=tab_total_rees_p[0]+(tab_total_rees_p[1]==undefined?"":','+tab_total_rees_p[1]);
        

    eval("document.forms[0].rees_"+i+"_"+j).value = rees_v;
    eval("document.forms[0].old_"+i+"_"+j).value = rees_v;
    eval("document.forms[0].total_rees_"+i).value = total_rees_mois_v;
    eval("document.forms[0].tot_mois_"+j).value = tot_mois_v;
    eval("document.forms[0].total_rees").value = total_rees_v;
    
    // TD 659 ajout du calcul du reestimée 
    total_reest_mois_v = parseFloat(total_rees_mois_v.replace(",",".")) + parseFloat(eval("document.forms[0].total_cons_"+i).value.replace(",",".")); 
    total_reest_v = parseFloat(total_rees_v.replace(",",".")) + parseFloat(eval("document.forms[0].total_cons").value.replace(",","."));
    
    eval("document.forms[0].total_reest_"+i).value = total_reest_mois_v.toString().replace(".",",");
    eval("document.forms[0].total_reest").value = total_reest_v.toString().replace(".",",");
    
    // NE PAS SUPPRIMER : utilisé pour détecter l'ajout d'une activité alors que le réestimé a été modifié
	// on flag modifRees à true si on a bien effectué une modification sur le réestimé pour tester
	// dans le cas de l'ajout d'une activité s'il faut sauvegarder les modifications ou pas
	if (old_conso_to_compare != EF.value) {
		document.forms[0].modifRees.value = 'true';
	}
	tab_conso=EF.value.split('.');
	CONSO=tab_conso[0]+(tab_conso[1]==undefined?"":','+tab_conso[1]);

	EF.value=CONSO;

	return true;
 
}



function Verifier(form, action, flag)
{
   
   VerifierSaisieRees(form, action, flag);
   
}


function ValiderEcran(form)
{
	if (document.forms[0].bloquerEnvoi.value=='true') {
		document.forms[0].bloquerEnvoi.value=='false';
	    return false;
	} else {
	    return true;
	}
}

function paginer(page, index , action){
	document.forms[0].action.value = action;
	document.forms[0].page.value   = page;
    document.forms[0].index.value  = index;
    document.forms[0].submit();
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
          <td background="../images/ligne.gif"></td>
        </tr>
        <tr> 
          <td height="20" class="TitrePage"><!-- #BeginEditable "titre_page" -->
          Saisie du R&eacute;estim&eacute;
           <!-- #EndEditable --></td>
        </tr>
        <tr> 
          <td background="../images/ligne.gif"></td>
        </tr>
        <tr> 
          <td> </td>
        </tr>
        <tr> 
          <td> 
            <!-- #BeginEditable "debut_form" -->
            <html:form action="/saisieRees"  onsubmit="return ValiderEcran(this);">
            <!-- #EndEditable --> 
            <table width="100%" border="0">
              <tr> 
                <td> 
                  <div align="center"><!-- #BeginEditable "contenu" -->
				    <input type="hidden" name="pageAide" value="<%= sPageAide %>">
                    <input type="hidden" name="indexMenu" value="<%= sIndexMenu %>">
                    <html:hidden property="action"/>
<html:hidden property="arborescence" value="<%= arborescence %>"/>
                    <html:hidden property="page" value="modifier"/>
                    <input type="hidden" name="index" value="modifier">
                    <html:hidden property="annee"/>
                    <html:hidden property="nbmois"/>
                    <html:hidden property="date_depart"/>
                    <html:hidden property="date_arrivee"/>
                    <html:hidden property="ident"/>
                    <html:hidden property="type_ress"/> <!--type de la ressource-->
                    <html:hidden property="position"/> <!--position de la ressource dans la liste-->
		            <html:hidden property="posScen"/> <!--position du sénario dans la liste-->
		            <html:hidden property="modifRees"/> <!--le réestimé a-t-il été modifié ?-->
                    <input type="hidden" name="bloquerEnvoi" value="false"> <!--pour bloquer l'envoi du formulaire -->
                   
				    <table border=0 cellspacing=0 cellpadding=2 class="tableBleu">
                      <tr>
                        <td>&nbsp;</td>
                        <td><b>Code D&eacute;partement/P&ocirc;le/Groupe : <bean:write name="saisieReesForm" property="codsg"/></b>
                           <html:hidden property="codsg"/>
                        </td>
                        <td>&nbsp;</td>
                        <td><b>Sc&eacute;nario : <bean:write name="saisieReesForm" property="code_scenario"/></b>
                          <html:hidden property="code_scenario"/>
                        </td>
                        <td>&nbsp;</td>
                      </tr>
                      <tr>
                        <td>&nbsp;</td>
                        <td><b>Ressource : <bean:write name="saisieReesForm" property="ressource"/></b>
                           <html:hidden property="ressource"/>
                        </td>
                        <td>&nbsp;</td>
                        <td>&nbsp;</td>
                        <td align="right">
                        	<html:submit property="boutonInitialiser" disabled="<%= disableInit %>" value="Initialiser" styleClass="input" onclick="Verifier(this.form, 'refresh', true);"/>
                        </td>
                      </tr>
                      <tr>
                        <td>&nbsp;</td>
                        <td colspan="3" align="center"><b>Ajout activit&eacute; : </b>
		               		<html:select property="newCodeActivite" size="1" styleClass="input">
								<html:options collection="choixActivite" property="cle" labelProperty="libelle"/>
							</html:select>
							<html:submit property="boutonActivite" value="Cr&eacute;er" styleClass="input" onclick="Verifier(this.form, 'creer', true);"/>
                        </td>
                        <td>&nbsp;</td>
                      </tr>
                      <tr>
                        <td colspan="5">
                        <!-- Tableau de saisie -->
                          <table border="0" cellspacing="0" cellpadding="2" >
                            <tr>
					          <td height="10" class="libisac">Activit&eacute;</td>
					          <td align="center" width="40" class="libisac">jan</td>
					          <td align="center" width="40" class="libisac">f&eacute;v</td>
					          <td align="center" width="40" class="libisac">mar</td>
					          <td align="center" width="40" class="libisac">avr</td>
					          <td align="center" width="40" class="libisac">mai</td>
					          <td align="center" width="40" class="libisac">jun</td>
					          <td align="center" width="40" class="libisac">jul</td>
					          <td align="center" width="40" class="libisac">ao&ucirc;</td>
					          <td align="center" width="40" class="libisac">sep</td>
					          <td align="center" width="40" class="libisac">oct</td>
					          <td align="center" width="40" class="libisac">nov</td>
					          <td align="center" width="40" class="libisac">d&eacute;c</td>
					          <td align="center" width="40" class="libisac">Total</td>
					          <td align="center" width="40" class="libisac">RAF</td>
					          <td align="center" width="40" class="libisac">Réest</td>
				            </tr>
      		<logic:iterate id="element" name="listeReestimes" length="<%= listeReestimes.getCountInBlock() %>" 
            		offset="<%= listeReestimes.getOffset(0) %>" type="com.socgen.bip.metier.ReestimeOutil" indexId="index"> 


			<% if ( i == 0) i = 1; else i = 0;
			   nbligne ++;
			   libCode_activite="code_activite_"+nbligne;
			   libTotalCons="total_cons_"+nbligne;
			   libTotalRees="total_rees_"+nbligne;
			   libTotalReest="total_reest_"+nbligne;
			%>
                            <tr class="<%= strTabCols[i] %>">
   					          <td >
                                <bean:write name="element" property="code_activite" />
                                <input type="hidden" name="<%=libCode_activite%>" value="<bean:write name="element" property="code_activite" />">
                              </td>
				<%	
/*	Affichage du consommé sur l'activité en cours pour les mois avant la mensuelle */
				    String rees = "";
					k = (new Integer(nbMois)).intValue();
				    Class[] parameterString = {};
				    Object oRees=null;
					for (j=1 ; j<=12;j++) {
						//mois = j-1;
                        libConso = "conso_"+nbligne+"_"+j;
                        libRees = "rees_"+nbligne+"_"+j;
                        libOld = "old_"+nbligne+"_"+j;
                        try {
                        	Object[] param1 = {};
                     
                        	oRees=element.getClass().getDeclaredMethod("getRees_"+j,parameterString).invoke((Object) element, param1);
                        	if (oRees!=null) rees=oRees.toString();
                        	else rees="";
							
						if(j<mois_depart){
							/* Affichage conso si (mois < mois courant) ou (mois < mois_arrivee) */
							if ( (j<=k) || (j<mois_arrivee)) {
				%>
                              <td align="center">
								<input readonly class="inputgras" type="text" size="3" name="<%=libConso%>" value="<%=rees%>" >
                                <input type="hidden" name="<%=libOld%>" value="<%=rees%>">
                              </td>
				<%			} else {
				%>
                              <td align="center">
								<input <bean:write name="element" property="fermee" /> type='text' size=2 name="<%=libRees%>" value="<%=rees%>" onChange="return CalculerTotMois(this.name,this);" >
                                <input type="hidden" name="<%=libOld%>" value="<%=rees%>">
                              </td>
				<%			}
						}
						else
						{
			    %>			
							<td align="center">
								<input readonly class="inputgras" type="text" size="3" name="<%=libRees%>" value="0">
                                <input type="hidden" name="<%=libOld%>" value="0">
                              </td>
				<%		}  
				
						} catch (NoSuchMethodException me) { %>
							NoSuchMethodException 
				<%		} catch (SecurityException se) { %>
							SecurityException
				<%		} catch (IllegalAccessException ia) { %>
							IllegalAccessException
				<%		} catch (IllegalArgumentException iae) { %>
							IllegalArgumentException
				<%		} catch (InvocationTargetException ite) { %>
							InvocationTargetException
				<%		}
					}//for
				%>
                              <!-- Total Consommé -->
	                          <td align="right">
                                <input readonly class="inputgras" type="text" size=3 
                                 name="<%=libTotalCons%>" value="<bean:write name="element" property="total_cons" />">
                              </td>
                              <!-- Total Réestimé -->
	                          <td align="right">
                                <input readonly class="inputgras" type="text" size=3 
                                 name="<%=libTotalRees%>" value="<bean:write name="element" property="total_rees" />">
                              </td>
                              <% 
                              try {
                              Object[] param1 = {};
                              float total_cons = 0;
                              float total_rees = 0;
                              float total_reest= 0;
                              String result="";
                              
                              Object oTotal_cons=null;
                              Object oTotal_rees=null;
                              
                              oTotal_cons = element.getClass().getDeclaredMethod("getTotal_cons",parameterString).invoke((Object) element, param1);
                              
                              
                              if (oTotal_cons!=null) total_cons= Float.parseFloat( oTotal_cons.toString().replace(",",".") );
                          	else total_cons=0;
                              
                              oTotal_rees= element.getClass().getDeclaredMethod("getTotal_rees",parameterString).invoke((Object) element, param1);
                              if (oTotal_rees!=null) total_rees=  Float.parseFloat(oTotal_rees.toString().replace(",",".") );
                          	else total_rees=0;
                              
                              total_reest=total_rees+total_cons;
								result= Float.toString(total_reest).replace(".0","").replace(".",",");
                              %>                   
                              <td align="right">
                                <input readonly class="inputgras" type="text" size=3 
                                 name="<%=libTotalReest%>" value="<%=result%>">
                              </td>
                              <%
                                                            } catch (NoSuchMethodException me) { %>
  							NoSuchMethodException 
  				<%		} catch (SecurityException se) { %>
  							SecurityException
  				<%		} catch (IllegalAccessException ia) { %>
  							IllegalAccessException
  				<%		} catch (IllegalArgumentException iae) { %>
  							IllegalArgumentException
  				<%		} catch (InvocationTargetException ite) { %>
  							InvocationTargetException
  				<%		}
                              %>
                            </tr>		
			</logic:iterate> 
                  
                            <tr>
                              <td align="center" class="libisac">Total</td>
                              <td align="right" class="libisac">
                                <% if(1<mois_depart){ %>
                              	
                                      <B> <html:text property="tot_mois_1" styleClass="inputgras" size="2" readonly="true"/> </B>
                                      <html:hidden property="old_tot_mois_1"/>
                                
                                <% }else {%>
                                
                                      <B> <html:text property="tot_mois_1" styleClass="inputgras" size="2" readonly="true" value="0"/> </B>
                                      <html:hidden property="old_tot_mois_1" value="0"/>
                                
                                <% } %>
                              </td>
                              <td align="right" class="libisac">
                                <% if(2<mois_depart){ %>
                              	
                                      <B> <html:text property="tot_mois_2" styleClass="inputgras" size="2" readonly="true"/> </B>
                                      <html:hidden property="old_tot_mois_2"/>
                                
                                <% }else {%>
                                
                                      <B> <html:text property="tot_mois_2" styleClass="inputgras" size="2" readonly="true" value="0"/> </B>
                                      <html:hidden property="old_tot_mois_2" value="0"/>
                                
                                <% } %>
                              </td>
                              <td align="right" class="libisac">
                                <% if(3<mois_depart){ %>
                              	
                                      <B> <html:text property="tot_mois_3" styleClass="inputgras" size="2" readonly="true"/> </B>
                                      <html:hidden property="old_tot_mois_3"/>
                                
                                <% }else {%>
                                
                                      <B> <html:text property="tot_mois_3" styleClass="inputgras" size="2" readonly="true" value="0"/> </B>
                                      <html:hidden property="old_tot_mois_3" value="0"/>
                                
                                <% } %>
                              </td>
                              <td align="right" class="libisac">
                                <% if(4<mois_depart){ %>
                              	
                                      <B> <html:text property="tot_mois_4" styleClass="inputgras" size="2" readonly="true"/> </B>
                                      <html:hidden property="old_tot_mois_4"/>
                                
                                <% }else {%>
                                
                                      <B> <html:text property="tot_mois_4" styleClass="inputgras" size="2" readonly="true" value="0"/> </B>
                                      <html:hidden property="old_tot_mois_4" value="0"/>
                                
                                <% } %>
                              </td>
                              <td align="right" class="libisac">
                                <% if(5<mois_depart){ %>
                              	
                                      <B> <html:text property="tot_mois_5" styleClass="inputgras" size="2" readonly="true"/> </B>
                                      <html:hidden property="old_tot_mois_5"/>
                                
                                <% }else {%>
                                
                                      <B> <html:text property="tot_mois_5" styleClass="inputgras" size="2" readonly="true" value="0"/> </B>
                                      <html:hidden property="old_tot_mois_5" value="0"/>
                                
                                <% } %>
                              </td>
                              <td align="right" class="libisac">
                                <% if(6<mois_depart){ %>
                              	
                                      <B> <html:text property="tot_mois_6" styleClass="inputgras" size="2" readonly="true"/> </B>
                                      <html:hidden property="old_tot_mois_6"/>
                                
                                <% }else {%>
                                
                                      <B> <html:text property="tot_mois_6" styleClass="inputgras" size="2" readonly="true" value="0"/> </B>
                                      <html:hidden property="old_tot_mois_6" value="0"/>
                                
                                <% } %>
                              </td>
                              <td align="right" class="libisac">
                                <% if(7<mois_depart){ %>
                              	
                                      <B> <html:text property="tot_mois_7" styleClass="inputgras" size="2" readonly="true"/> </B>
                                      <html:hidden property="old_tot_mois_7"/>
                                
                                <% }else {%>
                                
                                      <B> <html:text property="tot_mois_7" styleClass="inputgras" size="2" readonly="true" value="0"/> </B>
                                      <html:hidden property="old_tot_mois_7" value="0"/>
                                
                                <% } %>
                              </td>
                              <td align="right" class="libisac">
                                <% if(8<mois_depart){ %>
                              	
                                      <B> <html:text property="tot_mois_8" styleClass="inputgras" size="2" readonly="true"/> </B>
                                      <html:hidden property="old_tot_mois_8"/>
                                
                                <% }else {%>
                                
                                      <B> <html:text property="tot_mois_8" styleClass="inputgras" size="2" readonly="true" value="0"/> </B>
                                      <html:hidden property="old_tot_mois_8" value="0"/>
                                
                                <% } %>
                              </td>
                              <td align="right" class="libisac">
                                <% if(9<mois_depart){ %>
                              	
                                      <B> <html:text property="tot_mois_9" styleClass="inputgras" size="2" readonly="true"/> </B>
                                      <html:hidden property="old_tot_mois_9"/>
                                
                                <% }else {%>
                                
                                      <B> <html:text property="tot_mois_9" styleClass="inputgras" size="2" readonly="true" value="0"/> </B>
                                      <html:hidden property="old_tot_mois_9" value="0"/>
                                
                                <% } %>
                              </td>
                              <td align="right" class="libisac">
                                <% if(10<mois_depart){ %>
                              	
                                      <B> <html:text property="tot_mois_10" styleClass="inputgras" size="2" readonly="true"/> </B>
                                      <html:hidden property="old_tot_mois_10"/>
                                
                                <% }else {%>
                                
                                      <B> <html:text property="tot_mois_10" styleClass="inputgras" size="2" readonly="true" value="0"/> </B>
                                      <html:hidden property="old_tot_mois_10" value="0"/>
                                
                                <% } %>
                              </td>
                              <td align="right" class="libisac">
                                <% if(11<mois_depart){ %>
                              	
                                      <B> <html:text property="tot_mois_11" styleClass="inputgras" size="2" readonly="true"/> </B>
                                      <html:hidden property="old_tot_mois_11"/>
                                
                                <% }else {%>
                                
                                      <B> <html:text property="tot_mois_11" styleClass="inputgras" size="2" readonly="true" value="0"/> </B>
                                      <html:hidden property="old_tot_mois_11" value="0"/>
                                
                                <% } %>
                              </td>
                              <td align="right" class="libisac">
                              	<% if(12<mois_depart){ %>
                              	
                                      <B> <html:text property="tot_mois_12" styleClass="inputgras" size="2" readonly="true"/> </B>
                                      <html:hidden property="old_tot_mois_12"/>
                                
                                <% }else {%>
                                
                                      <B> <html:text property="tot_mois_12" styleClass="inputgras" size="2" readonly="true" value="0"/> </B>
                                      <html:hidden property="old_tot_mois_12" value="0"/>
                                
                                <% } %>
                                
                              </td>

                              <td align="right" class="libisac"> 
                                <html:text  property="total_cons" styleClass="inputgras" size="3" readonly="true"/>
                              </td>
                              
                              <!-- Total réestimé -->
                              <td align="right" class="libisac"> 
                                <html:text  property="total_rees" styleClass="inputgras" size="3" readonly="true"/>
                              </td>
                              <% 
                              float total_reest=0;
                              DecimalFormat form = new DecimalFormat("0.##");
                                             
                              
                              
                              float var1=Float.parseFloat(saisieReesForm.getTotal_cons().replace(",","."));
                                                    
                              float var2=Float.parseFloat(saisieReesForm.getTotal_rees().replace(",","."));
                           
                                                          
                              
                              total_reest=var1 + var2;
                              %> 
                              <td align="right">
                                <input readonly class="inputgras" type="text" size=3 
                                 name="total_reest" value="<%=form.format(total_reest)%>">
                              </td>
                            </tr>
                            <tr>
							  <td align="center" class="libisac">Nombre de jours ouvr&eacute;s</td>
							  <td align="right" class="libisac">&nbsp;&nbsp;&nbsp;&nbsp;<bean:write name="saisieReesForm" property="nbjour_1" />&nbsp;<html:hidden property="nbjour_1"/></td>
							  <td align="right" class="libisac">&nbsp;&nbsp;&nbsp;&nbsp;<bean:write name="saisieReesForm" property="nbjour_2" />&nbsp;<html:hidden property="nbjour_2"/></td>
							  <td align="right" class="libisac">&nbsp;&nbsp;&nbsp;&nbsp;<bean:write name="saisieReesForm" property="nbjour_3" />&nbsp;<html:hidden property="nbjour_3"/></td>
							  <td align="right" class="libisac">&nbsp;&nbsp;&nbsp;&nbsp;<bean:write name="saisieReesForm" property="nbjour_4" />&nbsp;<html:hidden property="nbjour_4"/></td>
							  <td align="right" class="libisac">&nbsp;&nbsp;&nbsp;&nbsp;<bean:write name="saisieReesForm" property="nbjour_5" />&nbsp;<html:hidden property="nbjour_5"/></td>
							  <td align="right" class="libisac">&nbsp;&nbsp;&nbsp;&nbsp;<bean:write name="saisieReesForm" property="nbjour_6" />&nbsp;<html:hidden property="nbjour_6"/></td>
							  <td align="right" class="libisac">&nbsp;&nbsp;&nbsp;&nbsp;<bean:write name="saisieReesForm" property="nbjour_7" />&nbsp;<html:hidden property="nbjour_7"/></td>
							  <td align="right" class="libisac">&nbsp;&nbsp;&nbsp;&nbsp;<bean:write name="saisieReesForm" property="nbjour_8" />&nbsp;<html:hidden property="nbjour_8"/></td>
							  <td align="right" class="libisac">&nbsp;&nbsp;&nbsp;&nbsp;<bean:write name="saisieReesForm" property="nbjour_9" />&nbsp;<html:hidden property="nbjour_9"/></td>
							  <td align="right" class="libisac">&nbsp;&nbsp;&nbsp;&nbsp;<bean:write name="saisieReesForm" property="nbjour_10" />&nbsp;<html:hidden property="nbjour_10"/></td>
							  <td align="right" class="libisac">&nbsp;&nbsp;&nbsp;&nbsp;<bean:write name="saisieReesForm" property="nbjour_11" />&nbsp;<html:hidden property="nbjour_11"/></td>
							  <td align="right" class="libisac">&nbsp;&nbsp;&nbsp;&nbsp;<bean:write name="saisieReesForm" property="nbjour_12" />&nbsp;<html:hidden property="nbjour_12"/></td>
							  <td class="libisac">&nbsp;</td>
							  <td class="libisac">&nbsp;</td>
							  <td class="libisac">&nbsp;</td>
                            </tr>
                   
                          </table>
             
             	          <table width="100%" border="0" cellspacing="0" cellpadding="0">
			   	            <tr>
					          <td align="center" colspan="4" class="contenu">
						        <bip:pagination beanName="listeReestimes"/>
					          </td>
				            </tr>
	 			            <tr><td colspan="4">&nbsp;</td></tr>
	 			            <tr>
              		          <td width="25%">&nbsp;</td>
                	          <td width="25%">
                	            <div align="center">
                	              <html:submit property="boutonValider" value="Valider" styleClass="input" onclick="Verifier(this.form, 'valider', true);"/>
                	            </div>
               		          </td> 
               		          <td width="25%"> 
                  	            <div align="center"> 
                	              <html:submit property="boutonAnnuler" value="Annuler" styleClass="input" onclick="Verifier(this.form, 'annuler', false);"/>
              		            </div>
                              </td>
                              <td width="25%">&nbsp;</td>
            	            </tr>
     
				          </table>
				        </td>
            	      </tr>
     
				    </table>
				  </table>

                  </div>
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
<% 
Integer id_webo_page = new Integer("4006"); 
com.socgen.bip.commun.form.AutomateForm formWebo = saisieReesForm ;
%>
<%@ include file="/incWebo.jsp" %>
</html:html>
