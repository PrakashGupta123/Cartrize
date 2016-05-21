//
//  CMSPageViewController.h
//  IShop
//
//  Created by Avnish Sharma on 7/18/14.
//  Copyright (c) 2014 Syscraft. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CMSPageViewController : UIViewController<UIWebViewDelegate>
{
    
}
@property(nonatomic ,retain)NSString *strTitle,*strDescreption;
@property(nonatomic ,retain)IBOutlet UILabel *lblTitle;
@property(nonatomic ,retain)IBOutlet UIWebView *webViewCMS;

@end
