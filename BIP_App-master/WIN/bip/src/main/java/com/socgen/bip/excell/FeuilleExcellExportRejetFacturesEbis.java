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

import com.socgen.bip.service.dto.LogsFacturesEbisDto;

public class FeuilleExcellExportRejetFacturesEbis {
	private DocumentExcell doc = new DocumentExcell();
	private HSSFSheet sheet1;

	public FeuilleExcellExportRejetFacturesEbis(Collection listeRejet, Locale local)
			throws ParseException {
		ResourceBundle myResources = ResourceBundle.getBundle("ApplicationResources", local);
		this.sheet1 = doc.createSheet(myResources.getString("excell.ebis.factures.logs.nom.feuille"));
		creerTableauDesFactures(myResources);
		genererTableauDesUsers(myResources, listeRejet);
	}

	private void creerTableauDesFactures(ResourceBundle myResources) {
		HSSFRow rowEnteteTableau = this.sheet1.createRow((short) 0);
		short col = 0;
		doc.setCellule(rowEnteteTableau, col++, myResources.getString("excell.ebis.factures.logs.tableau.entete.numenr"), doc.getStyleEntete());
		doc.setCellule(rowEnteteTableau, col++, myResources.getString("excell.ebis.factures.logs.tableau.entete.codeerreur"), doc.getStyleEntete());
		doc.setCellule(rowEnteteTableau, col++, myResources.getString("excell.ebis.factures.logs.tableau.entete.numcont"), doc.getStyleEntete());
		doc.setCellule(rowEnteteTableau, col++, myResources.getString("excell.ebis.factures.logs.tableau.entete.numfact"),doc.getStyleEntete());
		doc.setCellule(rowEnteteTableau, col++, myResources.getString("excell.ebis.factures.logs.tableau.entete.typefact"), doc.getStyleEntete());
		doc.setCellule(rowEnteteTableau, col++, myResources.getString("excell.ebis.factures.logs.tableau.entete.datefact"), doc.getStyleEntete());
		doc.setCellule(rowEnteteTableau, col++, myResources.getString("excell.ebis.factures.logs.tableau.entete.cav"),doc.getStyleEntete());
		doc.setCellule(rowEnteteTableau, col++, myResources.getString("excell.ebis.factures.logs.tableau.entete.cdreferentiel"),doc.getStyleEntete());
		doc.setCellule(rowEnteteTableau, col++, myResources.getString("excell.ebis.factures.logs.tableau.entete.cdexpense"), doc.getStyleEntete());
		doc.setCellule(rowEnteteTableau, col++, myResources.getString("excell.ebis.factures.logs.tableau.entete.soccode"), doc.getStyleEntete());
		doc.setCellule(rowEnteteTableau, col++, myResources.getString("excell.ebis.factures.logs.tableau.entete.numexpense"), doc.getStyleEntete());
		doc.setCellule(rowEnteteTableau, col++, myResources.getString("excell.ebis.factures.logs.tableau.entete.fmontht"), doc.getStyleEntete());
		doc.setCellule(rowEnteteTableau, col++, myResources.getString("excell.ebis.factures.logs.tableau.entete.fmontttc"),doc.getStyleEntete());
		doc.setCellule(rowEnteteTableau, col++, myResources.getString("excell.ebis.factures.logs.tableau.entete.datecompta"), doc.getStyleEntete());
		doc.setCellule(rowEnteteTableau, col++, myResources.getString("excell.ebis.factures.logs.tableau.entete.lnum"), doc.getStyleEntete());
		doc.setCellule(rowEnteteTableau, col++, myResources.getString("excell.ebis.factures.logs.tableau.entete.ident"), doc.getStyleEntete());
		doc.setCellule(rowEnteteTableau, col++, myResources.getString("excell.ebis.factures.logs.tableau.entete.lmontht"),doc.getStyleEntete());
		doc.setCellule(rowEnteteTableau, col++, myResources.getString("excell.ebis.factures.logs.tableau.entete.lmoisprest"),doc.getStyleEntete());
		doc.setCellule(rowEnteteTableau, col++, myResources.getString("excell.ebis.factures.logs.tableau.entete.cusag_expense"), doc.getStyleEntete());
		doc.setCellule(rowEnteteTableau, col++, myResources.getString("excell.ebis.factures.logs.tableau.entete.toppost"), doc.getStyleEntete());
		doc.setCellule(rowEnteteTableau, col++, myResources.getString("excell.ebis.factures.logs.tableau.entete.timestamp"), doc.getStyleEntete());
		doc.setCellule(rowEnteteTableau, col++, myResources.getString("excell.ebis.factures.logs.tableau.entete.topetat"), doc.getStyleEntete());
	}

