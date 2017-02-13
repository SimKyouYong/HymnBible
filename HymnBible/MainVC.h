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
}

@property (weak, nonatomic) IBOutlet UIWebView *MainWebView;

@property(nonatomic, strong)SpeechToTextModule *speechToTextObj;

@end
