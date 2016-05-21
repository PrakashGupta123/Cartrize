//
//  StarRatingView.h
//  StarRatingDemo
//
//  Created by HengHong on 5/4/13.
//  Copyright (c) 2013 Fixel Labs Pte. Ltd. All rights reserved.
//


#import <UIKit/UIKit.h>

@class StarRatingView;

@protocol StarRatingViewDelegate<NSObject>

- (void)onTapTableWidgetSaveUpdates:(StarRatingView *)tableWidget;

@end

@interface StarRatingView : UIView
{
    id <StarRatingViewDelegate> delegate;
    BOOL isGiveRating;
}

@property (nonatomic) int userRating;
@property (nonatomic) int ratingIndex;;

@property(nonatomic ,assign) id <StarRatingViewDelegate> delegate;

//- (id)initWithFrame:(CGRect)frame andRating:(int)rating withLabel:(BOOL)label animated:(BOOL)animated;
- (id)initWithFrame:(CGRect)frame andRating:(int)rating withLabel:(BOOL)label animated:(BOOL)animated withSetRating:(BOOL)giveRating;
- (id)initWithFrame:(CGRect)frame andRating:(int)rating withLabel:(BOOL)label animated:(BOOL)animated withIndexPath :(int) indexPath;

@end