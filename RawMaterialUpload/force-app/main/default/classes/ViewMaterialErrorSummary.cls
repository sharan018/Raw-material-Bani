public with sharing class ViewMaterialErrorSummary {

        @AuraEnabled
    public static ReturnWrapperObj  fetchErrorCount(String batchID) {
        ReturnWrapperObj wrapObj = new ReturnWrapperObj();  
        List<Sales_Error_Code__c> missingFieldErrorcode;
        if(
            Sales_Error_Code__c.SObjectType.getDescribe().isAccessible()
        ) {

        missingFieldErrorcode = [SELECT Error_Description__c ,Error_Message__c , Error_Type__c , Error_Detail_Report_Link__c FROM Sales_Error_Code__c where Error_Type__c = 'Missing Field' and Record_Code_Type__c = 'Material Upload' and Active__c = true and Error_Description__c != Null WITH SECURITY_ENFORCED];
        }
        //  system.debug('missingFieldErrorcode >>>>>'+missingFieldErrorcode);
        String query = 'SELECT '; 
        List<String> stringlst = new  List<String>();
        Map<String,String> missingReportLinkMap = new  Map<String,String>();
        for( Sales_Error_Code__c materialErrorCodeList : missingFieldErrorcode){
            System.debug(materialErrorCodeList.Error_Description__c);
            stringlst.add(materialErrorCodeList.Error_Description__c);
            System.debug('values in map');
            System.debug(materialErrorCodeList.Error_Message__c+'='+materialErrorCodeList.Error_Detail_Report_Link__c);
            missingReportLinkMap.put(materialErrorCodeList.Error_Message__c, materialErrorCodeList.Error_Detail_Report_Link__c);
        }
        // system.debug('missingReportLinkMap >>>>>>'+missingReportLinkMap);
        query +=  String.join(stringlst, ',');
        //  system.debug('query >>>>>'+query) ;
        query +=  ' FROM Material_Transaction_Stage__c WHERE Upload_Batch_No__c=:batchID';
        //  system.debug('query >>>>>'+query);
        AggregateResult lstofErrorCOunt;
         if( Material_Transaction_Stage__c.SObjectType.getDescribe().isAccessible()){
             lstofErrorCOunt = Database.query(query); 
        }
        // system.debug('lstofErrorCOunt >>>>>>'+lstofErrorCOunt);
        Inventory_Transaction_Master__c invTrnasMaster;   
        if (Schema.sObjectType.Inventory_Transaction_Master__c.isAccessible()) { 
            invTrnasMaster = [SELECT Batch_No__c ,Sales_Month__c ,Sales_Year__c ,Sales_Company__c ,Total_Row_Count__c FROM Inventory_Transaction_Master__c where  Id=:batchID WITH SECURITY_ENFORCED];       
        }
        Integer totalUploadedCount = [SELECT Count() FROM Material_Transaction_Stage__c WHERE Upload_Batch_No__c=:batchID WITH SECURITY_ENFORCED];        
        Integer missingfieldCount = [SELECT Count() FROM Material_Transaction_Stage__c WHERE  Upload_Batch_No__c =: batchId  AND ( Year_FB__c = true OR Month_FB__c = true OR PO_Number_FB__c = true OR  Mainetti_Company_FB__c= true OR 	Supplier_Country_2_FB__c=true OR PO_Date_FB__c = true OR Item_code_local_FB__c = true OR Order_Type_FB__c = true OR Purchase_Terms_FB__c = true OR Freight_cost_to_factory_FB__c = true OR Landed_cost_to_factory_FB__c = true OR UOM_FB__c = true OR QTY_FB__c = true OR Purchase_Currency_FB__c = true OR Purchase_Unit_Price_FB__c = true OR Purchase_Price_FB__c = true OR ExRate_To_USD_FB__c = true OR ExRate_To_EUR_FB__c = true OR  Expected_Delivery_Month_FB__c = true OR Expected_Delivery_Year_FB__c = true OR Error_Code__c <> NUll) WITH SECURITY_ENFORCED];
        
        List< MaterialErrorNameCountObjWrapper> materialErrorNameCountObjlist = new list<MaterialErrorNameCountObjWrapper>();
        for( Sales_Error_Code__c lst :missingFieldErrorcode){
            MaterialErrorNameCountObjWrapper materialErrorNameCountObj = new MaterialErrorNameCountObjWrapper();
            materialErrorNameCountObj.name = lst.Error_Message__c;
            System.debug(lst);

            System.debug(lst.Error_Message__c);
            materialErrorNameCountObj.count = Integer.valueOf(lstofErrorCOunt.get(lst.Error_Message__c));
            materialErrorNameCountObj.reportLink = missingReportLinkMap.get(lst.Error_Message__c);
            if( materialErrorNameCountObj.Count != null && materialErrorNameCountObj.Count > 0){
                materialErrorNameCountObjlist.add(materialErrorNameCountObj);
            }
        }
        InventroyTrnasMaster invTrnMaster = new InventroyTrnasMaster();        
        invTrnMaster.batchNo = invTrnasMaster.Batch_No__c;
        invTrnMaster.company = invTrnasMaster.Sales_Company__c;
        invTrnMaster.month = invTrnasMaster.Sales_Month__c;
        invTrnMaster.year = invTrnasMaster.Sales_Year__c;
        invTrnMaster.totalRecordCount = totalUploadedCount;
        invTrnMaster.totalSuccesCount = totalUploadedCount - missingfieldCount;
        
        wrapObj.salesErrorNameCount = materialErrorNameCountObjlist;
        wrapObj.invntryTransMaster = invTrnMaster;
        return wrapObj;
    }
    
    
    public class ReturnWrapperObj {
        @AuraEnabled
        public List<MaterialErrorNameCountObjWrapper> salesErrorNameCount {get;set;} 
        @AuraEnabled
        public InventroyTrnasMaster invntryTransMaster {get;set;} 
    }
    
    public class MaterialErrorNameCountObjWrapper {
        
        @AuraEnabled public String  name {get;set;}
        @AuraEnabled public Integer count {get;set;}
        @AuraEnabled public String reportLink {get;set;}
    }
    
    
    public class InventroyTrnasMaster{
        
        @AuraEnabled public String  batchNo {get;set;}
        @AuraEnabled public Integer totalRecordCount {get;set;}
        @AuraEnabled public Integer totalSuccesCount {get;set;}
        @AuraEnabled public String  company {get;set;}
        @AuraEnabled public String year {get;set;}
        @AuraEnabled public String month {get;set;}
        
    }
}