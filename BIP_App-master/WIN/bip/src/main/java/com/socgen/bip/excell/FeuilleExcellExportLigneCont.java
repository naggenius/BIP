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

import com.socgen.bip.service.dto.LogsLigneContDto;

public class FeuilleExcellExportLigneCont {
	private DocumentExcell doc = new DocumentExcell();
	private HSSFSheet sheet1;

	public FeuilleExcellExportLigneCont(Collection listeRejet, Locale local)
			throws ParseException {
		ResourceBundle myResources = ResourceBundle.getBundle("ApplicationResources", local);
		this.sheet1 = doc.createSheet(myResources.getString("excell.ebis.ll.nom.feuille"));
		creerTableauDesLogsTT(myResources);
		genererTableauDesUsers(myResources, listeRejet);
	}

	private void creerTableauDesLogsTT(ResourceBundle myResources) {
		HSSFRow rowEnteteTableau = this.sheet1.createRow((short) 0);
		short col = 0;    
		doc.setCellule(rowEnteteTableau, col++, myResources.getString("excell.ebis.ll.logs.type_action"), doc.getStyleEntete());
		doc.setCellule(rowEnteteTableau, col++, myResources.getString("excell.ebis.ll.logs.date_log"), doc.getStyleEntete());
		doc.setCellule(rowEnteteTableau, col++, myResources.getString("excell.ebis.ll.logs.user_log"), doc.getStyleEntete());
		doc.setCellule(rowEnteteTableau, col++, myResources.getString("excell.ebis.ll.logs.contrat"), doc.getStyleEntete());
		doc.setCellule(rowEnteteTableau, col++, myResources.getString("excell.ebis.ll.logs.perimetre"), doc.getStyleEntete());
		doc.setCellule(rowEnteteTableau, col++, myResources.getString("excell.ebis.ll.logs.reffournisseur"),doc.getStyleEntete());
		doc.setCellule(rowEnteteTableau, col++, myResources.getString("excell.ebis.ll.logs.fournisseur"), doc.getStyleEntete());
		doc.setCellule(rowEnteteTableau, col++, myResources.getString("excell.ebis.ll.logs.ligne"), doc.getStyleEntete());
		doc.setCellule(rowEnteteTableau, col++, myResources.getString("excell.ebis.ll.logs.code_ressource"),doc.getStyleEntete());
		doc.setCellule(rowEnteteTableau, col++, myResources.getString("excell.ebis.ll.logs.nom_ressource"),doc.getStyleEntete());
		doc.setCellule(rowEnteteTableau, col++, myResources.getString("excell.ebis.ll.logs.datedeb_ligne"), doc.getStyleEntete());
		doc.setCellule(rowEnteteTableau, col++, myResources.getString("excell.ebis.ll.logs.datefin_ligne"), doc.getStyleEntete());
		doc.setCellule(rowEnteteTableau, col++, myResources.getString("excell.ebis.ll.logs.societe"),doc.getStyleEntete());
		doc.setCellule(rowEnteteTableau, col++, myResources.getString("excell.ebis.ll.logs.siren"), doc.getStyleEntete());
		doc.setCellule(rowEnteteTableau, col++, myResources.getString("excell.ebis.ll.logs.avenant"), doc.getStyleEntete());
		doc.setCellule(rowEnteteTableau, col++, myResources.getString("excell.ebis.ll.logs.datdebcontrat"),doc.getStyleEntete());
		doc.setCellule(rowEnteteTableau, col++, myResources.getString("excell.ebis.ll.logs.datfincontrat"),doc.getStyleEntete());
					
	}

	private void genererTableauDesUsers(ResourceBundle myResources,	Collection listeRejets) throws ParseException {
		Iterator itRejet = ((List) listeRejets).iterator();
		int numLigne = 1;

		while (itRejet.hasNext()) {
			LogsLigneContDto logsLigneContDto = (LogsLigneContDto) itRejet.next();
			//this.sheet1.createFreezePane(0, 0, 0, 0);
			HSSFRow rowNouvelleLigne = this.sheet1.createRow((short) numLigne);
			short col =0;
			doc.setCellule(rowNouvelleLigne, col++, logsLigneContDto.getTYPE_ACTION(), doc.getStyleTableau());
			doc.setCellule(rowNouvelleLigne, col++, logsLigneContDto.getDATE_LOG() , doc.getStyleTableau());
			doc.setCellule(rowNouvelleLigne, col++, logsLigneContDto.getUSER_LOG() , doc.getStyleTableau());
			doc.setCellule(rowNouvelleLigne, col++, logsLigneContDto.getCONTRAT(), doc.getStyleTableau());
			doc.setCellule(rowNouvelleLigne, col++, logsLigneContDto.getPERIMETRE(), doc.getStyleTableau());
			doc.setCellule(rowNouvelleLigne, col++, logsLigneContDto.getREFFOURNISSEUR(), doc.getStyleTableau());
			doc.setCellule(rowNouvelleLigne, col++, logsLigneContDto.getFOURNISSEUR(), doc.getStyleTableau());
			doc.setCellule(rowNouvelleLigne, col++, logsLigneContDto.getLIGNE(),doc.getStyleTableau());
			doc.setCellule(rowNouvelleLigne, col++, logsLigneContDto.getCODE_RESSOURCE(), doc.getStyleTableau());
			doc.setCellule(rowNouvelleLigne, col++, logsLigneContDto.getNOM_RESSOURCE(), doc.getStyleTableau());
			doc.setCellule(rowNouvelleLigne, col++, logsLigneContDto.getDATEDEB_LIGNE(), doc.getStyleTableau());
			doc.setCellule(rowNouvelleLigne, col++, logsLigneContDto.getDATEFIN_LIGNE(), doc.getStyleTableau());
			doc.setCellule(rowNouvelleLigne, col++, logsLigneContDto.getSOCIETE(),doc.getStyleTableau());
			doc.setCellule(rowNouvelleLigne, col++, logsLigneContDto.getSIREN(), doc.getStyleTableau());
			doc.setCellule(rowNouvelleLigne, col++, logsLigneContDto.getAVENANT(), doc.getStyleTableau());
			doc.setCellule(rowNouvelleLigne, col++, logsLigneContDto.getDATDEBCONTRAT(), doc.getStyleTableau());
			doc.setCellule(rowNouvelleLigne, col++, logsLigneContDto.getDATFINCONTRAT(), doc.getStyleTableau());
		
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