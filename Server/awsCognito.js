const AWS = require('aws-sdk');

AWS.config.update({ region: 'YOUR_AWS_REGION' });

const cognito = new AWS.CognitoIdentityServiceProvider();

const authenticateUser = (username, password) => {
  const params = {
    AuthFlow: 'ADMIN_NO_SRP_AUTH',
    UserPoolId: 'YOUR_USER_POOL_ID',
    ClientId: 'YOUR_CLIENT_ID',
    AuthParameters: {
      USERNAME: username,
      PASSWORD: password,
    },
  };

  return new Promise((resolve, reject) => {
    cognito.adminInitiateAuth(params, (err, data) => {
      if (err) {
        reject(err);
      } else {
        resolve(data.AuthenticationResult);
      }
    });
  });
};

module.exports = {
  authenticateUser,
};
