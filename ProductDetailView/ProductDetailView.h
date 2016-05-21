//
//  ProductDetailView.h
//  IShop
//
//  Created by Hashim on 5/3/14.
//  Copyright (c) 2014 Syscraft. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#import <MessageUI/MessageUI.h>
#import "SearchView.h"


@interface ProductDetailView : UIViewController<UIPickerViewDelegate,UIPickerViewDataSource,UIGestureRecognizerDelegate,UIScrollViewDelegate, MFMailComposeViewControllerDelegate, UIWebViewDelegate,UICollectionViewDataSource,UICollectionViewDelegate,UIAlertViewDelegate,UITextFieldDelegate,UITableViewDataSource,UITableViewDelegate,UIPickerViewDataSource,UIPickerViewDelegate>
{
    BOOL WebCallAccordingCartId;
    UIScrollView *scrollViewProductDetail;
    //UIScrollView *scrolViewPrductImages;
    NSString *strProId;
    BOOL isShowLoader,isLogout;
    NSString *strRecent;
    UIWebView *wv,*wv1;
    MBProgressHUD *hud3;
    IBOutlet UIImageView *imgViewProducts;
    
    //Mutable Data iVar
    NSMutableData *webData;
    NSMutableArray *mutArrayProductImages,* arrayCartData;
       NSMutableArray *arrWeight;
    IBOutlet UILabel *lblProductName;
    IBOutlet UILabel *lblProductPrice;
    IBOutlet UILabel *lblProductProductCode;
    IBOutlet UILabel *lblProductProductDiscription;
    IBOutlet UILabel *lblAboutMe;//by Hupendra
    IBOutlet UIButton *btnInfo; //by Hupendra
    IBOutlet UILabel *lblProductSize;
    IBOutlet UILabel *lblProductColor;
    IBOutlet UILabel *lblBagCount;
    IBOutlet UILabel *lblDownBagCount;
    
    BOOL isRecomded;
    IBOutlet UIButton *btnDone;
    
    IBOutlet UIView *viewMoreInfo;
    IBOutlet UITextView *txtViewMoreInfo;
    IBOutlet UIButton *btnCloseMorInfo;
    
    IBOutlet UIButton *btnColorPicker;
    IBOutlet UIButton *btnSizePicker;
    
    int isWebserviceCount;
    int isGetButton;
    
    int index;
    int index1;
    
    int isSelectedPicker;
    
    IBOutlet UIView *topMenuSliderView;
    IBOutlet UIView *menuView;
    BOOL isVisibleTopView;
    float strDefaultPrice;
    IBOutlet UILabel *lblWelcomeuser;
    
    IBOutlet UIButton *btnCurrency;
    IBOutlet UIButton *btnSize;
    
    int iRequest;
    
    NSMutableDictionary *dictCartToCustomerResponse;
    
    
    NSString *strAttributeTitile;
    NSString *strPrdOptionId;
    NSString *strPrdOptionTypeId;
    NSString *strweight;
    NSString *strProductPrice;
    NSString *strPriceFinal,*strprdqty;
    
    BOOL isCheckOut;
    IBOutlet UIButton *btnMoreInfo;
    IBOutlet UIView *productDetView;
    IBOutlet UIImageView *imageViewBG;
    CGFloat stringHt;
    NSMutableArray *totalArr;
    UITextField *txtFieldCoupon;
    BOOL isSearch;
    SearchView *searchView;
    NSMutableArray *arrContaintList,*mArrayQuantity;

    int isTablcontent;
    float Price;
    IBOutlet UIImageView *descLblBg;
    UIView *viewMainWebview;
    BOOL isLoadedWebview,isLoadedWebview2,isLoadedWebview3;
    int weightIndex,weightIndex2;
    int allIndex,allIndex2;
    NSMutableString *request_gallery;
    IBOutlet UIActivityIndicatorView *activity;
    
    
}
@property(nonatomic,retain)IBOutlet UILabel *lblDiscountshow;
@property(nonatomic ,retain)IBOutlet UITableView *tableViewTopContent;
@property (strong, nonatomic) IBOutlet UIView *viewBackGround;

@property(nonatomic ,retain)IBOutlet UIButton *btnAddToBag;
@property(nonatomic ,retain)IBOutlet UITableView *tableViewPrdAttributes;
@property(nonatomic ,retain)IBOutlet UIView *viewPrdAttributes;

@property (nonatomic, retain) IBOutlet UIScrollView *scrollViewProductDetail;
//@property (nonatomic, retain) IBOutlet UIScrollView *scrolViewPrductImages;
@property (nonatomic, retain) NSMutableDictionary *mutDictProductDetail;
//by me
@property (strong, nonatomic) IBOutlet UIButton *btnOption;
@property (strong, nonatomic) IBOutlet UIButton *btncartietms;
@property (retain, nonatomic) NSString *strSelectValue;
//

//@property (nonatomic,retain) IBOutlet UIPickerView *pickerView;
//Property Mutable Array iVar
@property (nonatomic, retain) NSMutableArray *arrProductColor,*mArrayProductAttributes;
@property (nonatomic, retain) NSMutableArray *arrProductSize;
@property (nonatomic, retain) NSMutableArray *arrProductColorAndSize;

@property (retain, nonatomic) IBOutlet UIView *popupView;
@property (retain, nonatomic) IBOutlet UIView *popupViewSave;

@property (nonatomic, retain) IBOutlet UIToolbar *pickerToolbar1;
@property (nonatomic,retain) IBOutlet UIPickerView *pickerViewColorandSize;
//Property Uibutton iVar
@property (nonatomic, retain) IBOutlet UIButton *btnSignOut;
@property (nonatomic, retain) IBOutlet UIButton *btnSignIn, *btnPickerCancel, *btnPickerDone, *btnJoin,*btnMyAccount;

#pragma mark - UIButton Method

- (IBAction) btnBackAction:(id)sender;
- (IBAction) btnColorAndSizeAction:(id)sender;
- (IBAction) btnAddToBagAction:(id)sender;

- (IBAction) btnViewBagAction:(id)sender;
- (IBAction) btnCheckOutAction:(id)sender;
- (IBAction) btnCloseMoreInfoAction:(id)sender;

- (IBAction) btnSaveLaterAction:(id)sender;
- (IBAction) btnViewSavedItemAction:(id)sender;

- (IBAction)btnCancelToolbarAction:(id)sender;
- (IBAction)btnDoneToolbarAction:(id)sender;

- (IBAction) topNavigationSliderAction:(id)sender;

- (IBAction) btnJoinAction:(id)sender;
- (IBAction) btnSignInAction:(id)sender;
- (IBAction) btnSignOutAction:(id)sender;
- (IBAction) btnFavouriteAction:(id)sender;
- (IBAction)btnActionMyAccount:(id)sender;

- (IBAction)funcProfile:(id)sender;

- (IBAction) btnMoreInfoAction:(id)sender;


@end
