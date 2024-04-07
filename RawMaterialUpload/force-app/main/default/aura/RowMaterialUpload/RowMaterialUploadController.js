({
    show: function (component, event, helper) {

        component.set("v.toggleSpinner", false);
        // set default otion to material
        helper.defaultMaterial(component, helper);
        // Get month picklist values
        helper.month(component, event, helper);
        //Get month picklist values
        helper.batchStatus(component, event, helper);
        // Get year values from helper
        helper.getYear(component, event);
        helper.getsalesCompanyList(component, event);
        //Maintaince Modal PopUp
        helper.invoke(component, helper);
        if (component.get("v.openMaintainceModal") == true) {
            // helper.viewMaintainceAccess(component, helper);
            var today = new Date();
            var todayFormattedDate = today.getFullYear() + "-" + (today.getMonth() + 1) + "-" + today.getDate()
            var startDate = new Date(component.get("v.MaintainceStartDate"));
            var EndDate = new Date(component.get("v.MaintainceEndDate"));
            if (startDate <= today && today <= EndDate) {
                component.set("v.withinperiod", false);
            }
        }

    },

    FilterRecordsBasedOnYear: function (component, event, helper) {
        var year = component.find('yearLstval').get('v.value');
        var company = component.find('companyLstval').get('v.value');
        var batchStatus = component.find('batchLstval').get('v.value');
        if (year != 'Please Select a Year') {
            component.set('v.loaded', true);
            helper.getfilteredByYear(component, helper, year, company, batchStatus);
        }
        else {
            var text = 'Please select a proper year';
            helper.errorToast(component, event, helper, text);
        }
    },

    FilterRecordsBasedOnCompany: function (component, event, helper) {
        var company = component.find('companyLstval').get('v.value');
        var year = component.find('yearLstval').get('v.value');
        var month = component.find('batchLstval').get('v.value');
        if (company != 'Please Select a Company') {
            component.set('v.loaded', true);
            helper.getfilteredByYear(component, helper, year, company, month);
        }
        else {
            var text = 'Please select a proper Company';
            helper.errorToast(component, event, helper, text);
        }
    },

    FilterRecordsBasedOnBatchStatus: function (component, event, helper) {
        var company = component.find('companyLstval').get('v.value');
        // alert('company ::'+company);
        // alert('budPeriod ::'+budPeriod);
        var year = component.find('yearLstval').get('v.value');
        var month = component.find('batchLstval').get('v.value');
        // alert('batchstatus>>>'+month);
        if (company != 'Please Select a Company') {
            component.set('v.loaded', true);
            helper.getfilteredByYear(component, helper, year, company, month);
            // var set= component.set("v.selectedYear",year);
        }
        else {
            var text = 'Please select a proper Budget Period';
            helper.errorToast(component, event, helper, text);
        }
    },


    doInit: function (component) {
        var vfOrigin = "https://" + component.get("v.vfHost");
        window.addEventListener("message", function (event) {
            if (event.origin !== vfOrigin) {
            }
            // Handle the message
            if (event.data === 'Refresh') {
                window.location.reload();
            }
        }, false);
    },

    handleSalesCmpOnChange: function (component, event, helper) {
        var companysales = component.get("v.cmpsales.Sales_Data_Company__c");
        var set = component.set("v.selectedSalesCompany", companysales);
        var get = component.get("v.selectedSalesCompany");
    },

    handleMonthListOnChange: function (component, event, helper) {
        var month = component.find('monthList').get('v.value');
        var set = component.set("v.selectedMonth", month);

    },

    handleYearOnChange: function (component, event, helper) {
        var year = component.find('yearDynamicList').get('v.value');
        var set = component.set("v.selectedYear", year);
    },

    // function to get the error details of Inventory_Transaction_Stage__c,.    
    viewError: function (component, event, helper) {

        var batchId = event.getSource().get("v.name");
        component.set("v.BatchId", batchId);
        var evt = $A.get("e.force:navigateToComponent");
        evt.setParams({
            componentDef: "c:ViewMaterialErrorSummary",
            componentAttributes: {
                batchId: batchId
            }
        });
        evt.fire();
    },

    bulkFileProcess: function (component, event, helper) {
        //component.set("v.toggleSpinner", true);
        // alert('inside conttrollder');
        var buttonActive = component.get("v.isButtonActive");
        console.log(buttonActive);

        var allValid = true;
        if (!buttonActive) {
            component.set("v.toggleSpinner", true);
            component.set("v.isButtonActive", true);
            //component.set("v.openBulkUploadConfirmation",true);
            var fileInput = component.find("file").getElement();
            var file = fileInput.files[0];
            var recordstatus = component.get("v.itm.Record_Type__c");
            if (recordstatus == "") {
                document.getElementById('errorMissing').innerHTML = 'Please Select Record type!';
                component.set("v.toggleSpinner", false);
                allValid = false;
                component.set("v.isButtonActive", allValid);
                return;
            } else { allValid = true; }
            if (fileInput.value == "") {
                document.getElementById('errorMissing').innerHTML = 'You forgot to attach file!';
                component.set("v.toggleSpinner", false);
                allValid = false;
                component.set("v.isButtonActive", allValid);
                return;
            } else { allValid = true; }

            var extension = 'CSV';
            var extensionlowercase = extension.toLowerCase();
            //  alert(extensionlowercase)
            var fileextension = file.name.split(".").pop();

            // if(file.type!= 'application/vnd.ms-excel'){
            if (fileextension.toLowerCase() != extensionlowercase) {
                component.set("v.toggleSpinner", false);
                document.getElementById('errorMissing').innerHTML = 'Enter a valid file';
                allValid = false;
                component.set("v.isButtonActive", allValid);

                return;
            } else { allValid = true; }
            console.log("Before Calling PapaParser");

            Papa.parse(file, {
                complete: function (results) {
                    // console.log("Finished:", results.data);
                }

            });
            console.log("After Calling PapaParser");
            //  beforeFirstChunk: function( chunk ) {

            var batchNo = component.get("v.reuploadBatchNo");
            // helper.closeModal(component,helper);
            component.set("v.isButtonActive", allValid);
            // alert('befor parser');
            console.log('before parser' + allValid);
            helper.parseFile(component, file, batchNo, helper);
            //helper.closeModal(component,helper);
        }
    },

    newUpload: function (component, event, helper) {
        component.set("v.isButtonActive", false);
        component.set("v.reuploadBatchNo", '');
        component.set("v.isReupload", false);
        helper.openModal(component, helper);
        var today = new Date();
        var year = today.getFullYear();
        var month = today.getMonth();
        var monthArray = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
        // alert(month);
        component.set("v.selectedYear", year);
        component.set("v.selectedMonth", monthArray[month]);

    },

    closeModal: function (component, event, helper) {
        var modal = component.find("inventoryModal");
        var modalBackdrop = component.find("inventoryModalBackdrop");
        $A.util.removeClass(modal, "slds-fade-in-open");
        $A.util.removeClass(modalBackdrop, "slds-backdrop_open");
    },

    closeErrorModal: function (component, event, helper) {
        helper.closeErrorModal(component, helper);
    },
    closeModalopenFileDataSubmittedModal: function (component, event, helper) {
        helper.closeModalopenFileDataSubmittedModal(component, helper);
    },
    closeBulkUploadConfirmation: function (component, event, helper) {
        helper.closeBulkUploadConfirmation(component, helper);
    },

    reuploadfile: function (component, event, helper, batchId) {

        var batchId = event.getSource().get("v.name");
        helper.autoPopulateOnReupload(component, helper, batchId);
        component.set("v.reuploadBatchNo", batchId);
        component.set("v.isReupload", true);
        helper.openModal(component, helper);
    },
    //Onchange for Sales Minetti Company 

    /*handleSalesCmpOnSearch : function(component, event, helper) {
        var companysales = component.get("v.cmpsalesSearch.Sales_Data_Company__c");
     //   var set= component.set("v.selectedSalesCompanySearch",companysales);
      //  var get = component.get("v.selectedSalesCompanySearch");        
    },*/
    closeErrorFileFormatModal: function (component, event, helper) {
        var modal = component.find("errorFileFormatModal");
        var modalBackdrop = component.find("errorFileFormatModalBackdrop");
        $A.util.removeClass(modal, "slds-fade-in-open");
        $A.util.removeClass(modalBackdrop, "slds-backdrop_open");
    },
    closeDataSubmittedModal: function (component, event, helper) {
        var modal = component.find("dataSubmittedModal");
        var modalBackdrop = component.find("dataSubmittedModalBackdrop");
        $A.util.removeClass(modal, "slds-fade-in-open");
        $A.util.removeClass(modalBackdrop, "slds-backdrop_open");
    },

    //firing an event for admin access only.
    viewAdmin: function (component, event, helper) {
        var batchId = event.getSource().get("v.name");
        /* var evt = $A.get("e.force:navigateToComponent");
         evt.setParams({
             componentDef : "c:salesAdminAccess",
             componentAttributes: {
                 batchId : batchId
             }
         });
         evt.fire(); */
        helper.viewAdmintoProfileAccess(component, helper, batchId);
    },
    //To Delete the defunct Batch Records 
    deleteDefunctBatch: function (component, event, helper) {
        var batchId = event.getSource().get("v.name");
        event.getSource().set("v.disabled", true);
        component.set("v.toggleSpinner", true);
        helper.deleteDefunctBatch(component, helper, batchId);
    },

    downloadCSV: function (component, event, helper) {
        var fileName = event.getSource().get("v.name");
        // alert('ViewCSV>>'+fileName);
        var action = component.get("c.downloadCSVfile");
        action.setParams({
            "fileName": fileName
        });
        action.setCallback(this, function (response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var returnData = response.getReturnValue();
                window.open(returnData);
                console.log('returnData>>' + returnData);


            } else if (state === "ERROR") {
                var errors = response.getError();
                console.error(errors);
            }
        });
        $A.enqueueAction(action);
    },

    downloadConvertedCSV: function (component, event, helper) {
        var fileName = event.getSource().get("v.name");
        // alert('downloadCSV>>' + fileName);
        var action = component.get("c.downloadConvertedCSVfile");
        action.setParams({
            "fileName": fileName
        });
        action.setCallback(this, function (response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var returnData = response.getReturnValue();
                window.open(returnData);
                console.log('returnDatacon>>' + returnData);


            } else if (state === "ERROR") {
                var errors = response.getError();
                console.error(errors);
            }
        });
        $A.enqueueAction(action);
    },

    gotoURL_ViewUploadSummary: function (component, event, helper) {

        var urlEvent = $A.get("e.force:navigateToURL");
        urlEvent.setParams({
            "url": "/lightning/r/00O5h000000b1ELEAY/view"
        });
        urlEvent.fire();
    },
    deleteAdmin: function (component, event, helper) {
        var batchId = event.getSource().get("v.name");
        helper.deleteAdmintoProfileAccess(component, helper, batchId);
    },
    link: function (component, event, helper) {
        var batchId = event.getSource().get("v.name");
        component.find("navId").navigate({
            type: 'standard__recordPage',

            attributes: {
                recordId: batchId, // Hardcoded record id from given objectApiName
                actionName: 'view',  //Valid values include clone, edit, and view.
                objectApiName: 'Inventory_Transaction_Master__c' //The API name of the record’s object
            }
        }, true);

    },
    onclickContinueUpload: function (component, event, helper) {

        component.set("v.openMaintainceModal", false);
    }
})