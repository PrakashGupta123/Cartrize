//
//  CustomCell.m
//  IShop
//
//  Created by Avnish Sharma on 7/3/14.
//  Copyright (c) 2014 Syscraft. All rights reserved.
//

#import "CustomCell.h"

@implementation CustomCell
@synthesize lblPrdAttibuteTitle;
@synthesize btnPicker,btnCell;

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
