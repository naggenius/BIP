<%@ taglib uri="/WEB-INF/struts-bean.tld" prefix="bean" %>
<%@ taglib uri="/WEB-INF/struts-html.tld" prefix="html" %>
<%@ taglib uri="/WEB-INF/struts-logic.tld" prefix="logic" %>
 
<%@ page language="java" import="org.owasp.esapi.ESAPI,java.sql.*,java.io.*,javax.servlet.*,javax.servlet.http.*,com.socgen.ich.ihm.*,java.util.Hashtable"    errorPage="../jsp/erreur.jsp"  %>
<jsp:useBean id="ressActForm" scope="request" class="com.socgen.bip.form.RessActForm" />
<jsp:useBean id="listeRessAct" scope="session"	class="com.socgen.ich.ihm.menu.PaginationVector" />
<html:html locale="true"> 
 
<head>
 

<%@ taglib uri="/WEB-INF/bip.tld" prefix="bip" %>
 
<title>Outil de r&eacute;estim&eacute;</title>

<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">

<bip:VerifUser page="jsp/bRessourceActRe.jsp"/>
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
   var Message="<bean:write filter="false"  name="ressActForm"  property="msgErreur" />";
   var Focus = "<bean:write name="ressActForm"  property="focus" />";
   var pos_menu ="<%=session.getAttribute("POS_MENU")%>";
   
   if (Message != "") 
   {
      alert(Message);
   }	
   
   
   
  if (document.forms[0].code_activite.length-1>=parseInt(pos_menu))
		document.forms[0].code_activite.selectedIndex=parseInt(pos_menu);
   
   
}

function Verifier(form, action)
{
	if (action=='creer') {
		if ((document.forms[0].code_activite.length==0) || (document.forms[0].code_activite.selectedIndex==-1) ) {
			alert('Plus aucune activité à affecter.');
			document.forms[0].bloquerEnvoi.value = 'true';
			return false;
		}
	}
	form.action.value = action;
}

function VerifierSupprimer(form, action, valeur, num_ligne)
{
if (confirm("Voulez-vous supprimer cette ligne ?"))
{
	form.action.value = action;
   	form.code_activite_choisi.value = valeur;
// 	rafraichir(document.forms[0]);

	// on recalcule le total
	PREE = eval("document.forms[0].repartition_"+num_ligne).value;
  	totalRep = eval("document.forms[0].total_rep").value;
	if (PREE!='') {
		virgule  = totalRep.toString().split(',');
		totalRep = parseFloat(virgule[0]+'.'+virgule[1]);

		virgule  = PREE.toString().split(',');
		totalRep = parseFloat(totalRep) - parseFloat(virgule[0]+'.'+virgule[1]); 
	  
	  	totalRep = Math.round(totalRep*100)/100;
	  	
		virgule = totalRep.toString().split('.');
		if (virgule[1])
			totalRep = virgule[0]+','+virgule[1];
		else
			totalRep = virgule[0];

	}
  	eval("document.forms[0].total_rep").value=(totalRep==0?"":totalRep);

	// s'il n'y avait plus d'activite dans la liste il faut débloquer l'envoi
    document.forms[0].bloquerEnvoi.value = 'false';

   	return true;
}
else
{
	return false;
}
}

function ValiderEcran(form)
{ 
	if (document.forms[0].bloquerEnvoi.value=='true') {
		document.forms[0].bloquerEnvoi.value=='false';
	    return false;
	}
   
   form.pos_menu.value = form.code_activite.selectedIndex; 

   return true;
}

function paginer(page, index , action){
	document.forms[0].action.value =action;
	document.forms[0].page.value=page;
    document.forms[0].index.value=index;
    document.forms[0].submit();
}


function CalculerTotaux(Obj,EF)
{
  
  tab = Obj.split('_');
  i=tab[1];
  
   
  PREE = eval("document.forms[0].repartition_"+i).value;
  OLD_PREE = eval("document.forms[0].oldRep_"+i).value;
  totalRep = eval("document.forms[0].total_rep").value;
  
    
  nombre='';
  if (!VerifierDecOLD( EF,8,2,EF.value)) return false;
  
  if (PREE=="") PREE=0;
  if (OLD_PREE=="") OLD_PREE=0;
  if (totalRep=="") totalRep=0;
  
  virgule=totalRep.toString().split(',');
  totalRep=parseFloat(virgule[0]+'.'+virgule[1]);
  
  virgule=PREE.toString().split(',');
  totalRep=parseFloat(virgule[0]+'.'+virgule[1])+parseFloat(totalRep); 
  
  virgule=OLD_PREE.toString().split(',');
  totalRep=parseFloat(totalRep)-parseFloat(virgule[0]+'.'+virgule[1]);
  
  totalRep = Math.round(totalRep*100)/100;
  
  virgule=totalRep.toString().split('.');
  if(virgule[1])
  totalRep=virgule[0]+','+virgule[1];
  else
     totalRep=virgule[0];
    
  eval("document.forms[0].total_rep").value=(totalRep==0?"":totalRep);
  eval("document.forms[0].oldRep_"+i).value = PREE;
  

  EF.focus;
  return true;
  
}

