//
//  MainVC.h
//  HymnBible
//
//  Created by Joseph_iMac on 2017. 1. 24..
//  Copyright © 2017년 Joseph_iMac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SpeechToTextModule.h"
#import "HTTPNetworkManager.h"

@interface MainVC : UIViewController<SpeechToTextModuleDelegate, ASIHTTPRequestDelegate>{
    NSString *fURL;
    
    HTTPNetworkManager *requestDownload;
    
    NSString *urlValue;
    NSString *sqlValue;
    NSString *searchValue;
    NSString *returnValue;
    NSString *nameValue;
    NSString *musicURLValue;
}

@property (weak, nonatomic) IBOutlet UIWebView *MainWebView;
@property (weak, nonatomic) IBOutlet UIView *alphaView;
@property (weak, nonatomic) IBOutlet UIView *firstView;
@property (weak, nonatomic) IBOutlet UITextField *phoneText;
@property (weak, nonatomic) IBOutlet UITextField *addText;
- (IBAction)submitButton:(id)sender;



@property(nonatomic, strong)SpeechToTextModule *speechToTextObj;

@end
