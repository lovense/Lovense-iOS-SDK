//
//  ToyDetailVC.m
//  DemoSdk
//
//  Created by Lovense on 2019/3/4.
//  Copyright © 2019 Hytto. All rights reserved.
//

#import "ToyDetailVC.h"
#import "ToyDetailCell.h"
#import "ToyDetailHeaderView.h"
#define ScreenWidth [[UIScreen mainScreen] bounds].size.width
#define ScreenHeight [[UIScreen mainScreen] bounds].size.height

@interface ToyDetailVC ()<UITableViewDelegate,UITableViewDataSource>

@property(nonatomic,strong) UITableView * mainTableView;
@property (nonatomic, strong) UIActivityIndicatorView * activityIndicator;
@property(nonatomic,strong) ToyDetailHeaderView * tableHeaderView;
@property(nonatomic,assign) BOOL isLightOn;   //light indicator (e.g. Lush/Hush/Edge)
@property(nonatomic,assign) BOOL isAidLightOn;   //AID light indicator (e.g. Domi)
@property (nonatomic, strong) NSTimer * getBatteryTimer;        //get battery timer

@end

@implementation ToyDetailVC

-(void)viewWillDisappear:(BOOL)animated
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];

    [self.getBatteryTimer invalidate];
    self.getBatteryTimer = nil;
}


- (void)viewDidLoad {
    [super viewDidLoad];

    //get battery timer
    self.getBatteryTimer = [NSTimer timerWithTimeInterval:5 target:self selector:@selector(getBatteryHandler) userInfo:nil repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:self.getBatteryTimer forMode:NSRunLoopCommonModes];

    self.title = [NSString stringWithFormat:@"%@Toy Control",self.currentToy.name];
    [self addNotification];
    [self initAll];
}

- (void)addNotification
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(connectSuccessCallback:) name:kToyConnectSuccessNotification object:nil];     //Toy connected

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(connectFailCallback:) name:kToyConnectFailNotification object:nil];     //Failed to connect the toy

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(connectBreakCallback:) name:kToyConnectBreakNotification object:nil];     //Toy is disconnected

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(commandSuccessCallback:) name:kToyCommandCallbackNotificationAtSuccess object:nil];     //Command sent successfully

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(commandErrorCallback:) name:kToyCommandCallbackNotificationAtError object:nil];     //Failed to send command

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(deviceTypeCallback:) name:kToyCallbackNotificationDeviceType object:nil];     //device information

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(lightStatusCallback:) name:kToyCallbackNotificationGetLightStatus object:nil];    //light indication

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(aidLightStatusCallback:) name:kToyCallbackNotificationGetAidLightStatus object:nil];  //AID light indication

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(listenMove:) name:kToyCallbackNotificationListenMove object:nil];  //Start tracking the toy movement (usually used in 2 way interactions)


}


-(void)getBatteryHandler
{
    [self.tableHeaderView setBatteryContent:[NSString stringWithFormat:@"Battery:%i%%",self.currentToy.battery]];
}

-(void)initAll
{
    self.view.backgroundColor = [UIColor whiteColor];

    [self.view addSubview:self.mainTableView];

    self.activityIndicator = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:(UIActivityIndicatorViewStyleWhiteLarge)];
    self.activityIndicator.frame= CGRectMake(0, 0, ScreenWidth, ScreenHeight);
    self.activityIndicator.backgroundColor = [UIColor blackColor];
    self.activityIndicator.alpha = 0.2;
    self.activityIndicator.hidesWhenStopped = YES;
    [self.view addSubview:self.activityIndicator];

    UIBarButtonItem *rightBarItem = [[UIBarButtonItem alloc] initWithTitle:@"Disconnect" style:UIBarButtonItemStylePlain target:self action:@selector(onBreakClick)];
    self.navigationItem.rightBarButtonItem = rightBarItem;

    if(self.currentToy.isConnected == true)
    {
        [self.tableHeaderView setBatteryContent:[NSString stringWithFormat:@"Battery:%i%%",self.currentToy.battery]];
        if(self.currentToy.macAddress)
            [self.tableHeaderView setMacContent:[NSString stringWithFormat:@"MAC Address:%@",self.currentToy.macAddress]];
        if(self.currentToy.toyType)
            [self.tableHeaderView setTypeContent:[NSString stringWithFormat:@"Device Type:%@",self.currentToy.toyType]];
        if(self.currentToy.version)
            [self.tableHeaderView setVersionContent:[NSString stringWithFormat:@"Version:%@",self.currentToy.version]];
    }
    else
    {
        //Connect a toy
        //step 4
        [[Lovense shared] connectToy:self.currentToy.identifier];

        [self.activityIndicator startAnimating];
    }
}

