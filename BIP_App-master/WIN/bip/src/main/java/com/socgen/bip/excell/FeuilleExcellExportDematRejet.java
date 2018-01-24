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

import com.socgen.bip.service.dto.RejetFactureDto;

public class FeuilleExcellExportDematRejet {
	private DocumentExcell doc = new DocumentExcell();

	private HSSFSheet sheet1;

	public FeuilleExcellExportDematRejet(Collection listeRejet, Locale local)
			throws ParseException {
		ResourceBundle myResources = ResourceBundle.getBundle("ApplicationResources", local);
		this.sheet1 = doc.createSheet(myResources.getString("excell.demat.rejet.nom.feuille"));
		creerTableauDesFactures(myResources);
		genererTableauDesUsers(myResources, listeRejet);
	}

	private void creerTableauDesFactures(ResourceBundle myResources) {

		HSSFRow rowEnteteTableau = this.sheet1.createRow((short) 0);
		short col = 0;
		doc.setCellule(rowEnteteTableau, col++, myResources.getString("excell.demat.rejet.tableau.entete.coderr"), doc.getStyleEntete());
		doc.setCellule(rowEnteteTableau, col++, myResources.getString("excell.demat.rejet.tableau.entete.liberr"), doc.getStyleEntete());
		doc.setCellule(rowEnteteTableau, col++, myResources.getString("excell.demat.rejet.tableau.entete.codemetteur"),doc.getStyleEntete());
		doc.setCellule(rowEnteteTableau, col++, myResources.getString("excell.demat.rejet.tableau.entete.dateheure"), doc.getStyleEntete());
		doc.setCellule(rowEnteteTableau, col++, myResources.getString("excell.demat.rejet.tableau.entete.numordre"), doc.getStyleEntete());
		doc.setCellule(rowEnteteTableau, col++, myResources.getString("excell.demat.rejet.tableau.entete.refsg"), doc.getStyleEntete());
		doc.setCellule(rowEnteteTableau, col++, myResources.getString("excell.demat.rejet.tableau.entete.idfournisseur"),doc.getStyleEntete());
		doc.setCellule(rowEnteteTableau, col++, myResources.getString("excell.demat.rejet.tableau.entete.typedoc"), doc.getStyleEntete());
		doc.setCellule(rowEnteteTableau, col++, myResources.getString("excell.demat.rejet.tableau.entete.numfact"), doc.getStyleEntete());
		doc.setCellule(rowEnteteTableau, col++, myResources.getString("excell.demat.rejet.tableau.entete.datefact"), doc.getStyleEntete());
		doc.setCellule(rowEnteteTableau, col++, myResources.getString("excell.demat.rejet.tableau.entete.refcontrat"), doc.getStyleEntete());
		doc.setCellule(rowEnteteTableau, col++, myResources.getString("excell.demat.rejet.tableau.entete.rib"), doc.getStyleEntete());
		doc.setCellule(rowEnteteTableau, col++, myResources.getString("excell.demat.rejet.tableau.entete.montantht"), doc.getStyleEntete());
		doc.setCellule(rowEnteteTableau, col++, myResources.getString("excell.demat.rejet.tableau.entete.montanttva"), doc.getStyleEntete());
		doc.setCellule(rowEnteteTableau, col++, myResources.getString("excell.demat.rejet.tableau.entete.montantttc"), doc.getStyleEntete());

		for (int j = 1; j < 9; j++) {
			doc.setCellule(	rowEnteteTableau,col++,myResources.getString("excell.demat.rejet.tableau.entete.dateprestation")+ j, doc.getStyleEntete());
			doc.setCellule(	rowEnteteTableau,col++,	myResources.getString("excell.demat.rejet.tableau.entete.nomprestation")+ j, doc.getStyleEntete());
			doc.setCellule(rowEnteteTableau, col++, myResources.getString("excell.demat.rejet.tableau.entete.montantht")+ j, doc.getStyleEntete());
		}
	}

