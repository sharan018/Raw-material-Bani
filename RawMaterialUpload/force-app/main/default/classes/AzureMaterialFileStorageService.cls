public class AzureMaterialFileStorageService {

    Cogs_Sales_Upload__c detail = Cogs_Sales_Upload__c.getInstance();         
    String storageKey = detail.StorageKey__c;
    String storageName = detail.StorageName__c;
    String containerName = detail.Material_containerName__c;
    String downloadPath = detail.Material_File_Download_Path__c;
    string deletePath = detail.Material_File_Delete_Path__c;
    string sourcedownloadpath  = detail.Material_Source_File_Download_Path__c;
  
    public String mainAzureUserUpload(String batchId,String conVerTitle){
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
// system.debug('storageKey  >>>>>'+storageKey);
             Boolean createStatus = createFileRequest(storageName,storageKey, sourcedownloadpath, encodedfileName, fileLength);

            //  system.debug(LoggingLevel.WARN,'##################### createStatus :::'+createStatus + 'fileLength :::'+fileLength);
             if(createStatus){
                 Integer startRange = 0;
                 for(ContentVersion content : conVerList){
                     ContentVersion contentCSVData = getMastData.getCSVFileContent(content);
                     fileContent = EncodingUtil.base64Encode(contentCSVData.VersionData);   
                    //  system.debug(LoggingLevel.WARN,'##################### fileContent :::'+fileContent);
                     fileName = contentCSVData.PathOnClient;
                    //   system.debug(LoggingLevel.WARN,'##################### fileName :::'+fileName);
                     myBlob = EncodingUtil.base64Decode(fileContent);
                     Integer returnEndRange = putFileRequest(storageName, storageKey,sourcedownloadpath,encodedfileName,myBlob,startRange);
                     startRange = returnEndRange + 1;
                 }
             }
             encodedfileName = EncodingUtil.urlDecode(encodedfileName, 'UTF-8');
         }
    
         return encodedfileName;
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
            // system.debug('Create response into string'+res.toString());
            // system.debug('status>>> '+res.getStatus());
            // system.debug('status code>>> '+res.getStatusCode());
            if(res.getStatusCode() == 201){
                createStatus = true;
            }
        }
        catch (system.CalloutException ce){
            system.debug(LoggingLevel.ERROR,'##### Exceptionce During CalloutException createFileRequest:'+ce.getMessage());
        }
        return createStatus;
    }


    public static Integer putFileRequest(String account, String storageKey, String containerName,String encodedfileName,Blob myBlob,Integer startRange){
    
        String fileValue = myBlob.toString();
        
       // system.debug('myBlobSizeBefore: '+myBlob.size());
       // system.debug('fileSizeBefore: '+fileValue.length());
        if(startRange <> 0){
            fileValue = '\n' + myBlob.toString();
        }
        myBlob = null;
        Blob blobValue =Blob.valueOf(fileValue);
        
        
        //system.debug('myBlobSizeAfter: '+blobValue.size());
        //system.debug('fileSizeAfter: '+fileValue.length());
        
        Integer originalFileLength = blobValue.size();
        
        String startRnge = String.valueOf(startRange);    
        Integer returnEndRange = (startRange + originalFileLength - 1);
        String endRange = String.valueOf((startRange + originalFileLength - 1));
        // system.debug('startRnge:::::'+startRnge+'endRange::::'+endRange+'originalFileLength::::'+originalFileLength);
        String fileLength = String.valueof(originalFileLength);
        putFileRange(account,storageKey, containerName, encodedfileName, startRnge, endRange, fileLength,fileValue,blobValue);
        fileValue = null;
        blobValue = null;
        return returnEndRange;
    }


    public static void putFileRange(String account, String storageKey, String containerName,String encodedfileName,String startRange,String endRange,String fileLength,String fileVal,Blob blobValue){
    
        String contentType = 'text/csv; charset=UTF-8';        
        DateTime timestamp = Datetime.now().addMinutes(-5);               
        String reqdate = timestamp.formatGMT('EEE, dd MMM yyyy HH:mm:ss z');
        String bytesRange = startRange + '-' + endRange;
        // system.debug('bytesRange:::'+bytesRange);
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
        // system.debug('urlString::::'+urlString);
        request.setEndpoint(urlString);  
                
        Http http = new Http();
        HTTPResponse res = http.send(request);
    }

    
    public String mainAzureUploadDelete(String batchId,String fileNames,String fileData){
        Boolean uploadStatus = true;
        String fileName;
        String fileContent;
        String contentType;
        Blob myBlob;
        String encodedfileName;
        GetMaterialUploadMasterData getMastData = new GetMaterialUploadMasterData();
        List<ContentVersion> conVerList =  getMastData.getContentDocumentVerIds(batchId);
        Integer totalFileLength = 0;

                fileContent = EncodingUtil.base64Encode(blob.valueOf(fileData));
                // system.debug('fileContent:::'+fileContent);        
                fileName = fileNames;
                // system.debug('fileName:::'+fileName);  
                myBlob = EncodingUtil.base64Decode(fileContent);
                // system.debug('myBlob:::'+myBlob); 

                String fileValue = myBlob.toString();
                // system.debug('fileValue:::'+fileValue); 
                Blob blobValue =Blob.valueOf(fileValue);
                //  system.debug('blobValue:::'+blobValue); 

                totalFileLength = blobValue.size();
                // system.debug('totalFileLength:::'+totalFileLength);

                encodedfileName = EncodingUtil.urlEncode(fileNames, 'UTF-8');
                String fileLength = String.valueOf(totalFileLength);
                Boolean createStatus = createFileRequestDeletePath(storageName,storageKey, deletePath, encodedfileName, fileLength);
                // system.debug('createStatus'+createStatus);
                if(createStatus){
                Integer startRange = 0;
                // system.debug('conVerListSize'+conVerList.size());
               /* for(ContentVersion content : conVerList){
                    system.debug('conVerList>>'+conVerList);
                    ContentVersion contentCSVData = getMastData.getCSVFileContent(content);*/
                /*    fileContent = EncodingUtil.base64Encode(contentCSVData.VersionData);        
                    fileName = contentCSVData.PathOnClient;
                    myBlob = EncodingUtil.base64Decode(fileContent); */
                    // system.debug('beforeputFileRequestDeletePathReturnEndRange>>>>');
                    Integer returnEndRange = putFileRequestDeletePath(storageName, storageKey,deletePath,encodedfileName,myBlob,startRange);
                    // system.debug('returnEndRange'+returnEndRange);
                    //startRange = returnEndRange + 1;
               // }
            }
            encodedfileName = EncodingUtil.urlDecode(fileNames, 'UTF-8');

        return encodedfileName;
    }


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
           // system.debug('Create response into string'+res.toString());
           // system.debug('status>>> '+res.getStatus());
            //system.debug('status code>>> '+res.getStatusCode());
            if(res.getStatusCode() == 201){
                createStatus = true;
                // system.debug('##### createStatus:'+createStatus);
                // system.debug('##### createStatus:'+res.getBody());
            }
        }
        catch (system.CalloutException ce){
            //system.debug('##### Exceptionce During CalloutException createFileRequest:'+ce.getMessage());
        }
        return createStatus;
    }

    public static String getAuthenticationString(String stringToSign, String account, String storageKey){
            // system.debug('storageKey >>>>>>'+storageKey);
        Blob temp = EncodingUtil.base64Decode(storageKey);
        Blob hmac = Crypto.generateMac('HmacSHA256', Blob.valueOf(stringToSign), temp);
        String authKey = EncodingUtil.base64Encode(hmac);        
        String auth = 'SharedKey ' + account + ':' + authKey;
        return auth;
    }

    public static Integer putFileRequestDeletePath(String account, String storageKey, String deletePath,String encodedfileName,Blob myBlob,Integer startRange){
    
        String fileValue = myBlob.toString();
        
        //system.debug('myBlobSizeBefore: '+myBlob.size());
        //system.debug('fileSizeBefore: '+fileValue.length());
        if(startRange <> 0){
            fileValue = '\n' + myBlob.toString();
        }
        
        Blob blobValue =Blob.valueOf(fileValue);
        
        // system.debug('fileValue:>>>>'+fileValue);
        // system.debug('myBlobSizeAfter: '+blobValue.size());
        // system.debug('fileSizeAfter: '+fileValue.length());
        
        Integer originalFileLength = blobValue.size();
        
        String startRnge = String.valueOf(startRange);
        Integer returnEndRange = (startRange + originalFileLength - 1);
        String endRange = String.valueOf((startRange + originalFileLength - 1));
        // system.debug('endRange>>'+endRange);
        String fileLength = String.valueof(originalFileLength);
        putFileRangeDeletePath(account,storageKey, deletePath, encodedfileName, startRnge, endRange, fileLength,fileValue,blobValue);
        return returnEndRange;
    }

    public static void putFileRangeDeletePath(String account, String storageKey, String deletePath,String encodedfileName,String startRange,String endRange,String fileLength,String fileVal,Blob blobValue){
    
        // System.debug('INSIDE putFileRangeDeletePath');
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
        // System.debug('urlString>>'+urlString);
        request.setEndpoint(urlString);  
        
        Http http = new Http();
        HTTPResponse res = http.send(request);
        // system.debug('##### createStatus:'+res.getBody());
    }
    
    public String mainAzureUpload(String batchId,String conVerTitle){
        // Boolean uploadStatus = true;
        // String fileName,fileContent,contentType;
          String fileName;
          String fileContent;
         Blob myBlob;
         String encodedfileName;
         GetMaterialUploadMasterData getMastData = new GetMaterialUploadMasterData();
         List<ContentVersion> conVerList =  getMastData.getContentDocumentVerIds(batchId,conVerTitle);
        //   system.debug('conVerList:::'+conVerList);
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
             
             //to view the success file we need to change containerName to sourcedownloadpath
             Boolean createStatus = createFileRequest(storageName,storageKey, containerName, encodedfileName, fileLength);
            //  system.debug(LoggingLevel.WARN,'##################### createStatus :::'+createStatus + 'fileLength :::'+fileLength);
             
             if(createStatus){
                 Integer startRange = 0;
                 for(ContentVersion content : conVerList){
                     ContentVersion contentCSVData = getMastData.getCSVFileContent(content);
                     fileContent = EncodingUtil.base64Encode(contentCSVData.VersionData);   
                    //  system.debug(LoggingLevel.WARN,'##################### fileContent :::'+fileContent);
                     fileName = contentCSVData.PathOnClient;
                    //   system.debug(LoggingLevel.WARN,'##################### fileName :::'+fileName);
                     myBlob = EncodingUtil.base64Decode(fileContent);
                     
                     //to view the success file we need to change containerName to sourcedownloadpath
                     Integer returnEndRange = putFileRequest(storageName, storageKey,containerName,encodedfileName,myBlob,startRange);
                    
                     startRange = returnEndRange + 1;
                 }
             }
             encodedfileName = EncodingUtil.urlDecode(encodedfileName, 'UTF-8');
         }
    
         return encodedfileName;
     }
     
         //This method will generate the download link of a file stored in azure file storage.
