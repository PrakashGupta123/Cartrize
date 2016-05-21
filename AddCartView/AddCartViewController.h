//
//  AddCartViewController.h
//  IShop
//
//  Created by Hashim on 5/1/14.
//  Copyright (c) 2014 Syscraft. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#import <MessageUI/MessageUI.h>

@interface AddCartViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,UIScrollViewDelegate,UIAlertViewDelegate, UIPickerViewDelegate, UIPickerViewDataSource, UIActionSheetDelegate,MFMailComposeViewControllerDelegate,UITextFieldDelegate>
{
    IBOutlet UILabel *lblNavTitle;
    float Price;
    int editQty;
    NSString *strprdqty;
    UILabel *lblEditprotitle;
    NSMutableArray *arraycontent;
    float totalPrice;
    int iRequest;
    NSInteger deleteIndex;
    UILabel *btnRef;
    NSMutableArray *arrayCartData;
    UIActivityIndicatorView *spinner ;
    
    int btnTag;
    
    int selectedItemIndex,selectedColorIndex,selectedSizeIndex,selectedQuantityIndex;
    
    NSString *strHoldCurrentPrice,*strQty2;
    
    NSMutableDictionary *dictProductAddToCart;
    NSMutableDictionary *dictCartToCustomerResponse;
    NSMutableArray *mArrayQuantity;
    
    IBOutlet UIView *viewMoreInfo;
    IBOutlet UITextView *txtViewMoreInfo;
    IBOutlet UIButton *btnCloseMorInfo;
    
    int isWebserviceCount;
    IBOutlet UIImageView *imgViewProducts;

    float strDefaultPrice;
    NSMutableArray *mutArrayProductImages;

    IBOutlet UILabel *lblProductName;
    IBOutlet UILabel *lblProductPrice;
    IBOutlet UILabel *lblProductProductCode;
    IBOutlet UILabel *lblProductProductDiscription;
   
    int index;
    int isSelectedPicker;
    int isPickerIndex;
    

    BOOL isRecomded;

    BOOL recent_is;
    BOOL isProductEdit;
    
    NSString *strAttributeTitile;
    NSString *strPrdOptionId;
    NSString *strPrdOptionTypeId;
    
    int selectedIndexViewMore;
    
    NSMutableArray *optionJsonValues;
    
    NSString *strCartId;
    int prdtotalAddqty;
    float Priceafter;
    UITextField *txtFieldCoupon;
    int randomNumber;
    NSString *strProductPrice;
    
    NSInteger indexTag;
    NSData *imageData;
    
    IBOutlet UIButton *btnMoreInfo; //Hupendra
    CGFloat stringHt;
     IBOutlet UILabel *lblAboutMe; //by hupendra
}

@property (weak, nonatomic) IBOutlet UILabel *lblRecentItems;
@property (weak, nonatomic) IBOutlet UIButton *buttonClearAll;

@property (weak, nonatomic) IBOutlet UICollectionView *CollectionMoreInfo;

@property (strong, nonatomic) IBOutlet UIButton *btnApply;

@property (weak, nonatomic) IBOutlet UIButton *buttonBuythelook;
@property (weak, nonatomic) IBOutlet UIButton *buttonWeRecom;
@property (weak, nonatomic) IBOutlet UIButton *buttonRecentView;
@property (weak, nonatomic) IBOutlet UILabel *lblButTheItems;
@property (weak, nonatomic) IBOutlet UIPageControl *pagecontroller;
//by me
@property (strong, nonatomic) IBOutlet UIButton *btnPAY_SECURELY;
@property (strong, nonatomic) IBOutlet UIButton *btnEditdisplay;
@property (strong, nonatomic) IBOutlet UILabel *lbl_Price;

@property (strong, nonatomic) IBOutlet UILabel *lbl_TOTAL;
@property (strong, nonatomic) IBOutlet UIImageView *imgDescBackGround;

//
@property (nonatomic, retain) IBOutlet UIToolbar *pickerToolbar1;
@property (nonatomic,retain) IBOutlet UIPickerView *pickerViewColorandSize;

@property (nonatomic, retain) NSMutableDictionary *mutDictProductDetail;

@property(nonatomic ,readwrite)int requestFor;

@property (nonatomic, retain) NSString *strQty, *strPrices;

//Property Mutable Array iVar
@property (nonatomic, retain) NSMutableArray *arrProductColor;
@property (nonatomic, retain) NSMutableArray *arrProductSize;
@property (nonatomic, retain) NSMutableArray *arrProductColorAndSize;

@property (nonatomic, retain) NSMutableDictionary *mDictEditDetail;

@property (nonatomic, retain) NSMutableData *dataSize;

@property (nonatomic, retain) IBOutlet UITableView *tblViewProductBag;
@property (nonatomic, retain)  NSMutableArray *arrProducts;
@property (nonatomic,retain) IBOutlet UIToolbar *pickerToolbar;
@property (nonatomic,retain) IBOutlet UIPickerView *pickerViewDetail;

@property(nonatomic ,retain)IBOutlet UIView *viewProductDetail;
@property(nonatomic ,retain)IBOutlet UITableView *tableViewPrdAttributes;
@property(nonatomic ,retain)IBOutlet UIView *viewPrdAttributes;
@property (nonatomic, retain) IBOutlet UIScrollView *scrollViewProductDetail;
@property (nonatomic, retain) IBOutlet UIScrollView *scrolViewPrductImages;

@property (nonatomic, retain) NSMutableArray *mArrayProductAttributes;



- (IBAction) btnBackAction:(id)sender;
- (void)btnContinueAction;
- (IBAction)funcOpenPicker:(id)sender;
- (IBAction)btnDeleteAction:(id)sender;
- (IBAction)btnCancelToolbarAction:(id)sender;
- (IBAction)btnDoneToolbarAction:(id)sender;

@end