	private void genererTableauDesUsers(ResourceBundle myResources,	Collection listeRejets) throws ParseException {
		Iterator itRejet = ((List) listeRejets).iterator();
		int numLigne = 1;

		while (itRejet.hasNext()) {
			RejetFactureDto rejetFact = (RejetFactureDto) itRejet.next();
			//this.sheet1.createFreezePane(0, 0, 0, 0);
			HSSFRow rowNouvelleLigne = this.sheet1.createRow((short) numLigne);
			short col = 0;
			//HSSFCellStyle style=doc.getWb().createCellStyle();
			
			doc.setCellule(rowNouvelleLigne, col++, rejetFact.getCodeErr(), doc.getStyleTableau());
			doc.setCellule(rowNouvelleLigne, col++, rejetFact.getLibErr(), doc.getStyleTableau());
			doc.setCellule(rowNouvelleLigne, col++, rejetFact.getEmetteur(),doc.getStyleTableau());
			doc.setCellule(rowNouvelleLigne, col++, rejetFact.getDateFic(), doc.getStyleTableau());
			doc.setCellule(rowNouvelleLigne, col++, rejetFact.getNumOrd(), doc.getStyleTableau());
			doc.setCellule(rowNouvelleLigne, col++, rejetFact.getRefSG(), doc.getStyleTableau());
			doc.setCellule(rowNouvelleLigne, col++, rejetFact.getSiren(), doc.getStyleTableau());
			doc.setCellule(rowNouvelleLigne, col++, rejetFact.getTypFact(), doc.getStyleTableau());
			doc.setCellule(rowNouvelleLigne, col++, rejetFact.getNumFact(), doc.getStyleTableau());
			doc.setCellule(rowNouvelleLigne, col++, rejetFact.getDatFact(), doc.getStyleTableau());
			doc.setCellule(rowNouvelleLigne, col++, rejetFact.getNumCont(), doc.getStyleTableau());
			doc.setCellule(rowNouvelleLigne, col++, rejetFact.getRib(), doc.getStyleTableau());
			doc.setCellule(rowNouvelleLigne, col++, rejetFact.getMontHT(), doc.getStyleTableau());
			doc.setCellule(rowNouvelleLigne, col++, rejetFact.getMontTVA(), doc.getStyleTableau());
			doc.setCellule(rowNouvelleLigne, col++, rejetFact.getMontTTC(), doc.getStyleTableau());
			for (int i = 1; i < Integer.parseInt(rejetFact.getNbPrest())+1; i++) {
				
				if(i==1) {
					doc.setCellule(rowNouvelleLigne, col++, rejetFact.getDatPrest1(), doc.getStyleTableau());
					doc.setCellule(rowNouvelleLigne, col++, rejetFact.getNomPrest1(), doc.getStyleTableau());
					doc.setCellule(rowNouvelleLigne, col++, rejetFact.getMontHT1(), doc.getStyleTableau());
				}
				if(i==2) {
					doc.setCellule(rowNouvelleLigne, col++, rejetFact.getDatPrest2(), doc.getStyleTableau());
					doc.setCellule(rowNouvelleLigne, col++, rejetFact.getNomPrest2(), doc.getStyleTableau());
					doc.setCellule(rowNouvelleLigne, col++, rejetFact.getMontHT2(), doc.getStyleTableau());
				}
				if(i==3) {
					doc.setCellule(rowNouvelleLigne, col++, rejetFact.getDatPrest3(), doc.getStyleTableau());
					doc.setCellule(rowNouvelleLigne, col++, rejetFact.getNomPrest3(), doc.getStyleTableau());
					doc.setCellule(rowNouvelleLigne, col++, rejetFact.getMontHT3(), doc.getStyleTableau());
				}
				if(i==4) {
					doc.setCellule(rowNouvelleLigne, col++, rejetFact.getDatPrest4(), doc.getStyleTableau());
					doc.setCellule(rowNouvelleLigne, col++, rejetFact.getNomPrest4(), doc.getStyleTableau());
					doc.setCellule(rowNouvelleLigne, col++, rejetFact.getMontHT4(), doc.getStyleTableau());
				}
				if(i==5) {
					doc.setCellule(rowNouvelleLigne, col++, rejetFact.getDatPrest5(), doc.getStyleTableau());
					doc.setCellule(rowNouvelleLigne, col++, rejetFact.getNomPrest5(), doc.getStyleTableau());
					doc.setCellule(rowNouvelleLigne, col++, rejetFact.getMontHT5(), doc.getStyleTableau());
				}
				if(i==6) {
					doc.setCellule(rowNouvelleLigne, col++, rejetFact.getDatPrest6(), doc.getStyleTableau());
					doc.setCellule(rowNouvelleLigne, col++, rejetFact.getNomPrest6(), doc.getStyleTableau());
					doc.setCellule(rowNouvelleLigne, col++, rejetFact.getMontHT6(), doc.getStyleTableau());
				}
				if(i==7) {
					doc.setCellule(rowNouvelleLigne, col++, rejetFact.getDatPrest7(), doc.getStyleTableau());
					doc.setCellule(rowNouvelleLigne, col++, rejetFact.getNomPrest7(), doc.getStyleTableau());
					doc.setCellule(rowNouvelleLigne, col++, rejetFact.getMontHT7(), doc.getStyleTableau());
				}
				if(i==8) {
					doc.setCellule(rowNouvelleLigne, col++, rejetFact.getDatPrest8(), doc.getStyleTableau());
					doc.setCellule(rowNouvelleLigne, col++, rejetFact.getNomPrest8(), doc.getStyleTableau());
					doc.setCellule(rowNouvelleLigne, col++, rejetFact.getMontHT8(), doc.getStyleTableau());
				}
			}
			if(rejetFact.getColonneErreur()!= null)
				if(rejetFact.getColonneErreur().trim()!= "")
				{
					int colonne = Integer.parseInt(rejetFact.getColonneErreur());
					if (colonne>-1)
						doc.updateColorCelluleError(rowNouvelleLigne,(short)(colonne+2));
				}
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