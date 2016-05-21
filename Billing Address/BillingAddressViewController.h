//
//  BillingAddressViewController.h
//  French Bakery
//
//  Created by Avnish Sharma on 10/4/13.
//  Copyright (c) 2013 Mayank. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#import "GridViewController.h"
#import "UITextField+PendingTextFieldWithImage.h"
@interface BillingAddressViewController : UIViewController<UIPickerViewDataSource,UIPickerViewDelegate>
{
    NSString *Webserviceurl;
    UIWebView *wv;
    MBProgressHUD *BILLHUD;
     //UITextField iVar
    IBOutlet UITextField *txtFldFirstName;
    IBOutlet UITextField *txtFldLastName;
    IBOutlet UITextField *txtFldContact;
    IBOutlet UITextField *txtFldCity;
    IBOutlet UITextField *txtFldStreet;
    IBOutlet UITextField *txtFldZipCode;
    IBOutlet UITextField *txtFldState;
    
    //UIButton iVar
    IBOutlet UIButton *btnCountry;
    IBOutlet UIButton *btnState;
    IBOutlet UIButton *btnContinue;
    
    //UIPickerView iVar
    IBOutlet UIPickerView *pickerViewCountry;
   
    //UILabel iVar
    IBOutlet UILabel *lblCountryName;
    IBOutlet UILabel *lblStateName;
    
    //Mutable array iVar
    NSMutableArray *arrayCountry;
    NSMutableArray *arrayStates;
    
    //Mutable Data iVar
    NSMutableData *nsDataCountry;
    NSMutableData *nsDataState;
    
    //Other iVar
    AppDelegate *ObjAppDelegate;
    BOOL isCheckService;
    int iRow;
    int iRequest;
    BOOL isStateSelect;
    
    BOOL AB;
    NSInteger SelectedSection;
    NSString *strShippingCode;
    
}

@property(nonatomic ,retain)NSMutableArray *RowArray;
@property(nonatomic ,retain)NSMutableArray *mArrayUPSShipping,*mArrayDHLShiping,*mArrayFlatRate,*mArrayFreeShipping,*mArrayFedex,*mArrayUps,*mArrayUsps,*mArrayDhlint;

@property(nonatomic ,readwrite)int requestFor;
@property(nonatomic,retain)NSMutableDictionary *mDictProductDetail;

@property (nonatomic,retain)  NSMutableArray *arrayCountry;
@property (nonatomic,retain)  NSMutableArray *arrayStates;
@property (nonatomic, retain) UIToolbar *keyboardToolbar;
@property (nonatomic, retain) IBOutlet UIButton *doneButton;

@property(nonatomic ,retain)IBOutlet UITableView *tableViewShipping;
@property(nonatomic ,retain)IBOutlet UIView *viewShipping;

#pragma mark - UIButton Action

- (void) CountryAction;
- (void) StateAction;
- (IBAction) btnCountryAction:(id)sender;
- (IBAction) btnStateAction:(id)sender;
- (IBAction) btnBackAction:(id)sender;
- (IBAction) btnCountinueAction:(id)sender;
- (IBAction) doneBtnPressToGetValue:(id)sender;
- (IBAction) btnCancelAction:(id)sender;

@end
