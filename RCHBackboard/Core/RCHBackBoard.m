//
//  RCHBackboard.m
//  RCHBackboard
//
//  Created by Rob Hayward on 28/11/2012.
//  Copyright (c) 2012 Rob Hayward. All rights reserved.
//

#import "RCHBackboard.h"
#import "RCHBackboard.h"
#import "RCHBackboardGestureControl.h"

#define RCH_DEFAULT_ANIMATION_DURATION 0.3f

NSString *const RCHBackboardWillPresentNotification = @"RCHBackboardWillPresentNotification";
NSString *const RCHBackboardDidPresentNotification = @"RCHBackboardDidPresentNotification";
NSString *const RCHBackboardWillDismissNotification = @"RCHBackboardWillDismissNotification";
NSString *const RCHBackboardDidDismissNotification = @"RCHBackboardDidDismissNotification";

static NSMutableDictionary *__backboards = nil;

@interface RCHBackboard () <RCHBackboardGestureControlDelegate>

@property (assign, nonatomic) BOOL isOpen;
@property (strong, nonatomic) RCHBackboardGestureControl *gestureControl;
@property (strong, nonatomic) UIViewController *rootViewController;
@property (strong, nonatomic) UIViewController *backboardViewController;
@property (strong, nonatomic) UIViewController *containerViewController;

@end

@implementation RCHBackboard

+ (void)initialize
{
  static dispatch_once_t onceToken;
  dispatch_once(&onceToken, ^{
    __backboards = [NSMutableDictionary dictionaryWithCapacity:0];
  });
}

+ (void)setupWithName:(NSString *)name container:(UIViewController *)container root:(UIViewController *)root backboard:(UIViewController *)backboard orientation:(RCHBackboardOrientation)orientation width:(CGFloat)width
{
  __unused id instance = [[RCHBackboard alloc] initWithName:name container:container root:root backboard:backboard orientation:orientation width:width];
}

+ (void)dismiss
{
  for (RCHBackboard *backboard in [__backboards allValues]) {
    [backboard dismissWithCompletion:nil];
  }
}

+ (RCHBackboard *)backboardWithName:(NSString *)name
{
  return [__backboards objectForKey:name];
}

+ (void)presentBackboardWithName:(NSString *)name completion:(void (^)(BOOL))completion
{
  RCHBackboard *backboard = [__backboards objectForKey:name];
  if (!backboard) return;
  [backboard presentWithCompletion:completion];
}

+ (void)dismissBackboardWithName:(NSString *)name completion:(void (^)(BOOL))completion
{
  RCHBackboard *backboard = [__backboards objectForKey:name];
  if (!backboard) return;
  [backboard dismissWithCompletion:completion];
}

+ (void)tearDown
{
  for (RCHBackboard *backboard in [__backboards allValues]) {
    [backboard tearDown];
  }
  __backboards = [NSMutableDictionary dictionaryWithCapacity:0];
}

- (id)initWithName:(NSString *)name container:(UIViewController *)container root:(UIViewController *)root backboard:(UIViewController *)backboard orientation:(RCHBackboardOrientation)orientation width:(CGFloat)width
{
  self = [super init];
  if (self) {
    NSParameterAssert(name);
    NSParameterAssert(container);
    NSParameterAssert(root);
    NSParameterAssert(backboard);
    NSAssert(width > 0, @"Width must be greater than zero to present the backboard");
    NSAssert(![__backboards objectForKey:name], @"Each backboard should have a unique name");
    
    [__backboards setObject:self forKey:name];
    
    self.name = name;
    self.width = width;
    self.orientation = orientation;
    self.rootViewController = root;
    self.backboardViewController = backboard;
    self.containerViewController = container;
    self.animationDuration = RCH_DEFAULT_ANIMATION_DURATION;
    self.gestureControl = [[RCHBackboardGestureControl alloc] initWithDelegate:self];
    
    [self notifications];
  }
  return self;
}

- (void)setupContainerViewController
{
  [_containerViewController addChildViewController:_backboardViewController];
  [_containerViewController.view insertSubview:_backboardViewController.view atIndex:0];
  [_containerViewController addChildViewController:_rootViewController];
  [_containerViewController.view insertSubview:_rootViewController.view atIndex:1];
}

#pragma mark - Notifications

- (void)notifications
{
  [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(willPresent:) name:RCHBackboardWillPresentNotification object:nil];
  [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didPresent:) name:RCHBackboardDidPresentNotification object:nil];
  [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(willDismiss:) name:RCHBackboardWillDismissNotification object:nil];
  [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didDismiss:) name:RCHBackboardDidDismissNotification object:nil];
}

- (void)willPresent:(NSNotification *)notification
{
  if (self != [notification object]) return;
  self.state = RCHBackboardStateOpening;
}

