<%@ taglib uri="/WEB-INF/struts-bean.tld" prefix="bean"%>
<%@ taglib uri="/WEB-INF/struts-html.tld" prefix="html"%>
<%@ taglib uri="/WEB-INF/struts-logic.tld" prefix="logic"%>
<!-- #BeginEditable "imports" -->
<%@ page language="java"
	import="org.owasp.esapi.ESAPI,java.sql.*,java.io.*,javax.servlet.*,javax.servlet.http.*,com.socgen.ich.ihm.*,com.socgen.bip.commun.liste.*"
	errorPage="../jsp/erreur.jsp"%>
<jsp:useBean id="personneForm" scope="request"
	class="com.socgen.bip.form.PersonneForm" />



<html:html locale="true">
<!-- #EndEditable -->
<!-- #BeginTemplate "/Templates/Page_filtre_maj.dwt" -->
<head>

<%@ taglib uri="/WEB-INF/bip.tld" prefix="bip"%>

<!-- #BeginEditable "doctitle" -->
<title>Consultation d'une ressource : détails</title>
<!-- #EndEditable -->
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<!-- #BeginEditable "fichier" -->
<bip:VerifUser page="jsp/consultationRess.jsp" />

<%
  java.util.ArrayList list1 = new com.socgen.bip.commun.liste.ListeDynamique().getListeDynamique("situress",personneForm.getHParams()); 
  pageContext.setAttribute("choix1", list1);  
  /*BIP 540 changes*/
String listStr="";
 for(Object opt : list1) {
  	
  	ListeOption op =(ListeOption)opt;
  	String tmp = op.getLibelle();
  	listStr=listStr+tmp;
  	listStr =listStr+'$' ;
  	} 
  	
	com.socgen.bip.user.UserBip user = (com.socgen.bip.user.UserBip)session.getAttribute("UserBip") ;
	com.socgen.bip.menu.item.BipItemMenu menu = user.getCurrentMenu();
	String menuId = menu.getId();
%>
<script language="JavaScript" src="../js/function.cjs"></script>
<script language="JavaScript" src="../js/jquery.js"></script>
<link rel="stylesheet" href="../css/style_bip_new.css" type="text/css">
<script language="JavaScript">

var blnVerification = true;

<%
	String arborescence = ESAPI.encoder().encodeForJavaScript(ESAPI.encoder().canonicalize(request.getParameter("arborescence")));
String sPageAide = ESAPI.encoder().encodeForJavaScript(ESAPI.encoder().canonicalize(request.getParameter("pageAide")));
	String rtype = "";
 
	if (personneForm.getRtype().equalsIgnoreCase("L")){
		rtype = "Logiciel";
	}else if (personneForm.getRtype().equalsIgnoreCase("A")){
		rtype = "SG ou assimilé";
	}else if (personneForm.getRtype().equalsIgnoreCase("P")){
		rtype = "presta. au temps passé";
	}else if (personneForm.getRtype().equalsIgnoreCase("E")){
		rtype = "Forfait sans frais d'env.";
	}else{
		rtype = "Forfait avec frais d'env.";
	}
	
%>
var pageAide = "<%= sPageAide %>";

/*BIP 540 changes -  to highlight the row*/
$( document ).ready(function() {
	MessageInitial();
	dynamicArrayTable();
	
	$("#model_table tbody tr").click(function () {     
     $("#model_table tbody tr").removeClass("highlight");
    $(this).addClass("highlight");
    });
    
});

function MessageInitial()
{
   	if(blnVerification){
   		var Message="<bean:write filter="false"  name="personneForm"  property="msgErreur" />";
   		if (Message != "") {
      		alert(Message);
      		}
	}
	
}


/*BIP 540 changes - creating dynamic HTML table */
function dynamicArrayTable() {

var listArray ="<%=listStr%>";
	var len = listArray.split('$').length-1;
	 var content = new Array();
	 var collect= new Array();
	for(var i=0;i<len;i++){
	
	content[i]=new Array(listArray.split('$')[i]);
	/*BIP 659 changes*/
	collect[i] = content[i].toString().split('###');
	if( collect[i][9]!=='---'){
	 collect[i][9]='<a href="/jsp/ecranDetailLink.jsp?&cpident='+collect[i][9]+'" target="_blank"><u>'+collect[i][9]+'</u></a>'; 
	 }
	if(collect[i][10]!=='---'){
	collect[i][10]='<a href="/jsp/ecranDetailLink.jsp?&fident='+collect[i][10]+'" target="_blank"><u>'+collect[i][10]+'</u></a>';
	}
	}

var content = "";
content = dynamicTable(collect);

$('#model_table').append(content);

}