	private void genererTableauDesUsers(ResourceBundle myResources,	Collection listeRejets) throws ParseException {
		Iterator itRejet = ((List) listeRejets).iterator();
		int numLigne = 1;

		while (itRejet.hasNext()) {
			LogsFacturesEbisDto logsFacturesEbis = (LogsFacturesEbisDto) itRejet.next();
			//this.sheet1.createFreezePane(0, 0, 0, 0);
			HSSFRow rowNouvelleLigne = this.sheet1.createRow((short) numLigne);
			short col = 0;
			doc.setCellule(rowNouvelleLigne, col++, logsFacturesEbis.getNUMENR(), doc.getStyleTableau());
			doc.setCellule(rowNouvelleLigne, col++, logsFacturesEbis.getCODE_RETOUR(), doc.getStyleTableau());
			doc.setCellule(rowNouvelleLigne, col++, logsFacturesEbis.getNUMCONT(), doc.getStyleTableau());
			doc.setCellule(rowNouvelleLigne, col++, logsFacturesEbis.getNUMFACT(), doc.getStyleTableau());
			doc.setCellule(rowNouvelleLigne, col++, logsFacturesEbis.getTYPFACT(), doc.getStyleTableau());
			doc.setCellule(rowNouvelleLigne, col++, logsFacturesEbis.getDATFACT(),doc.getStyleTableau());
			doc.setCellule(rowNouvelleLigne, col++, logsFacturesEbis.getCAV(), doc.getStyleTableau());
			doc.setCellule(rowNouvelleLigne, col++, logsFacturesEbis.getCD_REFERENTIEL(), doc.getStyleTableau());
			doc.setCellule(rowNouvelleLigne, col++, logsFacturesEbis.getCD_EXPENSE(), doc.getStyleTableau());
			doc.setCellule(rowNouvelleLigne, col++, logsFacturesEbis.getSOCCODE(), doc.getStyleTableau());
			doc.setCellule(rowNouvelleLigne, col++, logsFacturesEbis.getNUM_EXPENSE(), doc.getStyleTableau());
			doc.setCellule(rowNouvelleLigne, col++, logsFacturesEbis.getFMONTHT(), doc.getStyleTableau());
			doc.setCellule(rowNouvelleLigne, col++, logsFacturesEbis.getFMONTTTC(), doc.getStyleTableau());
			doc.setCellule(rowNouvelleLigne, col++, logsFacturesEbis.getDATE_COMPTA(), doc.getStyleTableau());
			doc.setCellule(rowNouvelleLigne, col++, logsFacturesEbis.getLNUM(), doc.getStyleTableau());
			doc.setCellule(rowNouvelleLigne, col++, logsFacturesEbis.getIDENT(), doc.getStyleTableau());
			doc.setCellule(rowNouvelleLigne, col++, logsFacturesEbis.getLMONTHT(),doc.getStyleTableau());
			doc.setCellule(rowNouvelleLigne, col++, logsFacturesEbis.getLMOISPREST(), doc.getStyleTableau());
			doc.setCellule(rowNouvelleLigne, col++, logsFacturesEbis.getCUSAG_EXPENSE(), doc.getStyleTableau());
			doc.setCellule(rowNouvelleLigne, col++, logsFacturesEbis.getTOPPOST(), doc.getStyleTableau());
			doc.setCellule(rowNouvelleLigne, col++, logsFacturesEbis.getTIMESTAMP(), doc.getStyleTableau());
			doc.setCellule(rowNouvelleLigne, col++, logsFacturesEbis.getTOP_ETAT(), doc.getStyleTableau());
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