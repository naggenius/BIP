<%@ taglib uri="/WEB-INF/struts-bean.tld" prefix="bean" %>
<%@ taglib uri="/WEB-INF/struts-html.tld" prefix="html" %>
<%@ taglib uri="/WEB-INF/struts-logic.tld" prefix="logic" %>

<%@ page language="java" import="org.owasp.esapi.ESAPI,java.sql.*,java.io.*,javax.servlet.*,javax.servlet.http.*,com.socgen.ich.ihm.*,java.lang.NullPointerException.*,java.io.IOException.*,java.io.IOException.*"    errorPage="../jsp/erreur.jsp"  %>
<jsp:useBean id="editionForm" scope="request" class="com.socgen.bip.commun.form.EditionForm" />
<html:html locale="true">
<head>


<%@ taglib uri="/WEB-INF/bip.tld" prefix="bip" %>

<!-- HMI PPM 62325 $4.3 -->
<title>Edition</title>

<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<script language="JavaScript" src="../js/function.cjs"></script>
<link rel="stylesheet" href="../css/style_bip_new.css" type="text/css">
<script language="JavaScript">
// var pageAide = "aide/hvide.htm";
var pageAide ;

<%
editionForm.setP_param9("1");
editionForm.setListeReports("1");
// document.editionForm.listeReports.value = '1';
System.out.println("AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA");

String p7 = ESAPI.encoder().encodeForJavaScript(ESAPI.encoder().canonicalize(request.getParameter("p7")));
String p6 = ESAPI.encoder().encodeForJavaScript(ESAPI.encoder().canonicalize(request.getParameter("p6")));
String p8 = ESAPI.encoder().encodeForJavaScript(ESAPI.encoder().canonicalize(request.getParameter("p8")));

editionForm.setP_param6(ESAPI.encoder().encodeForJavaScript(ESAPI.encoder().canonicalize(request.getParameter("p6"))));
editionForm.setP_param7(ESAPI.encoder().encodeForJavaScript(ESAPI.encoder().canonicalize(request.getParameter("p7"))));
editionForm.setP_param8(ESAPI.encoder().encodeForJavaScript(ESAPI.encoder().canonicalize(request.getParameter("p8"))));

System.out.println("NEWWWWWW PARAM6: " +editionForm.getP_param6() );
System.out.println("NEWWWWWW PARAM7: " +editionForm.getP_param7() );
System.out.println("NEWWWWWW PARAM8: " +editionForm.getP_param8() );

System.out.println("sParam7: " + p7);
System.out.println("sParam6: " + p6);
System.out.println("sParam8: " + p8);
		Hashtable hKeyListDossierProjet= new Hashtable();
		hKeyListDossierProjet.put("userid", ((com.socgen.bip.user.UserBip)session.getAttribute("UserBip")).getInfosUser());
		
		System.out.println("USERRRRRRRRRRRRRRRRR: " + ((com.socgen.bip.user.UserBip)session.getAttribute("UserBip")).getInfosUser());
		
