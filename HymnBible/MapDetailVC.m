//
//  MapDetailVC.m
//  HymnBible
//
//  Created by Joseph_iMac on 2017. 3. 21..
//  Copyright © 2017년 Joseph_iMac. All rights reserved.
//

#import "MapDetailVC.h"

@interface MapDetailVC ()

@end

@implementation MapDetailVC

@synthesize mapDetailDic;
@synthesize churchNameText;
@synthesize nameText;
@synthesize nameText2;
@synthesize nameText3;
@synthesize addrText;
@synthesize postText;
@synthesize phoneText;
@synthesize faxText;
@synthesize homepageText;
@synthesize introText;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    self.navigationController.view.backgroundColor = [UIColor colorWithRed:0.0/255.0 green:122.0/255.0 blue:255.0/255.0 alpha:1.0];
    
    //NSLog(@"mapDetailDic : %@", mapDetailDic);
    
    churchNameText.text = [mapDetailDic objectForKey:@"church_name"];
    nameText.text = [mapDetailDic objectForKey:@"church_name"];
    nameText2.text = [mapDetailDic objectForKey:@"church_type"];
    nameText3.text = [mapDetailDic objectForKey:@"person_name"];
    addrText.text = [mapDetailDic objectForKey:@"church_address"];
    postText.text = [mapDetailDic objectForKey:@"church_post"];
    phoneText.text = [mapDetailDic objectForKey:@"church_number"];
    faxText.text = [mapDetailDic objectForKey:@"church_fax"];
    homepageText.text = [mapDetailDic objectForKey:@"church_homepage"];
    introText.text = [mapDetailDic objectForKey:@"church_body"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

- (IBAction)backButton:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)infoButton:(id)sender {
}

- (IBAction)closeButton:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

@end
