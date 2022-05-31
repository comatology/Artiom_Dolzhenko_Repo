aws dynamodb create-table --table-name artiom_dolzhenko_playlist --attribute-definitions AttributeName=Artist,AttributeType=S AttributeName=Song,AttributeType=S --key-schema AttributeName=Artist,KeyType=HASH AttributeName=Song,KeyType=RANGE  --provisioned-throughput ReadCapacityUnits=5,WriteCapacityUnits=5 --region eu-central-1 --profile=epam_lab_mfa
#############################################
###############show list of tables###########
#############################################
aws dynamodb list-tables  --region eu-central-1 --profile=epam_lab_mfa



#############################################
################add items####################
#############################################
aws dynamodb put-item  --table-name artiom_dolzhenko_playlist --item file://C:\Users\Artiom_Dolzhenko\TABLES_FOR_AWS\json\item1.json --return-consumed-capacity TOTAL --region eu-central-1 --profile=epam_lab_mfa
aws dynamodb put-item  --table-name artiom_dolzhenko_playlist --item file://C:\Users\Artiom_Dolzhenko\TABLES_FOR_AWS\json\item2.json --return-consumed-capacity TOTAL --region eu-central-1 --profile=epam_lab_mfa
aws dynamodb put-item  --table-name artiom_dolzhenko_playlist --item file://C:\Users\Artiom_Dolzhenko\TABLES_FOR_AWS\json\item3.json --return-consumed-capacity TOTAL --region eu-central-1 --profile=epam_lab_mfa
aws dynamodb put-item  --table-name artiom_dolzhenko_playlist --item file://C:\Users\Artiom_Dolzhenko\TABLES_FOR_AWS\json\item4.json --return-consumed-capacity TOTAL --region eu-central-1 --profile=epam_lab_mfa
aws dynamodb put-item  --table-name artiom_dolzhenko_playlist --item file://C:\Users\Artiom_Dolzhenko\TABLES_FOR_AWS\json\item5.json --return-consumed-capacity TOTAL --region eu-central-1 --profile=epam_lab_mfa
aws dynamodb put-item  --table-name artiom_dolzhenko_playlist --item file://C:\Users\Artiom_Dolzhenko\TABLES_FOR_AWS\json\item6.json --return-consumed-capacity TOTAL --region eu-central-1 --profile=epam_lab_mfa
aws dynamodb put-item  --table-name artiom_dolzhenko_playlist --item file://C:\Users\Artiom_Dolzhenko\TABLES_FOR_AWS\json\item7.json --return-consumed-capacity TOTAL --region eu-central-1 --profile=epam_lab_mfa
aws dynamodb put-item  --table-name artiom_dolzhenko_playlist --item file://C:\Users\Artiom_Dolzhenko\TABLES_FOR_AWS\json\item8.json --return-consumed-capacity TOTAL --region eu-central-1 --profile=epam_lab_mfa
aws dynamodb put-item  --table-name artiom_dolzhenko_playlist --item file://C:\Users\Artiom_Dolzhenko\TABLES_FOR_AWS\json\item9.json --return-consumed-capacity TOTAL --region eu-central-1 --profile=epam_lab_mfa
aws dynamodb put-item  --table-name artiom_dolzhenko_playlist --item file://C:\Users\Artiom_Dolzhenko\TABLES_FOR_AWS\json\item10.json --return-consumed-capacity TOTAL --region eu-central-1 --profile=epam_lab_mfa
aws dynamodb put-item  --table-name artiom_dolzhenko_playlist --item file://C:\Users\Artiom_Dolzhenko\TABLES_FOR_AWS\json\item11.json --return-consumed-capacity TOTAL --region eu-central-1 --profile=epam_lab_mfa
aws dynamodb put-item  --table-name artiom_dolzhenko_playlist --item file://C:\Users\Artiom_Dolzhenko\TABLES_FOR_AWS\json\item12.json --return-consumed-capacity TOTAL --region eu-central-1 --profile=epam_lab_mfa
aws dynamodb put-item  --table-name artiom_dolzhenko_playlist --item file://C:\Users\Artiom_Dolzhenko\TABLES_FOR_AWS\json\item13.json --return-consumed-capacity TOTAL --region eu-central-1 --profile=epam_lab_mfa
aws dynamodb put-item  --table-name artiom_dolzhenko_playlist --item file://C:\Users\Artiom_Dolzhenko\TABLES_FOR_AWS\json\item14.json --return-consumed-capacity TOTAL --region eu-central-1 --profile=epam_lab_mfa
aws dynamodb put-item  --table-name artiom_dolzhenko_playlist --item file://C:\Users\Artiom_Dolzhenko\TABLES_FOR_AWS\json\item15.json --return-consumed-capacity TOTAL --region eu-central-1 --profile=epam_lab_mfa
aws dynamodb put-item  --table-name artiom_dolzhenko_playlist --item file://C:\Users\Artiom_Dolzhenko\TABLES_FOR_AWS\json\item16.json --return-consumed-capacity TOTAL --region eu-central-1 --profile=epam_lab_mfa
aws dynamodb put-item  --table-name artiom_dolzhenko_playlist --item file://C:\Users\Artiom_Dolzhenko\TABLES_FOR_AWS\json\item17.json --return-consumed-capacity TOTAL --region eu-central-1 --profile=epam_lab_mfa
aws dynamodb put-item  --table-name artiom_dolzhenko_playlist --item file://C:\Users\Artiom_Dolzhenko\TABLES_FOR_AWS\json\item18.json --return-consumed-capacity TOTAL --region eu-central-1 --profile=epam_lab_mfa
aws dynamodb put-item  --table-name artiom_dolzhenko_playlist --item file://C:\Users\Artiom_Dolzhenko\TABLES_FOR_AWS\json\item19.json --return-consumed-capacity TOTAL --region eu-central-1 --profile=epam_lab_mfa
aws dynamodb put-item  --table-name artiom_dolzhenko_playlist --item file://C:\Users\Artiom_Dolzhenko\TABLES_FOR_AWS\json\item20.json --return-consumed-capacity TOTAL --region eu-central-1 --profile=epam_lab_mfa
aws dynamodb put-item  --table-name artiom_dolzhenko_playlist --item file://C:\Users\Artiom_Dolzhenko\TABLES_FOR_AWS\json\item21.json --return-consumed-capacity TOTAL --region eu-central-1 --profile=epam_lab_mfa
aws dynamodb put-item  --table-name artiom_dolzhenko_playlist --item file://C:\Users\Artiom_Dolzhenko\TABLES_FOR_AWS\json\item22.json --return-consumed-capacity TOTAL --region eu-central-1 --profile=epam_lab_mfa
aws dynamodb put-item  --table-name artiom_dolzhenko_playlist --item file://C:\Users\Artiom_Dolzhenko\TABLES_FOR_AWS\json\item23.json --return-consumed-capacity TOTAL --region eu-central-1 --profile=epam_lab_mfa


