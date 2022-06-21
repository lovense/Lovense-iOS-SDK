//
//  LovenseToy.h
//  LovenseBluetoothSDK
//
//  Created by Lovense on 2019/3/4.
//  Copyright © 2019 Hytto. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreBluetooth/CoreBluetooth.h>

NS_ASSUME_NONNULL_BEGIN

@interface LovenseToy : NSObject<NSCoding>

///name
@property(nonatomic,copy,readonly)NSString * name;

///Toy ID
@property(nonatomic,copy,readonly)NSString * identifier;

///Toy type - Nora/Max/Lush/Hush/Ambi/Osci/Edge/Domi
///Once a toy connected, it will populated with a value
@property(nonatomic,copy,readonly)NSString * toyType;

//version
@property(nonatomic,copy,readonly)NSString * version;

//MAC address
@property(nonatomic,copy,readonly)NSString * macAddress;

///Bluetooth search status
@property(nonatomic,assign,readonly)BOOL isFound;

///Toy connection status
@property(nonatomic,assign,readonly)BOOL isConnected;

///Signal strength of the Bluetooth connection
@property(nonatomic,assign,readonly)int rssi;

///Battery status
@property(nonatomic,assign,readonly)int battery;

@end

NS_ASSUME_NONNULL_END