// 		hKeyListDossierProjet.put("p_param6","Tous");
// 		hKeyListDossierProjet.put("p_param7","Tous");
// 		hKeyListDossierProjet.put("p_param8","Tous");
		
		if (request.getParameter("p6") != null) {
			hKeyListDossierProjet.put("p_param6",request.getParameter("p6"));
		}
		if (request.getParameter("p8") != null) {
			hKeyListDossierProjet.put("p_param8",request.getParameter("p8"));
		}
		if (request.getParameter("p7") != null) {
			hKeyListDossierProjet.put("p_param7",request.getParameter("p7"));
		}
		
		Hashtable hKeyListDpCopi= new Hashtable();
		hKeyListDpCopi.put("userid", ((com.socgen.bip.user.UserBip)session.getAttribute("UserBip")).getInfosUser());
		
		hKeyListDpCopi.put("p_param6","Tous");
		hKeyListDpCopi.put("p_param7","Tous");
		hKeyListDpCopi.put("p_param8","Tous");
		
		System.out.println("p_param7: " + request.getParameter("p7"));
		if (request.getParameter("p7") != null) {
			hKeyListDpCopi.put("p_param7",request.getParameter("p7"));
		}
		if (request.getParameter("p8") != null) {
			hKeyListDpCopi.put("p_param8",request.getParameter("p8"));
		}
		if (request.getParameter("p6") != null) {
			hKeyListDpCopi.put("p_param6",request.getParameter("p6"));
		}
		
		Hashtable hKeyListRefDemande= new Hashtable();
		hKeyListRefDemande.put("userid", ((com.socgen.bip.user.UserBip)session.getAttribute("UserBip")).getInfosUser());
		hKeyListRefDemande.put("p_param6","Tous");
		hKeyListRefDemande.put("p_param7","Tous");
		hKeyListRefDemande.put("p_param8","Tous");
		
		if (request.getParameter("p6") != null) {
			hKeyListRefDemande.put("p_param6",request.getParameter("p6"));
		}
		if (request.getParameter("p7") != null) {
			hKeyListRefDemande.put("p_param7",request.getParameter("p7"));
		}
		if (request.getParameter("p8") != null) {
			hKeyListRefDemande.put("p_param8",request.getParameter("p8"));
		}
		
		System.out.println("JJJJJJJJJJ1");
		try{
		java.util.ArrayList  list1 = new com.socgen.bip.commun.liste.ListeDynamique().getListeDynamique("suivi_budg_dossier_projet",hKeyListDossierProjet);
		System.out.println("JJJJJJJJJJ2");
		
// 		java.util.ArrayList  list1 = new com.socgen.bip.commun.liste.ListeDynamique().getListeDynamique("dossier_projet",hKeyListDossierProjet);
		System.out.println("list1: " + list1.size());
		pageContext.setAttribute("listDossierProjet", list1);
		}
		catch(Exception e){
			System.out.println("JJJJJJJJJJ3");
			editionForm.setMsgErreur("Compte-tenu de votre habilitation à des Dossiers projets, cette fonction ne peut vous restituer aucune information");
			editionForm.setMode("list1 vide");
				
		}
		
		try{
		java.util.ArrayList  list2 = new com.socgen.bip.commun.liste.ListeDynamique().getListeDynamique("dossier_projet_copi",hKeyListDpCopi);
		System.out.println("list2: " + list2.size());
		pageContext.setAttribute("listDpCopi", list2);
		}
		
		catch(Exception e){
			System.out.println("JJJJJJJJJJ33");
			editionForm.setMsgErreur("Compte-tenu de votre habilitation à des Dossiers projets, cette fonction ne peut vous restituer aucune information");
			
			if ((editionForm.getP_param7())  == null){
				editionForm.setMode("list2 vide");}
			
			else {
			
			editionForm.setP_param6("Tous");
			editionForm.setP_param7("Tous");
			editionForm.setP_param8("Tous");
			
// 			hKeyListDossierProjet.put("p_param6","Tous");
// 			hKeyListDossierProjet.put("p_param7","Tous");
// 			hKeyListDossierProjet.put("p_param8","Tous");
			java.util.ArrayList  list1 = new com.socgen.bip.commun.liste.ListeDynamique().getListeDynamique("suivi_budg_dossier_projet",hKeyListDossierProjet);
			if (list1!=null && !list1.isEmpty()){
				  list1 = new com.socgen.bip.commun.liste.ListeDynamique().getListeDynamique("suivi_budg_dossier_projet",hKeyListDossierProjet);
				pageContext.setAttribute("listDossierProjet", list1);
			}		
			
			}
			
			System.out.println("VVVVVVVCCCC PARAM6: " +editionForm.getP_param6() );
			System.out.println("VVVVVVVCCCC PARAM7: " +editionForm.getP_param7() );
			System.out.println("VVVVVVVCCCC PARAM8: " +editionForm.getP_param8() );
			
				
		}
		
		finally{
		java.util.ArrayList  list3 = new com.socgen.bip.commun.liste.ListeDynamique().getListeDynamique("ref_demande",hKeyListRefDemande);
		System.out.println("list3: " + list3.size());
		pageContext.setAttribute("listRefDemande", list3);System.out.println("BBBBBBBBBBBBBBBBBBBBBBBBBB");}
		
		System.out.println("****** PARAM6: ****** " +editionForm.getP_param6() );
		System.out.println("**** PARAM7: **** " +editionForm.getP_param7() );
		System.out.println("**** PARAM8: ****" +editionForm.getP_param8() );
		
		
%>



