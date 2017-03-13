//
//  MainVC.h
//  HymnBible
//
//  Created by Joseph_iMac on 2017. 1. 24..
//  Copyright © 2017년 Joseph_iMac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HTTPNetworkManager.h"

@interface MainVC : UIViewController<ASIHTTPRequestDelegate>{
    NSString *fURL;
    
    HTTPNetworkManager *requestDownload;
    
    NSString *urlValue;
    NSString *sqlValue;
    NSString *searchValue;
    NSString *returnValue;
    NSString *nameValue;
    NSString *musicURLValue;
    
    UIActivityIndicatorView *activityView;
    UIView *loadingView;
    UILabel *loadingLabel;
}

@property (weak, nonatomic) IBOutlet UIWebView *MainWebView;
@property (weak, nonatomic) IBOutlet UIView *alphaView;
@property (weak, nonatomic) IBOutlet UIView *firstView;
@property (weak, nonatomic) IBOutlet UITextField *phoneText;
@property (weak, nonatomic) IBOutlet UITextField *addText;
- (IBAction)submitButton:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *agreeCheckButton;
- (IBAction)agreeCheckButton:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *agreeTextButton;
- (IBAction)agreeTextButton:(id)sender;

@property (weak, nonatomic) IBOutlet UIView *addView;
@property (weak, nonatomic) IBOutlet UITextField *addText2;
- (IBAction)submitButton2:(id)sender;

@property (weak, nonatomic) IBOutlet UIImageView *animationImageView;
@property (weak, nonatomic) IBOutlet UIView *loadingAlphaView;

@end
