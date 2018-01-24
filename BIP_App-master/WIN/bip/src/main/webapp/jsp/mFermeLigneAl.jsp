<!DOCTYPE html>
<%@ taglib uri="/WEB-INF/struts-bean.tld" prefix="bean" %>
<%@ taglib uri="/WEB-INF/struts-html.tld" prefix="html" %>
<%@ taglib uri="/WEB-INF/struts-logic.tld" prefix="logic" %>

<%@ page language="java" import="org.owasp.esapi.ESAPI,java.sql.*,java.io.*,javax.servlet.*,javax.servlet.http.*,com.socgen.ich.ihm.*"    errorPage="../jsp/erreur.jsp"  %>
<jsp:useBean id="ligneBipMoForm" scope="request" class="com.socgen.bip.form.LigneBipMoForm" />
<html:html locale="true">
<head>
 

<%@ taglib uri="/WEB-INF/bip.tld" prefix="bip" %>
 
<title>Page BIP</title>

<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">

<bip:VerifUser page="jsp/fFermeLigneAl.jsp"/> 

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
   var Message="<bean:write filter="false"  name="ligneBipMoForm"  property="msgErreur" />";
   var Focus = "<bean:write name="ligneBipMoForm"  property="focus" />";
   if (Message != "") {
      alert(Message);
   }
}

function Verifier(form, action,mode, flag)
{
   blnVerification = flag;
   form.action.value = action;
}

function ValiderEcran(form)
{
   return true;
}
</script>

</head>
<body bgcolor="#FFFFFF" text="#000000" topmargin="0" leftmargin="0" onLoad="MessageInitial();">
<div id="mainContainer">
<div id="topContainer">
<div id="entete"></div>
<div id="logo">
		<div id="logo_sg"><img src="../images/logo_SG.gif" width="162" height="33" border="0" /></div>
		<div id="nomdusite"><img src="../images/bip_logo.png" width="78" height="46" border="0" /></div>
</div>
<table width="100%" border="0" cellpadding="0" cellspacing="0" >
  <tr> 
    <td> 
      <table width="100%" border="0" cellspacing="0" cellpadding="0">
        <tr> 
          <td><div id="outils" align="center"><!-- #BeginEditable "barre_haut" -->
              <%ToolBarNew tb = new com.socgen.ich.ihm.ToolBarNew("bip_ihm",false,false,true,true,false,false,false,false,false,request) ;%>
				<%=tb.printHtml()%><!-- #EndEditable -->
		</div></td>
        </tr>
        <tr > 
          <td> 
            &nbsp;
          </td>
        </tr>
        <tr> 
          <td>&nbsp;</td>
        </tr>
<!--         <tr>  -->
<!--           <td background="../images/ligne.gif"></td> -->
<!--         </tr> -->
        <tr> 
          <td height="20" class="TitrePage">Etes-vous sûr de vouloir fermer la ligne suivante?</td>
        </tr>
<!--         <tr>  -->
<!--           <td background="../images/ligne.gif"></td> -->
<!--         </tr> -->
        <tr> 
          <td> 
          	<html:form action="/fermeLigneBip"  onsubmit="return ValiderEcran(this);">
            <div align="center">
            <input type="hidden" name="pageAide" value="<%= sPageAide %>">
			  <html:hidden property="action"/> 
              <html:hidden property="mode"/>
