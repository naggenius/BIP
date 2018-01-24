package com.socgen.bip.excell;

import java.util.Collection;
import java.util.Iterator;
import java.util.List;
import java.util.Locale;
import java.util.ResourceBundle;

import org.apache.poi.hssf.usermodel.HSSFRow;
import org.apache.poi.hssf.usermodel.HSSFSheet;
import org.apache.poi.hssf.usermodel.HSSFWorkbook;

import com.socgen.bip.service.dto.ChargementFactureDto;

public class FeuilleExcellExportDematIntegre {
	
	private DocumentExcell doc = new DocumentExcell();
	private HSSFSheet sheet1; 
	
	public FeuilleExcellExportDematIntegre(Collection listeCharg, Locale local){
		ResourceBundle myResources = ResourceBundle.getBundle("ApplicationResources",local);
		this.sheet1 = doc.createSheet(myResources.getString("excell.demat.integ.nom.feuille"));
		creerTableauDesFactures(myResources);
		genererTableauDesUsers(myResources,listeCharg);
	}

	private void creerTableauDesFactures(ResourceBundle myResources){
		HSSFRow rowEnteteTableau = this.sheet1.createRow((short)0);
		short col = 0;
		doc.setCellule(rowEnteteTableau, col++, myResources.getString("excell.demat.integ.tableau.entete.numfact"), doc.getStyleEntete());
		doc.setCellule(rowEnteteTableau, col++, myResources.getString("excell.demat.integ.tableau.entete.type"), doc.getStyleEntete());
		doc.setCellule(rowEnteteTableau, col++, myResources.getString("excell.demat.integ.tableau.entete.refsg"), doc.getStyleEntete());
		doc.setCellule(rowEnteteTableau, col++, myResources.getString("excell.demat.integ.tableau.entete.nomsms"), doc.getStyleEntete());
		doc.setCellule(rowEnteteTableau, col++, myResources.getString("excell.demat.integ.tableau.entete.user"), doc.getStyleEntete());
		doc.setCellule(rowEnteteTableau, col++, myResources.getString("excell.demat.integ.tableau.entete.dpgfact"), doc.getStyleEntete());
		doc.setCellule(rowEnteteTableau, col++, myResources.getString("excell.demat.integ.tableau.entete.montantfactht"), doc.getStyleEntete());
		doc.setCellule(rowEnteteTableau, col++, myResources.getString("excell.demat.integ.tableau.entete.montantfactttc"), doc.getStyleEntete());
		doc.setCellule(rowEnteteTableau, col++, myResources.getString("excell.demat.integ.tableau.entete.tvafact"), doc.getStyleEntete());
		doc.setCellule(rowEnteteTableau, col++, myResources.getString("excell.demat.integ.tableau.entete.moisacompta"), doc.getStyleEntete());
		doc.setCellule(rowEnteteTableau, col++, myResources.getString("excell.demat.integ.tableau.entete.codecomtpa"), doc.getStyleEntete());
		doc.setCellule(rowEnteteTableau, col++, myResources.getString("excell.demat.integ.tableau.entete.centrefrais"), doc.getStyleEntete());
		doc.setCellule(rowEnteteTableau, col++, myResources.getString("excell.demat.integ.tableau.entete.numcontrat"), doc.getStyleEntete());
		doc.setCellule(rowEnteteTableau, col++, myResources.getString("excell.demat.integ.tableau.entete.avenant"), doc.getStyleEntete());
		doc.setCellule(rowEnteteTableau, col++, myResources.getString("excell.demat.integ.tableau.entete.statut1"), doc.getStyleEntete());
		doc.setCellule(rowEnteteTableau, col++, myResources.getString("excell.demat.integ.tableau.entete.statut2"), doc.getStyleEntete());
		doc.setCellule(rowEnteteTableau, col++, myResources.getString("excell.demat.integ.tableau.entete.codeste"), doc.getStyleEntete());
		doc.setCellule(rowEnteteTableau, col++, myResources.getString("excell.demat.integ.tableau.entete.libste"), doc.getStyleEntete());
		doc.setCellule(rowEnteteTableau, col++, myResources.getString("excell.demat.integ.tableau.entete.datefact"), doc.getStyleEntete());
		doc.setCellule(rowEnteteTableau, col++, myResources.getString("excell.demat.integ.tableau.entete.dateenvenrcompta"), doc.getStyleEntete());
		doc.setCellule(rowEnteteTableau, col++, myResources.getString("excell.demat.integ.tableau.entete.datesaisi"), doc.getStyleEntete());
		doc.setCellule(rowEnteteTableau, col++, myResources.getString("excell.demat.integ.tableau.entete.datemaj"), doc.getStyleEntete());
		doc.setCellule(rowEnteteTableau, col++, myResources.getString("excell.demat.integ.tableau.entete.dateaccord"), doc.getStyleEntete());
		doc.setCellule(rowEnteteTableau, col++, myResources.getString("excell.demat.integ.tableau.entete.datereception"), doc.getStyleEntete());
		doc.setCellule(rowEnteteTableau, col++, myResources.getString("excell.demat.integ.tableau.entete.datefact"), doc.getStyleEntete());
		
	}

