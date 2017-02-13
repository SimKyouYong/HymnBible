//
//  MusicVC.m
//  HymnBible
//
//  Created by Joseph_iMac on 2017. 2. 13..
//  Copyright © 2017년 Joseph_iMac. All rights reserved.
//

#import "MusicVC.h"

@interface MusicVC ()

@end

@implementation MusicVC

@synthesize webview;
@synthesize musicURL;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSURL *url = [NSURL URLWithString:musicURL];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    [webview loadRequest:request];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)closeButton:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

@end
