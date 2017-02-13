//
//  MusicVC.h
//  HymnBible
//
//  Created by Joseph_iMac on 2017. 2. 13..
//  Copyright © 2017년 Joseph_iMac. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MusicVC : UIViewController

@property (weak, nonatomic) IBOutlet UIWebView *webview;

@property (nonatomic) NSString  *musicURL;

- (IBAction)closeButton:(id)sender;

@end
