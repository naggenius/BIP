mkdir -p target/generated-packages

echo "Generating PLSQL Packages ..."

for SQL_FILE in $(ls -t plsql/*.sql)
   do
        echo "processing ${SQL_FILE} ..."
                                                      
        echo "" >> target/generated-packages/BIP_PACKAGES-ALL.sql
                                                       
        cat ${SQL_FILE} >> target/generated-packages/BIP_PACKAGES-ALL.sql
                  
   done 