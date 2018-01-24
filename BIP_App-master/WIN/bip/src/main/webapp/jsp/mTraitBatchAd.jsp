 
<%@ taglib uri="/WEB-INF/struts-bean.tld" prefix="bean" %>
<%@ taglib uri="/WEB-INF/struts-html.tld" prefix="html" %>
<%@ taglib uri="/WEB-INF/struts-logic.tld" prefix="logic" %>
<%@ taglib uri="/WEB-INF/struts-nested.tld" prefix="nested" %>
<!-- #BeginEditable "imports" --> 
<%@ page language="java" import="org.owasp.esapi.ESAPI,java.sql.*,java.io.*,javax.servlet.*,javax.servlet.http.*,com.socgen.ich.ihm.*"   errorPage="../jsp/erreur.jsp"  %>
<jsp:useBean id="traitBatchForm" scope="session" class="com.socgen.bip.form.TraitBatchForm" />

<bean:size id="listeShellSize" name="traitBatchForm" property="listeShell"/>
<html:html locale="true"> 
<!-- #EndEditable --> <!-- #BeginTemplate "/Templates/Page_filtre_maj.dwt" --><head>


<%@ taglib uri="/WEB-INF/bip.tld" prefix="bip" %>



<!-- #BeginEditable "doctitle" --> 
<title>Filtre Maj</title>
<!-- #EndEditable -->
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<!-- #BeginEditable "fichier" --> 
<bip:VerifUser page="jsp/fmTraitBatchAd.jsp"/> 
<script language="JavaScript" src="../js/function.cjs"></script>
<link rel="stylesheet" href="../css/base_style.css" type="text/css">
<link rel="stylesheet" href="../css/style_bip.css" type="text/css">
<script language="JavaScript">
var blnVerification = true;
<%
	String arborescence = ESAPI.encoder().encodeForJavaScript(ESAPI.encoder().canonicalize(request.getParameter("arborescence")));
	String sPageAide = ESAPI.encoder().encodeForJavaScript(ESAPI.encoder().canonicalize(request.getParameter("pageAide")));
%>
var pageAide = "<%= sPageAide %>";

function MessageInitial()
{
   var Message="<bean:write filter="false"  name="traitBatchForm"  property="msgErreur" />";
   var Focus = "<bean:write name="traitBatchForm"  property="focus" />";
   if (Message != "") {
      alert(Message);
   }
   if (Focus != "") (eval( "document.forms[0]."+Focus )).focus();
}

function Verifier(form, action, flag)
{
   blnVerification = flag;
   form.action.value = action;

} 
function ValiderEcran(form)
{
   if(blnVerification){
   	   var delta=1;
	   for(var i=0;i<parseInt(document.getElementById('size').value);i++){
	   		if(document.getElementsByName("trait["+i+"].flagSuppr")[0]!=null){ 
		   		if(document.getElementsByName("trait["+i+"].flagSuppr")[0].value==""){
			   		var heure = document.getElementsByName("trait["+i+"].heure_shell")[0];
			   			var plusun = i+delta;
				   		if(heure.value.length==0){
				   			alert("L'heure à la ligne "+plusun+" ne doit pas être vide.");
				   			return false;
				   		}else if(!formatHeure(heure.value)){
				   			alert("L'heure à la ligne "+plusun+" n'est pas au bon format d'heure (HH:mm).");
				   			return false;
				   		}
		   		}
		   	}else{
		   		//Si on a une ligne null, càd supprimée par l'utilisateur, il faut, pour le message d'erreur, 
		   		//corriger le numéro de ligne qu'on annonce
		   		//pour que cela corresponde à ce que l'utilisateur voit à l'écran
		   		delta = delta-1;
		   	}
	   }
   }
   return true;
}

