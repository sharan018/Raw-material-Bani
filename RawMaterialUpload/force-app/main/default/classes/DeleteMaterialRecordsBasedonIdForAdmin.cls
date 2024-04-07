global class DeleteMaterialRecordsBasedonIdForAdmin implements Database.Batchable<sObject>, Database.AllowsCallouts, Database.Stateful {
  String query = 'SELECT Year__c, Month__c, PO_Number__c, Mainetti_Company__c	, PO_Date__c, Material__c, Grade__c, Color__c, Item_code_local__c, Product_Description__c, Order_Type__c, Supplier_Name__c, Supplier_Country__c, Purchase_Terms__c, UOM__c, Landed_cost_to_factory__c,Freight_cost_to_factory__c,QTY__c, Purchase_Currency__c, Purchase_Unit_Price__c, Purchase_Price__c, ExRate_To_USD__c, ExRate_To_EUR__c, Expected_Delivery_Date__c, Expected_Delivery_Month__c, Expected_Delivery_Year__c, Record_Status__c, Error_Code__c, Remarks__c, Year_FB__c, Month_FB__c,PO_Number_FB__c, Mainetti_Company_FB__c, PO_Date_FB__c, Item_code_local_FB__c, Order_Type_FB__c, Supplier_Country_FB__c, Purchase_Terms_FB__c, UOM_FB__c, QTY_FB__c, Purchase_Currency_FB__c, Purchase_Unit_Price_FB__c, Purchase_Price_FB__c, ExRate_To_USD_FB__c	, ExRate_To_EUR_FB__c, Expected_Delivery_Month_FB__c, Expected_Delivery_Year_FB__c, Year_NF__c, Mainetti_Company_NF__c, PO_Date_NF__c, Item_code_local_NF__c, Order_Type_NF__c, Supplier_Country_NF__c, Purchase_Terms_NF__c, Freight_cost_to_factory_FB__c,Landed_cost_to_factory_FB__c,UOM_NF__c, QTY_NF__c, Purchase_Currency_NF__c, Purchase_Price_NF__c, exRate_To_USD_NF__c, exRate_To_EUR_NF__c, Expected_Delivery_Date_NF__c, Expected_Delivery_Month_NF__c, Expected_Delivery_Year_NF__c  FROM Material_Transaction_Stage__c WHERE Upload_Batch_No__c=:batchId WITH SECURITY_ENFORCED order by Row_No__c';
  private String batchId;
  private String userEmail;
  private List<Material_Transaction_Stage__c> materialTransStageForCSV;

  public DeleteMaterialRecordsBasedonIdForAdmin( String batchId, String userEmail ) {
    // System.debug( '########## START OF REUPLOAD DELETE CONSTRUCTOR BATCH ID' + batchId );
    this.batchId = batchId;
    this.userEmail = userEmail;
  }

  global Database.querylocator start(Database.BatchableContext bc) {
    return Database.getQueryLocator(query);
  }
  global void execute( Database.BatchableContext bc, List<Material_Transaction_Stage__c> materialTransStage ) {
    // system.debug('materialTransStage:::' + materialTransStage.size());
    try {
      materialTransStageForCSV = materialTransStage;
      delete materialTransStage;
    } catch (DMLException ex) {
      System.debug(LoggingLevel.ERROR,'Exception during bulk delete >> ' + ex.getMessage());
    }
  }
  global void finish(Database.BatchableContext bc) {
    Inventory_Transaction_Master__c transactions = new Inventory_Transaction_Master__c();
    transactions.Id = batchId;
    Inventory_Transaction_Master__c query = [
      SELECT Batch_No__c, Batch_Status__c
      FROM Inventory_Transaction_Master__c
      WHERE Id = :batchId
      WITH SECURITY_ENFORCED
    ];
    try {
      if (query.Batch_Status__c == '8 - Migration Success') {
        Database.executeBatch(new DeleteMaterialRecordBasedOnId(batchId), 2000);
        // system.debug('Successfully Deleted  Data Upload Material');
      } else {
        // system.debug('001');
        delete transactions;
        // system.debug('002');
      }

      /*
                Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
        String[] toAddresses = new String[] {userEmail,'datasupport.hk@mainetti.com', 'portal.admin@mainetti.com'};
            mail.setToAddresses(toAddresses);
        mail.setSenderDisplayName('Batch Processing');
        mail.setSubject('Material Batch Process Completed , Ref Batch No :'+query.Batch_No__c);
        mail.setPlainTextBody('Hello,\n\n Your Material File Upload process has been Deleted Successfully. \n\n Warm Regards \n Admin');
        Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });   */
    } catch (DMLException e) {
      system.debug(LoggingLevel.ERROR,'Error in deleteTheRecordsBasedonId: during Delete Master Record' + e.getMessage() );
    }
    // system.debug('######## Complete the Deletion of Master Record');
  }
}