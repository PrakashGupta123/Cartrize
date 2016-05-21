//
//  CMSPageViewController.m
//  IShop
//
//  Created by Avnish Sharma on 7/18/14.
//  Copyright (c) 2014 Syscraft. All rights reserved.
//

#import "CMSPageViewController.h"

@interface CMSPageViewController ()

@end

@implementation CMSPageViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.lblTitle.text = _strTitle;
    //create the string
    NSMutableString *html = [NSMutableString stringWithString: @"<html><head><title></title></head><body style=\"background:transparent;\"> <span style=\"font-family: Myriad Pro; font-size: 15px\"></span>"];
    //continue building the string
    [html appendString:_strDescreption];
    [html appendString:@"</body></html>"];
    //make the background transparent
    [_webViewCMS setBackgroundColor:[UIColor clearColor]];
    [_webViewCMS setOpaque:NO];
    //pass the string to the webview
    [_webViewCMS loadHTMLString:[html description] baseURL:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(IBAction)actionBack:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}


@end
