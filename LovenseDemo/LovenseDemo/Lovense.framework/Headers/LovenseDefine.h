//
//  LovenseBluetoothSDK.h
//  LovenseBluetoothSDK
//
//  Created by Lovense on 2019/3/4.
//  Copyright © 2019 Hytto. All rights reserved.
//

#import <UIKit/UIKit.h>

#pragma mark - CommandType
typedef enum {
    /**
     - Vibrate the toy .The parameter must be between 0 and 20!
     - param Key = kSendCommandParamKey_VibrateLevel
     - Supported toys = all
     - return notification = kToyCommandCallbackNotificationAtSuccess
     [notification object] = @{@"receiveToy":LovenseToy,
     @"receiveToyUUID":NSString,
     @"commandType":NSString
     }
     */
    COMMAND_VIBRATE = 101,

    /**
     - Rotate the toy .The parameter must be between 0 and 20!
     - param Key = kSendCommandParamKey_RotateLevel
     - Supported toys = Nora
     - return notification = kToyCommandCallbackNotificationAtSuccess
     [notification object] = @{@"receiveToy":LovenseToy,
     @"receiveToyUUID":NSString,
     @"commandType":NSString
     }
     */
    COMMAND_ROTATE = 102,

    /**
     - Rotate clockwise .The parameter must be between 0 and 20!
     - param Key = kSendCommandParamKey_RotateLevel
     - Supported toys = Nora
     - return notification = kToyCommandCallbackNotificationAtSuccess
     [notification object] = @{@"receiveToy":LovenseToy,
     @"receiveToyUUID":NSString,
     @"commandType":NSString
     }
     */
    COMMAND_ROTATE_CLOCKWISE = 103,

    /**
     - Rotate anti-clockwise .The parameter must be between 0 and 20!
     - param Key = kSendCommandParamKey_RotateLevel
     - Supported toys = Nora
     - return notification = kToyCommandCallbackNotificationAtSuccess
     [notification object] = @{@"receiveToy":LovenseToy,
     @"receiveToyUUID":NSString,
     @"commandType":NSString
     }
     */
    COMMAND_ROTATE_ANTI_CLOCKWISE = 104,

    /**
     - Change the rotation direction
     - param Key = no parameter
     - Supported toys = Nora
     - return notification = kToyCommandCallbackNotificationAtSuccess
     [notification object] = @{@"receiveToy":LovenseToy,
     @"receiveToyUUID":NSString,
     @"commandType":NSString
     }
     */
    COMMAND_ROTATE_CHANGE = 105,

    /**
     - Air inflation for n seconds. The parameter must be between 1 and 3.
     - param Key = kSendCommandParamKey_AirLevel
     - Supported toys = Max
     - return notification = kToyCommandCallbackNotificationAtSuccess
     [notification object] = @{@"receiveToy":LovenseToy,
     @"receiveToyUUID":NSString,
     @"commandType":NSString
     }
     */
    COMMAND_AIR_IN = 106,

    /**
     - Air deflation for n seconds. The parameter must be between 1 and 3.
     - param Key = kSendCommandParamKey_AirLevel
     - Supported toys = Max
     - return notification = kToyCommandCallbackNotificationAtSuccess
     [notification object] = @{@"receiveToy":LovenseToy,
     @"receiveToyUUID":NSString,
     @"commandType":NSString
     }
     */
    COMMAND_AIR_OUT = 107,

    /**
     - Cycle air inflation for n seconds and air deflation for n seconds. The parameter must be between 0 and 3 (0 means stop).
     - param Key = kSendCommandParamKey_AirAutoLevel
     - Supported toys = Max
     - return notification = kToyCommandCallbackNotificationAtSuccess
     [notification object] = @{@"receiveToy":LovenseToy,
     @"receiveToyUUID":NSString,
     @"commandType":NSString
     }
     */
    COMMAND_AIR_AUTO = 108,

    
    /**
     - Vibrate with a preset pattern. Patterns range from 1 to 10. n=0 will stop vibrations.
     - param Key = kSendCommandParamKey_PresetLevel
     - Supported toys = all
     - return notification = kToyCommandCallbackNotificationAtSuccess
     [notification object] = @{@"receiveToy":LovenseToy,
     @"receiveToyUUID":NSString,
     @"commandType":NSString
     }
     */
    COMMAND_PRESET = 109,
    
    /**
     - Activate the first vibrator at level n .The parameter must be between 0 and 20!
     - param Key = kSendCommandParamKey_VibrateLevel
     - Supported toys = Edge
     - return notification = kToyCommandCallbackNotificationAtSuccess
     [notification object] = @{@"receiveToy":LovenseToy,
     @"receiveToyUUID":NSString,
     @"commandType":NSString
     }
     */
    COMMAND_VIBRATE1 = 113,
    
    /**
     - Activate the second vibrator at level n .The parameter must be between 0 and 20!
     - param Key = kSendCommandParamKey_VibrateLevel
     - Supported toys = Edge
     - return notification = kToyCommandCallbackNotificationAtSuccess
     [notification object] = @{@"receiveToy":LovenseToy,
     @"receiveToyUUID":NSString,
     @"commandType":NSString
     }
     */
    COMMAND_VIBRATE2 = 114,

    /**
     - Vibrate the toy at level n, and flash the light at the same time .The parameter must be between 0 and 20!
     - param key = kSendCommandParamKey_VibrateLevel: vibration level (between 1~3)
     - param key = kSendCommandParamKey_FlashLevel: Flashing frequency (per second). Between 0~9
     - Supported toys = Ambi / Domi / Osci
     - return notification = kToyCommandCallbackNotificationAtSuccess
     [notification object] = @{@"receiveToy":LovenseToy,
     @"receiveToyUUID":NSString,
     @"commandType":NSString
     }
     */
    COMMAND_VIBRATE_FLASH = 120,

    /**
     - Flash the light 3 times
     - param Key = no parameter
     - Supported toys = all
     - return notification = kToyCommandCallbackNotificationAtSuccess
     [notification object] = @{@"receiveToy":LovenseToy,
     @"receiveToyUUID":NSString,
     @"commandType":NSString
     }
     */
    COMMAND_FLASH = 201,

    /**
     - Turn off the light (saved permanently)
     - param Key = no parameter
     - Supported toys = Lush / Hush / Edge
     - return notification = kToyCommandCallbackNotificationAtSuccess
     [notification object] = @{@"receiveToy":LovenseToy,
     @"receiveToyUUID":NSString,
     @"commandType":NSString
     }
     */
    COMMAND_LIGHT_OFF = 210,

    /**
     - Turn on the light (saved permanently)
     - param Key = no parameter
     - Supported toys = Lush / Hush / Edge
     - return notification = kToyCommandCallbackNotificationAtSuccess
     [notification object] = @{@"receiveToy":LovenseToy,
     @"receiveToyUUID":NSString,
     @"commandType":NSString
     }
     */
    COMMAND_LIGHT_ON = 211,

    /**
     Get the light status (1: on, 0:off)
     - param Key = no parameter
     * Supported toys = Lush  Hush  Edge
     - return notification "kToyCallbackNotificationGetLightStatus"
     [notification object] = @{@"receiveToy":LovenseToy,
     @"receiveToyUUID":NSString,
     @"isOpen":NSString
     }
     */
    COMMAND_GET_LIGHT_STATUS = 212,

    /**
     - Turn off the AID light (saved permanently)
     - param Key = no parameter
     - Supported toys = Domi
     - return notification = kToyCommandCallbackNotificationAtSuccess
     [notification object] = @{@"receiveToy":LovenseToy,
     @"receiveToyUUID":NSString,
     @"commandType":NSString
     }
     */
    COMMAND_ALIGHT_OFF = 220,

    /**
     - Turn on the AID light (saved permanently)
     - param Key = no parameter
     - Supported toys = Domi
     - return notification = kToyCommandCallbackNotificationAtSuccess
     [notification object] = @{@"receiveToy":LovenseToy,
     @"receiveToyUUID":NSString,
     @"commandType":NSString
     }
     */
    COMMAND_ALIGHT_ON = 221,

    /**
     Get the AID light status (1: on, 0:off)
     - param Key = no parameter
     * Supported toys = Domi
     - return notification "kToyCallbackNotificationGetAidLightStatus"
     [notification object] = @{@"receiveToy":LovenseToy,
     @"receiveToyUUID":NSString,
     @"isOpen":NSString
     }
     */
    COMMAND_GET_ALIGHT_STATUS = 222,

    /**
     - Get battery status,
     - param Key = no parameter
     * Supported toys = all
     - return notification "kToyCallbackNotificationBattery"
     [notification object] = @{@"receiveToy":LovenseToy,
     @"receiveToyUUID":NSString,
     @"battery":NSString}
     */
    COMMAND_GET_BATTERY = 300,

    /**
     Get device/toy information
     - param Key = no parameter
     * Supported toys = all
     - return notification "kToyCallbackNotificationDeviceType"
      [notification object] = @{@"receiveToy":LovenseToy,
      @"receiveToyUUID":NSString,
      @"type":NSString,
      @"version":NSString,
      @"macAddress":NSString
      }
     */
    COMMAND_GET_DEVICE_TYPE = 310,

    /**
     Start tracking the toy movement (0-4)
     - param Key = no parameter
     * Supported toys = Max,Nora
     - return notification "kToyCallbackNotificationListenMove"
     [notification object] = @{@"receiveToy":LovenseToy,
     @"receiveToyUUID":NSString,
     @"moveLevel":NSString
     }
     */
    COMMAND_START_MOVE = 400,

    /**
     Stop tracking the toy movement
     - param Key = no parameter
     * Supported toys = Max,Nora
     - return notification = kToyCommandCallbackNotificationAtSuccess
     [notification object] = @{@"receiveToy":LovenseToy,
     @"receiveToyUUID":NSString,
     @"commandType":NSString
     }
     */
    COMMAND_STOP_MOVE = 401

} LovenseCommandType;


