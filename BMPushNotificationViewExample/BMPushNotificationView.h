//
//  BMPushNotificationView.h
//  BMPushNotificationViewExample
//
//  Created by Christian on 7/15/15.
//  Copyright (c) 2015 bookmarq. All rights reserved.
//

#import <UIKit/UIKit.h>

@class BMPushNotificationView;

/**
 *
 */
typedef NS_ENUM(NSInteger, BMPushNotificationViewEndSwipingStyle)
{
    /**
     *
     */
    BMPushNotificationViewEndSwipingStyleDefault = 0,
    
    /**
     *  When the user lets go of the animating view, the animating view will end at the left of the button(s).
     */
    BMPushNotificationViewEndSwipingStyleLeft,
    
    /**
     *  When the user lets go of the animating view, the animating view will end at the middle of the button(s).
     */
    BMPushNotificationViewEndSwipingStyleMiddle,
    
    /**
     *  When the user lets go of the animating view, the animating view will cover the button(s).
     */
    BMPushNotificationViewEndSwipingStyleRight
};

@protocol BMPushNotificationViewButtonsDataSource <NSObject>

@required

/**
 *  Returns the number of buttons the user wants in the push notification view.
 */
- (NSUInteger)numberOfButtonsForPushNotificationView:(BMPushNotificationView * __nonnull)pushNotificationView;

/**
 *  Returns a color determined by an index for each button in the push notification view. The number of indexes should be equivalent to the number specified in the numberOfButtonsForPushNotificationView method or else there will be a crash.
 */
- (UIColor * __nonnull)colorOfButtonAtIndex:(NSUInteger)index
           forPushNotificationView:(BMPushNotificationView * __nonnull)pushNotificationView;

/**
 *  Returns a title determined by an index for each button in the push notification view. The number of indexes should be equivalent to the number specified in the numberOfButtonsForPushNotificationView method or else there will be a crash.
 */
- (NSString * __nullable)titleForButtonAtIndex:(NSUInteger)index
            forPushNotificationView:(BMPushNotificationView * __nonnull)pushNotificationView;

@end

@interface BMPushNotificationView : UIView

@property (nonatomic, assign, nullable) id<BMPushNotificationViewButtonsDataSource> dataSource;

@property (nonatomic, weak) IBOutlet UIView *contentView;

@property (nonatomic, weak) IBOutlet UILabel *timeLabel;
@property (nonatomic, weak) IBOutlet UILabel *dateLabel;

@property (nonatomic, weak) IBOutlet UIView   *buttonContainer;

@property (nonatomic, weak) IBOutlet UIView      *animatingView;
@property (nonatomic, weak) IBOutlet UIImageView *iconImageView;
@property (nonatomic, weak) IBOutlet UILabel     *appNameLabel;          // Streaq  - Helvi Neueue (medium) 12
@property (nonatomic, weak) IBOutlet UILabel     *notificationTimeLabel; // now - Helvi Neueue 9/10
@property (nonatomic, weak) IBOutlet UILabel     *messageLabel;          // Make sure you read a chapter a day! - Helvi Neueue 10/11
@property (nonatomic, weak) IBOutlet UILabel     *commandLabel;          // slide to view - Helvi Neueue 9/10

@property (nonatomic, weak) IBOutlet NSLayoutConstraint *iconConstraint;
@property (nonatomic, weak) IBOutlet NSLayoutConstraint *buttonConstraint;

#pragma mark - Customizable Properties

/**
 *  Determines whether the sliding view can be dragged and moved around by the user.
 *  Defaults to NO.
 */
@property (atomic, assign) BOOL interactive;

/**
 *  Determines the swiping style relative to the button(s) of the sliding view when dragging ends.
 */
@property (atomic, assign) BMPushNotificationViewEndSwipingStyle swipingStyle;

/**
 *  Determines the image that gets shown in the notification.
 */
@property (nonatomic, strong, nullable) UIImage *icon;

/**
 *  The default height of this view.
 */
+ (CGFloat)defaultHeight;

- (void)startAnimating;
- (void)stopAnimating;

- (void)reloadButtonsData;

@end