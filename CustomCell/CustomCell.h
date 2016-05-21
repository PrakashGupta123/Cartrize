//
//  CustomCell.h
//  IShop
//
//  Created by Avnish Sharma on 7/3/14.
//  Copyright (c) 2014 Syscraft. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CustomCell : UITableViewCell

@property(nonatomic ,retain)IBOutlet UIButton *btnPicker,*btnCell;


@property(nonatomic ,retain)IBOutlet UILabel *lblPrdAttibuteTitle;


@property(nonatomic ,retain)IBOutlet UILabel *lblNickName,*lblTitle,*lblDetail;
@end
