global class MaterialSuccessData implements Database.Batchable<sObject> ,Database.AllowsCallouts, Database.Stateful {
	String fetchSuccessdata = 'SELECT Year__c, Month__c, PO_Date__c, PO_Number__c ,Region__c, Cogs_Country__c, Mainetti_Company__c,  Product_Category__c, Material__c, Grade__c, Color__c, Item_code_local__c, Supplier_Name__c, Supplier_Name1__c, Supplier_Country_2__c, Supplier_Code__c, Supplier_Group__c, Purchase_Terms__c, UOM__c,Freight_cost_to_factory__c, Landed_cost_to_factory__c,  Purchase_Currency__c, Purchase_Unit_Price__c,  exRate_To_USD__c, exRate_To_EUR__c, Expected_Delivery_Date__c, Expected_Delivery_Month__c,Expected_Delivery_Year__c, CreatedById, Upload_Batch_No__c, Purchase_Price__c , QTY__c, Purchase_Price_USD__c, Purchase_Price_EUR__c, Type__c, Product_Description__c, Order_Type__c, 	Product_Unique_ID__c, Local_Supplier_Code__c FROM Material_Transaction_Stage__c WHERE Upload_Batch_No__c=:batchId and Record_Status__c =\'2 - Data Validation Successful\' ';
    String email;
    public String batchId;
    public String userEmail;
    public Boolean insertStatus;    
    public Boolean uploadStatus;
    public String fileName;
    private List<Material_Transaction_Stage__c> materialTransStageForCSV = new List<Material_Transaction_Stage__c>();
    public MaterialSuccessData( String batchId,String userEmail) {
        this.batchId = batchId;
        this.userEmail = userEmail; 
    }
    global Database.querylocator start(Database.BatchableContext bc){
        
			uploadStatus =  createCSVFileAndUploadToAzure(batchId);
        if(uploadStatus)
        {
            Inventory_Transaction_Master__c updateBatchStatus = new Inventory_Transaction_Master__c();
            updateBatchStatus.Id = batchId;
            updateBatchStatus.Batch_Status__c = '7 - Migration In Progress';
            update updateBatchStatus;
            insertStatus = true;
        }     
        else
        {
           fetchSuccessdata = null; 
        }
        return Database.getQueryLocator(fetchSuccessdata);        
    }
    
    global void execute(Database.BatchableContext bc, List<Material_Transaction_Stage__c> transferRecords){ 
        List<Material_upload__c> insertRecord = new List<Material_upload__c>();
        // system.debug('transferRecords :::'+transferRecords);
        if(transferRecords.size() > 0){    
            // -Aki :) Migrating values from Material transaction Stage object to Material Upload        
            for(Material_Transaction_Stage__c materialTransaction: transferRecords){
                Material_upload__c materialUpload = new Material_upload__c();
                materialUpload.Year__c = materialTransaction.Year__c;
                materialUpload.Month__c = materialTransaction.Month__c;
                materialUpload.PO_Date__c = materialTransaction.PO_Date__c;
                materialUpload.PO_Number__c =  materialTransaction.PO_Number__c;
                materialUpload.Region__c = materialTransaction.Region__c;
                materialUpload.Cogs_Country__c = materialTransaction.Cogs_Country__c;
                materialUpload.Mainetti_Company__c = materialTransaction.Mainetti_Company__c;
                materialUpload.Product_Category__c =  materialTransaction.Product_Category__c;
                materialUpload.Material__c = materialTransaction.Material__c;
                materialUpload.Grade__c =  materialTransaction.Grade__c;
                materialUpload.Color__c =  materialTransaction.Color__c;
                materialUpload.Item_code_local__c = materialTransaction.Item_code_local__c;
                materialUpload.Supplier_Name__c =  materialTransaction.Supplier_Name__c;
                materialUpload.Supplier_Name1__c = materialTransaction.Supplier_Name1__c;
                materialUpload.Local_Supplier_Code__c = materialTransaction.Local_Supplier_Code__c;
                materialUpload.Supplier_Country_2__c = materialTransaction.Supplier_Country_2__c;
                materialUpload.Supplier_Code__c = materialTransaction.Supplier_Code__c;
                materialUpload.Supplier_Group__c = materialTransaction.Supplier_Group__c;
                materialUpload.Purchase_Terms__c = materialTransaction.Purchase_Terms__c;
                materialUpload.Freight_cost_to_factory__c =Decimal.valueOf(materialTransaction.Freight_cost_to_factory__c);
                materialUpload.Landed_cost_to_factory__c =Decimal.valueOf(materialTransaction.Landed_cost_to_factory__c);
                materialUpload.UOM__c = materialTransaction.UOM__c;
                materialUpload.QTY__c = Decimal.valueOf(materialTransaction.QTY__c);
                materialUpload.Purchase_Currency__c = materialTransaction.Purchase_Currency__c;
                materialUpload.Purchase_Unit_Price__c = Decimal.valueOf(materialTransaction.Purchase_Unit_Price__c);
                materialUpload.Purchase_Price__c = Decimal.valueOf(materialTransaction.Purchase_Price__c);
                materialUpload.exRate_To_USD__c = Decimal.valueOf(materialTransaction.exRate_To_USD__c);
                materialUpload.exRate_To_EUR__c = Decimal.valueOf(materialTransaction.exRate_To_EUR__c);
                materialUpload.Purchase_Price_USD__c = Decimal.valueOf(materialTransaction.Purchase_Price_USD__c);
                materialUpload.Purchase_Price_EUR__c = Decimal.valueOf(materialTransaction.Purchase_Price_EUR__c);
                materialUpload.Expected_Delivery_Date__c = materialTransaction.Expected_Delivery_Date__c;
                materialUpload.Expected_Delivery_Month__c = materialTransaction.Expected_Delivery_Month__c;
                materialUpload.Expected_Delivery_Year__c = materialTransaction.Expected_Delivery_Year__c;
                materialUpload.OwnerId = materialTransaction.CreatedById;
                materialUpload.Upload_Batch_No__c = materialTransaction.Upload_Batch_No__c;
                materialUpload.Type__c = materialTransaction.Type__c;
                materialUpload.Product_Description__c =  materialTransaction.Product_Description__c;
                materialUpload.Purchase_Price_USD__c = Decimal.valueOf(materialTransaction.Purchase_Price_USD__c);
                materialUpload.Purchase_Price_EUR__c = Decimal.valueOf(materialTransaction.Purchase_Price_EUR__c);
                materialUpload.Order_Type__c = materialTransaction.Order_Type__c;
                materialUpload.Product_Unique_ID__c = materialTransaction.Product_Unique_ID__c;
                insertRecord.add(materialUpload);
                materialUpload = null;
            }
            
            if(insertRecord.size()>0){
                try{
                        //Aki :) Refering to Upload Material Class
                        new UploadMaterial().splitInsertRecordListForUpload(insertRecord);
                        new UploadMaterial().splitListForDelete(transferRecords);
                }catch(DMLException e){   
                    insertStatus = false;
                    // system.debug('Error in insertDataUploadMaterial: during DataUploadMaterial'+e.getMessage());
                }
            }  
        }
        
    }
    global void finish(Database.BatchableContext bc){
        Inventory_Transaction_Master__c updateBatchStatus = new Inventory_Transaction_Master__c();
        // System.debug('finish method');
        updateBatchStatus.Id = batchId;
        updateBatchStatus.Batch_Process__c='Completed';
        // system.debug('insertStatus::::'+insertStatus+'uploadStatus::::'+uploadStatus);
        if(insertStatus && uploadStatus){
            String recCount = getUploadDetails(batchId);
            updateBatchStatus.Total_Row_Count__c = Integer.valueOf(recCount);
            // System.debug('migration success and total count'+ recCount);
            updateBatchStatus.Batch_Status__c = '8 - Migration Success';
            // System.debug('8 - Migration Success');
        }else{
            updateBatchStatus.Batch_Status__c = '9 - Migration Fail';
        }        
        update updateBatchStatus;
        
        Inventory_Transaction_Master__c query = [SELECT Upload_Email_Sent_Status__c, Batch_No__c FROM Inventory_Transaction_Master__c WHERE Id =: batchId WITH SECURITY_ENFORCED LIMIT 1 ];
        query.Upload_Email_Sent_Status__c=true;
        try {
            update query;
            // System.debug('Email Sent Status updated');
        } catch (Exception e) {
            query.Upload_Email_Sent_Status__c=false;
        }
        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
        String[] toAddresses = new String[] {userEmail};
        mail.setToAddresses(toAddresses);
        mail.setSenderDisplayName('Batch Processing');
        mail.setSubject('Material Batch Process Completed , Ref Batch No :'+query.Batch_No__c);
        mail.setPlainTextBody('Hello,\n\n Your Material File Upload process has been completed,\n Please proceed to the application and go to the File Upload Screen & Check the upload Status for next steps.. \n\n Warm Regards \n Admin');
        //Put the total records etc.. in the email body.
        Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });   
        // System.debug('Mail sent');
    }

    global Date getRowDate( string year,string month)
    {
        Map <String, Integer> monthNumber = new Map <String, Integer> {'jan'=>1, 'feb'=>2
            , 'mar'=>3, 'apr'=>4, 'may'=>5, 'jun'=>6, 'jul'=>7, 'aug'=>8, 'sep'=>9
            , 'oct'=>10, 'nov'=>11, 'dec'=>12};
                
                Integer dayStart = Integer.valueOf('01');
        Integer monthStart = monthNumber.get(month.toLowerCase());
        Integer yearStart = Integer.valueOf(year);    
        Date parsedDateStart = Date.newInstance(yearStart,monthStart,dayStart); 
        
        return parsedDateStart;
    }
        
    global  boolean createCSVFileAndUploadToAzure(String batchId){
        // system.debug(' createCSVFileAndUploadToAzure  ::: batchId ::'+batchId);
        boolean fileCreationNUploadToAzure = true;
        
        
        /************************************update the Azure URL **************************************/

            Inventory_Transaction_Master__c transMast = new Inventory_Transaction_Master__c();
            transMast.Id = batchId;
            transMast.Batch_Status__c = '6 - Azure File Upload Successful';
            try{
                update transMast;
            }catch(DMLException ex){
                fileCreationNUploadToAzure = false;
                // System.debug('DML Exception during the 6 - Azure File Upload Successful'+ex.getMessage());
            }                  
        // system.debug('fileCreationNUploadToAzure ::'+fileCreationNUploadToAzure);
        return fileCreationNUploadToAzure;
    }
    
    global String getUploadDetails(String batchId){
        String recCount='';    
        AggregateResult[] groupedResults = [SELECT  Count(Id) recCount FROM Material_upload__c where Upload_Batch_No__c=:batchId WITH SECURITY_ENFORCED ];
        // System.debug(groupedResults);
        // System.debug('Master status count update');
        for (AggregateResult ar : groupedResults)  {
            recCount = String.valueOf(ar.get('recCount'));
        }      
        return recCount;
    }   
}