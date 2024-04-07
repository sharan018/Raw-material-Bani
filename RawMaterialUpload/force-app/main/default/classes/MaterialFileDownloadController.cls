public with sharing class MaterialFileDownloadController {
    public Inventory_Transaction_Master__c invTransMast {get;set;}
    
    public MaterialFileDownloadController(ApexPages.StandardController sc) {
        SObject parent;
        parent  = sc.getRecord();
        invTransMast = [SELECT Id ,upload_file_name__c FROM Inventory_Transaction_Master__c where  Id =:parent.Id WITH SECURITY_ENFORCED ];
     
     }
     //returns storage key, storage name and container
    @RemoteAction
    public static MaterialFileDownloadController.AzureWrapper storageDetails(){    	
    	Cogs_Sales_Upload__c detail = Cogs_Sales_Upload__c.getInstance();
    	return new MaterialFileDownloadController.AzureWrapper(detail.storageKey__c, detail.storageName__c,detail.containerName__c);
    }
    
    public class AzureWrapper {
    
    	String storageKey;
    	String storageName;
    	String containerName;    	
    	
    	public AzureWrapper(String sk, String sn, String cn) {
    		//this.storageKey = sk;
    		//this.storageName = sn;  
            //this.containerName = cn;
            
            this.storageKey = 'jvgVaNt0NiDwLOuvX9HX5M8hliJF4TI1cQmKcfnALKpTJ6hJ5mtoX0ST2MaKdYEmTbJgCr89keEc8xvQltoF1A==';
    		this.storageName = 'mpdm01';
            this.containerName = 'mpdm01files';
        }
    }

}