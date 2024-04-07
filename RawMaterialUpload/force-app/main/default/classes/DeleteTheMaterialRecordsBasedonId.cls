global class DeleteTheMaterialRecordsBasedonId implements Database.Batchable<sObject> , Database.Stateful{
	String query = 'SELECT Id FROM Material_Transaction_Stage__c WHERE Upload_Batch_No__c=:batchId WITH SECURITY_ENFORCED';
    private String batchId;
    public DeleteTheMaterialRecordsBasedonId(String batchId) {
        //System.debug('########## START OF REUPLOAD DELETE CONSTRUCTOR BATCH ID'+batchId);
        this.batchId = batchId;
    }
    global Database.querylocator start(Database.BatchableContext bc){
        //Returns delete status
        // boolean delStatus =  
        new GetMaterialUploadMasterData().deleteCSVFile(batchId);
        return Database.getQueryLocator(query);        
    }    
    global void execute(Database.BatchableContext bc, List<Material_Transaction_Stage__c> materialTransStage)
     {    try{
            delete materialTransStage;
        }catch(DMLException ex){
            System.debug(LoggingLevel.ERROR,'Exception during bulk delete '+ex.getMessage());
        }
    }    
    global void finish(Database.BatchableContext bc)
    {
        Inventory_Transaction_Master__c transactions = new Inventory_Transaction_Master__c();           
        transactions.Id = batchId;                   
        try{
            delete transactions;           
        }catch(DMLException e){             
            system.debug(LoggingLevel.ERROR,'Error in  deleteTheRecordsBasedonId: during Delete Master Record'+e.getMessage());
        }
        //system.debug('######## Complete the Deletion of Master Record');
    }
}