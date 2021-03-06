package com.socgen.bip.excell;

import java.util.ArrayList;
import java.util.Collection;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Locale;
import java.util.Map;
import java.util.ResourceBundle;

import org.apache.poi.hssf.usermodel.HSSFWorkbook;
import org.apache.poi.ss.usermodel.Cell;
import org.apache.poi.ss.usermodel.CellStyle;
import org.apache.poi.ss.usermodel.Font;
import org.apache.poi.ss.usermodel.IndexedColors;
import org.apache.poi.ss.usermodel.PrintSetup;
import org.apache.poi.ss.usermodel.Row;
import org.apache.poi.ss.usermodel.Sheet;
import org.apache.poi.ss.usermodel.Workbook;
import org.apache.poi.ss.util.CellRangeAddress;
import org.apache.poi.ss.util.CellReference;
import org.apache.struts.action.ActionForm;

import com.socgen.bip.form.AuditImmoForm;
import com.socgen.bip.service.dto.SyntheseImmoDto;

public class FeuilleExcellSyntheseImmoMo  {
	
	private Workbook wb  = new HSSFWorkbook();
	private Sheet sheet;
	private Map<String, CellStyle> styles = createStyles(wb);
	private int compteurAnnee=0;
	int compteurProjet=0;
	int compteurLignes=0;
	int colonnes=0;
	private AuditImmoForm form;

	public FeuilleExcellSyntheseImmoMo(Collection<Collection> listeImmo, ActionForm form, Locale local)
			 {
		
		ResourceBundle myResources = ResourceBundle.getBundle("ApplicationResources", local);
		AuditImmoForm bipForm = (AuditImmoForm) form;
		this.form = bipForm;
		sheet = wb.createSheet(myResources.getString("excell.synthese.stock.immo.feuille"));
		sheet.setDefaultColumnWidth(14);
		PrintSetup printSetup = sheet.getPrintSetup();
		printSetup.setLandscape(true);
		printSetup.setPaperSize(printSetup.A4_PAPERSIZE);
	    sheet.setMargin(sheet.LeftMargin, 0.1);
	    sheet.setMargin(sheet.RightMargin, 0.1);
	    sheet.setHorizontallyCenter(true);
	    creerTitre();
	    for(Collection col:listeImmo){
	    	if(col.size()!=0){
				creerTitreTableau(col);
				creerTableau(col);
				calculSomme();
				compteurLignes += compteurProjet;
				compteurLignes+=7;
				if("DOSSIERPROJET".equals(((AuditImmoForm)form).getIcpi()))
					sheet.setRowBreak(compteurLignes+3);
	    	}
	    }
	}
	

	private void calculSomme() {
			int numLigne=8;
			int numCol=1;
			String plageJH ="";
			String plageEuros ="";
			// KRA PPM 61879
			if("DOSSIERPROJET".equals(form.getIcpi()))
				numCol=4;			
	        else
	        	numCol=1;
			// Fin KRA
			for (int i=0;i<compteurProjet;i++)
			{
				Row row = sheet.getRow(compteurLignes+numLigne+i);
				for (int j=0;j<compteurAnnee*2;j=j+2)
				{
					CellReference CellJH = new CellReference(compteurLignes+i+numLigne,j+numCol);
					plageJH = plageJH+CellJH.formatAsString()+",";
					CellReference CellEuros= new CellReference(compteurLignes+i+numLigne,j+numCol+1);
					plageEuros = plageEuros+CellEuros.formatAsString()+",";
					
				}
				Cell cell = row.createCell(compteurAnnee*2+numCol);
				cell.setCellFormula("sum("+plageJH+")");
				cell.setCellStyle(styles.get("formule"));
				cell = row.createCell(compteurAnnee*2+numCol+1);
				cell.setCellFormula("sum("+plageEuros+")");
				cell.setCellStyle(styles.get("formule"));
				plageJH = "";
				plageEuros = "";
			}
	
			//KRA PPM 61879 : d�but
			Row rowEuros;
			Row rowJH;
			if("DOSSIERPROJET".equals(form.getIcpi()))
	        {
			rowEuros = sheet.getRow(compteurLignes+numLigne+compteurProjet+1);
			rowJH = sheet.getRow(compteurLignes+numLigne+compteurProjet);
			//KRA PPM 61879 
			for(int c=1; c<4;c++){				
				Cell cell = rowEuros.createCell(c);
				cell.setCellStyle(styles.get("formule"));
				cell = rowJH.createCell(c);
				cell.setCellStyle(styles.get("formule"));					
			}
	        }else{
	        	//KRA PPM 61879 : l'existant
	        	rowJH = sheet.getRow(compteurLignes+numLigne+compteurProjet+1);
	        	rowEuros= sheet.getRow(compteurLignes+numLigne+compteurProjet);	
				//Fin de l'existant
	        }
			//Fin KRA
			

			for (int i=0;i<compteurAnnee*2+2;i++)
			{
			
				String plage="";
				CellReference Cell = new CellReference(compteurLignes+numLigne,i+numCol);
				plage = plage+Cell.formatAsString()+":";
				for (int j=1;j<compteurProjet;j++)
				{
					Cell = new CellReference(compteurLignes+j+numLigne,i+numCol);
					
				}
				plage = plage+Cell.formatAsString();
				
				int reste = (i+numCol) % 2;
				Cell cell = rowEuros.createCell(i+numCol);
				cell.setCellStyle(styles.get("formule"));
				cell = rowJH.createCell(i+numCol);
				cell.setCellStyle(styles.get("formule"));
				if (reste != 0)
				{
					Cell cellJH = rowEuros.createCell(i+numCol);
					cellJH.setCellFormula("sum("+plage+")");
					cellJH.setCellStyle(styles.get("formule"));
				}
				else
				{
					Cell cellEuros = rowJH.createCell(i+numCol);
					cellEuros.setCellFormula("sum("+plage+")");
					cellEuros.setCellStyle(styles.get("formule"));
				}
			}
	}

