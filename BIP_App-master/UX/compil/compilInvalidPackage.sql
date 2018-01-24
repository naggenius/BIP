declare
	   cursor inv_obj is 
	   		  select distinct 'alter ' || decode(object_type, 'PACKAGE BODY', 'PACKAGE', object_type) || ' ' || object_name || ' compile' commande,
			  		 object_name obj_nom
			    from obj 
			   where status='INVALID';
	   l_commande varchar2(500);
	   l_obj_nom  obj.OBJECT_NAME%type;
	   num_obj_inv number;
	   old_num_obj_inv number;
	   max_iter number;
	   cur integer;
	   rc  integer;
	   l_obj_err varchar2(1000);
begin
    DBMS_OUTPUT.enable(500000);
	max_iter:=0;
	select count(*) into num_obj_inv from vue_invalid;
	old_num_obj_inv := num_obj_inv;
	
	loop
	
		open inv_obj;
		loop
			fetch inv_obj into l_commande, l_obj_nom;
			
			if (inv_obj%notfound) then
			   exit;
			end if;
			
			DBMS_OUTPUT.put_line(l_commande);
			
			BEGIN
				EXECUTE IMMEDIATE l_commande;
				DBMS_OUTPUT.put_line('............... succès');
			EXCEPTION
			    WHEN OTHERS then
					DBMS_OUTPUT.put_line('...ERREUR de compilation');
					DBMS_OUTPUT.put_line('');
					if (length(l_obj_err)>0) then
					    l_obj_err := l_obj_err||', ';
					end if;  
				    l_obj_err := l_obj_err||l_obj_nom;
			END;
/*			cur := DBMS_SQL.OPEN_CURSOR;
			DBMS_SQL.PARSE(cur, l_commande, DBMS_SQL.NATIVE);
			rc := DBMS_SQL.EXECUTE(cur);
			DBMS_SQL.CLOSE_CURSOR(cur);*/
	  
		end loop;
		
		select count(*) into num_obj_inv from vue_invalid;
		
		if ( (num_obj_inv=0) or ( old_num_obj_inv = num_obj_inv) ) then
		   exit;
		end if;

		old_num_obj_inv := num_obj_inv;
		max_iter := max_iter + 1;
		
		close inv_obj;
		
		if (max_iter>=10) then
			DBMS_OUTPUT.put_line('');
			DBMS_OUTPUT.put_line('Nb max d''iteration dans la boucle atteint :'||max_iter);
			exit;
		end if;
		
	end loop;
	
	DBMS_OUTPUT.put_line('');
	DBMS_OUTPUT.put_line('Objets provoquant des erreurs à la compilation : '||l_obj_err);
	DBMS_OUTPUT.put_line('');

/*DBMS_UTILITY.compile_schema('BIP');*/
end;
/

