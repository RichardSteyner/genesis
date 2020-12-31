public class TCIConnection{
	public static String clientId = 'gene532';
	public static String apiClientKey = 'GckTVKbi3p7IbYomGo9Ad8FA/TsZuf/kwLtZ1o/FMoiZwwvr3AvXka6IZb+d/bD3';
	public static String dealerId = '';
	public static String userId = 'Cloudcreations';
	public static String apiKeyName = 'CloudCreations';
	public static String apiKey = 'GckTVKbi3p7IbYomGo9Ad8FA/TsZuf/kwLtZ1o/FMoiZwwvr3AvXka6IZb+d/bD3';
	public static String appId = '';
	
	public static void test(){
		Map<String,String> headers = genAuthHeaders('GET','/applications/2079068385527');
        system.debug(headers);
        
        Http h = new Http(); 
        HttpRequest req = new HttpRequest();
        req.setMethod('GET');
        Map<String,String> parametersOAuth = new Map<String,String>();
        req.setEndpoint('https://api-demo.decisionlender.solutions/applications/2079068385527');
        req.setTimeout(120000);
        for(String key : headers.keySet()){
            system.debug(key + ': ' + headers.get(key));
            req.setHeader(key,headers.get(key));
        }
        req.setHeader('Content-Type','application/json');
		HttpResponse res = h.send(req);
        system.debug(res.getStatus());
        system.debug(res.getStatusCode());
        system.debug(res.getBody());
	}
	
	public static Map<String,String> genAuthHeaders(String method, String path){
		String datex = '20201208';//Datetime.now().format('Ymmd');
		// current UTC timestamp in millisec
		String timestamp = String.valueOf(DateTime.now().getTime() / 1000);
		
        String authHeader = 'TCIv1-HmacSHA256 Credential=';
        List<String> creds = new List<String>{datex,'external',clientId,userId,apiKeyName};
            
       	if(dealerId != null && dealerId != '') creds = new List<String>{datex,'external',clientId,dealerId,userId,apiKeyName};
            
        String signingKey = apiKey; //generateHmacSHA256Signature(apiKey, 'HmacSHA256'); 
        String toSign = method + ';' + path + ';' + datex;
        // derive request signing key from the api key + creds
        for(Integer i = 0; i < creds.size(); i++ ) {
            signingKey = generateHmacSHA256Signature(creds[i], signingKey);
            if(i > 0) authHeader = authHeader + '/';
            authHeader = authHeader + creds[i];
        }
        authHeader = authHeader + ', SignedHeaders=' + toSign + ', SignedEntities=METHOD;PATH;x-tci-timestamp, Signature=';
        
        system.debug('##authHeader: '+authHeader);
        system.debug('##signingKey: '+signingKey);
        // generate signature
        String signature = generateHmacSHA256Signature(authHeader, signingKey);
        authHeader = authHeader + EncodingUtil.convertToHex(Blob.valueOf(signature));
        system.debug('##authHeader: '+authHeader);

        Map<String,String> headers = new Map<String,String>();
        headers.put('x-api-key',apiClientKey);
        headers.put('Authorization',authHeader);
        headers.put('x-tci-timestamp',timestamp);
        
		return headers;
	}
    
    public static String generateHmacSHA256Signature(String input, String secretKey) {
        Blob mac = Crypto.generateMac('HmacSHA256', Blob.valueOf(input), EncodingUtil.base64Decode(Secretkey));
        String macUrl = EncodingUtil.base64Encode(mac);
        return macUrl;
    }
}