- (void)didPresent:(NSNotification *)notification
{
  if (self != [notification object]) return;
  self.state = RCHBackboardStateOpen;
}

- (void)willDismiss:(NSNotification *)notification
{
  if (self != [notification object]) return;
  self.state = RCHBackboardStateClosing;
}

- (void)didDismiss:(NSNotification *)notification
{
  if (self != [notification object]) return;
  self.state = RCHBackboardStateClosed;
}

#pragma mark - Getters

- (BOOL)isOpen
{
  if ((_state == RCHBackboardStateOpen) || (_state == RCHBackboardStateOpening)) {
    return YES;
  }
  return NO;
}

#pragma mark - Presenting

- (void)presentWithCompletion:(void (^)(BOOL finished))completion
{
  if (_isOpen) return;
  
  [RCHBackboard dismiss];
  
  [[NSNotificationCenter defaultCenter] postNotificationName:RCHBackboardWillPresentNotification object:self userInfo:@{@"Name": self.name}];
  
  [_containerViewController addChildViewController:_backboardViewController];
  [_containerViewController.view insertSubview:_backboardViewController.view atIndex:0];
  
  [UIView animateWithDuration:_animationDuration animations:^{
    
    CGRect rootViewFrame = _rootViewController.view.frame;
    switch (self.orientation) {
      case RCHBackboardOrientationLeft:
        rootViewFrame.origin.x += self.width;
        break;
      case RCHBackboardOrientationTop:
        rootViewFrame.origin.y += self.width+100;
        break;
      case RCHBackboardOrientationRight:
        rootViewFrame.origin.x -= self.width;
        break;
      case RCHBackboardOrientationBottom:
        rootViewFrame.origin.y -= self.width;
        break;
    }
    [_rootViewController.view setFrame:rootViewFrame];
    
  } completion:^(BOOL finished){
    
    [self setupGestures];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:RCHBackboardDidPresentNotification object:self userInfo:@{@"Name": self.name}];
    
    if (completion) completion(finished);
    
  }];
}

#pragma mark - Dismissing

- (void)dismissWithCompletion:(void (^)(BOOL finished))completion
{
  if (!self.isOpen) return;
  
  [_gestureControl.view removeFromSuperview];
  
  [[NSNotificationCenter defaultCenter] postNotificationName:RCHBackboardWillDismissNotification object:self userInfo:@{@"Name": self.name}];
  [UIView animateWithDuration:self.animationDuration animations:^{
    
    CGRect rootViewFrame = _rootViewController.view.frame;
    switch (self.orientation) {
      case RCHBackboardOrientationLeft:
        rootViewFrame.origin.x = 0;
        break;
      case RCHBackboardOrientationTop:
        rootViewFrame.origin.y = 0;
        break;
      case RCHBackboardOrientationRight:
        rootViewFrame.origin.x = 0;
        break;
      case RCHBackboardOrientationBottom:
        rootViewFrame.origin.y = 0;
        break;
    }
    _rootViewController.view.frame = rootViewFrame;
    
  } completion:^(BOOL finished){
    
    [[NSNotificationCenter defaultCenter] postNotificationName:RCHBackboardDidDismissNotification object:self userInfo:@{@"Name": self.name}];
    
    [_backboardViewController.view removeFromSuperview];
    [_backboardViewController removeFromParentViewController];
    
    if (completion) completion(finished);
  }];
}

#pragma mark - Gestures

- (void)setupGestures
{
  [_gestureControl reset];
  [_gestureControl setBackboard:self];
  UIView *gestureView = [_gestureControl view];
  [gestureView removeFromSuperview];
  [gestureView setFrame:_rootViewController.view.bounds];
  [_rootViewController.view addSubview:gestureView];
}

#pragma mark - GestureControlDelegate

- (void)RCHBackboardGestureTapReceived:(RCHBackboardGestureControl *)gestureControl
{
  [self dismissWithCompletion:nil];
}

- (void)RCHBackboardGestureSwipeToCloseReceived:(RCHBackboardGestureControl *)gestureControl
{
  [self dismissWithCompletion:nil];
}

#pragma mark - TearDown

- (void)tearDown
{
  _rootViewController = nil;
  _backboardViewController = nil;
  _containerViewController = nil;
  [__backboards removeObjectForKey:_name];
  [[NSNotificationCenter defaultCenter] removeObserver:self name:RCHBackboardWillPresentNotification object:nil];
  [[NSNotificationCenter defaultCenter] removeObserver:self name:RCHBackboardDidPresentNotification object:nil];
  [[NSNotificationCenter defaultCenter] removeObserver:self name:RCHBackboardWillDismissNotification object:nil];
  [[NSNotificationCenter defaultCenter] removeObserver:self name:RCHBackboardDidDismissNotification object:nil];
}


@end
