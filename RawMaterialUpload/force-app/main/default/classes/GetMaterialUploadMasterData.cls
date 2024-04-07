public with sharing class GetMaterialUploadMasterData {
    
    //Akhilesh Mapping Error Field
 /*    
    ██████  ███████  ██████  ██    ██ ██ ██████  ███████ ██████  
    ██   ██ ██      ██    ██ ██    ██ ██ ██   ██ ██      ██   ██ 
    ██████  █████   ██    ██ ██    ██ ██ ██████  █████   ██   ██ 
    ██   ██ ██      ██ ▄▄ ██ ██    ██ ██ ██   ██ ██      ██   ██ 
    ██   ██ ███████  ██████   ██████  ██ ██   ██ ███████ ██████  
                        ▀▀                                       
                                                                 
  */

    // public  Map<string,Map<string,Map<string,string>>> getFullMaterialErrorMap() {        
        
    //     Map<string,Map<string,Map<string,string>>> materialErrorMap = new Map<string,Map<string,Map<string,string>>>();        
    //     list<Sales_Error_Mapping__c> mapData = [Select Company__c,Raw_Data_Field__c, Map_From_Value__c, Map_To_Value__c from     Where Status__c = 'Active' order by Company__c]; 
    //     for ( Sales_Error_Mapping__c mapVal : mapData ){
    //         if(String.isNotBlank(mapVal.Company__c)){
    //             if(materialErrorMap.containsKey(mapVal.Company__c)){
    //                 Map<string,Map<string,string>> rawDataFieldMap = materialErrorMap.get(mapVal.Company__c);
    //                 if(rawDataFieldMap.containsKey(mapVal.Raw_Data_Field__c)){                        
    //                     Map<string,string> mapFromToValueMap = rawDataFieldMap.get(mapVal.Raw_Data_Field__c);
    //                     String mapFromValue = mapVal.Map_From_Value__c;
    //                     mapFromToValueMap.put(mapFromValue.toLowerCase(),mapVal.Map_To_Value__c);
    //                     rawDataFieldMap.put(mapVal.Raw_Data_Field__c,mapFromToValueMap);
    //                     materialErrorMap.put(mapVal.Company__c,rawDataFieldMap);
    //                 }else{                            
    //                     Map<string,string> mapFromToValueMap = new Map<string,string>();
    //                     String mapFromValue = mapVal.Map_From_Value__c;
    //                     mapFromToValueMap.put(mapFromValue.toLowerCase(),mapVal.Map_To_Value__c);
    //                     rawDataFieldMap.put(mapVal.Raw_Data_Field__c,mapFromToValueMap);
    //                     materialErrorMap.put(mapVal.Company__c,rawDataFieldMap);
    //                 }                        
    //             }else{ 
    //                 Map<string,Map<string,string>> rawDataFieldMap = new Map<string,Map<string,string>>();
    //                 Map<string,string> mapFromToValueMap = new Map<string,string>();  
    //                 String mapFromValue = mapVal.Map_From_Value__c; 
    //                 mapFromToValueMap.put(mapFromValue.toLowerCase(),mapVal.Map_To_Value__c);
    //                 rawDataFieldMap.put(mapVal.Raw_Data_Field__c,mapFromToValueMap);
    //                 materialErrorMap.put(mapVal.Company__c,rawDataFieldMap);
    //             }
    //         }      
    //     }    
    //     system.debug('materialErrorMap ::'+materialErrorMap);
    //       system.debug('materialErrorMap ::'+materialErrorMap);
    //     return materialErrorMap;
    // }

    /* 
 ██████ ██       ██████  ███████ ███████ ██████  
 ██      ██      ██    ██ ██      ██      ██   ██ 
 ██      ██      ██    ██ ███████ █████   ██   ██ 
 ██      ██      ██    ██      ██ ██      ██   ██ 
  ██████ ███████  ██████  ███████ ███████ ██████  
                */                                   
                                                  
 

    // public  Map<string,string> getPickListMap(String objectName,String fieldName){
    
    //     Map<string,string> pickListValMap = new Map<string,string>();
    //     Schema.SObjectType tarType = Schema.getGlobalDescribe().get(objectName); 
    //     Sobject objectnamee = tarType.newSObject();                 
    //     Schema.sObjectType sobjecttype = objectnamee.getSObjectType(); 
    //     Schema.DescribeSObjectResult sobjectdescribe = sobjecttype.getDescribe(); 
    //     Map<String, Schema.SObjectField> fieldmap = sobjectdescribe.fields.getMap();        
    //     List<Schema.PicklistEntry> picklistvalues = fieldmap.get(fieldName).getDescribe().getPickListValues();        
    //     for (Schema.PicklistEntry a : picklistvalues) { 
    //         String colorPicklist = a.getValue();
    //         pickListValMap.put(colorPicklist.toUpperCase(),colorPicklist.toUpperCase());
    //        // system.debug('pickListValMap::::'+pickListValMap);
    //     }
    //     return pickListValMap;
    // }
    
    public   map<string,string> getManitteCompanyPicklistMap()
    {
        list<Partner__c> partner = new list<Partner__c>();
        Map<string,string> mainettiCompanyMap = new Map<string,string>();        
        partner = [SELECT  Name, Default_Order_to_Company__c 
        FROM Partner__c where Default_Order_to_Company__c != null and Partner_Status__c = 'Active' and  RecordType.Name in('Mainetti Company','Licensee Partner') 
        WITH SECURITY_ENFORCED order by Name]; 
        for ( Partner__c ptn : partner ){
            mainettiCompanyMap.put(ptn.Name,ptn.Default_Order_to_Company__c);            
        }             
        return mainettiCompanyMap;
    }
    public  Map<String, Map<String,String>> getPartnerSupplierNameMap()
    {
        Map<String, Map<String,String>> getPartnerSupplierNameMap = new Map<String, Map<String,String>>();
        list<Partner__c> partner = new list<Partner__c>();
        Map<string,string> companyNameCogsCountryMap = new Map<string,string>();        
        Map<string,string> companyNameCossIdMap = new Map<string,string>();        
        Map<string,string> companyNameSupplierCodeMap = new Map<string,string>();        
        Map<string,string> companyNameSupplierGroupMap = new Map<string,string>();        
        partner = [SELECT Id, Name,Country__c, Supplier_Code__c,Supplier_Group__c, RecordType.Name FROM Partner__c where Partner_Status__c = 'Active' AND RecordType.Name= 'Supplier' AND Country__c <> null WITH SECURITY_ENFORCED order by Name]; 
        for ( Partner__c ptn : partner ){
            // System.debug('map forloop'+ptn.Name+'#'+ptn.Country__c);
            String stringval = ptn.Name+'#'+ptn.Country__c;
            companyNameCogsCountryMap.put((stringval).toUpperCase(),ptn.Name);    
            companyNameCossIdMap.put((stringval).toUpperCase(), ptn.Id);
            companyNameSupplierCodeMap.put((stringval).toUpperCase(), ptn.Supplier_Code__c);
            companyNameSupplierGroupMap.put((stringval).toUpperCase(), ptn.Supplier_Group__c);
        }         
        getPartnerSupplierNameMap.put('companyNameCogsCountryMap',companyNameCogsCountryMap);    
        getPartnerSupplierNameMap.put('companyNameCossIdMap',companyNameCossIdMap);   
        // System.debug(companyNameSupplierCodeMap); 
        getPartnerSupplierNameMap.put('companyNameSupplierCodeMap',companyNameSupplierCodeMap);    
        getPartnerSupplierNameMap.put('companyNameSupplierGroupMap',companyNameSupplierGroupMap);    
        return getPartnerSupplierNameMap;
    }
    
     
    public List<Material_Transaction_Stage__c> getMaterialRows(String batchId){
        List<Material_Transaction_Stage__c> materialTransStagRec = new List<Material_Transaction_Stage__c>();
        if(!String.isBlank(batchId)){
            materialTransStagRec = [SELECT Record_Status__c, Year__c, Month__c, PO_Number__c, PO_Date__c, Material__c, Grade__c, Mainetti_Company__c, Purchase_Terms__c, Order_Type__c, Purchase_Currency__c, Supplier_Country_2__c, Landed_cost_to_factory__c,Freight_cost_to_factory__c, UOM__c, Color__c, Item_code__c, Product_Description__c, Supplier_Name__c,   Expected_Delivery_Date__c, Expected_Delivery_Month__c, Expected_Delivery_Year__c, Year_FB__c, Month_FB__c, PO_Number_FB__c, Mainetti_Company_FB__c, PO_Date_FB__c, Order_Type_FB__c, Supplier_Country_2_FB__c, Purchase_Terms_FB__c,Freight_cost_to_factory_FB__c,Landed_cost_to_factory_FB__c,UOM_FB__c, QTY_FB__c, Purchase_Currency_FB__c, Purchase_Unit_Price_FB__c, Purchase_Price_FB__c, ExRate_To_USD_FB__c, ExRate_To_EUR_FB__c, Expected_Delivery_Month_FB__c, Expected_Delivery_Year_FB__c,  QTY__c, Purchase_Unit_Price__c,  ExRate_To_USD__c, ExRate_To_EUR__c, Cogs_Country__c
            FROM Material_Transaction_Stage__c where Upload_Batch_No__c=:batchId WITH SECURITY_ENFORCED ];
        }
        // System.debug('<<<getMaterialStageRow Querry>>>'+ materialTransStagRec);
        return materialTransStagRec; 
    }
   public List<Material_Transaction_Stage__c> getMaterialStageRowsByPage(List<Material_Transaction_Stage__c> materialTransStagRecAfterReconciliation,String batchId, string selcomp,string selMonth,string selYear, Inventory_Transaction_Master__c updateBatchStatus, validateMaterialUploadRowsBulk.recordValidationStatus recordStatus ){
       System.debug('parameters recieved at rows By Page return call');
       System.debug(materialTransStagRecAfterReconciliation);
       System.debug( batchId+':'+  selcomp+':'+  selMonth+':'+  selYear+':'+ updateBatchStatus+':'+  recordStatus);
        return new ProcessMaterialUploadData().processMaterialDataChunk(materialTransStagRecAfterReconciliation, batchId, selcomp, selMonth, selYear,updateBatchStatus, recordStatus);     
    }  

    // Control will come here from validateMaterialUploadRowsBulk
    public List<Material_Transaction_Stage__c> preValidationMaterialStageDataByPage(List<Material_Transaction_Stage__c> materialTransStagRecForReconciliation,String batchId, String selcomp,String selMonth,String selYear, Inventory_Transaction_Master__c updateBatchStatus, validateMaterialUploadRowsBulk.recordValidationStatus recordStatus,Map<string, Map<string,Map<string,string>>> fullMaterialErrorMap){
        // System.debug('1st entry PrevalidationMaterialStageDataByPage');
        List<Material_Transaction_Stage__c> reconcilseData = new ProcessMaterialUploadData().reconcileDataWithMaterialErrorMapBulk(materialTransStagRecForReconciliation, fullMaterialErrorMap);        
        System.debug('parameters recieved'+ reconcilseData); 
        System.debug('Batch details'+batchId+':'+  selcomp+':'+  selMonth+':'+  selYear+':'+  updateBatchStatus+':'+  recordStatus);
        List<Material_Transaction_Stage__c> finalUpdateData= getMaterialStageRowsByPage(reconcilseData, batchid,  selcomp, selMonth, selYear,updateBatchStatus,recordStatus);
        System.debug('FINAL uPLADE DATA');
        System.debug(finalUpdateData);
        return finalUpdateData;  
    }
    
    public List<Material_Transaction_Stage__c> preValidationMaterialStageData(string batchid){
        // System.debug('batchid'+batchid);
        
        List<Material_Transaction_Stage__c> fetchSuccessdata=[SELECT Record_Status__c, Year__c, Color__c, Material__c, Grade__c, Mainetti_Company__c, Purchase_Terms__c, Order_Type__c,Supplier_Country_2__c, UOM__c,Landed_cost_to_factory__c, Freight_cost_to_factory__c,Purchase_Currency__c, Month__c, PO_Number__c , PO_Date__c, Item_code__c, Product_Description__c,  Supplier_Name__c,   Expected_Delivery_Date__c, Expected_Delivery_Month__c, Expected_Delivery_Year__c, Year_FB__c, Month_FB__c, PO_Number_FB__c, Mainetti_Company_FB__c, PO_Date_FB__c, Order_Type_FB__c, Supplier_Country_2_FB__c, Purchase_Terms_FB__c,Freight_cost_to_factory_FB__c,Landed_cost_to_factory_FB__c, UOM_FB__c, QTY_FB__c, Purchase_Currency_FB__c, Purchase_Unit_Price_FB__c, Purchase_Price_FB__c, ExRate_To_USD_FB__c, ExRate_To_EUR_FB__c, Expected_Delivery_Month_FB__c, Expected_Delivery_Year_FB__c, Product_Category__c, Purchase_Price__c, QTY__c, Purchase_Unit_Price__c,  ExRate_To_USD__c, ExRate_To_EUR__c
        FROM Material_Transaction_Stage__c WHERE Upload_Batch_No__c=:batchId WITH SECURITY_ENFORCED ]; 
        // System.debug('<<<<preValidationMaterialStageData Querry>>>'+ fetchSuccessdata);
        
        return fetchSuccessdata;
    }

    public Map<string,string> checkCompMonthYear(String selcomp)
     {
         
         Map<string,string> checkCompMonthYear = new Map<string,string>();
         string compmonthyear = 'select Mainetti_Company__c ,Month__c, Year__c from  Material_upload__c Where Mainetti_Company__c = : selcomp GROUP BY Mainetti_Company__c,Month__c,Year__c';
         for (AggregateResult cwemonyear :  Database.Query(compmonthyear)){                 
             string comyearmonth = (cwemonyear.get('Mainetti_Company__c'))+'#'+(cwemonyear.get('Month__c'))+'#'+cwemonyear.get('Year__c');
             comyearmonth = comyearmonth.toUpperCase(); 
             checkCompMonthYear.put(comyearmonth, comyearmonth);
         }
         return checkCompMonthYear;
     }

    /*Reterieveing the file from  the contentverion for upload into Azure */
    public  List<ContentVersion> getContentDocumentVerIds(String batchId){
        List<ContentVersion> contVer = new List<ContentVersion>();
        ContentDocumentLink[] contentLink = [SELECT ContentDocumentId FROM ContentDocumentLink where LinkedEntityId=:batchId WITH SECURITY_ENFORCED ];
        set<Id> docId = new set<Id>();
        for(ContentDocumentLink contentLin : contentLink){
            docId.add(contentLin.ContentDocumentId);
        }
        if(contentLink.size()>0){
            contVer = [SELECT Id,PathOnClient FROM ContentVersion WHERE ContentDocumentId in :docId
                       AND IsLatest = true WITH SECURITY_ENFORCED order by createdDate asc ];            
        } 
        return contVer;        
    }
    

    
    public  ContentVersion getCSVFile(String batchId){
        ContentVersion contVer = new ContentVersion();
        ContentDocumentLink[] contentLink = [SELECT ContentDocumentId from ContentDocumentLink where LinkedEntityId=:batchId WITH SECURITY_ENFORCED];
        set<Id> docId = new set<Id>();
        for(ContentDocumentLink contentLin : contentLink){
            docId.add(contentLin.ContentDocumentId);
        }
        if(contentLink.size()>0){
            contVer = [SELECT Title, VersionData, PathOnClient, FileType FROM ContentVersion WHERE ContentDocumentId in :docId
                       AND IsLatest = true WITH SECURITY_ENFORCED order by createdDate desc limit 1];            
        } 
        return contVer;        
    }
    
    /*Deleting the csv file from the content version if the file created date is < today old, files will be deleted*/
    public boolean deleteCSVFile(String batchId){
        boolean delStatus = true;       
        try{
            list<ContentDocument> contentList = new list<ContentDocument>();
            ContentDocument[] content = [SELECT Id, Title, FileExtension, CreatedDate FROM ContentDocument USING SCOPE Everything where (title = 'MaterailUserUploadedCSVFile' OR title = 'MaterialSuccessCSVFile') WITH SECURITY_ENFORCED];
            Date today = system.Today();
            for ( ContentDocument cont : content ){ 
                Datetime recCreateDt = cont.CreatedDate;
                Date startDateParsed = date.newinstance(recCreateDt.year(), recCreateDt.month(), recCreateDt.day());                
              //  if(cont.Title == 'Inventory Data File Uplaod'){
                    if(startDateParsed < today){  
                        contentList.add(cont);
                    }
               // }                   
            }   
            // system.debug('contentList.size:::::'+contentList.size());
            if(contentList.size()>0){
                if (Schema.sObjectType.ContentDocument.isDeletable()) {
                    delete contentList;

                }
                
            }
        }catch(DMLException ex){
            delStatus = false;
            // System.debug('Error during deleteCSVFile'+EX.getMessage());         
        }       
        return delStatus;        
    }    
    
    public  Map<string,Map<string,Map<string,string>>> getMaterialErrorMap() {        
        
        Map<string,Map<string,Map<string,string>>> materialErrorMap = new Map<string,Map<string,Map<string,string>>>();        
        list<Sales_Error_Mapping__c> mapData = [SELECT Company__c,Raw_Data_Field__c, Map_From_Value__c, Map_To_Value__c FROM Sales_Error_Mapping__c Where Status__c = 'Active' WITH SECURITY_ENFORCED order by Company__c]; 
        for ( Sales_Error_Mapping__c mapVal : mapData ){
            if(String.isNotBlank(mapVal.Company__c)){
                if(materialErrorMap.containsKey(mapVal.Company__c)){
                    Map<string,Map<string,string>> rawDataFieldMap = materialErrorMap.get(mapVal.Company__c);
                    if(rawDataFieldMap.containsKey(mapVal.Raw_Data_Field__c)){                        
                        Map<string,string> mapFromToValueMap = rawDataFieldMap.get(mapVal.Raw_Data_Field__c);
                        String mapFromValue = mapVal.Map_From_Value__c;
                        mapFromToValueMap.put(mapFromValue.toLowerCase(),mapVal.Map_To_Value__c);
                        rawDataFieldMap.put(mapVal.Raw_Data_Field__c,mapFromToValueMap);
                        materialErrorMap.put(mapVal.Company__c,rawDataFieldMap);
                    }else{                            
                        Map<string,string> mapFromToValueMap = new Map<string,string>();
                        String mapFromValue = mapVal.Map_From_Value__c;
                        mapFromToValueMap.put(mapFromValue.toLowerCase(),mapVal.Map_To_Value__c);
                        rawDataFieldMap.put(mapVal.Raw_Data_Field__c,mapFromToValueMap);
                        materialErrorMap.put(mapVal.Company__c,rawDataFieldMap);
                    }                        
                }else{ 
                    Map<string,Map<string,string>> rawDataFieldMap = new Map<string,Map<string,string>>();
                    Map<string,string> mapFromToValueMap = new Map<string,string>();  
                    String mapFromValue = mapVal.Map_From_Value__c; 
                    mapFromToValueMap.put(mapFromValue.toLowerCase(),mapVal.Map_To_Value__c);
                    rawDataFieldMap.put(mapVal.Raw_Data_Field__c,mapFromToValueMap);
                    materialErrorMap.put(mapVal.Company__c,rawDataFieldMap);
                }
            }      
        }    
        //system.debug('materialErrorMap ::'+materialErrorMap);
          //system.debug('materialErrorMap ::'+materialErrorMap);
        return materialErrorMap;
    } 
    
    
    public   List<string> partnerCompany()
    {
        list<Partner__c> partner = new list<Partner__c>();
        List<string> partnerCompanyList = new List<string>();        
        partner = [SELECT  Name, Default_Order_to_Company__c 
        FROM Partner__c where Name ='Others' and Default_Order_to_Company__c != null and Partner_Status__c = 'Active' and  RecordType.Name in('Mainetti Company','Licensee Partner') WITH SECURITY_ENFORCED order by Name]; 
        for ( Partner__c ptn : partner ){
            partnerCompanyList.add(ptn.Name);            
        }             
        return partnerCompanyList;
    }
    
    
    public   map<string,string> getModelConsolidateMap()
    {
        list<Product__c> model = new list<Product__c>();
        Map<string,string> modelConsolidateMap = new Map<string,string>();        
        model = [SELECT Consolidated_Style__c FROM Product__c where Consolidated_Style__c <> null WITH SECURITY_ENFORCED ]; 
        for ( Product__c mod : model ){ 
            modelConsolidateMap.put(mod.Consolidated_Style__c.toLowerCase(),mod.Consolidated_Style__c.toLowerCase());            
        }             
        return modelConsolidateMap;
    }
    
    // Category
    // public   map<string,string> getCategoryBusinessVerticalMap()
    // {
    //     list<Product__c> category = new list<Product__c>();
    //     Map<string,string> categoryBusinessVerticalMap = new Map<string,string>();        
    //     category = [SELECT Business_Vertical__c FROM Product__c where Business_Vertical__c <> null WITH SECURITY_ENFORCED ]; 
    //     for ( Product__c cat : category ){
    //         categoryBusinessVerticalMap.put(cat.Business_Vertical__c.toLowerCase(),cat.Business_Vertical__c.toLowerCase());            
    //     }             
    //     return categoryBusinessVerticalMap;
    // }
    // Model,category,sub-category and family composite key.
        //add by alvin 23-7-2020 End
        /*add by alvin 3-9-2020 Start 

        String hangerOther = 'Hangers & Accessories'+'#'+ 'HANGERS' +'#'+'OTHERS';
        String hangerOtherFull = 'Hangers & Accessories'+'#'+ 'HANGERS' +'#'+ 'PLASTIC HANGERS' +'#'+'OTHERS';
        modelCompositeKeyMap1.put(hangerOther.trim().toLowerCase(),hangerOtherFull); 

        String accessoriesOther = 'Hangers & Accessories'+'#'+ 'ACCESSORIES' +'#'+'OTHERS';
        String accessoriesOtherFull = 'Hangers & Accessories'+'#'+ 'ACCESSORIES' +'#'+ 'ACCESSORIES' +'#'+'OTHERS';
        modelCompositeKeyMap1.put(accessoriesOther.trim().toLowerCase(),accessoriesOtherFull); 

        String hangerOtherOther = 'Hangers & Accessories'+'#'+ 'OTHERS' +'#'+'OTHERS';
        String hangerOtherOtherFull = 'Hangers & Accessories'+'#'+ 'OTHERS' +'#'+'OTHERS'+'#'+'OTHERS';
        modelCompositeKeyMap1.put(hangerOtherOther.trim().toLowerCase(),hangerOtherOtherFull);
        
        String hangerWHangerOther = 'Hangers & Accessories'+'#'+ 'WHANGERS' +'#'+'OTHERS';
        String hangerWHangerOtherFull = 'Hangers & Accessories'+'#'+ 'HANGERS' +'#'+'WOODEN HANGERS'+'#'+'OTHERS';
        modelCompositeKeyMap1.put(hangerWHangerOther.trim().toLowerCase(),hangerWHangerOtherFull); 
        //add by alvin 3-9-2020 End
        //add by alvin 23-10-2020 Start 
        String hangerMHangerOther = 'Hangers & Accessories'+'#'+ 'MHANGERS' +'#'+'OTHERS';
        String hangerMHangerOtherFull = 'Hangers & Accessories'+'#'+ 'HANGERS' +'#'+'METAL HANGERS'+'#'+'OTHERS';
        modelCompositeKeyMap1.put(hangerMHangerOther.trim().toLowerCase(),hangerMHangerOtherFull); 
        //add by alvin 23-10-2020 End*/
        
      
 
    
    
    
    // Vendor, Division, Brand, Label CompositeKey map with Label_Division__c Object.
            
    

    /*** Creating an temporary storage of the csv file before it is moved into Azure*/
    public boolean createDocument(String batchId,String csvJason,String fileName,String contVerTitle){
        
        boolean insertStatus = true;
        try{            
            ContentVersion invenotryFile = new ContentVersion();
            invenotryFile.ContentLocation = 'S';
            invenotryFile.VersionData = Blob.valueOf(csvJason);
            invenotryFile.Title = contVerTitle;
            invenotryFile.PathOnClient = fileName;
            if (Schema.sObjectType.ContentVersion.isCreateable()) {
                insert invenotryFile;
            }            
            csvJason = null;
            ContentVersion inventoryVerContent = [SELECT id, ContentDocumentId FROM ContentVersion where Id = :invenotryFile.Id WITH SECURITY_ENFORCED ];            
            ContentDocumentLink contentlink=new ContentDocumentLink();
            contentlink.LinkedEntityId=batchid;
            contentlink.ShareType= 'V';
            contentlink.ContentDocumentId=inventoryVerContent.ContentDocumentId;
            if (Schema.sObjectType.ContentDocumentLink.isCreateable()) {
                insert contentlink;           
            }               
        }catch(DMLException ex){
            insertStatus = false;
        }   
        return insertStatus;
    }
    
    

    
    
  /*   public Map<String,String> getParterCmpyRegion(){
       // String recCount='';    
          Map<String,String> salesCompanyRegionMap = new Map<String,String>();
        List<Partner__c> groupedResults = [Select Name, Default_Order_to_Company__c,Sales_Data_Company__c,Region__c from Partner__c where  Sales_Data_Company__c <> null and Region__c <> null and Partner_Status__c = 'Active' and  RecordType.Name in('Mainetti Company','Licensee Partner')]; 
        for (Partner__c partner : groupedResults)  {
            salesCompanyRegionMap.put(partner.Sales_Data_Company__c, partner.Region__c);
        }      
          //recCount = groupedResults.Region__c;
           //system.debug('salesCompanyRegionMap ::'+salesCompanyRegionMap);
          return salesCompanyRegionMap ;
    }  */
            /* 
    
██    ██ ███████ ███████ ██████  
██    ██ ██      ██      ██   ██ 
██    ██ ███████ █████   ██   ██ 
██    ██      ██ ██      ██   ██ 
 ██████  ███████ ███████ ██████  
                                 
                                 

    */
    
    public  Map<String,Map<String,String>> getParterCmpyRegionNCogsCountryNComapnyGroupName(){
         
        Map<String,String> salesCompanyRegionMap = new Map<String,String>();
        Map<String,String> salesCogsCountryMap = new Map<String,String>();
        // Map<String,String> salesCompanyGroupNameMap = new Map<String,String>();
        // Map<String,String> partnerCogsCountryMap = new Map<String,String>();

        Map<String,Map<String,String>>  salesCogsCountryAndCountryGroupMap = new  Map<String,Map<String,String>>();
      
      List<Partner__c> groupedResults = [SELECT Name,Region__c , Cogs_Country__c , Company_Group_Name__c ,Sales_Data_Company__c FROM Partner__c where  Sales_Data_Company__c <> null and Region__c <> null and Cogs_Country__c <> null and Company_Group_Name__c <> null and Partner_Status__c = 'Active' and  RecordType.Name in('Mainetti Company','Licensee Partner') WITH SECURITY_ENFORCED ]; 
    //   System.debug(groupedResults);
      for (Partner__c partner : groupedResults)  {
          salesCompanyRegionMap.put(partner.Sales_Data_Company__c, partner.Region__c);
          salesCogsCountryMap.put(partner.Sales_Data_Company__c, partner.Cogs_Country__c);
        //   salesCompanyGroupNameMap.put(partner.Sales_Data_Company__c, partner.Sales_Data_Company__c);
        //   partnerCogsCountryMap.put(partner.Cogs_Country__c, partner.Cogs_Country__c);
      }      
    //   system.debug('salesCogsCountryMap ::'+salesCogsCountryMap);
    //   system.debug('salesCompanyGroupNameMap ::'+salesCompanyGroupNameMap);
    //   System.debug('partnerCogsCountryMap'+partnerCogsCountryMap);
      salesCogsCountryAndCountryGroupMap.put('salesCompanyRegionMap' , salesCompanyRegionMap);
      salesCogsCountryAndCountryGroupMap.put('salesCogsCountryMap' , salesCogsCountryMap);
    //   salesCogsCountryAndCountryGroupMap.put('salesCompanyGroupNameMap' , salesCompanyGroupNameMap);
    //   salesCogsCountryAndCountryGroupMap.put('partnerCogsCountryMap', partnerCogsCountryMap);
    //   system.debug('salesCogsCountryAndCountryGroupMap ::'+salesCogsCountryAndCountryGroupMap);		
        return salesCogsCountryAndCountryGroupMap ;
  }

        /* 
    
██    ██ ███████ ███████ ██████  
██    ██ ██      ██      ██   ██ 
██    ██ ███████ █████   ██   ██ 
██    ██      ██ ██      ██   ██ 
 ██████  ███████ ███████ ██████  
                                 
                                 

    */

    //From product Object 
    public Map<String,Map<String,String>> getMatchingProduct(){
        List<Product__c> resultProduct = [SELECT Id, Name, Business_Vertical__c, M_Material__c,Product_Catagory__c, Color__c, Grade__c FROM product__c WHERE Business_Vertical__c <> null  AND M_Material__c <> null  AND Name Like '%Material%' AND Status__c='Inactive' WITH SECURITY_ENFORCED ];
        System.debug(LoggingLevel.DEBUG, resultProduct);
        Map<String,Map<String,String>> getProductMap = new Map<String,Map<String,String>>();
        Map<String,String> materialNGradeNColorMap = new Map<String,String>();
        // Map<String,String> materialProductCategoryMap = new Map<String,String>();
        Map<String,String> materialMaterialMap = new Map<String,String>();
        // Map<String,String> companyProductCategoryMap = new Map<String,String>();
        Map<String,String> productIDMatGradCol = new Map<String,String>();
        Map<String,String> productIDMatGradColName = new Map<String,String>();
        Map<String,String> gradeTypeMap = new Map<String,String>();

        for (Product__c product : resultProduct) {
            String materialNGradeNColor = product.M_Material__c+'#'+product.Grade__c+'#'+product.Color__c;
            // System.debug(materialNGradeNColor);
            // System.debug(materialNGradeNColorMap);
            materialNGradeNColorMap.put(materialNGradeNColor, product.Name);
            
            // materialProductCategoryMap.put(product.M_Material__c, product.Product_Catagory__c);
            productIDMatGradCol.put(materialNGradeNColor, product.Id);
            productIDMatGradColName.put(materialNGradeNColor, product.Name);
            if((product.Grade__c=='REGRIND') || (product.Grade__c=='COMPOUND')|| (product.Grade__c=='VICS COMPOUND') || (product.Grade__c=='METAL FREE COMPOUND') || (product.Grade__c=='POLYLOOP') ){
                gradeTypeMap.put(product.Grade__c, 'RECYCLED');
            }else {
                gradeTypeMap.put(product.Grade__c, 'NEW');
            }
        } 
        
		Schema.DescribeFieldResult fieldResult = product__c.M_Material__c.getDescribe();
		List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
		for( Schema.PicklistEntry pickListVal : ple){
            materialMaterialMap.put(pickListVal.getLabel(), pickListVal.getLabel());
		}     
		
        getProductMap.put('materialNGradeNColorMap', materialNGradeNColorMap);
        // getProductMap.put('materialProductCategoryMap', materialProductCategoryMap);
        getProductMap.put('productIDMatGradCol', productIDMatGradCol);
        getProductMap.put('productIDMatGradColName', productIDMatGradColName);
        getProductMap.put('gradeTypeMap', gradeTypeMap);
        getProductMap.put('materialMaterialMap', materialMaterialMap);
        // System.debug(materialNGradeNColorMap);
        return getProductMap;
    }
    
            /* 
    
██    ██ ███████ ███████ ██████  
██    ██ ██      ██      ██   ██ 
██    ██ ███████ █████   ██   ██ 
██    ██      ██ ██      ██   ██ 
 ██████  ███████ ███████ ██████  
                                 
                                 
    
    */

    public Map<String,String> getMonthMMM(){
        Map <String, String> monthString = new Map <String, String> {'Jan'=>'Jan', 'Feb'=>'Feb'
        , 'Mar'=>'Mar', 'Apr'=>'Apr', 'May'=>'May', 'Jun'=>'Jun', 'Jul'=>'Jul', 'Aug'=>'Aug', 'Sep'=>'Sep'
        , 'Oct'=>'Oct', 'Nov'=>'Nov', 'Dec'=>'Dec'}; 
           /*   */
        return monthString;
    }
    
   /*  public Map<String,Map<String,String>> getMaterialUploadMap(){

        List<Material_upload__c> resultMaterialUpload = [SELECT Material__c, Grade__c,  Order_Type__c, Color__c FROM Material_upload__c];

        Map<String,Map<String,String>> getMaterialUploadMap =  new Map<String,Map<String,String>>();
        // Map<String,Map<String,String>> getMaterialtoGradeMap =  new Map<String,Map<String,String>>();
        // Map<String,Map<String,String>> getGradetoColorMap =  new Map<String,Map<String,String>>();
        Map<String, String> materialUploadMaterialMap = new Map<String, String>();
        // Map<String, String> fieldtoFieldMap  = new Map<String, String>();
        
        // Map<String, String> colortoColorMap = new Map<String, String>();
        for (Material_upload__c materialUpload : resultMaterialUpload) {
            materialUploadMaterialMap.put(materialUpload.Material__c, materialUpload.Material__c);
           
        }
        System.debug('materialUploadMaterialMap: '+materialUploadMaterialMap);
        System.debug('fieldtoFieldMap : '+fieldtoFieldMap );
        System.debug('colortoColorMap: '+colortoColorMap);
        getMaterialUploadMap.put('materialUploadMaterialMap', materialUploadMaterialMap);
        // System.debug('getMaterialUploadMap material upload map'+getMaterialUploadMap);

        // getMaterialUploadMap.put('fieldtoFieldMap ', fieldtoFieldMap );
        // getMaterialUploadMap.put('colortoColorMap', colortoColorMap);
        System.debug('return Map'+getMaterialUploadMap);

        return getMaterialUploadMap;
    } */

    public Map<String,String> getPickListValuesIntoMap(Schema.DescribeFieldResult objval){
        Map<String,String> pickListValuesMap= new Map<String,String>();
        List<Schema.PicklistEntry> ple = objval.getPicklistValues();
        if(!(ple.isEmpty())){
            for (Schema.PicklistEntry var : ple) {
                pickListValuesMap.put((var.getValue()).toUpperCase(), (var.getLabel()).toUpperCase());
            }
        }
         return pickListValuesMap;
     }

    public Map<Object,Map<String,String>> getDependentPicklistMap(Schema.sObjectField objectval){
        //Code Bharath

        Schema.sObjectField dependentField = objectval;
        Map<Object,Map<String,String>> dependentPicklistValues = new Map<Object,Map<String,String>>();
        //Get dependent field result
        Map<String, String> fieldtoFieldMap  = new Map<String, String>();
        // Map<String, String> materialtoMaterialMap = new Map<String, String>();
        Schema.DescribeFieldResult dependentFieldResult = dependentField.getDescribe();
        //Get dependent field controlling field
        Schema.sObjectField controllerField = dependentFieldResult.getController();
        //Check controlling field is not null

        //Get controlling field result
        Schema.DescribeFieldResult controllerFieldResult = controllerField.getDescribe();
        //Get controlling field picklist values if controlling field is not a checkbox
        List<Schema.PicklistEntry> controllerValues = (controllerFieldResult.getType() == Schema.DisplayType.Boolean ? null : controllerFieldResult.getPicklistValues());
        //It is used to decode the characters of the validFor fields.
        String base64map = 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/';
        for (Schema.PicklistEntry entry : dependentFieldResult.getPicklistValues()){
            if (entry.isActive()){
                //The PicklistEntry is serialized and deserialized using the Apex JSON class and it will check to have a 'validFor' field
                List<String> base64chars = String.valueOf(((Map<String,Object>)JSON.deserializeUntyped(JSON.serialize(entry))).get('validFor')).split('');
                for (Integer i = 0; i < controllerValues.size(); i++){
                    Object controllerValue = (controllerValues == null ? (Object) (i == 1) : (Object) (controllerValues[i].isActive() ? controllerValues[i].getLabel() : null));
                    // System.debug('dependentPicklistValues'+dependentPicklistValues);
                    // System.debug('controllerValue'+controllerValue);
                    Integer bitIndex = i / 6;
                    Integer bitShift = 5 - Math.mod(i, 6 );
                    if(controllerValue == null || (base64map.indexOf(base64chars[bitIndex]) & (1 << bitShift)) == 0){
                        continue;
                    }
                    // System.debug('controllerValueString'+controllerValue);
                    if (!dependentPicklistValues.containsKey(controllerValue)){
                        dependentPicklistValues.put(controllerValue, new Map<String,String>());
                    }
                    fieldtoFieldMap .put(entry.getLabel(),entry.getLabel());
                    // System.debug('fieldtoFieldMap :'+fieldtoFieldMap );
                    dependentPicklistValues.get(controllerValue).put(entry.getLabel(),entry.getLabel());
                }
            }
        }
        // System.debug('materialtoMaterialMap'+materialtoMaterialMap);
        // system.debug('dependentPicklistValues ::'+dependentPicklistValues);
        // system.debug('fieldtoFieldMap ::'+fieldtoFieldMap );
        dependentPicklistValues.put('fieldtoFieldMap', fieldtoFieldMap);
        return dependentPicklistValues;
    }

    

    //Used ACS
    /* 
██    ██ ███████ ███████ ██████  
██    ██ ██      ██      ██   ██ 
██    ██ ███████ █████   ██   ██ 
██    ██      ██ ██      ██   ██ 
 ██████  ███████ ██
    */

    public List<String> getMaterialUploadOrdertypePicklist(){
        List<String> pickListValuesList= new List<String>();
         Schema.DescribeFieldResult fieldResult = Material_upload__c.Order_Type__c.getDescribe();
         List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
         for( Schema.PicklistEntry pickListVal : ple){
             pickListValuesList.add(pickListVal.getLabel());
         }     
         return pickListValuesList;
     }

/* 


██    ██ ███████ ███████ ██████  
██    ██ ██      ██      ██   ██ 
██    ██ ███████ █████   ██   ██ 
██    ██      ██ ██      ██   ██ 
 ██████  ███████ ███████ ██████  
                                 
           testing dependent picklist                      

    //END of dependent pick list


     /* Requires ACS Reterieveing the file from  the contentverion for upload into Azure */
    
    public  List<ContentVersion> getContentDocumentVerIds(String batchId,String conVerTitle){
        //  system.debug('batchId ::'+batchId);
        //  system.debug('conVerTitle ::'+conVerTitle);
        List<ContentVersion> contVer = new List<ContentVersion>();
        ContentDocumentLink[] contentLink = [SELECT ContentDocumentId FROM ContentDocumentLink where LinkedEntityId=:batchId WITH SECURITY_ENFORCED ];
        set<Id> docId = new set<Id>();
        for(ContentDocumentLink contentLin : contentLink){
            docId.add(contentLin.ContentDocumentId);
            //system.debug('docId ::'+docId);            
        }
        // system.debug('docId ::'+contentLink.size()); 
        if(contentLink.size()>0){
            contVer = [SELECT Id,PathOnClient FROM ContentVersion WHERE ContentDocumentId in:docId AND IsLatest = true AND Title =:conVerTitle WITH SECURITY_ENFORCED order by createdDate asc ];            
        } 
        // system.debug('contVer ::'+contVer.size());
        return contVer;        
    }
     
     // Requires ACS
    public  ContentVersion getCSVFileContent(ContentVersion contentVerson){
        ContentVersion contVer = [SELECT Title, VersionData, PathOnClient, FileType 
        FROM ContentVersion WHERE IsLatest = true AND id=:contentVerson.Id  WITH SECURITY_ENFORCED limit 1];
        return contVer;
    }

}