@isTest
public class OTPGeneratorTest {

    @isTest
    static void testGenerateOTP() {
        // Define the desired OTP length for testing
        Integer desiredLength = 6;

        // Call the generateOTP method with the desired length
        List<Integer> lengthList = new List<Integer>();
        lengthList.add(desiredLength);
        List<String> otpList = OTPGenerator.generateOTP(lengthList);

        // Ensure that the OTP list contains only one OTP
        System.assertEquals(1, otpList.size(), 'There should be only one OTP generated');

        // Check if the generated OTP matches the desired length and contains only valid characters
        String generatedOTP = otpList[0];
        System.assertEquals(desiredLength, generatedOTP.length(), 'Generated OTP length should match the desired length');
        for (Integer i = 0; i < generatedOTP.length(); i++) {
            String character = generatedOTP.substring(i, i + 1);
            System.assert(allowedCharacters.contains(character), 'Generated OTP should contain valid characters');
        }
    }
    
    // Define the allowed characters for OTP
    static String allowedCharacters = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';
}