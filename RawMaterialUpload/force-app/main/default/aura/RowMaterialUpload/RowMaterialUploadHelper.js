({
  // Upload type is set to material
  defaultMaterial: function (component, helper) {
    component.set("v.appName", "Material");
    component.set("v.itm.Record_Type__c", "Material");
    component.set("v.selectedRecordType", "Material");
  },

  // Set Month picklist values
  month: function (component, event, helper) {
    helper.monthDynamic(
      $A.getCallback(function handleServerResponse(serverResponse) {
        component.set("v.optionss", serverResponse.month);
      })
    );
  },
  monthDynamic: function (onResponse) {
    setTimeout(function () {
      var serverResponse = {
        month: [
          { id: "Jan", label: "Jan" },
          { id: "Feb", label: "Feb" },
          { id: "Mar", label: "Mar" },
          { id: "Apr", label: "Apr" },
          { id: "May", label: "May" },
          { id: "Jun", label: "Jun" },
          { id: "Jul", label: "Jul" },
          { id: "Aug", label: "Aug" },
          { id: "Sep", label: "Sep" },
          { id: "Oct", label: "Oct" },
          { id: "Nov", label: "Nov" },
          { id: "Dec", label: "Dec" }
        ]
      };
      onResponse.call(null, serverResponse);
    }, 2000);
  },

  // Set batchStatus list values init call
  batchStatus: function (component, event, helper) {
    var action = component.get("c.getBatchStatusList");
    action.setCallback(this, function (response) {
      var state = response.getState();
      //alert(state);
      if (state === "SUCCESS") {
        component.set("v.batchstatusList", response.getReturnValue());
        //alert('v.batchstatusList>>>'+JSON.stringify(component.get("v.batchstatusList")));
      } else if (state === "ERROR") {
        var errors = response.getError();
        alert(errors in getBatchStatusList);
      }
    });
    $A.enqueueAction(action);
  },

  //Get Year from Apex

  getYear: function (component, helper) {
    var action = component.get("c.getPreviousYear");
    action.setCallback(this, function (response) {
      var state = response.getState();
      // alert(state);
      if (state === "SUCCESS") {
        component.set("v.yearList", response.getReturnValue());
        component.set("v.prvsyearList", response.getReturnValue());
      } else if (state === "ERROR") {
        var errors = response.getError();
        console.error(errors);
      }
    });
    $A.enqueueAction(action);
  },

  // Get company pick list for Material upload
  getsalesCompanyList: function (component, event) {
    var action = component.get("c.getMaterialCompanyList");
    action.setCallback(this, function (response) {
      var state = response.getState();
      if (state === "SUCCESS") {
        var result = response.getReturnValue();
        var partnerCompanyMap = [];
        for (var key in result) {
          partnerCompanyMap.push({ key: key, value: result[key] });
        }
        component.set("v.SalesCompanyMap", partnerCompanyMap);
      }
    });
    $A.enqueueAction(action);
  },

  invoke: function (component, helper) {
    var action = component.get("c.getMaterialData");
    action.setCallback(this, function (response) {
      var state = response.getState();
      if (state === "SUCCESS") {
        // alert(state);
        component.set("v.data", response.getReturnValue());
        // console.log("Data returned from inventory master" + response.getReturnValue());
      } else if (state === "ERROR") {
        var errors = response.getError();
        console.error(errors);
      }
    });
    $A.enqueueAction(action);
  },

  // Used for reupload
  autoPopulateOnReupload: function (component, helper, batchId) {
    // alert('inside helper');
    var action = component.get("c.getAutoPopulateMasterValues");
    action.setParams({
      batchId: batchId
    });
    action.setCallback(this, function (response) {
      var state = response.getState();
      if (state === "SUCCESS") {
        var result = response.getReturnValue();
        for (var i = 0; i < result.length; i++) {
          //alert('result[i] ::'+result[i].Period__c);
          component.set("v.selectedMonth", result[i].Sales_Month__c);
          // alert(component.get("v.selectedMonth"));
          component.set("v.selectedYear", result[i].Sales_Year__c);
          component.set("v.cmpsales.Name", result[i].Sales_Company__c);

          // var Pval = component.get('v.selectedValues');
          //alert('Pval ::'+Pval);`
          component.set("v.IsCompanyDefault", result[i].Sales_Company__c);
          component.set("v.IsMonthDefault", result[i].Sales_Month__c);
          component.set("v.IsYearDefault", result[i].Sales_Year__c);
          //helper.getPeriodPicklist(component, event, result[i].Sales_Year__c);
        }
      } else if (state === "ERROR") {
        var errors = response.getError();
        console.error(errors);
      }
    });
    $A.enqueueAction(action);
  },

  prevYear: function (component, helper) {
    var action = component.get("c.getprevYear");
    action.setCallback(this, function (response) {
      var state = response.getState();
      if (state === "SUCCESS") {
        component.set("v.prvsyearList", response.getReturnValue());
      } else if (state === "ERROR") {
        var errors = response.getError();
        console.error(errors);
      }
    });
    $A.enqueueAction(action);
  },

  getfilteredByYear: function (component, helper, year, company, batchStatus) {
    var action = component.get("c.getMaterialDatabyYear");
    action.setParams({
      year: year,
      company: company,
      batchStatus: batchStatus
    });
    action.setCallback(this, function (response) {
      var state = response.getState();
      if (state === "SUCCESS") {
        component.set("v.data", response.getReturnValue());
        component.set("v.loaded", false);
      } else if (state === "ERROR") {
        var errors = response.getError();
        console.error(errors);
      }
    });
    $A.enqueueAction(action);
  },

  /*  getMainettiCompanyPicklist: function (component, event) {
     var action = component.get("c.getMainettiMap");
     action.setCallback(this, function (response) {
       var state = response.getState();
       if (state === "SUCCESS") {
         var result = response.getReturnValue();
         var recordStatusMap = [];
         for (var key in result) {
           recordStatusMap.push({ key: key, value: result[key] });
         }
         component.set("v.mainettiCompanyMap", recordStatusMap);
       }
     });
     $A.enqueueAction(action);
   }, */

  /*   getRecordStatusPicklist: function(component, event) {
        var action = component.get("c.getRecordStatus");
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var result = response.getReturnValue();
                var recordStatusMap = [];
                for(var key in result){
                    recordStatusMap.push({key: key, value: result[key]});
                }
                component.set("v.recordStatusMap", recordStatusMap);
            }
        });
        $A.enqueueAction(action);
    },
    
    getBatchStatusPicklist: function(component, event) {
        var action = component.get("c.getBatchStatus");
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var result = response.getReturnValue();
                var batchStatusMap = [];
                for(var key in result){
                    batchStatusMap.push({key: key, value: result[key]});
                }
                component.set("v.batchStatusMap", batchStatusMap);
            }
        });
        $A.enqueueAction(action);
    },*/

  parseFile: function (component, file, batchNo, helper) {
    var allValid = true;
    var recordType = component.get("v.selectedRecordType");
    var selMonthNum = component.get("v.selectedMonth");
    if (recordType == "Material") {
      var selYear = component.get("v.selectedYear");
      var selCompany = component.get("v.cmpsales.Name");
      console.log(
        "    selYear :::::" + selYear + "   selCompany :::" + selCompany
      );
      if (selCompany == "") {
        document.getElementById("errorMissing").innerHTML =
          "Please Select the Company!";
        component.set("v.toggleSpinner", false);
        allValid = false;
        return;
      }
      if (selMonthNum == "") {
        document.getElementById("errorMissing").innerHTML =
          "Please Select the Month!";
        component.set("v.toggleSpinner", false);
        allValid = false;
        return;
      }
      if (selYear == "") {
        document.getElementById("errorMissing").innerHTML =
          "Please Select a Year!";
        component.set("v.toggleSpinner", false);
        allValid = false;
        return;
      }

      var isreupload = component.get("v.isReupload");
    }
    component.set("v.isButtonActive", allValid);
    helper.isDataAlreadySubmitted(component, event, helper);
  },

  isDataAlreadySubmitted: function (component, event, helper) {
    var allValid = true;
    console.log("##### START isMaterialUploadAlreadySubmitted #########");
    var selMonth = component.get("v.selectedMonth");
    var selYear = component.get("v.selectedYear");
    var selCompany = component.get("v.cmpsales.Name");
    var fileInput = component.find("file").getElement();
    var file = fileInput.files[0];
    var rowsExists = false;

    var IsMonthDefault = component.get("v.IsMonthDefault");
    var IsYearDefault = component.get("v.IsYearDefault");

    var IsCompanyDefault = component.get("v.IsCompanyDefault");


    if (file.size > 0) {
      rowsExists = true;
    }
    if (rowsExists) {
      component.set('v.isChunkDataSubmitted', true);
      var action = component.get("c.errordataSubmitted");
      action.setParams({
        "companyArray": selCompany,
        "selmonth": selMonth,
        "selyear": selYear
      });
      action.setCallback(this, function (response) {
        var state = response.getState();
        var batchStatus;
        var Batchstatus;
        var isreupload = component.get("v.isReupload");

        if (state === "SUCCESS") {
          var fetchValue = response.getReturnValue();
          batchStatus = fetchValue;
          Batchstatus = component.set("v.BatchStatus", fetchValue);
          if ((fetchValue != '' && (batchStatus != '8 - Migration Success') && !isreupload)) {
            component.set("v.toggleSpinner", false);
            component.set("v.errorReupload", true);
            component.set("v.isDataSubmitted", false);
            helper.closeModal(component, helper);
            var text = 'The Error File data as already been submitted, Please Use Re-Upload Button';
            allValid = false;
            helper.openErrorSubmittedModal(component, event, helper, text);

          }
          else if (isreupload && (IsCompanyDefault != selCompany || IsMonthDefault != selMonth || IsYearDefault != selYear)) {
            component.set("v.toggleSpinner", false);
            component.set("v.errorReupload", true);
            helper.closeModal(component, helper);
            var text = 'The Selected Values in Dropdown does not Match with the Record Values';
            allValid = false;
            helper.openErrorSubmittedModal(component, event, helper, text);
          }
          else {
            component.set("v.isButtonActive", allValid);
            console.log('##### INSIDE ELSE START AFTER ERRORDATA SUBMITTED isDataAlreadySubmitted #########');
            if ((rowsExists && isreupload) || (rowsExists && (batchStatus == '' || batchStatus == '8 - Migration Success'))) {
              var action = component.get("c.dataSubmitted");
              action.setParams({
                "companyArray": selCompany,
                "selmonth": selMonth,
                "selyear": selYear
              });
              action.setCallback(this, function (response) {
                var state = response.getState();
                if (state === "SUCCESS") {
                  var fetchValue = response.getReturnValue();
                  if (fetchValue > 0) {
                    component.set("v.toggleSpinner", false);
                    component.set("v.isDataSubmitted", false);
                    helper.openDataSubmittedModal(component, event, helper);
                  } else {
                    helper.closeModal(component, helper);
                    // component.set("v.openBulkUploadConfirmation",true);
                    //  helper.openBulkUploadConfirmation(component,helper);
                    var chunk = $A.getCallback(function (results, parser) {
                      console.log('##### INSIDE CHUNK START #########');
                      var isreupload = component.get("v.isReupload");
                      var selYear = component.get("v.selectedYear");
                      var selCompany = component.get("v.cmpsales.Name");
                      var getAppName = component.get("v.appName");
                      var myJson = JSON.stringify(results.data);
                      console.log('myJson:::' + myJson);
                      var rows = results.data;
                      // console.log('rows:::'+rows);
                      var companyrow = rows[0].Company__c;
                      var yearrow = rows[0].Year__c;
                      var monthrow = rows[0].Month__c;
                      // console.log('selCompany:::::'+selCompany.toLowerCase()+'selMonth:::::'+selMonth.toLowerCase()+'companyrow:::::'+companyrow.toLowerCase()+'monthrow:::::'+monthrow.toLowerCase()+'selYear:::::'+selYear+'yearrow:::::'+yearrow);
                      /*  if(selCompany.toLowerCase() != companyrow.toLowerCase() || selMonth.toLowerCase() != monthrow.toLowerCase()  || selYear != yearrow )
                        {
                            var text = 'The Selected Values in Dropdown doesnot Match with the Uploaded File Values / The File Type is Incorrect';
                            helper.openErrorSubmittedModal(component, event, helper,text);
                            component.set("v.toggleSpinner", false);
                            component.set("v.parseSalesFileChunkBoolean",false);
                            
                        } */
                      //   else{
                      ///////////////////
                      helper.closeModal(component, helper);
                      component.set("v.openBulkUploadConfirmation", true);
                      helper.openBulkUploadConfirmation(component, helper);
                      var recordType = component.get("v.selectedRecordType");
                      var file = component.find("file").getElement().files[0];
                      var fileName = file.name;
                      var fileDelimiters = component.find('fileDelimiter').get('v.value');
                      console.log('##### INSIDE CHUNK FileName' + fileName);

                      if (rows.length >= 1) {
                        var chunkCount = component.get("v.chunkCount");
                        if (!parser.paused()) {
                          parser.pause();
                          console.log('##### Parser CHUNK Paused ChunkCount' + chunkCount);
                        }
                        var batchNo = component.get("v.reuploadBatchNo");
                        component.set("v.chunkCount", (chunkCount + 1));
                        console.log('##### INSIDE CHUNK BEFORE  ####CHUNK COUNT #####' + chunkCount + ':BATCHNO:::' + batchNo + ':::ROWS LENGTH:::' + rows.length);
                        var action = component.get("c.insertBulkMaterial");
                        action.setParams({
                          "jsonin": myJson,
                          "batchNo": batchNo,
                          "recordType": recordType,
                          "selComp": selCompany,
                          "selMonth": selMonth,
                          "selYear": selYear,
                          "isreupload": isreupload,
                          "chunkCount": chunkCount,
                          "fileName": fileName,
                          "fileDelimiters": fileDelimiters
                        });
                        action.setCallback(this, function (response) {
                          var state = response.getState();
                          var errors = response.getError();
                          if (errors && Array.isArray(errors) && errors.length > 0) {
                            console.log('error callback post creation of Master Record:' + errors[0].message);
                            helper.openErrorModal(component, helper);
                            return;
                          }
                          if (state === "SUCCESS") {

                            var batchId = response.getReturnValue();
                            component.set("v.reuploadBatchNo", batchId);
                            console.log('##### INSIDE CHUNK  isDataSubmitted SUCCESS ## batchId returned from insert bulk material ###### ' + batchId + ' ####CHUNK COUNT #####' + chunkCount);
                            if (parser.paused()) {
                              var isreUpload = component.get("v.isReupload");
                              if (isreUpload) {
                                component.set("v.isReupload", false);
                              }
                              parser.resume();
                              console.log('##### INSIDE CHUNK PARSER  RESUMED #CHUNK COUNT #' + chunkCount);
                              component.set("v.parseSalesFileChunkBoolean", true);
                            }
                          }
                        });
                        $A.enqueueAction(action);
                      } else {
                      }
                      // }
                    })

                    var chunkComplete = $A.getCallback(function (results) {
                      var parseSalesFileChunkComplete = component.get("v.parseSalesFileChunkBoolean");
                      if (parseSalesFileChunkComplete) {
                        var batchNo = component.get("v.reuploadBatchNo");
                        console.log();
                        var fileInput = component.find("file").getElement();
                        var file = fileInput.files[0];
                        var recordType = component.get("v.selectedRecordType");

                        //  console.log('##### START CHUNK COMPLETE   ####'+batchNo);
                        component.set("v.openBulkUploadConfirmation", false);
                        component.set("v.isButtonActive", false);
                        helper.parseSalesFileChunk(component, file, batchNo, helper, recordType, true);
                      }

                    })

                    var fileInput = component.find("file").getElement();
                    var fileDelimiter = component.find('fileDelimiter').get('v.value');
                    var file = fileInput.files[0];

                    component.set("v.toggleSpinner", true);
                    // Papa.LocalChunkSize = 1  024*640*1;
                    //Papa.LocalChunkSize = 1024*704*1;  
                    Papa.LocalChunkSize = 1024 * 250 * 1;
                    // Papa.LocalChunkSize = 1024*696*1;  
                    //Papa.LocalChunkSize = 7680*1;
                    var parser = Papa.parse(file, {
                      skipEmptyLines: true,
                      delimiter: fileDelimiter,
                      header: true,
                      encoding: "UTF-8",
                      beforeFirstChunk: function (chunk) {
                        var rows = chunk.split(/\r\n|\r|\n/);
                        var headings = rows[0].split(fileDelimiter);
                        headings[0] = helper.returnSalesHeader(component, helper, headings[0]);
                        headings[1] = helper.returnSalesHeader(component, helper, headings[1]);
                        headings[2] = helper.returnSalesHeader(component, helper, headings[2]);
                        headings[3] = helper.returnSalesHeader(component, helper, headings[3]);
                        headings[4] = helper.returnSalesHeader(component, helper, headings[4]);
                        headings[5] = helper.returnSalesHeader(component, helper, headings[5]);
                        headings[6] = helper.returnSalesHeader(component, helper, headings[6]);
                        headings[7] = helper.returnSalesHeader(component, helper, headings[7]);
                        headings[8] = helper.returnSalesHeader(component, helper, headings[8]);
                        headings[9] = helper.returnSalesHeader(component, helper, headings[9]);
                        headings[10] = helper.returnSalesHeader(component, helper, headings[10]);
                        headings[11] = helper.returnSalesHeader(component, helper, headings[11]);
                        headings[12] = helper.returnSalesHeader(component, helper, headings[12]);
                        headings[13] = helper.returnSalesHeader(component, helper, headings[13]);
                        headings[14] = helper.returnSalesHeader(component, helper, headings[14]);
                        headings[15] = helper.returnSalesHeader(component, helper, headings[15]);
                        headings[16] = helper.returnSalesHeader(component, helper, headings[16]);
                        headings[17] = helper.returnSalesHeader(component, helper, headings[17]);
                        headings[18] = helper.returnSalesHeader(component, helper, headings[18]);
                        headings[19] = helper.returnSalesHeader(component, helper, headings[19]);
                        headings[20] = helper.returnSalesHeader(component, helper, headings[20]);
                        headings[21] = helper.returnSalesHeader(component, helper, headings[21]);
                        headings[22] = helper.returnSalesHeader(component, helper, headings[22]);
                        headings[23] = helper.returnSalesHeader(component, helper, headings[23]);
                        headings[24] = helper.returnSalesHeader(component, helper, headings[24]);
                        headings[25] = helper.returnSalesHeader(component, helper, headings[25]);
                        headings[26] = helper.returnSalesHeader(component, helper, headings[26]);

                        rows[0] = headings.join(fileDelimiter);
                        return rows.join('\n');
                      },
                      chunk: chunk,
                      complete: chunkComplete
                    });
                  }
                }
              });
              $A.enqueueAction(action);
            }
          }
        }

      });
      $A.enqueueAction(action);

      return;
    }
    else {

      component.set("v.toggleSpinner", false);
      helper.openErrorFileFormatModal(component, event, helper);
    }
  },
  parseSalesFileChunk: function (
    component,
    file,
    batchNo,
    helper,
    recordType,
    postBulkInsert
  ) {
    console.log(
      "##### START parseSalesFileChunk ####batchNo::" +
      batchNo +
      ":::recordType::::::" +
      recordType +
      "::::postBulkInsert::::::" +
      postBulkInsert
    );
    var selMonth = component.get("v.selectedMonth");
    var selYear = component.get("v.selectedYear");
    console.log("selYear:::" + selYear);
    var selCompany = component.get("v.cmpsales.Name");
    var complete = $A.getCallback(function (results) {
      var myJson = JSON.stringify(results.data);
      console.log(" Parse Material Chunk method Paramets to be passed");
      console.log(myJson);
      console.log('batchNo' + batchNo);
      console.log(recordType);
      console.log(selCompany);
      console.log(selMonth);
      console.log(selYear);
      console.log(postBulkInsert);
      console.log("Paramets END");

      //making the jason empty as bulk data is inserted via chunk
      if (postBulkInsert) {
        myJson = "";
      }
      var submitStatus = component.get("v.submitMaterial");
      if (batchNo != "" && submitStatus) {
        var action = component.get("c.parseMaterialChunk");
        action.setParams({
          jsonin: myJson,
          batchNo: batchNo,
          recordType: recordType,
          selComp: selCompany,
          selMonth: selMonth,
          selYear: selYear,
          postBulkInsert: postBulkInsert
        });
        action.setCallback(this, function (response) {
          var state = response.getState();
          var errors = response.getError();
          if (errors && Array.isArray(errors) && errors.length > 0) {
            component.set("v.toggleSpinner", false);
            console.log(
              "error callback post creation of Master Record:" +
              errors[0].message
            );
            helper.openErrorModal(component, helper);
          }
          if (state === "SUCCESS") {
            component.rerenderList();
            var batchId = response.getReturnValue();
            console.log(
              "##### INSIDE SUCCES parseSalesFileChunk #### batchId:::" +
              batchId
            );
            helper.closeBulkUploadConfirmation(component, helper);
            //if(batchId != ''){
            helper.openFileDataSubmittedModal(component, helper);
            //}
          }
        });
        $A.enqueueAction(action);
        setTimeout(
          $A.getCallback(function () {
            $A.get("e.force:refreshView").fire();
          }),
          750000
        ); // Waits 30 seconds
      } else {
        helper.openErrorFileFormatModal(component, helper);
        component.set("v.toggleSpinner", false);
      }
    });

    var file = component.find("file").getElement().files[0];
    var fileDelimiter = component.find("fileDelimiter").get("v.value");

    console.log("parseSalesFileChunk::::fileDelimiter " + fileDelimiter);
    Papa.parse(file, {
      skipEmptyLines: true,
      delimiter: fileDelimiter,
      header: true,
      encoding: "UTF-8",
      beforeFirstChunk: function (chunk) {
        var rows = chunk.split(/\r\n|\r|\n/);
        var headings = rows[0].split(fileDelimiter);

        headings[0] = helper.returnSalesHeader(component, helper, headings[0]);
        headings[1] = helper.returnSalesHeader(component, helper, headings[1]);
        headings[2] = helper.returnSalesHeader(component, helper, headings[2]);
        headings[3] = helper.returnSalesHeader(component, helper, headings[3]);
        headings[4] = helper.returnSalesHeader(component, helper, headings[4]);
        headings[5] = helper.returnSalesHeader(component, helper, headings[5]);
        headings[6] = helper.returnSalesHeader(component, helper, headings[6]);
        headings[7] = helper.returnSalesHeader(component, helper, headings[7]);
        headings[8] = helper.returnSalesHeader(component, helper, headings[8]);
        headings[9] = helper.returnSalesHeader(component, helper, headings[9]);
        headings[10] = helper.returnSalesHeader(component, helper, headings[10]);
        headings[11] = helper.returnSalesHeader(component, helper, headings[11]);
        headings[12] = helper.returnSalesHeader(component, helper, headings[12]);
        headings[13] = helper.returnSalesHeader(component, helper, headings[13]);
        headings[14] = helper.returnSalesHeader(component, helper, headings[14]);
        headings[15] = helper.returnSalesHeader(component, helper, headings[15]);
        headings[16] = helper.returnSalesHeader(component, helper, headings[16]);
        headings[17] = helper.returnSalesHeader(component, helper, headings[17]);
        headings[18] = helper.returnSalesHeader(component, helper, headings[18]);
        headings[19] = helper.returnSalesHeader(component, helper, headings[19]);
        headings[20] = helper.returnSalesHeader(component, helper, headings[20]);
        headings[21] = helper.returnSalesHeader(component, helper, headings[21]);
        headings[22] = helper.returnSalesHeader(component, helper, headings[22]);
        headings[23] = helper.returnSalesHeader(component, helper, headings[23]);
        headings[24] = helper.returnSalesHeader(component, helper, headings[24]);
        headings[25] = helper.returnSalesHeader(component, helper, headings[25]);
        headings[26] = helper.returnSalesHeader(component, helper, headings[26]);

        rows[0] = headings.join(fileDelimiter);

        return rows.join("\n");
      },
      complete: complete
    });
    // $A.get('e.force:refreshView').fire();
  },

  openModal: function (component, event, helper) {
    var modal = component.find("inventoryModal");
    var modalBackdrop = component.find("inventoryModalBackdrop");
    $A.util.addClass(modal, "slds-fade-in-open");
    $A.util.addClass(modalBackdrop, "slds-backdrop_open");
  },
  closeModal: function (component, event, helper) {
    var modal = component.find("inventoryModal");
    var modalBackdrop = component.find("inventoryModalBackdrop");
    $A.util.removeClass(modal, "slds-fade-in-open");
    $A.util.removeClass(modalBackdrop, "slds-backdrop_open");
  },

  openBulkUploadConfirmation: function (component, event, helper) {
    component.set("v.openBulkUploadConfirmation", true);
  },
  closeBulkUploadConfirmation: function (component, event, helper) {
    component.set("v.openBulkUploadConfirmation", false);
    component.set("v.openFileDataSubmitted", false);
  },
  openFileDataSubmittedModal: function (component, event, helper) {
    component.set("v.openFileDataSubmitted", true);
    var modal = component.find("openFileDataSubmitted");
    var modalBackdrop = component.find("openFileDataSubmittedBackdrop");
    $A.util.addClass(modal, "slds-fade-in-open");
    $A.util.addClass(modalBackdrop, "slds-backdrop_open");
  },
  closeModalopenFileDataSubmittedModal: function (component, event, helper) {
    component.set("v.openFileDataSubmitted", false);
    var modal = component.find("openFileDataSubmitted");
    var modalBackdrop = component.find("openFileDataSubmittedBackdrop");
    $A.util.removeClass(modal, "slds-fade-in-open");
    $A.util.removeClass(modalBackdrop, "slds-backdrop_open");
  },
  openErrorModal: function (component, event, helper) {
    var toastEvent = $A.get("e.force:showToast");
    toastEvent.setParams({
      title: "Error",
      message:
        "Error in the data File Uploaded, Please click the Error Details link",
      type: "error",
      mode: "sticky"
    });
    toastEvent.fire();
  },
  closeErrorModal: function (component, event, helper) {
    var modal = component.find("inventoryErrorModal");
    var modalBackdrop = component.find("inventoryErrorModalBackdrop");
    $A.util.removeClass(modal, "slds-fade-in-open");
    $A.util.removeClass(modalBackdrop, "slds-backdrop_open");
  },
  openErrorFileFormatModal: function (component, event, helper) {
    var toastEvent = $A.get("e.force:showToast");
    toastEvent.setParams({
      title: "Error",
      message: "Error in Format of the data File Uploaded",
      type: "error",
      mode: "sticky"
    });
    toastEvent.fire();
  },
  closeErrorFileFormatModal: function (component, event, helper) {
    var modal = component.find("errorFileFormatModal");
    var modalBackdrop = component.find("errorFileFormatModalBackdrop");
    $A.util.removeClass(modal, "slds-fade-in-open");
    $A.util.removeClass(modalBackdrop, "slds-backdrop_open");
  },
  cmpWeekOpen: function (component, event, helper) {
    var modal = component.find("cmpWeekMissing");
    var modalBackdrop = component.find("cmpWeekMissingBackdrop");
    $A.util.addClass(modal, "slds-fade-in-open");
    $A.util.addClass(modalBackdrop, "slds-backdrop_open");
  },

  returnSalesHeader: function (component, helper, headerName) {

    console.log('Headder Name Here'+headerName);
    if (headerName != "" && headerName != null) {
      if (headerName.trim().toLowerCase() == "Company".trim().toLowerCase()) {
        return "Mainetti_Company__c";
      } else if (
        headerName.trim().toLowerCase() == "Year".trim().toLowerCase()
      ) {
        return "Year__c";
      } else if (
        headerName.trim().toLowerCase() == "Month".trim().toLowerCase()
      ) {
        return "Month__c";
      } else if (
        headerName.trim().toLowerCase() == "PO Number".trim().toLowerCase()
      ) {
        return "PO_Number__c";
      } else if (
        headerName.trim().toLowerCase() == "PO Date".trim().toLowerCase()
      ) {
        return "PO_Date__c";
      } else if (
        headerName.trim().toLowerCase() == "Material".trim().toLowerCase()
      ) {
        return "Material__c";
      } else if (
        headerName.trim().toLowerCase() == "Grade".trim().toLowerCase()
      ) {
        return "Grade__c";
      } else if (
        headerName.trim().toLowerCase() == "Color".trim().toLowerCase()
      ) {
        return "Color__c";
      } else if (
        headerName.trim().toLowerCase() ==
        "Item Code(Local)".trim().toLowerCase()
      ) {
        return "Item_code_local__c";
      } else if (
        headerName.trim().toLowerCase() == "Product Desc".trim().toLowerCase()
      ) {
        return "Product_Description__c";
      } else if (
        headerName.trim().toLowerCase() == "Order Type".trim().toLowerCase()
      ) {
        return "Order_Type__c";
      } else if (
        headerName.trim().toLowerCase() == "Supplier Name".trim().toLowerCase()
      ) {
        return "Supplier_Name__c";
      } else if (
        headerName.trim().toLowerCase() == "Local Supplier Code".trim().toLowerCase()
      ) {
        return "Local_Supplier_Code__c";
      } else if (
        headerName.trim().toLowerCase() ==
        "Supplier Country".trim().toLowerCase()
      ) {
        return "Supplier_Country_2__c";
      } else if (
        headerName.trim().toLowerCase() == "Shipping Terms".trim().toLowerCase()
      ) {
        return "Purchase_Terms__c";
      }else if(
        headerName.trim().toLowerCase() == "Freight cost to factory (road/ship/freight)".trim().toLowerCase()
      ) {
        console.log('inside headder replace');
        return "Freight_cost_to_factory__c";
      }
      else if(
        headerName.trim().toLowerCase() == "Landed cost to factory".trim().toLowerCase()
      ) {
        return "Landed_cost_to_factory__c";
      } else if (
        headerName.trim().toLowerCase() == "UOM".trim().toLowerCase()
      ) {
        return "UOM__c";
      } else if (
        headerName.trim().toLowerCase() == "Qty".trim().toLowerCase()
      ) {
        return "QTY__c";
      } else if (
        headerName.trim().toLowerCase() ==
        "Purchase Currency".trim().toLowerCase()
      ) {
        return "Purchase_Currency__c";
      } else if (
        headerName.trim().toLowerCase() ==
        "Purchase Unit Price".trim().toLowerCase()
      ) {
        return "Purchase_Unit_Price__c";
      } else if (
        headerName.trim().toLowerCase() == "Purchase Price".trim().toLowerCase()
      ) {
        return "Purchase_Price__c";
      } else if (
        headerName.trim().toLowerCase() == "exRate To USD".trim().toLowerCase()
      ) {
        return "exRate_To_USD__c";
      } else if (
        headerName.trim().toLowerCase() == "exRate To EUR".trim().toLowerCase()
      ) {
        return "exRate_To_EUR__c";
      } else if (
        headerName.trim().toLowerCase() ==
        "Expected Delivery Date".trim().toLowerCase()
      ) {
        return "Expected_Delivery_Date__c";
      } else if (
        headerName.trim().toLowerCase() ==
        "Expected Delivery Month".trim().toLowerCase()
      ) {
        return "Expected_Delivery_Month__c";
      } else if (
        headerName.trim().toLowerCase() ==
        "Expected Delivery Year".trim().toLowerCase()
      ) {
        return "Expected_Delivery_Year__c";
      }
    } else {
      component.set("v.submitMaterial", false);
      return false;
    }
  },
  //NOt used
  /*   getPeriodPicklist: function (component, event, year, company) {
    // alert('year ::'+year);
    var action = component.get("c.getperiodpicklist");
    action.setParams({
      reviewYear: year,
      reviewCompany: company
    });
    action.setCallback(this, function (response) {
      var state = response.getState();
      if (state === "SUCCESS") {
        var result = response.getReturnValue();
        var partnerCompanyMap = [];
        for (var key in result) {
          partnerCompanyMap.push({ key: key, value: result[key] });
          // partnerCompanyMap.push({key: key, value: result});
        }
        component.set("v.optionss", partnerCompanyMap);
      }
    });
    $A.enqueueAction(action);
  },
 */

  openDataSubmittedModal: function (component, event, helper) {
    var toastEvent = $A.get("e.force:showToast");
    toastEvent.setParams({
      title: "Error",
      message: "The File data as already been submitted",
      type: "error",
      mode: "sticky"
    });
    toastEvent.fire();
  },
  closeDataSubmittedModal: function (component, event, helper) {
    var modal = component.find("dataSubmittedModal");
    var modalBackdrop = component.find("dataSubmittedModalBackdrop");
    $A.util.removeClass(modal, "slds-fade-in-open");
    $A.util.removeClass(modalBackdrop, "slds-backdrop_open");
  },
  openErrorSubmittedModal: function (component, event, helper, text) {
    var toastEvent = $A.get("e.force:showToast");
    toastEvent.setParams({
      title: "Error",
      message: text,
      duration: "5000",
      type: "info",
      mode: "dismissible"
    });
    toastEvent.fire();
  },
  SalesFile: function (file) {
    var file = new File([csvWrapper.csvFileContent], csvWrapper.fileName, {
      type: "text/plain"
    });
    var fileContent = atob(csvWrapper.csvFileContent);
    var fileData = new File([fileContent], csvWrapper.fileName, {
      type: "text/plain"
    });
    var fileDelimiter = component.find("fileDelimiter").get("v.value");
    console.log("SalesFile::::fileDelimiter " + fileDelimiter);
    Papa.parse(fileData, {
      skipEmptyLines: true,
      delimiter: fileDelimiter,
      header: true,
      encoding: "UTF-8",
      beforeFirstChunk: function (chunk) {
        var rows = chunk.split(/\r\n|\r|\n/);
        //var headings = rows[0].split( ',' );
        var headings = rows[0].split(fileDelimiter);
        headings[0] = returnSalesHeader(headings[0]);
        headings[1] = returnSalesHeader(headings[1]);
        headings[2] = returnSalesHeader(headings[2]);
        headings[3] = returnSalesHeader(headings[3]);
        headings[4] = returnSalesHeader(headings[4]);
        headings[5] = returnSalesHeader(headings[5]);
        headings[6] = returnSalesHeader(headings[6]);
        headings[7] = returnSalesHeader(headings[7]);
        headings[8] = returnSalesHeader(headings[8]);
        headings[9] = returnSalesHeader(headings[9]);
        headings[10] = returnSalesHeader(headings[10]);
        headings[11] = returnSalesHeader(headings[11]);
        headings[12] = returnSalesHeader(headings[12]);
        headings[13] = returnSalesHeader(headings[13]);
        headings[14] = returnSalesHeader(headings[14]);
        headings[15] = returnSalesHeader(headings[15]);
        headings[16] = returnSalesHeader(headings[16]);
        headings[17] = returnSalesHeader(headings[17]);
        headings[18] = returnSalesHeader(headings[18]);
        headings[19] = returnSalesHeader(headings[19]);
        headings[20] = returnSalesHeader(headings[20]);
        headings[21] = returnSalesHeader(headings[21]);
        headings[22] = returnSalesHeader(headings[22]);
        headings[23] = returnSalesHeader(headings[23]);
        headings[24] = returnSalesHeader(headings[24]);
        headings[25] = returnSalesHeader(headings[25]);
        headings[26] = returnSalesHeader(headings[26]);

        rows[0] = headings.join(fileDelimiter);
        return rows.join("\n");
      },
      complete: function (results) {
        var myJson = JSON.stringify(results.data);
        var csv = Papa.unparse(myJson);
        var file = new File([csv], csvWrapper.fileName, { type: "text/plain" });
        uploadFile(file);
      }
    });
  },
  closeModal: function (component, event, helper) {
    var modal = component.find("inventoryModal");
    var modalBackdrop = component.find("inventoryModalBackdrop");
    $A.util.removeClass(modal, "slds-fade-in-open");
    $A.util.removeClass(modalBackdrop, "slds-backdrop_open");
  },
  deleteDefunctBatch: function (component, helper, batchId) {
    console.log("########INSIDE deleteDefunctBatch:::" + batchId);
    var action = component.get("c.deleteDefunctBatchRecord");
    action.setParams({
      batchId: batchId
    });
    action.setCallback(this, function (response) {
      var state = response.getState();
      if (state === "SUCCESS") {
        component.set("v.toggleSpinner", false);
        console.log("Deletion submission successfully");
      } else if (state === "ERROR") {
        var errors = response.getError();
        console.error(errors);
      }
    });
    $A.enqueueAction(action);
  },
  viewAdmintoProfileAccess: function (component, helper, batchId) {
    console.log("batchId :::" + batchId);
    var action = component.get("c.hasViewAdminToProfileAccess");

    action.setCallback(this, function (response) {
      var state = response.getState();
      if (state === "SUCCESS") {
        var result = response.getReturnValue();
        console.log("viewAdmintoProfileAccess:::" + result);
        if (result == true) {
          var evt = $A.get("e.force:navigateToComponent");
          evt.setParams({
            componentDef: "c:budgetAdminAccess",
            componentAttributes: {
              batchId: batchId
            }
          });
          evt.fire();
        } else {
          var text = "You can't access this page";
          helper.errorToast(component, event, helper, text);
          return;
        }
        //  component.set("v.toggleSpinner", false);
      } else if (state === "ERROR") {
        var errors = response.getError();
        console.error(errors);
      }
    });
    $A.enqueueAction(action);
  },
  errorToast: function (component, event, helper, text) {
    var toastEvent = $A.get("e.force:showToast");
    toastEvent.setParams({
      title: "Error!",
      message: text,
      type: "error",
      mode: "dismissable"
    });
    toastEvent.fire();
  },
  deleteAdmintoProfileAccess: function (component, helper, batchId) {
    var action = component.get("c.hasViewAdminToProfileAccess");

    action.setCallback(this, function (response) {
      var state = response.getState();
      if (state === "SUCCESS") {
        var result = response.getReturnValue();
        console.log("deleteAdmintoProfileAccess:::" + result);
        if (result == true) {
          var evt = $A.get("e.force:navigateToComponent");
          evt.setParams({
            componentDef: "c:DeleteAdminAccessforMaterialUpload",
            componentAttributes: {
              batchId: batchId
            }
          });
          evt.fire();
        } else {
          var text = "You can't access this page";
          helper.errorToast(component, event, helper, text);
          return;
        }
        //  component.set("v.toggleSpinner", false);
      } else if (state === "ERROR") {
        var errors = response.getError();
        console.error(errors);
      }
    });
    $A.enqueueAction(action);
  },
  viewMaintainceAccess: function (component, helper) {
    var action = component.get("c.hasViewAdminToProfileAccess");

    action.setCallback(this, function (response) {
      var state = response.getState();
      if (state === "SUCCESS") {
        var result = response.getReturnValue();
        if (result == true) {
          component.set("v.MaintainceAdminAccess", true);
        }
        //  component.set("v.toggleSpinner", false);
      } else if (state === "ERROR") {
        var errors = response.getError();
        console.error(errors);
      }
    });
    $A.enqueueAction(action);
  }
});