	private void genererTableauDesUsers(ResourceBundle myResources,Collection listeInteg){
		Iterator itInteg = ((List)listeInteg).iterator();
		int numLigne =1;
		while (itInteg.hasNext()){
			ChargementFactureDto chargFact = (ChargementFactureDto)itInteg.next();
			//this.sheet1.createFreezePane(0, 0, 0, 0);
			HSSFRow rowNouvelleLigne = this.sheet1.createRow((short)numLigne);
			short col = 0;
			doc.setCellule(rowNouvelleLigne, col++, chargFact.getNumFact(), doc.getStyleTableau());
			doc.setCellule(rowNouvelleLigne, col++, chargFact.getTypFact(), doc.getStyleTableau());
			doc.setCellule(rowNouvelleLigne, col++, chargFact.getRefSG(), doc.getStyleTableau());
			doc.setCellule(rowNouvelleLigne, col++, chargFact.getNumSMS(), doc.getStyleTableau());
			doc.setCellule(rowNouvelleLigne, col++, chargFact.getFcodUser(), doc.getStyleTableau());
			doc.setCellule(rowNouvelleLigne, col++, chargFact.getFdepPole(), doc.getStyleTableau());
			doc.setCellule(rowNouvelleLigne, col++, chargFact.getFmontHT(), doc.getStyleTableau());
			doc.setCellule(rowNouvelleLigne, col++, chargFact.getFmontTTC(), doc.getStyleTableau());
			doc.setCellule(rowNouvelleLigne, col++, chargFact.getFTVA(), doc.getStyleTableau());
			doc.setCellule(rowNouvelleLigne, col++, chargFact.getFmoiaCompta(), doc.getStyleTableau());
			doc.setCellule(rowNouvelleLigne, col++, chargFact.getFcodCompta(), doc.getStyleTableau());
			doc.setCellule(rowNouvelleLigne, col++, chargFact.getFcentreFrais(), doc.getStyleTableau());
			doc.setCellule(rowNouvelleLigne, col++, chargFact.getNumCont(), doc.getStyleTableau());
			doc.setCellule(rowNouvelleLigne, col++, chargFact.getCAV(), doc.getStyleTableau());
			doc.setCellule(rowNouvelleLigne, col++, chargFact.getFstatut1(), doc.getStyleTableau());
			doc.setCellule(rowNouvelleLigne, col++, chargFact.getFstatut2(), doc.getStyleTableau());
			doc.setCellule(rowNouvelleLigne, col++, chargFact.getSocFact(), doc.getStyleTableau());
			doc.setCellule(rowNouvelleLigne, col++, chargFact.getLlibAnalyt(), doc.getStyleTableau());
			doc.setCellule(rowNouvelleLigne, col++, chargFact.getDatFact(), doc.getStyleTableau());
			doc.setCellule(rowNouvelleLigne, col++, chargFact.getFenrCompta(), doc.getStyleTableau());
			doc.setCellule(rowNouvelleLigne, col++, chargFact.getFdatSai(), doc.getStyleTableau());
			doc.setCellule(rowNouvelleLigne, col++, chargFact.getFdatMAJ(), doc.getStyleTableau());
			doc.setCellule(rowNouvelleLigne, col++, chargFact.getFaccSec(), doc.getStyleTableau());
			doc.setCellule(rowNouvelleLigne, col++, chargFact.getFdatRecep(), doc.getStyleTableau());
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