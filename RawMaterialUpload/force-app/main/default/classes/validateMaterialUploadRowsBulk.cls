global class validateMaterialUploadRowsBulk implements Database.Batchable<sObject>, Database.Stateful {
    String query = 'SELECT Year__c, Month__c, PO_Number__c,  PO_Date__c,  Item_code_local__c, Supplier_Country_2__c, Product_Description__c, Supplier_Name__c,  Expected_Delivery_Date__c, Expected_Delivery_Month__c, Expected_Delivery_Year__c, Year_FB__c, Month_FB__c, PO_Number_FB__c, Mainetti_Company_FB__c, PO_Date_FB__c, Item_code_local_FB__c, Order_Type_FB__c, Supplier_Country_FB__c, Supplier_Country_2_FB__c, Region__c, Purchase_Terms_FB__c, UOM_FB__c, QTY_FB__c, Purchase_Currency_FB__c, Purchase_Unit_Price_FB__c, Purchase_Price_FB__c, ExRate_To_USD_FB__c, ExRate_To_EUR_FB__c, Expected_Delivery_Month_FB__c, Expected_Delivery_Year_FB__c, Year_NF__c, Mainetti_Company_NF__c, PO_Date_NF__c, Item_code_local_NF__c, Order_Type_NF__c, Supplier_Country_NF__c, Supplier_Country_2_NF__c, Purchase_Terms_NF__c,Freight_cost_to_factory_NF__c,Landed_cost_to_factory_NF__c, UOM_NF__c, QTY_NF__c, Purchase_Currency_NF__c, Purchase_Price_NF__c, exRate_To_USD_NF__c, exRate_To_EUR_NF__c, Expected_Delivery_Date_NF__c, Expected_Delivery_Month_NF__c, Expected_Delivery_Year_NF__c, Record_Status__c, Error_Code__c, Remarks__c, Mainetti_Company__c, Color__c, Material__c, Grade__c,Purchase_Terms__c, Order_Type__c, Purchase_Currency__c, Supplier_Country__c,  UOM__c, Type__c, Upload_Batch_No__c, Purchase_Price__c,  QTY__c, Purchase_Unit_Price__c,  ExRate_To_USD__c, ExRate_To_EUR__c, Purchase_Price_EUR__c, Purchase_Price_USD__c, Product_Unique_ID_Name__c, Product_Category__c, Cogs_Country__c, Batch_No__c, Local_Supplier_Code__c,Freight_cost_to_factory__c,Landed_cost_to_factory__c,Freight_cost_to_factory_FB__c,Landed_cost_to_factory_FB__c  FROM Material_Transaction_Stage__c  WHERE Upload_Batch_No__c=:batchId  order by Row_No__c ';
    
    private String selMonth;
    private String selYear;
    private String selcomp;
    private String email;
    private String batchId;
    private String userEmail;  
    private String returnBatchId;
    private List<Material_Transaction_Stage__c> materialTransStageForCSV;
    
    public validateMaterialUploadRowsBulk(String batchId,String selMonth,String selYear,String selcomp,String userEmail) {
        // System.debug('Inside validatematerialupliadrowBulk: '+batchId);
        this.batchId = batchId;
        this.selMonth = selMonth;
        this.selYear = selYear;
        this.selcomp = selcomp;
        this.userEmail = userEmail;
    }    
    global class  RecordValidationStatus{
        public Boolean validateStatus { get; set; }
        public Boolean updateCheckbox { get; set; }        
    }    
    global Database.querylocator start(Database.BatchableContext bc){        
        //System.debug('::::::::::::::: INSIDE THE START METHOD OF Material UPLOAD BATCH PROCESSING :::::::::::::::::::::');
        Inventory_Transaction_Master__c  updateBatchStatus = new Inventory_Transaction_Master__c();
        updateBatchStatus.Id = batchId;
        updateBatchStatus.Batch_Process__c='In Progress';
        update updateBatchStatus;
        // System.debug('Querry result : '+Database.getQueryLocator(query));
        
        return Database.getQueryLocator(query);            
    }
    
    global void execute(Database.BatchableContext bc, List<Material_Transaction_Stage__c> materialTransStagRecAfterReconciliation){
    //    system.debug('Execute method materialTransStagRecAfterReconciliation:::'+materialTransStagRecAfterReconciliation);
        //For Error Mapping ACS
        GetMaterialUploadMasterData getMaterialMasterData = new GetMaterialUploadMasterData();
       Map<string,Map<string,Map<string,string>>> fullMaterialErrorMap =getMaterialMasterData.getmaterialErrorMap();
    
        // System.debug('Execute method in ValidateMaterial Upload');
        RecordValidationStatus recordStatus =  new RecordValidationStatus();
        recordStatus.validateStatus = true;
        recordStatus.updateCheckbox= false;
        boolean validateStatus;
        boolean updateCheckbox;
        materialTransStageForCSV = materialTransStagRecAfterReconciliation;
        // System.debug('Heap Size 001  => ');
        //System.debug('::::::::::::::: INSIDE THE EXECUTE METHOD OF Material UPLOAD materialTransStageForCSV size'+materialTransStageForCSV.size());       
        GetMaterialUploadMasterData materialMasterData = new GetMaterialUploadMasterData();
        // System.debug('Heap Size 004  => '+Limits.getHeapSize());
        String userName = UserInfo.getUserName();
        User activeUser = [Select Email From User where Username = : userName WITH SECURITY_ENFORCED limit 1];
        String userEmailNotify = activeUser.Email;        
        Inventory_Transaction_Master__c  updateBatchStatus = new Inventory_Transaction_Master__c();
        //  System.debug('materialTransStagRecAfterReconciliation >>>>>'+materialTransStagRecAfterReconciliation);
        // System.debug('record sent to pre validation MaterialStafeDataByPage');
        // System.debug('Before Calling preValidation Material Stage by page');
        List<Material_Transaction_Stage__c> materialTransStagUpdate =  materialMasterData.preValidationMaterialStageDataByPage(materialTransStagRecAfterReconciliation, BatchId,selcomp, selMonth, selYear, updateBatchStatus,recordStatus,fullMaterialErrorMap);
        // System.debug( 'preValidationMaterialStageDataByPage >>>>>>'+materialTransStagUpdate);
        // System.debug('data returned after validation to update in material transaction');
        //  System.debug('Heap Size after clearing variables  => '+Limits.getHeapSize());
        boolean isUpdateMaster = false;
        // System.debug(recordStatus+'Record Status');
        validateStatus = (Boolean) recordStatus.validateStatus;
        updateCheckbox = (Boolean) recordStatus.updateCheckbox;
        if(updateCheckbox){              
            updateBatchStatus.Id = batchId;              
            updateBatchStatus.Reprocess_Email_Notify__c = userEmailNotify; 
            isUpdateMaster = true;
        }
        // System.debug('outside main if');
        // System.debug('if conditon '+(materialTransStagUpdate != null && materialTransStagUpdate.size() > 0 )+'maxrecord count'+ materialTransStagUpdate.size());
        if(materialTransStagUpdate != null && materialTransStagUpdate.size() > 0){
            try{            
                // Getting the total record count of the salesrecord for pagination
                Integer totalRecCountForUpdate = materialTransStagUpdate.size();
                Integer maxSizeForUpdate = 9000;
                // System.debug('outer if material transaction');
                // System.debug('totalRecCountForUpdate '+totalRecCountForUpdate +'maxSizeForUpdate'+ maxSizeForUpdate);
                if(totalRecCountForUpdate > maxSizeForUpdate){
                    // System.debug('inside If '+(totalRecCountForUpdate > maxSizeForUpdate));
                    // System.debug('totalRecCountForUpdate '+totalRecCountForUpdate +'maxSizeForUpdate'+ maxSizeForUpdate);
                    // System.debug('for condition'+(totalRecCountForUpdate / maxSizeForUpdate)+1);
                    for(Integer i = 0 ; i < (totalRecCountForUpdate / maxSizeForUpdate)+1 ; i++){
                        List<Material_Transaction_Stage__c> materialTemp = new  List<Material_Transaction_Stage__c>();
                        for(Integer j=(i*maxSizeForUpdate);(j<(i*maxSizeForUpdate)+maxSizeForUpdate) && j<totalRecCountForUpdate ; j++){materialTemp.add(materialTransStagUpdate.get(j));
                            
                            // System.debug('record added to material temp');
                            
                        }
                        update materialTemp;
                    }                    
                }else{
                    // System.debug(materialTransStagUpdate);
                    // System.debug('record updated in else');
                    update materialTransStagUpdate;
                    // System.debug('after record update');
                }
                if(updateBatchStatus!= null){
                    if(isUpdateMaster){
                        update updateBatchStatus;
                    }
                }
            }catch(DMLException e){validateStatus= false;      
                // System.debug('The following exception has occurred: ' + e.getMessage());
                   
            }
        } 
        boolean recordStatuss = true;            
        try{            
            if(!validateStatus){
                updateBatchStatus.Id = batchId;
                updateBatchStatus.Batch_Status__c='3 - Error In Data Validation';   
                update updateBatchStatus;               
            }else{
                // boolean appendStatus = 
                appendTheCSVFile(batchId,materialTransStageForCSV);
                // boolean appendUserStatus = 
                appendTheUserUploadedCSVFile(batchId,materialTransStageForCSV);
            }
           // materialTransStageForCSV = null;
        }catch(DMLException e){recordStatuss = false;}
        
    }
    global void finish(Database.BatchableContext bc){       
        //   Check if any Field is missing or Notfound
        List<Material_Transaction_Stage__c> withOutMaterialAdmin = [SELECT Id  FROM Material_Transaction_Stage__c WHERE  Upload_Batch_No__c =: batchId  
        AND (Year_FB__c = true OR
        Month_FB__c = true OR
        PO_Number_FB__c = true OR
        Mainetti_Company_FB__c = true OR
        PO_Date_FB__c = true OR
        Item_code_local_FB__c = true OR
        Order_Type_FB__c = true OR
        Supplier_Country_FB__c = true OR
        Supplier_Country_2_FB__c = true OR
        Purchase_Terms_FB__c = true OR
        Freight_cost_to_factory_FB__c = true OR
        Landed_cost_to_factory_FB__c = true OR
        UOM_FB__c = true OR
        QTY_FB__c = true OR
        Purchase_Currency_FB__c = true OR
        Purchase_Unit_Price_FB__c = true OR
        Purchase_Price_FB__c = true OR
        ExRate_To_USD_FB__c = true OR
        ExRate_To_EUR_FB__c = true OR
        Expected_Delivery_Month_FB__c = true OR
        Expected_Delivery_Year_FB__c = true OR
        Year_NF__c  = true OR
        Mainetti_Company_NF__c = true OR
        PO_Date_NF__c = true OR
        Item_code_local_NF__c = true OR
        Order_Type_NF__c = true OR
        Supplier_Country_NF__c = true OR
        Supplier_Country_2_NF__c = true OR
        Purchase_Terms_NF__c= true OR
        Freight_cost_to_factory_NF__c = true OR
        Landed_cost_to_factory_NF__c = true OR
        UOM_NF__c= true OR
        QTY_NF__c= true OR
        Purchase_Currency_NF__c= true OR
        Purchase_Price_NF__c= true OR
        exRate_To_USD_NF__c= true OR
        exRate_To_EUR_NF__c= true OR
        Expected_Delivery_Date_NF__c= true OR
        Expected_Delivery_Month_NF__c= true OR
        Expected_Delivery_Year_NF__c = true) WITH SECURITY_ENFORCED LIMIT 1 ];
        if(withOutMaterialAdmin.size() == 0)
        {
            //Akhi Need to include both FB & NF fields
            List<Material_Transaction_Stage__c> materialAdmin = [ SELECT Id  FROM Material_Transaction_Stage__c WHERE  Upload_Batch_No__c =: batchId AND
            Year_FB__c != true AND
            Month_FB__c != true AND
            PO_Number_FB__c != true AND
            Mainetti_Company_FB__c != true AND
            PO_Date_FB__c != true AND
            Item_code_local_FB__c != true AND
            Order_Type_FB__c != true AND
            Supplier_Country_FB__c != true AND
            Purchase_Terms_FB__c != true AND
            Freight_cost_to_factory_FB__c != true AND
            Landed_cost_to_factory_FB__c != true AND
            UOM_FB__c != true AND
            QTY_FB__c != true AND
            Purchase_Currency_FB__c != true AND
            Purchase_Unit_Price_FB__c != true AND
            Purchase_Price_FB__c != true AND
            ExRate_To_USD_FB__c != true AND
            ExRate_To_EUR_FB__c != true AND
            Expected_Delivery_Month_FB__c != true AND
            Expected_Delivery_Year_FB__c != true AND
            Year_NF__c  != true AND
            Mainetti_Company_NF__c != true AND
            PO_Date_NF__c != true AND
            Item_code_local_NF__c != true AND
            Year_NF__c != true AND
            Mainetti_Company_NF__c != true AND
            PO_Date_NF__c != true AND
            Item_code_local_NF__c != true AND
            Order_Type_NF__c != true AND
            Supplier_Country_NF__c != true AND
            Purchase_Terms_NF__c != true AND
            Freight_cost_to_factory_NF__c != true AND
            Landed_cost_to_factory_NF__c !=true AND
            UOM_NF__c != true AND
            QTY_NF__c != true AND
            Purchase_Currency_NF__c != true AND
            Purchase_Price_NF__c != true AND
            exRate_To_USD_NF__c != true AND
            exRate_To_EUR_NF__c != true AND
            Expected_Delivery_Date_NF__c != true AND
            Expected_Delivery_Month_NF__c != true AND
            Expected_Delivery_Year_NF__c != true AND
            Order_Type_NF__c  != true AND
            Supplier_Country_NF__c != true AND
            Purchase_Terms_NF__c != true AND
            Freight_cost_to_factory_NF__c != true AND
            Landed_cost_to_factory_NF__c !=true AND
            UOM_NF__c != true AND
            QTY_NF__c != true AND
            Purchase_Currency_NF__c != true AND
            Purchase_Price_NF__c != true AND
            exRate_To_USD_NF__c != true AND
            exRate_To_EUR_NF__c != true AND
            Expected_Delivery_Date_NF__c != true AND
            Expected_Delivery_Month_NF__c != true AND
            Expected_Delivery_Year_NF__c != true WITH SECURITY_ENFORCED LIMIT 1 ];
            
            if(materialAdmin.size() > 0){
                Inventory_Transaction_Master__c updateReprocessingStatus = new Inventory_Transaction_Master__c();
                updateReprocessingStatus.Id = batchId;
                updateReprocessingStatus.Reprocessing__c = true ;
                update updateReprocessingStatus;
            } 
        }
        boolean containsWarning = false;
        Inventory_Transaction_Master__c updateBatchStatus = new Inventory_Transaction_Master__c();
        // Material_Transaction_Stage__c market = [SELECT Market__c FROM Material_Transaction_Stage__c WHERE Upload_Batch_No__c =: batchId LIMIT 1];
        Inventory_Transaction_Master__c query = [SELECT Batch_No__c,upload_file_name__c,Batch_Status__c FROM Inventory_Transaction_Master__c where Id =: batchId WITH SECURITY_ENFORCED LIMIT 1];
        String recCount = getTotalMaterialTransactionRecords(batchId);
        // String recCount1 = 
        getTotalMaterialTransactionErrorRecords(batchId);
        // System.debug(' query'+query);
            updateBatchStatus.Total_Row_Count__c= Integer.valueOf(recCount);
        if(query != null){
            String batchStaus = query.Batch_Status__c;
            if(batchStaus.endsWithIgnoreCase('3 - Error In Data Validation')){
                containsWarning = true;
            }
        } 
        if(containsWarning){
            updateBatchStatus.Id = batchId;
            updateBatchStatus.Batch_Process__c='Completed';
            update updateBatchStatus;
            Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
            String[] toAddresses = new String[] {userEmail};
            mail.setToAddresses(toAddresses);
            mail.setSenderDisplayName('Batch Processing');
            mail.setSubject('Material Upload Batch Process Completed , Ref Batch No :'+query.Batch_No__c);
            mail.setPlainTextBody('Hello,\n\n Your Material File Upload process has been completed,\n Please proceed to the application and go to the File Upload Screen & Check the upload Status for next steps.. \n\n Warm Regards \n Admin');
            //Put the total records etc.. in the email body.
            Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
            
        }else{
            updateBatchStatus.Id = batchId;
            updateBatchStatus.Batch_Status__c='4 - Data Validation Successful';  
            // system.debug('Batch_Status__c:::'+updateBatchStatus.Batch_Status__c);
            update updateBatchStatus; 

            Database.executeBatch(new AzureUserMaterialFileUploadBatch(batchId,'MaterailUserUploadedCSVFile',userEmail),1);
            // Database.executeBatch(new MaterialSuccessData(batchId,userEmail),1);
            
        }        
    }
    
     public boolean appendTheCSVFile(String batchId,List<Material_Transaction_Stage__c> materialTransStageForCSV){
        GetMaterialUploadMasterData getMastData = new GetMaterialUploadMasterData();
        Inventory_Transaction_Master__c invTransMast = [SELECT Sales_Company__c, Sales_Month__c, Sales_Year__c,Batch_No__c,upload_file_name__c,Batch_Status__c,File_Delimiters__c FROM Inventory_Transaction_Master__c WHERE Id =: batchId WITH SECURITY_ENFORCED ];
        String fileDelimiter = invTransMast.File_Delimiters__c;
        boolean createStatus = true;
        // boolean createUserStatus = true;
        
        //For populating type value to Success CSV file at upload material the type is populated using formula field
        

        
        String csvFile;
        // String csvUserFile;
        String csvColumnHeader = '';
        // string csvUserColumnHeader = '';
        // String contentType = 'text/plain';
        String fileName = invTransMast.Sales_Company__c+'+'+invTransMast.Sales_Month__c+'+'+invTransMast.Sales_Year__c +'+'+invTransMast.Batch_No__c+'.csv';
        
        List<String> csvRowValues = generateCSVRow(materialTransStageForCSV,batchId,fileDelimiter,true);
        String conVerTitle = 'MaterialSuccessCSVFile';
        List<ContentVersion> conVerList =  getMastData.getContentDocumentVerIds(batchId,conVerTitle);
        if(conVerList.size() == 0){
            
           
              csvColumnHeader = 'Batch No'+','+'Year'+','+'Month'+','+'PO Date'+','+'PO Number'+','+'Region'+','+'Cogs_country'+','+'Company'+','+'Product Unique ID'+','+'Product Category'+','+'Material'+','+'Grade'+','+'Color'+','+'Type'+','+'Item Code(Local)'+','+'Product Desc'+','+'Order Type'+','+'Supplier Name'+','+'Supplier Name ID in SF'+','+'Local Supplier Code'+','+'Supplier Country'+','+'Supplier Code'+','+'Supplier group'+','+'Terms'+','+'Freight cost to factory (road/ship/freight)'+','+'Landed cost to factory'+','+'UOM'+','+'Qty'+','+'Purchase Currency'+','+'Purchase Unit Price'+','+'Purchase Price'+','+'exRate To USD'+','+'exRate To EUR' +','+'Purchase Price USD'+','+'Purchase Price EUR'+','+'Expected Delivery  Date'+','+'Expected Delivery  Month'+','+'Expected Delivery Year\n'; 
        }
        //  System.debug('Before CSV FILE Clearing  => '+Limits.getHeapSize());
        csvFile = csvColumnHeader + String.join(csvRowValues,'\n');         
        // system.debug('csvFile:::'+csvFile);
        // boolean delStatus =  
        getMastData.deleteCSVFile(batchId);
        createStatus = new GetMaterialUploadMasterData().createDocument(batchId,csvFile,fileName,conVerTitle);
        //  system.debug('createStatus>>'+createStatus+'<<<<fileName>>'+fileName);
         csvFile = null;
         materialTransStageForCSV = NULL;
        //  System.debug('after CSV FILE Clearing  => '+Limits.getHeapSize());
        return  createStatus ;
    }
 
    // used ACS for generating csv file for attachment

    
    global List<String>  generateCSVRow(List<Material_Transaction_Stage__c> materialTransStageForCSV, String batchId,String fileDelimiter,boolean userfile){
        List<String> csvRowValues = new List<String>(); 
        // System.debug('Material Transaction Stage');

        //used only for populating type field in success csv file in final upload material, value will be populated using formula field ACS
        getmaterialUploadMasterData getmaterialUploadMasterData = new getmaterialUploadMasterData();
        Map<String,Map<String,String>> getProductMap = getmaterialUploadMasterData.getMatchingProduct();
        Map<String,String> gradeTypeMap = getProductMap.get('gradeTypeMap');
        //  system.debug('materialTransStageForCSV >>>>'+materialTransStageForCSV);
        for(Material_Transaction_Stage__c materialTranStage : materialTransStageForCSV){
            String batchNo = materialTranStage.Batch_No__c != null ? materialTranStage.Batch_No__c : '';
            String year = materialTranStage.Year__c != null ? materialTranStage.Year__c : '';
            String month = materialTranStage.Month__c != null ? materialTranStage.Month__c : '';
            String poDate = materialTranStage.PO_Date__c != null ? materialTranStage.PO_Date__c : '';
            String poNumber = materialTranStage.PO_Number__c != null ? materialTranStage.PO_Number__c : '';
            String region = materialTranStage.Region__c != null ? materialTranStage.Region__c : '';
            String cogsCountry = materialTranStage.Cogs_Country__c != null ? materialTranStage.Cogs_Country__c : '';
            String company = materialTranStage.Mainetti_Company__c != null ? materialTranStage.Mainetti_Company__c : '';
            // System.debug('at product unique ID');
            String productUniqueId = materialTranStage.Product_Unique_ID_Name__c != null ? materialTranStage.Product_Unique_ID_Name__c : '';
  
            String productCategory = materialTranStage.Product_Category__c != null ? materialTranStage.Product_Category__c : '';
            String material = materialTranStage.Material__c != null ? materialTranStage.Material__c : '';
            String grade = materialTranStage.Grade__c != null ? materialTranStage.Grade__c : '';
            String color = materialTranStage.Color__c != null ? materialTranStage.Color__c : '';
            // System.debug('Populating type value gradeTypeMap');
            // System.debug(gradeTypeMap);
            String type = '';
            if(materialTranStage.Grade__c != null){
                if (gradeTypeMap.containsKey((materialTranStage.Grade__c).toUpperCase() )) {
                    type=gradeTypeMap.get((materialTranStage.Grade__c).toUpperCase());
                } 
            }else {
                type='NEW';
            }

            String itemCode = materialTranStage.Item_code_local__c != null ? materialTranStage.Item_code_local__c : '';
            String productDescription = materialTranStage.Product_Description__c != null ? materialTranStage.Product_Description__c : '';
            String orderType = materialTranStage.Order_Type__c != null ? materialTranStage.Order_Type__c : '';
            String supplierName = materialTranStage.Supplier_Name__c != null ? materialTranStage.Supplier_Name__c : '';
            String doublequotesSupplierName = supplierName.replaceAll('"','""');

            // System.debug('SupplierNameACS'+materialTranStage.Supplier_Name1__c);
            String supplierName1 = materialTranStage.Supplier_Name1__c != null ? materialTranStage.Supplier_Name1__c : '';
            String localSupplierCode= materialTranStage.Local_Supplier_Code__c != null ? materialTranStage.Local_Supplier_Code__c : '';
            String supplierCountry= materialTranStage.Supplier_Country_2__c != null ? materialTranStage.Supplier_Country_2__c : '';
            String supplierCode= materialTranStage.Supplier_Code__c != null ? materialTranStage.Supplier_Code__c : '';
            String supplierGroup= materialTranStage.Supplier_Group__c != null ? materialTranStage.Supplier_Group__c : '';

            String purchaseTerm =  materialTranStage.Purchase_Terms__c != null ? materialTranStage.Purchase_Terms__c : '';
            String freightCost = materialTranStage.Freight_cost_to_factory__c != null ? materialTranStage.Freight_cost_to_factory__c : '';
            String landedCost = materialTranStage.Landed_cost_to_factory__c != null ? materialTranStage.Landed_cost_to_factory__c : '';
            String uom =  materialTranStage.UOM__c != null ? materialTranStage.UOM__c : '';
            String qty = materialTranStage.QTY__c != null ? String.valueOf(materialTranStage.QTY__c) : '';
            String purchaseCurrency = materialTranStage.Purchase_Currency__c != null ? materialTranStage.Purchase_Currency__c : '';
            String purchaseUnitPrice = materialTranStage.Purchase_Unit_Price__c != null ? String.valueOf(materialTranStage.Purchase_Unit_Price__c) : '';
            String purchasePrice = materialTranStage.Purchase_Price__c != null ? String.valueOf(materialTranStage.Purchase_Price__c) : '';
            String exRatetoUSD = materialTranStage.ExRate_To_USD__c != null ? materialTranStage.ExRate_To_USD__c : '';
            String exRatetoEUR = materialTranStage.ExRate_To_EUR__c != null ? materialTranStage.ExRate_To_EUR__c : '';
            String pruchasePriceUSD = materialTranStage.Purchase_Price_USD__c != null ? materialTranStage.Purchase_Price_USD__c : '0';
            String pruchasePriceEUR =materialTranStage.Purchase_Price_EUR__c != null ? materialTranStage.Purchase_Price_EUR__c : '0';

            String expectedDeliveryDate = materialTranStage.Expected_Delivery_Date__c != null ? materialTranStage.Expected_Delivery_Date__c : '';
            String expectedDeliveryMonth = materialTranStage.Expected_Delivery_Month__c != null ? materialTranStage.Expected_Delivery_Month__c : '';
            String expectedDeliveryear = materialTranStage.Expected_Delivery_Year__c != null ? materialTranStage.Expected_Delivery_Year__c : '';
            String doubleQuoteItemCode = itemCode.replaceAll('"','""');
            String doubleQuoteProdDescripition =  productDescription.replaceAll('"','""');
            String doubleQuotePoNuumber = poNumber.replaceAll('"','""');
            String doubleQuoteLocalSupplierCode = localSupplierCode.replaceAll('"','""'); 
            
                 String rowStr = '"'+batchNo + '","' + year + '","' + month + '","' + poDate + '","' + doubleQuotePoNuumber + '","' + region + '","' + cogsCountry + '","' + company + '","' + productUniqueId + '","' + productCategory + '","' + material + '","' +grade + '","' + color + '","' + type + '","' + doubleQuoteItemCode + '","'+doubleQuoteProdDescripition+'","' + orderType + '","' + doublequotesSupplierName + '","' +supplierName1+ '","' + doubleQuoteLocalSupplierCode+ '","' + supplierCountry + '","' + supplierCode + '","' + supplierGroup + '","' +  purchaseTerm + '","'+  freightCost + '","'+  landedCost + '","' + uom + '","'  + qty + '","' + purchaseCurrency+ '","' +purchaseUnitPrice+ '","' +purchasePrice+ '","' +exRatetoUSD+ '","' +exRatetoEUR+ '","' +pruchasePriceUSD+ '","' +pruchasePriceEUR+ '","' +expectedDeliveryDate+ '","' +expectedDeliveryMonth+ '","' +expectedDeliveryear+'"';
            
            csvRowValues.add(rowStr); 
        }
        materialTransStageForCSV = null;
        return csvRowValues;
    } 
    //Used ACS
    public String getTotalMaterialTransactionRecords(String batchId){
        String recCount='';    
        AggregateResult[] groupedResults = [SELECT  Count(Id) recCount FROM Material_Transaction_Stage__c WHERE Upload_Batch_No__c=: batchId WITH SECURITY_ENFORCED ];
        for (AggregateResult ar : groupedResults)  {
            recCount = String.valueOf(ar.get('recCount'));
            // system.debug('recCount:::'+recCount);
            // system.debug('recCount:::'+recCount);
        }      
        return recCount;
    } 
    //used accs
    public String getTotalMaterialTransactionErrorRecords(string batchid){
        String recCount1='';
        AggregateResult[] groupedResults = [SELECT  Count(Id) recCount1 FROM Material_Transaction_Stage__c WHERE Upload_Batch_No__c=: batchId and Record_Status__c = '1 - Error In Data Validation' WITH SECURITY_ENFORCED ];
        
        for (AggregateResult ar : groupedResults)  {
            recCount1 = String.valueOf(ar.get('recCount1'));
            // system.debug('recCount1:::'+recCount1);
        }      
        return recCount1;
    }
    
    // added by sai 12-07-2021
    public boolean appendTheUserUploadedCSVFile(String batchId,List<Material_Transaction_Stage__c> materialTransStageForCSV){
        GetMaterialUploadMasterData getMastData = new GetMaterialUploadMasterData();
        Inventory_Transaction_Master__c invTransMast = [SELECT Sales_Company__c, Sales_Month__c, Sales_Year__c,Batch_No__c,upload_file_name__c,Batch_Status__c,File_Delimiters__c FROM Inventory_Transaction_Master__c where Id =: batchId WITH SECURITY_ENFORCED];
        String fileDelimiter = invTransMast.File_Delimiters__c;
        boolean createStatus = true;
        
        String csvFile;
        String csvColumnHeader = '';
        // String contentType = 'text/plain';
        String fileName = invTransMast.Sales_Company__c+'+'+invTransMast.Sales_Month__c+'+'+invTransMast.Sales_Year__c +'+'+invTransMast.Batch_No__c+'User.csv';
        
        List<String> csvRowValues = generateUserUploadedCSVRow(materialTransStageForCSV,batchId,fileDelimiter);
        String conVerTitle = 'MaterailUserUploadedCSVFile';
        List<ContentVersion> conVerList =  getMastData.getContentDocumentVerIds(batchId,conVerTitle);
        if(conVerList.size() == 0){
            
           csvColumnHeader = 'Year'+','+'Month'+','+'PO Number'+','+'Company'+','+'PO Date'+','+'Material'+','+'Grade'+','+'Color'+','+'Item Code(Local)'+','+'Product Desc'+','+'Order Type'+','+'Supplier Name'+','+'Local Supplier Code'+','+'Supplier Country'+','+'Shipping Terms'+','+'Freight cost to factory (road/ship/freight)'+','+'Landed cost to factory'+','+'UOM'+','+'Qty'+','+'Purchase Currency'+','+'Purchase Unit Price'+','+'Purchase Price'+','+'exRate To USD'+','+'exRate To EUR'+','+'Expected Delivery Date'+','+'Expected Delivery Month'+','+'Expected Delivery Year\n';  

        }
        //  System.debug('Before USER CSV FILE Clearing  => '+Limits.getHeapSize());
        csvFile = csvColumnHeader + String.join(csvRowValues,'\n');
        // system.debug('csvFile:::'+csvFile);
        // boolean delStatus =  
        getMastData.deleteCSVFile(batchId);
        createStatus = new GetMaterialUploadMasterData().createDocument(batchId,csvFile,fileName,conVerTitle);
        // system.debug('createStatusforuser>>'+createStatus+'<<<<fileName>>'+fileName);
        csvFile = null;
        materialTransStageForCSV = NULL;
        //  System.debug('After USER CSV FILE Clearing  => '+Limits.getHeapSize());
        return  createStatus ;
    } 
    
      
    global List<String>  generateUserUploadedCSVRow(List<Material_Transaction_Stage__c> materialTransStageForCSV, String batchId,String fileDelimiter){
        List<String> csvRowValues = new List<String>();       
        for(Material_Transaction_Stage__c materialTranStage : materialTransStageForCSV){
            
            String year = materialTranStage.Year__c != null ? materialTranStage.Year__c : '';
            String month = materialTranStage.Month__c != null ? materialTranStage.Month__c : '';
            String poNumber = materialTranStage.PO_Number__c != null ? materialTranStage.PO_Number__c : '';
            String company = materialTranStage.Mainetti_Company__c != null ? materialTranStage.Mainetti_Company__c : '';
            String poDate = materialTranStage.PO_Date__c != null ? materialTranStage.PO_Date__c : '';
            String material = materialTranStage.Material__c != null ? materialTranStage.Material__c : '';
            String grade = materialTranStage.Grade__c != null ? materialTranStage.Grade__c : '';
            String color = materialTranStage.Color__c != null ? materialTranStage.Color__c : ''; 
            String itemCode = materialTranStage.Item_code_local__c != null ? materialTranStage.Item_code_local__c : '';
            String productDescription = materialTranStage.Product_Description__c != null ? materialTranStage.Product_Description__c : '';
            String orderType = materialTranStage.Order_Type__c != null ? materialTranStage.Order_Type__c : '';
            String supplierName = materialTranStage.Supplier_Name__c != null ? materialTranStage.Supplier_Name__c : '';
            String doublequotesSupplierName = supplierName.replaceAll('"','""');
            String localSupplierCode = materialTranStage.Local_Supplier_Code__c != null ? materialTranStage.Local_Supplier_Code__c : '';
            String supplierCountry = materialTranStage.Supplier_Country_2__c != null ? materialTranStage.Supplier_Country_2__c : '';
            
            String shippingTerm = materialTranStage.Purchase_Terms__c != null ? materialTranStage.Purchase_Terms__c : '';
            String freightCost = materialTranStage.Freight_cost_to_factory__c != null ? materialTranStage.Freight_cost_to_factory__c : '';
            String landedCost = materialTranStage.Landed_cost_to_factory__c != null ? materialTranStage.Landed_cost_to_factory__c : '';
            String uom = materialTranStage.UOM__c != null ? materialTranStage.UOM__c : '';
            String qty =materialTranStage.QTY__c != null ? String.valueOf(materialTranStage.QTY__c) : '';
            String purchaseCurrency = materialTranStage.Purchase_Currency__c != null ? materialTranStage.Purchase_Currency__c : '';
            String purchaseUnitPrice =materialTranStage.Purchase_Unit_Price__c != null ? String.valueOf(materialTranStage.Purchase_Unit_Price__c) : '';
            String purchasePrice = materialTranStage.Purchase_Price__c != null ? String.valueOf(materialTranStage.Purchase_Price__c) : '';
            String exRatetoUSD = materialTranStage.ExRate_To_USD__c != null ? materialTranStage.ExRate_To_USD__c : '';
            String exRatetoERU = materialTranStage.ExRate_To_EUR__c != null ? materialTranStage.ExRate_To_EUR__c : '';
            String expectedDeliveryDate = materialTranStage.Expected_Delivery_Date__c != null ? materialTranStage.Expected_Delivery_Date__c : '';
            String expectedDeliveryMonth = materialTranStage.Expected_Delivery_Month__c != null ? materialTranStage.Expected_Delivery_Month__c : '';
            String expectedDeliveryear = materialTranStage.Expected_Delivery_Year__c != null ? materialTranStage.Expected_Delivery_Year__c : '';
            String doubleQuoteItemCode = itemCode.replaceAll('"','""');
            String doubleQuoteProdDescripition =  productDescription.replaceAll('"','""');
            String doubleQuotePoNuumber = poNumber.replaceAll('"','""');
            String doubleQuoteLocalSupplierCode = localSupplierCode.replaceAll('"','""'); 
            
            
           String rowStr = '"'+ year + '","' + month + '","' + doubleQuotePoNuumber + '","' + company + '","' + poDate + '","' + material + '","' + grade + '","' + color + '","' + doubleQuoteItemCode + '","' +doubleQuoteProdDescripition + '","' + orderType + '","' + doublequotesSupplierName + '","' + doubleQuoteLocalSupplierCode + '","' + supplierCountry + '","'+shippingTerm+'","' +freightCost+'","'+landedCost+'","'+ uom + '","' + qty + '","' + purchaseCurrency + '","' + purchaseUnitPrice + '","' + purchasePrice + '","' +  exRatetoUSD + '","' + exRatetoERU + '","'  +expectedDeliveryDate + '","'  + expectedDeliveryMonth + '","' + expectedDeliveryear+'"';
            
          // String rowStr = '';
            csvRowValues.add(rowStr); 
        }
        materialTransStageForCSV = null;
        return csvRowValues;
    }  
    
}