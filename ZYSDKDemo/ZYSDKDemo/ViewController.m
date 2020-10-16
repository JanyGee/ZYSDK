//
//  ViewController.m
//  OctopusIntegrateSDK
//
//  Created by Petry on 16/6/15.
//  Copyright © 2016年 Octopus. All rights reserved.
//

#import "ViewController.h"
#import "OctopusSDK.h"

@interface ViewController()<ZYGameLoginDelegate,ZYGameLogoutDelegate,ZYGamePayDelegate,ZYGameSwitchDelegate,ZYGameAntiAddictionDelegate,ZYGameInitDelegate>
{
    NSMutableArray *allBtns;
    UILabel *userIdLabel;
    UILabel *moneyLabel;
    NSString *lastOrderId;
}
@property (nonatomic, copy)NSDictionary *resultDict;
@end

@implementation ViewController

__strong static ViewController *singleton = nil;

+ (ViewController *)shareInstance
{
    static dispatch_once_t pred = 0;
    dispatch_once(&pred, ^{
        singleton = [[super allocWithZone:NULL] init];
    });
    return singleton;
}
+ (instancetype)allocWithZone:(struct _NSZone *)zone
{
    return [self shareInstance];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //初始化界面
    [self initAllSubViews];
    lastOrderId = @"";
    
}

#pragma mark - ***LDPay所有API调用如下***
//初始化sdk的必要的代理对象
- (void)initSDKDelegate{
    
    [OctopusSDK addLoginDelegate:self logoutDelegate:self];
    
    //设置切换账号的代理  sdk切换账号后能接收到回调方法doSwitch 这里面进行游戏角色账号的注销操作等
    [OctopusSDK switchListener:self];
    
    //设置防沉迷代理
    [OctopusSDK addAntiAddictionDelegate:self];
    
    //初始化SDK代理
    [OctopusSDK initGame:self];
}

//初始化渠道SDK
- (void)initLDMobile{
    
    //设置回调代理对象为nil
    [OctopusSDK initSDK];
    
}

//登录
- (void)startLDMobileLogin{
    
    [OctopusSDK login:@"loginInfo"];
}

//切换用户
- (void)changeLDMobileAccount{
    
    //1.游戏客户端注销自己
    
    //2.呼出登录界面
    [OctopusSDK switchAccount:self];
}

//注销
- (void)startLDMobilelogout{
    
    [OctopusSDK logout:self];
}

//是否登录
- (void)isLDMobileLogin{
    
}

//打印日志
- (void)debugEnable{
    [OctopusSDK setHoverButtonVisible:NO];
}

//用户信息
- (void)submitEntergame{
    
    NSString *userId = [NSString stringWithFormat:@"%@",_resultDict[@"userId"]];
    userIdLabel.text = userId;
    moneyLabel.text = @"100";
    //模拟游戏登陆成功 进入游戏提交信息到服务器
    NSMutableDictionary *roleDict = [NSMutableDictionary dictionary];
    [roleDict setValue:@"旋风小子" forKey:@"ZYSDKRoleName"];
    [roleDict setValue:@"66" forKey:@"ZYSDKRoleLevel"];
    [roleDict setValue:@"1006" forKey:@"ZYSDKRoleZoneId"];
    [roleDict setValue:@"123456" forKey:@"ZYSDKRoleId"];
    [roleDict setValue:@"3" forKey:@"ZYSDKVipLevel"];
    [roleDict setValue:@"1006" forKey:@"ZYSDKThirdGameZoneId"];
    [roleDict setValue:@"无懈可击一服" forKey:@"ZYSDKThirdGameZoneName"];
    [roleDict setValue:@"流沙城" forKey:@"ZYSDKGuildName"];
    [roleDict setValue:@"1" forKey:@"ZYSDKSubmitType"];
    [OctopusSDK submitEntergame:roleDict];
    
}

