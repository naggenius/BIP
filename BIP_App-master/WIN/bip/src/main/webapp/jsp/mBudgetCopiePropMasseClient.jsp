 
<%@ taglib uri="/WEB-INF/struts-bean.tld" prefix="bean" %>
<%@ taglib uri="/WEB-INF/struts-html.tld" prefix="html" %>
<%@ taglib uri="/WEB-INF/struts-logic.tld" prefix="logic" %>
<!-- #BeginEditable "imports" --> 
<%@ page language="java" import="org.owasp.esapi.ESAPI,java.sql.*,java.io.*,javax.servlet.*,javax.servlet.http.*,com.socgen.ich.ihm.*,com.socgen.bip.commun.liste.*"   errorPage="../jsp/erreur.jsp"  %>
<jsp:useBean id="budgetcopiepropmasseForm" scope="request" class="com.socgen.bip.form.BudgetCopiePropMasseForm" />
<html:html locale="true"> 
<!-- #EndEditable --> <!-- #BeginTemplate "/Templates/Page_filtre_maj.dwt" --><head>


<%@ taglib uri="/WEB-INF/bip.tld" prefix="bip" %>



<!-- #BeginEditable "doctitle" --> 
<title>Filtre Maj</title>
<!-- #EndEditable -->
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<!-- #BeginEditable "fichier" --> 
<bip:VerifUser page="/budgetcopiepropmasse.do"/> 
<%
  java.util.ArrayList list1 = new com.socgen.bip.commun.liste.ListeDynamique().getListeDynamique("typeligne",budgetcopiepropmasseForm.getHParams()); 
list1.add(0,new ListeOption("TOUS", "Tous" ));
  list1.add(1,new ListeOption("ENV", "Enveloppe domaine (P1, T2, T3 et T4)" ));
pageContext.setAttribute("typeligne", list1);

java.util.ArrayList list2 = new com.socgen.bip.commun.liste.ListeDynamique().getListeDynamique("dossproj",budgetcopiepropmasseForm.getHParams()); 
list2.add(0,new ListeOption("TOUS", "Tous" ));
pageContext.setAttribute("dossproj", list2);

java.util.ArrayList list3 = new com.socgen.bip.commun.liste.ListeDynamique().getListeDynamique("clientpropmasse",budgetcopiepropmasseForm.getHParams()); 
list3.add(0,new ListeOption("TOUS", "Tous" ));
pageContext.setAttribute("clientpropmasse", list3);
try
{
	pageContext.setAttribute("directionpropmasse", new ArrayList());
	
	if (budgetcopiepropmasseForm.getTypeligne() != null &&  budgetcopiepropmasseForm.getClient() != null)
	{
		if (budgetcopiepropmasseForm.getDossproj() == null)
		  budgetcopiepropmasseForm.setDossproj("TOUS");
		java.util.ArrayList list4 = new com.socgen.bip.commun.liste.ListeDynamique().getListeDynamique("directionpropmasse",budgetcopiepropmasseForm.getHParams()); 
		list4.add(0,new ListeOption("TOUS", "Toutes" ));
		pageContext.setAttribute("directionpropmasse", list4);
	}
}
catch (Exception e) {
    pageContext.setAttribute("directionpropmasse", new ArrayList());
    
}	   

%>


<STYLE TYPE="text/css">
<!--   
#cache {
    position:absolute; top:200px; z-index:10; visibility:hidden;
}

ul {
margin-top: 0px;
}
-->
</STYLE>

<script language="JavaScript" src="../js/function.cjs"></script>
<link rel="stylesheet" href="../css/base_style.css" type="text/css">
<link rel="stylesheet" href="../css/style_bip.css" type="text/css">
<script language="JavaScript">
var blnVerification = true;
var rafraichiEnCours = false;
var flagModif = 0;
<%
	String arborescence = ESAPI.encoder().encodeForJavaScript(ESAPI.encoder().canonicalize(request.getParameter("arborescence")));
	String sPageAide = ESAPI.encoder().encodeForJavaScript(ESAPI.encoder().canonicalize(request.getParameter("pageAide")));
%>
var pageAide = "<%= sPageAide %>";
var annee_ref = "<%= Integer.parseInt(budgetcopiepropmasseForm.getAnnee_ref()) %>";
var annee_ref3ans = "<%= Integer.parseInt(budgetcopiepropmasseForm.getAnnee_ref())+3 %>";