	private void creerTitreTableau(Collection listeImmo) {
		Iterator itListe = ((List) listeImmo).iterator();
		int numCol = 1;
		String tmpAnnee="";
		Row enteteTabRow0 = sheet.createRow(5+compteurLignes);
		Row enteteTabRow = sheet.createRow(6+compteurLignes);
		Row enteteTabRow2 = sheet.createRow(7+compteurLignes);
		int numLigne = 6+compteurLignes;
		Collection syntheseResult = new ArrayList();
		compteurAnnee=0;
		
		// KRA PPM 61879 : debut
		if("DOSSIERPROJET".equals(form.getIcpi()))
        {
			numCol = 0;
			/*
			//Cell EnteteCell = enteteTabRow.createCell(numCol);
			//EnteteCell.setCellValue("ProjCode");
			//EnteteCell.setCellStyle(styles.get("TitreTabProj"));		
			Cell EnteteCell2 = enteteTabRow2.createCell(numCol);
			EnteteCell2.setCellValue("ProjCode");
			EnteteCell2.setCellStyle(styles.get("TitreTabProj"));
			//CellRangeAddress reg=new CellRangeAddress(numLigne,numLigne+1,numCol,numCol);
			//sheet.addMergedRegion(reg);		
			numCol++;		
			
			Cell EnteteCell = enteteTabRow.createCell(numCol);
			EnteteCell.setCellValue("ProjLib");
			EnteteCell.setCellStyle(styles.get("TitreTabProj"));
			EnteteCell2 = enteteTabRow2.createCell(numCol);
			EnteteCell2.setCellStyle(styles.get("TitreTabProj"));
			CellRangeAddress reg=new CellRangeAddress(numLigne,numLigne+1,numCol,numCol);
			sheet.addMergedRegion(reg);
			numCol++;
			*/
					
						
			Cell EnteteCell = enteteTabRow.createCell(numCol);
			EnteteCell.setCellValue("ProjCode");
			EnteteCell.setCellStyle(styles.get("TitreTabProj"));			
			Cell EnteteCell2 = enteteTabRow2.createCell(numCol);		
			EnteteCell2.setCellStyle(styles.get("TitreTabProj"));
			CellRangeAddress reg=new CellRangeAddress(numLigne,numLigne+1,numCol,numCol);
			sheet.addMergedRegion(reg);
			numCol++;
			
			/*sheet.setColumnWidth(numCol, (short)(28*256)); //(short)1,(short)(128*256)
			Row enteteTabRowLib = sheet.createRow(6+compteurLignes);				
			Cell EnteteCellLib = enteteTabRowLib.createCell(numCol);
			EnteteCellLib.setCellValue("ProjLib");
			EnteteCellLib.setCellStyle(styles.get("TitreTabProj"));*/
			EnteteCell = enteteTabRow.createCell(numCol);
			EnteteCell.setCellValue("ProjLib");
			EnteteCell.setCellStyle(styles.get("TitreTabProj"));
			sheet.setColumnWidth(numCol, (short)(50*256));
			
			EnteteCell2 = enteteTabRow2.createCell(numCol);
			EnteteCell2.setCellStyle(styles.get("TitreTabProj"));
			reg=new CellRangeAddress(numLigne,numLigne+1,numCol,numCol);
			sheet.addMergedRegion(reg);
			numCol++;
			
			EnteteCell = enteteTabRow.createCell(numCol);
			EnteteCell.setCellValue("ProjStatutCode");
			EnteteCell.setCellStyle(styles.get("TitreTabProj"));
			EnteteCell2 = enteteTabRow2.createCell(numCol);
			EnteteCell2.setCellStyle(styles.get("TitreTabProj"));
			reg=new CellRangeAddress(numLigne,numLigne+1,numCol,numCol);
			sheet.addMergedRegion(reg);
			numCol++;
			
			EnteteCell = enteteTabRow.createCell(numCol);
			EnteteCell.setCellValue("ProjStatutDateVal");
			EnteteCell.setCellStyle(styles.get("TitreTabProj"));
			EnteteCell2 = enteteTabRow2.createCell(numCol);
			EnteteCell2.setCellStyle(styles.get("TitreTabProj"));
			reg=new CellRangeAddress(numLigne,numLigne+1,numCol,numCol);
			sheet.addMergedRegion(reg);
			numCol++;
        }
		//Fin KRA
		
		while (itListe.hasNext())
		{
			
			SyntheseImmoDto syntheseImmoDto = (SyntheseImmoDto) itListe.next();
			
			if (!tmpAnnee.equals(syntheseImmoDto.getAnnee()) && (!syntheseResult.contains(syntheseImmoDto.getAnnee())))
			{
				// KRA PPM 61879 : debut
				Cell EnteteCell;
				if("DOSSIERPROJET".equals(form.getIcpi()))
		        {
				EnteteCell = enteteTabRow0.createCell(0);//KRA PPM 61879 : new ligne en haut
		        }else
		        {
		        EnteteCell = enteteTabRow.createCell(0);//KRA PPM 61879 : existant
			    }
				//Fin KRA
				EnteteCell.setCellValue(syntheseImmoDto.getComposant());
				EnteteCell.setCellStyle(styles.get("TitreTableau"));
				
				EnteteCell = enteteTabRow.createCell(numCol);
				EnteteCell.setCellValue(syntheseImmoDto.getAnnee());
				EnteteCell.setCellStyle(styles.get("TitreTableau"));
				EnteteCell = enteteTabRow.createCell(numCol+1);
				EnteteCell.setCellStyle(styles.get("TitreTableau"));
				Cell EnteteJH = enteteTabRow2.createCell(numCol);
				EnteteJH.setCellValue("JH");
				EnteteJH.setCellStyle(styles.get("TitreTableau"));
				Cell EnteteEuros = enteteTabRow2.createCell(numCol+1);
				EnteteEuros.setCellValue("�");
				EnteteEuros.setCellStyle(styles.get("TitreTableau"));
				CellRangeAddress reg=new CellRangeAddress(6+compteurLignes,6+compteurLignes,numCol,numCol+1);
				sheet.addMergedRegion(reg);
				numCol=numCol+2;
				compteurAnnee++;
				
				
			}
			syntheseResult.add(tmpAnnee);	
			tmpAnnee = syntheseImmoDto.getAnnee();
		}
		Cell EnteteCell = enteteTabRow.createCell(numCol);
		EnteteCell.setCellValue("Totaux");
		EnteteCell.setCellStyle(styles.get("TitreTableau"));
		EnteteCell = enteteTabRow.createCell(numCol+1);
		EnteteCell.setCellStyle(styles.get("TitreTableau"));
		CellRangeAddress reg=new CellRangeAddress(6+compteurLignes,6+compteurLignes,numCol,numCol+1);
		EnteteCell.setCellStyle(styles.get("TitreTableau"));
		sheet.addMergedRegion(reg);
		Cell EnteteJH = enteteTabRow2.createCell(numCol);
		EnteteJH.setCellValue("JH");
		EnteteJH.setCellStyle(styles.get("TitreTableau"));
		Cell EnteteEuros = enteteTabRow2.createCell(numCol+1);
		EnteteEuros.setCellValue("�");
		EnteteEuros.setCellStyle(styles.get("TitreTableau"));
		colonnes = numCol+2;
			
	}
	
