//
//  UITextField+PendingTextFieldWithImage.m
//  Challo
//
//  Created by Administrator on 21/11/14.
//  Copyright (c) 2014 Syscraft. All rights reserved.
//

#import "UITextField+PendingTextFieldWithImage.h"

@implementation UITextField (PendingTextFieldWithImage)

-(void)leftMargin:(int)value {
    
    UIView *paddingView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, value, 0)];
    self.leftView = paddingView;
    self.leftViewMode = UITextFieldViewModeAlways;
    
}
@end
