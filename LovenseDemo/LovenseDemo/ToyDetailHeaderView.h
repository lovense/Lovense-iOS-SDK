//
//  ToyDetailHeaderView.h
//  DemoSdk
//
//  Created by Lovense on 2019/3/4.
//  Copyright © 2019 Hytto. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ToyDetailHeaderView : UIView

-(void)setTypeContent:(NSString*)typeStr;

-(void)setMacContent:(NSString*)macStr;

-(void)setBatteryContent:(NSString*)batteryStr;

-(void)setVersionContent:(NSString*)versionStr;

-(void)setMoveLevel:(NSString*)moveLevel;
@end

NS_ASSUME_NONNULL_END
