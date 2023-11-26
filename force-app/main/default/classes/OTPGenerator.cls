public class OTPGenerator {
@invocableMethod(label='update otp field')
    // Method to generate a random OTP of a specified length
    public static list<String> generateOTP(list<Integer> length) {
        Integer myValue = length[0];
        String allowedCharacters = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';
        String otp = '';
        
        for (Integer i = 0; i < myValue; i++) {
            Integer randomIndex = Math.mod(Math.abs(Crypto.getRandomInteger()), allowedCharacters.length());
            system.debug(randomIndex);
            otp += allowedCharacters.substring(randomIndex, randomIndex + 1);
            system.debug(otp);
        }
        
        // Return a result as a List<String> (you can change the type as needed)
        List<String> result = new List<String>();
        result.add(otp);
		system.debug(result);
        return result;
    }
    
    
    
    // Method to store the OTP in a field
   /*public static void storeOTP(Id recordId, string otp) {
        inov8__PMT_Project__c obj = [SELECT Id, OTP__c FROM inov8__PMT_Project__c WHERE Id = :recordId LIMIT 1];
        
        if (obj != null) {
            obj.OTP__c = otp;
            update obj;
        }
    }*/
}