-(void)onBreakClick
{
    [[Lovense shared] disconnectToy:self.currentToy.identifier];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 7;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 60;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    switch (section)
    {
        case 0:
            return 3;   //all
        case 1:
            return 4;   //Nora
        case 2:
            return 2;   //Edge
        case 3:
            return 3;   //Domi
        case 4:
            return 2;   //Lush Hush Edge
        case 5:
            return 2;   //Nora Max
        case 6:
            return 3;    //Max

    }
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section == 6 && indexPath.row == 4)   //Ambi, Domi, Osci
        return 120;
    else
        return 90;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *headerView = [[UIView alloc]init];
    headerView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    UILabel *label = [[UILabel alloc]init];
    label.textColor = [UIColor blackColor];
    label.font = [UIFont systemFontOfSize:18];
    label.frame = CGRectMake(15, 15, self.view.bounds.size.width, 20);
    [headerView addSubview:label];

    switch (section)
    {
        case 0:
            label.text = @"All Toy Command";
            break;
        case 1:
            label.text = @"Nora";
            break;
        case 2:
            label.text = @"Edge";
            break;
        case 3:
            label.text = @"Domi";
            break;
        case 4:
            label.text = @"Lush Hush Edge";
            break;
        case 5:
            label.text = @"Nora Max";
            break;
        case 6:
            label.text = @"Max";
            break;


        default:
            break;
    }
    return headerView;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    __weak typeof(self) weakSelf = self;

    static NSString *indentifiter;
    ToyDetailCell * cell;

    indentifiter = [NSString stringWithFormat:@"ToyDetailCell%li_%li",(long)indexPath.section,(long)indexPath.row];
    cell = [tableView dequeueReusableCellWithIdentifier:indentifiter];
    if (!cell)
    {
        cell = [[ToyDetailCell alloc] initWithStyle:UITableViewCellStyleDefault
                                      reuseIdentifier:indentifiter];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }

    if(indexPath.section == 0 && indexPath.row == 0)
    {
        cell.sliderName = @"Vibration";
        [cell setSliderChangeBlock:^(int value) {
            NSMutableDictionary * paramDict = [NSMutableDictionary dictionary];
            [paramDict setObject:@(value) forKey:kSendCommandParamKey_VibrateLevel];
            //step 5
            [[Lovense shared] sendCommandWithToyId:weakSelf.currentToy.identifier andCommandType:COMMAND_VIBRATE andParamDict:paramDict];
        }];
    }

    else if(indexPath.section == 0 && indexPath.row == 1)
    {
        [cell setBtnName:@"Quick Flash"];
        [cell setBtnClickBlock:^{
            [[Lovense shared] sendCommandWithToyId:weakSelf.currentToy.identifier andCommandType:COMMAND_FLASH andParamDict:nil ];
        }];
    }
    
    else if(indexPath.section == 0 && indexPath.row == 2)
    {
        [cell setSliderName:@"Preset" andMinValue:0 andMaxValue:10];
        [cell setSliderChangeBlock:^(int value) {
            NSMutableDictionary * paramDict = [NSMutableDictionary dictionary];
            [paramDict setObject:@(value) forKey:kSendCommandParamKey_PresetLevel];

            [[Lovense shared] sendCommandWithToyId:weakSelf.currentToy.identifier andCommandType:COMMAND_PRESET andParamDict:paramDict];
        }];
    }

    else if(indexPath.section == 1 && indexPath.row == 0)
    {
        cell.sliderName = @"Nora Rotation";
        [cell setSliderChangeBlock:^(int value) {
            NSMutableDictionary * paramDict = [NSMutableDictionary dictionary];
            [paramDict setObject:@(value) forKey:kSendCommandParamKey_RotateLevel];

            [[Lovense shared] sendCommandWithToyId:weakSelf.currentToy.identifier andCommandType:COMMAND_ROTATE andParamDict:paramDict ];
        }];
    }

    else if(indexPath.section == 1 && indexPath.row == 1)
    {
        cell.sliderName = @"Nora Rotation";
        [cell setSliderChangeBlock:^(int value) {
            NSMutableDictionary * paramDict = [NSMutableDictionary dictionary];
            [paramDict setObject:@(value) forKey:kSendCommandParamKey_RotateLevel];

            [[Lovense shared] sendCommandWithToyId:weakSelf.currentToy.identifier andCommandType:COMMAND_ROTATE_CLOCKWISE andParamDict:paramDict ];
        }];
    }

    else if(indexPath.section == 1 && indexPath.row == 2)
    {
        cell.sliderName = @"Nora Rotation(Anti-clockwise)";
        [cell setSliderChangeBlock:^(int value) {
            NSMutableDictionary * paramDict = [NSMutableDictionary dictionary];
            [paramDict setObject:@(value) forKey:kSendCommandParamKey_RotateLevel];

            [[Lovense shared] sendCommandWithToyId:weakSelf.currentToy.identifier andCommandType:COMMAND_ROTATE_ANTI_CLOCKWISE andParamDict:paramDict];
        }];
    }

    else if(indexPath.section == 1 && indexPath.row == 3)
    {
        [cell setBtnName:@"Nora Rotation Change"];
        [cell setBtnClickBlock:^{
            [[Lovense shared] sendCommandWithToyId:weakSelf.currentToy.identifier andCommandType:COMMAND_ROTATE_CHANGE andParamDict:nil];
        }];
    }
    else if(indexPath.section == 2 && indexPath.row == 0)
    {
        cell.sliderName = @"Edge Vibrator 1";
        [cell setSliderChangeBlock:^(int value) {
            NSMutableDictionary * paramDict = [NSMutableDictionary dictionary];
            [paramDict setObject:@(value) forKey:kSendCommandParamKey_VibrateLevel];

            [[Lovense shared] sendCommandWithToyId:weakSelf.currentToy.identifier andCommandType:COMMAND_VIBRATE1 andParamDict:paramDict ];
        }];
    }

    else if(indexPath.section == 2 && indexPath.row == 1)
    {
        cell.sliderName = @"Edge Vibrator 2";
        [cell setSliderChangeBlock:^(int value) {
            NSMutableDictionary * paramDict = [NSMutableDictionary dictionary];
            [paramDict setObject:@(value) forKey:kSendCommandParamKey_VibrateLevel];

            [[Lovense shared] sendCommandWithToyId:weakSelf.currentToy.identifier andCommandType:COMMAND_VIBRATE2 andParamDict:paramDict ];
        }];
    }

    else if(indexPath.section == 3 && indexPath.row == 0)   //domi
    {
        [cell setBtnName:@"Turn off AID Light"];
        [cell setBtnClickBlock:^{
            [[Lovense shared] sendCommandWithToyId:weakSelf.currentToy.identifier andCommandType:COMMAND_ALIGHT_OFF andParamDict:nil ];
        }];
    }

    else if(indexPath.section == 3 && indexPath.row == 1)   //domi
    {
        [cell setBtnName:@"Turn on AID Light"];
        [cell setBtnClickBlock:^{
            [[Lovense shared] sendCommandWithToyId:weakSelf.currentToy.identifier andCommandType:COMMAND_ALIGHT_ON andParamDict:nil ];
        }];
    }

    else if(indexPath.section == 3 && indexPath.row == 2)   //domi
    {
        [cell setBtnName:[NSString stringWithFormat:@"Get AID Light Status=%i",self.isAidLightOn]];
        [cell setBtnClickBlock:^{
            [[Lovense shared] sendCommandWithToyId:weakSelf.currentToy.identifier andCommandType:COMMAND_GET_ALIGHT_STATUS andParamDict:nil ];
        }];
    }

    else if(indexPath.section == 4 && indexPath.row == 0)   // Lush  hush  edge
    {
        [cell setBtnName:@"Turn off Light"];
        [cell setBtnClickBlock:^{
            [[Lovense shared] sendCommandWithToyId:weakSelf.currentToy.identifier andCommandType:COMMAND_LIGHT_OFF andParamDict:nil];
        }];
    }

    else if(indexPath.section == 4 && indexPath.row == 1)   // Lush  hush  edge
    {
        [cell setBtnName:@"Turn on Light"];
        [cell setBtnClickBlock:^{
            [[Lovense shared] sendCommandWithToyId:weakSelf.currentToy.identifier andCommandType:COMMAND_LIGHT_ON andParamDict:nil];
        }];
    }
    else if(indexPath.section == 5 && indexPath.row == 0)   //Nora Max
    {
        [cell setBtnName:[NSString stringWithFormat:@"Start tracking movement"]];
        [cell setBtnClickBlock:^{
            [[Lovense shared] sendCommandWithToyId:weakSelf.currentToy.identifier andCommandType:COMMAND_START_MOVE andParamDict:nil ];
        }];
    }
    else if(indexPath.section == 5 && indexPath.row == 1)   //Nora Max
    {
        [cell setBtnName:[NSString stringWithFormat:@"Stop tracking movement"]];
        [cell setBtnClickBlock:^{
            [[Lovense shared] sendCommandWithToyId:weakSelf.currentToy.identifier andCommandType:COMMAND_STOP_MOVE andParamDict:nil];
        }];
    }
    else if(indexPath.section == 6 && indexPath.row == 0)       //Max
    {
        [cell setSliderName:@"Max Air In" andMinValue:1 andMaxValue:3];
        [cell setSliderChangeBlock:^(int value) {
            NSMutableDictionary * paramDict = [NSMutableDictionary dictionary];
            [paramDict setObject:@(value) forKey:kSendCommandParamKey_AirLevel];

            [[Lovense shared] sendCommandWithToyId:weakSelf.currentToy.identifier andCommandType:COMMAND_AIR_IN andParamDict:paramDict];
        }];
    }

    else if(indexPath.section == 6 && indexPath.row == 1)
    {
        [cell setSliderName:@"Max Air Out" andMinValue:1 andMaxValue:3];

        [cell setSliderChangeBlock:^(int value) {
            NSMutableDictionary * paramDict = [NSMutableDictionary dictionary];
            [paramDict setObject:@(value) forKey:kSendCommandParamKey_AirLevel];

            [[Lovense shared] sendCommandWithToyId:weakSelf.currentToy.identifier andCommandType:COMMAND_AIR_OUT andParamDict:paramDict];
        }];
    }

    else if(indexPath.section == 6 && indexPath.row == 2)
    {
        [cell setSliderName:@"Max Air Auto" andMinValue:0 andMaxValue:3];

        [cell setSliderChangeBlock:^(int value) {
            NSMutableDictionary * paramDict = [NSMutableDictionary dictionary];
            [paramDict setObject:@(value) forKey:kSendCommandParamKey_AirAutoLevel];

            [[Lovense shared] sendCommandWithToyId:weakSelf.currentToy.identifier andCommandType:COMMAND_AIR_AUTO andParamDict:paramDict];
        }];
    }


    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.view endEditing:YES];
}

