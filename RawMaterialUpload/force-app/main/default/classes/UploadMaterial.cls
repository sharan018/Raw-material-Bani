public with sharing class UploadMaterial {

    // Called from aura for getting picklist values of Year acs
    @AuraEnabled
    public static List<integer> getPreviousYear() {
        // System.debug('$- Upload Material > getPreviousYear');
        List<integer> prevYear = new List<integer>();
        Integer currentYear = System.Today().year();
        prevYear.add(currentYear);
        prevYear.add(currentYear-1);
        return prevYear;        
    }
    //AKI :) Called from aura for getting picklist values for company acs
    @AuraEnabled 
    public static map<string,string> getMaterialCompanyList()
    {      
        Map<string,string> materialCompMap = new Map<string,string>();      
        Schema.DescribeFieldResult fieldResult = Partner__c.Sales_Data_Company__c.getDescribe();
        List<Schema.PicklistEntry> pList = fieldResult.getPicklistValues();
        for (Schema.PicklistEntry p: pList) {
            materialCompMap.put(p.getValue(), p.getLabel());
        }
        return materialCompMap;
    }

    //Used to get pick list values for filter by batch status acs  
    @AuraEnabled 
    public static List<String> getBatchStatusList()
    {      
        List<String> pickListValuesList= new List<String>();
        Schema.DescribeFieldResult fieldResult = Inventory_Transaction_Master__c.Batch_Status__c.getDescribe();
        List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
        for( Schema.PicklistEntry pickListVal : ple){
            pickListValuesList.add(pickListVal.getLabel());
        }     
        return pickListValuesList;
    }


    // Get Inventory Transaction master Data to display in table
    @AuraEnabled
    public static List<Inventory_Transaction_Master__c> getMaterialData(){
        // Integer currentYear = System.Today().year();
        string searchQuery = 'SELECT Id, upload_file_name__c,Upload_Converted_File_Name__c, Batch_No__c, Reprocessing__c,Batch_Status__c, File_Uploaded_By__c, Record_Type__c,Azure_File_Link__c,Mainetti_Company__c,Total_Row_Count__c,Uploaded_Total_Stock_In_Qty__c,company_week__c,Sales_Company__c,Sales_Month__c,Sales_Market__c,Sales_Year__c,Batch_Process__c,CreatedDate,Void__c,Void_Reason__c FROM Inventory_Transaction_Master__c'; 
        
        string itsMaterial = 'Material';
        searchQuery += ' where Record_Type__c =: itsMaterial';
        //searchQuery += ' order by CreatedDate desc LIMIT 80';
        searchQuery += ' order by LASTMODIFIEDDATE desc LIMIT 80'; //edited by tony from CreatedDate To LASTMODIFIEDDATE 20220518
        List<Inventory_Transaction_Master__c> fetchdata= Database.query(searchQuery);
        return fetchdata;
    }  

    //Checks if data is already submitted for the selected company, year and month on upload
    @AuraEnabled
    public static String errordataSubmitted(string companyArray, string selmonth, string selyear)
    {
        List<string> companyList = companyArray.split(',');
        Set<String> companyName = new Set<String>();
        for (string valFormt : companyList){
            if(string.isNotBlank(valFormt)){
                companyName.add(valFormt);
            }
        }   
        String recordType = 'Material';
        List<Inventory_Transaction_Master__c> fetchData = [SELECT Sales_Company__c,Sales_Month__c,Sales_Year__c,Batch_Status__c FROM  Inventory_Transaction_Master__c WHERE Sales_Company__c =:companyArray and Sales_Month__c =: selmonth AND Sales_Year__c =: selyear AND Record_Type__c=:recordType WITH SECURITY_ENFORCED ORDER BY CreatedDate desc LIMIT 1];
        String batchStatus = '';
        // System.debug(companyArray+'#+#'+selmonth+'#+#'+selyear);
        // System.debug(fetchData);
        for (Inventory_Transaction_Master__c transMast : fetchData){
            batchStatus = transMast.Batch_Status__c;
            // system.debug('batchStatus::::'+batchStatus);
        }   
        // Integer fetchdataSize = fetchData.size();
        // system.debug('fetchdataSize::::'+fetchdataSize);
        return batchStatus;        
    }

     @AuraEnabled
    public static Integer dataSubmitted(string companyArray, string selmonth, string selyear)
    {
        List<string> companyList = companyArray.split(',');
        Set<String> companyName = new Set<String>(); 
        for (string valFormt : companyList){
            if(string.isNotBlank(valFormt)){
                companyName.add(valFormt);
                // system.debug('companyList'+companyList);
                // system.debug('companyName'+companyName);
            }
        }   
        List<Material_upload__c> fetchData = new List<Material_upload__c> ();
        // system.debug('fetchData'+fetchData);
        Integer fetchdataSize = fetchData.size();
        return fetchdataSize;        
    }

    //Create Inventory Trtansaction master record for the process and return the Batch Id 
    // Insert records into material Trasnsactionn Stage
    @AuraEnabled
    public static String insertBulkMaterial(string jsonin, string batchNo,string recordType, string selMonth, string selYear, string selComp,string isreupload,String chunkCount,String fileName,string fileDelimiters) {
        // System.debug('jsonin recieved for deserialise'+jsonin);
        // System.debug('###### START insertBulkMaterial :::: chunkCount:: APEX::'+chunkCount+'###batchNo:'+batchNo);
        boolean isReUploadLocal = Boolean.valueOf(isreupload);
        if(isReUploadLocal){
            // System.debug('#################### INSIDE ISREUPLOAD');
            Database.executeBatch(new deleteTheRecordsBasedonId(batchNo),2000);
            batchNo = '';
        }
        boolean insertStatus =true;        
        String returnBatchId;
        
        if(String.isBlank(batchNo)) {
            Inventory_Transaction_Master__c transactions = new Inventory_Transaction_Master__c();
            transactions.File_Uploaded_By__c = userInfo.getFirstName() + ','+ userInfo.getLastName();
            transactions.Record_Type__c = recordType;
            transactions.Sales_Company__c = selComp;
            transactions.Sales_Month__c = selMonth;
            transactions.Sales_Year__c = selYear;    
            transactions.upload_file_name__c = EncodingUtil.urlEncode(fileName, 'UTF-8');
            transactions.File_Delimiters__c = fileDelimiters;
            try{
                if(
                    Inventory_Transaction_Master__c.SObjectType.getDescribe().isCreateable()){
                        insert transactions;
                    }
                    // System.debug('After Inserting Master batch num'+transactions.Id);
                batchNo = transactions.Id;
            }catch(DMLException e){   
                insertStatus = false;
                // system.debug('Error in insertDataUploadMaterial: during DataUploadMaterial'+e.getMessage());
            }
        }
        boolean status = false;
        if(insertStatus){
            if(jsonin!= null){
                // System.debug('##############jsonin:::::'+jsonin);
                System.debug('Insert records into material Trasnsactionn Stage');
                // System.debug('Current heap Size'+Limits.getHeapSize());
                // System.debug('Max Allowed Heap Size'+Limits.getLimitHeapSize());
                
                status=insertMaterialStageChunk(jsonin,batchNo);       
            }            
        }  
        // System.debug('status:'+status+'###batchNo'+batchNo);      
        if(status){
            returnBatchId = batchNo;
        }else{
            // System.debug('Inside Else clearing batch ID');
            returnBatchId ='';
        }        
        return returnBatchId;
    }


        //insert stage records into Material_Transaction_Stage__c
        public static boolean insertMaterialStageChunk(string jsonin, string batchNo){    
            // System.debug('Current heap Size chunk'+Limits.getHeapSize());
            // System.debug('Max Allowed Heap Size chunk'+Limits.getLimitHeapSize());
               
            boolean insertStatus = true;        
            double rowNo;
            // System.debug('Json recieved at Insert Material Stage Chunk'+jsonin);
            List<Material_Transaction_Stage__c> deserializedMaterial = (List<Material_Transaction_Stage__c>) System.JSON.deserialize(jsonin, List<Material_Transaction_Stage__c>.class);
            // System.debug('Current heap Size chunk 2'+Limits.getHeapSize());
            // System.debug('Max Allowed Heap Size chunk 2'+Limits.getLimitHeapSize());
            List<Material_Transaction_Stage__c> transbatchid = new  List<Material_Transaction_Stage__c>();
            List<Material_Transaction_Stage__c> transErrorRow = new  List<Material_Transaction_Stage__c>();
            // system.debug('jsonin::::'+jsonin);
            // system.debug('batch No::::'+batchNo);
            
            // System.debug('deserialised:::'+deserializedMaterial);
            Integer totalCount = [SELECT  COUNT() FROM Material_Transaction_Stage__c where Upload_Batch_No__c =: batchNo WITH SECURITY_ENFORCED];
            System.debug('totalCount'+ totalCount);
            if(totalCount==0){
                // System.debug('row count is 0 zero inc by 2');
                rowNo = (totalCount+2);
                // System.debug('inside if roNO'+ rowNo);
            }else {
                rowNo = (totalCount+1);
            }
            // system.debug('rowNo:::'+rowNo);
            // double firstRowCount = 1;
            // double count = 1;
            if(deserializedMaterial.size() >0){
                double inputFileRowCount = deserializedMaterial.size();
                // system.debug('inputFileRowCount:::'+inputFileRowCount);            
                for(Material_Transaction_Stage__c trans: deserializedMaterial){
                    if((inputFileRowCount) == rowNo){
                        if(  String.isBlank(trans.Year__c) && String.isBlank(trans.Month__c) && String.isBlank(trans.PO_Date__c) && String.isBlank(trans.PO_Number__c) && String.isBlank(trans.Mainetti_Company__c) && String.isBlank(trans.Material__c) &&  String.isBlank(trans.Order_Type__c) && String.isBlank(trans.Supplier_Name__c) &&  String.isBlank(trans.Supplier_Country_2__c) && String.isBlank(trans.Purchase_Terms__c) && String.isBlank(trans.UOM__c) &&  String.isBlank(String.valueOf(trans.QTY__c)) && String.isBlank(String.valueOf(trans.Purchase_Currency__c)) && String.isBlank(String.valueOf(trans.Purchase_Unit_Price__c)) && String.isBlank(String.valueOf(trans.Purchase_Price__c)) && String.isBlank(trans.ExRate_To_USD__c) &&  String.isBlank(trans.ExRate_To_EUR__c) && String.isBlank(trans.Expected_Delivery_Month__c) &&  String.isBlank(trans.Expected_Delivery_Year__c)){
                            
                            // system.debug('1  mandatory Fields not found');
                        }
                        else{
                            // system.debug('2 Mandatory fields found insert records');
                            trans.Row_No__c =rowNo;
                            trans.Upload_Batch_No__c = batchNo;
                            trans.Transaction_Master_Id__c = batchNo;
                            transbatchid.add(trans);
                            rowNo++;
                            System.debug('Row incremented');
                        }
                    }else{ 
                        if(  String.isBlank(trans.Year__c) && String.isBlank(trans.Month__c) && String.isBlank(trans.PO_Date__c) &&  String.isBlank(trans.PO_Number__c) && String.isBlank(trans.Mainetti_Company__c) && String.isBlank(trans.Material__c) &&   String.isBlank(trans.Order_Type__c) && String.isBlank(trans.Supplier_Name__c) && String.isBlank(trans.Supplier_Country_2__c) && String.isBlank(trans.Purchase_Terms__c) && String.isBlank(trans.UOM__c) && String.isBlank(String.valueOf(trans.QTY__c)) && String.isBlank(String.valueOf(trans.Purchase_Currency__c)) && String.isBlank(String.valueOf(trans.Purchase_Unit_Price__c)) && String.isBlank(String.valueOf(trans.Purchase_Price__c)) && String.isBlank(trans.ExRate_To_USD__c) && String.isBlank(trans.ExRate_To_EUR__c) && String.isBlank(trans.Expected_Delivery_Month__c) &&  String.isBlank(trans.Expected_Delivery_Year__c)){
                         
                        //  system.debug('3  mandatory Fields not found');
                     }
                     else{
                        //  system.debug('4 Mandatory fields found insert records');
                         trans.Row_No__c =rowNo;
                         trans.Upload_Batch_No__c = batchNo;
                         trans.Transaction_Master_Id__c = batchNo;
                         transbatchid.add(trans);
                         rowNo++;
                     }
                        // System.debug('5 regular insert rows');
                    }
                }
            }
        try{
            // inserting error rows           
            if(transErrorRow.size()>0){   
                if (Schema.sObjectType.Material_Transaction_Stage__c.isCreateable()) {
                    insert transErrorRow;
                }  
                // system.debug('transErrorRow   001 ::'+transErrorRow);
            }
            if(transbatchid.size()>0){ 
                insert transbatchid;
                // system.debug('transbatchid    002::'+transbatchid);
            }else {
                insertStatus = false;
                // system.debug('insertStatus    003::'+insertStatus);
            }
        }catch(DMLException e){ 
            insertStatus = false;
            // system.debug('insertStatus    004::'+insertStatus+'Excep'+e.getMessage());
            
        }
        // system.debug('insertStatus    005::'+insertStatus);
        return insertStatus;  
            
        }
    

    
    @AuraEnabled
    public static String parseMaterialChunk(string jsonin, string batchNo, string recordType, string selComp, string selMonth, string selYear, string postBulkInsert) {
        // system.debug('jsonin ::'+jsonin);
        string returnBatchId = '';
        Inventory_Transaction_Master__c updateBatchStatus = new Inventory_Transaction_Master__c();
        boolean recordStatus = true;   
        // boolean proceedStatus = false;
        // boolean isInsertRequired = boolean.valueOf(postBulkInsert);
        // System.debug('validate BUlk Batch Apex'+batchNo+':'+selMonth+':'+selYear+':'+selComp+':'+recordStatus);
        if(recordStatus){
            // System.debug('inside if in parsematerialchunk');
            returnBatchId = batchNo;
            updateBatchStatus.Id = batchNo;               
            updateBatchStatus.Batch_Status__c='2 - Data Validation In Progress';
            if (Schema.sObjectType.Inventory_Transaction_Master__c.isUpdateable()) {
                update updateBatchStatus;
            }
            string userEmail = UserInfo.getUserEmail();
            
            // calling the validateMaterialRowsBulk Batch Apex
            
            validataeBulkBatchApex(batchNo,selMonth,selYear,selComp,userEmail);
            
        }   
        return returnBatchId;
    }  

        // Called by parse material chunk for validation
        public static boolean validataeBulkBatchApex(String batchNo,String selMonth,String selYear,String selComp,String userEmail){
            // System.debug('validate BUlk Batch mehtod called: '+batchNo+':'+selMonth+':'+selYear+':'+selComp);
            
            boolean validateBulkStatus = true;
            validateMaterialUploadRowsBulk validateBulk = new validateMaterialUploadRowsBulk(batchNo,selMonth,selYear,selComp,userEmail);
            Database.executeBatch(validateBulk,1500);
            //Database.executeBatch(validateBulk,2);
            return validateBulkStatus;
        } 
        

     //get Inventory Transcation Master Batch Status Picklist Values for filter by record status picklist
     @AuraEnabled 
     public static Map<String, String> getBatchStatus(){
         Map<String, String> options = new Map<String, String>();
         Schema.DescribeFieldResult fieldResult = Inventory_Transaction_Master__c.Batch_Status__c.getDescribe();
         List<Schema.PicklistEntry> pList = fieldResult.getPicklistValues();
         for (Schema.PicklistEntry p: pList) {
             //Put Picklist Value & Label in Map
             options.put(p.getValue(), p.getLabel());
         }
         return options;
     }

     //Filter batch status table based on year company and batch status
     @AuraEnabled
     public static List<Inventory_Transaction_Master__c> getMaterialDatabyYear(String year,String company,String batchStatus){
        //  system.debug('year :::'+year);
        //  system.debug('company :::'+company);
        //  system.debug('batchStatus :::'+batchStatus);
         string searchQuery = 'select Id, upload_file_name__c,Upload_Converted_File_Name__c, Batch_No__c, Reprocessing__c,Batch_Status__c, File_Uploaded_By__c, Record_Type__c,Azure_File_Link__c,Mainetti_Company__c,Total_Row_Count__c,Uploaded_Total_Stock_In_Qty__c,company_week__c,Sales_Company__c,Sales_Month__c,Sales_Market__c,Sales_Year__c,Batch_Process__c,CreatedDate,Void__c,Void_Reason__c from Inventory_Transaction_Master__c'; 
         
         string itsMaterial = 'Material';
         searchQuery += ' where Record_Type__c =: itsMaterial';
         if(String.isNotBlank(year)){
            //  system.debug('year :::'+year);
             searchQuery += ' and Sales_Year__c =: year';
         }
         if(String.isNotBlank(company)){
            //  system.debug('company :::'+company);
             searchQuery += ' and Sales_Company__c =: company';
         }
         if(String.isNotBlank(batchStatus)){
            //  system.debug('month :::'+batchStatus);
             searchQuery += ' and Batch_Status__c =: batchStatus ';
         }
         
         searchQuery += ' order by CreatedDate desc LIMIT 50';
        //  system.debug('searchQuery>>'+searchQuery);
         List<Inventory_Transaction_Master__c> fetchdata= Database.query(searchQuery);
         return fetchdata;
     }

     // used to auto populate valuse for reupload
     @AuraEnabled
     public static List<Inventory_Transaction_Master__c> getAutoPopulateMasterValues(String batchId){
         List<Inventory_Transaction_Master__c> masterData= [Select Sales_Company__c,Sales_Year__c,Sales_Month__c from Inventory_Transaction_Master__c where id =:batchId ];
        //  System.debug('master Data'+masterData);
         return masterData;
     }

/*     
 █████   ██████ ███████     ████████ ███████ ███████ ████████ 
██   ██ ██      ██             ██    ██      ██         ██    
███████ ██      ███████        ██    █████   ███████    ██    
██   ██ ██           ██        ██    ██           ██    ██    
██   ██  ██████ ███████        ██    ███████ ███████    ██    
                                                              
                                                              
 */

    //called from aura once the csv data is converted to JSON using Papa parser with field mapping
    
    
   
    
    //get Inventory Transcation Master Record Status Picklist Values
/*     @AuraEnabled 
    public static Map<String, String> getRecordStatus(){
        Map<String, String> options = new Map<String, String>();
        Schema.DescribeFieldResult fieldResult = Inventory_Transaction_Master__c.Record_Type__c.getDescribe();
        List<Schema.PicklistEntry> pList = fieldResult.getPicklistValues();
        for (Schema.PicklistEntry p: pList) {
            //Put Picklist Value & Label in Map
            options.put(p.getValue(), p.getLabel());
        }
        return options;
    }     */
   
    
/*     @AuraEnabled 
    public static Map<String, String> getMainettiMap(){
        getSalesBudgetMasterData mainettiMap = new getSalesBudgetMasterData();
        return mainettiMap.getManitteCompanyPicklistMap();
    }     */

    /* @AuraEnabled
    public static List<Inventory_Transaction_Master__c> getDateandTypeRecords(date fromDate, date toDate, string recordStatus, string batchStatus, string mainettiCmp){
        recordStatus = 'Sales';
        string searchQuery = 'select Id, Batch_No__c, Batch_Status__c, File_Uploaded_By__c, Record_Type__c,Azure_File_Link__c,Mainetti_Company__c,Total_Row_Count__c,Uploaded_Total_Stock_In_Qty__c,company_week__c,Batch_Process__c,CreatedDate from Inventory_Transaction_Master__c';
        if(!String.isBlank(string.valueOf(fromDate)) || !String.isBlank(string.valueOf(toDate))||!String.isBlank(recordStatus)||!String.isBlank(batchStatus)||!String.isBlank(mainettiCmp)){
            searchQuery += ' where ';
        }        
        boolean dateFieldFrmPresent = false;
        boolean dateFieldToPresent = false;
        boolean recordStatusPresent = false;
        boolean batchStatusPresent = false;
        if(!String.isBlank(string.valueOf(fromDate)) || !String.isBlank(string.valueOf(toDate))){
            if(!String.isBlank(string.valueOf(fromDate)) && !String.isBlank(string.valueOf(toDate))){
                searchQuery += ' DAY_ONLY(CreatedDate) >=:fromDate AND DAY_ONLY(CreatedDate) <=:toDate';       
                dateFieldFrmPresent = true; 
                dateFieldToPresent = true;
            }
            if(!String.isBlank(string.valueOf(fromDate)) && String.isBlank(string.valueOf(toDate))){
                searchQuery += ' DAY_ONLY(CreatedDate) >=:fromDate';
                dateFieldFrmPresent = true;
            }
            if(String.isBlank(string.valueOf(fromDate)) && !String.isBlank(string.valueOf(toDate))){
                searchQuery += ' DAY_ONLY(CreatedDate) >=:toDate';
                dateFieldToPresent = true;
            }            
        }
        if(!String.isBlank(recordStatus)){
            if(dateFieldFrmPresent==true || dateFieldToPresent==true){
                searchQuery += ' AND Record_Type__c=:recordStatus';
            }else{
                searchQuery += ' Record_Type__c=:recordStatus';
            }
            recordStatusPresent = true;
        }
        if(!String.isBlank(batchStatus)){
            if(dateFieldFrmPresent==true || dateFieldToPresent==true || recordStatusPresent==true ){
                if(batchStatus == '1 - Migration Success'){
                    batchStatus = '8 - Migration Success';
                    searchQuery += ' AND Batch_Status__c=:batchStatus';
                }
                else{
                    batchStatus = '8 - Migration Success';
                    searchQuery += ' AND Batch_Status__c!=:batchStatus'; 
                }               
            }else{                
                if(batchStatus == '1 - Migration Success'){
                    batchStatus = '8 - Migration Success';
                    searchQuery += ' Batch_Status__c=:batchStatus';
                }
                else{
                    batchStatus = '8 - Migration Success';
                    searchQuery += ' Batch_Status__c!=:batchStatus';
                } 
            }
            batchStatusPresent = true;
        }
        if(!String.isBlank(mainettiCmp)){
            if(dateFieldFrmPresent==true || dateFieldToPresent==true || recordStatusPresent==true || batchStatusPresent==true){
                searchQuery += ' AND Mainetti_Company__c=:mainettiCmp';
            }else{
                searchQuery += ' Mainetti_Company__c=:mainettiCmp';
            }
        }
        searchQuery += ' order by CreatedDate';
        List<Inventory_Transaction_Master__c> fetchdata= Database.query(searchQuery);     
        return fetchdata;
    } */
    
    
    /* public static Integer getSalesRecordCount(string batchid){
        
        // AggregateResult[] fetchErrordata=[Select Count(Id) recordCount from Sales_Transaction_Stage__c where Transaction_Master_Id__c=:BatchId];
        AggregateResult[] fetchErrordata=[SELECT Count(Id) recordCount FROM Material_Transaction_Stage__c where Transaction_Master_Id__c=:BatchId WITH SECURITY_ENFORCED];
        
        Integer recCount = 0;
        if(!fetchErrordata.isEmpty()){
            for (AggregateResult salesErrCnt : fetchErrordata){
                recCount = Integer.valueOf(salesErrCnt.get('recordCount'));
            }
        }
        return recCount;
    } */
    //Get error details of Material_Transaction_Stage__c.
/*     @AuraEnabled
    public static List<Material_Transaction_Stage__c> getSalesErrorData(string batchid){
        List <Material_Transaction_Stage__c> fetchFamily= new List<Material_Transaction_Stage__c>();
        Map<string,string> familyMap = new Map<string,string>(); 
        //insert all fields ACS
        List<Material_Transaction_Stage__c> fetchErrordata = [SELECT id FROM Material_Transaction_Stage__c where Transaction_Master_Id__c=:BatchId WITH SECURITY_ENFORCED];
        Integer fetchErrordataSize = fetchErrordata.size();
        return fetchErrordata;
    }
  */
    
    
/*     @AuraEnabled 
    public static Boolean checkQ1ReviewDataSubmitted( String reviewYear , String budgetPeriod , string reviewCompany)
    {
        Boolean recordExists = false;
        
        List<Material_upload__c> fetchData = [SELECT Id FROM  Material_upload__c where Year__c =:reviewYear and Mainetti_Company__c =:reviewCompany WITH SECURITY_ENFORCED LIMIT 1];
        system.debug('fetchData :::'+fetchData);
        if(fetchData.size() > 0){
            recordExists = true;
        }
        return recordExists;
    } */
    
    
    //acs not required
/*     @AuraEnabled 
    public static Boolean checkMaterialAlreadySubmitted( String reviewCompany , String reviewmonth , string reviewyear)
    {
        Boolean recordExists = false;
        
        List<Material_upload__c> fetchData = [SELECT Id
                                              FROM Material_upload__c
                                              WHERE Mainetti_Company__c = :reviewCompany AND Year__c =:reviewyear AND Month__c = :reviewmonth WITH SECURITY_ENFORCED LIMIT 1];
        system.debug('fetchData :::'+fetchData);
        if(fetchData.size() > 0){
            recordExists = true;
        }
        
        system.debug('recordExists :::'+recordExists);
        return recordExists;
    } */
    
    //Used for re upload
    
    
    
    
    
    
    
    /* @AuraEnabled
    public static String generateIdForFileUpload(string recordType, string selMonth, string selYear, string selComp) {
        String batchId;        
        Inventory_Transaction_Master__c Transactions = new Inventory_Transaction_Master__c();
        Transactions.File_Uploaded_By__c = userInfo.getFirstName() + ','+ userInfo.getLastName();
        Transactions.Record_Type__c = recordType;
        Transactions.Sales_Company__c = selComp;
        Transactions.Sales_Month__c = selMonth;
        Transactions.Sales_Year__c = selYear;    
        //Transactions.upload_file_name__c = EncodingUtil.urlEncode(fileName, 'UTF-8');
        try{
            insert Transactions;
            batchId = Transactions.Id;
        }catch(DMLException e){   
            system.debug('Error in generateIdForFileUpload: during DataUploadSales'+e.getMessage());
        } 
        return batchId;
    }
    
 */
    
    /* @AuraEnabled
public static boolean recStatusUpsertForInventory(string batchid){
boolean status = true;
string userEmail = UserInfo.getUserEmail();
recStatusUpsertForInventoryBulk validateBulk = new recStatusUpsertForInventoryBulk(batchId,userEmail);
Database.executeBatch(validateBulk,2000);   
return status;        
}  */
    
/*     @AuraEnabled
    public static boolean recUpdateFOrInvSuccess(string batchid){
        boolean status = true;
        Inventory_Transaction_Master__c updateCheckbox = new Inventory_Transaction_Master__c();
        updateCheckbox.Id = batchid;
        updateCheckbox.Success_Notification__c = true;
        updateCheckbox.Reprocessing__c = false;
        try {
            update updateCheckbox;
        } catch (DMLException e) {
            status = false;
        }
        return status; 
    } */
    /***************Delete the Batch Process records which have become defunct due to some exception****/
    @AuraEnabled
    public static boolean deleteDefunctBatchRecord(String batchId){
        boolean status = true;
        // System.debug('#############INSIDE THE DELETE DEFUNCT BATCH METHOD#########'+batchId);
        Database.executeBatch(new DeleteTheMaterialRecordsBasedonId(batchId),2000);
        return status;
    }

 
    /*

 █████  ███████ ██    ██ ██████  ███████ 
██   ██    ███  ██    ██ ██   ██ ██      
███████   ███   ██    ██ ██████  █████   
██   ██  ███    ██    ██ ██   ██ ██      
██   ██ ███████  ██████  ██   ██ ███████ 
                                         
                                         

     */
    
    @AuraEnabled
    public static String downloadCSVfile(String fileName){
        String fileLink;
        // system.debug('fileName:::'+fileName);
        if(Test.isRunningTest()){
            fileLink = 'https://mcogs01.file.core.windows.net/mcogs01files/SalesForce/TestMaterialUploadSource/Hong+Kong+Oct+2021+220505-015938.csv?sv=2017-11-09&se=2022-05-05T07:05:38Z&sr=f&sp=r&sig=RiSg9GhVPa%2BQ6Mtn02UQN3SZvlKP91mWq6kv%2FNuuYAI%3D';
        } else {
            fileLink = new AzureFileStorageForMaterial().downloadAzureFile(fileName);    
        }    
        // system.debug('fileLink ::'+fileLink);
        return fileLink;
    }
    
    @AuraEnabled
    public static String downloadConvertedCSVfile(String fileName){
        String fileLink;
        // system.debug('fileName:::'+fileName);
        if(Test.isRunningTest()){
             fileLink = 'https://mcogs01.file.core.windows.net/mcogs01files/SalesForce/TestMaterialUploadSuccess/Hong+Kong+Oct+2021+220505-015938User.csv?sv=2017-11-09&se=2022-05-05T07:05:38Z&sr=f&sp=r&sig=RiSg9GhVPa%2BQ6Mtn02UQN3SZvlKP91mWq6kv%2FNuuYAI%3D';
        }else{
            fileLink = new AzureFileStorageForMaterial().downloadConvertedAzureFile(fileName);    
        }
        
        // system.debug('fileLink ::'+fileLink);
        return fileLink;
    }
    

    //Azure download file
  
    @AuraEnabled
    public static boolean hasViewAdminToProfileAccess(){
        boolean status;
        List<Profile> profile;
        // system.debug('status::::'+status);
        if (Schema.sObjectType.Profile.isAccessible()) {
            profile = [SELECT Id, Name FROM Profile WHERE Id=:userinfo.getProfileId() LIMIT 1];
        }
        String myProflieName = profile[0].Name;
        system.debug('myProflieName:::'+myProflieName);
        // AKI :) Custom Settng data
        Sales_Transaction__c customData = Sales_Transaction__c.getInstance();
        string profileName = customData.Profile__c;
        system.debug('profileName:::'+profileName);
        // system.debug('profileNameList before split:::'+profileName);
        List<string> profileNameList = profileName.split(',');
        // system.debug('profileNameList:::'+profileNameList);
        for (string valFormt : profileNameList){

            system.debug('valFormt:::'+valFormt);

            if(valFormt.equals(myProflieName))
            {
                status = true;
                system.debug('myProflieName::Inside Condition::::'+myProflieName+'Statusss1:::'+status);
                break;
            } 
        }
        return status;
    }
    
    // Required for AZURE
    
    //Aki :) Calling from Material Success Data Class for migration  
    public void splitInsertRecordListForUpload(List<Material_upload__c> insertRecord){        
        Integer totalRecCountForUpdate = insertRecord.size();
        Integer maxSizeForUpdate = 9900;
        // System.debug('Record send to split Inserrt rECORD');
        // System.debug(insertRecord);
        
        List<Material_upload__c> uploadTemp = new  List<Material_upload__c>();
        if(totalRecCountForUpdate > maxSizeForUpdate){
            for(Integer i = 0 ; i < (totalRecCountForUpdate / maxSizeForUpdate)+1 ; i++){
                //  List<Material_upload__c> uploadTemp = new  List<Material_upload__c>();
                for(Integer j=(i*maxSizeForUpdate);(j<(i*maxSizeForUpdate)+maxSizeForUpdate) && j<totalRecCountForUpdate ; j++){
                    uploadTemp.add(insertRecord.get(j));
                }
                //   insert uploadTemp;
            }
            if (Schema.sObjectType.Material_upload__c.isCreateable()) {
                insert uploadTemp;
            }
        }else{
            // System.debug('Record Insert Successfull');
            if (Schema.sObjectType.Material_upload__c.isCreateable()) {
                insert insertRecord;
            }
        }
    }
    
    //Required for AZURE

     //Aki :) Calling from Material Success Data Class for migration  
    public void splitListForDelete(List<Material_Transaction_Stage__c> transferRecords){        
        Integer totalRecCountForUpdate = transferRecords.size();
        // system.debug('totalRecCountForUpdate:::'+totalRecCountForUpdate);
        Integer maxSizeForUpdate = 9900;
        if(totalRecCountForUpdate > maxSizeForUpdate){
            List<Material_Transaction_Stage__c> demandTemp = new  List<Material_Transaction_Stage__c>();
            for(Integer i = 0 ; i < (totalRecCountForUpdate / maxSizeForUpdate)+1 ; i++){
                for(Integer j=(i*maxSizeForUpdate);(j<(i*maxSizeForUpdate)+maxSizeForUpdate) && j<totalRecCountForUpdate ; j++){
                    demandTemp.add(transferRecords.get(j));
                }
            }
            if (Schema.sObjectType.Material_Transaction_Stage__c.isDeletable()) {
                delete demandTemp;
            }
        }else{
            if (Schema.sObjectType.Material_Transaction_Stage__c.isDeletable()) {
                delete transferRecords;
            }
        }
    }
    
/*     @AuraEnabled
    public static List<AggregateResult> getprevYear() {
        List<integer> prevYear = new List<integer>();
        List<AggregateResult> ITMRecords = [select  Sales_Year__c  from  Inventory_Transaction_Master__c Where Record_Type__c = 'Budget' GROUP BY Sales_Year__c ];
        system.debug('ITMRecords ::'+ITMRecords);
        for(AggregateResult record : ITMRecords){
            //system.debug('record.Sales_Year__c ::'+record.Sales_Year__c);
            //prevYear.add(record.);
        }
        Integer currentYear = System.Today().year();
        //prevYear.add(currentYear);
        // prevYear.add(currentYear-1);
        return ITMRecords;        
    }  */
    
     
    
    
}