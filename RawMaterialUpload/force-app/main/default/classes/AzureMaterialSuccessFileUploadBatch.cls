global class AzureMaterialSuccessFileUploadBatch implements Database.Batchable<sObject> ,Database.AllowsCallouts, Database.Stateful {  

    global String batchId;
    global String conVerTitle;
    //global boolean uploadSalesSuccessFile;
    global String fileName;
    global String encodedfileName ;
    global  Integer startRange = 0;
    global String userEmail;
    global boolean uploadStatus;

    String fetchSuccessdata = 'SELECT Batch_No__c FROM Inventory_Transaction_Master__c WHERE Id =: batchId';
    private List<ContentVersion> contentCSVData;

    Cogs_Sales_Upload__c detail = Cogs_Sales_Upload__c.getInstance();         
    String storageKey = detail.StorageKey__c;
    String storageName = detail.StorageName__c;
    string sourcedownloadpath  = detail.Material_Source_File_Download_Path__c;
    String containerName = detail.Material_containerName__c;
 
    public AzureMaterialSuccessFileUploadBatch( String batchId,String conVerTitle,String userEmail) {
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
        if(uploadStatus) {
            Database.executeBatch(new MaterialSuccessData(batchId,userEmail),2000);
        }

    }

    global  boolean createCSVFileAndUploadToAzure(String batchId){
        // system.debug(' createCSVFileAndUploadToAzure  :::: batchId ::'+batchId);
        String fileName;
        // string userfileName;
        boolean fileCreationNUploadToAzure = true;
        GetMaterialUploadMasterData getMastData = new GetMaterialUploadMasterData();
        // boolean fileUploadStatus= true;    
        
        fileName = new AzureMaterialFileStorageService().mainAzureUpload(batchId,conVerTitle); 
        // system.debug(' createCSVFileAndUploadToAzure  ::: fileName ::'+fileName);
        if(fileName <> null ){
            Inventory_Transaction_Master__c transMast = new Inventory_Transaction_Master__c();
            //String  inventoryFileLink = '/apex/salesFileDownload?Id='+batchId;
            String  inventoryFileLink = '/apex/MaterialFileDownload?Id='+batchId;
            transMast.Id = batchId;
            transMast.upload_file_name__c = fileName;
            transMast.Azure_File_Link__c = inventoryFileLink;
            try{
                update transMast;

                // Returns delete statement
                // boolean delStatus =  
                getMastData.deleteCSVFile(batchId);
                // system.debug('delStatus>>'+delStatus);
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