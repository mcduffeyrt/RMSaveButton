//
//  RMSaveButton.m
//
//  Created by Richard McDuffey on 5/20/15.
//  Copyright (c) 2015 Richard McDuffey. All rights reserved.
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in all
//  copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
//  SOFTWARE.


#import "RMSaveButton.h"

NSString * const StartAnimationKey = @"Start";
const NSInteger NumberOfIndicatiors = 10;

@interface RMSaveButton ()

@property (nonatomic, strong) CAReplicatorLayer *activityLayer;
@property (nonatomic, strong) CAShapeLayer *backingLayer;
@property (nonatomic, strong) CAShapeLayer *tickLayer;
@property (nonatomic, strong) CALayer *marker;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, assign) CGRect collapsedFrame;
@property (nonatomic, assign) CGRect expandedFrame;
@property (nonatomic, assign) BOOL isAnimating;
@property (nonatomic, assign) BOOL isInterrupted;

@end

@implementation RMSaveButton

#pragma mark - Initialization

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    
    if (self) {
       [self setup];
    }
    
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setup];
    }
    
    return self;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.frame = CGRectMake(0, 0, 120, 40);
        [self setup];
    }
    
    return self;
}

#pragma mark - Storyboard / NIB setup 

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    [self setup];
}

- (void)prepareForInterfaceBuilder
{
    [self setup];
}

#pragma mark - Setup and Layout

- (void)setup
{
    
    self.isAnimating = NO;
    
    self.backgroundColor = [UIColor clearColor];
    
    self.backingLayer = [CAShapeLayer layer];
    self.backingLayer.fillColor = self.foregroundColor.CGColor;
    [[self layer] addSublayer:self.backingLayer];
    
    self.tickLayer = [CAShapeLayer layer];
    self.tickLayer.strokeColor = [UIColor whiteColor].CGColor;
    self.tickLayer.lineWidth = 3;
    self.tickLayer.lineJoin = kCALineJoinRound;
    self.tickLayer.fillColor = [UIColor clearColor].CGColor;
    [[self layer] addSublayer:self.tickLayer];
    
    self.activityLayer = [CAReplicatorLayer layer];
    self.activityLayer.backgroundColor = [UIColor clearColor].CGColor;
    
    CGFloat angle = (2.0 * M_PI) / NumberOfIndicatiors;
    CATransform3D instanceRotation = CATransform3DMakeRotation(angle, 0.0, 0.0, 1.0);
    
    self.activityLayer.instanceTransform = instanceRotation;
    self.activityLayer.instanceCount = NumberOfIndicatiors;
    
    [[self layer] addSublayer:self.activityLayer];
    
    self.marker = [CALayer layer];
    [self.marker setBackgroundColor:[[UIColor darkGrayColor] CGColor]];
    [self.activityLayer addSublayer:self.marker];
    
    [self.marker setOpacity:0.0];
    
    self.titleLabel = [UILabel new];
    self.titleLabel.translatesAutoresizingMaskIntoConstraints = NO;
    self.titleLabel.textColor = [UIColor whiteColor];
    self.titleLabel.backgroundColor = [UIColor clearColor];
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
    self.titleLabel.numberOfLines = 1;
    self.titleLabel.minimumScaleFactor = 0.1;
    self.titleLabel.adjustsFontSizeToFitWidth = YES;
    [self addSubview:self.titleLabel];
    
    
    
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"|[label]|"
                                                                options:0
                                                                metrics:nil
                                                                  views:@{@"label": _titleLabel}]];
    
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-[label]-|"
                                                                 options:0
                                                                 metrics:nil
                                                                   views:@{@"label": _titleLabel}]];

    
    [self addTarget:self action:@selector(touchUpInside:) forControlEvents:UIControlEventTouchUpInside];
    [self registerNotifications];
    
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    CGFloat halfWidth = CGRectGetWidth(self.bounds) / 2;
    CGFloat halfHeight = CGRectGetHeight(self.bounds) / 2;
    
    self.expandedFrame = self.bounds;
    self.collapsedFrame = CGRectInset(self.bounds, halfWidth - halfHeight, 0);
    self.activityLayer.frame = CGRectInset(self.collapsedFrame, 5, 0);
    self.activityLayer.position = CGPointMake(halfWidth, halfHeight);
    self.marker.frame = CGRectMake(0, 0, self.collapsedFrame.size.width / 4, 4);
    self.marker.cornerRadius = 2;
    self.marker.position = CGPointMake(self.collapsedFrame.size.width / 4 - 4, self.collapsedFrame.size.height / 2);
    
    self.backingLayer.frame = self.bounds;
    UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:self.bounds cornerRadius:halfHeight];
    self.backingLayer.path = path.CGPath;
    
    self.tickLayer.frame = self.bounds;
    
    UIFont *font = [UIFont systemFontOfSize:1.5];
    float fontAspectFactor = 1.0 / font.lineHeight;
    self.titleLabel.font = [UIFont boldSystemFontOfSize:self.titleLabel.frame.size.height * fontAspectFactor];
    self.titleLabel.text = self.label;
}