function ajoutLigne(){

	var listeShellSize = <%=listeShellSize%>;

	if(listeShellSize==0){
		alert("Aucun traitement n'a été créé par l'administrateur dans Tables->Mise à jour->Traitements.");
		return false;
	}
	

	var newRow = document.getElementById('tableLignes').insertRow(-1);
	var index = document.getElementById('size').value;
	newRow.id="ligne_"+index;
	var newCell = newRow.insertCell(0);

	newCell.innerHTML = '<input type="hidden" name="trait['+index+'].flagSuppr" value=""/>'
	newCell = newRow.insertCell(1);
	newCell.innerHTML = '&nbsp;'
  	newCell = newRow.insertCell(2);
  	
	//On récupère la première option du champ select des shells
	var valeur = '<bean:write name="traitBatchForm" property="infos_shell"/>';
	
	newCell.innerHTML = '<input type="hidden" name="trait['+index+'].id_trait_batch" value="-1"/>'+
	'<select name="trait['+index+'].id_shell" class="input" onchange="selectShell(this);">'+
	'<logic:iterate name="traitBatchForm" property="listeShell" id="listeShell">'+
	'<option value=<bean:write name="listeShell" property="id_shell"/> ><bean:write name="listeShell" property="infos_shell"/></option>'+
	'</logic:iterate>'+
	'</select>'+
	'<input type="hidden" name="trait['+index+'].date_shell" value="<bean:write name="traitBatchForm" property="jour"/> 00:00"/>';
	
	newCell = newRow.insertCell(3);
	
	newCell.innerHTML = '<input type="text" name="trait['+index+'].heure_shell" value="" size="5" class="input">';

	newCell = newRow.insertCell(4);
	newCell.innerHTML = '&nbsp;'	
	//Si la première option du champ des shells ne prend pas de fichier en entrée, on n'affiche pas le champ d'upload
	if(valeur.search('Aucun fichier en entrée')==-1){
	
		newCell = newRow.insertCell(5);
		newCell.innerHTML = '<input type="file" class="input" name="trait['+index+'].fichier" accept="txt,csv" size="40" value="">'
		
		newCell = newRow.insertCell(6);
		newCell.innerHTML = '<IMG SRC="../images/zoom_out.gif" ALT="Enlever un traitement" onClick="supprLigne('+index+');">';	

	}else{
		newCell = newRow.insertCell(5);
		newCell.innerHTML = '&nbsp;'
	
		newCell = newRow.insertCell(6);
		newCell.innerHTML = '<IMG SRC="../images/zoom_out.gif" ALT="Enlever un traitement" onClick="supprLigne('+index+');">';	
	}

	document.getElementById('size').value=parseInt(index)+1;
}

function supprLigne(index){

	var idTrait = document.getElementsByName("trait["+index+"].id_trait_batch")[0].value;
	
	document.getElementsByName("listeTraitSuppr")[0].value = document.getElementsByName("listeTraitSuppr")[0].value+idTrait+',';

 	document.getElementById("ligne_"+index).firstChild.firstChild.value="suppr";

 	document.getElementById('tableLignes').deleteRow(document.getElementById("ligne_"+index).rowIndex);
}

function selectShell(champ){
	var index = champ.name.substring(champ.name.indexOf("[")+1,champ.name.indexOf("]"));
	var valeur = champ.options[champ.selectedIndex].text;
	var row = document.getElementById("ligne_"+index);
	if(valeur.search('Aucun fichier en entrée')==-1) {
	    
	    row.cells[5].innerHTML = '<input type="file" class="input" name="trait['+index+'].fichier" accept="txt,csv" size="40" value="">';

	}else {
		
		row.cells[5].innerHTML = '&nbsp;'  ;
		
	}
}