#pragma mark - Parameter KEY
#define kSendCommandParamKey_VibrateLevel @"VibrateLevel" //Vibrate key 0-20
#define kSendCommandParamKey_PresetLevel @"PresetLevel" //Preset key (Lush,Hush 0-3)(Ambi, Domi, Osci 0-10)
#define kSendCommandParamKey_RotateLevel @"RotateLevel"   //Rotate key 0-20
#define kSendCommandParamKey_FlashLevel @"FlashLevel" //Flash light key 0-9
#define kSendCommandParamKey_AirLevel @"AirLevel"   //Air key 1-3
#define kSendCommandParamKey_AirAutoLevel @"AirAutoLevel"   //Air auto key 0 - 3


#pragma mark - Notification Callbacks
/**
 Found toy list
 callback parameter object = @{@"scanToyArray":<LovenseToy*>NSArray*}
 **/
#define kToyScanSuccessNotification @"kToyScanSuccessNotification"

/**
 Update toy callback
 callback parameter object = @{@"updateToyArray":<LovenseToy*>NSArray*}
 **/
#define kToyScanUpdateSuccessNotification @"kToyScanUpdateSuccessNotification"

/**
 Toy connected
 callback parameter object = @{@"toy":LovenseToy}
 **/
#define kToyConnectSuccessNotification @"kToyConnectSuccessNotification"

