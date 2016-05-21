//
//  FavouriteCell.m
//  IShop
//
//  Created by Avnish Sharma on 5/26/14.
//  Copyright (c) 2014 Syscraft. All rights reserved.
//

#import "FavouriteCell.h"

@implementation FavouriteCell

@synthesize lblProductName,lblColor,lblQty,lblSize,btn_Edit,btn_Delete,imgViewProduct, lblPrice, btnMoveToBag,lblMessage;
@synthesize lblTextSize,lblTextColor,lblEditColor,lblEditQty,lblEditSize;
@synthesize viewDetail,viewEdit;
@synthesize imgViewEditProduct,imgBtn;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
       
        //imgViewProduct.layer.cornerRadius=6;
//        imgViewProduct.layer.masksToBounds=YES;
//        imgViewProduct.layer.borderColor=[[UIColor greenColor]CGColor];
//        imgViewProduct.layer.borderWidth= 1.0f;
       
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
