Lovense SDK for iOS
========================

The Lovense iOS SDK is a set of application interfaces based on iOS 8.0 and above. Use this SDK to develop applications for iOS mobile devices. By calling the Lovense SDK interface, you can easily control Lovense toys and build applications with rich functions and strong interactivity.


TRY IT OUT
----------

In order to be able to use the API you must create a free account on the Lovense Official website in order to get your token
1. Create a new account at https://www.lovense.com/sextoys/developer/join/.
2. Go to https://www.lovense.com/user/developer/info and get your developer token.
3. Start coding! Visit https://developer.lovense.com/lovense-ios-sdk-demo.zip to download the demo app.
4. Check out https://developer.lovense.com/#ios-sdk for a list of commands and callbacks.
5. You can also download the demo app from this repo.


INSTALLATION
------------

- Create a new account at https://www.lovense.com/sextoys/developer/join/

- Go to https://www.lovense.com/user/developer/info and get your developer token

- Download and extract the Lovense SDK at https://developer.lovense.com/lovense-ios-sdk-1.0.6.zip

- Copy the extracted `Lovense.framework` to your project

- Configure environment: TARGETS -> General -> Deployment Info -> Deployment Target -> setting 8.0 or above

- Connect Lovense toys and send commands

```
// import Lovense
#import <Lovense/Lovense.h>

// Pass your token into the Lovense framework
[[Lovense  shared] setDeveloperToken:@"Your token"];

// Add a scan success notification
[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(scanSuccessCallback:)
name:kToyScanSuccessNotification object:nil];      //Scanning toy success notification
-(void)scanSuccessCallback:(NSNotification *)noti
{
    NSDictionary * dict = [noti object];
    NSArray <LovenseToy*>* toys = [dict objectForKey:@"scanToyArray"];
}

// Add a connect success notification

[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(connectSuccessCallback:)
name:kToyConnectSuccessNotification object:nil];     //Connected toy successfully notification
-(void)connectSuccessCallback:(NSNotification *)noti
{
    NSDictionary * dict = [noti object];
    LovenseToy * toy = [dict objectForKey:@"toy"];
    NSLog(@"%@",toy);
}

// Search for the toys over Bluetooth
[[Lovense  shared] searchToys];

// Save the toys
[[Lovense  shared] saveToys:toys];

// Retrieve the saved toys
NSArray<LovenseToy*> * listToys = [[Lovense  shared] listToys];

// Connect the toy
[[Lovense shared] connectToy:toyId];

// Disconnect the toy
[[Lovense shared] disconnectToy:toyId];

// Send a command to the toy
[[LovenseBluetoothManager shared] sendCommandWithToyId:toyId
andCommandType:COMMAND_VIBRATE andParamDict:@{kSendCommandParamKey
_VibrateLevel:@(20)}];
```











GIVE FEEDBACK
-------------
Please report bugs or issues to [Lovense Support](mailto:developer@mail.lovense.com).

You can also join our [Lovense Developer Community Discord](https://discord.gg/dW9f54BwqR), visit the [Lovense Developers Website](https://developer.lovense.com/#introduction), or open an issue in this repository.
