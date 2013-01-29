function facebookLogin(){
  FB.login(function(response) {
   if (response.authResponse) {
     window.location.replace('/account/fb_authenticate');
   } else {
     console.log('User cancelled login or did not fully authorize.');
   }
  }, {scope: 'email, user_location, publish_stream'});
}