//
//  ToyDetailCell.m
//  DemoSdk
//
//  Created by Lovense on 2019/3/4.
//  Copyright © 2019 Hytto. All rights reserved.
//

#import "ToyDetailCell.h"
#define ScreenWidth [[UIScreen mainScreen] bounds].size.width
#define ScreenHeight [[UIScreen mainScreen] bounds].size.heigh

@interface ToyDetailCell()

@end

@implementation ToyDetailCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {

    }
    return self;
}

-(void)setSliderName:(NSString *)sliderName
{
    if(!_slider)
    {
        self.textLabel.numberOfLines = 0;
        self.textLabel.font = [UIFont systemFontOfSize:14];
        self.textLabel.textAlignment = NSTextAlignmentCenter;
        [self.textLabel setText:sliderName];
        _slider = [[UISlider alloc]initWithFrame:CGRectMake(15 , 40, ScreenWidth-30, 50)];
        _slider.minimumValue = 0;
        _slider.maximumValue = 20;
        _slider.value = 0;
        _slider.continuous = NO;
        _slider.thumbTintColor = [UIColor blueColor];
        [_slider addTarget:self action:@selector(sliderChange:) forControlEvents:UIControlEventValueChanged];

        [self.contentView addSubview:_slider];
    }
    else
    {
        [self.textLabel setText:sliderName];
    }
}

-(void)setSliderName:(NSString *)sliderName andMinValue:(NSInteger)minValue andMaxValue:(NSInteger)maxValue
{
    if(!_slider)
    {
        self.textLabel.numberOfLines = 0;
        self.textLabel.font = [UIFont systemFontOfSize:14];
        self.textLabel.textAlignment = NSTextAlignmentCenter;
        [self.textLabel setText:sliderName];
        _slider = [[UISlider alloc]initWithFrame:CGRectMake(15 , 40, ScreenWidth-30, 50)];
        _slider.minimumValue = minValue;
        _slider.maximumValue = maxValue;
        _slider.value = 0;
        _slider.continuous = NO;
        _slider.thumbTintColor = [UIColor blueColor];
        [_slider addTarget:self action:@selector(sliderChange:) forControlEvents:UIControlEventValueChanged];

        UILabel * minLabel = [[UILabel alloc] initWithFrame:CGRectMake(30, 20, 50, 20)];
        minLabel.font = [UIFont systemFontOfSize:12];
        minLabel.text = [NSString stringWithFormat:@"%li",(long)minValue];
        [self.contentView addSubview:minLabel];

        UILabel * maxLabel = [[UILabel alloc] initWithFrame:CGRectMake(ScreenWidth - 30, 20, 30, 20)];
        maxLabel.font = [UIFont systemFontOfSize:12];
        maxLabel.text = [NSString stringWithFormat:@"%li",(long)maxValue];
        [self.contentView addSubview:maxLabel];

        [self.contentView addSubview:_slider];
    }
    else
    {
        [self.textLabel setText:sliderName];
    }
}


-(void)setBtnName:(NSString *)btnName
{
    if(!_btn)
    {
        _btn = [UIButton buttonWithType:UIButtonTypeSystem];
        [_btn setTitle:btnName forState:UIControlStateNormal];
        _btn.frame = CGRectMake(0, 10, ScreenWidth, 50);
        [_btn addTarget:self action:@selector(btnClick) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:_btn];
    }
    else
    {
        [_btn setTitle:btnName forState:UIControlStateNormal];
    }
}

-(UITextField*)inputTextField
{
    if(!_inputTextField)
    {
        _inputTextField = [[UITextField alloc] initWithFrame:CGRectMake(5, 10, ScreenWidth-10, 30)];
        _inputTextField.borderStyle = UITextBorderStyleLine;
        _inputTextField.layer.borderWidth = 1;
        _inputTextField.layer.borderColor = [UIColor blackColor].CGColor;
        [self.contentView addSubview:_inputTextField];
    }
    return _inputTextField;
}

-(void)sliderChange:(UISlider*)slider
{
    if(self.sliderChangeBlock)
        self.sliderChangeBlock(slider.value);
}

-(void)btnClick
{
    if(self.btnClickBlock)
        self.btnClickBlock();
}

@end
