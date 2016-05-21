//
//  Currency_Size_VC.h
//  IShop
//
//  Created by Vivek  on 30/05/14.
//  Copyright (c) 2014 Syscraft. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MBProgressHUD.h"
#import "AppDelegate.h"
#import "SearchView.h"

@protocol CurrencyDelegate <NSObject>

-(void)RefreshCurrencydelegatemethod:(NSString *)symbol withvalue:(NSString *)value;


@end

@interface Currency_Size_VC : UIViewController<UITableViewDataSource,UITableViewDelegate,MBProgressHUDDelegate,UITextFieldDelegate>
{
    
    IBOutlet UIView *topMenuSliderView;
    IBOutlet UIView *menuView;
    BOOL isVisibleTopView;
    NSMutableData *webData;
    IBOutlet UILabel *lblDownBagCount;
    IBOutlet UILabel *lblWelcomeuser;
    IBOutlet UILabel *lblRecommended, *lblBagCount;
    SearchView *searchView ;
    NSMutableArray *arrContaintList;
    
    BOOL isSearch;
    int isTablcontent;
}

@property(nonatomic ,retain)IBOutlet UITableView *tableViewTopContent;
@property (assign, nonatomic) id<CurrencyDelegate> delegateCurrency;
@property (nonatomic, retain) id delegate;

@property (nonatomic,retain) NSArray *dataArray;
@property (nonatomic,retain) MBProgressHUD *progressHud;
//Property Uibutton iVar
@property (nonatomic, retain) IBOutlet UIButton *btnSignOut;
@property (nonatomic, retain) IBOutlet UIButton *btnSignIn, *btnJoin,*btnMyAccount;

@property int isSelectedValue;

- (IBAction) SeacrhButtonPress:(id)sender;
- (IBAction)btnActionMyAccount:(id)sender;

- (IBAction) btnJoinAction:(id)sender;
- (IBAction) btnSignInAction:(id)sender;
- (IBAction) btnSignOutAction:(id)sender;
@end
