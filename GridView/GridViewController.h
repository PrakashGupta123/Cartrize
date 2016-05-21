//
//  GridViewController.h
//  Cartrize
//
//  Created by Admin on 21/07/14.
//  Copyright (c) 2014 Syscraft. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GridViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,UICollectionViewDataSource, UICollectionViewDelegate>{
  
    IBOutlet UIScrollView *scroll;
    NSMutableArray *bannerArr;
    NSMutableArray *categoriesArr;
    int count;
    UIWebView *wv;
    IBOutlet UIActivityIndicatorView *activity;
    IBOutlet UITableView *productList;
    NSMutableArray *catProductList;
    IBOutlet UICollectionView *colViewObj;
    IBOutlet UIActivityIndicatorView *activity1;
    NSInteger newIndex;
    
}
@property (nonatomic, strong) NSMutableDictionary *contentOffsetDictionary;
@property (nonatomic, strong) NSArray *colorArray;

-(IBAction)logoutAction:(id)sender;
@end