//支付1.00元
- (void)pay{
    
    //模拟下单
    NSDateFormatter *dateFormater = [[NSDateFormatter alloc] init];
    [dateFormater setDateFormat:@"yyyyMMddHHmmssfff"];
    NSString *orderId = [dateFormater stringFromDate:[NSDate date]];
    
    NSMutableDictionary *orderDict = [NSMutableDictionary dictionary];
    [orderDict setValue:orderId forKey:@"ZYSDKOrderId"];            //必要参数
    [orderDict setValue:@"1175" forKey:@"ZYSDKProductId"];          //必要参数
    [orderDict setValue:@"6.00" forKey:@"ZYSDKMoney"];              //必要参数
    [orderDict setValue:@"60钻石" forKey:@"ZYSDKProductName"];       //必要参数
    [orderDict setValue:@"商品详情" forKey:@"ZYSDKProductDesc"];
    [orderDict setValue:@"http//baidu.com" forKey:@"ZYSDKoExInfo"];
    [orderDict setValue:@"1000" forKey:@"ZYSDKServerId"];           //必要参数
    [orderDict setValue:@"3234" forKey:@"ZYSDKRoleId"];             //必要参数
    [orderDict setValue:@"自定义用户所在服务器名称" forKey:@"ZYSDKServerName"];
    [orderDict setValue:@"1" forKey:@"ZYSDKCount"];                 //购买数量 默认1
    [orderDict setValue:@"测试应用" forKey:@"ZYSDKGameName"];
    [orderDict setValue:@"Jany" forKey:@"ZYSDKRoleName"];            //角色名字
    [orderDict setValue:@"100" forKey:@"ZYSDKRoleLevel"];            //角色等级
    [orderDict setValue:@"http://140.143.79.107:9123/pgame/background_api/?command=recharge&sdk_type=2" forKey:@"ZYSDKNotifyUrl"];//订单回调地址
    
    [OctopusSDK shopping:orderDict payDelegate:self];
    
}

//个人中心
- (void)presentUserCenter{
    
    [OctopusSDK goUserCenter];
}

//检查更新
- (void)checkNewVersion{
    
    [OctopusSDK setHoverButtonVisible:YES];
    
}

#pragma mark -***ZYGameInitDelegate
- (void)initSuccess{
    [self showAlertView:@"初始化成功" message:nil cancelBtn:@"确定"];
}

- (void)initFail{
    
    [self showAlertView:@"初始化失败" message:nil cancelBtn:@"确定"];
}

#pragma mark - ***ZYGameLoginDelegate***
- (void)loginSuccess:(NSDictionary *)result{
    
    //    NSLog(@"%@",result);
    _resultDict = result;
    [self showAlertView:@"渠道SDK账号登陆成功" message:nil cancelBtn:@"确定"];
    /*result:
     advChannel:渠道号
     channelName:渠道名称
     subChannel:子渠道
     appId:appId
     sdkVersion:sdk版本
     operatorOs:操作系统
     deviceNo:设备号(IDFV)
     device:设备号(IDFA)
     thirdId:thirdAppId
     userId:用户Id
     token:token
     extension:扩展字段
     */
    //从服务器拿到信息 交给游戏客户端进行登录验证
    
    
}

- (void)loginFail
{
    NSLog(@"登录验证失败");
}

#pragma mark - ***ZYGameLogoutDelegate***
- (void)logoutSuccess{
    
    //此处要做您的用户登出操作
    userIdLabel.text = @"已退出";
    moneyLabel.text = @"0";
}

- (void)logoutFail:(NSString *)reason{
    
    [self showAlertView:reason message:nil cancelBtn:@"确定"];
}

- (void)logoutCancel{
    
    [self showAlertView:@"取消退出" message:nil cancelBtn:@"确定"];
}

#pragma mark - ***ZYGamePayDelegate***
- (void)gamePaySuccess{
    
    [self showAlertView:@"pay success" message:nil cancelBtn:@"确定"];
}

- (void)gamePayFail{
    
    [self showAlertView:@"pay fail" message:nil cancelBtn:@"确定"];
}

- (void)gamePayCancel{
    
    [self showAlertView:@"pay cancel" message:nil cancelBtn:@"确定"];
}

- (void)gamePayOrder:(NSString *)orderID{
    //游戏服务器需要将订单号及时处理 以便支付的时候核对订单号
    NSLog(@"生成的订单号是：%@",orderID);
}

#pragma mark - ***ZYGameSwitchDelegate***
// 切换账号的代理方法
- (void)doSwitch{
    
    //1.注销游戏角色
    
    //2.返回登录界面
    
    //3.同时弹出登录窗口
    [OctopusSDK login:@"test"];
}

#pragma mark - ***ZYGameAntiAddictionDelegate***
//实名制了而且已经成年，正常游戏娱乐
- (void)onVerifiedSuccess
{
    [self showAlertView:@"正常游戏娱乐" message:nil cancelBtn:@"确定"];
    //正常游戏
    
}
//实名了但未成年以及未实名制但还允许游戏时都需要通知游戏做相应的防沉迷提醒机制
- (void)doAntiAddiction
{
    [self showAlertView:@"需要防沉迷提醒" message:nil cancelBtn:@"确定"];
    //游戏进行相应的提醒
    
}
//未实名且不允许该类用户体验游戏，需游戏方处理退出游戏操作
- (void)onFail
{
    [self showAlertView:@"退出游戏操作" message:nil cancelBtn:@"确定"];
    //游戏退出操作
    
}

