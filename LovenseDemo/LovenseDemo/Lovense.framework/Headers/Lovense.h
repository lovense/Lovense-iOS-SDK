//
//  Lovense.h
//  Lovense
//
//  Created by Lovense on 2019/3/4.
//  Copyright © 2019 Hytto. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LovenseToy.h"
#import "LovenseDefine.h"

@interface Lovense : NSObject

+ (Lovense * _Nonnull)shared;

/**
 Pass your token into Lovense framework
 */
- (void)setDeveloperToken:(NSString * _Nonnull)token;

/**
 Search for Lovense toys
 */
- (void)searchToys;

/**
 Stop searching
 */
- (void)stopSearching;

/**
 Remove a toy from the saved list

 @param toyId toy's ID
 */
- (void)removeToyById:(NSString * _Nonnull)toyId;

/**
 Connect a toy

 @param toyId toy ID
 */
- (void)connectToy:(NSString * _Nonnull)toyId;

/**
 Disconnect a toy

 @param toyId toy ID
 */
- (void)disconnectToy:(NSString * _Nonnull)toyId;

/**
 Save a toy to the local list

 */
-(void)saveToys:(NSArray<LovenseToy *>* _Nonnull)toys;

/**
 Retrieve the saved toy list
 */
-(NSArray<LovenseToy *>* _Nullable)listToys;

/**
 Send a command to the toy

 @param toyId toy ID
 @param commandType command
 @param paramDict command parameters
 */
- (void)sendCommandWithToyId:(NSString * _Nonnull)toyId andCommandType:(LovenseCommandType)commandType andParamDict:(NSDictionary* _Nullable)paramDict;


@end

