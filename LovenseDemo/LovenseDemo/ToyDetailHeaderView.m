//
//  ToyDetailHeaderView.m
//  DemoSdk
//
//  Created by Lovense on 2019/3/4.
//  Copyright © 2019 Hytto. All rights reserved..
//

#import "ToyDetailHeaderView.h"

@interface ToyDetailHeaderView()

@property(nonatomic,strong)UILabel * typeLabel;
@property(nonatomic,strong)UILabel * macLabel;
@property(nonatomic,strong)UILabel * versionLabel;
@property(nonatomic,strong)UILabel * batteryLabel;
@property(nonatomic,strong)UILabel * moveLevelLabel;

@end

@implementation ToyDetailHeaderView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        self.backgroundColor = [UIColor whiteColor];
        self.typeLabel = [[UILabel alloc]init];
        self.typeLabel.textColor = [UIColor blackColor];
        self.typeLabel.font = [UIFont systemFontOfSize:16];
        self.typeLabel.frame = CGRectMake(15, 10, 300, 20);
        [self addSubview:self.typeLabel];

        self.macLabel = [[UILabel alloc]init];
        self.macLabel.textColor = [UIColor blackColor];
        self.macLabel.font = [UIFont systemFontOfSize:16];
        self.macLabel.frame = CGRectMake(15, 40, 300, 20);
        [self addSubview:self.macLabel];

        self.versionLabel = [[UILabel alloc]init];
        self.versionLabel.textColor = [UIColor blackColor];
        self.versionLabel.font = [UIFont systemFontOfSize:16];
        self.versionLabel.frame = CGRectMake(15, 70, 300, 20);
        [self addSubview:self.versionLabel];

        self.batteryLabel = [[UILabel alloc]init];
        self.batteryLabel.textColor = [UIColor blackColor];
        self.batteryLabel.font = [UIFont systemFontOfSize:16];
        self.batteryLabel.frame = CGRectMake(15, 100, 300, 20);
        [self addSubview:self.batteryLabel];

        self.moveLevelLabel = [[UILabel alloc]init];
        self.moveLevelLabel.textColor = [UIColor blackColor];
        self.moveLevelLabel.font = [UIFont systemFontOfSize:16];
        self.moveLevelLabel.frame = CGRectMake(15, 130, 300, 20);
        [self addSubview:self.moveLevelLabel];
    }
    return self;
}


-(void)setTypeContent:(NSString*)typeStr
{
    [self.typeLabel setText:typeStr];
}

-(void)setMacContent:(NSString*)macStr
{
    [self.macLabel setText:macStr];
}

-(void)setBatteryContent:(NSString*)batteryStr
{
    [self.batteryLabel setText:batteryStr];
}

-(void)setVersionContent:(NSString*)versionStr
{
    [self.versionLabel setText:versionStr];
}

-(void)setMoveLevel:(NSString*)moveLevel
{
    [self.moveLevelLabel setText:moveLevel];
}


@end
