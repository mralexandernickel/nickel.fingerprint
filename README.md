Fingerprints of Files for AngularJS
===================================

Generate Fingerprints/MD5-Checksums of Files inside the Browser... comes very handy to check if File-Uploads to the Server have been REALLY successful. This Module is always splitting the Files into Chunks of 2MB before generating the Fingerprint, as otherwise it would consume WAY too much Memory, leading to wrong Fingerprints on large Files...

Please Note that this Module requires [SparkMD5](https://github.com/satazor/SparkMD5).

## How to use

Load SparkMD5 and this Module inside your DOM, and set this Module as dependency in your AngularJS-App. After that you have to include the shipped Provider in your Controller (or wherever you need it), and you're ready to go:

    ExampleController = function($scope, $fingerprint) {
      $scope.eventHandler = function(file) {
        $fingerprint.generate(file)
          .then(function(fingerprint){
            console.log("The generated Fingerprint is " + fingerprint)
          },
          function(error){
            console.log(error)
          },
          function(progress){
            console.log(progress + "% of the Fingerprint generated...")
          })
      }
    }
    app.controller("ExampleController", ExampleController)