#############################################
##Retrieve 5 rows from the table using keys##
############################################# 
aws dynamodb get-item --table-name artiom_dolzhenko_playlist --key file://C:\Users\Artiom_Dolzhenko\TABLES_FOR_AWS\json\key1.json --region eu-central-1 --profile=epam_lab_mfa
aws dynamodb get-item --table-name artiom_dolzhenko_playlist --key file://C:\Users\Artiom_Dolzhenko\TABLES_FOR_AWS\json\key2.json --region eu-central-1 --profile=epam_lab_mfa
aws dynamodb get-item --table-name artiom_dolzhenko_playlist --key file://C:\Users\Artiom_Dolzhenko\TABLES_FOR_AWS\json\key3.json --region eu-central-1 --profile=epam_lab_mfa
aws dynamodb get-item --table-name artiom_dolzhenko_playlist --key file://C:\Users\Artiom_Dolzhenko\TABLES_FOR_AWS\json\key4.json --region eu-central-1 --profile=epam_lab_mfa
aws dynamodb get-item --table-name artiom_dolzhenko_playlist --key file://C:\Users\Artiom_Dolzhenko\TABLES_FOR_AWS\json\key5.json --region eu-central-1 --profile=epam_lab_mfa


##############################################
##############selects#########################
##############################################
aws dynamodb query --table-name artiom_dolzhenko_playlist --key-condition-expression "Artist = :a" --expression-attribute-values "{\":a\": {\"S\": \"Wu tang clan\"}}" --region eu-central-1 --profile=epam_lab_mfa
aws dynamodb query --table-name artiom_dolzhenko_playlist --key-condition-expression "Artist = :a and Song = :s" --expression-attribute-values "{\":a\": {\"S\": \"Wu tang clan\"}, \":s\": {\"S\": \"Iron nattle\"}}" --region eu-central-1 --profile=epam_lab_mfa


############################################## 
#############delete 2 rows####################
##############################################
aws dynamodb delete-item --table-name artiom_dolzhenko_playlist --key file://C:\Users\Artiom_Dolzhenko\TABLES_FOR_AWS\json\key1.json --region eu-central-1 --profile=epam_lab_mfa
aws dynamodb delete-item --table-name artiom_dolzhenko_playlist --key file://C:\Users\Artiom_Dolzhenko\TABLES_FOR_AWS\json\key2.json --region eu-central-1 --profile=epam_lab_mfa