#pragma mark - Callbacks
///Toy Connected
-(void)connectSuccessCallback:(NSNotification *)noti
{
    [self.activityIndicator stopAnimating];

     //Once connected, retrive the battery status
    NSDictionary * connectedSuccessDict = [noti object];
    LovenseToy * connectedToy = [connectedSuccessDict objectForKey:@"toy"];
    if([connectedToy.identifier isEqualToString:self.currentToy.identifier])
    {
        self.currentToy = connectedToy;
        if(self.currentToy.isConnected == true)
        {
            [self.tableHeaderView setBatteryContent:[NSString stringWithFormat:@"Battery:%i%%",self.currentToy.battery]];

            if(self.currentToy.macAddress)
                [self.tableHeaderView setMacContent:[NSString stringWithFormat:@"MAC Address:%@",self.currentToy.macAddress]];
            if(self.currentToy.toyType)
                [self.tableHeaderView setTypeContent:[NSString stringWithFormat:@"Device Type:%@",self.currentToy.toyType]];
            if(self.currentToy.version)
                [self.tableHeaderView setVersionContent:[NSString stringWithFormat:@"Version:%@",self.currentToy.version]];
        }
    }
}

//Failed to connect the toy
-(void)connectFailCallback:(NSNotification *)noti
{
    [self.activityIndicator stopAnimating];

    NSDictionary * resonDict = [noti object];
    NSLog(@"%@",resonDict);
    UIAlertController *alertVc = [UIAlertController alertControllerWithTitle:nil message:[NSString stringWithFormat:@"connect fail=%@",resonDict.description] preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancelBtn = [UIAlertAction actionWithTitle:@"ok" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
    }];
    [alertVc addAction:cancelBtn];
    [self presentViewController:alertVc animated:YES completion:nil];
}

