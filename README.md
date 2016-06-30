#Microsft Azure Active Directory Native Client for iOS B2C (iPhone)

**NOTE regarding iOS 9:**

Apple has released iOS 9 which includes support for App Transport Security (ATS). ATS restricts apps from accessing the internet unless they meet several security requirements incuding TLS 1.2 and SHA-256. While Microsoft's APIs support these standards some third party APIs and content delivery networks we use have yet to be upgraded. This means that any app that relies on Azure Active Directory or Microsoft Accounts will fail when compiled with iOS 9. For now our recommendation is to disable ATS, which reverts to iOS 8 functionality. Please refer to this [technote from Apple](https://developer.apple.com/library/prerelease/ios/technotes/App-Transport-Security-Technote/) for more informtaion.

----

This sample shows how to build an iOS application that calls a web API that uses a Facebook, Google, or Local Account for authentication. This sample uses the Active Directory Authentication Library for iOS to do the interactive OAuth 2.0 authorization code flow with public client.


## Quick Start

Getting started with the sample is easy. It is configured to run out of the box with minimal setup. 



### Step 1: Download the iOS B2C Native Client Sample code

* `$ git clone git@github.com:AzureADSamples/B2C-NativeClient-iOS.git`

### Step 2: Download Cocoapods (if you don't already have it)

CocoaPods is the dependency manager for Swift and Objective-C Cocoa projects. It has thousands of libraries and can help you scale your projects elegantly. To install on OS X 10.9 and greater simply run the following command in your terminal:

`$ sudo gem install cocoapods`

### Step 3: Build the sample and pull down ADAL for iOS automatically

Run the following command in your terminal:

`$ pod install`

This will download and build ADAL for iOS for you and configure your Microsoft Tasks B2C.xcodeproj to use the correct dependencies.

You should see the following output:

```
$ pod install
Analyzing dependencies

Pre-downloading: `ADALiOS` from `https://github.com/AzureAD/azure-activedirectory-library-for-objc.git`, branch `B2C-ADAL`
Downloading dependencies
Installing ADALiOS (1.2.2)
Generating Pods project
Integrating client project

[!] Please close any current Xcode sessions and use `Microsoft Tasks B2C.xcworkspace` for this project from now on.
```
### Step 4: Run the application in Xcode

Launch XCode and load the `Microsoft Tasks B2C.xcworkspace` file. The application will run in an emulator as soon as it is loaded. 

 
### Step 5: Configure the settings.plist file with your tenant information

You will need to configure your application to work with the Azure AD tenant you've created. Under "Supporting Files"you will find a settings.plist file. It contains the following information:

```XML
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
	<key>authority</key>
	<string>https://login.microsoftonline.com/hypercubeb2c.onmicrosoft.com/oauth2/authorize?api-version=1.0</string>
	<key>clientId</key>
	<string>31367e67-6ccc-41fb-8613-ad8be09951ef</string>
	<key>resourceString</key>
	<string>http://localhost:8888</string>
	<key>redirectUri</key>
	<string>https://com.microsoft.windowsazure.activedirectory.samples.Microsoft-Tasks</string>
	<key>userId</key>
	<string>test@hypercubeb2c.onmicrosoft.com</string>
	<key>taskWebAPI</key>
	<string>http://localhost:8888/tasks</string>
	<key>signUpPolicyId</key>
	<string>B2C_1_B2CSU</string>
	<key>signInPolicyId</key>
	<string>B2C_1_B2CSI</string>
	<key>fullScreen</key>
	<true/>
</dict>
</plist>
```

Replace the information in the plist file with your settings. 

##### NOTE

The current defaults are set up to work with our [Azure Active Directory Sample REST API Service for Node.js B2C](https://github.com/AzureADSamples/B2C-WebAPI-Nodejs). You will need to specify the clientID of your Web API, however. If you are running your own API, you will need to update the endpoints as required.





