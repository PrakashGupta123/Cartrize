//
//  RefineViewController.h
//  IShop
//
//  Created by Hashim on 5/2/14.
//  Copyright (c) 2014 Syscraft. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NMRangeSlider.h"
#import "AppDelegate.h"
#import "MBProgressHUD.h"

BOOL isREFINED;

@interface RefineViewController : UIViewController <NSURLConnectionDelegate,UITextFieldDelegate,UIPickerViewDataSource,UIPickerViewDelegate,MBProgressHUDDelegate>
{
    NSMutableArray *mArrayCategoryList;
    NSMutableData *nsDataResult;
    
    NSString *strRefineBy;
    NSString *strGender;
    NSString *strSize;
    NSString *strCurrentPrice;
    NSString *strColor;
    NSString *strMinPrice;
    NSString *strMaxPrice;
    NSString *hold_min;
    NSString *hold_max;
    NSString *callAPI;
    
    IBOutlet UILabel *lblRightSlider;
    IBOutlet UILabel *lblLeftSlider;
    
    IBOutlet UIView *viewSliderPrice;
    int iCount;
    
    IBOutlet UITextField *nametf;
    IBOutlet UITextField *descTf;
    IBOutlet UITextField *shortdescTf;
    IBOutlet UITextField *skuTf;
    IBOutlet UITextField *minPriceTf;
    IBOutlet UITextField *maxPricetf;
    NSMutableArray *taxArray;
    NSString *selectedTax;
    BOOL minSel;
    BOOL status;
    NSMutableArray *arrRefine;
}
@property(nonatomic,retain)MBProgressHUD *progressHud;
@property(nonatomic,retain)UIWindow *window;

@property (nonatomic, retain) IBOutlet UITableView *tblViewCategory;
@property (nonatomic, retain) NSMutableArray *mArrayCategoryList;
@property (nonatomic, retain) NSMutableArray *arForIPs;
@property (nonatomic, retain) NSMutableArray *arForIPs1;
@property (nonatomic, retain) NSMutableArray *arForIPs2;
@property (nonatomic, retain) NSMutableArray *arForIPs3;

@property (nonatomic, retain) NSMutableArray *mArrayContain;

@property (weak, nonatomic) IBOutlet NMRangeSlider *labelSlider;
@property (nonatomic, retain) id delegate;
- (void)updateSliderLabels;
- (void)rangeSliderValueChanged:(id)sender;

-(IBAction)backButtonPress:(id)sender;

//-(IBAction)btnDoneAction:(id)sender;

//-(IBAction)btnClearAction:(id)sender;
- (IBAction)labelSliderChanged:(NMRangeSlider*)sender;

@end