</script>
 
</head>
<body bgcolor="#FFFFFF" text="#000000" topmargin="0" leftmargin="0" onLoad="MessageInitial();">
<%
	Hashtable hKeyList= new Hashtable();
	hKeyList.put("codsg", ""+ressActForm.getCodsg());
	hKeyList.put("code_ress", ""+ressActForm.getCode_ress());
	hKeyList.put("userid", ""+((com.socgen.bip.user.UserBip)session.getAttribute("UserBip")).getInfosUser());
	java.util.ArrayList listeLigne = new com.socgen.bip.commun.liste.ListeDynamique().getListeDynamique("ressLigne", hKeyList);
	// On enleve les lignes deja choisies
	for(java.util.Iterator iter = listeRessAct.iterator(); iter.hasNext();)
	{
		com.socgen.bip.metier.RessAct ressLigne = (com.socgen.bip.metier.RessAct) iter.next();
		com.socgen.bip.commun.liste.ListeOption listeOption = new com.socgen.bip.commun.liste.ListeOption(ressLigne.getCode_activite(), ressLigne.getCode_activite() + " - " + ressLigne.getLib_activite());
		for (int i = 0 ; i < listeLigne.size() ; i++)
		{
			if (listeOption.equals((com.socgen.bip.commun.liste.ListeOption)listeLigne.get(i)))
			{
				listeLigne.remove(i);
			}
		}
	}	
	pageContext.setAttribute("listeLigne", listeLigne);
%>
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
          <td height="20" class="TitrePage">Affectation Ressources - Activit&eacute;s </td>
        </tr>
        <tr> 
          <td background="../images/ligne.gif"></td>
        </tr>
        <tr> 
          <td> 
          	<html:form action="/ressAct"  onsubmit="return ValiderEcran(this);"> 
            <div align="center">
			<input type="hidden" name="pageAide" value="<%= sPageAide %>">
            <html:hidden property="action"/>
		    <html:hidden property="mode"/>
