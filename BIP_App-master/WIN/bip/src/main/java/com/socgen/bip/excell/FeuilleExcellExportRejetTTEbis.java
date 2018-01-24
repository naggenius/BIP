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

import com.socgen.bip.service.dto.LogsTTEbisDto;

public class FeuilleExcellExportRejetTTEbis {
	private DocumentExcell doc = new DocumentExcell();
	private HSSFSheet sheet1;

	public FeuilleExcellExportRejetTTEbis(Collection listeRejet, Locale local)
			throws ParseException {
		ResourceBundle myResources = ResourceBundle.getBundle("ApplicationResources", local);
		this.sheet1 = doc.createSheet(myResources.getString("excell.ebis.tt.nom.feuille"));
		creerTableauDesLogsTT(myResources);
		genererTableauDesUsers(myResources, listeRejet);
	}

	private void creerTableauDesLogsTT(ResourceBundle myResources) {
		HSSFRow rowEnteteTableau = this.sheet1.createRow((short) 0);
		short col = 0;  
		  
		doc.setCellule(rowEnteteTableau, col++, myResources.getString("excell.ebis.tt.logs.dpg"), doc.getStyleEntete());
		doc.setCellule(rowEnteteTableau, col++, myResources.getString("excell.ebis.tt.logs.dpg.contrat"), doc.getStyleEntete());
		doc.setCellule(rowEnteteTableau, col++, myResources.getString("excell.ebis.tt.logs.soccode"), doc.getStyleEntete());
		doc.setCellule(rowEnteteTableau, col++, myResources.getString("excell.ebis.tt.logs.ident"), doc.getStyleEntete());
		doc.setCellule(rowEnteteTableau, col++, myResources.getString("excell.ebis.tt.logs.rnom"),doc.getStyleEntete());
		doc.setCellule(rowEnteteTableau, col++, myResources.getString("excell.ebis.tt.logs.lmoisprest"), doc.getStyleEntete());
		doc.setCellule(rowEnteteTableau, col++, myResources.getString("excell.ebis.tt.logs.cusag"), doc.getStyleEntete());
		doc.setCellule(rowEnteteTableau, col++, myResources.getString("excell.ebis.tt.logs.datdep"),doc.getStyleEntete());
		doc.setCellule(rowEnteteTableau, col++, myResources.getString("excell.ebis.tt.logs.numcont"),doc.getStyleEntete());
		doc.setCellule(rowEnteteTableau, col++, myResources.getString("excell.ebis.tt.logs.cav"),doc.getStyleEntete()); 
		doc.setCellule(rowEnteteTableau, col++, myResources.getString("excell.ebis.tt.logs.soccont"), doc.getStyleEntete());
		doc.setCellule(rowEnteteTableau, col++, myResources.getString("excell.ebis.tt.logs.referentiel"), doc.getStyleEntete());
		doc.setCellule(rowEnteteTableau, col++, myResources.getString("excell.ebis.tt.logs.perimetre"), doc.getStyleEntete());
		doc.setCellule(rowEnteteTableau, col++, myResources.getString("excell.ebis.tt.logs.cdatfin"), doc.getStyleEntete()); 
		doc.setCellule(rowEnteteTableau, col++, myResources.getString("excell.ebis.tt.logs.syscompt.res"), doc.getStyleEntete());
		doc.setCellule(rowEnteteTableau, col++, myResources.getString("excell.ebis.tt.logs.syscompt.contrat"), doc.getStyleEntete()); 
		doc.setCellule(rowEnteteTableau, col++, myResources.getString("excell.ebis.tt.logs.message"), doc.getStyleEntete());		
		doc.setCellule(rowEnteteTableau, col++, myResources.getString("excell.ebis.tt.logs.code_retour"), doc.getStyleEntete());
		doc.setCellule(rowEnteteTableau, col++, myResources.getString("excell.ebis.tt.logs.date_trait"), doc.getStyleEntete());
		//		doc.setCellule(rowEnteteTableau, col++, myResources.getString("excell.ebis.tt.logs.timestamp"),doc.getStyleEntete());
	}

	private void genererTableauDesUsers(ResourceBundle myResources,	Collection listeRejets) throws ParseException {
		Iterator itRejet = ((List) listeRejets).iterator();
		int numLigne = 1;

		while (itRejet.hasNext()) {
			LogsTTEbisDto logsTTEbisDto = (LogsTTEbisDto) itRejet.next();
			//this.sheet1.createFreezePane(0, 0, 0, 0);
			HSSFRow rowNouvelleLigne = this.sheet1.createRow((short) numLigne);
			short col = 0;
			doc.setCellule(rowNouvelleLigne, col++, logsTTEbisDto.getDPG(), doc.getStyleTableau());
			doc.setCellule(rowNouvelleLigne, col++, logsTTEbisDto.getCODSG_CONT() , doc.getStyleTableau());
			doc.setCellule(rowNouvelleLigne, col++, logsTTEbisDto.getSOCCODE(), doc.getStyleTableau());
			doc.setCellule(rowNouvelleLigne, col++, logsTTEbisDto.getIDENT(), doc.getStyleTableau());
			doc.setCellule(rowNouvelleLigne, col++, logsTTEbisDto.getRNOM(), doc.getStyleTableau());
			doc.setCellule(rowNouvelleLigne, col++, logsTTEbisDto.getLMOISPREST(), doc.getStyleTableau());
			doc.setCellule(rowNouvelleLigne, col++, logsTTEbisDto.getCUSAG(),doc.getStyleTableau());
			doc.setCellule(rowNouvelleLigne, col++, logsTTEbisDto.getDATDEP(), doc.getStyleTableau());
			doc.setCellule(rowNouvelleLigne, col++, logsTTEbisDto.getNUMCONT(), doc.getStyleTableau());
			doc.setCellule(rowNouvelleLigne, col++, logsTTEbisDto.getCAV(), doc.getStyleTableau());
			doc.setCellule(rowNouvelleLigne, col++, logsTTEbisDto.getSOCCONT(), doc.getStyleTableau());
			doc.setCellule(rowNouvelleLigne, col++, logsTTEbisDto.getREFERENTIEL(), doc.getStyleTableau());
			doc.setCellule(rowNouvelleLigne, col++, logsTTEbisDto.getPERIMETRE(), doc.getStyleTableau());
			doc.setCellule(rowNouvelleLigne, col++, logsTTEbisDto.getCDATFIN(), doc.getStyleTableau());			
			doc.setCellule(rowNouvelleLigne, col++, logsTTEbisDto.getSYSCPT_RES(), doc.getStyleTableau());
			doc.setCellule(rowNouvelleLigne, col++, logsTTEbisDto.getSYSCPT_CONT(), doc.getStyleTableau());			
			doc.setCellule(rowNouvelleLigne, col++, logsTTEbisDto.getMESSAGE(), doc.getStyleTableau()); 
			doc.setCellule(rowNouvelleLigne, col++, logsTTEbisDto.getCODE_RETOUR() , doc.getStyleTableau());
			doc.setCellule(rowNouvelleLigne, col++, logsTTEbisDto.getDATE_TRAIT(), doc.getStyleTableau());	
			//doc.setCellule(rowNouvelleLigne, col++, logsTTEbisDto.getTIMESTAMP(), doc.getStyleTableau());
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