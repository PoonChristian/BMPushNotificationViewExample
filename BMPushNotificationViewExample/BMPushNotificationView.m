//
//  BMPushNotificationView.m
//  BMPushNotificationViewExample
//
//  Created by Christian on 7/15/15.
//  Copyright (c) 2015 bookmarq. All rights reserved.
//

#import "BMPushNotificationView.h"

@interface BMPushNotificationView ()
@property (atomic, assign) BOOL shouldAnimate;

@property (atomic, assign) NSUInteger buttonCount;

@end

@implementation BMPushNotificationView

static CGFloat const kAnimationDuration       = 1.7f;
static CGFloat const kAnimationDelay          = 1.5f;
static CGFloat const kAnimationSpringDamping  = 0.71f; // Play with
static CGFloat const kAnimationSpringVelocity = 0.5f; // both attributes

static CGFloat const kSlidingDistancePadding = 12.0f;

static CGFloat const kButtonWidth = 64.0f;
static CGFloat const kButtonHeight = 80.0f;

+ (CGFloat)defaultHeight
{
    return 216.0f;
}

#pragma mark - Initialization

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self)
    {
        [self setup];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        [self setup];
    }
    return self;
}

- (void)setup
{
    self.interactive   = NO;
    self.shouldAnimate = YES;
}

#pragma mark - View Lifecycle

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    self.translatesAutoresizingMaskIntoConstraints = YES;
    
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self
                                                                          action:@selector(handlePanGesture:)];

    [self.animatingView addGestureRecognizer:pan];
}

- (void)didMoveToWindow
{
    [super didMoveToWindow];
    
    [self reloadButtonsData];
}

#pragma mark - Custom Setters/Getters

- (void)setBackgroundColor:(UIColor *)backgroundColor
{
    [super setBackgroundColor: backgroundColor];
    [self.contentView setBackgroundColor: backgroundColor];
}

- (void)setIcon:(UIImage * __nullable)icon
{
    _icon = icon;
    [self.iconImageView setImage:icon];
    [self setNeedsUpdateConstraints];
}

#pragma mark - Customizable Properties

- (void)handlePanGesture:(UIPanGestureRecognizer *)recognizer
{
    [self stopAnimating];
    
    CGRect currentViewFrame = [[self.animatingView.layer presentationLayer] frame];
    
    const CGFloat maxX = CGRectGetMaxX(currentViewFrame);
    NSLog(@"maxX=%f", maxX);
    
    const CGFloat buttonMidX = CGRectGetMidX(self.buttonContainer.frame);
    NSLog(@"midX=%f", buttonMidX);
    
    const CGFloat buttonMinX = CGRectGetMinX(self.buttonContainer.frame);
    NSLog(@"minX=%f", buttonMinX);

    CGPoint translation = [recognizer translationInView:self.animatingView];
    recognizer.view.center = CGPointMake(recognizer.view.center.x + translation.x, recognizer.view.center.y);
    [recognizer setTranslation:CGPointZero inView:self.animatingView];
    
    if (recognizer.state == UIGestureRecognizerStateEnded) {

        // TODO: check if user implemented
        const CGFloat leftFinalX = -(CGRectGetWidth(self.buttonContainer.frame) + kSlidingDistancePadding);
        const CGFloat middleFinalX = leftFinalX / 2;
        const CGFloat rightFinalX = 0.0f;
        
        // TODO: Come up with a descriptive name such that the user understands what the heck each boolean represents
        BOOL endsLeftOfMiddleOfAllButtons = ((self.buttonCount > 1) && (maxX < buttonMidX));
        BOOL endsLeftOfSingleButton = ((self.buttonCount == 1) && (maxX < buttonMinX));
        
        if (self.swipingStyle == BMPushNotificationViewEndSwipingStyleDefault)
        {
            if (endsLeftOfMiddleOfAllButtons || endsLeftOfSingleButton)
            {
                [self panGestureReleased: leftFinalX animateLeft: NO];
            }
            else
            {
                [self panGestureReleased: rightFinalX animateLeft: YES];
            }
        }
        else if (self.swipingStyle == BMPushNotificationViewEndSwipingStyleLeft)
        {
            [self panGestureReleased: leftFinalX animateLeft: NO];
        }
        else if (self.swipingStyle == BMPushNotificationViewEndSwipingStyleMiddle)
        {
            [self panGestureReleased: middleFinalX animateLeft: NO];
        }
        else if (self.swipingStyle == BMPushNotificationViewEndSwipingStyleRight)
        {
            [self panGestureReleased: rightFinalX animateLeft: YES];
        }

    }
}

// TODO: better name
- (void)panGestureReleased:(CGFloat)x animateLeft:(BOOL)animateLeft
{
    [UIView animateWithDuration: kAnimationDuration
                          delay: 0.0f
         usingSpringWithDamping: kAnimationSpringDamping
          initialSpringVelocity: kAnimationSpringVelocity
                        options: UIViewAnimationOptionCurveEaseOut | UIViewAnimationOptionAllowUserInteraction
                     animations: ^{
                         CGRect frame = self.animatingView.frame;
                         frame.origin.x = x;
                         self.animatingView.frame = frame;
                     }
                     completion: ^(BOOL finished) {
                         
                         // TODO: What if user wanted 0 buttons
                         if (self.dataSource && self.buttonCount != 0)
                         {
                             self.shouldAnimate = YES;
                             
                             if (animateLeft) {
                                 [self animateLeft];
                             } else {
                                 [self animateRight];
                             }
                         }
                         else
                         {
                             NSLog(@"WARNING: There are %lu buttons, which is not between 1 and 3, so there will be no animation.", self.buttonCount);
                         }
                     }];
}