var blnVerification = true;
// document.editionForm.listeReports.value = '1';
<%System.out.println("CCCCCCCCCCCCCCCCCCCCCCCCC");
	String arborescence = ESAPI.encoder().encodeForJavaScript(ESAPI.encoder().canonicalize(request.getParameter("arborescence")));System.out.println("DDDDDDDDDDDDDDDDDDDDDDDDDDDD");
String sPageAide = ESAPI.encoder().encodeForJavaScript(ESAPI.encoder().canonicalize(request.getParameter("pageAide")));System.out.println("EEEEEEEEEEEEEEEEEEEEEEEEE");
%>
var pageAide = "<%= sPageAide %>";

var choixEffectue = false;
var choixPresentation = true;
var refChoisi = ""


	


<%
	String sTitre = "Suivi budgétaire de projets";
	String sInitial;
	String sJobId = "e_suivibudgproj";
%>




function MessageInitial(){
	
	var Message="<bean:write filter="false"  name="editionForm"  property="msgErreur" />";
	<%System.out.println("VVVVVVVVVV"+editionForm.getMsgErreur());
	System.out.println("YYYYYYY"+editionForm.getMode());
	System.out.println("BOUTONNNNNNN"+editionForm.getP_param9());
	%>
	var Focus = "<bean:write name="editionForm"  property="focus" />";
	
	if (Message != "") {
		alert(Message);
	}
	<%System.out.println("SSSSSSS");%>
	
	<%System.out.println("GGGGGGGGGGG");%>
	
	<%
// 	sJobId = ESAPI.encoder().encodeForJavaScript(ESAPI.encoder().canonicalize(request.getParameter("jobId")));
	System.out.println("sJobId : " + sJobId);
	
	
	
	sInitial=ESAPI.encoder().encodeForJavaScript(ESAPI.encoder().canonicalize(request.getQueryString()));
	System.out.println("sInitial : " + sInitial);
	if (sInitial == null)
		sInitial = request.getRequestURI();
	else
		sInitial = request.getRequestURI() + "?" + sInitial;
	sInitial = sInitial.substring(request.getContextPath().length());
%>

	
}


function refreshEcran(value) {
		
	if (value=="P") {
		document.location.href="/jsp/SuiviBudgProj.jsp?p7="+document.forms[0].p_param7.value;
	}
	else 
		if (value=="D") {
			document.location.href="/jsp/SuiviBudgProj.jsp?p6="+document.forms[0].p_param6.value;
		}
		else 
			if (value=="R") {
				document.location.href="/jsp/SuiviBudgProj.jsp?p8="+document.forms[0].p_param8.value;
			}
	
//  	document.location.href="/jsp/SuiviBudgProj.jsp?p7="+document.forms[0].p_param7.value+"&p8="+document.forms[0].p_param8.value+"&p6="+document.forms[0].p_param6.value;
	

}


function aucuneOptionSelect(){
	 if((document.forms[0].p_param7.value == '') || (document.forms[0].p_param8.value == '') || (document.forms[0].p_param6.value == '')){
		return true;
		}
		return false;
	}

var blnVerification = true;
function Verifier(form, action, flag)
{

   blnVerification = flag;
   form.action.value = action;
}

function ValiderEcran(form){
	
	
	System.out.println("NEWW BOUTONNNNNNN NEWW1** "+editionForm.getP_param9());
<%-- 	 <% String choixPresentation = editionForm.getP_param9();%> --%>
<%-- 		document.editionForm.listeReports.value = <%= choixPresentation %> --%>

	 if (blnVerification == false) {
		
	  		form.action.value ="annuler";
	      return true;
	 }
	 else 
		 
		 if (blnVerification == true) {
			if(choixPresentation){
				var msg="<bean:write filter="false"  name="editionForm"  property="p_param9" />";
				
				document.editionForm.listeReports.value = msg;
			}
		     
// 				if (!choixEffectue) {
// 					alert("vous devez choisir 1 et 1 seul choix de présentation ");
// 					return false;
// 					}
// 				else 
		  		form.action.value ="liste";
				
			     return true ; 
		 }
	 	editionForm.setP_param6("");
		editionForm.setP_param7("");
		editionForm.setP_param8("");
		
		
}

