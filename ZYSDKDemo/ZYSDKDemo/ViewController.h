//
//  ViewController.h
//  ZYSDKDemo
//
//  Created by zhangyu on 2019/4/11.
//  Copyright © 2019年 zhangyu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController
+ (ViewController *)shareInstance;
//初始化sdk的必要的代理对象
- (void)initSDKDelegate;
@end