#pragma mark - Notifications

- (void)registerNotifications {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationDidEnterBackground) name:UIApplicationDidEnterBackgroundNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationWillEnterForeground) name:UIApplicationWillEnterForegroundNotification object:nil];
}

- (void)applicationDidEnterBackground {
    if (self.isAnimating) {
        [self.marker removeAnimationForKey:StartAnimationKey];
    }
}

- (void)applicationWillEnterForeground {
    if (self.isAnimating) {
        [self startActivityAnimation];
    }
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self forKeyPath:UIApplicationDidEnterBackgroundNotification];
    [[NSNotificationCenter defaultCenter] removeObserver:self forKeyPath:UIApplicationWillEnterForegroundNotification];
}

#pragma mark - Setters and Getters

- (NSString *)label
{
    return _label != nil ? _label : @"SAVE";
}

- (UIColor *)foregroundColor
{
    return _foregroundColor != nil ? _foregroundColor : [UIColor colorWithRed:43/255.0 green:189/255.0 blue:224/255.0 alpha:1.0];
}

- (UIColor *)highlightedColor
{
    return _highlightedColor != nil ? _highlightedColor : [UIColor colorWithRed:108/255.0 green:164/255.0 blue:176/255.0 alpha:1.0];
}


- (void)setHighlighted:(BOOL)highlighted
{
    [super setHighlighted:highlighted];
    
    if (highlighted && !self.isAnimating) {
        [CATransaction begin];
        [CATransaction setValue:(id)kCFBooleanTrue forKey:kCATransactionDisableActions];
            self.backingLayer.fillColor = self.highlightedColor.CGColor;
        [CATransaction commit];
    }
    else {
        [CATransaction begin];
        [CATransaction setValue:(id)kCFBooleanTrue forKey:kCATransactionDisableActions];
        self.backingLayer.fillColor = self.foregroundColor.CGColor;
        [CATransaction commit];
    }
}
#pragma mark - Helper Methods

- (void)touchUpInside:(RMSaveButton *)sender
{
    [self setSelected:!self.selected animated:YES];
    [self sendActionsForControlEvents:UIControlEventValueChanged];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    if (animated && !self.isAnimating) {
        [self startAnimation];
        
        if (self.startHandler != nil) {
            self.startHandler();
        }
    }
    
    else if (self.isAnimating) {
        [self interruptAnimation];
        
        if (self.interruptHandler != nil) {
            self.interruptHandler();
        }
    }
}

