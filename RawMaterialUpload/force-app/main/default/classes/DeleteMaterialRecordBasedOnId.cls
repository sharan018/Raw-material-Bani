global class DeleteMaterialRecordBasedOnId implements Database.Batchable<sObject> , Database.Stateful,Database.AllowsCallouts
{
    String query = 'SELECT Id FROM Material_upload__c WHERE Upload_Batch_No__c=:batchId';
    private String batchId;
    private String userEmail = userinfo.getUserEmail();

    
    public DeleteMaterialRecordBasedOnId(String batchId) {
       // System.debug('######### # START OF REUPLOAD DELETE CONSTRUCTOR BATCH ID'+batchId);
        this.batchId = batchId;
    }
    global Database.querylocator start(Database.BatchableContext bc){
        
        //Returns append status
        // boolean appendStatus = 
        appendTheCSVFile(batchId);
        return Database.getQueryLocator(query);        
    }    
    global void execute(Database.BatchableContext bc, List<Material_upload__c> dataUploadMaterial)
     {    try{
         //system.debug('001');
            delete dataUploadMaterial;
         //system.debug('002');
        }catch(DMLException ex){
            System.debug(LoggingLevel.ERROR,'Exception during bulk delete '+ex.getMessage());
        }
    }
    global void finish(Database.BatchableContext bc)
    {
        Inventory_Transaction_Master__c query = [SELECT Batch_No__c,Batch_Status__c FROM Inventory_Transaction_Master__c WHERE Id =: batchId ];
         boolean appendStatus = appendTheCSVFile(batchId);
        // system.debug('appendStatus    >>>>>>'+appendStatus);

        Map<String,Cogs_Upload_Email_Notification_Users__mdt> cogsUploadEmailMap = Cogs_Upload_Email_Notification_Users__mdt.getAll();
        Cogs_Upload_Email_Notification_Users__mdt cogsUploadEmails = cogsUploadEmailMap.get('Batch_Delete_Process');
        String cogsEmail = cogsUploadEmails.Email__c;
        
        List<String> lstEmail = cogsEmail.split(',');
        String[] toAddresses = new String[]{};
        for(String email:lstEmail){
        toAddresses.add(email);
        }
        // system.debug('toAddresses>>>'+toAddresses);
        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
        mail.setToAddresses(toAddresses);
        mail.setSenderDisplayName('Batch Delete Process');

        if(appendStatus){

        Inventory_Transaction_Master__c transactions = new Inventory_Transaction_Master__c();           
        transactions.Id = batchId;                   
        try{
            //system.debug('0001');
            delete transactions;  

        //Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
        //String[] toAddresses = new String[] {userEmail , 'datasupport.hk@mainetti.com', 'portal.admin@mainetti.com'};
        //mail.setToAddresses(toAddresses);
        //mail.setSenderDisplayName('Batch Delete Process');
        mail.setSubject('Material Delete Batch Process Completed , Ref Batch No :'+query.Batch_No__c);
        mail.setPlainTextBody('Hello,\n\n Your Material File Upload process has been Deleted Successfully. \n\n Warm Regards \n Admin');
        Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });   
            // system.debug('0002');
        }catch(DMLException e){             
            system.debug(LoggingLevel.ERROR,'Error in deleteTheRecordsBasedonId: during Delete Master Record'+e.getMessage());
        }
    }
        else{
            //Revert the Inventory Transaction master void status and delete failure mail to be sent
            Inventory_Transaction_Master__c updateVoidStatus = [SELECT Void__c FROM Inventory_Transaction_Master__c WHERE Id=:batchid LIMIT 1];  updateVoidStatus.Void__c= 'Delete Request Submitted'; update updateVoidStatus;

            // system.debug('Deletion of Master Record Failed');  
            //Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
            //String[] toAddresses = new String[] {userEmail,'datasupport.hk@mainetti.com', 'portal.admin@mainetti.com'};
            //mail.setToAddresses(toAddresses);
            //mail.setSenderDisplayName('Batch Delete Process');
            mail.setSubject('Material Batch Delete Process, Ref Batch No :'+query.Batch_No__c); mail.setPlainTextBody('Hello,\n\n Your Material File Upload delete process failed please contact the Admin. \n\n Warm Regards \n Admin'); Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });  
        }
    }
    
    
    public boolean appendTheCSVFile(String batchId){
        // GetMaterialUploadMasterData getMastData = new GetMaterialUploadMasterData();
        Inventory_Transaction_Master__c invTransMast = [SELECT Sales_Company__c, Sales_Month__c, Sales_Year__c,Batch_No__c,upload_file_name__c,Batch_Status__c,File_Delimiters__c FROM Inventory_Transaction_Master__c where Id =: batchId WITH SECURITY_ENFORCED];
        //  String fileDelimiter = invTransMast.File_Delimiters__c;
         String batchNumber = invTransMast.Batch_No__c;
         //system.debug('batchNumber:::'+batchNumber);

        String fileNames = invTransMast.Sales_Company__c+'+'+invTransMast.Sales_Month__c+'+'+invTransMast.Sales_Year__c +'+'+invTransMast.Batch_No__c+'.csv';
         //system.debug('fileName:::'+fileNames);
         
          String batchNo = batchNumber != null ? batchNumber : '';          
             String fileData = '"'+ batchNo +'"';
        //   system.debug('fileData :::'+fileData);
         
          boolean uploadStatus =  createCSVFileAndUploadToAzure(batchId,fileNames,fileData); 
        //   system.debug('uploadStatus:::'+uploadStatus);
          return  uploadStatus ;
    }
        global  boolean createCSVFileAndUploadToAzure(String batchId,String fileNames, String fileData){
        String fileName;
        boolean fileCreationNUploadToAzure = false;
        GetMaterialUploadMasterData getMastData = new GetMaterialUploadMasterData();
        // boolean fileUploadStatus= true;   
        // system.debug('batchId:::'+batchId+'fileNames:::'+fileNames+'fileData:::'+fileData);
        
        fileName = new AzureMaterialFileStorageService().mainAzureUploadDelete(batchId,fileNames,fileData);   
        // system.debug('fileName:::'+fileName);
         
        /************************************update the Azure URL ********************************** ****/
        if(fileName <> null){
            Inventory_Transaction_Master__c transMast = new Inventory_Transaction_Master__c();             
            transMast.Id = batchId;
            try{
                update transMast;
                
                //returns file Delete Status
                boolean delStatus =  
                getMastData.deleteCSVFile(batchId);
                if(delStatus){
                    fileCreationNUploadToAzure = true;
                }
            }catch(DMLException ex){ fileCreationNUploadToAzure = false;
                System.debug(LoggingLevel.ERROR,'DML Exception '+ex.getMessage());
            }            
        }    
        return fileCreationNUploadToAzure;
    }
}