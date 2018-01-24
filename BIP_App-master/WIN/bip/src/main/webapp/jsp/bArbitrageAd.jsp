<%@ taglib uri="/WEB-INF/struts-bean.tld" prefix="bean" %>
<%@ taglib uri="/WEB-INF/struts-html.tld" prefix="html" %>
<%@ taglib uri="/WEB-INF/struts-logic.tld" prefix="logic" %>

<!-- #BeginEditable "imports" --> 
<%@ page language="java" import="org.owasp.esapi.ESAPI,java.sql.*,java.io.*,javax.servlet.*,javax.servlet.http.*,java.lang.reflect.InvocationTargetException,com.socgen.ich.ihm.*"    errorPage="../jsp/erreur.jsp"  %>
<jsp:useBean id="arbitrageForm" scope="request" class="com.socgen.bip.form.ArbitrageForm" />
<jsp:useBean id="listeArbitre" scope="session"	class="com.socgen.ich.ihm.menu.PaginationVector" />
<html:html locale="true"> 
<!-- #EndEditable --> <!-- #BeginTemplate "/Templates/Page_bip.dwt" --> 
<head>
 

<%@ taglib uri="/WEB-INF/bip.tld" prefix="bip" %>


 <!-- #BeginEditable "doctitle" --> 
<title>Page BIP</title>
<!-- #EndEditable --> 
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<!-- #BeginEditable "fichier" --> 
<bip:VerifUser page="jsp/fArbitrageAd.jsp"/> 
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
   var liste_pid = "<bean:write name="arbitrageForm"  property="liste_pid" />";
   var Message="<bean:write filter="false"  name="arbitrageForm"  property="msgErreur" />";
   var Focus = "<bean:write name="arbitrageForm"  property="focus" />";
   if (Message != "") {
      alert(Message);
   }
	// FAD PPM Corrective 64448 : Réinitialisation des champs Totaux aprés chaque MAJ
	document.forms[0].tot_bpmontmo.value = "";
	document.forms[0].tot_anmont.value = "";
	document.forms[0].tot_ecart.value = "";
	// FAD PPM Corrective 64448 : Fin
}


function Verifier(form, action, flag, save)
{
  blnVerification = flag;
  form.action.value = action;
  form.save.value = save;
  
  if ( (form.tot_ecart.value != 0) && (action=='valider') )
  	{
  	var choix = confirm("Attention: la somme des écart n'est pas égale à 0");
  	if (choix) form.submit();
  		else return false;
  	}
  	else form.submit();
}

function Editer(form, action, flag, save)
{
  blnVerification = flag;
  form.action.value = action;
  form.save.value = save;
  window.open("/arbitrage.do?action=valider&save=OUI&liste_pid="+document.forms[0].liste_pid.value+"&windowTitle=Edition&habilitationPage=HabilitationLigneBip"  ,"", "toolbar=yes, directories=no, location=no, status=no, menubar=yes, resizable=yes, scrollbars=yes, width=450, height=450") ;
  return ;
  
}

function ValiderEcran(form)
{
    return true;
}

function paginer(page, index , action){
	document.forms[0].action.value =action;
	document.forms[0].page.value=page;
    document.forms[0].index.value=index;
    document.forms[0].submit();
}