//Toy is disconnected
-(void)connectBreakCallback:(NSNotification *)noti
{
    [self.activityIndicator stopAnimating];

    NSDictionary * resonDict = [noti object];
    NSLog(@"%@",resonDict);
    UIAlertController *alertVc = [UIAlertController alertControllerWithTitle:nil message:[NSString stringWithFormat:@"Toy is  disconnected=%@",resonDict.description] preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancelBtn = [UIAlertAction actionWithTitle:@"ok" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
    }];
    [alertVc addAction:cancelBtn];
    [self presentViewController:alertVc animated:YES completion:nil];
}

//Command sent success
-(void)commandSuccessCallback:(NSNotification *)noti
{
    NSDictionary * callbackDict = [noti object];
    NSLog(@"callbackDict==%@",callbackDict);
}

//Failed to send command
-(void)commandErrorCallback:(NSNotification *)noti
{
    NSDictionary * callbackDict = [noti object];
    NSLog(@"callbackDict==%@",callbackDict);
}

//Device information
-(void)deviceTypeCallback:(NSNotification *)noti
{
    NSDictionary * callbackDict = [noti object];
    NSLog(@"callbackDict==%@",callbackDict);
    LovenseToy * receiveToy = [callbackDict objectForKey:@"receiveToy"];
    if(self.currentToy == receiveToy)
    {
        [self.tableHeaderView setMacContent:[NSString stringWithFormat:@"MAC Address:%@",self.currentToy.macAddress]];
        [self.tableHeaderView setTypeContent:[NSString stringWithFormat:@"Device Info:%@",self.currentToy.toyType]];
        [self.tableHeaderView setVersionContent:[NSString stringWithFormat:@"Version:%@",self.currentToy.version]];
    }
}