	private void creerTableau(Collection listeImmo) {
		Iterator itListe = ((List) listeImmo).iterator();
		int numCol = 0;
		int numLigne = 7;
		String tmpProjet="";
		compteurProjet=0;
		Row TabRow = null;
		while (itListe.hasNext())
		{
			SyntheseImmoDto syntheseImmoDto = (SyntheseImmoDto) itListe.next();
			if (!tmpProjet.equals(syntheseImmoDto.getIcpi()))
			{
				numLigne++;
				TabRow = sheet.createRow(compteurLignes+numLigne);
				setCellule(TabRow, numCol = 0, syntheseImmoDto.getIcpi(), "titreProjet");
				numCol++;
				compteurProjet++;
				
				//KRA PPM 61879 : debut 
				if("DOSSIERPROJET".equals(form.getIcpi()))
		        {
					setCellule(TabRow, numCol++, syntheseImmoDto.getIlibel(), "titreProjet");
					setCellule(TabRow, numCol++, syntheseImmoDto.getStatut(), "titreProjet");
					setCellule(TabRow, numCol++, syntheseImmoDto.getDatstatut(), "titreProjet");
		        }
				//KRA PPM 61879 : fin 				
			}
			
			setCellule(TabRow, numCol++, syntheseImmoDto.getJh());
			setCellule(TabRow, numCol++, syntheseImmoDto.getEuros());
			tmpProjet= syntheseImmoDto.getIcpi();
			
		}
		numLigne++;
		TabRow = sheet.createRow(compteurLignes+numLigne++);
		setCellule(TabRow, numCol = 0, "JH", "TitreTableau");
		TabRow = sheet.createRow(compteurLignes+numLigne);
		setCellule(TabRow, numCol = 0, "Euros", "TitreTableau");
	}

