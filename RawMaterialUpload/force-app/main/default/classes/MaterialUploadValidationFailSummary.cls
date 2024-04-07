public with sharing class MaterialUploadValidationFailSummary {
    @AuraEnabled
        public static List<validationFailErrorCodeWrapperObject> initializeAccordianHeaderList(String batchNo){
            
            List<validationFailErrorCodeWrapperObject> errorCodeWrapHeaderList = new List<validationFailErrorCodeWrapperObject>();
            
            //Get picklist values  to populate header
            Schema.DescribeFieldResult fieldResult = Sales_Error_Code__c.Error_Type__c.getDescribe();
            // System.debug(LoggingLevel.DEBUG, fieldResult);
            List<Schema.PicklistEntry> pList = fieldResult.getPicklistValues();
            for(integer i=0; i<pList.Size(); i++){
                if(pList[i].getValue() <> 'Missing Field'){
                    validationFailErrorCodeWrapperObject errorCodeHeader = new validationFailErrorCodeWrapperObject();
                    errorCodeHeader.headerNo = 'No';
                    errorCodeHeader.picklistValue = pList[i].getValue();
                    // System.debug(errorCodeHeader.picklistValue+'+picklistvalue');
                    errorCodeHeader.headerErrMessage = pList[i].getValue() + ' : Error Message';
                    errorCodeHeader.headerErrRecords = 'Error Records';
                    errorCodeHeader.headerErrDetailReport = 'Error Detail Report';
                    errorCodeHeader.headerErrDescription = 'Error Description';
                    List<validationFailErrorCodeWrapper> errorCodeWrapList = getValidationFailSummaryOnErrorType(batchNo, pList[i].getValue());
                    errorCodeHeader.validationErrorCodeList = errorCodeWrapList;
                    if(!(errorCodeHeader.picklistValue == 'Label & Division')){
                        errorCodeWrapHeaderList.add(errorCodeHeader);
                    }
                }
            }
            return errorCodeWrapHeaderList;
        }
        
        @AuraEnabled
        public static List<validationFailErrorCodeWrapper> getValidationFailSummaryOnErrorType(String batchNo, String errorType){
            // system.debug('errorType ::'+errorType);
            List<Sales_Error_Code__c> materialErrorCode  = [SELECT Name,Error_Records__c,Error_Description__c,Error_Detail_Report_Link__c, Error_Message__c FROM Sales_Error_Code__c WHERE Record_Code_Type__c = 'Material Upload' and Active__c = true and Error_Type__c = :errorType WITH SECURITY_ENFORCED ];
            
            Set<String> errorCodes = new Set<String>();
            Map<String,Sales_Error_Code__c> errorCodeObjMap = new Map<String,Sales_Error_Code__c>();
            Map<String,Integer> errorCodeCountMap = new Map<String,Integer>();
            
            for(Sales_Error_Code__c errCode : materialErrorCode){
                String errrCode = '%' + errCode.Name + '%';
                errorCodes.add(errrCode);
                errorCodeObjMap.put(errCode.Name,errCode);
            }
            
            List<Material_Transaction_Stage__c> materialTransStage = [SELECT Error_Code__c FROM Material_Transaction_Stage__c where Upload_Batch_No__c=:batchNo and Error_Code__c like :errorCodes WITH SECURITY_ENFORCED ];
            
            // System.debug('Querry'+materialTransStage);
            for(Material_Transaction_Stage__c materialStage : materialTransStage){
                String[] stageErorCodes= materialStage.Error_Code__c .split(',');
                // System.debug('Split error code'+stageErorCodes);
                for(String erCode : stageErorCodes){
                    if(String.isNotBlank(erCode)){
                        if(errorCodeCountMap.containsKey(erCode)){
                            Integer errorCodeCount = errorCodeCountMap.get(erCode);
                            errorCodeCount = errorCodeCount + 1;
                            errorCodeCountMap.put(erCode,errorCodeCount);
                        } else {
                            Integer errorCodeCount = 1;
                            errorCodeCountMap.put(erCode,errorCodeCount);
                        }
                    }
                }
            }
            
            List<validationFailErrorCodeWrapper> errorCodeWrapList = new List<validationFailErrorCodeWrapper>();
                // system.debug('errorCodeCountMap.keySet()>>>>>'+errorCodeCountMap.keySet());
            // system.debug('errorCodeObjMap>>>>>'+errorCodeObjMap);
                // system.debug('errorCodeObjMap.keySet()>>>>>'+errorCodeObjMap.keySet());
            for(String errorCodeKey : errorCodeCountMap.keySet()){
                system.debug('errorCodeKey>>>>'+errorCodeKey);
                Sales_Error_Code__c errCodeObject = new Sales_Error_Code__c();
                errCodeObject = errorCodeObjMap.get(errorCodeKey);
                // system.debug('errCodeObject>>>>'+errCodeObject);
                // system.debug('errCodeObject>>>>'+errorCodeObjMap.get(errorCodeKey));
                if(errCodeObject != null){
                    // system.debug('errCodeObject>>>>insideIF>>>>'+errCodeObject);
                    validationFailErrorCodeWrapper errCodeWrap = new validationFailErrorCodeWrapper();
                    errCodeWrap.errorCode = errorCodeKey;
                    errCodeWrap.errorCount = errorCodeCountMap.get(errorCodeKey);                
                    errCodeWrap.errorMessage = errCodeObject.Error_Message__c;
                    errCodeWrap.errorDescription = errCodeObject.Error_Description__c;
                    errCodeWrap.errorReportLink = errCodeObject.Error_Detail_Report_Link__c;    
                    errorCodeWrapList.add(errCodeWrap);
                    // system.debug('errorCodeWrapList>>>>insideIF>>>>'+errorCodeWrapList);
                }
            }
            // system.debug('errorCodeWrapList>>>>'+errorCodeWrapList);
            return errorCodeWrapList;
        }
        
        public class validationFailErrorCodeWrapper {
            @AuraEnabled public String errorCode {get;set;}
            @AuraEnabled public Integer errorCount {get;set;}
            @AuraEnabled public String errorMessage {get;set;}
            @AuraEnabled public String errorDescription {get;set;}
            @AuraEnabled public String errorReportLink {get;set;}
        }
        
        
        public class validationFailErrorCodeWrapperObject {        
            @AuraEnabled public String headerNo {get;set;}
            @AuraEnabled public String headerErrMessage {get;set;}
            @AuraEnabled public String headerErrRecords {get;set;}
            @AuraEnabled public String headerErrDetailReport {get;set;}
            @AuraEnabled public String headerErrDescription {get;set;}
            @AuraEnabled public String picklistValue {get;set;}
            @AuraEnabled public List<validationFailErrorCodeWrapper> validationErrorCodeList {get;set;}
        }

}