public String downloadAzureFile(String fileName){

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
    
    return link;
}

public String downloadConvertedAzureFile(String fileName){

    fileName = fileName.replaceAll(' ', '+');
    //DateTime timestamp = Datetime.now().addDays(1);
    DateTime timestamp = Datetime.now().addMinutes(5);
    String reqdate = timestamp.formatGMT('yyyy-MM-dd\'T\'HH:mm:ss\'Z\'');        
    String link = 'https://'+ storageName +'.file.core.windows.net/'+ sourcedownloadpath + '/'+fileName;
    
    String spe = 'r';
    String st = '';
    String se = reqdate;
    String res = '/file/'+ storageName +'/'+ sourcedownloadpath + '/'+fileName;
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
    
    // system.debug('sts::::'+sts);
    // system.debug('Blob.valueOf(sts)::::'+Blob.valueOf(sts));
    // system.debug('EncodingUtil.base64Decode(storageKey)::::'+EncodingUtil.base64Decode(storageKey));
    Blob data = crypto.generateMac('HmacSHA256', Blob.valueOf(sts), EncodingUtil.base64Decode(storageKey));
    // system.debug('data::::'+data);
    String sas = EncodingUtil.base64Encode(data);
    // system.debug('sas1::::'+sas);
    sas = EncodingUtil.urlEncode(sas, 'UTF-8');
    // system.debug('sas2::::'+sas);
    link += '?sv=' + sv + '&se=' + se + '&sr=' + sr + '&sp=' + spe + '&sig=' + sas;
    // system.debug('link::::'+link);
    
    return link;
}
    

}