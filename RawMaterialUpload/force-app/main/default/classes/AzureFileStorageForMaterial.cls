public class AzureFileStorageForMaterial { 
    
    Cogs_Sales_Upload__c detail = Cogs_Sales_Upload__c.getInstance();        
    String storageKey = detail.StorageKey__c;
    String storageName = detail.StorageName__c;
    String containerName = detail.Material_containerName__c; 
	String downloadPath = detail.Material_File_Download_Path__c;
    string deletePath = detail.Material_File_Delete_Path__c;
    //string deletePath = detail.Material_Source_File_Download_Path__c;
    string sourcedownloadPath = detail.Material_Source_File_Download_Path__c;
    
     //The below is for development testing. mcogs01files/SalesForce   mcogs01files/SalesForce/SalesUpload
   // String storageKey = 'jvgVaNt0NiDwLOuvX9HX5M8hliJF4TI1cQmKcfnALKpTJ6hJ5mtoX0ST2MaKdYEmTbJgCr89keEc8xvQltoF1A==';
   // String storageName = 'mpdm01';
  //  String containerName = 'mpdm01files/salesforce';
	//String downloadPath = 'mpdm01files/salesforce';

 /*   public String mainAzureUpload(String batchId){
        Boolean uploadStatus = true;
        String fileName,fileContent,contentType;
        Blob myBlob;
        String encodedfileName;
        getSalesMasterData getMastData = new getSalesMasterData();
        List<ContentVersion> conVerList =  getMastData.getContentDocumentVerIds(batchId);
        Integer totalFileLength = 0;
        
        if(conVerList.size() > 0){          
                for(integer i=0; i<conVerList.size(); i++){
                    ContentVersion contentCSVData = getMastData.getCSVFileContent(conVerList[i]);
                    fileContent = EncodingUtil.base64Encode(contentCSVData.VersionData);        
                    fileName = contentCSVData.PathOnClient;
                    myBlob = EncodingUtil.base64Decode(fileContent);
                    
                    String fileValue = myBlob.toString();
                    Blob blobValue =Blob.valueOf(fileValue);
                    
                    totalFileLength = totalFileLength + blobValue.size();
                    if(i < (conVerList.size() - 1)){
                        totalFileLength = totalFileLength + 1; //Adding additional 1 bytes since we are including '\n' while pushing to azure.
                    }
                }
            encodedfileName = EncodingUtil.urlEncode(conVerList[0].PathOnClient, 'UTF-8');
            String fileLength = String.valueOf(totalFileLength);
            // system.debug('##################### storageName :::'+storageName + '    storageKey :::'+storageKey + '    containerName :::'+containerName + '    encodedfileName :::'+encodedfileName + '    fileLength :::'+fileLength);
            Boolean createStatus = createFileRequest(storageName,storageKey, containerName, encodedfileName, fileLength);
            // system.debug('##################### createStatus :::'+createStatus + 'fileLength :::'+fileLength);
            if(createStatus){
                Integer startRange = 0;
                for(ContentVersion content : conVerList){
                    ContentVersion contentCSVData = getMastData.getCSVFileContent(content);
                    fileContent = EncodingUtil.base64Encode(contentCSVData.VersionData);   
                    // system.debug('##################### fileContent :::'+fileContent);
                    fileName = contentCSVData.PathOnClient;
                    //  system.debug('##################### fileName :::'+fileName);
                    myBlob = EncodingUtil.base64Decode(fileContent);
                    Integer returnEndRange = putFileRequest(storageName, storageKey,containerName,encodedfileName,myBlob,startRange);
                    startRange = returnEndRange + 1;
                }
            }
            encodedfileName = EncodingUtil.urlDecode(encodedfileName, 'UTF-8');
        }
   
        return encodedfileName;
    } */
     public String mainAzureUpload(String batchId,String conVerTitle){
       // Boolean uploadStatus = true;
       // String fileName,fileContent,contentType;
         String fileName;
         String fileContent;
        Blob myBlob;
        String encodedfileName;
        GetMaterialUploadMasterData getMastData = new GetMaterialUploadMasterData();
        List<ContentVersion> conVerList =  getMastData.getContentDocumentVerIds(batchId,conVerTitle);
        Integer totalFileLength = 0;
        
        if(conVerList.size() > 0){          
                for(integer i=0; i<conVerList.size(); i++){
                    ContentVersion contentCSVData = getMastData.getCSVFileContent(conVerList[i]);
                    fileContent = EncodingUtil.base64Encode(contentCSVData.VersionData);        
                    fileName = contentCSVData.PathOnClient;
                    myBlob = EncodingUtil.base64Decode(fileContent);
                    
                    String fileValue = myBlob.toString();
                    Blob blobValue =Blob.valueOf(fileValue);
                    
                    totalFileLength = totalFileLength + blobValue.size();
                    if(i < (conVerList.size() - 1)){
                        totalFileLength = totalFileLength + 1; //Adding additional 1 bytes since we are including '\n' while pushing to azure.
                    }
                }
            encodedfileName = EncodingUtil.urlEncode(conVerList[0].PathOnClient, 'UTF-8');
            String fileLength = String.valueOf(totalFileLength);
            Boolean createStatus = createFileRequest(storageName,storageKey, containerName, encodedfileName, fileLength);
            // system.debug(LoggingLevel.INFO,'##################### createStatus :::'+createStatus + 'fileLength :::'+fileLength);
            if(createStatus){
                Integer startRange = 0;
                for(ContentVersion content : conVerList){
                    ContentVersion contentCSVData = getMastData.getCSVFileContent(content);
                    fileContent = EncodingUtil.base64Encode(contentCSVData.VersionData);   
                    // system.debug(LoggingLevel.WARN,'##################### fileContent :::'+fileContent);
                    fileName = contentCSVData.PathOnClient;
                    //  system.debug(LoggingLevel.WARN,'##################### fileName :::'+fileName);
                    myBlob = EncodingUtil.base64Decode(fileContent);
                    Integer returnEndRange = putFileRequest(storageName, storageKey,containerName,encodedfileName,myBlob,startRange);
                    startRange = returnEndRange + 1;
                }
            }
            encodedfileName = EncodingUtil.urlDecode(encodedfileName, 'UTF-8');
        }
   
        return encodedfileName;
    }
    
    
     public String mainAzureUploadSource(String batchId,String conVerTitle){
        //  system.debug(LoggingLevel.WARN,'batchId ::'+batchId);
        //  system.debug(LoggingLevel.WARN,'conVerTitle ::'+conVerTitle);
       // Boolean uploadStatus = true;
        // String fileName,fileContent,contentType;
         String fileName;
         String fileContent;
        Blob myBlob;
        String encodedfileName;
        GetMaterialUploadMasterData getMastData = new GetMaterialUploadMasterData();
        List<ContentVersion> conVerList =  getMastData.getContentDocumentVerIds(batchId,conVerTitle);
        Integer totalFileLength = 0;
        
        if(conVerList.size() > 0){          
                for(integer i=0; i<conVerList.size(); i++){
                    ContentVersion contentCSVData = getMastData.getCSVFileContent(conVerList[i]);
                    fileContent = EncodingUtil.base64Encode(contentCSVData.VersionData);        
                    fileName = contentCSVData.PathOnClient;
                    myBlob = EncodingUtil.base64Decode(fileContent);
                    
                    String fileValue = myBlob.toString();
                    Blob blobValue =Blob.valueOf(fileValue);
                    
                    totalFileLength = totalFileLength + blobValue.size();
                    if(i < (conVerList.size() - 1)){
                        totalFileLength = totalFileLength + 1; //Adding additional 1 bytes since we are including '\n' while pushing to azure.
                    }
                }
            encodedfileName = EncodingUtil.urlEncode(conVerList[0].PathOnClient, 'UTF-8');
            String fileLength = String.valueOf(totalFileLength);
            Boolean createStatus = createFileRequest(storageName,storageKey, sourcedownloadPath, encodedfileName, fileLength);
            // system.debug(LoggingLevel.WARN,'##################### createStatus :::'+createStatus + 'fileLength :::'+fileLength);
            if(createStatus){
                Integer startRange = 0;
                for(ContentVersion content : conVerList){
                    ContentVersion contentCSVData = getMastData.getCSVFileContent(content);
                    fileContent = EncodingUtil.base64Encode(contentCSVData.VersionData);   
                    // system.debug(LoggingLevel.WARN,'##################### fileContent :::'+fileContent);
                    fileName = contentCSVData.PathOnClient;
                    //  system.debug(LoggingLevel.WARN,'##################### fileName :::'+fileName);
                    myBlob = EncodingUtil.base64Decode(fileContent);
                    Integer returnEndRange = putFileRequest(storageName, storageKey,sourcedownloadPath,encodedfileName,myBlob,startRange);
                    startRange = returnEndRange + 1;
                }
            }
            encodedfileName = EncodingUtil.urlDecode(encodedfileName, 'UTF-8');
        }
   
        return encodedfileName;
    }
     
   /* public Static Void salesBudegtUploadToAzure(String batchId){
         Cogs_Sales_Upload__c detail = Cogs_Sales_Upload__c.getInstance();        
    String storageKey = detail.StorageKey__c;
    String storageName = detail.StorageName__c;
    String containerName = detail.containerName__c;
	String downloadPath = detail.File_Download_Path__c;
    string deletePath = detail.File_Delete_Path__c;
        Boolean uploadStatus = true;
        String fileName,fileContent,contentType;
        Blob myBlob;
        String encodedfileName;
        getSalesMasterData getMastData = new getSalesMasterData();
        List<ContentVersion> conVerList =  getMastData.getContentDocumentVerIds(batchId);
        Integer totalFileLength = 0;
        
        if(conVerList.size() > 0){
            
           
            
                for(integer i=0; i<conVerList.size(); i++){
                    ContentVersion contentCSVData = getMastData.getCSVFileContent(conVerList[i]);
                    fileContent = EncodingUtil.base64Encode(contentCSVData.VersionData);        
                    fileName = contentCSVData.PathOnClient;
                    myBlob = EncodingUtil.base64Decode(fileContent);
                    
                    String fileValue = myBlob.toString();
                    Blob blobValue =Blob.valueOf(fileValue);
                    
                    totalFileLength = totalFileLength + blobValue.size();
                    if(i < (conVerList.size() - 1)){
                        totalFileLength = totalFileLength + 1; //Adding additional 1 bytes since we are including '\n' while pushing to azure.
                    }
                }
            encodedfileName = EncodingUtil.urlEncode(conVerList[0].PathOnClient, 'UTF-8');
            String fileLength = String.valueOf(totalFileLength);
            Boolean createStatus = createFileRequest(storageName,storageKey, containerName, encodedfileName, fileLength);
            if(createStatus){
                Integer startRange = 0;
                for(ContentVersion content : conVerList){
                    ContentVersion contentCSVData = getMastData.getCSVFileContent(content);
                    fileContent = EncodingUtil.base64Encode(contentCSVData.VersionData);        
                    fileName = contentCSVData.PathOnClient;
                    myBlob = EncodingUtil.base64Decode(fileContent);
                    Integer returnEndRange = putFileRequest(storageName, storageKey,containerName,encodedfileName,myBlob,startRange);
                    startRange = returnEndRange + 1;
                }
            }
            encodedfileName = EncodingUtil.urlDecode(encodedfileName, 'UTF-8');
        }
   
    }*/
    
    
    // Added by Sai 19-03-2021
    public String mainAzureUploadDelete(String batchId,String fileNames,String fileData){
       // Boolean uploadStatus = true;
        // String fileName,fileContent,contentType;
         String fileName;
         String fileContent;
        Blob myBlob;
        String encodedfileName;
        GetMaterialUploadMasterData getMastData = new GetMaterialUploadMasterData();
        // List<ContentVersion> conVerList =  
        getMastData.getContentDocumentVerIds(batchId);
        Integer totalFileLength = 0;
        
     //   if(conVerList.size() > 0){
            
           
            
             //   for(integer i=0; i<conVerList.size(); i++){
                  //  ContentVersion contentCSVData = getMastData.getCSVFileContent(conVerList[i]);
                    fileContent = EncodingUtil.base64Encode(blob.valueOf(fileData));
					// system.debug(LoggingLevel.WARN,'fileContent:::'+fileContent);        
                    fileName = fileNames;
        // system.debug(LoggingLevel.WARN,'fileName:::'+fileName);  
                    myBlob = EncodingUtil.base64Decode(fileContent);
        // system.debug(LoggingLevel.WARN,'myBlob:::'+myBlob); 
                    
                    String fileValue = myBlob.toString();
        // system.debug(LoggingLevel.WARN,'fileValue:::'+fileValue); 
                    Blob blobValue =Blob.valueOf(fileValue);
        // system.debug(LoggingLevel.WARN,'blobValue:::'+blobValue); 
                    
                    totalFileLength = blobValue.size();
        // system.debug(LoggingLevel.WARN, 'totalFileLength:::'+totalFileLength);
                  /*  if(i < (conVerList.size() - 1)){
                        totalFileLength = totalFileLength + 1; //Adding additional 1 bytes since we are including '\n' while pushing to azure.
                    }*/
            //    }
            try {
                encodedfileName = EncodingUtil.urlEncode(fileNames, 'UTF-8');
                String fileLength = String.valueOf(totalFileLength);
                Boolean createStatus = createFileRequestDeletePath(storageName,storageKey, deletePath, encodedfileName, fileLength);
                Integer returnEndRange;
                if(createStatus){
                    Integer startRange = 0;
                   /* for(ContentVersion content : conVerList){
                        ContentVersion contentCSVData = getMastData.getCSVFileContent(content);
                        fileContent = EncodingUtil.base64Encode(contentCSVData.VersionData);        
                        fileName = contentCSVData.PathOnClient;
                        myBlob = EncodingUtil.base64Decode(fileContent); */
                        returnEndRange = putFileRequestDeletePath(storageName, storageKey,deletePath,encodedfileName,myBlob,startRange);
                        //startRange = returnEndRange + 1;
                    //}
                }
                if(returnEndRange == null){
                    encodedfileName = null;
                }    
            } catch (Exception e) {
                 encodedfileName = null;
                // System.debug('Exception Occured'+e.getMessage());
            }
        // system.debug('encodedfileName >>>>>>'+encodedfileName);
        return encodedfileName;
    }
    
    public static Integer putFileRequest(String account, String storageKey, String containerName,String encodedfileName,Blob myBlob,Integer startRange){
        
        String fileValue = myBlob.toString();
        
        // system.debug(LoggingLevel.WARN,'myBlobSizeBefore: '+myBlob.size());
        // system.debug(LoggingLevel.WARN,'fileSizeBefore: '+fileValue.length());
        if(startRange <> 0){
            fileValue = '\n' + myBlob.toString();
        }
        
        Blob blobValue =Blob.valueOf(fileValue);
        
        // system.debug(LoggingLevel.WARN,'myBlobSizeAfter: '+blobValue.size());
        // system.debug(LoggingLevel.WARN,'fileSizeAfter: '+fileValue.length());
        
        Integer originalFileLength = blobValue.size();
        
        String startRnge = String.valueOf(startRange);
        Integer returnEndRange = (startRange + originalFileLength - 1);
        String endRange = String.valueOf((startRange + originalFileLength - 1));
        String fileLength = String.valueof(originalFileLength);
        putFileRange(account,storageKey, containerName, encodedfileName, startRnge, endRange, fileLength,fileValue,blobValue);
        return returnEndRange;
    }
    
    //Create a empty file in the azure file storage before inserting the contents.
    public static boolean createFileRequest(String account, String storageKey, String containerName,String encodedfileName,String fileLength){

        Boolean createStatus = false;        
        String contentType = 'text/csv; charset=UTF-8';        
        DateTime timestamp = Datetime.now().addMinutes(-5);       
        String reqdate = timestamp.formatGMT('EEE, dd MMM yyyy HH:mm:ss z');
       //create a file
        String stringToSign =  'PUT\n'
            + '\n' // content encoding
            + '\n' // content language
            + '\n' // content length
            + '\n' // content md5
            + contentType + '\n' // content type
            + '\n' // date
            + '\n' // if modified since
            + '\n' // if match
            + '\n' // if none match
            + '\n' // if unmodified since
            + '\n' // range            
            + 'x-ms-content-length:'+fileLength+'\n'
            + 'x-ms-date:' + reqdate + '\n' + 'x-ms-type:file' + '\n' + 'x-ms-version:2017-07-29\n' //headers 
            + '/'+account +'/'+containerName+'/'+encodedfileName;
        

        String auth = getAuthenticationString(stringToSign,account,storageKey);
        HttpRequest request = new HttpRequest();
        request.setMethod('PUT');
        request.setHeader('Authorization', auth);  
        request.setHeader('x-ms-content-length', fileLength); 
        request.setHeader('x-ms-version', '2017-07-29');
        request.setHeader('x-ms-date', reqdate);
        request.setHeader('x-ms-type', 'file');
        request.setHeader('Content-Type', contentType);
        request.setBody('');
 		         
        String urlString = 'https://' + account + '.file.core.windows.net/'+containerName+'/'+encodedfileName;
        request.setEndpoint(urlString);
        
        try{      
            Http http = new Http();
            HTTPResponse res = http.send(request);
            // system.debug(LoggingLevel.WARN,'Create response into string'+res.toString());
            System.debug(LoggingLevel.INFO,'encodedfileName'+encodedfileName);
            system.debug(LoggingLevel.WARN,'status>>> '+res.getStatus());
            system.debug(LoggingLevel.WARN,'status code>>> '+res.getStatusCode());
            if(res.getStatusCode() == 201){
                createStatus = true;
            }
        }
        catch (system.CalloutException ce){
            createStatus = false;
            system.debug(LoggingLevel.WARN,'##### Exceptionce During CalloutException createFileRequest:'+ce.getMessage());
        }
        return createStatus;
    }
    
    
    
    //Inserting the file contents.
    public static void putFileRange(String account, String storageKey, String containerName,String encodedfileName,String startRange,String endRange,String fileLength,String fileVal,Blob blobValue){
        
        String contentType = 'text/csv; charset=UTF-8';        
        DateTime timestamp = Datetime.now().addMinutes(-5);               
        String reqdate = timestamp.formatGMT('EEE, dd MMM yyyy HH:mm:ss z');
        String bytesRange = startRange + '-' + endRange;
        String stringToSign =  'PUT\n'
            + '\n' // content encoding
            + '\n' // content language
            + fileLength + '\n' // content length
            + '\n' // content md5
            + contentType + '\n' // content type
            + '\n' // date
            + '\n' // if modified since
            + '\n' // if match
            + '\n' // if none match
            + '\n' // if unmodified since
            + '\n' // range
            + 'x-ms-date:' + reqdate + '\n'            
            + 'x-ms-range:bytes=' +bytesRange + '\n'
     		+ 'x-ms-version:2014-02-14\n'
            + 'x-ms-write:update\n'
            + '/'+account +'/'+containerName+'/'+encodedfileName+'\n'
            + 'comp:range'; 
        
        String auth = getAuthenticationString(stringToSign,account,storageKey);
        HttpRequest request = new HttpRequest();
        request.setMethod('PUT');
        request.setHeader('Authorization', auth);
        request.setHeader('x-ms-range','bytes='+ bytesRange); 
        request.setHeader('x-ms-version', '2014-02-14');
        request.setHeader('x-ms-date', reqdate);
        request.setHeader('x-ms-write', 'update');
        request.setHeader('Content-Type', contentType);
        request.setBodyAsBlob(blobValue);
       
        
        String urlString = 'https://' + account + '.file.core.windows.net/'+containerName+'/'+encodedfileName +'?comp=range';
        request.setEndpoint(urlString);  
             
        Http http = new Http();
        // HTTPResponse res = 
        http.send(request);
    }
    
    public static String getAuthenticationString(String stringToSign, String account, String storageKey){
               
        Blob temp = EncodingUtil.base64Decode(storageKey);
        Blob hmac = Crypto.generateMac('HmacSHA256', Blob.valueOf(stringToSign), temp);
        String authKey = EncodingUtil.base64Encode(hmac);        
        String auth = 'SharedKey ' + account + ':' + authKey;
        return auth;
    }
    
    //This method will generate the download link of a file stored in azure file storage.
    public String downloadAzureFile(String fileName){

        fileName = fileName.replaceAll(' ', '+');
        //DateTime timestamp = Datetime.now().addDays(1);
        DateTime timestamp = Datetime.now().addMinutes(5);
        String reqdate = timestamp.formatGMT('yyyy-MM-dd\'T\'HH:mm:ss\'Z\'');        
        String link = 'https://'+ storageName +'.file.core.windows.net/'+ sourcedownloadPath + '/'+fileName;
        
        String spe = 'r';
        String st = '';
        String se = reqdate;
        String res = '/file/'+ storageName +'/'+ sourcedownloadPath + '/'+fileName;
        String si = '';
        String sip = '';
        String spr = '';
        String sr = 'f';
        String sv = '2017-11-09';
        String rscc = '';
        String rscd = '';
        String rsce = '';
        String rscl = '';
        String rsct = '';
        
        String sts = spe + '\n'  +
            st + '\n' +
            se + '\n' +
            res + '\n' +
            si + '\n' +
            sip + '\n' +
            spr + '\n'+
            sv + '\n' +
            rscc + '\n' +
            rscd + '\n' +
            rsce + '\n' +
            rscl + '\n' +
            rsct;
        
        Blob data = crypto.generateMac('HmacSHA256', Blob.valueOf(sts), EncodingUtil.base64Decode(storageKey));
        String sas = EncodingUtil.base64Encode(data);
        sas = EncodingUtil.urlEncode(sas, 'UTF-8');
        link += '?sv=' + sv + '&se=' + se + '&sr=' + sr + '&sp=' + spe + '&sig=' + sas;
        // system.debug('link >>>>'+link);
        return link;
    }
    
    
     //This method will generate the download link of a file stored in Converted azure file storage.
    public String downloadConvertedAzureFile(String fileName){

        fileName = fileName.replaceAll(' ', '+');
        //DateTime timestamp = Datetime.now().addDays(1);
        DateTime timestamp = Datetime.now().addMinutes(5);
        String reqdate = timestamp.formatGMT('yyyy-MM-dd\'T\'HH:mm:ss\'Z\'');        
        String link = 'https://'+ storageName +'.file.core.windows.net/'+ downloadPath + '/'+fileName;
        
        String spe = 'r';
        String st = '';
        String se = reqdate;
        String res = '/file/'+ storageName +'/'+ downloadPath + '/'+fileName;
        String si = '';
        String sip = '';
        String spr = '';
        String sr = 'f';
        String sv = '2017-11-09';
        String rscc = '';
        String rscd = '';
        String rsce = '';
        String rscl = '';
        String rsct = '';
        
        String sts = spe + '\n'  +
            st + '\n' +
            se + '\n' +
            res + '\n' +
            si + '\n' +
            sip + '\n' +
            spr + '\n'+
            sv + '\n' +
            rscc + '\n' +
            rscd + '\n' +
            rsce + '\n' +
            rscl + '\n' +
            rsct;
        
        Blob data = crypto.generateMac('HmacSHA256', Blob.valueOf(sts), EncodingUtil.base64Decode(storageKey));
        String sas = EncodingUtil.base64Encode(data);
        sas = EncodingUtil.urlEncode(sas, 'UTF-8');
        link += '?sv=' + sv + '&se=' + se + '&sr=' + sr + '&sp=' + spe + '&sig=' + sas;
        //  system.debug('link >>>>'+link);
        return link;
    }
    
    
    // Added by Sai 24-03-2020
    public static Integer putFileRequestDeletePath(String account, String storageKey, String deletePath,String encodedfileName,Blob myBlob,Integer startRange){
        
        String fileValue = myBlob.toString();
        
        // system.debug(LoggingLevel.WARN,'myBlobSizeBefore: '+myBlob.size());
        // system.debug(LoggingLevel.WARN,'fileSizeBefore: '+fileValue.length());
        if(startRange <> 0){
            fileValue = '\n' + myBlob.toString();
        }
        
        Blob blobValue =Blob.valueOf(fileValue);
        
        // system.debug(LoggingLevel.WARN,'myBlobSizeAfter: '+blobValue.size());
        // system.debug(LoggingLevel.WARN,'fileSizeAfter: '+fileValue.length());
        
        Integer originalFileLength = blobValue.size();
        
        String startRnge = String.valueOf(startRange);
        Integer returnEndRange = (startRange + originalFileLength - 1);
        String endRange = String.valueOf((startRange + originalFileLength - 1));
        String fileLength = String.valueof(originalFileLength);
        Boolean deleteConfirm = putFileRangeDeletePath(account,storageKey, deletePath, encodedfileName, startRnge, endRange, fileLength,fileValue,blobValue);
        if(!deleteConfirm){
            returnEndRange = null;
        }
        return returnEndRange;
    }
    
    //Create a empty file in the azure file storage before inserting the contents.
    //Added by Sai 24-03-2020
    public static boolean createFileRequestDeletePath(String account, String storageKey, String deletePath,String encodedfileName,String fileLength){

        Boolean createStatus = false;        
        String contentType = 'text/csv; charset=UTF-8';        
        DateTime timestamp = Datetime.now().addMinutes(-5);       
        String reqdate = timestamp.formatGMT('EEE, dd MMM yyyy HH:mm:ss z');
       //create a file
        String stringToSign =  'PUT\n'
            + '\n' // content encoding
            + '\n' // content language
            + '\n' // content length
            + '\n' // content md5
            + contentType + '\n' // content type
            + '\n' // date
            + '\n' // if modified since
            + '\n' // if match
            + '\n' // if none match
            + '\n' // if unmodified since
            + '\n' // range            
            + 'x-ms-content-length:'+fileLength+'\n'
            + 'x-ms-date:' + reqdate + '\n' + 'x-ms-type:file' + '\n' + 'x-ms-version:2017-07-29\n' //headers 
            + '/'+account +'/'+deletePath+'/'+encodedfileName;
        

        String auth = getAuthenticationString(stringToSign,account,storageKey);
        HttpRequest request = new HttpRequest();
        request.setMethod('PUT');
        request.setHeader('Authorization', auth);
         
        request.setHeader('x-ms-content-length', fileLength); 
        request.setHeader('x-ms-version', '2017-07-29');
        request.setHeader('x-ms-date', reqdate);
        request.setHeader('x-ms-type', 'file');
        request.setHeader('Content-Type', contentType);
        request.setBody('');
 		         
        String urlString = 'https://' + account + '.file.core.windows.net/'+deletePath+'/'+encodedfileName;
        request.setEndpoint(urlString);
        
        try{      
            Http http = new Http();
            HTTPResponse res = http.send(request);
            // system.debug(LoggingLevel.WARN,'Create response into string'+res.toString());
            // system.debug(LoggingLevel.WARN,'status>>> '+res.getStatus());
            // system.debug(LoggingLevel.WARN,'status code>>> '+res.getStatusCode());
            if(res.getStatusCode() == 201){
                createStatus = true;
                // system.debug(LoggingLevel.WARN,'##### createStatus:'+createStatus);
            }
        }
        catch (system.CalloutException ce){
             createStatus = false;
            // system.debug(LoggingLevel.WARN,'##### Exceptionce During CalloutException createFileRequest:'+ce.getMessage());
        }
        return createStatus;
    }
    
    //Inserting the file contents.
    //Added by Sai 24-03-2020
    public static Boolean putFileRangeDeletePath(String account, String storageKey, String deletePath,String encodedfileName,String startRange,String endRange,String fileLength,String fileVal,Blob blobValue){
        
        String contentType = 'text/csv; charset=UTF-8';        
        DateTime timestamp = Datetime.now().addMinutes(-5);               
        String reqdate = timestamp.formatGMT('EEE, dd MMM yyyy HH:mm:ss z');
        String bytesRange = startRange + '-' + endRange;
        String stringToSign =  'PUT\n'
            + '\n' // content encoding
            + '\n' // content language
            + fileLength + '\n' // content length
            + '\n' // content md5
            + contentType + '\n' // content type
            + '\n' // date
            + '\n' // if modified since
            + '\n' // if match
            + '\n' // if none match
            + '\n' // if unmodified since
            + '\n' // range
            + 'x-ms-date:' + reqdate + '\n'            
            + 'x-ms-range:bytes=' +bytesRange + '\n'
     		+ 'x-ms-version:2014-02-14\n'
            + 'x-ms-write:update\n'
            + '/'+account +'/'+deletePath+'/'+encodedfileName+'\n'
            + 'comp:range'; 
        
        String auth = getAuthenticationString(stringToSign,account,storageKey);
        HttpRequest request = new HttpRequest();
        request.setMethod('PUT');
        request.setHeader('Authorization', auth);
        request.setHeader('x-ms-range','bytes='+ bytesRange); 
        request.setHeader('x-ms-version', '2014-02-14');
        request.setHeader('x-ms-date', reqdate);
        request.setHeader('x-ms-write', 'update');
        request.setHeader('Content-Type', contentType);
        request.setBodyAsBlob(blobValue);
       
        
        String urlString = 'https://' + account + '.file.core.windows.net/'+deletePath+'/'+encodedfileName +'?comp=range';
        request.setEndpoint(urlString);  
             
        Http http = new Http();
        HTTPResponse res = http.send(request);
        if(res.getStatus() == 'Created'){
            return true;
        }
        else{
            return false;
        }
    }
    
    
}