package com.socgen.bip.excell;

import java.text.ParseException;
import java.util.Collection;
import java.util.Iterator;
import java.util.List;
import java.util.Locale;
import java.util.ResourceBundle;

import org.apache.poi.hssf.usermodel.HSSFRow;
import org.apache.poi.hssf.usermodel.HSSFSheet;
import org.apache.poi.hssf.usermodel.HSSFWorkbook;

import com.socgen.bip.service.dto.LogsContratsEbisDto;

public class FeuilleExcellExportLogsContratsEbis {
	private DocumentExcell doc = new DocumentExcell();
	private HSSFSheet sheet1;

	public FeuilleExcellExportLogsContratsEbis(Collection listeRejet, Locale local)
			throws ParseException {
		ResourceBundle myResources = ResourceBundle.getBundle("ApplicationResources", local);
		this.sheet1 = doc.createSheet(myResources.getString("excell.ebis.contrat.logs.nom.feuille"));
		creerTableauDesFactures(myResources);
		genererTableauDesUsers(myResources, listeRejet);
	}

	private void creerTableauDesFactures(ResourceBundle myResources) {
		HSSFRow rowEnteteTableau = this.sheet1.createRow((short) 0);
		short col = 0;
		doc.setCellule(rowEnteteTableau, col++, myResources.getString("excell.ebis.contrat.logs.tableau.entete.numcont"), doc.getStyleEntete());
		doc.setCellule(rowEnteteTableau, col++, myResources.getString("excell.ebis.contrat.logs.tableau.entete.soccont"), doc.getStyleEntete());
		doc.setCellule(rowEnteteTableau, col++, myResources.getString("excell.ebis.contrat.logs.tableau.entete.cav"),doc.getStyleEntete());
		doc.setCellule(rowEnteteTableau, col++, myResources.getString("excell.ebis.contrat.logs.tableau.entete.lcnum"), doc.getStyleEntete());
		doc.setCellule(rowEnteteTableau, col++, myResources.getString("excell.ebis.contrat.logs.tableau.entete.ident"), doc.getStyleEntete());
		doc.setCellule(rowEnteteTableau, col++, myResources.getString("excell.ebis.contrat.logs.tableau.entete.cdatdeb"), doc.getStyleEntete());
		doc.setCellule(rowEnteteTableau, col++, myResources.getString("excell.ebis.contrat.logs.tableau.entete.cdatfin"), doc.getStyleEntete());
		doc.setCellule(rowEnteteTableau, col++, myResources.getString("excell.ebis.contrat.logs.tableau.entete.codsg"), doc.getStyleEntete());
		//YNI fiche 1001
		doc.setCellule(rowEnteteTableau, col++, myResources.getString("excell.ebis.contrat.logs.tableau.entete.libdsg"), doc.getStyleEntete());
		//Fin YNI fiche 1001
		doc.setCellule(rowEnteteTableau, col++, myResources.getString("excell.ebis.contrat.logs.tableau.entete.referentiel"), doc.getStyleEntete());
		doc.setCellule(rowEnteteTableau, col++, myResources.getString("excell.ebis.contrat.logs.tableau.entete.perimetre"), doc.getStyleEntete());
		doc.setCellule(rowEnteteTableau, col++, myResources.getString("excell.ebis.contrat.logs.tableau.entete.commentaire"), doc.getStyleEntete());
	}

	private void genererTableauDesUsers(ResourceBundle myResources,	Collection listeRejets) throws ParseException {
		Iterator itRejet = ((List) listeRejets).iterator();
		int numLigne = 1;
		while (itRejet.hasNext()) {
			LogsContratsEbisDto logsContratEbis = (LogsContratsEbisDto) itRejet.next();
			//this.sheet1.createFreezePane(0, 0, 0, 0);
			HSSFRow rowNouvelleLigne = this.sheet1.createRow((short) numLigne);
			short col = 0;
			doc.setCellule(rowNouvelleLigne, col++, logsContratEbis.getNUMCONT(), doc.getStyleTableau());
			doc.setCellule(rowNouvelleLigne, col++, logsContratEbis.getSOCCONT(), doc.getStyleTableau());
			doc.setCellule(rowNouvelleLigne, col++, logsContratEbis.getCAV(),doc.getStyleTableau());
			doc.setCellule(rowNouvelleLigne, col++, logsContratEbis.getLCNUM(), doc.getStyleTableau());
			doc.setCellule(rowNouvelleLigne, col++, logsContratEbis.getIDENT(), doc.getStyleTableau());
			doc.setCellule(rowNouvelleLigne, col++, logsContratEbis.getCDATDEB(), doc.getStyleTableau());
			doc.setCellule(rowNouvelleLigne, col++, logsContratEbis.getCDATFIN(), doc.getStyleTableau());
			doc.setCellule(rowNouvelleLigne, col++, logsContratEbis.getCODSG(), doc.getStyleTableau());
			////YNI fiche 1001
			doc.setCellule(rowNouvelleLigne, col++, logsContratEbis.getLIBDSG(), doc.getStyleTableau());
			////Fin YNI fiche 1001
			doc.setCellule(rowNouvelleLigne, col++, logsContratEbis.getREFERENTIEL(), doc.getStyleTableau());
			doc.setCellule(rowNouvelleLigne, col++, logsContratEbis.getPERIMETRE(), doc.getStyleTableau());
			doc.setCellule(rowNouvelleLigne, col++, logsContratEbis.getCOMMENTAIRE(), doc.getStyleTableau());
			numLigne++;
		}
	}
	/**
	 * Méthode permettant de retourner le flux Excell générer
	 * @return wb
	 */
	public HSSFWorkbook getWb() {
		return doc.getWb();
	}
}