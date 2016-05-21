//
//  CurrencyViewController.h
//  IShop
//
//  Created by Avnish Sharma on 6/18/14.
//  Copyright (c) 2014 Syscraft. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CurrencyViewController : UIViewController<UITableViewDataSource,UITableViewDelegate> {
    
    UITableView *tblView;
}

@property (nonatomic, retain) IBOutlet UITableView *tblView;
@property (nonatomic, retain) NSMutableArray *arrCurrencyAndSize;

- (IBAction) btnBackAction:(id)sender;

@end