#pragma mark - ***Demo示例界面操作***
//初始化界面
- (void)initAllSubViews
{
    allBtns = [NSMutableArray array];
    
    NSMutableArray *allBtnsInfo = [NSMutableArray arrayWithObjects:
                                   @{@"image":@"startInit",@"title":@"初始化",@"action":@"initLDMobile"},
                                   @{@"image":@"loginin",@"title":@"登录",@"action":@"startLDMobileLogin"},
                                   @{@"image":@"switch_account",@"title":@"切换账号",@"action":@"changeLDMobileAccount"},
                                   @{@"image":@"loginout",@"title":@"退出",@"action":@"startLDMobilelogout"},
                                   @{@"image":@"user_sign",@"title":@"上传信息",@"action":@"submitEntergame"},
                                   @{@"image":@"payment",@"title":@"6.00元支付",@"action":@"pay"}
                                   , nil];
    CGSize mainSize = [UIScreen mainScreen].bounds.size;
    int longLength = (mainSize.width > mainSize.height?mainSize.width : mainSize.height);
    int shortLength = (mainSize.width < mainSize.height?mainSize.width : mainSize.height);
    CGFloat btnWidth = shortLength/3.0;
    CGFloat btnHeight = longLength/4.0;
    //判断是否是横屏
    if (UIInterfaceOrientationIsLandscape([UIApplication sharedApplication].statusBarOrientation)) {
        btnWidth = longLength/4.0;
        btnHeight = shortLength/3.0;
    }
    for (int i=0; i<[allBtnsInfo count]; i++) {
        NSDictionary *dictInfo = [allBtnsInfo objectAtIndex:i];
        UIButton *btn = [self createButtonWithImage:[dictInfo objectForKey:@"image"] title:[dictInfo objectForKey:@"title"] frame:CGRectMake(0, 0, btnWidth, btnHeight) action:NSSelectorFromString([dictInfo objectForKey:@"action"])];
        CGFloat poiX = btnWidth*0.5+i%3*btnWidth;
        CGFloat poiY = btnHeight*0.5+i/3*btnHeight;
        btn.center = CGPointMake(poiX, poiY);
        [allBtns addObject:btn];
        [self.view addSubview:btn];
    }
    
    CGFloat poiX = btnWidth * 0.5 + [allBtnsInfo count] % 3 * btnWidth;
    CGFloat poiY = btnHeight * 0.5 + [allBtnsInfo count] % 3 * btnHeight;
    UIView *infoView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, btnWidth, btnHeight)];
    infoView.backgroundColor = [UIColor whiteColor];
    infoView.center = CGPointMake(poiX, poiY);
    infoView.layer.borderWidth = 0.5;
    infoView.layer.borderColor = [UIColor colorWithWhite:0.45 alpha:1.0].CGColor;
    [allBtns addObject:infoView];
    [self.view addSubview:infoView];
    
    UILabel *titleLbl = [[UILabel alloc] initWithFrame:CGRectMake(0, 20, infoView.frame.size.width, 20)];
    titleLbl.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    titleLbl.textAlignment = NSTextAlignmentCenter;
    titleLbl.font = [UIFont systemFontOfSize:12];
    titleLbl.textColor = [UIColor orangeColor];
    titleLbl.text = @"当前玩家";
    [infoView addSubview:titleLbl];
    
    userIdLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 40, infoView.bounds.size.width, 20)];
    userIdLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    userIdLabel.textAlignment = NSTextAlignmentCenter;
    userIdLabel.font = [UIFont systemFontOfSize:13];
    userIdLabel.textColor = [UIColor blackColor];
    userIdLabel.text = @"未登录";
    [infoView addSubview:userIdLabel];
    
    UILabel *moneyTitle = [[UILabel alloc] initWithFrame:CGRectMake(0, 60, infoView.bounds.size.width, 20)];
    moneyTitle.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    moneyTitle.textAlignment = NSTextAlignmentCenter;
    moneyTitle.font = [UIFont systemFontOfSize:12];
    moneyTitle.textColor = [UIColor orangeColor];
    moneyTitle.text = @"总金币数";
    [infoView addSubview:moneyTitle];
    
    moneyLabel = [[UILabel alloc] initWithFrame:CGRectMake(0,80, infoView.frame.size.width, 20)];
    moneyLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    moneyLabel.textAlignment = NSTextAlignmentCenter;
    moneyLabel.font = [UIFont systemFontOfSize:13];
    moneyLabel.textColor = [UIColor blackColor];
    moneyLabel.text = @"0";
    [infoView addSubview:moneyLabel];
    
}