function Verifier(form, action, flag)
{
  blnVerification = flag;
  form.action.value =action;
 
}

function ValiderEcran(form)
{
   var Message="<bean:write filter="false"  name="personneForm"  property="msgErreur" />";
   return true;
}

</script>
<!-- #EndEditable -->


</head>
<!-- <body bgcolor="#FFFFFF" text="#000000" topmargin="0" leftmargin="0" onLoad="MessageInitial();"> -->
<body bgcolor="#FFFFFF" text="#000000" topmargin="0" leftmargin="0" >
<div id="mainContainer">
<div id="topContainer">
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
				<td height="20" class="TitrePage"><div id="titre" ><!-- #BeginEditable "titre_page" -->Consultation
				d'une ressource : détails<!-- #EndEditable --></div></td>
			</tr>
			<tr>
				<td><!-- #BeginEditable "debut_form" --> <html:form action="/consultRess"  id="consultId" onsubmit="return ValiderEcran(this);">
					<!-- #EndEditable -->
					<div id="content">
					<div><!-- #BeginEditable "contenu" --> <input
						type="hidden" name="pageAide" value="<%= sPageAide %>"> <html:hidden
						property="action" /> <html:hidden property="mode" /> <html:hidden
						property="debnom" /> <html:hidden property="nomcont" /> <html:hidden property="count"/>
						<html:hidden property="matricule" />
						<html:hidden property="igg" />
						
