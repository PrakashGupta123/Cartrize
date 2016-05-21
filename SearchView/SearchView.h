//
//  SearchView.h
//  IShop
//
//  Created by Avnish Sharma on 7/14/14.
//  Copyright (c) 2014 Syscraft. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SearchView : UIView

@property(nonatomic,retain)IBOutlet UITableView *tableViewSearchResult;
@property(nonatomic ,retain)IBOutlet UITextField *txtSearch;
@property(nonatomic ,retain)IBOutlet UIButton *btnHideView;
@end
