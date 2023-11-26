public class OTPVerification {
    
     @InvocableMethod(label='Generate OTP Number')
    public static List<RandomNumberResponse> generateRandomNumber() {
        Integer randomNum = (Integer)Math.floor(Math.random() * 900000) + 100000;
        List<RandomNumberResponse> responseList = new List<RandomNumberResponse>();
        responseList.add(new RandomNumberResponse(String.valueOf(randomNum)));
        return responseList;
    }

    public class RandomNumberResponse {
        @InvocableVariable
        public String randomNumber;

        public RandomNumberResponse(String randomNumber) {
            this.randomNumber = randomNumber;
        }
    }

}