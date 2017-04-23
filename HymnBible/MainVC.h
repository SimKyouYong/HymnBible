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
    
    // 추천인(메인 : 0, 설정 : 1)
    NSInteger addNum;
}

@property (weak, nonatomic) IBOutlet UIWebView *MainWebView;
@property (weak, nonatomic) IBOutlet UIView *alphaView;

@property (weak, nonatomic) IBOutlet UIView *addView;
@property (weak, nonatomic) IBOutlet UITextField *addText2;
- (IBAction)submitButton2:(id)sender;
- (IBAction)cancelButton:(id)sender;

@property (weak, nonatomic) IBOutlet UIImageView *animationImageView;
@property (weak, nonatomic) IBOutlet UIView *loadingAlphaView;
@property (weak, nonatomic) IBOutlet UILabel *sttText;
@property (weak, nonatomic) IBOutlet UIButton *closeButton;
- (IBAction)closeButton:(id)sender;

@end