//Light indicator
-(void)lightStatusCallback:(NSNotification *)noti
{
    NSDictionary * callbackDict = [noti object];
    self.isLightOn = [[callbackDict objectForKey:@"isOpen"] boolValue];
    [self.mainTableView reloadData];
}

//AID Light Indicator
-(void)aidLightStatusCallback:(NSNotification *)noti
{
    NSDictionary * callbackDict = [noti object];
    self.isAidLightOn = [[callbackDict objectForKey:@"isOpen"] boolValue];
    [self.mainTableView reloadData];
}

//Start tracking movement
-(void)listenMove:(NSNotification *)noti
{
    NSDictionary * dict = [noti object];
    NSString * level = [dict objectForKey:@"moveLevel"];
    [self.tableHeaderView setMoveLevel:[NSString stringWithFormat:@"Movement:%@",level]];
}


#pragma mark lazy
- (UITableView *)mainTableView
{
    if (_mainTableView == nil)
    {
        _mainTableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];

        _mainTableView.backgroundColor= [UIColor whiteColor];
        _mainTableView.scrollsToTop = YES;
        _mainTableView.delegate = self;
        _mainTableView.dataSource = self;
        _mainTableView.tableFooterView = [[UIView alloc] init];
        _mainTableView.tableHeaderView = self.tableHeaderView;
    }
    return _mainTableView;
}

-(UIView*)tableHeaderView
{
    if(_tableHeaderView == nil)
    {
        _tableHeaderView = [[ToyDetailHeaderView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 180)];
    }
    return _tableHeaderView;
}

- (void)dealloc
{
    NSLog(@"----dealloc-----");
}

@end