- (void)updateConstraints
{
    [super updateConstraints];
    if (self.icon) {
        self.iconConstraint.constant = 40;
    } else {
        self.iconConstraint.constant = 8;
    }
}

#pragma mark - Animation Code

- (void)startAnimating
{
    [self animateLeft];
}

- (void)animateLeft
{
    const CGFloat slidingDistance = CGRectGetWidth(self.buttonContainer.frame) + kSlidingDistancePadding;
    
    if (self.shouldAnimate) {
        [UIView animateWithDuration: kAnimationDuration
                              delay: kAnimationDelay
             usingSpringWithDamping: kAnimationSpringDamping
              initialSpringVelocity: kAnimationSpringVelocity
                            options: UIViewAnimationOptionCurveEaseOut | UIViewAnimationOptionAllowUserInteraction
                         animations: ^{
                             CGRect frame = self.animatingView.frame;
                             frame.origin.x -= slidingDistance;
                             self.animatingView.frame = frame;
                             NSLog(@"%@", NSStringFromCGRect(self.animatingView.frame));
                        }
                         completion: ^(BOOL finished) {
                             [self animateRight];
                         }];
    } else {
        [self stopAnimating];
    }
}

- (void)animateRight
{
    const CGFloat middleSwipingStyleMaxX = CGRectGetMaxX(self.animatingView.frame) + (kSlidingDistancePadding / 2);
    const CGFloat buttonMidX = CGRectGetMidX(self.buttonContainer.frame);
    
    CGFloat slidingDistance;
    if (middleSwipingStyleMaxX == buttonMidX)
    {
        slidingDistance = (CGRectGetWidth(self.buttonContainer.frame) / 2) + (kSlidingDistancePadding / 2);
    }
    else
    {
        slidingDistance = CGRectGetWidth(self.buttonContainer.frame) + kSlidingDistancePadding;
    }
    
    if (self.shouldAnimate) {
        [UIView animateWithDuration:kAnimationDuration
                              delay:kAnimationDelay
             usingSpringWithDamping:kAnimationSpringDamping
              initialSpringVelocity:kAnimationSpringVelocity
                            options:UIViewAnimationOptionCurveEaseOut | UIViewAnimationOptionAllowUserInteraction
                         animations:^{
                             CGRect frame = self.animatingView.frame;
                             frame.origin.x += slidingDistance;
                             self.animatingView.frame = frame;
                             NSLog(@"%@", NSStringFromCGRect(self.animatingView.frame));
                         }
                         completion: ^(BOOL finished) {
                             [self animateLeft];
                         }];
    } else {
        [self stopAnimating];
    }
}

- (void)stopAnimating
{
    self.shouldAnimate = NO;
    
    CGPoint presentationPosition = [[self.animatingView.layer presentationLayer] position];
    self.animatingView.center = presentationPosition;
    [self.animatingView.layer removeAllAnimations];
}

#pragma mark - Buttons Data Source

- (void)reloadButtonsData
{
    if ( self.dataSource )
    {
        if ( [self.dataSource respondsToSelector: @selector(numberOfButtonsForPushNotificationView:)] )
        {
            self.buttonCount = [self.dataSource numberOfButtonsForPushNotificationView:self];
            
            // TODO: Do check here if > 3, log also
            
            if (self.buttonCount >= 1 && self.buttonCount <= 3)
            {
                self.buttonConstraint.constant *= self.buttonCount;
                
                for (NSUInteger i = 0; i < self.buttonCount; i++)
                {
                    UIButton *newButton = [UIButton buttonWithType:UIButtonTypeSystem];
                    newButton.frame = CGRectMake(kButtonWidth * i, 0.0f, kButtonWidth, kButtonHeight);
                    
                    // TODO: Check if user has implemented the data source method.. if not, then use @"" as title
                    NSString *title;
                    if ( [self.dataSource respondsToSelector: @selector(titleForButtonAtIndex:forPushNotificationView:)] )
                    {
                        title = [self.dataSource titleForButtonAtIndex:i forPushNotificationView:self];
                    }
                    else
                    {
                        title = @"";
                    }
                    [newButton setTitle:title forState:UIControlStateNormal];
                    
                    // TODO: Check is user has implemented the data source method.. if not, then use white
                    UIColor *color;
                    if ( [self.dataSource respondsToSelector:@selector(colorOfButtonAtIndex:forPushNotificationView:)] )
                    {
                        color = [self.dataSource colorOfButtonAtIndex:i forPushNotificationView:self];
                    }
                    else
                    {
                        color = [UIColor whiteColor];
                    }
                    [newButton setBackgroundColor:color];
                    
                    [newButton setUserInteractionEnabled:NO];
                    
                    [self.buttonContainer addSubview:newButton];
                }
            }
            else
            {
                // TODO: Log error
                NSLog(@"WARNING: numberOfButtonsForPushNotificationView returned %lu buttons, which is not between 1 and 3", self.buttonCount);
                self.shouldAnimate = NO;
            }
        }
        else
        {
            NSLog(@"WARNING: User did not implement numberOfButtonsForPushNotificationView method");
            self.shouldAnimate = NO;
        }
    }
    else
    {
        // TODO: Implement
        self.shouldAnimate = NO;
    }
}

@end