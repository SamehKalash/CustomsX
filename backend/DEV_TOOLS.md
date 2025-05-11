# Development Tools for Phone Verification

## Console Logging

When a user registers or requests a verification code, the code is logged to the console:

```
==================================================
📱 VERIFICATION CODE for +1234567890: 123456
==================================================
```

This allows you to easily test the verification flow without setting up real SMS credentials.

## Manual Phone Verification

For testing purposes, you can manually verify a user's phone using a special development endpoint:

```
GET /dev/verify-phone/:email
```

Example:
```
http://localhost:5000/dev/verify-phone/user@example.com
```

This will:
1. Find the user with the provided email
2. Set `phoneVerified` to `true` in the database
3. Return a success message

## Phone Verification Process

The simplified phone verification process works as follows:

1. User registers with the application
2. Backend generates a 6-digit verification code and displays it in the console
3. User enters the code in the verification screen
4. Upon successful verification, user is redirected to the login screen
5. User can now log in with their credentials

## Development Tips

1. **View Verification Codes**: Check the server console for verification codes.
2. **Skip Verification**: Use the `/dev/verify-phone/:email` endpoint to manually verify users.
3. **Testing Registration**: You can see new user registrations in the console with the `🔐 NEW USER REGISTRATION` message.
4. **Testing Resend**: When resending a verification code, look for the `🔄 RESENDING VERIFICATION CODE` message.
5. **Unverified Login Attempts**: When a user with an unverified phone tries to log in, a new code is generated with the `⚠️ LOGIN ATTEMPT WITH UNVERIFIED PHONE` message.

## Important Notes

- This simplified verification process is for development and testing only
- In production, proper SMS sending should be configured with a service like Twilio, Nexmo, etc.
- 2FA (Two-Factor Authentication) has been disabled in this version 