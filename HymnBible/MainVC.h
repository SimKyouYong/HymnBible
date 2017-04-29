//
//  MainVC.h
//  HymnBible
//
//  Created by Joseph_iMac on 2017. 1. 24..
//  Copyright © 2017년 Joseph_iMac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HTTPNetworkManager.h"
#import <MessageUI/MFMailComposeViewController.h>
#import <AVFoundation/AVFoundation.h>

@interface MainVC : UIViewController<ASIHTTPRequestDelegate, MFMailComposeViewControllerDelegate>{
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
    
    // 찬송가 상세화면에서 백했을때 로딩바 안나오게
    NSInteger musicFlag;
    
    AVSpeechSynthesizer *synthesizer;
    
    NSUserDefaults *defaults;
}

@property (weak, nonatomic) IBOutlet UIWebView *MainWebView;
@property (weak, nonatomic) IBOutlet UIView *alphaView;

// 최초 실행시 본인 휴대폰 번호랑 추천인 입력
@property (weak, nonatomic) IBOutlet UIView *firstView;
@property (weak, nonatomic) IBOutlet UITextField *phoneText;
@property (weak, nonatomic) IBOutlet UITextField *addText;
- (IBAction)firstSubmitButton:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *firstSubmitButton;

// 설정에서 추천인 입력 뷰
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

@interface UIWebView (Javascript)
- (void)webView:(UIWebView *)sender runJavaScriptAlertPanelWithMessage:(NSString *)message     initiatedByFrame:(id *)frame;
@end
