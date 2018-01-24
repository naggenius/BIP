<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<title>Confirmation de modification projet</title>
<script language="JavaScript">
function updateLines(confirm){
//PPM 64510	
	if(confirm=="oui"){
		
		window.opener.document.forms[0].updatestatut.value="O";
	}
	else{
	}
	window.opener.document.forms[0].submit();
	window.close();
}
</script>
</head>
<body style="">
	<br/>
	<div class="lib" style="text-align:center;font-size:12px;color:#484848;font-family:Arial, Helvetica, sans-serif">
		Souhaitez-vous que les lignes BIP de statut O (A immobiliser), liées à ce projet, 
		aient leur statut mis à jour avec le statut Q (Démarré sans amortissement) ?
	</div>
	<br/>
	<form>
	<div style="text-align:center">
	<table style="width:100%">
	<tr>
		<td><input class="input" type="button" value="OUI" onclick="updateLines('oui')" style=""/></td>
		<td><input class="input" type="button" value="NON" onclick="updateLines('non')" style=""/></td> 
		<td><input class="input" type="button" value="ANNULER" onclick="window.close();" style=""/></td>
	</tr>
	</table>
	</div>
	
	</form>
</body>
</html>