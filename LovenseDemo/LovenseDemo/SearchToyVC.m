//
//  ViewController.m
//  DemoSdk
//
//  Created by Lovense on 2019/3/4.
//  Copyright © 2019 Hytto. All rights reserved.
//

#import "SearchToyVC.h"
#import <Lovense/Lovense.h>
#import "ToyDetailVC.h"

#define StatusBarHeight [[UIApplication sharedApplication] statusBarFrame].size.height

@interface SearchToyVC ()<UITableViewDelegate,UITableViewDataSource, CBCentralManagerDelegate>

@property (nonatomic,strong) CBCentralManager * centralManager;
@property(nonatomic,strong) UITableView * mainTableView;
@property(nonatomic,strong) UIButton * searchBtn;
@property(nonatomic,strong) UIButton * stopSearchBtn;
@property(nonatomic,strong) UILabel * bluetoothStatusLabel;
@property(nonatomic,strong) UILabel * tipsLabel;
@property(nonatomic,strong) NSMutableArray<LovenseToy*> * allToyModelArr;

@end

@implementation SearchToyVC

-(void)viewWillAppear:(BOOL)animated
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];

    //step 3 (scanSuccess)
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(scanSuccessCallback:) name:kToyScanSuccessNotification object:nil];     //Scanning toy success notification

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(connectSuccessCallback:) name:kToyConnectSuccessNotification object:nil];     //Connected toy successfully notification

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(connectFailCallback:) name:kToyConnectFailNotification object:nil];     //Failed to connect the toy

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(connectBreakCallback:) name:kToyConnectBreakNotification object:nil];     //Toy is disconnected

    [self.mainTableView reloadData];
}


- (void)viewDidLoad
{
    [super viewDidLoad];

    self.title = @"Lovense Toy";

    //step 1 (setDeveloperToken)
    NSString * token = @"";
    if(token.length == 0)
    {
        NSLog(@"%s [Line %d] please input your token!", __PRETTY_FUNCTION__, __LINE__);
    }
    else
    {
        [[Lovense shared] setDeveloperToken:token];
    }

    self.centralManager = [[CBCentralManager alloc]initWithDelegate:self queue:dispatch_get_main_queue()];

    [self initView];
}

-(void)initView
{
    if([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)])
    {
        self.navigationController.interactivePopGestureRecognizer.enabled = NO;
    }
    self.view.backgroundColor = [UIColor groupTableViewBackgroundColor];
    [self.view addSubview:self.mainTableView];
    [self.view addSubview:self.searchBtn];
    [self.view addSubview:self.stopSearchBtn];
    [self.view addSubview:self.bluetoothStatusLabel];
    [self.view addSubview:self.tipsLabel];

    UIBarButtonItem *rightBarItem = [[UIBarButtonItem alloc] initWithTitle:@"clear" style:UIBarButtonItemStylePlain target:self action:@selector(clearAllToy)];
    self.navigationItem.rightBarButtonItem = rightBarItem;

    // Retrieve the saved toys
    self.allToyModelArr = [[[Lovense shared] listToys] mutableCopy];
    [self.mainTableView reloadData];
}

-(void)centralManagerDidUpdateState:(CBCentralManager *)central
{
    switch (central.state)
    {
        case CBCentralManagerStatePoweredOn:
            self.bluetoothStatusLabel.text = @"bluetooth: 🔵";
            break;
        default:
            self.bluetoothStatusLabel.text = @"bluetooth: ⚪️";

            for(int i = 0; i < self.allToyModelArr.count; i++)
            {
                LovenseToy * toyModel = [self.allToyModelArr objectAtIndex:i];
                UITableViewCell * cell = [self.mainTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:i inSection:0]];
                NSString * notConectStr = @"not connected ❌";

                [cell.textLabel setText:[NSString stringWithFormat:@"name:%@\nID:%@\nRSSI:%d\nstatus:%@",toyModel.name,toyModel.identifier,toyModel.rssi,notConectStr]];
            }

            break;
    }
}

-(void)onScanClick
{
    //step 2
    [[Lovense shared] searchToys];
    [self.tipsLabel setText:@"searching toy"];
}

-(void)onStopScanClick
{
    [[Lovense shared] stopSearching];
    [self.tipsLabel setText:@"stop search toy"];
}

-(void)clearAllToy
{
    NSArray * localToyArr = [[Lovense shared] listToys];
    for (LovenseToy * localToy in localToyArr)
    {
        [[Lovense shared] removeToyById:localToy.identifier];
    }

    [self.allToyModelArr removeAllObjects];
    [self.mainTableView reloadData];

    [self.tipsLabel setText:@"clear all toy"];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.allToyModelArr.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 90;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *indentifiter;
    UITableViewCell * cell;

    indentifiter = [NSString stringWithFormat:@"SearchToyCell%li",(long)indexPath.row];
    cell = [tableView dequeueReusableCellWithIdentifier:indentifiter];
    if (!cell)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                          reuseIdentifier:indentifiter];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }

    LovenseToy * toyModel = [self.allToyModelArr objectAtIndex:indexPath.row];
    cell.textLabel.numberOfLines = 0;
    NSString * isConectStr = @"not connected ❌";
    if(toyModel.isConnected) isConectStr = @"connected ✅";

    [cell.textLabel setText:[NSString stringWithFormat:@"name:%@\nID:%@\nRSSI:%d\nstatus:%@",toyModel.name,toyModel.identifier,toyModel.rssi,isConectStr]];
    cell.textLabel.font = [UIFont systemFontOfSize:14];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    LovenseToy * toyModel = [self.allToyModelArr objectAtIndex:indexPath.row];

    ToyDetailVC * detailVC = [ToyDetailVC new];
    detailVC.currentToy = toyModel;
    [self.navigationController pushViewController:detailVC animated:YES];
}


- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(editingStyle == UITableViewCellEditingStyleDelete)
    {
        LovenseToy * delToy = [self.allToyModelArr objectAtIndex:indexPath.row];
        [[Lovense shared]removeToyById:delToy.identifier];
        [self.allToyModelArr removeObject:delToy];
        [self.mainTableView reloadData];
    }
}

#pragma mark - Callback
//step 3
-(void)scanSuccessCallback:(NSNotification *)noti
{
    NSDictionary * dict = [noti object];
    NSArray * scanToyArr = [dict objectForKey:@"scanToyArray"];
    self.allToyModelArr = [scanToyArr mutableCopy];
    [self.mainTableView reloadData];

    // Save a toy to the local list
    [[Lovense shared] saveToys:self.allToyModelArr];
}

//connectSuccess
-(void)connectSuccessCallback:(NSNotification *)noti
{
    NSDictionary * dict = [noti object];
    LovenseToy * connectedToy = [dict objectForKey:@"toy"];

    for (LovenseToy * toy in self.allToyModelArr)
    {
        if([toy.identifier isEqualToString:connectedToy.identifier])
        {
            [self.allToyModelArr removeObject:toy];
            [self.allToyModelArr addObject:connectedToy];
            break;
        }
    }

    NSLog(@"%@",connectedToy);
    [self.mainTableView reloadData];
}

//Failed to connect the toy
-(void)connectFailCallback:(NSNotification *)noti
{
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
    NSDictionary * resonDict = [noti object];
    NSLog(@"%@",resonDict);
    LovenseToy * breakToy = [resonDict objectForKey:@"toy"];

    for (int i = 0; i < self.allToyModelArr.count; i++)
    {
        LovenseToy * myToy = [self.allToyModelArr objectAtIndex:i];
        if([breakToy.identifier isEqualToString:myToy.identifier])
        {
            NSString * notConnect = @"not connected ❌";
            UITableViewCell * cell = [self.mainTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:i inSection:0]];
            [cell.textLabel setText:[NSString stringWithFormat:@"name:%@\nID:%@\nRSSI:%d\nstatus:%@",myToy.name,myToy.identifier,myToy.rssi,notConnect]];
        }
    }

}


#pragma mark lazy
- (UITableView *)mainTableView
{
    if (_mainTableView == nil)
    {
        _mainTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, StatusBarHeight + 150, self.view.bounds.size.width, self.view.bounds.size.height - 150) style:UITableViewStylePlain];

        _mainTableView.backgroundColor= [UIColor whiteColor];
        _mainTableView.scrollsToTop = YES;
        _mainTableView.delegate = self;
        _mainTableView.dataSource = self;
        _mainTableView.tableFooterView = [[UIView alloc] init];
    }
    return _mainTableView;
}

-(UIButton *)searchBtn
{
    if(_searchBtn == nil)
    {
        _searchBtn = [UIButton buttonWithType:UIButtonTypeSystem];
        _searchBtn.frame = CGRectMake(20, StatusBarHeight + 100, (self.view.bounds.size.width - 60) * 0.5, 44);
        [_searchBtn setTitle:@"search" forState:UIControlStateNormal];
        _searchBtn.layer.borderColor = [[UIColor blueColor] CGColor];
        _searchBtn.layer.cornerRadius = 4;
        _searchBtn.layer.borderWidth = 1;
        _searchBtn.layer.masksToBounds = YES;
        [_searchBtn addTarget:self action:@selector(onScanClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _searchBtn;
}

-(UIButton *)stopSearchBtn
{
    if(_stopSearchBtn == nil)
    {
        CGFloat viewWidth = self.view.bounds.size.width;
        CGFloat buttonWidth = (viewWidth - 60) * 0.5;
        CGFloat buttonX = viewWidth - 20 - buttonWidth;
        
        _stopSearchBtn = [UIButton buttonWithType:UIButtonTypeSystem];
        _stopSearchBtn.frame = CGRectMake(buttonX, StatusBarHeight + 100, buttonWidth, 44);
        [_stopSearchBtn setTitle:@"stop search" forState:UIControlStateNormal];
        _stopSearchBtn.layer.borderColor = [[UIColor blueColor] CGColor];
        _stopSearchBtn.layer.cornerRadius = 4;
        _stopSearchBtn.layer.borderWidth = 1;
        _stopSearchBtn.layer.masksToBounds = YES;
        [_stopSearchBtn addTarget:self action:@selector(onStopScanClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _stopSearchBtn;
}

-(UILabel*)bluetoothStatusLabel
{
    if(!_bluetoothStatusLabel)
    {
        _bluetoothStatusLabel = [UILabel new];
        _bluetoothStatusLabel.frame = CGRectMake(20, StatusBarHeight + 60, (self.view.bounds.size.width - 40) * 0.5, 30);
    }
    return _bluetoothStatusLabel;
}


-(UILabel*)tipsLabel
{
    if(!_tipsLabel)
    {
        _tipsLabel = [UILabel new];
        _tipsLabel.frame = CGRectMake(self.view.bounds.size.width * 0.5 + 20, StatusBarHeight + 60, (self.view.bounds.size.width - 40) * 0.55, 30);
    }
    return _tipsLabel;
}

-(NSMutableArray<LovenseToy*>*)allToyModelArr
{
    if(!_allToyModelArr)
    {
        _allToyModelArr = [NSMutableArray array];
    }
    return _allToyModelArr;
}


@end
