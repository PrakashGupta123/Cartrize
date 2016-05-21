//
//  FavouriteCell.h
//  IShop
//
//  Created by Avnish Sharma on 5/26/14.
//  Copyright (c) 2014 Syscraft. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AsyncImageView.h"

@interface FavouriteCell : UITableViewCell

@property (nonatomic, retain) IBOutlet UILabel *lblProductName;
@property (nonatomic, retain) IBOutlet UILabel *lblSize;
@property (nonatomic, retain) IBOutlet UILabel *lblColor;
@property (nonatomic, retain) IBOutlet UILabel *lblQty;

@property (nonatomic, retain) IBOutlet UILabel *lblPrice;
@property (nonatomic ,retain)IBOutlet UILabel *lblMessage;

@property (nonatomic, retain) IBOutlet UIButton *btn_Edit;
@property (nonatomic, retain) IBOutlet UIButton *btn_Delete;
@property (nonatomic, retain) IBOutlet UIButton *btnMoveToBag;
@property (nonatomic, retain) IBOutlet UIImageView *imgViewProduct;
@property (nonatomic, retain) IBOutlet UIView *viewDetail, *viewEdit;
@property (nonatomic, retain) IBOutlet AsyncImageView *imgViewEditProduct;
@property (nonatomic, retain) IBOutlet UILabel *lblTextSize;
@property (nonatomic, retain) IBOutlet UILabel *lblTextColor;
@property (nonatomic, retain) IBOutlet UILabel *lblEditSize, *lblEditQty, *lblEditColor;

@property (nonatomic, retain) IBOutlet UIButton *btnEditCancel, *btnEditApply, *btnEditDelete, *btnEditQty, *btnEditSize, *btnEditColour,*btnViewMore;

@property(nonatomic ,retain)IBOutlet UILabel *lblViewMore;
@property(nonatomic,retain)IBOutlet UIButton *imgBtn;

@end
