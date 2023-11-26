import { LightningElement, track, api } from 'lwc';
import validateOTP from '@salesforce/apex/ValidateEmailAndOTP.validateOTP';
export default class LoginPageLWC extends LightningElement { 
//showSpinner = false;
@track email = '';
@track otp = '';
@track verificationResult = false;
@track verificationResultMessage = '';




handleEmailChange(event) {
    this.email = event.target.value;
}

handleOTPChange(event) {
    this.otp = event.target.value;
}

validateOTPAndLogin() {
    //this.showSpinner = true;
    validateOTP({ emailID: this.email, enteredOTP: this.otp })
        .then(result => {
            this.verificationResult = result;
            if (result) {
                this.verificationResultMessage = 'Verification successful!';
            }
            else {
                this.verificationResultMessage = 'Verification failed. Please check your email and OTP.';
                }
         
            
        })
        .catch(error => {
            
            console.error('Error:', error);
                this.verificationResultMessage = 'An error occurred during verification.';
            });
        
}

}