- (void)drawTick
{
    CGPoint origin = CGPointMake(self.bounds.size.width / 2, self.bounds.size.height / 2);
    CGFloat radius = self.bounds.size.height / 2;
    
    origin.y = origin.y + radius / 3;
    
    UIBezierPath *path = [UIBezierPath bezierPath];
    
    CGPoint start = CGPointZero;
    start.x = origin.x + (radius / 2) * cos(220 * M_PI / 180);
    start.y = origin.y + (radius / 2) * sin(220 * M_PI / 180);
    
    [path moveToPoint:start];
    [path addLineToPoint:origin];
    
    CGPoint end = CGPointZero;
    
    end.x = origin.x + radius * cos(300 * M_PI / 180);
    end.y = origin.y + radius * sin(300 * M_PI / 180);
    
    [path addLineToPoint:end];
    
    self.tickLayer.path = path.CGPath;
}

- (void)resetButton
{
    self.titleLabel.alpha = 1.0;
    self.tickLayer.path = nil;
}

#pragma mark - Animation

- (void)startActivityAnimation
{
    CABasicAnimation * fade = [CABasicAnimation animationWithKeyPath:@"opacity"];
    [fade setFromValue:[NSNumber numberWithFloat:1.0]];
    [fade setToValue:[NSNumber numberWithFloat:0.0]];
    [fade setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear]];
    [fade setRepeatCount:HUGE_VALF];
    [fade setDuration:1.0];
    CGFloat markerAnimationDuration = 1.0 / NumberOfIndicatiors;
    [self.activityLayer setInstanceDelay:markerAnimationDuration];
    [self.marker addAnimation:fade forKey:StartAnimationKey];
}

- (void)startAnimation
{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 0.5 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
    
        self.titleLabel.alpha = 0.0;
        
        CGPathRef originalPath = self.backingLayer.path;
        
        UIBezierPath *end = [UIBezierPath bezierPathWithRoundedRect:self.collapsedFrame cornerRadius:self.frame.size.height / 2];
        
        self.backingLayer.path = end.CGPath;
        
        CABasicAnimation *pathAnimate = [CABasicAnimation animationWithKeyPath:@"path"];
        pathAnimate.duration = 0.6;
        pathAnimate.fromValue = (__bridge id)(originalPath);
        pathAnimate.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];
        pathAnimate.delegate = self;
        [self.backingLayer addAnimation:pathAnimate forKey:@"path"];
        
        self.isAnimating = YES;
    
    });
}

- (void)interruptAnimation
{
    [self.marker removeAnimationForKey:StartAnimationKey];
   
    CGPathRef originalPath = self.backingLayer.path;
    
    UIBezierPath *end = [UIBezierPath bezierPathWithRoundedRect:self.expandedFrame cornerRadius:self.frame.size.height / 2];
    
    self.backingLayer.path = end.CGPath;
    
    CABasicAnimation *pathAnimate = [CABasicAnimation animationWithKeyPath:@"path"];
    pathAnimate.duration = 0.6;
    pathAnimate.fromValue = (__bridge id)(originalPath);
    pathAnimate.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];
    pathAnimate.delegate = self;
    [self.backingLayer addAnimation:pathAnimate forKey:@"path"];
    
    self.isAnimating = NO;
    self.isInterrupted = YES;
}

- (void)endAnimation
{
    [self.marker removeAnimationForKey:StartAnimationKey];
    
    CGPathRef originalPath = self.backingLayer.path;
    
    UIBezierPath *end = [UIBezierPath bezierPathWithRoundedRect:self.expandedFrame cornerRadius:self.frame.size.height / 2];
    
    self.backingLayer.path = end.CGPath;
    
    CABasicAnimation *pathAnimate = [CABasicAnimation animationWithKeyPath:@"path"];
    pathAnimate.duration = 0.6;
    pathAnimate.fromValue = (__bridge id)(originalPath);
    pathAnimate.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];
    pathAnimate.delegate = self;
    [self.backingLayer addAnimation:pathAnimate forKey:@"path"];
    
    self.isAnimating = NO;
}

#pragma mark - CAAnimation Delegate

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag
{
    if (self.isAnimating) {
        [self startActivityAnimation];
    }
    
    else if (!self.isAnimating && self.isInterrupted) {
        self.titleLabel.alpha = 1.0;
    }
    
    else {
        [self drawTick];
    }
}

@end
