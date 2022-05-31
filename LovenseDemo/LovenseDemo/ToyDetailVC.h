//
//  ToyDetailVC.h
//  DemoSdk
//
//  Created by Lovense on 2019/3/4.
//  Copyright © 2019 Hytto. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Lovense/Lovense.h>

NS_ASSUME_NONNULL_BEGIN

@interface ToyDetailVC : UIViewController

@property(nonatomic,strong)LovenseToy * currentToy;

@end

NS_ASSUME_NONNULL_END