<html:hidden property="arborescence" value="<%= arborescence %>"/> 
			  <html:hidden property="flaglock"/> 
              <html:hidden property="flag"/>
              <html:hidden property="titrePage"/> 
            
              <table border=0 cellspacing=2  cellpadding=2  class="tableBleu" width="500">
                <tr> 
                  <td align=center height="20">&nbsp;</td>
                </tr>
                <tr align="left"> 
                  <td class=texte nowrap>Code ligne BIP :</td>
                  <td class="texte" nowrap> <b><bean:write name="ligneBipMoForm"  property="pid" /> </b>
                    <html:hidden property="pid"/>&nbsp;  </td>
                  <td class=texte >Libellé :</td>
                  <td class="texte" nowrap> <bean:write name="ligneBipMoForm"  property="pnom" /> 
                    <html:hidden property="pnom"/> &nbsp; </td>
                  <td class=texte nowrap>Année :</td>
                  <td nowrap class="texte"> <b><bean:write name="ligneBipMoForm"  property="annee" /></b> 
                    <html:hidden property="adatestatut"/> &nbsp; </td>
                </tr>
              
                <tr align="left"> 
                  <td class=texte>Type :</td>
                  <td class="texte"> <bean:write name="ligneBipMoForm"  property="typproj" /> 
                    <html:hidden property="typproj"/> 
                     </td>
                
                  <td class=texte colspan="1">Typologie :</td>
                  <td class="texte" colspan="1"><bean:write name="ligneBipMoForm"  property="arctype" /> 
                    <html:hidden property="arctype"/>   </td>
                  <td class=texte>Tri : </td>
                  <td class="texte"> <bean:write name="ligneBipMoForm"  property="toptri" /> 
                    <html:hidden property="toptri"/> 
                  </td>
                </tr>
              </table>
              <table border="0" cellspacing="2" cellpadding="2" class="tableBleu" width=500>
                <tr> 
                  <td width=171> 
                    <hr>
                  </td>
                  <td class="texte"  width="141"><b> 
                    <center>
                      Référentiel projets 
                    </center>
                    </b></td>
                  <td width=167> 
                    <hr>
                  </td>
                </tr>
              </table>
              <table border=0 cellspacing=2  cellpadding=2  class="tableBleu" width=500>
                 <tr align="left">
                  <td class=texte >Projet sp&eacute;cial :</td>
                  <td > <bean:write name="ligneBipMoForm"  property="codpspe" />  <bean:write name="ligneBipMoForm"  property="libpspe" /> 
                    <html:hidden property="codpspe"/>     
                    <html:hidden property="libpspe"/>  
                  </td>
                </tr>
            
                <tr align="left"> 
                  <td class="texte">Code Projet :</td>
                  <td class="texte"> <bean:write name="ligneBipMoForm"  property="icpi" />  <bean:write name="ligneBipMoForm"  property="ilibel" /> 
                    <html:hidden property="icpi"/>     
                    <html:hidden property="ilibel"/>
                    </td>
                 </tr>
            
                <tr align="left"> 
                  
                  <td class="texte">Code Application :</td>
                  <td class="texte"> <bean:write name="ligneBipMoForm"  property="airt" />  <bean:write name="ligneBipMoForm"  property="alibel" /> 
                    <html:hidden property="airt"/>     
                    <html:hidden property="alibel"/>
                
                  </td>
                 </tr>
            
                <tr align="left"> 
                  <td class="texte" width=155 nowrap="nowrap">Code Dossier projet:</td>
                  <td class="texte"> <bean:write name="ligneBipMoForm"  property="dpcode" />  <bean:write name="ligneBipMoForm"  property="dplib" /> 
                    <html:hidden property="dpcode"/>     
                    <html:hidden property="dplib"/>
                  </td> 
                </tr>
              </table>
              <table border="0" cellspacing="2" cellpadding="2" class="tableBleu" width="500" >
                <tr> 
                  <td width=161> 
                    <hr>
                  </td>
                  <td class="texte"  width="161"><b> 
                    <center>
                      Clients et Fournisseurs 
                    </center>
                    </b></td>
                  <td width=157> 
                    <hr>
                  </td>
                </tr>
              </table>
              <table border=0 cellspacing=2  cellpadding=2  class="tableBleu" width=500>
                <tr align="left"> 
                  <td class="texte" >Code DPG Fournisseur :</td>
                  <td colspan="3" class="texte"> <bean:write name="ligneBipMoForm"  property="codsg" />  <bean:write name="ligneBipMoForm"  property="libdsg" /> 
                    <html:hidden property="codsg"/>     
                    <html:hidden property="libdsg"/>
                  </td>
                </tr>
                <tr align="left">
                  <td class="texte">Chef de projet ME :</td>
                  <td class="texte"> <bean:write name="ligneBipMoForm"  property="rnom" /> 
                    <html:hidden property="rnom"/>
                  </td>
                  <td class="texte">Métier :</td>
                  <td class="texte"> <bean:write name="ligneBipMoForm"  property="metier" /> 
                    <html:hidden property="metier"/>
                  </td>
                </tr>
                 <tr align="left"> 
                  	<td class="texte">Nom du correspondant MO :</td>
                  	<td nowrap class="texte"> <bean:write name="ligneBipMoForm"  property="pnmouvra" /> 
                    <html:hidden property="pnmouvra"/> </td>
                
                   <td class="texte">CA payeur : </td>
                  	<td class="texte">  <bean:write name="ligneBipMoForm"  property="codcamo" /> 
                    <html:hidden property="codcamo"/>
                  </td>
                </tr>
                <tr align="left"> 
                  <td class="texte" nowrap>Direction cliente :</td>
                  <td class="texte"><bean:write name="ligneBipMoForm"  property="clilib" /> 
                    <html:hidden property="clicode"/> 
				  </td>
                </tr>
              </table>
              <table border="0" cellspacing="2" cellpadding="2" class="tableBleu" width="500" >
                <tr> 
                  <td width=111> 
                    <hr>
                  </td>
                  <td  class="texte" width="250"><b> 
                    <center>
                      Objet
                    </center>
                    </b></td>
                  <td width=118> 
                    <hr>
                  </td>
                </tr>
              </table>
              <table border=0 cellspacing=2  cellpadding=2  class="tableBleu" width=500>
                <tr> 
                  <td align="center" class="texte"> 
                  	<bean:write name="ligneBipMoForm"  property="pobjet" /> 
                  	<html:hidden property="pobjet"/> 
                  </td>
                </tr>
                </table>
              <table border="0" cellspacing="2" cellpadding="2" class="tableBleu" width="500" >
				<tr align="left">
					<td width="25%"><hr></td>
					<td align=center class="texte"><b>Données budgétaires en JH.</b></td>
					<td width="25%"><hr></td>
				</tr>
				</table>
				<table border="0" cellspacing="2" cellpadding="2" class="tableBleu" width="500" >
                 <tr align="left"> 
                  <td class="texte">Notifi&eacute; : </td>
                  <td class="texte">
				  <bean:write name="ligneBipMoForm"  property="bnmont" /> 
                    <html:hidden property="bnmont"/>
                  </td>
                  <td class="texte">Propos&eacute; fournisseur :</td>
                  <td class="texte">
				  <bean:write name="ligneBipMoForm"  property="bpmontme" /> 
                    <html:hidden property="bpmontme"/>
                  </td>
                </tr>
                <tr align="left"> 
                  <td class="texte">Arbitr&eacute; : </td>
                  <td class="texte">
				  <bean:write name="ligneBipMoForm"  property="anmont" /> 
                    <html:hidden property="anmont"/>
                  </td>
                  <td class="texte">Ré-estim&eacute;e fournisseur :</td>
                  <td class="texte">
				  <bean:write name="ligneBipMoForm"  property="reestime" /> 
                    <html:hidden property="reestime"/>
                  </td>
                </tr>
                 <tr align="left"> 
                  <td class="texte">Estimation pluriannuelle : </td>
                  <td class="texte">
				  <bean:write name="ligneBipMoForm"  property="estimplurian" /> 
                    <html:hidden property="estimplurian"/>
                  </td>
                  <td class="texte">Réalis&eacute; de l'année :</td>
                  <td class="texte">
				   <bean:write name="ligneBipMoForm"  property="cusag" /> 
                    <html:hidden property="cusag"/>
                  </td>
                </tr>
                
                <tr align="left">
					<td class="texte">
				     	Proposé client :
					</td>
					<td class="texte">
				   		<bean:write name='ligneBipMoForm'  property='bpmontmo' />
				   		<html:hidden property="bpmontmo"/>
					</td>
				</tr>

  				<tr> 
                <td>&nbsp;</td>
                </tr>
              </table>
       
              </div>
          </td>
        </tr>
        <tr> 
          <td align="center"> 
            <table width="100%" border="0">
              <tr><td height="15"></td></tr>
              <tr> 
                <td width="25%">&nbsp;</td>
                <td width="25%"> 
                  <div align="center"> <html:submit property="boutonValider" value=" Oui " styleClass="input" onclick="Verifier(this.form, 'valider', this.form.mode.value,true);"/> 
                  </div>
                </td>
                <td width="25%"> 
                  <div align="center"> <html:submit property="boutonAnnuler" value=" Non " styleClass="input" onclick="Verifier(this.form, 'annuler', null, false);"/> 
                  </div>
                </td>
                <td width="25%">&nbsp;</td>
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
            <div align="center"><html:errors/></div>
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
</body></html:html>