<html:hidden property="arborescence" value="<%= arborescence %>"/>
				<% String paddingRightLibelle = "5px";
					String paddingRightContenu = "35px";
           		    if (personneForm.getRtype().equalsIgnoreCase("L")
           		    		|| 
           		    	personneForm.getRtype().equalsIgnoreCase("E") 
           		    		|| 
           		    	personneForm.getRtype().equalsIgnoreCase("F"))
           		    {
 				%>
					<table width="60%" border="0" cellspacing=0 class="tableauBlanc" align="center">

						<tr>
							<td>&nbsp;</td>
						</tr>
						<tr>
							<!-- td style="width:5%;">&nbsp;</td-->
							<td class="texteGras" style="width:15%"><b>Type ressource :</b></td>
							<td style="width:15%" class="texte"><%=rtype%> 
								<html:hidden property="rtype" /></td>
							<td style="width:10%">&nbsp;</td>
							<td class="texteGras" style="width:10%"><b>Identifiant : </b></td>
							<td style="width:10%" class="texte"><bean:write name="personneForm"
								property="ident" /> <html:hidden property="ident" /></td>
							
							
							<!-- td style="width:10%;">&nbsp;</td-->
						</tr>
						<tr>
							<!-- td style="width:5%;">&nbsp;</td-->
							<td class="texteGras" style="width:15%"><b>Nom :</b></td>
							<td style="width:15%" class="texte"><nobr><bean:write name="personneForm"
								property="rnom" /></nobr> <html:hidden property="rnom" /></td>
							<td style="width:10%" align="left"><nobr><bean:write name="personneForm" property="rprenom" /></nobr></td>
							<td class="texteGras" style="width:10%"><b>Coût total : </b></td>
							<td style="width:10%" class="texte"><bean:write name="personneForm"
								property="cout" /> <html:hidden property="cout" /></td>
							
							
							<!-- td style="width:10%;">&nbsp;</td-->
							
						</tr>				
				        <tr>
				      		<td>&nbsp;</td>
				        </tr>
					</table>
					<%
					}else{
 					%>
 				<br>
				<table border="0"  class="tableauBlanc" align="center">
				    	<tr>
				      		<td>&nbsp;</td>
				      	</tr>
				        <tr align="left">
				        	
				        	<td style="padding-right:<%= paddingRightLibelle %>;">&nbsp;</td>
				            <td style="padding-right:<%= paddingRightContenu %>;">&nbsp;</td>
								                    
				            <td style="padding-right:<%= paddingRightLibelle %>;" class="texteGras" nowrap>Type ressource :</td>
				            <td style="padding-right:<%= paddingRightContenu %>;" class="texte" nowrap>
				            	<%=rtype%>
					            <html:hidden property="rtype"/>
						    </td>						    
						    <td style="padding-right:<%= paddingRightLibelle %>;" >&nbsp;</td>
				            <td style="padding-right:<%= paddingRightContenu %>;">&nbsp;</td>
							
							<td style="padding-right:<%= paddingRightLibelle %>;">&nbsp;</td>
				            <td style="padding-right:<%= paddingRightContenu %>;">&nbsp;</td>
						    
				       </tr>
				        <tr align="left">
				        	
				        	<td style="padding-right:<%= paddingRightLibelle %>;" class="texteGras">Identifiant : </td>
				            <td style="padding-right:<%= paddingRightContenu %>;" class="texte"><bean:write name="personneForm"  property="ident" />
				            	<html:hidden property="ident"/>
							</td>
								                    
				            <td style="padding-right:<%= paddingRightLibelle %>;" class="texteGras">Nom :</td>
				            <td style="padding-right:<%= paddingRightContenu %>;" class="texte"><bean:write name="personneForm"  property="rnom" />
				            	<html:hidden property="rnom"/>
						    </td>
						    
						    <td style="padding-right:<%= paddingRightLibelle %>;" >&nbsp;</td>
				            <td style="padding-right:<%= paddingRightContenu %>;">&nbsp;</td>
				
						    <td style="padding-right:<%= paddingRightLibelle %>;" class="texteGras"><b>Prenom :</b></td>
				            <td style="padding-right:<%= paddingRightContenu %>;" class="texte"><bean:write name="personneForm"  property="rprenom" />
				            	<html:hidden property="rprenom"/>
						    </td>
				       </tr>
				       <tr align="left">
				        	<td >&nbsp;</td>
					        <td >&nbsp;</td>

					    	<td>&nbsp;</td>
				            <td >&nbsp;</td>
						    
						    <td>&nbsp;</td>
				            <td >&nbsp;</td>

						    <td style="padding-right:<%= paddingRightLibelle %>;" class="texteGras"><b>Matricule :</b></td>
				            <td style="padding-right:<%= paddingRightContenu %>;" class="texte"><bean:write name="personneForm"  property="matricule" />
			            	<html:hidden property="matricule"/>
						    </td>

				       </tr >
				       <tr align="left">
				        	<td>&nbsp;</td>
					        <td >&nbsp;</td>

					    	<td>&nbsp;</td>
				            <td >&nbsp;</td>
						    
						    <td >&nbsp;</td>
				            <td >&nbsp;</td>

						    <td style="padding-right:<%= paddingRightLibelle %>;" class="texteGras"><b>IGG :</b></td>
				            <td style="padding-right:<%= paddingRightContenu %>;" class="texte"><bean:write name="personneForm"  property="igg" />
			            	<html:hidden property="matricule"/>
						    </td>

				       </tr>
				       <tr align="left">
				        	
				        	<td >&nbsp;</td>
				            <td >&nbsp;</td>
							
				            <td style="padding-right:<%= paddingRightLibelle %>;" class="texteGras"  class="texte">N° de tél interne :</td>
				            <td style="padding-right:<%= paddingRightContenu %>;" nowrap  class="texte"><bean:write name="personneForm"  property="rtel" />
				            	<html:hidden property="rtel"/>
						    </td>
						    
						    <td >&nbsp;</td>
				            <td >&nbsp;</td>
				            
				            <td >&nbsp;</td>
				            <td >&nbsp;</td>
						    
				       </tr>
				       <tr align="left">
				        	<td style="padding-right:<%= paddingRightLibelle %>;" class="texteGras">Immeuble : </td>
				            <td style="padding-right:<%= paddingRightContenu %>;" class="texte"><bean:write name="personneForm"  property="batiment" />
				            	<html:hidden property="batiment"/>
							</td>
								                    
				            <td style="padding-right:<%= paddingRightLibelle %>;" class="texteGras">Zone :</td>
				            <td style="padding-right:<%= paddingRightContenu %>;" class="texte"><bean:write name="personneForm"  property="zone" />
				            	<html:hidden property="zone"/>
						    </td>
						    
						    <td style="padding-right:<%= paddingRightLibelle %>;" class="texteGras"><b>Etage :</b></td>
				            <td style="padding-right:<%= paddingRightContenu %>;" class="texte"><bean:write name="personneForm"  property="etage" />
				            	<html:hidden property="etage"/>
						    </td>
						    
						    <td style="padding-right:<%= paddingRightLibelle %>;" class="texteGras"><b>Bureau :</b></td>
				            <td style="padding-right:<%= paddingRightContenu %>;" class="texte"><bean:write name="personneForm"  property="bureau" />
				            	<html:hidden property="bureau"/>
						    </td>
				       </tr>
				       <tr align="left">
				      		<td>&nbsp;</td>
				       </tr>
				    </table>
					
					<%
					}
					%> 
					</br></br></br>
					<table cellspacing="2" cellpadding="2" class="tableBleu" border="0" width="95%" align="center">
						<tr>
							<td align=center  class="texte"><u>Historique des situations</u> :</td>
						</tr>
						<!-- <tr>
						<td > 
						
												
																	
									<span STYLE="position: relative; left:  4px; z-index: 1;">Date début</span> 
									<span STYLE="position: relative; left:  20px; z-index: 1;">Date fin </span> 
									<span STYLE="position: relative; left: 50px; z-index: 1;">DPG</span>
									<span STYLE="position: relative; left: 79px; z-index: 1;">Sté</span> 
									<span STYLE="position: relative; left: 95px; z-index: 1;">Siren</span>
									<span STYLE="position: relative; left: 142px; z-index: 1;">Libel sté</span> 
									<span STYLE="position: relative; left: 175px; z-index: 1;">Dom</span>
									<span STYLE="position: relative; left: 183px; z-index: 1;">Prest</span>
									<span STYLE="position: relative; left: 190px; z-index: 1;">MCI</span>
									<span STYLE="position: relative; left: 214px; z-index: 1;">CP</span>
									FAD PPM 63904 : Ajout du libellé de la colonne Forf. et MAJ du positionnement des colonnes suivantes
									<span STYLE="position: relative; left: 235px; z-index: 1;">Forf.</span>
									<span STYLE="position: relative; left: 252; z-index: 1;">Niv</span>
									<span STYLE="position: relative; left: 263px; z-index: 1;">Dispo</span>
									<span STYLE="position: relative; left: 289px; z-index: 1;">coût</span>
									<span STYLE="position: relative; left: 351px; z-index: 1;">Mt mens</span> 
									 
									<span STYLE="position: relative; left: 236; z-index: 1;">Niv</span>
									<span STYLE="position: relative; left: 246px; z-index: 1;">Dispo</span>
									<span STYLE="position: relative; left: 272px; z-index: 1;">coût</span>
									<span STYLE="position: relative; left: 334px; z-index: 1;">Mt mens</span>
									
									FAD PPM 63904 : Fin
									
							
							
							</td>
						</tr> -->
						<tr>
						
							<td style="align:center;" >
											
													
							<!-- BIP 540 changes : header : Body is written using Jquery -->
							<table id="model_table" class="model_table" align="center" cellpadding="0" cellspacing="0" >
							<thead>
							<tr>
								<td >Date début</td>
									<td>Date fin</td>
									<td>DPG</td>
									<td>Sté</td>
									<td>Siren</td>
									<td>Libel sté</td>
									<td>Dom</td>
									<td>Prest</td>
									<td>MCI</td>
									<td>CP</td>
									<td>Forf.</td>
									<td>Niv</td>
									<td>Dispo</td>
									<td>coût</td>
									<td>Mt mens</td>
									</tr>
							</thead>
							</table>
																
							
							</td>
						</tr>
						<tr>
							<!-- FAD PPM 63904 : MAJ du libellé MCI=Mode contractuel indicatif -->
							<!-- <td align="right" class="texte">MCI=Mode contractuel indicatif</td> -->
							<td align="right" class="texte">Forf.=Forfait lié MCI=Mode contractuel indicatif</td>
							<!-- FAD PPM 63904 : Fin -->
						</tr>	
						<tr>
							<td>&nbsp;</td>
						</tr>	
						<tr>
							<td align="center">

							<table width="70%" border="0">

								<tr>
									<td width=10%>&nbsp;</td>
									<td width="20%" align="left"><html:submit
										property="boutonModifier" value="Modifier" styleClass="input"
										onclick="Verifier(this.form, 'suite', true);" /></td>
									<td width="20%" align="left"><html:submit
										property="boutonAnnuler" value="Annuler" styleClass="input"
										onclick="Verifier(this.form, 'initialiser', false);" /></td>
									<td width=10%>&nbsp;</td>

								</tr>

							</table>

							<!-- #BeginEditable "fin_form" --></html:form><!-- #EndEditable --></td>
						</tr>
					</table>
					</div></div>
				</td>
			</tr>	
			<tr>
				<td>&nbsp;</td>
			</tr>
			<tr>
				<td>
				<div align="center"><html:errors /><!-- #BeginEditable "barre_bas" --><!-- #EndEditable --></div>
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

<!-- #EndTemplate -->
