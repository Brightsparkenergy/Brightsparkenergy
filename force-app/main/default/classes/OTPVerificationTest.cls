@isTest
private class OTPVerificationTest {

    @isTest
    static void testGenerateRandomNumber() {
        // Call the method to test
        List<OTPVerification.RandomNumberResponse> result = OTPVerification.generateRandomNumber();

        // Add your assertions here based on the expected results
        System.assertEquals(1, result.size());
        System.assertNotEquals(null, result[0].randomNumber);
        System.assertNotEquals('', result[0].randomNumber);
        System.assert(Integer.valueOf(result[0].randomNumber) >= 100000 && Integer.valueOf(result[0].randomNumber) <= 999999);
    }
}