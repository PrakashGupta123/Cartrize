//
//  FavouriteViewController.h
//  IShop
//
//  Created by Avnish Sharma on 5/26/14.
//  Copyright (c) 2014 Syscraft. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#import <MessageUI/MessageUI.h>


@interface FavouriteViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,UIScrollViewDelegate,UIAlertViewDelegate,UIPickerViewDelegate,UIPickerViewDataSource,MFMailComposeViewControllerDelegate>
{
    IBOutlet UILabel *lblNavTitle;
    
    float totalPrice;
    int iRequest;
    int index1;
    int index;
    
    NSMutableDictionary *dictProductAddToCart;
    NSMutableDictionary *dictCartToCustomerResponse;
    
    BOOL isEditProduct;
    
    //UIPickerView iVar
    IBOutlet UIPickerView *pickerViewColor;
    IBOutlet UIPickerView *pickerViewQty;
   
    int selectedItemIndex;
    int selectedCellIndex;
    
    NSString *strColor,*strSize;
    IBOutlet UIButton *btnMoreInfo;
    CGFloat stringHt;
    
    float Price;

      NSInteger indexTag;
    IBOutlet UILabel *lblProductName;
    IBOutlet UILabel *lblProductPrice;
    IBOutlet UILabel *lblProductProductCode;
    IBOutlet UILabel *lblProductProductDiscription;
    IBOutlet UILabel *lblAboutMe; //by hupendra
    
    IBOutlet UIView *viewMoreInfo;
    IBOutlet UITextView *txtViewMoreInfo;
     IBOutlet UITextField *txtWeight;
    IBOutlet UIImageView *imgViewProducts;
    float strDefaultPrice;
    int isWebserviceCount;
    NSMutableArray *mutArrayProductImages;
    BOOL isProductEdit;
    int selectedIndexViewMore;
    int isSelectedPicker;
    NSString *strAttributeTitile;
    NSMutableArray *mArrayQuantity;
    
    int btnTag;
    
    int IndexValue;
    
    NSString *strPrdOptionId;
    NSString *strPrdOptionTypeId;
    NSString *strProductPrice;
   
    BOOL isApply;

}
@property (nonatomic, retain) NSString *strQty;
@property (nonatomic, retain) UIToolbar *keyboardToolbar;
@property (nonatomic, retain)NSMutableArray *arrProductColor,*arrProductSize;
@property (nonatomic, retain) NSMutableDictionary *mDictEditDetail;
@property (strong, nonatomic) IBOutlet UIButton *btnApply;

@property (nonatomic, retain) IBOutlet UITableView *tblViewProductBag;
@property (nonatomic, retain)  NSMutableArray *arrProducts;

@property(nonatomic ,retain)IBOutlet UIView *viewProductDetail;
@property (nonatomic, retain) IBOutlet UIScrollView *scrollViewProductDetail;
@property (nonatomic, retain) IBOutlet UIScrollView *scrolViewPrductImages;
@property (weak, nonatomic) IBOutlet UIPageControl *pagecontroller;
@property(nonatomic ,retain)IBOutlet UITableView *tableViewPrdAttributes;
@property(nonatomic ,retain)IBOutlet UIView *viewPrdAttributes;
@property (nonatomic, retain) NSMutableDictionary *mutDictProductDetail;
@property (nonatomic, retain) NSMutableArray *arrProductColorAndSize,*copyarrProductColorAndSize;
@property (nonatomic, retain) IBOutlet UIToolbar *pickerToolbar1;
@property (nonatomic, retain) NSMutableArray *mArrayProductAttributes;

@property (strong, nonatomic) IBOutlet UIButton *btnMoveAll;
@property (strong, nonatomic) IBOutlet UIImageView *imgDescBackground;

- (IBAction) btnBackAction:(id)sender;
- (void) btnContinueAction;
- (IBAction) btnDeleteAction:(id)sender;
- (IBAction) btnMoveAllToBagAction:(id)sender;
- (IBAction)DropDownWeithList:(id)sender;

- (IBAction) btnMoreInfoAction:(id)sender;


@end
