public class AutopalConnection {

    public static String companyId = Autopal__c.getOrgDefaults().Company_ID__c;
    public static String companyKey = Autopal__c.getOrgDefaults().Company_Key__c;
    public static String userId = Autopal__c.getOrgDefaults().User_ID__c;
    public static String urlBase = Autopal__c.getOrgDefaults().Base__c;
    
    public static HttpResponse getData(String filters){
        String url = urlBase + filters;
        String signature = generateHmacSHA256Signature(Blob.valueOf(url),Blob.valueOf(companyKey));
        Map<String,String> parametersOAuth = new Map<String,String>();
        parametersOAuth.put('X-AutoPal-Company',companyId);
        parametersOAuth.put('X-AutoPal-Auth',signature);
        parametersOAuth.put('X-AutoPal-User',userId);
 		return createRequest(url,parametersOAuth);
    }
    
    public static HttpResponse createRequest(String url, Map<String,String> parameters){
        Http h = new Http(); 
        HttpRequest req = new HttpRequest();
        req.setMethod('GET');
        req.setEndpoint(url);
        req.setTimeout(120000);
        req.setHeader('Content-Type','application/x-www-form-urlencoded');
        for(String key : parameters.keySet()){
            //system.debug(key + ': ' + parameters.get(key));
            req.setHeader(key,parameters.get(key));
        }
        HttpResponse res = h.send(req);
        //system.debug(res.getStatus());
        //system.debug(res.getStatusCode());
        //system.debug(res.getBody());
        //for(String key : res.getHeaderKeys()){
        //    system.debug(key + ': ' + res.getHeader(key));
        //}
        return res;
    }
    
    public static String generateHmacSHA256Signature(Blob input, Blob secretKey) {
        return EncodingUtil.convertToHex(Crypto.generateMac('HmacSHA256',input,secretKey));
    }
}