function ChangeRef(newRef){
	
	if (newRef=="1") {
	
	refChoisi = "1";
	}
	else if (newRef=="2") {
	
	refChoisi = "2";
	}
	else if (newRef=="3") {
	
	refChoisi = "3";
	}
	document.editionForm.listeReports.value = refChoisi;
	
	choixEffectue=true;
}


function majListe(newRef)
{
	var msg1="<bean:write filter="false"  name="editionForm"  property="p_param9" />";
	
	
 	refChoisi = "";
	if (newRef == "1")
	{
		if (refChoisi == ""){
		refChoisi="1";
		
		choixEffectue=true;
		choixPresentation = false;
		}
		
		else if (refChoisi != ""){
			choixEffectue=false;	
			}
	}
	
	else if (newRef == "2")
	{
		if (refChoisi == ""){
			refChoisi="2";
			
		choixEffectue=true;
		choixPresentation = false;
		}
		
		else if (refChoisi != ""){
		choixEffectue=false;	
		}
	}
	
	else if (newRef == "3")
	{
		if (refChoisi == ""){
			refChoisi="3";
			
		choixEffectue=true;
		choixPresentation = false;
		}
		else if (refChoisi != ""){
		
			choixEffectue=false;	
		}
	}
	
	document.editionForm.listeReports.value = refChoisi;
	
}

</script>

</head>
<body bgcolor="#FFFFFF" text="#000000" topmargin="0" leftmargin="0" onLoad="MessageInitial();">
<div id="mainContainer">
<div id="topContainer" style="min-height:98%;">
<div id="entete"></div>
<div id="logo">
		<div id="logo_sg"><img src="../images/logo_SG.gif" width="162" height="33" border="0" /></div>
		<div id="nomdusite"><img src="../images/bip_logo.png" width="78" height="46" border="0" /></div>
</div>
<table width="100%" border="0" cellpadding="0" cellspacing="0">
  <tr> 
    <td> 
      <table width="100%" border="0" cellspacing="0" cellpadding="0">
<!-- 		<tr>  -->
<!--           <td></td> -->
<!--         </tr> -->
<!-- 		<tr >  -->
<!-- 		  <td></td> -->
<!--         </tr> -->
        <tr> 
          <td><div id="outils" align="center"><!-- #BeginEditable "barre_haut" -->
              <%ToolBarNew tb = new com.socgen.ich.ihm.ToolBarNew("bip_ihm",false,false,true,true,false,false,false,false,false,request) ;%>
				<%=tb.printHtml()%><!-- #EndEditable -->
		</div></td>
        </tr>
<!--         <tr>  -->
<!--           <td background="../images/ligne.gif"></td> -->
<!--         </tr> -->
        <tr> 
          <td height="20" class="TitrePage"><%=sTitre%></td>
        </tr>
        <tr> 
<!--           <td background="../images/ligne.gif"></td> -->
        </tr>
    <tr> 
          <td>
           <logic:notEqual name="editionForm"  property="mode" value="list2 vide"> 
           <logic:notEqual name="editionForm"  property="mode" value="list1 vide"> 
         
		  <html:form action="/edition" onsubmit="return ValiderEcran(this);"  >
            
			<html:hidden property="arborescence" value="<%= arborescence %>"/>
			<input type="hidden" name="jobId" value="<%=sJobId%>">
			<input type="hidden" name="initial" value="<%= sInitial %>">
			<html:hidden property="action"/>
<%-- 			<html:hidden property="p_param12" value="<%= arborescence %>"/> --%>
            <input type="hidden" name="listeReports" value="1">
           
                 
					
					
            <table width="100%" border="0">
              <tr>
        <td class=texte> Cet état prend en compte votre périmètre habilité sur les Dossiers projets </td>
        </tr>            
					
                <tr> 
                  <td> 
                    <div align="left">
					<table border="0" cellspacing=2 cellpadding=2 class="tableBleu" >
					<input type="hidden" name="pageAide" value="<%= sPageAide %>">
					  <tr>
                        <td colspan=3 align="center">&nbsp;</td>
                      </tr>
	               	  
                	
			                   
              	 <tr> 
          			<td td colspan=3>&nbsp;</td>
       		 	 </tr>    
               <logic:equal name="editionForm"  property="msgErreur" value=""> 
					<tr>
						<td class=texte width=90 nowrap="nowrap" valign="top" align="left"/>
