//
//  VSPDropDownView.h
//  Things2Do
//
//  Created by Vivek on 10/12/14.
//  Copyright (c) 2014 Syscraft. All rights reserved.
//

#import <UIKit/UIKit.h>

@class VSPDropDownView;
@protocol vSpDropDownDelegate <NSObject>

- (void) VSPDropDownDelegateMethod: (VSPDropDownView *) sender;
- (void) getStrData: (NSString *)strDate1;

@end
@interface VSPDropDownView : UIView<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong)  UIImageView *imgView;
@property (nonatomic, strong) id <vSpDropDownDelegate> delegate;
@property (nonatomic, strong) NSString *animationDirection;
-(void)hideDropDown:(UIButton *)button;

- (id)showDropDown:(UIButton *)button andWithHeight:(CGFloat)height andWithArray:(NSMutableArray *)arr andWithDirection:(NSString *)direction;

@end
