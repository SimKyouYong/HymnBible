//
//  MapDetailVC.h
//  HymnBible
//
//  Created by Joseph_iMac on 2017. 3. 21..
//  Copyright © 2017년 Joseph_iMac. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MapDetailVC : UIViewController

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

@end