function CalculerTot(Obj,EF)
{
	/*On recupere le numero de l'enrigistrement cliqué*/
	tab = Obj.split('_');
  	i=tab[1];
  	pid = eval("document.forms[0].pid_"+i).value + ";";
	
	/* alert ("Objet envoye: "+Obj); */
	/* Initialise les totaux */
	totalbpmontmo = eval("document.forms[0].tot_bpmontmo").value;
	totalanmont = eval("document.forms[0].tot_anmont").value;
	totalecart = eval("document.forms[0].tot_ecart").value;
	if (totalbpmontmo=="") totalbpmontmo=0;
	if (totalanmont=="") totalanmont=0;
	if (totalecart=="") totalecart=0;
	
	totalbpmontmo_i = eval("document.forms[0].bpmontmo_"+i).value;
	totalanmont_i = eval("document.forms[0].anmont_"+i).value;
	totalecart_i = eval("document.forms[0].ecart_"+i).value;
	
	/* alert("total actuel: "+totalbpmontmo); */
		
	if (eval("document.forms[0].ck_"+i).checked==true ) 
		{
		/* On ajoute le pid selectioner a la liste des pid */
		document.forms[0].liste_pid.value = document.forms[0].liste_pid.value + pid;
		/* Calcul propose */ 
		virgule = totalbpmontmo.toString().split(',');
		totalbpmontmo = parseFloat(virgule[0]+'.'+virgule[1]);
		virgule = totalbpmontmo_i.toString().split(',');
		totalbpmontmo =parseFloat(totalbpmontmo) + parseFloat(virgule[0]+'.'+virgule[1]);
		
		/* alert("Propose a ajoute: "+eval("document.forms[0].bpmontmo_"+i).value); */
		/* calcul arbitre */ 
		virgule=totalanmont.toString().split(',');
		totalanmont=parseFloat(virgule[0]+'.'+virgule[1]);
		virgule = totalanmont_i.toString().split(',');
		totalanmont =parseFloat(totalanmont) + parseFloat(virgule[0]+'.'+virgule[1]);
		/* calcul ecart */
		virgule=totalecart.toString().split(',');
		totalecart=parseFloat(virgule[0]+'.'+virgule[1]);
		virgule = totalecart_i.toString().split(',');
		totalecart =parseFloat(totalecart) + parseFloat(virgule[0]+'.'+virgule[1]);
		}
		else
			{
			/* on retire le pid deselectionné */
			virgule = totalbpmontmo.toString().split(',');
			totalbpmontmo = parseFloat(virgule[0]+'.'+virgule[1]);
			document.forms[0].liste_pid.value = document.forms[0].liste_pid.value.replace(pid,"");
			virgule = totalbpmontmo_i.toString().split(',');
			totalbpmontmo =parseFloat(totalbpmontmo) - parseFloat(virgule[0]+'.'+virgule[1]);
			
			virgule=totalanmont.toString().split(',');
			totalanmont=parseFloat(virgule[0]+'.'+virgule[1]);
			virgule = totalanmont_i.toString().split(',');
			totalanmont =parseFloat(totalanmont) - parseFloat(virgule[0]+'.'+virgule[1]);
			
			virgule=totalecart.toString().split(',');
			totalecart=parseFloat(virgule[0]+'.'+virgule[1]);
			virgule = totalecart_i.toString().split(',');
			totalecart =parseFloat(totalecart) - parseFloat(virgule[0]+'.'+virgule[1]);
			}

	/*alert("nouveau total: "+totalbpmontmo);	*/
  /* Formatage propose */
  virgule=totalbpmontmo.toString().split('.');
  if(virgule[1])
  totalbpmontmo=virgule[0]+','+virgule[1];
  else
     totalbpmontmo=virgule[0];
  /* formatage arbitre */   
  virgule=totalanmont.toString().split('.');
  if(virgule[1])
  totalanmont=virgule[0]+','+virgule[1];
  else
     totalanmont=virgule[0];
  /* Fromatage ecart */   
   virgule=totalecart.toString().split('.');
  if(virgule[1])
  totalecart=virgule[0]+','+virgule[1];
  else
     totalecart=virgule[0];

	document.forms[0].tot_bpmontmo.value = totalbpmontmo
	document.forms[0].tot_anmont.value = totalanmont
	document.forms[0].tot_ecart.value = totalecart
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
          <td height="20" class="TitrePage">Outil d'arbitrage des JH</td>
        </tr>
        <tr> 
          <td background="../images/ligne.gif"></td>
        </tr>
        <tr> 
          <td> </td>
        </tr>
        <tr> 
          <td><html:form action="/arbitrage"  onsubmit="return ValiderEcran(this);">
            <table width="80%" border="0" align="center">
              <tr> 
                <td> 
                  <div align="center"><!-- #BeginEditable "contenu" -->
					 <input type="hidden" name="pageAide" value="<%= sPageAide %>">
                     <html:hidden property="action"/>
<html:hidden property="arborescence" value="<%= arborescence %>"/>
                     <html:hidden property="annee"/>
                     <html:hidden property="dpcode"/>
                     <html:hidden property="icpi"/>
                     <html:hidden property="pid"/>
                     <html:hidden property="codsg"/>
                     <html:hidden property="metier"/>
                     <html:hidden property="save"/>
                     <html:hidden property="blocksize"/>
                     <html:hidden property="ordre_tri"/>
                     <html:hidden property="liste_pid"/>
                     <html:hidden property="page" value="modifier"/>
                     <input type="hidden" name="index" value="modifier">
                     
				    <table border=0 cellspacing=2 cellpadding=2 class="TableBleu">
                      
                      <tr>
                        <td colspan=6>&nbsp;</td>
                      </tr>
                      </table>
                      <table width="100%" border="0">
                      <tr class="titreTableau">
                      	<td class="lib" align="center" rowspan="2"><B>Client</B></td>
                        <td class="lib" align="center" rowspan="2"><B>DP</B></td>
                        <td class="lib" align="center" rowspan="2"><B>DP-COPI</B></td>
                        <td class="lib" align="center" rowspan="2"><B>Projet</B></td>
                        <td class="lib" align="center" rowspan="2"><B>Ref_demande</B></td> <!--  KRA - Version SIOP - PPM 61919 - §6.9 -->
                        <td class="lib" align="center" rowspan="2"><B>Métier</B></td>
                        <td class="lib" align="center" rowspan="2"><B>Fournisseur</B></td>
                        <td class="lib" align="center" rowspan="2"><B>Ligne</B></td>
                        <td class="lib" align="center" colspan="2"><B>Type</B></td>
                        <td class="lib" align="center" rowspan="2"><B>Consommé année</B></td> <!--  KRA - Version SIOP - PPM 61919 - §6.9 -->
                        <td width="5%" class="lib" align="center" rowspan="2"><B>Proposé</B></td>
                        <td width="5%" class="lib" align="center" rowspan="2"><B>Ecart</B></td>
                        <td width="5%" class="lib" align="center" rowspan="2"><B>Arbitré</B></td>
                        <!--  YNI
                        <td class="lib"><B>Date Modification</B></td>
                        <td class="lib"><B>Identifiant</B></td>
                        -->
                        <td class="lib" rowspan="2">&nbsp;</td>
                      </tr>
                        <tr class="titreTableau">
                      	<td class="lib" align="center"><B>prin</B></td>
                        <td class="lib" align="center"><B>sec</B></td>
                      </tr>
             <% int i = 0;
			   int nbligne = 0;
			   String libPid="";
			   String libFlaglock="";
			   String libck="";
			   String libPropose="";
			   String libArbitre="";
			   String libEcart="";
			   String[] strTabCols = new String[] {  "fond1" , "fond2" }; %>
			   
			   
			<logic:iterate id="element" name="listeArbitre" length="<%=  listeArbitre.getCountInBlock()  %>" 
            			offset="<%=  listeArbitre.getOffset(0) %>"
						type="com.socgen.bip.metier.Arbitrage"
						indexId="index"> 
			<% if ( i == 0) i = 1; else i = 0;
			   nbligne ++;
			   libPid="pid_"+nbligne;
			   libFlaglock="flaglock_"+nbligne;
			   libck="ck_"+nbligne;
			   libPropose="bpmontmo_"+nbligne;
			   libArbitre="anmont_"+nbligne;
			   libEcart="ecart_"+nbligne;
			 %>
						<tr class="<%= strTabCols[i] %>">
    			  		<td class="contenu"><bean:write name="element" property="clilib" /></td>
						<td class="contenu"><bean:write name="element" property="dpcode" /></td>
						<td class="contenu"><bean:write name="element" property="dp_copi" /></td>
						<td class="contenu"><bean:write name="element" property="icpi" /></td>
						<td class="contenu"><bean:write name="element" property="ref_demande" /></td> <!--  KRA - Version SIOP - PPM 61919 - §6.9 -->
						<td class="contenu"><bean:write name="element" property="metier" /></td>
						<td class="contenu"><bean:write name="element" property="fournisseur" /></td>
    			  		<td class="contenu"><bean:write name="element" property="pid" /></td>
    			  		<input type="hidden" name="<%=libPid%>" value="<bean:write name="element" property="pid" />">
    			  		<td class="contenu"><bean:write name="element" property="type" /></td> <!--  KRA - Version SIOP - PPM 61919 - §6.9 -->
    			  		<td class="contenu"><bean:write name="element" property="arctype" /></td>
    			  		<td class="contenu" align="right"><bean:write name="element" property="consoAnnee" /></td> <!--  KRA - Version SIOP - PPM 61919 - §6.9 -->
    			  		<td class="contenu" align="right"><bean:write name="element" property="bpmontmo" /></td>
    			  		<input type="hidden" name="<%=libPropose%>" value="<bean:write name="element" property="bpmontmo" />">
    			  		<td class="contenu" align="right"><bean:write name="element" property="ecart" /></td>
    			  		<input type="hidden" name="<%=libEcart%>" value="<bean:write name="element" property="ecart" />">
    			  		<td class="contenu" align="right"><bean:write name="element" property="anmont" /></td>
    			  		<input type="hidden" name="<%=libArbitre%>" value="<bean:write name="element" property="anmont" />">
    			  		<!-- YNI
    			  		<td class="contenu"><bean:write name="element" property="date" /></td>
    			  		<td class="contenu"><bean:write name="element" property="identifiant" /></td>
    			  		-->
    			  		<td class="contenu">
    			  			<logic:equal name="element" property="ck" value="N">
                  		        <input TYPE="checkbox" NAME="<%= libck %>" VALUE="<bean:write name="element" property="ck"/>"  onClick="return CalculerTot(this.name,this);">
                            </logic:equal>
                           	<logic:notEqual name="element" property="ck" value="N">
                           		<input TYPE="checkbox" NAME="<%= libck %>" VALUE="<bean:write name="element" property="ck"/>"  onClick="return CalculerTot(this.name,this);" checked>
                            </logic:notEqual>
    			  			
    			  		</td>
    			  		<input type="hidden" name="<%=libFlaglock%>" value="<bean:write name="element" property="flaglock" />">
						
						</tr>
                  </logic:iterate>      
                      
                   
                   <tr class="TableBleu">
						<td class="lib"><B>Total<B></td>
						<td class="lib">&nbsp;</td>
					    <td class="lib">&nbsp;</td>
					    <td class="lib">&nbsp;</td>
					    <td class="lib">&nbsp;</td>
					    <td class="lib">&nbsp;</td>
					    <td class="lib">&nbsp;</td>
					    <td class="lib">&nbsp;</td>
					    <td class="lib">&nbsp;</td>
					    <td class="lib">&nbsp;</td> <!--  KRA - Version SIOP - PPM 61919 - §6.9 -->
					    <td class="lib">&nbsp;</td> <!--  KRA - Version SIOP - PPM 61919 - §6.9 -->
					    <td class="lib">
					    <html:text property="tot_bpmontmo" styleClass="inputgrasleft" size="9" maxlength="9" readonly="true" />
					    </td>
					    <td class="lib">
					    <html:text property="tot_ecart" styleClass="inputgrasleft" size="9" maxlength="9" readonly="true" />
					    </td>
					    <td class="lib">
					    <html:text property="tot_anmont" styleClass="inputgrasleft" size="9" maxlength="9" readonly="true" />
					    </td>		
					    <td class="lib">&nbsp;</td>				
				</tr>	
                   
                   
               	</table>
             
             	<table  width="100%" border="0" cellspacing="0" cellpadding="0">
			   	<tr>
					<td align="center" colspan="4" class="contenu">
						<bip:pagination beanName="listeArbitre"/>
					</td>
				</tr>
	 			<tr><td colspan="4">&nbsp;
	 			</tr>
	 			<tr>
              		<td width="20%">&nbsp;</td>
                	<td width="20%">
                	 <div align="center">
                	  <html:button property="boutonValider" value="Valider" styleClass="input" onclick="Verifier(this.form, 'valider', true, 'NON');"/>
                	 </div>
               		</td> 
               		<td width="20%">
		                	 <div align="center">
		                	  <html:button property="boutonSave" value="Editer" styleClass="input" onclick="Editer(this.form, 'valider', true, 'OUI');"/>
		                	 </div>
		               		</td> 
               		<td width="20%"> 
                  	 <div align="center"> 
                	  <html:submit property="boutonAnnuler" value="Annuler" styleClass="input" onclick="Verifier(this.form, 'annuler', false, 'NON');"/>
              		 </div>
                </td>
                <td width="25%">&nbsp;</td>
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
Integer id_webo_page = new Integer("1057"); 
com.socgen.bip.commun.form.AutomateForm formWebo = arbitrageForm ;
%>
<%@ include file="/incWebo.jsp" %>
</html:html>
<!-- #EndTemplate -->
