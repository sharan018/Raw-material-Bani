global class AzureUserMaterialFileUploadBatch implements Database.Batchable<sObject> ,Database.AllowsCallouts, Database.Stateful {  
    
        global String batchId;
        global String conVerTitle;
        //global boolean uploadSalesSuccessFile;
        global String fileName;
        global String encodedfileName ;
        global  Integer startRange = 0;
        global String userEmail;
        global boolean uploadStatus;
        private List<ContentVersion> contentCSVData;
        
        String fetchSuccessdata = 'SELECT Batch_No__c FROM Inventory_Transaction_Master__c WHERE Id =: batchId WITH SECURITY_ENFORCED';
        
        
        Cogs_Sales_Upload__c detail = Cogs_Sales_Upload__c.getInstance();         
        String storageKey = detail.StorageKey__c;
        String storageName = detail.StorageName__c;
        string sourcedownloadpath  = detail.Material_Source_File_Download_Path__c;
        String containerName = detail.Material_containerName__c;

        public AzureUserMaterialFileUploadBatch(String batchId,String conVerTitle,String userEmail) {
            this.batchId = batchId;
            this.conVerTitle = conVerTitle;
            this.userEmail = userEmail;
        }
        
        
        global Database.querylocator start(Database.BatchableContext bc){

        this.uploadStatus =  createCSVFileAndUploadToAzure(batchId);    
        return Database.getQueryLocator(fetchSuccessdata);  
        }



        global void execute(Database.BatchableContext bc, List<Inventory_Transaction_Master__c> transferRecords){

        }



        global void finish(Database.BatchableContext bc){
        // system.debug('finish  :::');  
        if(uploadStatus) {
            Database.executeBatch(new AzureMaterialSuccessFileUploadBatch(batchId,'MaterialSuccessCSVFile',userEmail),1);
        }
    }

     global  boolean createCSVFileAndUploadToAzure(String batchId){
        // system.debug(' createCSVFileAndUploadToAzure  ::: batchId ::'+batchId);
        // String fileName;
        string userfileName;
        boolean fileCreationNUploadToAzure = true;
        // boolean fileUploadStatus= true;    
             userfileName = new AzureMaterialFileStorageService().mainAzureUserUpload(batchId,conVerTitle); 
            //  system.debug(' createCSVFileAndUploadToAzure  ::: userfileName ::'+userfileName);
         
        /************************************update the Azure URL **************************************/
            if(userfileName <> null ){
            Inventory_Transaction_Master__c transMast = new Inventory_Transaction_Master__c();
            //String  convertedFileLink = '/apex/budgetConvertedFileDownload?Id='+batchId; 
            String  convertedFileLink = '/apex/MaterialConvertedFileDownload?Id='+batchId; 
            transMast.Id = batchId;
            transMast.Upload_Converted_File_Name__c = userfileName;
           transMast.Sales_Budget_Converted_File_Link__c = convertedFileLink;
            try{
                update transMast;
            }catch(DMLException ex){
                fileCreationNUploadToAzure = false;
                // System.debug('DML Exception during the 6 - Azure File Upload Successful'+ex.getMessage());
            }            
        }else{
            fileCreationNUploadToAzure = false;
        }        
        return fileCreationNUploadToAzure;
    }
    
}