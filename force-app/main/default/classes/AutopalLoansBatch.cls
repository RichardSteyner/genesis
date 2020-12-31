global class AutopalLoansBatch implements Database.Batchable<Integer>, Database.AllowsCallouts{
	
	public List<Integer> start(Database.BatchableContext BC ){
        system.debug('##start AutopalLoansBatch');
        Integer totalPages;
		HttpResponse response = AutopalConnection.getData('loan/search.json?pxLimit=30&pxSortReverse=1');
        if(response.getStatusCode() == 200){
            List<Object> lst_JsonParse = (List<Object>)Json.deserializeUntyped(response.getBody());
            Integer i = 0;
            Integer totalRecords;
            for(Object obj : lst_JsonParse)
            {
                if(i == 0) totalRecords = Integer.valueOf((String)obj);
                i++;
            }
            system.debug(totalRecords);
            if(totalRecords != null){
                totalPages = totalRecords/30;
                if(Math.mod(totalRecords,30)>0){
                    totalPages = totalRecords/30 + 1;
                }
            }
        }
        
		List<Integer> numberP = new List<Integer>();
		for(Integer i=0; i<=totalPages;i++){
			numberP.add(30 * i);
		}
        system.debug(numberP);
        numberP.clear();
        numberP.add(0);
		return numberP;
	}
	
	public void execute(Database.BatchableContext BC, List<Integer> offsets) {
        system.debug('##execute AutopalLoansBatch');
		HttpResponse response = AutopalConnection.getData('loan/search.json?pxLimit=30&pxSortReverse=1' + (offsets.get(0) != 0 ? '&pxOffset=' + String.valueOf(offsets.get(0)) : ''));
        if(response.getStatusCode() == 200){
            Integer i = 0;
            List<Object> objList = new List<Object>();
            List<Object> lst_JsonParse = (List<Object>)Json.deserializeUntyped(response.getBody());
            AutopalLoan loanResult;
            //AutopalLoan loanSummaryData;
            String jsonStr;
            Loan__c loanApp;
            Map<String,Loan__c> loanMap = new Map<String,Loan__c>();
            Contact contactRecord;
            Map<String,Contact> contactMap = new Map<String,Contact>();
            String emailRegex = '([a-zA-Z0-9_\\-\\.]+)@((\\[a-z]{1,3}\\.[a-z]{1,3}\\.[a-z]{1,3}\\.)|(([a-zA-Z0-9\\-]+\\.)+))([a-zA-Z]{2,4}|[0-9]{1,3})';
            Pattern MyPattern;
            Matcher MyMatcher;
            Map<String,Object> objData;
            AutopalLoan.Collateral collateral;
            AutopalLoan.InitialSetup initialSetup;
            AutopalLoan.Summary summary;
            AutopalLoan.UserInformation userInformation;
            Map<String,Object> settings;
            Map<String,Object> payments;
            for(Object obj : lst_JsonParse)
            {
                if(i == 1){
                    objList = (List<Object>)obj;
                    for(Object objRecord : objList){
                        jsonStr = JSON.serialize(objRecord);
                        loanResult = (AutopalLoan) json.deserialize(jsonStr, AutopalLoan.class);
                        if(loanResult != null){
                            loanApp = new Loan__c();
                            loanApp.Name = loanResult.loan_title;
                            loanApp.Loan_ID__c = loanResult.loan_id;
                            loanApp.Loan_Alternative_ID__c = loanResult.loan_altId;
                            loanApp.Loan_Status__c = loanResult.loan_status;
                            system.debug(loanApp.Loan_ID__c);
                            if(loanApp.Loan_ID__c != null){
                                response = AutopalConnection.getData('loan.json/' + loanApp.Loan_ID__c + '/' + EncodingUtil.urlEncode('summary,initialSetup,collateral,settings,userInformation,payments','UTF-8')); //can add more sections
                                if(response.getStatusCode() == 200){
                                    //loanSummaryData = (AutopalLoan) json.deserialize(jsonString) (response.getBody().replace('"date"','"date_z"'), AutopalLoan.class);
                                    objData = (Map<String,Object>) json.deserializeUntyped(response.getBody().replace('"date"','"date_z"'));
                                    
                                    //Summary
                                    if(objData.get('summary') != null){
                                        jsonStr = JSON.serialize(objData.get('summary'));
                                        summary = (AutopalLoan.Summary) json.deserialize(jsonStr,AutopalLoan.Summary.class);
                                        loanApp.Loan_Display_ID__c = summary.loanDisplayId;
                                        loanApp.Amount_Due__c = (summary.amountDue != null ? Decimal.valueOf(summary.amountDue) : null);
                                        loanApp.Amount_Past_Due_30_Days__c = (summary.amountDue30Days != null ? Decimal.valueOf(summary.amountDue30Days) : null);
                                        loanApp.Days_Past_Due__c = (summary.DaysPastDue != null ? Decimal.valueOf(summary.DaysPastDue) : null);
                                        try{
                                            loanApp.Next_Payment_Due__c = (summary.nextPaymentDate != null ? Date.valueOf(summary.nextPaymentDate) : null);
                                        }catch(Exception e){
                                            loanApp.Next_Payment_Due__c = null;
                                        }
                                        loanApp.Next_Payment_Amount__c = (summary.nextPaymentAmount != null ? Decimal.valueOf(summary.nextPaymentAmount) : null);
                                        loanApp.Principal_Balance__c = (summary.principalBalance != null ? Decimal.valueOf(summary.principalBalance) : null);
                                        loanApp.Payoff_Autopal__c = (summary.currentPayoff != null ? Decimal.valueOf(summary.currentPayoff) : null);
                                    }
                                    //Collateral
                                    if(objData.get('collateral') != null){
                                        jsonStr = JSON.serialize(objData.get('collateral'));
                                        collateral = (jsonStr != null && jsonStr != '' ? (AutopalLoan.Collateral) json.deserialize(jsonStr,AutopalLoan.Collateral.class) : null);
                                        loanApp.AutoPal_VIN__c = (collateral != null && collateral.summary != null ? collateral.summary.VIN : null);
                                    }
                                    //Initial Setup
                                    if(objData.get('initialSetup') != null){
                                        jsonStr = JSON.serialize(objData.get('initialSetup'));
                                        initialSetup = (jsonStr != null && jsonStr != '' ? (AutopalLoan.InitialSetup) json.deserialize(jsonStr,AutopalLoan.InitialSetup.class) : null);
                                        loanApp.Payment_Frequency_Preference__c = (initialSetup != null && initialSetup.loanFrequency != null ? initialSetup.loanFrequency : null);
                                    }
                                    
                                    //Settings
                                    //loanApp.Source_Company__c = (loanSummaryData.settings != null && loanSummaryData.settings.sourceCompany != null ? loanSummaryData.settings.sourceCompany.value : null);
                                    loanApp.Sub_Status__c =  null;
                                    loanApp.Primary_Portfolio__c = null;
                                    if(objData.get('settings') != null){
                                        settings = (Map<String,Object>) objData.get('settings');
                                        if(settings.get('subStatus') != null){
                                            jsonStr = JSON.serialize(settings.get('subStatus'));
                                            loanApp.Sub_Status__c = (jsonStr != null && jsonStr != '' ? ((AutopalLoan.DataValue) json.deserialize(jsonStr,AutopalLoan.DataValue.class)) != null ? ((AutopalLoan.DataValue) json.deserialize(jsonStr,AutopalLoan.DataValue.class)).value : null : null);
                                        }
                                        if(settings.get('primaryPortfolio') != null){
                                            jsonStr = JSON.serialize(settings.get('primaryPortfolio'));
                                            loanApp.Primary_Portfolio__c = (jsonStr != null && jsonStr != '' ? (settings.get('primaryPortfolio') instanceof String ? null : ((AutopalLoan.DataValue) json.deserialize(jsonStr,AutopalLoan.DataValue.class)) != null ? ((AutopalLoan.DataValue) json.deserialize(jsonStr,AutopalLoan.DataValue.class)).value : null) : null);
                                        }
                                        if(settings.get('secondaryPortfolio') != null){
                                            jsonStr = JSON.serialize(settings.get('secondaryPortfolio'));
                                            loanApp.Secondary_Portfolio__c = (jsonStr != null && jsonStr != '' ? (settings.get('secondaryPortfolio') instanceof String ? null : ((AutopalLoan.DataValue) json.deserialize(jsonStr,AutopalLoan.DataValue.class)) != null ? ((AutopalLoan.DataValue) json.deserialize(jsonStr,AutopalLoan.DataValue.class)).value : null) : null);
                                        }
                                    }
                                    //Payments
                                    if(objData.get('payments') != null){
                                        payments = (Map<String,Object>) objData.get('payments');
                                    }
                                    //User Information
                                    if(objData.get('userInformation') != null){
                                        jsonStr = JSON.serialize(objData.get('userInformation'));
                                        userInformation = (AutopalLoan.UserInformation) json.deserialize(jsonStr,AutopalLoan.UserInformation.class);
                                        if(userInformation.borrower != null){
                                            contactRecord = new Contact();
                                            contactRecord.Autopal_ID__c = userInformation.borrower.id;
                                            loanApp.Contact_Autopal_ID__c = contactRecord.Autopal_ID__c;
                                            contactRecord.RecordTypeId = Schema.SObjectType.Contact.getRecordTypeInfosByDeveloperName().get('Applicant').getRecordTypeId();
                                            contactRecord.FirstName = (userInformation.borrower.name != null ? userInformation.borrower.name.first : null);
                                            contactRecord.MiddleName = (userInformation.borrower.name != null ? userInformation.borrower.name.middle : null);
                                            contactRecord.LastName = (userInformation.borrower.name != null ? userInformation.borrower.name.last : null);
                                            contactRecord.SSN__c = userInformation.borrower.ssn;
                                            contactRecord.Gender__c = userInformation.borrower.gender;
                                            contactRecord.Phone = userInformation.borrower.primaryPhone;
                                            if(userInformation.borrower.email != null){
                                                MyPattern = Pattern.compile(emailRegex);
                                                MyMatcher = MyPattern.matcher(userInformation.borrower.email);
                                                if (MyMatcher.matches()) contactRecord.Email = userInformation.borrower.email;
                                            }
                                            contactRecord.Birthdate = null;
                                            if(userInformation.borrower.dob != null && userInformation.borrower.dob.date_z != null){
                                                try{
                                                    contactRecord.Birthdate = Date.valueOf(userInformation.borrower.dob.date_z.split(' ')[0]); 
                                                }catch(Exception e){
                                                    contactRecord.Birthdate = null;
                                                }
                                            }
                                            contactRecord.MailingStreet = (userInformation.borrower.mailAddress != null && userInformation.borrower.mailAddress.address != null ? userInformation.borrower.mailAddress.address : null);
                                            contactRecord.MailingCity = (userInformation.borrower.mailAddress != null && userInformation.borrower.mailAddress.city != null ? userInformation.borrower.mailAddress.city : null);
                                            contactRecord.MailingState = (userInformation.borrower.mailAddress != null && userInformation.borrower.mailAddress.state != null ? userInformation.borrower.mailAddress.state : null);
                                            contactRecord.MailingPostalCode = (userInformation.borrower.mailAddress != null && userInformation.borrower.mailAddress.zipCode != null ? userInformation.borrower.mailAddress.zipCode : null);
                                            contactRecord.MailingCountry = (userInformation.borrower.mailAddress != null && userInformation.borrower.mailAddress.country != null ? userInformation.borrower.mailAddress.country : null);
                                            contactRecord.OtherStreet = (userInformation.borrower.primaryAddress != null && userInformation.borrower.primaryAddress.address != null ? userInformation.borrower.primaryAddress.address : null);
                                            contactRecord.OtherCity = (userInformation.borrower.primaryAddress != null && userInformation.borrower.primaryAddress.city != null ? userInformation.borrower.primaryAddress.city : null);
                                            contactRecord.OtherState = (userInformation.borrower.primaryAddress != null && userInformation.borrower.primaryAddress.state != null ? userInformation.borrower.primaryAddress.state : null);
                                            contactRecord.OtherPostalCode = (userInformation.borrower.primaryAddress != null && userInformation.borrower.primaryAddress.zipCode != null ? userInformation.borrower.primaryAddress.zipCode : null);
                                            contactRecord.OtherCountry = (userInformation.borrower.primaryAddress != null && userInformation.borrower.primaryAddress.country != null ? userInformation.borrower.primaryAddress.country : null);
                                            
                                            if(contactRecord.LastName == null && contactRecord.FirstName != null){
                                                contactRecord.LastName = contactRecord.FirstName;
                                                contactRecord.FirstName = null;
                                            }
                                            if(contactRecord.LastName != null) contactMap.put(contactRecord.Autopal_ID__c,contactRecord);
                                        }
                                    }
                                }
                            }                            
                            loanMap.put(loanApp.Loan_ID__c,loanApp);
                        }
                    }
                    //system.debug(objList);
                    break;
                }
                i++;
            }
            
            if(!loanMap.isEmpty()){
                List<Database.upsertResult> uResults;
                
                //Contacts
                uResults = Database.upsert(contactMap.values(),Contact.Autopal_ID__c,false);
                for(Database.upsertResult result : uResults) {
                    if(!result.isSuccess()){
                        for(Database.Error err : result.getErrors()) system.debug(err.getStatusCode() + ': ' + err.getMessage() + '. ' + 'Fields that affected this error: ' + err.getFields());
                    }
                }
                
                for(Loan__c l : loanMap.values()){
                    if(l.Contact_Autopal_ID__c != null && contactMap.get(l.Contact_Autopal_ID__c) != null) l.Contact_Name__c = contactMap.get(l.Contact_Autopal_ID__c).Id;
                }
                
                //Loan
                uResults = Database.upsert(loanMap.values(),Loan__c.Loan_ID__c,false);
                for(Database.upsertResult result : uResults) {
                    if(!result.isSuccess()){
                        for(Database.Error err : result.getErrors()) system.debug(err.getStatusCode() + ': ' + err.getMessage() + '. ' + 'Fields that affected this error: ' + err.getFields());
                    }
                }
            }
        }
	}
	
	public void finish(Database.BatchableContext BC) {
    	system.debug('##finish AutopalLoansBatch');
    }
}