<!-- 						<td class="texteGras" align=right width=20%><b>Dossier Projet : </b></td> -->
						<td class=texte width=90 nowrap="nowrap" valign="top" align="left">Dossier Projet : </td>
<!-- 						<td width=75%> -->
						 <td class=texte colspan="2" align="left" > 
							<html:select property="p_param7" styleClass="input"  onchange="refreshEcran('P')" size="5" style="width: 500px; border: 1px solid black;" > 
<!-- 							style="width: 4000px;"  -->
								<html:options collection="listDossierProjet" property="cle" labelProperty="libelle" />
							</html:select>
						</td>
					</tr>
					<tr>
                        <td colspan=3 align="center">&nbsp;</td>
                      </tr>
				</logic:equal>
				
				   <logic:notEqual name="editionForm"  property="msgErreur" value=""  > 

				   <% 
				   hKeyListDossierProjet.put("userid", ((com.socgen.bip.user.UserBip)session.getAttribute("UserBip")).getInfosUser());
				   
				   hKeyListDossierProjet.put("p_param6","Tous");
				   
				   
					hKeyListDossierProjet.put("p_param7","Tous");
					hKeyListDossierProjet.put("p_param8","Tous");
					java.util.ArrayList  list1  = new com.socgen.bip.commun.liste.ListeDynamique().getListeDynamique("suivi_budg_dossier_projet",hKeyListDossierProjet);
					 pageContext.setAttribute("listDossierProjet", list1);%>
					<tr>
						<td class=texte width=90 nowrap="nowrap" valign="top" align="left"/>
						<td class=texte width=90 nowrap="nowrap" valign="top" align="left">Dossier Projet : </td>
						 <td class=texte colspan="2" align="left" > 
							<html:select property="p_param7" styleClass="input"  onchange="refreshEcran('P')" size="5" style="width: 500px; border:1px;" > 
								<html:options collection="listDossierProjet" property="cle" labelProperty="libelle" />
							</html:select>
						</td>
					</tr>
					<tr>
                        <td colspan=3 align="center">&nbsp;</td>
                      </tr>
				</logic:notEqual>
				
				
			    <logic:equal name="editionForm"  property="msgErreur" value=""> 
			    
					<tr>
					<td class=texte width=90 nowrap="nowrap" valign="top" align="left"/>
<!-- 						<td class="texteGras" align=right width=20%><b>Lot DPCOPI : </b></td> -->
						<td class=texte width=90 nowrap="nowrap" valign="top" align="left">Lot DPCOPI : </td>
						 <td class=texte colspan="2" align="left" > 
							<html:select property="p_param6" styleClass="input" onchange="refreshEcran('D')" size="7" style="width: 500px; border:1px;" > 
								<html:options collection="listDpCopi" property="cle" labelProperty="libelle" />
							</html:select>
						</td>
					</tr>
					<tr>
                        <td colspan=3 align="center">&nbsp;</td>
                      </tr>
				</logic:equal>
			
			  <logic:notEqual name="editionForm"  property="msgErreur" value=""> 
			   <% 
			   hKeyListDpCopi.put("userid", ((com.socgen.bip.user.UserBip)session.getAttribute("UserBip")).getInfosUser());
			   hKeyListDpCopi.put("p_param6","Tous");
				hKeyListDpCopi.put("p_param7","Tous");
				hKeyListDpCopi.put("p_param8","Tous");
				
				java.util.ArrayList  list2 = new com.socgen.bip.commun.liste.ListeDynamique().getListeDynamique("dossier_projet_copi",hKeyListDpCopi);
				pageContext.setAttribute("listDpCopi", list2);
					 %>
					<tr>
					<td class=texte width=90 nowrap="nowrap" valign="top" align="left"/>
						<td class=texte width=90 nowrap="nowrap" valign="top" align="left">Lot DPCOPI : </td>
						 <td class=texte colspan="2" align="left" > 
							<html:select property="p_param6" styleClass="input" onchange="refreshEcran('D')" size="7" style="width: 500px; border:1px;" > 
								<html:options collection="listDpCopi" property="cle" labelProperty="libelle" />
							</html:select>
						</td>
					</tr>
					<tr>
                        <td colspan=3 align="center">&nbsp;</td>
                      </tr>
				</logic:notEqual>	
				
			    <logic:equal name="editionForm"  property="msgErreur" value=""> 	
					<tr>
					<td class=texte width=90 nowrap="nowrap" valign="top" align="left"/>
