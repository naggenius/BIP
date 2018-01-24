{ if (index(FILENAME,"BIP.RBIP.BIP")==1) {if (index($0,"A")==1) printf("%sRBIP\n", $0); else if (index($0,"#")==1) printf("%s;RBIP\n", $0);   else printf("%s\n", $0);}   
  else {
  	if (index(FILENAME,"DIVA")==1)    {if (index($0,"A")==1) printf("%sDIVA\n", $0);   else printf("%s\n", $0);}
	else { 
  		if (index(FILENAME,"NIKU")==1)    {if (index($0,"A")==1) printf("%sNIKU\n", $0);   else printf("%s\n", $0);} 
      	else {
			if (index(FILENAME,"GIMS")==1)    {if (index($0,"A")==1) printf("%sGIMS\n", $0);   else printf("%s\n", $0);} 
			else {
				if (index(FILENAME,"OSCAR")==1)   {if (index($0,"A")==1) printf("%sOSCAR\n", $0);  else printf("%s\n", $0);} 
				else {
					{if (index($0,"A")==1) printf("%sAUTRE\n", $0);  else printf("%s\n", $0);}
					}
				}
			}
		}
	}
}