/**
 Failed to connect a toy
 callback parameter object = @{@"toy":LovenseToy,@"error":NSString}
 **/
#define kToyConnectFailNotification @"kToyConnectFailNotification"

/**
 Disconnect a toy
 callback parameter object = @{@"toy":LovenseToy,@"error":NSError}
 **/
#define kToyConnectBreakNotification @"kToyConnectBreakNotification"

/**
 Unknown Command Received
 callback parameter object = @{@"errorDesc":NSString}
 **/
#define kToySendCommandErrorNotification @"kToySendCommandErrorNotification"

/**
 Command success
 callback parameter object = @{@"receiveToy":LovenseToy,
 @"receiveToyUUID":NSString,
 @"commandType":NSString
 }
 **/
#define kToyCommandCallbackNotificationAtSuccess @"kToyCommandCallbackNotificationAtSuccess"

/**
 Command Error
 callback parameter object = @{@"receiveToy":LovenseToy,
 @"receiveToyUUID":NSString,
 @"commandType":NSString
 }
 **/
#define kToyCommandCallbackNotificationAtError @"kToyCommandCallbackNotificationAtError"

/**
 Battery status
 callback parameter object = @{@"receiveToy":LovenseToy,
 @"receiveToyUUID":NSString,
 @"battery":NSString}
 **/
#define kToyCallbackNotificationBattery @"kToyCallbackNotificationBattery"

/**
 Device information
 callback parameter object = @{@"receiveToy":LovenseToy,
 @"receiveToyUUID":NSString,
 @"type":NSString,
 @"version":NSString,
 @"macAddress":NSString
 }
 **/
#define kToyCallbackNotificationDeviceType @"kToyCallbackNotificationDeviceType"

/**
 Light indicator
 callback parameter object = @{@"receiveToy":LovenseToy,
 @"receiveToyUUID":NSString,
 @"isOpen":NSString
 }
 **/
#define kToyCallbackNotificationGetLightStatus @"kToyCallbackNotificationGetLightStatus"

/**
 AID light indicator
 callback parameter object = @{@"receiveToy":LovenseToy,
 @"receiveToyUUID":NSString,
 @"isOpen":NSString
 }
 **/
#define kToyCallbackNotificationGetAidLightStatus @"kToyCallbackNotificationGetAidLightStatus"

/**
 Toy movement updates
 callback parameter object = @{@"receiveToy":LovenseToy,
 @"receiveToyUUID":NSString,
 @"moveLevel":NSString
 }
 **/
#define kToyCallbackNotificationListenMove @"kToyCallbackNotificationListenMove"

