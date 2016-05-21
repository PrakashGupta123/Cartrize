//
//  RCHBackboardGestureControl.h
//  RCHBackboard
//
//  Created by Rob Hayward on 28/11/2012.
//  Copyright (c) 2012 Rob Hayward. All rights reserved.
//

#import <Foundation/Foundation.h>

@class RCHBackboardGestureControl, RCHBackboard;

@protocol RCHBackboardGestureControlDelegate <NSObject>

- (void)RCHBackboardGestureTapReceived:(RCHBackboardGestureControl *)gestureControl;
- (void)RCHBackboardGestureSwipeToCloseReceived:(RCHBackboardGestureControl *)gestureControl;

@end

@interface RCHBackboardGestureControl : NSObject

@property (assign, nonatomic) id<RCHBackboardGestureControlDelegate> delegate;
@property (strong, nonatomic) UIView *view;
@property (assign, nonatomic) CGPoint panGestureStart;
@property (assign, nonatomic) CGPoint panGestureTrack;
@property (assign, nonatomic) CGPoint translatedPoint;
@property (assign, nonatomic) RCHBackboard *backboard;

- (id)initWithDelegate:(id<RCHBackboardGestureControlDelegate>)delegate;

- (void)reset;

@end
