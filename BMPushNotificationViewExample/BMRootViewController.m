//
//  BMRootViewController.m
//  BMPushNotificationViewExample
//
//  Created by Christian on 7/15/15.
//  Copyright (c) 2015 bookmarq. All rights reserved.
//

#import "BMRootViewController.h"
#import "BMPushNotificationView.h"
#import "UIView+Instantiation.h"

@interface BMRootViewController ()<BMPushNotificationViewButtonsDataSource>
@property (nonatomic, strong) BMPushNotificationView *pushNotificationView;
@end

@implementation BMRootViewController

#pragma mark - View Lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.pushNotificationView = [BMPushNotificationView instantiateFromXib];
    self.pushNotificationView.frame = CGRectMake(0.0f, 64.0f, CGRectGetWidth(self.view.frame), [BMPushNotificationView defaultHeight]);
    //self.pushNotificationView.icon = [UIImage imageNamed: @"sample_icon"];
    self.pushNotificationView.dataSource = self;
    
    [self.view addSubview: self.pushNotificationView];
}

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [self.pushNotificationView startAnimating];
}

#pragma mark - Push Notification View Buttons Data Source 

- (NSUInteger)numberOfButtonsForPushNotificationView:(BMPushNotificationView * __nonnull)pushNotificationView
{
    return 2;
}

- (NSString *)titleForButtonAtIndex:(NSUInteger)index forPushNotificationView:(BMPushNotificationView * __nonnull)pushNotificationView
{
    return @[@"Foo", @"Bar"][index];
}

- (UIColor *)colorOfButtonAtIndex:(NSUInteger)index forPushNotificationView:(BMPushNotificationView * __nonnull)pushNotificationView
{
    return [UIColor greenColor];
}

@end