<!-- 						<td class="texteGras" align=right width=20%><b> Réf. Demande : </b></td> -->
						<td class=texte width=90 nowrap="nowrap" valign="top" align="left">Réf. Demande : </td>
						 <td class=texte colspan="2" align="left" > 
							<html:select property="p_param8" styleClass="input" onchange="refreshEcran('R')" size="10" style="width: 540px;" > 
								<html:options collection="listRefDemande" property="cle" labelProperty="libelle" />
							</html:select>
						</td>
						</tr>
						<tr>
                        <td colspan=3 align="center">&nbsp;</td>
                      </tr>
				</logic:equal>	
				
				<logic:notEqual name="editionForm"  property="msgErreur" value=""> 	
				  <%
				  hKeyListRefDemande.put("userid", ((com.socgen.bip.user.UserBip)session.getAttribute("UserBip")).getInfosUser());
				  hKeyListRefDemande.put("p_param6","Tous");
				  hKeyListRefDemande.put("p_param7","Tous");
				  hKeyListRefDemande.put("p_param8","Tous");
				  java.util.ArrayList  list3 = new com.socgen.bip.commun.liste.ListeDynamique().getListeDynamique("ref_demande",hKeyListRefDemande);
				  pageContext.setAttribute("listRefDemande", list3);
				  %>
					<tr>
					<td class=texte width=90 nowrap="nowrap" valign="top" align="left"/>
						<td class=texte width=90 nowrap="nowrap" valign="top" align="left">Réf. Demande : </td>
						 <td class=texte colspan="2" align="left" > 
							<html:select property="p_param8" styleClass="input" onchange="refreshEcran('R')" size="10" style="width: 540px; border:1px;" > 
								<html:options collection="listRefDemande" property="cle" labelProperty="libelle" />
							</html:select>
						</td>
						</tr>
						<tr>
                        <td colspan=3 align="center">&nbsp;</td>
                      </tr>
				</logic:notEqual>	
				
				
					  <tr>
                        <td colspan=3 align="center">&nbsp;</td>
                      </tr>
                  
<%--                  <% editionForm.setMsgErreur(""); %>  --%>
                  <tr>
<!--                  <td class="texteGras" align="center"  width=20%><b> Choix de la présentation :  </b></td> -->
				<td class=texte width=90 nowrap="nowrap" valign="top" align="left"/>
                 <td class=texte width=155 nowrap="nowrap" colspan="2">Choix de la présentation : </td>
                 <td align="center">&nbsp;</td>
                 </tr>
                 
                 <tr >
                 <table border="0" align="left">
                 <tr>
                 	<td width="180"> &nbsp; </td>
                 	<td><html:radio property="p_param9" styleClass="input" value="1" onclick="majListe(this.value);" /> </td>
					<td class=texte width="155" nowrap="nowrap"> Par Projet </td>
					
                   
                   <td> <html:radio property="p_param9" styleClass="input" value="2" onclick="majListe(this.value);" /></td>
<!--                    onclick="majListe(this.value);" -->
             	   <td class=texte width="155" nowrap="nowrap"> Par DPG </td>
              		<td><html:radio property="p_param9" styleClass="input" value="3" onclick="majListe(this.value);"/></td>
                 	<td class=texte width="155" nowrap="nowrap"> Synthèse complète</td>          		  						
					</tr>
					<tr><td colspan="7">&nbsp;</td></tr>
					 <tr>
					 <td width="180"> &nbsp; </td>
					 <td> &nbsp; </td>
					<td class=texte width="155" nowrap="nowrap" align="center">  <html:submit property="boutonValider" value="  Liste  " styleClass="input" onclick="Verifier(this.form, 'liste' , true);"/> </td>
					<td> &nbsp; </td> 
              		<td align="right"><html:submit property="boutonAnnuler" value="Annuler" styleClass="input" onclick="Verifier(this.form, 'annuler', false);"/> </td>
                 	<td> &nbsp; </td>
                 	<td> &nbsp; </td>
					</tr>
					</tr>
				</table>
			   		</table>
					</div>
                  </td>
                </tr>
            </table>
			</html:form>
			</logic:notEqual>
			</logic:notEqual>
          </td>
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


