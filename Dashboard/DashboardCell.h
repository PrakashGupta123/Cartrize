//
//  DashboardCell.h
//  IShop
//
//  Created by Admin on 15/07/14.
//  Copyright (c) 2014 Syscraft. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DashboardCell : UITableViewCell
@property(strong,nonatomic)IBOutlet UILabel *shipto;
@property(strong,nonatomic)IBOutlet UILabel *orderNum;
@property(strong,nonatomic)IBOutlet UILabel *orderTotal;
@property(strong,nonatomic)IBOutlet UILabel *date;
@property(strong,nonatomic)IBOutlet UILabel *statuslbl;


@property(nonatomic ,retain)IBOutlet UILabel *lblSKU,*lblPrice,*lblQuantity,*lblProductName;
@end
