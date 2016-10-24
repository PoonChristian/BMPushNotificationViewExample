//
//  UIView+Instantiation.m
//  BMPushNotificationViewExample
//
//  Created by Christian on 7/15/15.
//  Copyright (c) 2015 bookmarq. All rights reserved.
//

#import "UIView+Instantiation.h"

@implementation UIView (Instantiation)

+ (instancetype)instantiateFromXib
{
    return [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:self options:0][0];
}

@end