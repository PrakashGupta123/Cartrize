//
//  ListGridViewController.h
//  IShop
//
//  Created by Hashim on 5/1/14.
//  Copyright (c) 2014 Syscraft. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MBProgressHUD.h"
#import "AppDelegate.h"
#import "SearchView.h"

extern BOOL isREFINED;

@interface ListGridViewController : UIViewController<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout,UIPickerViewDataSource,UIPickerViewDelegate,UITextFieldDelegate,MBProgressHUDDelegate,UIAlertViewDelegate,NSURLSessionDelegate,UITableViewDataSource,UITableViewDelegate>
{
    
    BOOL isRefine;

    IBOutlet UIView *topMenuSliderView;
    IBOutlet UIView *menuView;
    BOOL isVisibleTopView,isLogout;
    
    IBOutlet UILabel *lblRecommended, *lblBagCount;
    IBOutlet UILabel *lblWelcomeuser;
    
    int selectRow;
    int isSelectedTypeGird;
    int index;
    NSInteger valueForPullRequest;
    
   // SWRevealViewController *revealController;
    IBOutlet UILabel *lblDownBagCount;
    
    IBOutlet UIButton *btnCurrency;
    IBOutlet UIButton *btnSize;
    
    BOOL isRecomonded;
    
    UIImageView *imgProduct;
    
    int randomNumber;
    UIWebView *wv;
    NSString *Webserviceurl;
    SearchView *searchView ;
   
    IBOutlet UIButton *refineBtn;
    
    BOOL isSearch;
    NSString *strRecomonded;

    NSMutableArray *responseArr;
    
   
}
@property (nonatomic,strong) NSMutableArray *arrContaintList;
@property(nonatomic ,retain)IBOutlet UITableView *tableViewTopContent;
@property (nonatomic,retain) IBOutlet UIButton *bigGridBtn;
@property (nonatomic,retain) IBOutlet UIButton *smallGridBtn;
@property (nonatomic,retain) MBProgressHUD *progressHud;
@property (nonatomic,retain)  NSString *categoryId;
@property (nonatomic,retain) UIActionSheet *actionSheet;
@property (nonatomic,retain) IBOutlet UIToolbar *pickerToolbar;
@property (nonatomic,retain) IBOutlet UIPickerView *pickerView;
@property (nonatomic,strong) IBOutlet UICollectionView *myCollectionView;
@property (nonatomic,retain)  NSMutableArray *dataArray;
@property (nonatomic,retain) IBOutlet UIButton *tooglBackBtn;
@property (nonatomic,retain) IBOutlet UIButton *tooglBackBtnBottom;

@property (nonatomic,retain) IBOutlet UITextField *filterTxtField;

//Property Uibutton iVar
@property (nonatomic, retain) IBOutlet UIButton *btnSignOut;
@property (nonatomic, retain) IBOutlet UIButton *btnSignIn;

@property (nonatomic,retain) NSMutableArray *arrayRecommended;
@property (nonatomic, retain) IBOutlet UIButton  *btnJoin,*btnMyAccount;
@property(nonatomic)BOOL isRefined;
@property (nonatomic, retain)NSMutableArray *refinedArray;
@property(nonatomic)BOOL doUpdate;

@property(nonatomic ,retain)IBOutlet UIView *viewGridButtons;

#pragma mark -

- (IBAction)funcProfile:(id)sender;
- (IBAction)SeacrhButtonPress:(id)sender;
- (IBAction)ShowPicker:(id)sender;
- (IBAction)refineButtonPress:(id)sender;

- (IBAction) topNavigationSliderAction:(id)sender;

- (IBAction) btnJoinAction:(id)sender;
- (IBAction) btnSignInAction:(id)sender;
- (IBAction) btnSignOutAction:(id)sender;
- (IBAction) btnAddToBagAction:(id)sender;
- (IBAction)btnCancelToolbarAction:(id)sender;
- (IBAction)btnDoneToolbarAction:(id)sender;
- (IBAction)btnActionMyAccount:(id)sender;


- (IBAction) btnFavouriteAction:(id)sender;
-(IBAction)backAction:(id)sender;
@end
