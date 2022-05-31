//
//  ToyDetailCell.h
//  DemoSdk
//
//  Created by Lovense on 2019/3/4.
//  Copyright © 2019 Hytto. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ToyDetailCell : UITableViewCell

@property (nonatomic, strong) UISlider * slider;
@property (nonatomic, strong) UIButton * btn;
@property (nonatomic, strong) UITextField * inputTextField;;

@property (nonatomic, copy) void (^sliderChangeBlock)(int value);
@property (nonatomic, copy) void (^btnClickBlock)(void);

-(void)setSliderName:(NSString *)sliderName;
-(void)setSliderName:(NSString *)sliderName andMinValue:(NSInteger)minValue andMaxValue:(NSInteger)maxValue;

-(void)setBtnName:(NSString *)btnName;


@end