function OpenCsv(id)
{
	window.open("/traitBatch.do?action=creer&id_batch="+id  ,"", "toolbar=no, directories=no, location=no, status=no, menubar=no, resizable=yes, scrollbars=yes, width=450, height=450") ;
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
              <%=tb.printHtml()%> <!-- #EndEditable --></div>
          </td>
        </tr>
        <tr> 
          <td>&nbsp;</td>
        </tr>
        <tr> 
          <td background="../images/ligne.gif"></td>
        </tr>
        <tr> 
          <td height="20" class="TitrePage"><!-- #BeginEditable "titre_page" -->Planification des traitements exceptionnels<!-- #EndEditable --></td>
        </tr>
        <tr> 
          <td background="../images/ligne.gif"></td>
        </tr>
        <tr> 
          <td>
		  <!-- #BeginEditable "debut_form" --><html:form action="/traitBatch"  enctype="multipart/form-data" onsubmit="return ValiderEcran(this);"><!-- #EndEditable -->
		  <div align="center"><!-- #BeginEditable "contenu" -->
           <input type="hidden" name="pageAide" value="<%= sPageAide %>">
            <html:hidden property="action" value="consulter"/>
            <html:hidden property="mode"/>
			<html:hidden property="arborescence" value="<%= arborescence %>"/>
			<html:hidden property="jour"/>
			<html:hidden id="size" property="size"/>
			<html:hidden property="listeTraitSuppr" value=""/>
			<table border=0  cellpadding=2 cellspacing=2 class="tableBleu">
                <tbody id="tableLignes">
                <tr> 
                  <td colspan="7" align="center" ><b>Traitements du <bean:write name="traitBatchForm" property="jour"/></b></td>
                </tr>
                <tr> 
                  <td><IMG SRC="../images/zoom_in.gif" ALT="Ajouter un traitement" onClick="ajoutLigne();"/></td>
                  <td>&nbsp;</td>
                </tr>
	                <logic:iterate name="traitBatchForm" property="listeTraitBatch" id="trait" indexId="index">
		                <tr id='ligne_<bean:write name="index"/>'> 
		                  <td>
							<html:hidden name="trait" property="flagSuppr" value="" indexed="true"/>
		                  	<logic:equal name="trait" property="top_retour" value="O">
			                  	<a href="../<bean:write name="trait" property="fichier_retour"/>" target="_blank">
			                  		<IMG SRC="../images/csv.png" ALT="Fichier retour" border="0">
								</a>
		                  	</logic:equal>
		                  </td>
		                  <td>	
	                  		<logic:equal name="trait" property="top_exec" value="O">
	                  			<logic:equal name="trait" property="top_ano" value="O">
		                  			<IMG SRC="../images/imageKO.bmp" ALT="Ce traitement a été exécuté avec des erreurs"/>
		                  		</logic:equal>
	                  			<logic:notEqual name="trait" property="top_ano" value="O">
		                  			<IMG SRC="../images/imageOK.bmp" ALT="Ce traitement a été exécuté"/>
		                  		</logic:notEqual>		                  		
		                  	</logic:equal>
		                  	<logic:notEqual name="trait" property="top_exec" value="O">
		                  		<IMG SRC="../images/imageENCOURS.bmp" ALT="Ce traitement n'a pas encore été exécuté"/>
		                  	</logic:notEqual>
		                  </td>
		                  <td>
		                  	
		                  	<html:hidden name="trait" property="id_trait_batch" indexed="true"/>
		                  	
		                  	<html:select name="trait" styleClass="input" property="id_shell" indexed="true" onchange="selectShell(this);">
		                  		<html:optionsCollection name="traitBatchForm" property="listeShell" value="id_shell" label="infos_shell"/>
		                  	</html:select>
		                  </td>
		                  <td>
		                  	<html:text name="trait" styleClass="input" size="5" property="heure_shell" indexed="true"/>
		                  </td>
		                  
		                  <td>
				                  	<logic:notEqual name="trait" property="tailleClob" value="0">
				                  		<IMG SRC="../images/imageOK.bmp" ALT="Un fichier a déjà été uploadé pour ce traitement"/>
				                  	</logic:notEqual>
				                  	<logic:equal name="trait" property="tailleClob" value="0">
				                  		<IMG SRC="../images/imageKO.bmp" ALT="Aucun fichier n'a encore été uploadé pour ce traitement"/>
				                  	</logic:equal>		                  	
		                  </td>
		                  <td>
			                  <logic:notEmpty name="trait" property="nom_fich">				                  
				                  	<logic:equal name="trait" property="tailleClob" value="0">
				                  		<html:file styleClass="input" name="trait" property="fichier" accept="txt,csv" size="40" indexed="true"/>
				                  	</logic:equal>
				                  					                  
			                  </logic:notEmpty>
		                  </td>
		                  <td>
		                  	<IMG SRC="../images/zoom_out.gif" ALT="Enlever un traitement" onClick='supprLigne(<bean:write name="index"/>);'/>
		                  </td>
		                  
		                </tr>
	                </logic:iterate>
	          </tbody>
              </table>
			  <!-- #EndEditable --></div>
            
		</td>
		</tr>
		<tr>
		<td align="center">

		<table width="60%" border="0">
		
               <tr> 
                <td width="20%"> 
                  	<div align="center"> 
     				 	<html:submit property="boutonModifier" value="Valider" styleClass="input" onclick="Verifier(this.form, 'maj', true);"/>
                  	</div>
                </td>
               <td width="20%"> 
                  	<div align="center"> 
     				 	<html:submit property="boutonAnnuler" value="Annuler" styleClass="input" onclick="Verifier(this.form, 'annuler', false);"/>
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