//创建按钮方法
- (UIButton *)createButtonWithImage:(NSString *)imageName title:(NSString *)title frame:(CGRect)rect action:(SEL)selector
{
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = rect;
    btn.backgroundColor = [UIColor whiteColor];
    btn.layer.borderWidth = 0.5;
    btn.layer.borderColor = [UIColor colorWithWhite:0.45 alpha:1.0].CGColor;
    if (title && title.length>0) {
        [btn addTarget:self action:selector forControlEvents:UIControlEventTouchUpInside];
        
        UIImageView *imageV = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 40, 40)];
        imageV.image = [UIImage imageNamed:imageName];
        imageV.center = CGPointMake(rect.size.width*0.5, rect.size.height*0.5-20);
        imageV.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin;
        imageV.layer.cornerRadius = 3.0;
        imageV.clipsToBounds = NO;
        imageV.backgroundColor = [UIColor colorWithRed:0.2 green:0.4 blue:0.6 alpha:1.0];
        [btn addSubview:imageV];
        
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 60, 120, 60)];
        //        titleLabel.backgroundColor = [UIColor orangeColor];
        titleLabel.center = CGPointMake(20, 65);
        titleLabel.text = title;
        titleLabel.textColor = [UIColor colorWithWhite:0.18 alpha:1.0];
        titleLabel.highlightedTextColor = [UIColor colorWithWhite:0.3 alpha:1.0];
        titleLabel.font = [UIFont systemFontOfSize:14];
        titleLabel.textAlignment = NSTextAlignmentCenter;
        [imageV addSubview:titleLabel];
        
    }
    return btn;
}

//- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
//{
//    CGFloat longLength = ([UIScreen mainScreen].bounds.size.width>[UIScreen mainScreen].bounds.size.height?[UIScreen mainScreen].bounds.size.width:[UIScreen mainScreen].bounds.size.height);
//    CGFloat shortLength = ([UIScreen mainScreen].bounds.size.width<[UIScreen mainScreen].bounds.size.height?[UIScreen mainScreen].bounds.size.width:[UIScreen mainScreen].bounds.size.height);
//    CGFloat btnWidth = shortLength/3;
//    CGFloat btnHeight = longLength/4;
//
//    if (UIInterfaceOrientationIsLandscape(toInterfaceOrientation)) {
//        //横屏
//        btnWidth = longLength/4.0;
//        btnHeight = shortLength/3.0;
//        for (int i = 0; i < [allBtns count]; i++) {
//            UIButton *btn = [allBtns objectAtIndex:i];
//            btn.frame = CGRectMake(0, 0, btnWidth, btnHeight);
//            int poiX = btnWidth*0.5 + i%4*btnWidth;
//            int poiY = btnHeight*0.5 + i/4*btnHeight;
//            btn.center = CGPointMake(poiX, poiY);
//        }
//    }
//    else
//    {
//        for (int i = 0; i < [allBtns count]; i++) {
//            UIButton *btn = [allBtns objectAtIndex:i];
//            btn.frame = CGRectMake(0, 0, btnWidth, btnHeight);
//            int poiX = btnWidth*0.5 + i%3*btnWidth;
//            int poiY = btnHeight*0.5 + i/3*btnHeight;
//            btn.center = CGPointMake(poiX, poiY);
//        }    }
//}

#define SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(v) ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)
- (void)showAlertView:(NSString *)title message:(NSString *)message cancelBtn:(NSString *)btnTitle
{
    if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"8.0")) {
        //版本大于等于8.0
        dispatch_async(dispatch_get_main_queue(), ^{
            
            UIAlertController *alertControl = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
            [alertControl addAction:[UIAlertAction actionWithTitle:btnTitle style:UIAlertActionStyleDefault handler:nil]];
            
            [self presentViewController:alertControl animated:YES completion:nil];
            
        });

        
        
    }
    else
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title message:message delegate:nil cancelButtonTitle:btnTitle otherButtonTitles:nil];
        [alert show];
    }
}

@end
