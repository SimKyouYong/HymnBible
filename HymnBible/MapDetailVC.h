//
//  MapDetailVC.h
//  HymnBible
//
//  Created by Joseph_iMac on 2017. 3. 21..
//  Copyright © 2017년 Joseph_iMac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MFMailComposeViewController.h>

@interface MapDetailVC : UIViewController<MFMailComposeViewControllerDelegate>{
    NSInteger imageCount;
}

@property (nonatomic) NSDictionary *mapDetailDic;

@property (weak, nonatomic) IBOutlet UILabel *churchNameText;
@property (weak, nonatomic) IBOutlet UILabel *nameText;
@property (weak, nonatomic) IBOutlet UILabel *nameText2;
@property (weak, nonatomic) IBOutlet UILabel *nameText3;
@property (weak, nonatomic) IBOutlet UILabel *addrText;
@property (weak, nonatomic) IBOutlet UILabel *postText;
@property (weak, nonatomic) IBOutlet UILabel *phoneText;
@property (weak, nonatomic) IBOutlet UILabel *faxText;
@property (weak, nonatomic) IBOutlet UILabel *homepageText;
@property (weak, nonatomic) IBOutlet UILabel *introText;

- (IBAction)backButton:(id)sender;
- (IBAction)infoButton:(id)sender;
- (IBAction)closeButton:(id)sender;

@property (weak, nonatomic) IBOutlet UIView *bodyView;
@property (weak, nonatomic) IBOutlet UIImageView *churchImage;
@property (weak, nonatomic) IBOutlet UIButton *leftImageButton;
- (IBAction)leftImageButton:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *rightImageButton;
- (IBAction)rightImageButton:(id)sender;

- (IBAction)telButton:(id)sender;
- (IBAction)homepageButton:(id)sender;

@end
