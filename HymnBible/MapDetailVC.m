//
//  MapDetailVC.m
//  HymnBible
//
//  Created by Joseph_iMac on 2017. 3. 21..
//  Copyright © 2017년 Joseph_iMac. All rights reserved.
//

#import "MapDetailVC.h"
#import "GlobalHeader.h"

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
@synthesize churchImage;
@synthesize bodyView;
@synthesize leftImageButton;
@synthesize rightImageButton;

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
    
    if([[mapDetailDic objectForKey:@"church_img"] isEqualToString:@""]){
        
    }else{
        imageCount = 1;
        NSURL *imageURL = [NSURL URLWithString:[mapDetailDic objectForKey:@"church_img"]];
        NSData *imageData = [NSData dataWithContentsOfURL:imageURL];
        churchImage.image = [UIImage imageWithData:imageData];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)viewDidLayoutSubviews{
    [super viewDidLayoutSubviews];
    
    if([[mapDetailDic objectForKey:@"church_img"] isEqualToString:@""]){
        churchImage.hidden = YES;
        leftImageButton.hidden = YES;
        rightImageButton.hidden = YES;
        bodyView.frame = CGRectMake(10, 80, self.view.frame.size.width - 20, 280);
    }
}

- (IBAction)backButton:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)infoButton:(id)sender {
}

- (IBAction)closeButton:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)leftImageButton:(id)sender {
    imageCount--;
    if(imageCount == 0){
        imageCount = 1;
    }
    
    NSString *churchName = [NSString stringWithFormat:@"church_img%ld", imageCount];
    
    if(imageCount == 1){
        churchName = [NSString stringWithFormat:@"church_img"];
    }
    
    NSURL *imageURL = [NSURL URLWithString:[mapDetailDic objectForKey:churchName]];
    NSData *imageData = [NSData dataWithContentsOfURL:imageURL];
    churchImage.image = [UIImage imageWithData:imageData];
}

- (IBAction)rightImageButton:(id)sender {
    imageCount++;
    NSString *churchName = [NSString stringWithFormat:@"church_img%ld", imageCount];
    NSLog(@"%@", churchName);
    if([[mapDetailDic objectForKey:churchName] isEqualToString:@""]){
        imageCount--;
    }else{
        NSURL *imageURL = [NSURL URLWithString:[mapDetailDic objectForKey:churchName]];
        NSData *imageData = [NSData dataWithContentsOfURL:imageURL];
        churchImage.image = [UIImage imageWithData:imageData];
    }
}

@end