	private void creerTitre()
	{
		Row titleRow = sheet.createRow(0);
        titleRow.setHeightInPoints(45);
        Cell titleCell = titleRow.createCell(0);
        titleCell.setCellValue("Synth�se des flux immobilisations");
        titleCell.setCellStyle(styles.get("title"));
        sheet.addMergedRegion(CellRangeAddress.valueOf("$A$1:$L$1"));
        
		//KRA PPM 61879 : debut 
        int numCol;
		if("DOSSIERPROJET".equals(form.getIcpi())) 
			numCol = 4;
		else 
			numCol = 1;
		//Fin KRA PPM 61879
        
        titleRow = sheet.createRow(1);
        titleRow.setHeightInPoints(18);
        titleCell = titleRow.createCell(numCol);//KRA PPM 61879 : 1       
        
      
        Cell valCell = titleRow.createCell(numCol+3);//4
        if("PROJET".equals(form.getIcpi())){
       	 	titleCell.setCellValue("Projet :");
       	 	valCell.setCellValue("Les projets de votre p�rim�tre client");
       	 	//KRA PPM 61879 : debut
            titleCell.setCellStyle(styles.get("title2"));
            sheet.addMergedRegion(CellRangeAddress.valueOf("$B$2:$D$2"));
            valCell.setCellStyle(styles.get("ValeurFont"));
            
            titleRow = sheet.createRow(2);
            titleRow.setHeightInPoints(18);
            titleCell = titleRow.createCell(numCol);//1
            titleCell.setCellValue("Dernier traitement mensuel :");
            titleCell.setCellStyle(styles.get("title2"));
            sheet.addMergedRegion(CellRangeAddress.valueOf("$B$3:$D$3"));
            valCell = titleRow.createCell(numCol+3);//4
            valCell.setCellValue(form.getMoismens());
            valCell.setCellStyle(styles.get("ValeurFont"));
          //KRA PPM 61879 : Fin
            
        }else if("DOSSIERPROJET".equals(form.getIcpi())){
       	 	titleCell.setCellValue("Dossier Projet :");
       	 	valCell.setCellValue("Les dossiers projet de votre p�rim�tre client");
       	//KRA PPM 61879 : debut
            titleCell.setCellStyle(styles.get("title2"));
            sheet.addMergedRegion(CellRangeAddress.valueOf("$E$2:$G$2"));//"$B$2:$D$2"
            valCell.setCellStyle(styles.get("ValeurFont"));
            
            titleRow = sheet.createRow(2);
            titleRow.setHeightInPoints(18);
            titleCell = titleRow.createCell(numCol);//1
            titleCell.setCellValue("Dernier traitement mensuel :");
            titleCell.setCellStyle(styles.get("title2"));
            sheet.addMergedRegion(CellRangeAddress.valueOf("$E$3:$G$3"));//"$B$3:$D$3"
            valCell = titleRow.createCell(numCol+3);//4
            valCell.setCellValue(form.getMoismens());
            valCell.setCellStyle(styles.get("ValeurFont"));
          //KRA PPM 61879 : Fin
        }

        
		Row row = sheet.createRow(4);
		Cell cell = row.createCell(numCol);//1
		cell.setCellValue("Edit� le : ");
		cell = row.createCell(numCol+1);//2
		cell.setCellFormula("today()");
		cell.setCellStyle(styles.get("Date"));     
        
	}
		


