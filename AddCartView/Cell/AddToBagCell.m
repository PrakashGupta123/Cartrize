//
//  AddToBagCell.m
//  IShop
//
//  Created by Avnish Sharma on 5/12/14.
//  Copyright (c) 2014 Syscraft. All rights reserved.
//

#import "AddToBagCell.h"

@implementation AddToBagCell

@synthesize lblProductName,lblQty,lblSize,btn_Edit,btn_Delete,imgViewProduct,lblPrice, viewDetail, viewEdit, imgViewEditProduct,lblTextColor,lblTextSize;

@synthesize lblEditSize, lblEditQty, btnEditApply, btnEditCancel, btnEditDelete, btnEditQty, btnEditSize, btnEditColour, lblEditColor;

@synthesize btnProductDetail,btnViewMore;

@synthesize lblViewMore;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