<html:hidden property="arborescence" value="<%= arborescence %>"/>
		    <html:hidden property="page" value="creer"/>
		    <input type="hidden" name="index" value="creer">
            <input type="hidden" name="bloquerEnvoi" value="false"> <!--pour bloquer l'envoi du formulaire -->
		    <html:hidden property="pos_menu"/> 
			<table border=0 cellspacing=2 cellpadding=2 class="TableBleu">
                      <tr>
                        <td colspan=6>&nbsp;</td>
                      </tr>
                      	<tr>
                        <td align="left" class="lib"><b>Code D&eacute;partement/P&ocirc;le/Groupe : </b></td>
                        <td colspan=3 >
                        	<b><bean:write name="ressActForm" property="codsg"/></b>
                        	<html:hidden property="codsg"/>
                        </td>
                      </tr>
                      <tr>
                        <td align="left" class="lib"><b>Ressource : </b></td>
                        <td colspan=4>
                        	<b><bean:write name="ressActForm" property="code_ress"/> - <bean:write name="ressActForm" property="lib_ress"/></b>
                        	<html:hidden property="code_ress"/>
                        	<html:hidden property="lib_ress"/>
                        </td>
                      </tr>
                      <tr>
                        <td colspan=6>&nbsp;</td>
                      </tr>
                    </table>
                    <table border=0 cellspacing=0 cellpadding=2 class="TableBleu">
                    	<tr>
                      	<td>Ajout Activités : </td>
                        <td colspan=3>
							<html:select property="code_activite" styleClass="input" size="1"> 
                    			<html:options collection="listeLigne" property="cle" labelProperty="libelle"/>
                      		</html:select>
						</td>
						<td>
							<html:submit property="boutonCreer" value="Affecter" styleClass="input" onclick="Verifier(this.form, 'creer');"/>
						</td>
                      </tr>
                      <tr>
                        <td colspan=6>&nbsp;</td>
                      </tr>
                      <tr>
                        <td colspan=6>&nbsp;</td>
                      </tr>
                      <tr class="titreTableau">
                      	<td class="lib"><B>Activit&eacute;</B></td>
                        <td class="lib">&nbsp;</td>
                        <td class="lib"><B>Libell&eacute;</B></td>
                        <td class="lib">&nbsp;</td>
                        <td class="lib"><B>R&eacute;partition</B></td>
                        <td class="lib">&nbsp;</td>
                        <td class="lib"><B>Option</B></td>
                        <td class="lib">&nbsp;</td>
                      </tr>
            
                <% int i = 0;
                int nbligne = 0;
                String libCode_activite="";
				String libLib_activite="";
				String libRepartition="";
				String oldRep="";
			   String[] strTabCols = new String[] {  "fond1" , "fond2" }; %>
			<logic:iterate id="element" name="listeRessAct" length="<%=  listeRessAct.getCountInBlock()  %>" 
            			offset="<%=  listeRessAct.getOffset(0) %>"
						type="com.socgen.bip.metier.RessAct"
						indexId="index"> 
			<% 
			if ( i == 0) i = 1; else i = 0;
			nbligne ++;
			libCode_activite="code_activite_"+nbligne;
			libLib_activite="lib_activite_"+nbligne;
			libRepartition="repartition_"+nbligne;
			oldRep="oldRep_"+nbligne;
			 %>
					<tr class="<%= strTabCols[i] %>">
						<td class="contenu"><bean:write name="element" property="code_activite"/>
							<input type="hidden" name="<%=libCode_activite%>" value="<bean:write name="element" property="code_activite" />">
						</td>
    			  		<td>&nbsp;</td>
						<td class="contenu"><bean:write name="element" property="lib_activite"/>
							<input type="hidden" name="<%=libLib_activite%>" value="<bean:write name="element" property="lib_activite" />">
    			  		<td>&nbsp;</td>
    			  		<td class="contenu">
    			  			<input class="input" type="text" size="5" maxlength="5" property="lib_repartition" name="<%=libRepartition%>" value="<bean:write name="element" property="repartition"/>" onChange="return CalculerTotaux(this.name,this);" >
    			  			
					    <input type="hidden" name="<%=oldRep%>" value="<bean:write name="element" property="repartition"/>">
						%</td>
    			  		<td>&nbsp;</td>
    			  		<td align="contenu">
    			  			<input type="submit" name="boutonSupprimer" value="Supprimer" onclick="VerifierSupprimer(this.form, 'supprimer', '<bean:write name="element" property="code_activite"/>', <%=nbligne%>);" class="input">
						</td>
    			  		<td>&nbsp;</td>
    			  	</tr>
             </logic:iterate>      
                      <html:hidden property="code_activite_choisi"/>
                   
               	</table>
             
             	<table  width="100%" border="0" cellspacing="0" cellpadding="0">
			   	<tr>
					<td align="center" colspan="4" class="contenu">
						<bip:pagination beanName="listeRessAct"/>
					</td>
				</tr>
				</table>
                    	<table border=0 cellspacing=0 cellpadding=2 class="TableBleu">
                    		<tr>
                        <td colspan=6>&nbsp;</td>
                      </tr>
                    	<tr>
                      	<td >Total répartition : </td>
                        <td colspan=3>
                        	<html:text property="total_rep" size="6" readonly="true"/> %
                        </td>
                        </tr>
                        <tr>
                        <td colspan=6>&nbsp;</td>
                      </tr>
                        </table>
            <table  width="100%" border="0" cellspacing="0" cellpadding="0">
	 			<tr>
	 				<td width="25%">
               		</td> 
               		<td width="25%">
                	 <div align="center">
                	  <html:submit property="boutonValider" value="Valider" styleClass="input" onclick="Verifier(this.form, 'valider');"/>
                	 </div>
               		</td> 
               		<td width="25%"> 
                  	 <div align="center"> 
                	  <html:submit property="boutonAnnuler" value="Annuler" styleClass="input" onclick="Verifier(this.form, 'annuler');"/>
              		 </div>
                	</td>
                	<td width="25%">
               		</td>
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
</body>
<% 
Integer id_webo_page = new Integer("4004"); 
com.socgen.bip.commun.form.AutomateForm formWebo = ressActForm ;
%>
<%@ include file="/incWebo.jsp" %>
</html:html>
<!-- #EndTemplate -->
