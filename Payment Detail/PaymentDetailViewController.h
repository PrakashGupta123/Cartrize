//
//  PaymentDetailViewController.h
//  French Bakery
//
//  Created by Avnish Sharma on 10/11/13.
//  Copyright (c) 2013 Mayank. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#import "UITextField+PendingTextFieldWithImage.h"
@interface PaymentDetailViewController : UIViewController<NSURLConnectionDelegate,UIPickerViewDataSource,UIPickerViewDelegate,UITextFieldDelegate,UIAlertViewDelegate>{
   
    IBOutlet UITextField *txtFldCardNumber;
    IBOutlet UITextField *txtFldLastOnwerName;
    IBOutlet UITextField *txtFldExpiryYear;
    IBOutlet UITextField *txtFldExpiryMonth;

    //Mutable Data iVar
    NSMutableData *nsDataCardType;
    
    //Mutable array iVar
    NSMutableArray *arrayCardType;
    
    IBOutlet UILabel *lblCardType;
    IBOutlet UILabel *lblYear;
    IBOutlet UILabel *lblmonth;
    
    //UIPickerView iVar
    IBOutlet UIPickerView *pickerViewCountry;
    AppDelegate *ObjAppDelegate;
    int iRequest;
    int iRow;
    int isSelectedPickr;
    
    NSString *strCartType;
    NSString *strIncrement_id; //by Hupendra
}

@property(nonatomic ,readwrite)int requestFor;

@property (nonatomic, retain) NSMutableArray *arrayCardType;
@property (nonatomic, retain) NSMutableArray *arrayYear;
@property (nonatomic, retain) NSMutableArray *arrayMonth;
@property (nonatomic, retain) IBOutlet UIButton *doneButton;
@property (nonatomic, retain) IBOutlet UITextField *txtFldCvvNumber;
@property (nonatomic, retain)NSMutableDictionary *mDictPaymentResponse,*mDictProductDetail;
@property (nonatomic,strong)NSString *strPresenting;
#pragma mark - UIButton Action

- (IBAction) btnCardTypeAction:(id)sender;
- (IBAction) btnContinueAction:(id)sender;
- (IBAction) btnCancelAction:(id)sender;

- (IBAction) btnYearDDAction:(id)sender;
- (IBAction) btnMonthDDAction:(id)sender;

@end
