global with sharing class ProcessMaterialUploadData {
    
    global class  RecordValidationStatus{
        public Boolean validateStatus { get; set; }
        public Boolean updateCheckbox { get; set; }        
    }    
    
    // Aki :) Checking Missing Fields 
    public boolean missingFieldValueBulk(Material_Transaction_Stage__c dataRow){
        boolean missingField = true;
        dataRow.Remarks__c='';
        // System.debug(dataRow.Year__c+'Datarow year field in processmaterial Upload');
        System.debug('Field MandatoryCheck');
        System.debug(dataRow);
        if(dataRow != null){
            // System.debug('Year Value dararow : '+String.isBlank(dataRow.Year__c));
            if(String.isBlank(dataRow.Year__c)){
                // System.debug('Year Value Missing');
                dataRow.Year_FB__c = true;
                dataRow.Error_Code__c+='ERR-5001,';
                dataRow.Remarks__c+='\r\nMissing Year';
                missingField = false;
                // System.debug(dataRow.Year_FB__c+':'+dataRow.Error_Code__c+':'+dataRow.Remarks__c);
            }            
            if(String.isBlank(dataRow.Month__c)){
                dataRow.Month_FB__c = true;
                dataRow.Error_Code__c+='ERR-5002,';
                dataRow.Remarks__c+='\r\nMissing Month';
                missingField = false;
            }
            if(String.isBlank(dataRow.PO_Date__c)){
                dataRow.PO_Date_FB__c = true;
                dataRow.Error_Code__c+='ERR-5003,';
                dataRow.Remarks__c+='\r\nMissing PO Date';
                missingField = false;
            }
            if(String.isBlank(dataRow.PO_Number__c)){
                dataRow.PO_Number_FB__c = true;
                dataRow.Error_Code__c+='ERR-5004,';
                dataRow.Remarks__c+='\r\nMissing PO Number';
                missingField = false;
            }
            
            if(String.isBlank(dataRow.Mainetti_Company__c)){
                dataRow.Mainetti_Company_FB__c = true;
                dataRow.Error_Code__c+='ERR-5005,';
                dataRow.Remarks__c+='\r\nMissing Company';
                missingField = false;
            }
            if(String.isBlank(dataRow.Material__c)){
                dataRow.Material_FB__c = true;
                dataRow.Error_Code__c+='ERR-5007,';
                dataRow.Remarks__c+='\r\nMissing Material';
                missingField = false;
            }
            if(String.isBlank(dataRow.Order_Type__c)){
                dataRow.Order_Type_FB__c = true;
                dataRow.Error_Code__c+='ERR-5009,';
                dataRow.Remarks__c+='\r\nMissing Order Type';
                missingField = false;
            }
            if(String.isBlank(dataRow.Supplier_Name__c)){
                dataRow.Supplier_Name_FB__c	 = true;
                dataRow.Error_Code__c+='ERR-5010,';
                dataRow.Remarks__c+='\r\nMissing Supplier Name';
                missingField = false;
            }
            if(String.isBlank(dataRow.Supplier_Country_2__c)){
                dataRow.Supplier_Country_2_FB__c = true;
                dataRow.Error_Code__c+='ERR-5053,';
                dataRow.Remarks__c+='\r\nMissing Supplier country';
                missingField = false;
            }
            // IS BLANK
            if(String.isBlank(dataRow.Purchase_Terms__c)){
                dataRow.Purchase_Terms_FB__c = true;
                dataRow.Error_Code__c+='ERR-5011,';
                dataRow.Remarks__c+='\r\nMissing Terms';
                missingField = false;
            }
            if(String.isBlank(dataRow.Freight_cost_to_factory__c)){
                dataRow.Freight_cost_to_factory_FB__c = true;
                dataRow.Error_Code__c+='ERR-5061,';
                dataRow.Remarks__c+='\r\nFreight cost to factory';
                missingField = false;
            }
            if(String.isBlank(dataRow.Landed_cost_to_factory__c)){
                dataRow.Landed_cost_to_factory_FB__c = true;
                dataRow.Error_Code__c+='ERR-5062,';
                dataRow.Remarks__c+='\r\nLanded cost to factory';
                missingField = false;
            }
            
            if(String.isBlank(dataRow.UOM__c)){
                dataRow.UOM_FB__c = true;
                dataRow.Error_Code__c+='ERR-5012,';
                dataRow.Remarks__c+='\r\nMissing UOM';
                missingField = false;
            } 
            if(String.isBlank(String.valueOf(dataRow.QTY__c))){
                dataRow.QTY_FB__c = true;
                dataRow.Error_Code__c+='ERR-5013,';
                dataRow.Remarks__c+='\r\nMissing Qty';
                missingField = false;
            }
            if(String.isBlank(dataRow.Purchase_Currency__c)){
                dataRow.Purchase_Currency_FB__c = true;
                dataRow.Error_Code__c+='ERR-5014,';
                dataRow.Remarks__c+='\r\nMissing Purchase Currency';
                missingField = false;
            }
            if(String.isBlank(String.valueOf(dataRow.Purchase_Unit_Price__c))){
                dataRow.Purchase_Unit_Price_FB__c = true;
                dataRow.Error_Code__c+='ERR-5015,';
                dataRow.Remarks__c+='\r\nMissing Purchase Unit Price';
                missingField = false;
            }
            if(String.isBlank(String.valueOf(dataRow.Purchase_Price__c))){
                dataRow.Purchase_Price_FB__c = true;
                dataRow.Error_Code__c+='ERR-5016,';
                dataRow.Remarks__c+='\r\nMissing Purchase Price';
                missingField = false;
            }
            if(String.isBlank(dataRow.ExRate_To_USD__c)){
                dataRow.ExRate_To_USD_FB__c = true;
                dataRow.Error_Code__c+='ERR-5017,';
                dataRow.Remarks__c+='\r\nMissing exRate To USD';
                missingField = false;
            }
            if(String.isBlank(dataRow.ExRate_To_EUR__c)){
                dataRow.ExRate_To_EUR_FB__c = true;
                dataRow.Error_Code__c+='ERR-5018,';
                dataRow.Remarks__c+='\r\nMissing exRate To EUR';
                missingField = false;
            }
            if(String.isBlank(dataRow.Expected_Delivery_Month__c)){
                dataRow.Expected_Delivery_Month_FB__c = true;
                dataRow.Error_Code__c+='ERR-5019,';
                dataRow.Remarks__c+='\r\nMissing Expected Delivery Month';
                missingField = false;
            }
            if(String.isBlank(dataRow.Expected_Delivery_Year__c)){
                dataRow.Expected_Delivery_Year_FB__c = true;
                dataRow.Error_Code__c+='ERR-5020,';
                dataRow.Remarks__c+='\r\nMissing Expected Delivery Year';
                missingField = false;
            }    
            System.debug('Check new field Values');
            // System.debug(dataRow.Freight_cost_to_factory__c);
           // System.debug(dataRow.Landed_cost_to_factory__c);

            
        }
        // System.debug('return missinf field value:'+missingField);
        return missingField;
    }
    
    
    
    public List<Material_Transaction_Stage__c> processMaterialDataChunk(List<Material_Transaction_Stage__c> materialTransStagRec,String batchId, string selcomp,string selMonth,string selYear, Inventory_Transaction_Master__c updateBatchStatus, validateMaterialUploadRowsBulk.RecordValidationStatus recordStatus){
        // System.debug('Parameter passes'+materialTransStagRec+':'+ batchId+':'+  selcomp+':'+  selMonth+':'+  selYear+':'+ updateBatchStatus+':'+  recordStatus);
        // System.debug('values recieved at process Material Data Chunk');
        
        List<Material_Transaction_Stage__c> materialTransStagUpdate  = new List<Material_Transaction_Stage__c>();
        GetMaterialUploadMasterData getmaterialUploadMasterData = new GetMaterialUploadMasterData();
        
        map<string,string> getMonthMMM = getmaterialUploadMasterData.getMonthMMM();
        // map<string,string> getManitteCompanyMap = getmaterialUploadMasterData.getManitteCompanyMap();
        // Starting
        Map<string,Map<string,string>> getPartnerMaps = getmaterialUploadMasterData.getParterCmpyRegionNCogsCountryNComapnyGroupName();
        // system.debug('getPartnerMaps >>>>>>'+getPartnerMaps);
        map<string,string> getpartnerCompanyRegionMap = getPartnerMaps.get('salesCompanyRegionMap');
        map<string,string> getpartnerCompanyCogsCountry = getPartnerMaps.get('salesCogsCountryMap');
        // map<string,string> partnerCogsCountryMap = getPartnerMaps.get('partnerCogsCountryMap');
        // map<string,string> getpartnerCompanyGroupName = getPartnerMaps.get('salesCompanyGroupNameMap');
        //get product map ACS
        Map<String,Map<String,String>> getProductMap = getmaterialUploadMasterData.getMatchingProduct();
        Map<String,String> materialNGradeNColorMap = getProductMap.get('materialNGradeNColorMap');
        Map<String,String> materialMaterialMap = getProductMap.get('materialMaterialMap');
        Map<String,String> productIDMatGradCol = getProductMap.get('productIDMatGradCol');
        Map<String,String> productIDMatGradColName = getProductMap.get('productIDMatGradColName');
        Map<String,String> gradeTypeMap = getProductMap.get('gradeTypeMap');
        //get Material Upload map ACS
        
        
        
        Schema.DescribeFieldResult partnerCountry = Partner__c.Country__c.getDescribe();
        Map<String,String> partnerCountryMap = getmaterialUploadMasterData.getPickListValuesIntoMap(partnerCountry);
        
        // Schema.DescribeFieldResult picklistMaterial = Material_upload__c.Material__c.getDescribe();
        // Map<String,String> materialUploadMaterialMap = getmaterialUploadMasterData.getPickListValuesIntoMap(picklistMaterial);
        
        //dependent picklist map for Material Upload and Grade
        Schema.sObjectField dependentField = Material_upload__c.Grade__c;
        Map<Object,Map<String,String>> materialUploadGradeMap = getmaterialUploadMasterData.getDependentPicklistMap(dependentField);
        
        //dependent picklist Map for Material Upload and Color
        Schema.sObjectField dependentField2 = Material_upload__c.Color__c;
        Map<Object,Map<String,String>> materialUploadColorMap = getmaterialUploadMasterData.getDependentPicklistMap(dependentField2);
        
        Schema.sObjectField dependentField3 = Product__c.Product_Catagory__c;
        Map<Object,Map<String,String>> materialProductCategoryMap = getmaterialUploadMasterData.getDependentPicklistMap(dependentField3);
          
        //Get pick list for Material Ordertype
        List<String>  getMaterialUploadOrdertypePicklist = getmaterialUploadMasterData.getMaterialUploadOrdertypePicklist();
        
        // get map for company Name and Country and Id Maps
        
        Map<String, Map<String,String>> getPartnerSupplierNameMap = getmaterialUploadMasterData.getPartnerSupplierNameMap();
        //  zsystem.debug('getPartnerSupplierNameMap >>>>>>'+getPartnerSupplierNameMap);
        Map<String, String> companyNameCogsCountryMap =getPartnerSupplierNameMap.get('companyNameCogsCountryMap');
        //  system.debug('companyNameCogsCountryMap >>>>>>'+companyNameCogsCountryMap);
        Map<String, String> companyNameCossIdMap= getPartnerSupplierNameMap.get('companyNameCossIdMap');
        Map<String, String> companyNameSupplierCodeMap= getPartnerSupplierNameMap.get('companyNameSupplierCodeMap');
        Map<String, String> companyNameSupplierGroupMap= getPartnerSupplierNameMap.get('companyNameSupplierGroupMap');
        

        Schema.DescribeFieldResult picklistPurchaseTerms = Material_upload__c.Purchase_Terms__c.getDescribe();
        Map<String,String> materialUploadPurchaseTermMap = getmaterialUploadMasterData.getPickListValuesIntoMap(picklistPurchaseTerms);
        Schema.DescribeFieldResult picklistUOM = Material_upload__c.UOM__c.getDescribe();
        Map<String,String> materialUploadUomMap =getmaterialUploadMasterData.getPickListValuesIntoMap(picklistUOM);
        Schema.DescribeFieldResult picklistPurchaseCurrenct = Material_upload__c.Purchase_Currency__c.getDescribe();
        Map<String,String> materialUploadPurchaseCurrencyMap = getmaterialUploadMasterData.getPickListValuesIntoMap(picklistPurchaseCurrenct);
        Map<String,String> checkCompMonthYear = getmaterialUploadMasterData.checkCompMonthYear(selcomp);
        
        
        
        // Integer count = 0;
        for (Material_Transaction_Stage__c dataRow : materialTransStagRec) { 
            Boolean finalValidation=false;
            // System.debug('data row inside forloop process material upload chunk Count'+count++);
            // System.debug(dataRow);
            Boolean isDataValid = true;   
            // Boolean checkbox = false;   
            String remarks = '';
            String errorCode = '';
            dataRow.Error_Code__c='';
            // string totalerrorcode = '';
            // STRING errorcode1  = '';
            boolean missingField =  missingFieldValueBulk(dataRow); 
            // System.debug('Datarow missingField'+missingField);
            //checks missing fields first
            if(!missingField)
            {
                // System.debug('Mandatory field is missing');
                isDataValid = false;
            }
            
            
            //Pattern Validation Start
            
            //>>> Expected Delivery Date Format Check
            if(String.isNotBlank(dataRow.Expected_Delivery_Date__c)){
                String expectedDeliveryDate = dataRow.Expected_Delivery_Date__c.toUpperCase();
                String dateRegEx = '(([0-9])|([0-2][0-9])|([3][0-1]))-(JAN|FEB|MAR|APR|MAY|JUN|JUL|AUG|SEP|OCT|NOV|DEC)-((19|20)\\d\\d|\\d{2})'; 
                Pattern myPattern = Pattern.compile(dateRegEx);
                Matcher myMatcher = myPattern.matcher(expectedDeliveryDate);
                if(!myMatcher.matches()){
                    dataRow.Expected_Delivery_Date_NF__c = true;
                    remarks += '\r\nExpected Delivery Date must be number';
                    errorCode += 'ERR-5045,';
                    dataRow.Error_Code__c += 'ERR-5045,';
                    dataRow.Remarks__c += '\r\nExpected Delivery Date must be number';
                    isDataValid = false;
                }
                // else{
                //     SYSTEM.debug('Expected Delivery Date Valid');
                // }
                myMatcher =null;            
            }
            
            
            
            
            
            
            //Year Pattern Check
            
            if(String.isNotBlank(dataRow.Year__c)){
                // String year = dataRow.Year__c.toUpperCase();
                Boolean yearisNumeric = (String.valueOf(dataRow.Year__c)).isNumeric();
                Boolean yearIsValid = true;
                if(yearisNumeric){
                    yearIsValid = false;
                    if((Integer.valueOf(dataRow.Year__c) == System.Today().year()) || (Integer.valueOf(dataRow.Year__c) == System.Today().year()-1) ){
                        // System.debug('valid year');
                        yearIsValid = true;
                    } else { 
                        yearIsValid = false;
                    }
                }else{
                    yearIsValid = false;
                }
                
                if(!yearIsValid){
                    remarks += '\r\nYear must be in YYYY format';
                    errorCode += 'ERR-5021,';
                    dataRow.Error_Code__c += 'ERR-5021,';
                    dataRow.Remarks__c += '\r\nYear must be in YYYY format';
                    dataRow.Year_NF__c = true;
                    isDataValid = false;
                }
            }
            
            
            
            if(String.isNotBlank(dataRow.Month__c)){
                String month = dataRow.Month__c.toUpperCase();
                String monthRegEx = '(JAN|FEB|MAR|APR|MAY|JUN|JUL|AUG|SEP|OCT|NOV|DEC)'; 
                Pattern myPattern = Pattern.compile(monthRegEx);
                Matcher myMatcher = myPattern.matcher(month);
                if(!myMatcher.matches()){
                    remarks += '\r\nMonth must be in MMM format';
                    errorCode += 'ERR-5023,';
                    dataRow.Error_Code__c += 'ERR-5023,';
                    dataRow.Remarks__c += '\r\nMonth must be in MMM format';
                    dataRow.Month_NF__c = true;
                    isDataValid = false;
                }
                // System.debug('Month pattren matcheh');
                myMatcher =null;
            }
            
            // checking for selected month and year and Value montha and year
            
            //Check selected month and data month is same
            
            if(String.isNotBlank(dataRow.Month__c) && String.isNotBlank(selMonth)){
                String month ='';
                if(getMonthMMM.containsKey(selMonth)){
                    month = getMonthMMM.get(selMonth);
                }else {
                    month = selMonth;
                }
                // System.debug('Month in csv'+dataRow.Month__c+':'+(dataRow.Month__c).toLowerCase());
                // System.debug('Month in selMonth'+month+':'+month.toLowerCase());
                // System.debug((dataRow.Month__c).toLowerCase() != month.toLowerCase());
                if(!(dataRow.Month__c.toLowerCase() == month.toLowerCase())){
                    isDataValid = false;
                    remarks += '\r\nMonth value do not match with selected month';
                    errorCode += 'ERR-5024,';
                    dataRow.Error_Code__c += 'ERR-5024,';
                    dataRow.Remarks__c+='\r\nMonth value do not match with selected month';
                    isDataValid=false;
                }
                /* else {
                    System.debug(LoggingLevel.INFO,'month and selected month matching');
                } */
            }
            
            //Check selected year and data year is same
            if(String.isNotBlank(dataRow.Year__c) && String.isNotBlank(selYear)){
                if(dataRow.Year__c.toLowerCase() != selYear.toLowerCase()){
                    isDataValid = false;
                    remarks += '\r\nYear value do not match with selected year';
                    errorCode += 'ERR-5022,';
                    dataRow.Error_Code__c += 'ERR-5022,';
                    dataRow.Remarks__c='\r\nYear value do not match with selected month';
                    isDataValid=false;
                }
                /* else {
                    System.debug(LoggingLevel.INFO,'Selected year and record year matched');
                } */
            }
            
            if(String.isNotBlank(dataRow.Mainetti_Company__c)){
                // System.debug('inside region cogs country company validation'+dataRow.Mainetti_Company__c);
                if(getpartnerCompanyRegionMap.containsKey(selcomp)){
                    dataRow.Region__c = getpartnerCompanyRegionMap.get(selcomp);
                }
                if (getpartnerCompanyCogsCountry.containsKey(selcomp)) {
                    dataRow.Cogs_Country__c = getpartnerCompanyCogsCountry.get(selcomp);
                }
                // System.debug(' fetched from map dataRow.Cogs_Country__c'+dataRow.Cogs_Country__c);
                // System.debug('company group by name '+getpartnerCompanyGroupName);
                // System.debug('contains'+ getpartnerCompanyGroupName.containsKey((dataRow.Mainetti_Company__c).toUpperCase()));
                // System.debug(getpartnerCompanyCogsCountry.get(dataRow.Mainetti_Company__c));
                
                if(!((dataRow.Mainetti_Company__c).toUpperCase() == selcomp.toUpperCase()) ){
                    // System.debug('Map does not contain the company');
                    dataRow.Mainetti_Company_NF__c = true;
                    isDataValid = false;
                    remarks += '\r\n Company value do not match with selected company';
                    //Added on 22-10-2020 for Error Code Mapping
                    errorCode += 'ERR-5026,';
                    dataRow.Error_Code__c += 'ERR-5026,';
                    dataRow.Remarks__c += '\r\nCompany value do not match with selected company';
                }
                /* else {
                    System.debug(LoggingLevel.INFO,'map contains the company list');
                } */
            } 
            
            if(String.isNotBlank(dataRow.Mainetti_Company__c) && String.isNotBlank(dataRow.Month__c) && String.isNotBlank(dataRow.Year__c) ){
                String compMonthYear = (dataRow.Mainetti_Company__c).toUpperCase()+'#'+(dataRow.Month__c).toUpperCase()+'#'+dataRow.Year__c;
                // System.debug(' row compMonthYear>>>>>'+compMonthYear);
                // System.debug(checkCompMonthYear);
                if((checkCompMonthYear.containsKey(compMonthYear))){
                    isDataValid = false;
                    remarks += '\r\n Duplicate Year and Month under same Company';
                    errorCode += 'ERR-5051,';
                    dataRow.Error_Code__c += 'ERR-5051,';
                    dataRow.Remarks__c += '\r\nDuplicate Year and Month under same Company';
                }
            }
            
            
            //>>> PO Date Format Check
            // System.debug('Po Date Check');
            if(String.isNotBlank(dataRow.PO_Date__c)){
                String poDate = dataRow.PO_Date__c.toUpperCase();
                String regEx = '(([0-9])|([0-2][0-9])|([3][0-1]))-(JAN|FEB|MAR|APR|MAY|JUN|JUL|AUG|SEP|OCT|NOV|DEC)-((19|20)\\d\\d|\\d{2})'; 
                Pattern myPattern = Pattern.compile(regEx);
                Matcher myMatcher = myPattern.matcher(poDate);
                
                if(!myMatcher.matches()){
                    dataRow.PO_Date_NF__c = true;
                    remarks += '\r\nPO Date should be in DD-MMM-YYYY format';
                    errorCode += 'ERR-5025,';
                    dataRow.Error_Code__c += 'ERR-5025,';
                    dataRow.Remarks__c += '\r\nPO Date should be in DD-MMM-YYYY format';
                    isDataValid = false;
                }
                /* else{
                    SYSTEM.debug(LoggingLevel.INFO,'Po date pattren checked');
                } */
                myMatcher =null;            
            }
            
            //<<< Po Date Format Check END
            
            //Item code local length not longer than 255
            
            if(String.isNotBlank(dataRow.Item_code_local__c)){
                Integer length = String.valueOf(dataRow.Item_code_local__c).length();
                if(length>=255){
                    dataRow.Item_code_local_NF__c = true;
                    remarks += '\r\nItem Code can not longer than 255';
                    errorCode += 'ERR-5034,';
                    dataRow.Error_Code__c += 'ERR-5034,';
                    dataRow.Remarks__c += '\r\nItem Code can not longer than 255';
                    isDataValid = false;
                }
                /* else {
                    System.debug(LoggingLevel.INFO,'item code length is within 255 caracters');
                } */
            }
            
            //QTY must be integer
            
            
            
            //Purchase Unit Price must be number and should not allow negative
            if(String.isNotBlank(String.valueOf(dataRow.Purchase_Unit_Price__c))){
                // System.debug(LoggingLevel.INFO,'Purchase unit price not blank');
                Boolean isDecimal = true;
                    if(dataRow.Purchase_Unit_Price__c != null){
                    try{
                        // System.debug(LoggingLevel.INFO,'Purchase unit Price Negative');
                        Decimal.valueOf(dataRow.Purchase_Unit_Price__c);
                        if(Decimal.valueOf(dataRow.Purchase_Unit_Price__c)<=0){
                            // System.debug(LoggingLevel.INFO,'Inside purchase unit price negative error');
                            dataRow.Purchase_Unit_price_NF__c = true;
                            remarks += '\r\nPurchase Unit price cannot be negative';
                            errorCode += 'ERR-5058,';
                            dataRow.Error_Code__c += 'ERR-5058,';
                            dataRow.Remarks__c += '\r\nPurchase Unit price cannot be negative';
                            isDataValid = false;
                        }
                    }
                    catch(TypeException e){
                        isDecimal = false; 
                    }
                }
                // Boolean isInteger= String.valueOf(dataRow.Purchase_Unit_Price__c).isNumeric();
                if(!isDecimal){
                    dataRow.Purchase_Unit_price_NF__c = true;
                    remarks += '\r\nPurchase Unit price must be number';
                    errorCode += 'ERR-5041,';
                    dataRow.Error_Code__c += 'ERR-5041,';
                    dataRow.Remarks__c += '\r\nPurchase Unit price must be number';
                    isDataValid = false;
                }
                // System.debug('Purchase price'+String.valueOf(dataRow.Purchase_Unit_Price__c).containsAny('eE'));
                // System.debug('PurchasePrice'+dataRow.Purchase_Unit_Price__c);
                if(String.valueOf(dataRow.Purchase_Unit_Price__c).containsAny('eE')){
                    // System.debug('Inside Exrateto');        
                    dataRow.Purchase_Unit_price_NF__c = true;
                            remarks += '\r\nPurchase Unit Price, Purchase Price, exRate to USD and exRate to EUR should not be in Exponential Format';
                            errorCode += 'ERR-5060,';
                            dataRow.Error_Code__c += 'ERR-5060,';
                            dataRow.Remarks__c += '\r\nPurchase Unit Price, Purchase Price, exRate to USD and exRate to EUR should not be in Exponential Format';
                            isDataValid = false;
                        }
                /* else {
                    System.debug(LoggingLevel.INFO,'Purchase Unit Price must be number and should not allow negative checked');
                } */
            }
            
            //Purchase Price Price must be number and should not allow negative
            if(String.isNotBlank(dataRow.Purchase_Price__c) && String.isNotBlank(dataRow.QTY__c)){
                 Boolean isDecimal = true;
                if(dataRow.Purchase_Price__c != null ){
                    try{
                        Decimal.valueOf(dataRow.Purchase_Price__c);
                        if((Decimal.valueOf(dataRow.Purchase_Price__c)<0 && Decimal.valueOf(dataRow.QTY__c)>0)|| (Decimal.valueOf(dataRow.Purchase_Price__c)>0 && Decimal.valueOf(dataRow.QTY__c)<0)){
                            dataRow.Purchase_Unit_price_NF__c = true;
                            dataRow.QTY_NF__c = true;
                            remarks += '\r\nQty and Purchase Price must be both positive or both negative';
                            errorCode += 'ERR-5059,';
                            dataRow.Error_Code__c += 'ERR-5059,';
                            dataRow.Remarks__c += '\r\nQty and Purchase Price must be both positive or both negative';
                            isDataValid = false;
                        }
                    }
                    catch(TypeException e){
                        isDecimal = false; 
                    }
                }
                // Boolean isInteger= (String.valueOf(dataRow.Purchase_Price__c)).isNumeric();
                if(!(isDecimal)){
                    dataRow.Purchase_Price_NF__c = true;
                    remarks += '\r\nPurchase price must be number';
                    errorCode += 'ERR-5042,';
                    dataRow.Error_Code__c += 'ERR-5042,';
                    dataRow.Remarks__c += '\r\nPurchase price must be number';
                    isDataValid = false;
                }
                 if(String.valueOf(dataRow.Purchase_Price__c).containsAny('eE')){
                            dataRow.Purchase_Price_NF__c = true;
                            remarks += '\r\nPurchase Unit Price, Purchase Price, exRate to USD and exRate to EUR should not be in Exponential Format';
                            errorCode += 'ERR-5060,';
                            dataRow.Error_Code__c += 'ERR-5060,';
                            dataRow.Remarks__c += '\r\nPurchase Unit Price, Purchase Price, exRate to USD and exRate to EUR should not be in Exponential Format';
                            isDataValid = false;
                        }
                /* else {
                    System.debug(LoggingLevel.INFO,'Purchase Price Price must be number and should not allow negative checked');
                } */
            }
            
            //exRate To USD rate must be number and should not allow negative
            if(String.isNotBlank(String.valueOf(dataRow.exRate_To_USD__c)) && String.isNotBlank(Datarow.Purchase_Price__c) ){
                
                Boolean isDecimalUSD = true;
                Boolean isDecimalPurPrice = true;
                if(dataRow.exRate_To_USD__c != null && dataRow.Purchase_Price__c!= null){
                    try{Decimal.valueOf(dataRow.exRate_To_USD__c);}
                    catch(TypeException e){ isDecimalUSD = false; }
                    try{Decimal.valueOf(dataRow.Purchase_Price__c);}
                    catch(TypeException e){ isDecimalPurPrice = false; }
                }
                
                if(isDecimalUSD){
                    if(Decimal.valueOf(dataRow.exRate_To_USD__c)<0){
                        //dataRow.exRate_To_USD_NF__c = true;
                        remarks += '\r\nExRate to USD must be number';
                        errorCode += 'ERR-5043,';
                        dataRow.exRate_To_USD_NF__c=true;
                        dataRow.Error_Code__c += 'ERR-5043,';
                        dataRow.Remarks__c += '\r\nExRate to USD must be number';
                        isDataValid = false;
                        isDecimalUSD = false;
                    }else if(Decimal.valueOf(dataRow.exRate_To_USD__c)==0){
                        //dataRow.exRate_To_USD_NF__c = true;
                        dataRow.exRate_To_USD_NF__c=true;
                        remarks += '\r\nExRate to USD OR ExRate to EUR can not be 0';
                        errorCode += 'ERR-5050,';
                        dataRow.Error_Code__c += 'ERR-5050,';
                        dataRow.Remarks__c += '\r\nExRate to USD OR ExRate to EUR can not be 0';
                        isDataValid = false;
                        isDecimalUSD = false;
                    }
                    String exRate = dataRow.exRate_To_USD__c.replaceAll(',','');
                    if(Decimal.valueOf(dataRow.exRate_To_USD__c).scale()>6 || exRate.length() >= 19){
                        dataRow.exRate_To_USD_NF__c=true;
                        errorCode += 'ERR-5056,';
                        dataRow.Error_Code__c += 'ERR-5056,';
                        remarks += '\r\nUSD should be Max 18 digits and max 6 decimal point';
                        dataRow.Remarks__c += '\r\nUSD should be Max 18 digits and max 6 decimal point';
                        isDataValid = false;
                        isDecimalUSD = false;
                    }
                }else{
                    dataRow.exRate_To_USD_NF__c=true;
                    remarks += '\r\nExRate to USD must be number';
                    dataRow.Error_Code__c += 'ERR-5043,';
                    dataRow.Remarks__c += '\r\nExRate to USD must be number';
                    isDataValid = false;
                    isDecimalUSD = false;
                    
                }
                Boolean exponentialError = false;
                if(String.valueOf(dataRow.exRate_To_USD__c).containsAny('eE')){
                    exponentialError = true;
                    dataRow.exRate_To_USD_NF__c = true;
                    remarks += '\r\nPurchase Unit Price, Purchase Price, exRate to USD and exRate to EUR should not be in Exponential Format';
                    errorCode += 'ERR-5060,';
                    dataRow.Error_Code__c += 'ERR-5060,';
                    dataRow.Remarks__c += '\r\nPurchase Unit Price, Purchase Price, exRate to USD and exRate to EUR should not be in Exponential Format';
                    isDataValid = false;
                }
                if(isDecimalPurPrice && isDecimalUSD && !exponentialError) {
                    if(Decimal.valueOf(dataRow.exRate_To_USD__c)!=0){
                        // System.debug('exRate To USD rate must be number and should not allow negative checked');
                        // System.debug('First Value'+Decimal.valueOf(dataRow.Purchase_Price__c));
                        // System.debug('second'+Decimal.valueOf(dataRow.exRate_To_USD__c));
                        // System.debug(Decimal.valueOf(dataRow.Purchase_Price__c) * Decimal.valueOf(dataRow.exRate_To_USD__c));
                        Material_Upload_Custom__c customSetting = Material_Upload_Custom__c.getInstance();
                        Integer scaleValue = Integer.valueOf(customSetting.Scale_Purchase_Price__c);
                        Decimal purchasePriceUSD = Decimal.valueOf(dataRow.Purchase_Price__c) * Decimal.valueOf(dataRow.exRate_To_USD__c);
                        dataRow.Purchase_Price_USD__c =  String.valueOf(purchasePriceUSD.setScale(scaleValue));
                    }
                }else {
                    dataRow.exRate_To_USD_NF__c=true;
                    remarks += '\r\nInvalid calculate format in Purchase price and ExRate to USD';
                    errorCode += 'ERR-5048,';
                    dataRow.Error_Code__c += 'ERR-5048,';
                    dataRow.Remarks__c += '\r\nInvalid calculate format in Purchase price and ExRate to USD';
                    isDataValid = false;
                }
                
            }
            
            //exRate To USD rate must be number and should not allow negative
            // System.debug( dataRow.exRate_To_EUR__c);
            if(String.isNotBlank(dataRow.exRate_To_EUR__c) && String.isNotBlank(dataRow.Purchase_Price__c)){
                Boolean isDecimalUSD = true;
                Boolean isDecimalPurPrice = true;
                
                if(dataRow.exRate_To_USD__c != null && dataRow.Purchase_Price__c!= null){
                    try{Decimal.valueOf(dataRow.exRate_To_EUR__c);}
                    catch(TypeException e){ isDecimalUSD = false; }
                    try{Decimal.valueOf(dataRow.Purchase_Price__c);}
                    catch(TypeException e){ isDecimalPurPrice = false; }
                }
                
                if(isDecimalUSD){
                    if((Decimal.valueOf(dataRow.exRate_To_EUR__c))<0){
                        //dataRow.exRate_To_EUR_NF__c = true;
                        remarks += '\r\nExRate to EUR must be number';
                        errorCode += 'ERR-5044,';
                        dataRow.exRate_To_EUR_NF__c=true;
                        dataRow.Error_Code__c += 'ERR-5044,';
                        dataRow.Remarks__c += '\r\nExRate to EUR must be number';
                        isDataValid = false;
                        isDecimalUSD = false;
                    }
                    else if((Decimal.valueOf(dataRow.exRate_To_EUR__c))==0){
                        //dataRow.exRate_To_EUR_NF__c = true;
                        remarks += '\r\nExRate to USD OR ExRate to EUR can not be 0';
                        errorCode += 'ERR-5050,';
                        dataRow.exRate_To_EUR_NF__c=true;
                        dataRow.Error_Code__c += 'ERR-5050,';
                        dataRow.Remarks__c += '\r\nExRate to USD OR ExRate to EUR can not be 0';
                        isDataValid = false;
                        isDecimalUSD = false;
                    }
                    String exRate = dataRow.exRate_To_EUR__c.replaceAll(',','');
                    if(Decimal.valueOf(dataRow.exRate_To_EUR__c).scale()>6 || exRate.length() >= 19){
                        errorCode += 'ERR-5057,';
                        dataRow.Error_Code__c += 'ERR-5057,';
                        dataRow.exRate_To_EUR_NF__c=true;
                        remarks += '\r\nEUR should be Max 18 digits and max 6 decimal point';
                        dataRow.Remarks__c += '\r\nEUR should be Max 18 digits and max 6 decimal point';
                        isDataValid = false;
                        isDecimalUSD = false;
                    }
                } else {
                    //dataRow.exRate_To_EUR_NF__c = true;
                    remarks += '\r\nExRate to EUR must be number';
                    errorCode += 'ERR-5044,';
                    dataRow.Error_Code__c += 'ERR-5044,';
                    dataRow.exRate_To_EUR_NF__c=true;
                    dataRow.Remarks__c += '\r\nExRate to EUR must be number';
                    isDataValid = false;
                    isDecimalUSD = false;
                }
                Boolean exponentialError = false;
                if(String.valueOf(dataRow.exRate_To_EUR__c).containsAny('eE')){
                    exponentialError = true;
                    dataRow.exRate_To_EUR_NF__c = true;
                    remarks += '\r\nPurchase Unit Price, Purchase Price, exRate to USD and exRate to EUR should not be in Exponential Format';
                    errorCode += 'ERR-5060,';
                    dataRow.Error_Code__c += 'ERR-5060,';
                    dataRow.Remarks__c += '\r\nPurchase Unit Price, Purchase Price, exRate to USD and exRate to EUR should not be in Exponential Format';
                            isDataValid = false;
                }
                if(isDecimalUSD && isDecimalPurPrice && !exponentialError) {
                    if(Decimal.valueOf(dataRow.exRate_To_EUR__c)!=0){
                        // System.debug('exRate To USD rate must be number and should not allow negative checked');
                        // System.debug('First Value'+Decimal.valueOf(dataRow.Purchase_Price__c));
                        // System.debug('Second Value'+Decimal.valueOf(dataRow.exRate_To_EUR__c));
                        // System.debug(Decimal.valueOf(dataRow.Purchase_Price__c) * Decimal.valueOf(dataRow.exRate_To_EUR__c));
                        Material_Upload_Custom__c customSetting = Material_Upload_Custom__c.getInstance();
                        Integer scaleValue = Integer.valueOf(customSetting.Scale_Purchase_Price__c);
                        Decimal purchasePriceEUR = Decimal.valueOf(dataRow.Purchase_Price__c) * Decimal.valueOf(dataRow.exRate_To_EUR__c);
                        dataRow.Purchase_Price_EUR__c = String.valueOf(purchasePriceEUR.setScale(scaleValue));
                    }
                }
                else {
                    
                    remarks += '\r\nInvalid calculate format in Purchase price and ExRate to EUR';
                    errorCode += 'ERR-5049,';
                    dataRow.Error_Code__c += 'ERR-5049,';
                    dataRow.Remarks__c += '\r\nInvalid calculatfe format in Purchase price and ExRate to EUR';
                    isDataValid = false;
                }
                
            }

            //USD and EUR margin check

            // Validating the ExRate to USD should not be more than ExRate to EUR
            if(String.isNotBlank(dataRow.exRate_To_EUR__c) && String.isNotBlank(dataRow.exRate_To_USD__c)){
                Boolean isDecimal = true;
                    try{
                        Decimal.valueOf(dataRow.exRate_To_EUR__c);
                        Decimal.valueOf(dataRow.exRate_To_USD__c);
                    }
                    catch(TypeException e){
                        isDecimal = false; 
                    }
                if(isDecimal)
                {   
                    String exRatetoUSD= dataRow.exRate_To_USD__c;
                    String exRatetoEUR = dataRow.exRate_To_EUR__c;

                    decimal valueOfUsd = decimal.valueOf(exRatetoUSD.replaceAll(',',''));
                    decimal valueOfEur = decimal.valueOf(exRatetoEUR.replaceAll(',',''));
                    if(valueOfUsd!= 0 || valueOfEur!=0){
                        if(valueOfUsd <= valueOfEur){
                            dataRow.ExRate_to_USD_NF__c = True;
                            dataRow.ExRate_to_EUR_NF__c = True;
                            dataRow.Error_Code__c += 'ERR-5055,';
                            dataRow.Remarks__c += '\r\nExRate to EUR should not be more than ExRate to USD';
                            isDataValid = false;
                            remarks += '\r\n ExRate to EUR should not be more than ExRate to USD\r\n';
                            errorCode += 'ERR-5055,';
                        }
                    }
                }
            } 
            
            //Devlivery Month Pattern Check
            if(String.isNotBlank(dataRow.Expected_Delivery_Month__c)){
                String month = dataRow.Expected_Delivery_Month__c.toUpperCase();
                String monthRegEx = '(JAN|FEB|MAR|APR|MAY|JUN|JUL|AUG|SEP|OCT|NOV|DEC)'; 
                Pattern myPattern = Pattern.compile(monthRegEx);
                Matcher myMatcher = myPattern.matcher(month);
                if(!myMatcher.matches()){
                    remarks += '\r\nExpected Delivery Month must be in MMM format';
                    errorCode += 'ERR-5046,';
                    dataRow.Error_Code__c += 'ERR-5046,';
                    dataRow.Remarks__c += '\r\nExpected Delivery Month must be in MMM format';
                    dataRow.Expected_Delivery_Month_NF__c = true;
                    isDataValid = false;
                }
                /* else{
                    System.debug(LoggingLevel.INFO,'Delivery month pattren checked');
                } */
                myMatcher =null;
            }
            
            //Delivery Year Pattern Check
            /* if(String.isNotBlank(dataRow.Expected_Delivery_Year__c)){
Boolean isInteger= (String.valueOf(dataRow.Expected_Delivery_Year__c)).isNumeric();

if( !isInteger || String.valueOf(dataRow.Expected_Delivery_Year__c)>'2099' || String.valueOf(dataRow.Expected_Delivery_Year__c)<'1990' ){
remarks += '\r\nExpected Delivery Year must be in YYY formate';
errorCode += 'ERR-5047,';
dataRow.Error_Code__c += 'ERR-5047,';
dataRow.Remarks__c += '\r\nExpected Delivery Year must be in YYY formate';
dataRow.Expected_Delivery_Year_NF__c = true;
isDataValid = false;
}
else{
System.debug('delivey year yyyy pattern checked');
}

}
**/
            //Delivery Year Pattern Check
            Boolean valid = true;
            if(String.isNotBlank(dataRow.Expected_Delivery_Year__c)){
                Boolean isInteger= (String.valueOf(dataRow.Expected_Delivery_Year__c)).isNumeric();
                if(isInteger){
                    if(Integer.valueOf(dataRow.Expected_Delivery_Year__c) < 2099 && Integer.valueOf(dataRow.Expected_Delivery_Year__c) > 1990){
                        valid = true;
                    }
                    else{
                        valid = false;
                    }
                }
                else{
                    valid = false;
                }
            }
            if(!valid){
                remarks += '\r\nExpected Delivery Year must be in YYYY format';
                errorCode += 'ERR-5047,';
                dataRow.Error_Code__c += 'ERR-5047,';
                dataRow.Remarks__c += '\r\nExpected Delivery Year must be in YYYY format';
                dataRow.Expected_Delivery_Year_NF__c = true;
                isDataValid = false;
                // System.debug('delivey year yyyy pattern checked');
            }
            
            
            //Region Cogs Country Company Validation
            
            
            // Get product Id based on material grade colour
            
            if( String.isNotBlank(dataRow.Material__c)){ 
                // System.debug('Data row material grade color'+ dataRow.Material__c+':'+dataRow.Grade__c+':'+dataRow.Color__c);
                String grade = dataRow.Grade__c != null ? (dataRow.Grade__c).toUpperCase() : null;
                String color = dataRow.Color__c != null ? (dataRow.Color__c).toUpperCase() : null;
                String value =(dataRow.Material__c).toUpperCase()+'#'+grade+'#'+color;
                System.debug(materialNGradeNColorMap);
                System.debug(materialNGradeNColorMap.containsKey(value));
                if(!(materialNGradeNColorMap.containsKey(value))){
                    // System.debug('product id not found');
                    dataRow.Mainetti_Company_NF__c = True;
                    isDataValid = false;
                    remarks += '\r\n Can not find Material Product';
                    //Added on 22-10-2020 for Error Code Mapping
                    errorCode += 'ERR-0027,';
                    dataRow.Error_Code__c += 'ERR-5027,';
                    dataRow.Remarks__c += '\r\nCan not find Material Product';
                }else {
                    // System.debug('Product ID autopopulate');
                    // System.debug(value);
                    // System.debug(productIDMatGradCol);
                    if(productIDMatGradCol.containsKey(value)){
                        // System.debug('Product_Unique_ID__c inserted');
                        dataRow.Product_Unique_ID__c = productIDMatGradCol.get(value); 
                        dataRow.Product_Unique_ID_Name__c = productIDMatGradColName.get(value);
                    }
                   
                    // System.debug('map contains the product id');
                    // System.debug('Category autopopulated'+dataRow.Product_Category__c);
                    
                }
                
            }
            //Material Upload Material Validation
            if(String.isNotBlank(dataRow.Material__c)){
                // System.debug('Data row material grade color Material'+ dataRow.Material__c.toUpperCase());
                // System.debug(materialMaterialMap.containsKey(dataRow.Material__c.toUpperCase()));
                // System.debug('materialMaterialMap'+materialMaterialMap);
                if(!(materialMaterialMap.containsKey((dataRow.Material__c).toUpperCase()))){
                    // System.debug('product id not found');
                    isDataValid = false;
                    remarks += '\r\n Material value do not match with material list';
                    errorCode += 'ERR-5029,';
                    dataRow.Remarks__c += '\r\nMaterial value do not match with material list';
                    dataRow.Error_Code__c += 'ERR-5029,';
                }else {
                    // System.debug('map contains the Material from dataRow Material');
                    // System.debug('materialProductCategoryMap'+materialProductCategoryMap);
                    if(materialProductCategoryMap.containsKey(dataRow.Material__c.toUpperCase())){
                        // System.debug('Material found map fetched');
                        Map<String,String> mapfetched=materialProductCategoryMap.get(dataRow.Material__c.toUpperCase());
                        List<String> category = new List<String>();
                        category = mapfetched.values();
                        // System.debug('mapfetched.values()>>>'+category);
                        dataRow.Product_Category__c = category[0];
                        // System.debug('Value set to actegory'+dataRow.Product_Category__c);
                        // System.debug('Map fetched'+materialProductCategoryMap.get(dataRow.Material__c.toUpperCase()));
                    }

                    // System.debug('category not found for the material');
                }
            }
            
            //Material Upload Grade Validation
            if(String.isNotBlank(dataRow.Grade__c)){
                // System.debug('Data row material grade '+ dataRow.Grade__c);
                Map<String,String> fieldtoFieldMap = materialUploadGradeMap.get('fieldtoFieldMap');
                // System.debug(fieldtoFieldMap);
                if(!(fieldtoFieldMap.containsKey( (dataRow.Grade__c).toUpperCase()))){
                    // System.debug('Material Grade not found');
                    isDataValid = false;
                    remarks += '\r\n Grade value do not match with Grade list';
                    errorCode += 'ERR-5030,';
                    dataRow.Remarks__c += '\r\nGrade value do not match with Grade list';
                    dataRow.Error_Code__c += 'ERR-5030,';
                }
                else {
                    //  System.debug('list contains the Grade from Material Upload');
                    //   System.debug(gradeTypeMap);
                    //   System.debug(gradeTypeMap.containsKey((dataRow.Grade__c).toUpperCase()));
                    //   System.debug(gradeTypeMap.get((dataRow.Grade__c).toUpperCase()));
                      if (gradeTypeMap.containsKey((dataRow.Grade__c).toUpperCase())) {
                          dataRow.Type__c = gradeTypeMap.get((dataRow.Grade__c).toUpperCase());
                      }
                     }
                
                // System.debug('materialUploadGradeMap at validation'+materialUploadGradeMap);
                Map<String,String> gradeMap = new Map<String,String>();
                if(String.isNotBlank(dataRow.Material__c)){
                    if(materialUploadGradeMap.containsKey((dataRow.Material__c).toUpperCase())){
                        gradeMap= materialUploadGradeMap.get((dataRow.Material__c).toUpperCase());
                    }
                }
                // System.debug('grade map recieved at validation'+gradeMap);
                if(String.isNotBlank(dataRow.Grade__c)){                    
                    if (!(gradeMap.containsKey((dataRow.Grade__c).toUpperCase()))) {
                        // System.debug('Material Grade not found in dependent pick list');
                        isDataValid = false;
                        remarks += '\r\n Grade value do not match with Material-Grade combination';
                        errorCode += 'ERR-5031,';
                        dataRow.Remarks__c += '\r\nGrade value do not match with Material-Grade combination';
                        dataRow.Error_Code__c += 'ERR-5031,';
                    }
                    /* else {
                        System.debug('grade value matched with material');
                    } */
                }
            }
            
            //Material Upload color Validation
            if(String.isNotBlank(dataRow.Color__c) && String.isNotBlank(dataRow.Grade__c)){
                // System.debug('Data row material grade color'+ dataRow.Color__c);
                Map<String,String> fieldtoFieldMap = materialUploadColorMap.get('fieldtoFieldMap');
                // System.debug(fieldtoFieldMap);
                // System.debug(dataRow.Color__c.toUpperCase());
                // System.debug(fieldtoFieldMap.containsKey(dataRow.Color__c.toUpperCase()));
                if(!(fieldtoFieldMap.containsKey(dataRow.Color__c.toUpperCase()))){
                    // System.debug('Material Color not found');
                    isDataValid = false;
                    remarks += '\r\n Color value do not match with Color list';
                    errorCode += 'ERR-5032,';
                    dataRow.Remarks__c += '\r\nColor value do not match with Color list';
                    dataRow.Error_Code__c += 'ERR-5032,';
                }
                else {
                    dataRow.Color__c = (dataRow.Color__c).toUpperCase(); 
                    // System.debug('list contains the Grade from Material Upload');
                }
                    // System.debug('her getting colour map to check the colour based on material');
                    // System.debug(dataRow.Material__c);
                    Map<String,String> gradeMap = new Map<String,String>();
                    if(materialUploadColorMap.containsKey((dataRow.Grade__c).toUpperCase())){
                        gradeMap= materialUploadColorMap.get((dataRow.Grade__c).toUpperCase());
                        dataRow.Color__c = gradeMap.get(dataRow.Color__c);
                    }
                    // System.debug('map returned from get'+gradeMap+':'+dataRow.Color__c+':'+gradeMap.get(dataRow.Color__c));
                    if (!(gradeMap.containsKey(dataRow.Color__c))) {
                        // System.debug('Material Color not found in dependent pick list');
                        isDataValid = false;
                        remarks += '\r\n Color value do not match with Grade-Color combination';
                        errorCode += 'ERR-5033,';
                        dataRow.Remarks__c += '\r\nColor value do not match with Grade-Color combination';
                        dataRow.Error_Code__c += 'ERR-5033,';
                    }
                    /* else {
                        System.debug('COlour list matched with grade');
                    } */
            }

            // If color Value present and Grade == null
            if(String.isBlank(dataRow.Grade__c) && String.isNotBlank(dataRow.Color__c)){
                // System.debug('Material Color not found in dependent pick list');
                isDataValid = false;
                remarks += '\r\n Color value do not match with Grade-Color combination';
                errorCode += 'ERR-5033,';
                dataRow.Remarks__c += '\r\nColor value do not match with Grade-Color combination';
                dataRow.Error_Code__c += 'ERR-5033,';
            }
            
            //#Order Type Picklist check 
            if(String.isNotBlank((dataRow.Order_Type__c))){
                if(!(getMaterialUploadOrdertypePicklist.contains((dataRow.Order_Type__c).toUpperCase()))){
                    // System.debug('product id not found');
                    isDataValid = false;
                    dataRow.Order_Type_NF__c=true;
                    remarks += '\r\n Order Type value do not match with Order Type list';
                    errorCode += 'ERR-5035,';
                    dataRow.Remarks__c += '\r\nOrder Type value do not match with Order Type list';
                    dataRow.Error_Code__c += 'ERR-5035,';
                }
                /* else {
                    System.debug('order picklist value matched');
                } */
            }

            //#20 Supplier Name Validation
            if(String.isNotBlank((dataRow.Supplier_Name__c)) && (String.isNotBlank(dataRow.Supplier_Country_2__c)) ){
                String companyNameCountry = (dataRow.Supplier_Name__c).toUpperCase()+'#'+(dataRow.Supplier_Country_2__c).toUpperCase();
                
                // System.debug('Map company Name Cogs'+companyNameCogsCountryMap);
                // System.debug('kEY'+companyNameCountry);
                // System.debug('cONTAINS'+companyNameCogsCountryMap.containsKey(companyNameCountry));
                // System.debug('Value recieved'+dataRow.Supplier_Name__c);
                // System.debug('product id not found');
                if(!(companyNameCogsCountryMap.containsKey(companyNameCountry))){
                    isDataValid = false;
                    dataRow.Supplier_Name_NF__c=true;
                    remarks += '\r\n Supplier is not on list';
                    errorCode += 'ERR-5036,';
                    dataRow.Remarks__c += '\r\nSupplier is not on list';
                    dataRow.Error_Code__c += 'ERR-5036,';
                }else {
                    //auto populating the ID of partner object
                    // System.debug('supplier Name validated');
                    // System.debug('supplier Name 1 Map'+companyNameCossIdMap);
                    dataRow.Supplier_Name1__c=companyNameCossIdMap.get(companyNameCountry);
                    // System.debug('supplier name 1 updated'+dataRow.Supplier_Name1__c);
                }
            }
            //#22 Validation partner Cogs country validation
            if(String.isNotBlank((dataRow.Supplier_Country_2__c))){
                // System.debug('partnerCountryMap'+partnerCountryMap);
                if(!(partnerCountryMap.containsKey((dataRow.Supplier_Country_2__c).toUpperCase()))){
                    // System.debug('product id not found');
                    isDataValid = false;
                    dataRow.Supplier_Country_2_NF__c=true;
                    remarks += '\r\n Supplier Country value do not match with country list';
                    errorCode += 'ERR-5054,';
                    
                    dataRow.Remarks__c += '\r\nSupplier Country value do not match with country list';
                    dataRow.Error_Code__c += 'ERR-5054,';
                } else {
                    if(String.isNotBlank(dataRow.Supplier_Name__c)){
                        // System.debug(' Validation partner Cogs country validation success');
                        String companyNameCountry= (dataRow.Supplier_Name__c).toUpperCase()+'#'+(dataRow.Supplier_Country_2__c).toUpperCase();
                        // System.debug(' Companyname Country String'+companyNameCountry);
                        dataRow.Supplier_Code__c= companyNameSupplierCodeMap.get(companyNameCountry);
                        dataRow.Supplier_Group__c= companyNameSupplierGroupMap.get(companyNameCountry);
                        // System.debug('companyNameSupplierCodeMap'+companyNameSupplierCodeMap);
                        // System.debug('companyNameSupplierGroupMap'+companyNameSupplierGroupMap);
                        // System.debug('supplier code and group populated'+dataRow.Supplier_Code__c);
                        // System.debug('supplier code and group populated'+dataRow.Supplier_Group__c);
                        // System.debug('supplier values retrived');
                    }
                }
            }
            
            //#25 Validation partner purchase Term validation
            if(String.isNotBlank((dataRow.Purchase_Terms__c))){
                if(!(materialUploadPurchaseTermMap.containsKey((dataRow.Purchase_Terms__c).toUpperCase()))){
                    // System.debug('product id not found');
                    // System.debug(dataRow.Purchase_Terms__c);
                    isDataValid = false;
                    dataRow.Purchase_Terms_NF__c=true;
                    remarks += '\r\n Purchase Term value do not match with term list';
                    errorCode += 'ERR-5037,';
                    dataRow.Remarks__c += '\r\nPurchase Term value do not match with term list';
                    dataRow.Error_Code__c += 'ERR-5037,';
                }
                /* else {
                    System.debug('Purchase terms validated and matched with uploadmaterial');
                } */
            }

            // Validation of Freight_cost_to_factory
            if(String.isNotBlank(dataRow.Freight_cost_to_factory__c)){
                Boolean isDecimal = true;
               if(dataRow.Freight_cost_to_factory__c != null ){
                   try{
                       Decimal.valueOf(dataRow.Freight_cost_to_factory__c);
                       Decimal freightValue =Decimal.valueOf(dataRow.Freight_cost_to_factory__c);
                         System.debug(freightValue.scale()>2);
                         String freightLength = (dataRow.Freight_cost_to_factory__c).replaceAll(',','');
                       if(freightValue<0 || freightValue.scale()>2 || (dataRow.Freight_cost_to_factory__c).length() > 11){
                        dataRow.Freight_cost_to_factory_NF__c=true;
                        errorCode += 'ERR-5063,';
                        dataRow.Error_Code__c += 'ERR-5063,';
                        remarks += '\r\n Freight cost to factory should be Max 8 digits and should have 2 decimal point and value should be greater than Zero';
                        dataRow.Remarks__c += '\r\n Freight cost to factory should be Max 8 digits and should have 2 decimal point and value should be greater than Zero';
                        isDataValid = false;
                      }
                    }
                   catch(TypeException e){
                       isDecimal = false; 
                   }
            }
               if(!(isDecimal)){
                dataRow.Freight_cost_to_factory_NF__c = true;
                remarks += '\r\nFreight cost to factory must be number';
                errorCode += 'ERR-5063,';
                dataRow.Error_Code__c += 'ERR-5063,';
                dataRow.Remarks__c += '\r\nFreight cost to factory must be number';
                isDataValid = false;
            }
        }

            //validation Landed_cost_to_factory
            
            if(String.isNotBlank(dataRow.Landed_cost_to_factory__c)){
                Boolean isDecimal = true;
               if(dataRow.Landed_cost_to_factory__c != null ){
                   try{
                       Decimal dataValue = Decimal.valueOf(dataRow.Landed_cost_to_factory__c);
                       System.debug(dataValue.scale()>2);
                       String landedLength = (dataRow.Landed_cost_to_factory__c).replaceAll(',','');
                    System.debug('length check'+landedLength.length() > '11');
                       if(dataValue<0 || dataValue.scale()>2 || (dataRow.Landed_cost_to_factory__c).length() > 11){
                        dataRow.Landed_cost_to_factory_NF__c=true;
                        errorCode += 'ERR-5064,';
                        dataRow.Error_Code__c += 'ERR-5064,';
                        remarks += '\r\nLanded cost to factory should be Max 8 digits and should have 2 decimal point and value should be greater than Zero';
                        dataRow.Remarks__c += '\r\nLanded cost to factory should be Max 8 digits and should have 2 decimal point and value should be greater than Zero';
                        isDataValid = false;
                   }
                }
                   catch(TypeException e){
                       isDecimal = false; 
                   }
            }
            
               if(!(isDecimal)){
                dataRow.Landed_cost_to_factory_NF__c = true;
                remarks += '\r\nLanded cost to factory must be number';
                errorCode += 'ERR-5064,';
                dataRow.Error_Code__c += 'ERR-5064,';
                dataRow.Remarks__c += '\r\nLanded cost to factory must be number';
                isDataValid = false;
            }
        }



            //#26 Validation partner UOM validation
            Boolean uomIsValid = false; //used for Qty
            if(String.isNotBlank((dataRow.UOM__c))){
                // System.debug('  '+materialUploadUomMap);
                if(!(materialUploadUomMap.containsKey((dataRow.UOM__c).toUpperCase()))){
                    // System.debug('product id not found');
                    isDataValid = false;
                    dataRow.UOM_NF__c=true;
                    remarks += '\r\n UOM value do not match with UOM list';
                    errorCode += 'ERR-5038,';
                    dataRow.Remarks__c += '\r\nUOM value do not match with UOM list';
                    dataRow.Error_Code__c += 'ERR-5038,';
                    
                }
                else {
                    uomIsValid = true;
                    dataRow.UOM__c = (dataRow.UOM__c).toUpperCase();
                    // System.debug('partner UMO validated');
                }
            } 
            
            if(String.isNotBlank(String.valueOf(dataRow.QTY__c)) && uomIsValid){
                Boolean isInteger= (String.valueOf(dataRow.QTY__c.replaceAll('-',''))).isNumeric();
                Boolean isDecimal = true;
                try{
                    Decimal.valueOf(dataRow.QTY__c);
                }
                catch(TypeException e){
                    isDecimal = false; 
                }
                // System.debug('dataRow.QTY__c>>'+dataRow.QTY__c+'<<<<dataRow.UOM__c>>>'+dataRow.UOM__c);
                
                if((!isInteger || Decimal.valueOf(dataRow.QTY__c)==0)){
                    if( (!isInteger || Decimal.valueOf(dataRow.QTY__c)==0) && dataRow.UOM__c == 'PC'){
                        // System.debug('Inside pc');
                        dataRow.QTY_NF__c = true;
                        remarks += '\r\nWhen UOM is PC, QTY must be Integer';
                        errorCode += 'ERR-5039,';
                        dataRow.Error_Code__c += 'ERR-5039,';
                        dataRow.Remarks__c += '\r\nWhen UOM is PC, QTY must be Integer';
                        isDataValid = false;
                    }else if ( (!isDecimal || Decimal.valueOf(dataRow.QTY__c)==0) && dataRow.UOM__c != 'PC'){
                        // System.debug('Inside KG/..');
                        dataRow.QTY_NF__c = true;
                        remarks += '\r\nWhen UOM is KG/TONNIE, QTY must be number';
                        errorCode += 'ERR-5052,';
                        dataRow.Error_Code__c += 'ERR-5052,';
                        dataRow.Remarks__c += '\r\nWhen UOM is KG/TONNIE, QTY must be number';
                        isDataValid = false;
                    }
                }
            }
            
            /* if(String.isNotBlank(String.valueOf(dataRow.QTY__c))){
Boolean isInteger= (String.valueOf(dataRow.QTY__c)).isNumeric();
Boolean isNotInteger = (dataRow.QTY__c).contains('.');
System.debug('UOM');
System.debug(isInteger+':'+isNotInteger);
if(!((isNotInteger && !(isInteger) && !(uomIsValid))  // For checking weather it is Decimal and UOM is valid
&& ((dataRow.UOM__c).toUpperCase()=='PC')||((dataRow.UOM__c).toUpperCase()=='QTY'))){ //for checking UOM value 
dataRow.QTY_NF__c = true;
remarks += '\r\nWhen UOM is PC, QTY must be Integer';
errorCode += 'ERR-5039,';
dataRow.Error_Code__c += 'ERR-5039,';
dataRow.Remarks__c += '\r\nWhen UOM is PC, QTY must be Integer';
isDataValid = false;
}else if(!((!(isInteger) && !(uomIsValid)) 
&& ( ((dataRow.UOM__c).toUpperCase()=='KG') || ((dataRow.UOM__c).toUpperCase()=='TONNIE') ))){
dataRow.QTY_NF__c = true;
remarks += '\r\nWhen UOM is KG/TONNIE, QTY must be number';
errorCode += 'ERR-5052,';
dataRow.Error_Code__c += 'ERR-5052,';
dataRow.Remarks__c += '\r\nWhen UOM is KG/TONNIE, QTY must be number';
isDataValid = false;
}else {
System.debug('Quantity is a integer value checked');
}
} */
            //#28 Validation material upload purchase Currency validation 
            
            if(String.isNotBlank((dataRow.Purchase_Currency__c))){
                if(!(materialUploadPurchaseCurrencyMap.containsKey((dataRow.Purchase_Currency__c).toUpperCase()))){
                    // System.debug('product id not found');
                    isDataValid = false;
                    dataRow.Purchase_Currency_NF__c=true;
                    remarks += '\r\n Purchase Currency do not match with currency List';
                    errorCode += 'ERR-5040,';
                    
                    dataRow.Remarks__c += '\r\nPurchase Currency do not match with currency List';
                    dataRow.Error_Code__c += 'ERR-5040,';
                }else {
                    // System.debug('Purchase currency validated');
                    finalValidation = true;
                }
            } 
            //################ END OF VALIDATION #################
            // reprocessing for admin snippet ends here
            
            // System.debug('Endof Validation: '+isDataValid );
            if(!isDataValid){
                dataRow.Record_Status__c = '1 - Error In Data Validation';
                recordStatus.validateStatus= false;
            }else{
                // System.debug('inside else no data errors found and validated');
                if((dataRow.Record_Status__c!= null) && (dataRow.Record_Status__c.equals('1 - Error In Data Validation')))
                {
                    // System.debug('data record status is equal to Error in data validation');
                    // System.debug(dataRow.Record_Status__c);
                    recordStatus.validateStatus= false;
                }
                else{
                    // System.debug('data record status dety to success');
                    dataRow.Record_Status__c = '2 - Data Validation Successful';
                }
                
            }
            // System.debug('adding Data Row:'+dataRow);
            // System.debug('Data Rw ERROR:'+dataRow.Error_Code__c);
            // System.debug('Data Row:REMARKS'+dataRow.Remarks__c);
            materialTransStagUpdate.add(dataRow);
        }
        
        // System.debug('return Value: '+materialTransStagUpdate);
        return materialTransStagUpdate;
    }
    
    public  List<Material_Transaction_Stage__c>  reconcileDataWithMaterialErrorMapBulk(List<Material_Transaction_Stage__c> materialTransStagRecForReconciliation,  Map<string,Map<string,Map<string,string>>> fullMaterialErrorMap){     
        List<Material_Transaction_Stage__c> reconcileDataRowForUpdate = new List<Material_Transaction_Stage__c>();
        boolean reconcileComplete = true;
        // System.debug('inside Full material Error Map');
        // System.debug(fullMaterialErrorMap);
        List<String> keyList= new List<String>();
        for (String fieldName : fullMaterialErrorMap.keySet()){
            // System.debug('field name is ' + fieldName);
            keyList.add(fieldName);
        }
        // System.debug('out of error map loop');
        // System.debug(keyList); 
        
        for (Material_Transaction_Stage__c dataRow : materialTransStagRecForReconciliation) {
            
            // system.debug('fullMaterialErrorMap ::'+ fullMaterialErrorMap);
            if(dataRow != null){
                boolean dataReconciled = false;  
                boolean isErrorInRecord = false;
                boolean isRawMapAvailable = false;
                boolean isErrorMapHistory = false;
                Map<string,Map<string,string>> rawDataFieldMap;
                Map<string,string> mapFromToValueMap;
                String pickListValues='';  
                String errorMapHistory='{ ';
                // System.debug('Company material error mapping'+fullMaterialErrorMap.containsKey(dataRow.Mainetti_Company__c));
                if(String.isNotBlank(dataRow.Mainetti_Company__c)){
                    if (fullMaterialErrorMap.containsKey(dataRow.Mainetti_Company__c)) {
                        rawDataFieldMap = fullMaterialErrorMap.get(dataRow.Mainetti_Company__c);
                    }
                    // system.debug('rawDataFieldMap fetched::'+ rawDataFieldMap);
                    if(rawDataFieldMap != null){
                        isRawMapAvailable = true;                                                        
                    }
                }      
                // Error Data Mapping for Supplier Name
                if(String.isNotBlank(dataRow.Supplier_Name__c)){
                    if(isRawMapAvailable){
                        // System.debug('IsRaw Map Available');
                        if(rawDataFieldMap.containsKey('Supplier Name')){
                            mapFromToValueMap = rawDataFieldMap.get('Supplier Name');
                            if(mapFromToValueMap != null){
                                String mapFromValue = dataRow.Supplier_Name__c;
                                if(mapFromToValueMap.containsKey(mapFromValue.toLowerCase())){
                                    String mapToValue = mapFromToValueMap.get(mapFromValue.toLowerCase());
                                    if(String.isNotBlank(mapToValue)){
                                        dataRow.Supplier_Name__c= mapToValue;
                                        dataReconciled = true;
                                        isErrorMapHistory = true;
                                        errorMapHistory += '\r\n"Supplier Name":\n'+  '{' + '\n' + ' "From" :' + '"'  + mapFromValue +  '"' + ',' + '\n' +   ' "To" :' +  '"'  + mapToValue +  '"' + '\n' + '},';
                                        
                                    }
                                }else{
                                    if(String.isNotBlank(pickListValues)){
                                        pickListValues += ';'+ 'Supplier Name';
                                        // system.debug('pickListValues:::Year::001'+pickListValues);
                                    }else{
                                        pickListValues = 'Supplier Name';
                                        // system.debug('pickListValues:::Year::002'+pickListValues);
                                    }                                    
                                    dataReconciled = true;
                                    isErrorInRecord = true;
                                    
                                }
                            }
                            
                        }
                    }else {
                        if(String.isNotBlank(pickListValues)){
                            pickListValues += ';'+ 'Supplier Name';
                            // system.debug('pickListValues:::Year::001'+pickListValues);
                        }else{
                            pickListValues = 'Supplier Name';
                            // system.debug('pickListValues:::Year::002'+pickListValues);
                        }                                    
                        dataReconciled = true;
                        isErrorInRecord = true;
                    }
                }
                // Error Data mapping for supplier Country   
                if(String.isNotBlank(dataRow.Supplier_Country_2__c)){
                    if(isRawMapAvailable){
                        // System.debug('IsRaw Map Available');
                        if(rawDataFieldMap.containsKey('Supplier Country')){
                            mapFromToValueMap = rawDataFieldMap.get('Supplier Country');
                            if(mapFromToValueMap != null){
                                String mapFromValue = dataRow.Supplier_Country_2__c;
                                if(mapFromToValueMap.containsKey(mapFromValue.toLowerCase())){
                                    String mapToValue = mapFromToValueMap.get(mapFromValue.toLowerCase());
                                    if(String.isNotBlank(mapToValue)){
                                        dataRow.Supplier_Country_2__c= mapToValue;
                                        dataReconciled = true;
                                        isErrorMapHistory = true;
                                        errorMapHistory += '\r\n"Supplier Country":\n'+  '{' + '\n' + ' "From" :' + '"'  + mapFromValue +  '"' + ',' + '\n' +   ' "To" :' +  '"'  + mapToValue +  '"' + '\n' + '},';
                                        
                                    }
                                }else{
                                    if(String.isNotBlank(pickListValues)){
                                        pickListValues += ';'+ 'Supplier Country';
                                        // system.debug('pickListValues:::Year::001'+pickListValues);
                                    }else{
                                        pickListValues = 'Supplier Country';
                                        // system.debug('pickListValues:::Year::002'+pickListValues);
                                    }                                    
                                    dataReconciled = true;
                                    isErrorInRecord = true;
                                    
                                }
                            }
                            
                        }
                    }else {
                        if(String.isNotBlank(pickListValues)){
                            pickListValues += ';'+ 'Supplier Country';
                            // system.debug('pickListValues:::Year::001'+pickListValues);
                        }else{
                            pickListValues = 'Supplier Country';
                            // system.debug('pickListValues:::Year::002'+pickListValues);
                        }                                    
                        dataReconciled = true;
                        isErrorInRecord = true;
                    }
                }
                
                //check if there are any erro and action
                
                if(dataReconciled){                 
                    if(isErrorInRecord){
                        
                        // system.debug('pickListValues::::'+pickListValues);
                        dataRow.ErrorMapData__c = pickListValues ;                     
                        //  dataRow.Record_Status__c = '1 - Error In Data Validation';
                        reconcileComplete = false; 
                        
                    }
                    if(isErrorMapHistory){
                        dataRow.ErrorMapHistory__c = errorMapHistory +'\n}';
                        //  system.debug('dataRow.ErrorMapHistory__c::::'+dataRow.ErrorMapHistory__c);
                    }
                    reconcileDataRowForUpdate.add(dataRow);                                        
                }else{
                    reconcileDataRowForUpdate.add(dataRow);
                }
            }
        }
        /// Updating the reconciled data back into the stage table
        if(reconcileDataRowForUpdate.size() > 0){
            if (Schema.sObjectType.Material_Transaction_Stage__c.isUpdateable()) {
            update reconcileDataRowForUpdate;            
            }
        }
        
        return reconcileDataRowForUpdate;    
    }
    
    
}