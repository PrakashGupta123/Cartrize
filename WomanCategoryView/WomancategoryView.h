//
//  WomancategoryView.h
//  IShop
//
//  Created by Hashim on 4/30/14.
//  Copyright (c) 2014 Syscraft. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MBProgressHUD.h"
@interface WomancategoryView : UIViewController<UITableViewDataSource,UITableViewDelegate,MBProgressHUDDelegate>
@property(nonatomic,retain)NSArray *categoryArray;
@property(nonatomic,retain)MBProgressHUD *progressHud;
@property(nonatomic,retain)UIWindow *window;
@property(nonatomic,retain)IBOutlet UITableView *listTbl;

@end