	/**
	 * M�thode permettant de retourner le flux Excell g�n�rer
	 * @return wb
	 */
	public Workbook getWb() {
		return this.wb;
	}
	
	
	
    private Map<String, CellStyle> createStyles(Workbook wb){
        Map<String, CellStyle> styles = new HashMap<String, CellStyle>();
        CellStyle style;
        Font titleFont = wb.createFont();
        titleFont.setFontHeightInPoints((short)18);
        titleFont.setBoldweight(Font.BOLDWEIGHT_BOLD);
        style = wb.createCellStyle();
        style.setAlignment(CellStyle.ALIGN_CENTER);
        style.setVerticalAlignment(CellStyle.VERTICAL_CENTER);
        style.setFont(titleFont);
        styles.put("title", style);
        
        Font titleFont2 = wb.createFont();
        titleFont2.setFontHeightInPoints((short)14);
        style = wb.createCellStyle();
        style.setAlignment(CellStyle.ALIGN_LEFT);
        style.setVerticalAlignment(CellStyle.VERTICAL_CENTER);
        style.setFont(titleFont2);
        styles.put("title2", style);
        
        style = wb.createCellStyle();
        style.setDataFormat(wb.createDataFormat().getFormat("dd/mm/yy"));
        style.setAlignment(CellStyle.ALIGN_LEFT);
        style.setVerticalAlignment(CellStyle.VERTICAL_CENTER);
        styles.put("Date", style);
        
        Font ValeurFont = wb.createFont();
        ValeurFont.setFontHeightInPoints((short)12);
        ValeurFont.setColor(IndexedColors.BLUE.getIndex());
        style = wb.createCellStyle();
        style.setAlignment(CellStyle.ALIGN_LEFT);
        style.setVerticalAlignment(CellStyle.VERTICAL_CENTER);
        style.setFont(ValeurFont);
        styles.put("ValeurFont", style);
        
        //KRA PPM 61879 : debut
        Font TitreTabProj = wb.createFont();
        TitreTabProj.setFontHeightInPoints((short)10);
        TitreTabProj.setBoldweight(Font.BOLDWEIGHT_BOLD);
        TitreTabProj.setColor(IndexedColors.BLACK.getIndex());
        style = wb.createCellStyle();
        style.setAlignment(CellStyle.ALIGN_LEFT);
        style.setFillForegroundColor(IndexedColors.GREY_25_PERCENT.getIndex());
        style.setFillPattern(CellStyle.SOLID_FOREGROUND);
        style.setVerticalAlignment(CellStyle.VERTICAL_CENTER);
        style.setBorderRight(CellStyle.BORDER_THIN);
        style.setRightBorderColor(IndexedColors.BLACK.getIndex());
        style.setBorderLeft(CellStyle.BORDER_THIN);
        style.setLeftBorderColor(IndexedColors.BLACK.getIndex());
        style.setBorderTop(CellStyle.BORDER_THIN);
        style.setTopBorderColor(IndexedColors.BLACK.getIndex());
        style.setBorderBottom(CellStyle.BORDER_THIN);
        style.setBottomBorderColor(IndexedColors.BLACK.getIndex());
        style.setFont(TitreTabProj);
        styles.put("TitreTabProj", style);
        //Fin KRA
        
        Font TitreTableau = wb.createFont();
        TitreTableau.setFontHeightInPoints((short)10);
        TitreTableau.setBoldweight(Font.BOLDWEIGHT_BOLD);
        TitreTableau.setColor(IndexedColors.BLACK.getIndex());
        style = wb.createCellStyle();
        style.setAlignment(CellStyle.ALIGN_CENTER);
        style.setFillForegroundColor(IndexedColors.GREY_25_PERCENT.getIndex());
        style.setFillPattern(CellStyle.SOLID_FOREGROUND);
        style.setVerticalAlignment(CellStyle.VERTICAL_CENTER);
        style.setBorderRight(CellStyle.BORDER_THIN);
        style.setRightBorderColor(IndexedColors.BLACK.getIndex());
        style.setBorderLeft(CellStyle.BORDER_THIN);
        style.setLeftBorderColor(IndexedColors.BLACK.getIndex());
        style.setBorderTop(CellStyle.BORDER_THIN);
        style.setTopBorderColor(IndexedColors.BLACK.getIndex());
        style.setBorderBottom(CellStyle.BORDER_THIN);
        style.setBottomBorderColor(IndexedColors.BLACK.getIndex());
        style.setFont(TitreTableau);
        styles.put("TitreTableau", style);
      
        style = wb.createCellStyle();
        style.setAlignment(CellStyle.ALIGN_RIGHT);
        style.setVerticalAlignment(CellStyle.VERTICAL_CENTER);
        style.setDataFormat(wb.createDataFormat().getFormat("#,##0.00"));
        style.setBorderRight(CellStyle.BORDER_THIN);
        style.setRightBorderColor(IndexedColors.BLACK.getIndex());
        style.setBorderLeft(CellStyle.BORDER_THIN);
        style.setLeftBorderColor(IndexedColors.BLACK.getIndex());
        style.setBorderTop(CellStyle.BORDER_THIN);
        style.setTopBorderColor(IndexedColors.BLACK.getIndex());
        style.setBorderBottom(CellStyle.BORDER_THIN);
        style.setBottomBorderColor(IndexedColors.BLACK.getIndex());
        styles.put("valeurCell", style);
        
        style = wb.createCellStyle();
        style.setAlignment(CellStyle.ALIGN_LEFT);
        style.setVerticalAlignment(CellStyle.VERTICAL_CENTER);
        style.setBorderRight(CellStyle.BORDER_THIN);
        style.setRightBorderColor(IndexedColors.BLACK.getIndex());
        style.setBorderLeft(CellStyle.BORDER_THIN);
        style.setLeftBorderColor(IndexedColors.BLACK.getIndex());
        style.setBorderTop(CellStyle.BORDER_THIN);
        style.setTopBorderColor(IndexedColors.BLACK.getIndex());
        style.setBorderBottom(CellStyle.BORDER_THIN);
        style.setBottomBorderColor(IndexedColors.BLACK.getIndex());
        styles.put("titreProjet", style);

        Font Formule = wb.createFont();
        Formule.setFontHeightInPoints((short)10);
        Formule.setBoldweight(Font.BOLDWEIGHT_BOLD);
        style = wb.createCellStyle();
        style.setAlignment(CellStyle.ALIGN_RIGHT);
        style.setVerticalAlignment(CellStyle.VERTICAL_CENTER);
        style.setFillForegroundColor(IndexedColors.GREY_25_PERCENT.getIndex());
        style.setFillPattern(CellStyle.SOLID_FOREGROUND);
        style.setDataFormat(wb.createDataFormat().getFormat("#,##0.00"));
        style.setBorderRight(CellStyle.BORDER_THIN);
        style.setRightBorderColor(IndexedColors.BLACK.getIndex());
        style.setBorderLeft(CellStyle.BORDER_THIN);
        style.setLeftBorderColor(IndexedColors.BLACK.getIndex());
        style.setBorderTop(CellStyle.BORDER_THIN);
        style.setTopBorderColor(IndexedColors.BLACK.getIndex());
        style.setBorderBottom(CellStyle.BORDER_THIN);
        style.setBottomBorderColor(IndexedColors.BLACK.getIndex());
        style.setFont(Formule);
        styles.put("formule", style);

        return styles;
    }
	
    public void setCellule(Row row, int colonne, double value) {
		Cell cell = row.createCell(colonne);
		cell.setCellValue(value);
		cell.setCellStyle(styles.get("valeurCell"));
		
	
	}
    
    public void setCellule(Row row, int colonne, String value, String style) {
		Cell cell = row.createCell(colonne);
		cell.setCellValue(value);
		cell.setCellStyle(styles.get(style));
	
	}

}