function MessageInitial()
{
	document.getElementById("wait").style.display = "none";
	div_fermer();
   	   
 var Message="<bean:write filter="false"  name="budgetcopiepropmasseForm"  property="msgErreur" />";
 var message_simulation="<bean:write filter="false"  name="budgetcopiepropmasseForm"  property="message_simulation" />";
  
 var Focus = "<bean:write name="budgetcopiepropmasseForm"  property="focus" />";
   if (Message != "") {
       alert(Message);
   }
    if (message_simulation != "") {
       mise_en_page_div_afficher();
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
     if(rafraichiEnCours)
  	return false;

   if (blnVerification==true) {
	if (form.action.value != "annuler")
	{
		if (!ChampObligatoire(document.forms[0].annee, "l'année de proposition"))
		{
			document.forms[0].typeligne.focus();
			document.forms[0].annee.focus();
 			return false;  
		}
		else
		{
		var annee;
		var myDate = new Date(); 
		if (document.forms[0].annee.value < annee_ref && document.forms[0].annee.value != "")
		{
			alert("Veuillez saisir au minimum l'année en cours");
			setTimeout(function() { document.forms[0].annee.focus(); }, 100);
			document.forms[0].annee.value="";
			return false;  
		}
		else
		{ 
			if (document.forms[0].annee.value > annee_ref3ans)
			{
				alert("Veuillez saisir au maximum l'année en cours +3");
				setTimeout(function() { document.forms[0].annee.focus(); }, 100);
				document.forms[0].annee.value="";
				return false;  
			}
		}
		
	}
		
	}
    if (form.action.value == 'valider'){
       form.mode.value='valider';
    }
       
   }
 	document.getElementById("wait").style.display = "block";
   return true;
}


function refresh() {

if (flagModif ==0 && !ChampObligatoire(document.forms[0].annee, "l'année de proposition"))
{
	return false;  
}
else
	{
		var annee;
		var myDate = new Date(); 
		if (document.forms[0].annee.value < annee_ref && document.forms[0].annee.value != "")
		{
			alert("Veuillez saisir au minimum l'année en cours");
			setTimeout(function() { document.forms[0].annee.focus(); }, 100);
			document.forms[0].annee.value="";
			flagModif = 1;
			return false;  
		}
		else
		{ 
		   	if (document.forms[0].annee.value > annee_ref3ans)
			{
				alert("Veuillez saisir au maximum l'année en cours +3");
				setTimeout(function() { document.forms[0].annee.focus(); }, 100);
				document.forms[0].annee.value="";
				flagModif = 1;
				return false;  
			}
		}
	}


if (document.forms[0].annee.value != "")
	{
	 if(!rafraichiEnCours)
		      {
			     rafraichir(document.forms[0]);
			     rafraichiEnCours = true;
			   	 document.getElementById("wait").style.display = "block";
		       }
	}
}

function chargelibel(liste,nom)
{
	var champ = 'libelle'+nom;
	document.getElementsByName(champ)[0].value=liste.options[liste.selectedIndex].text;
}

function mise_en_page_div_afficher()
{
	document.getElementById("simulation").style.display = "block";
	document.getElementById("tableau").style.display = "none";
	document.getElementById("fermer").focus();
}

function div_fermer()
{
	document.getElementById("simulation").style.display="none";
	document.getElementById("tableau").style.display = "block";
}



</script>
<!-- #EndEditable -->  


</head>

<body bgcolor="#FFFFFF" text="#000000" topmargin="0" leftmargin="0" onLoad="MessageInitial();">

<div id="wait" class="tableBleu" style="font : normal 8pt Verdana, Helvetica, sans-serif;top:50%;left:40%;position:absolute;padding:5px;display:none"><img src="../images/indicator.gif" /> Veuillez patienter...</div>
<div id="simulation" class="tableBleu" style="z-index:1;border:1px solid Black;font : normal 8pt Verdana, Helvetica, sans-serif;position:absolute;padding:5px;margin: 0 auto;background-color: #FFFFFF;left:28%;top:33%; display:none"><%=budgetcopiepropmasseForm.getMessage_simulation() %>
<div style="text-align:center;">
<input type="submit" id="fermer" class="input" value="Fermer" onClick="div_fermer()">
</div>
</div>

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
          <td height="20" class="TitrePage"><!-- #BeginEditable "titre_page" -->Copie Prop. en masse : recopie de Proposés fournisseurs dans les Proposés clients<!-- #EndEditable --></td>
        </tr>
        <tr> 
          <td background="../images/ligne.gif"></td>
        </tr>
</table>
 
 <div style="margin-left:5%;margin-right:5%;"class="tableBleu">
 <br>
Cette fonction recopie les proposés fournisseurs dans les proposés clients, pour les lignes actives dont le périmètre correspond aux critères ci-après et dont le Proposé client est à zéro.
<br>
</div>
 <div id="tableau">      
		  <html:form action="/budgetcopiepropmasse"  onsubmit="return ValiderEcran(this);"><!-- #EndEditable -->
		  <input type="hidden" name="pageAide" value="<%= sPageAide %>">
            	<html:hidden property="action" value="suite"/>
			    <html:hidden property="mode"/>
			    <html:hidden property="libelletypeligne" />
			    <html:hidden property="libelledossproj" />
			    <html:hidden property="libelleclient" />
			    <html:hidden property="libelledirection" />
			    <html:hidden property="annee_ref" />
			    
<html:hidden property="arborescence" value="<%= arborescence %>"/>
			
			  <table cellspacing="1" cellpadding="1" class="tableBleu"  border="0" width="95%" align="center">
                <tr align="left"> 
                	<td class="lib" width="20%"><b>Année de proposition :</b></td>
                 	<td witdh="30%"><html:text property="annee" styleClass="input" size="5" maxlength="4"  onChange="if (VerifierNum(this,4,0)){refresh();}else{setTimeout(function() { document.forms[0].annee.focus(); }, 100);flagModif = 1;}"/></td>
  				    <td colspan=2 witdh="50%">&nbsp;</td>
                </tr>
                <tr> 
         			<td width="100%" colspan="4">&nbsp;</td>
       			 </tr>
                <tr align="left"> 
                   <td class="lib"  width="20%"><b>Type ligne :</b></td>
                   <td width="30%" name="ld"> 
                    	<html:select property="typeligne" styleClass="input" onChange="chargelibel(this,this.name);refresh(this);"> 
   						<html:options collection="typeligne" property="cle" labelProperty="libelle" />
						</html:select>
                    
                  </td>
					<!-- debut 59288 supression du filtre : lignes GT1 ou TOUS, la liste dossier projet doit être toujours visible -->
                    <td class="lib" align="left" width="20%"><b>Dossier projet :</b></td>
                    <td width="30%" name="ld"> 
                    	<html:select property="dossproj" styleClass="input"onChange="chargelibel(this,this.name);refresh();"> 
   						<html:options collection="dossproj" property="cle" labelProperty="libelle" />
						</html:select>
							
                    </td>
					<!-- fin 59288 supression du filtre : lignes GT1 ou TOUS -->
                </tr>
                <tr> 
         			<td width="100%" colspan="4">&nbsp;</td>
       			 </tr>
                <tr align="left"> 
                  <td class="lib" width="20%"><b>Client :</b></td>
                  <td width="30%" name="ld"> 
                    	<html:select property="client" styleClass="input" onChange="chargelibel(this,this.name);refresh();"> 
   						<html:options collection="clientpropmasse" property="cle" labelProperty="libelle" />
						</html:select>
                    
                  </td>
                  <td colspan=2 width="50%">&nbsp;</td>
                </tr>
                <tr> 
         			<td width="100%" colspan="4">&nbsp;</td>
       			 </tr>
                <tr align="left"> 
                  <td class="lib" width="20%"><b>Direction du fournisseur :</b></td>
                  <td width="30%" name="ld"> 
                    	<html:select property="direction" styleClass="input" onChange="chargelibel(this,this.name);refresh();"> 
   						<html:options collection="directionpropmasse" property="cle" labelProperty="libelle" />
						</html:select>
                    
                  </td>
                  <td colspan=2 width="50%">&nbsp;</td>
                </tr>
              
              </table>
		
            
		

		<table width="100%" border="0">
		  <tr>
		   <td colspan=3 >&nbsp;</td>
                </tr>
                <tr>
		   <td colspan=3 >&nbsp;</td>
                </tr>
                <tr> 
                  <td width="33%" align="right">  
                	 <html:submit value="Simuler" styleClass="input" onclick="Verifier(this.form, 'suite', true);"/>
                  </td>
				   <td width="33%" align="center">  
     				 <html:submit value="Valider" styleClass="input" onclick="Verifier(this.form, 'valider', true);"/>
                  </td>
				   <td width="33%" align="left">  
					<html:submit value="Annuler" styleClass="input" onclick="Verifier(this.form, 'annuler', true);"/>
                  </td>
                </tr>
            
            </table>
		
			  <!-- #BeginEditable "fin_form" --></html:form><!-- #EndEditable -->
    
		<table>
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
</div>
</body>
</html:html> 

<!-- #EndTemplate -->