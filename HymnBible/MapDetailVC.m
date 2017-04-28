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
    
    churchNameText.text = [NSString stringWithFormat:@"교회찾기 / %@", [mapDetailDic objectForKey:@"church_name"]];
    nameText.text = [mapDetailDic objectForKey:@"church_name"];
    nameText2.text = [mapDetailDic objectForKey:@"church_type"];
    nameText3.text = [mapDetailDic objectForKey:@"person_name"];
    addrText.text = [mapDetailDic objectForKey:@"church_address"];
    postText.text = [mapDetailDic objectForKey:@"church_post"];
    phoneText.text = [mapDetailDic objectForKey:@"church_number"];
    faxText.text = [mapDetailDic objectForKey:@"church_fax"];
    homepageText.text = [mapDetailDic objectForKey:@"church_homepage"];
    introText.text = [mapDetailDic objectForKey:@"church_body"];
    
    // 연락처
    if(phoneText.text.length !=0){
        NSMutableAttributedString *phoneStr = [[NSMutableAttributedString alloc]initWithString:[mapDetailDic objectForKey:@"church_number"]];
        [phoneStr addAttribute:NSForegroundColorAttributeName value:[UIColor blueColor] range:NSMakeRange(0, phoneStr.length)];
        [phoneStr addAttribute:NSUnderlineColorAttributeName value:[UIColor blueColor] range:NSMakeRange(0, phoneStr.length)];
        [phoneStr addAttribute:NSUnderlineStyleAttributeName value:[NSNumber numberWithInt:NSUnderlineStyleSingle] range:NSMakeRange(0, phoneStr.length)];
        
        phoneText.attributedText = phoneStr;
    }
    
    // 홈페이지
    if(homepageText.text.length != 0){
        NSMutableAttributedString *homePageStr = [[NSMutableAttributedString alloc]initWithString:[mapDetailDic objectForKey:@"church_homepage"]];
        [homePageStr addAttribute:NSForegroundColorAttributeName value:[UIColor blueColor] range:NSMakeRange(0, homePageStr.length)];
        [homePageStr addAttribute:NSUnderlineColorAttributeName value:[UIColor blueColor] range:NSMakeRange(0, homePageStr.length)];
        [homePageStr addAttribute:NSUnderlineStyleAttributeName value:[NSNumber numberWithInt:NSUnderlineStyleSingle] range:NSMakeRange(0, homePageStr.length)];
        
        homepageText.attributedText = homePageStr;
    }
    

    
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
    [self displayComposerSheet];
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

    if([[mapDetailDic objectForKey:churchName] isEqualToString:@""]){
        imageCount--;
    }else{
        NSURL *imageURL = [NSURL URLWithString:[mapDetailDic objectForKey:churchName]];
        NSData *imageData = [NSData dataWithContentsOfURL:imageURL];
        churchImage.image = [UIImage imageWithData:imageData];
    }
}

- (IBAction)telButton:(id)sender {
    if(phoneText.text.length !=0){
        NSString *telValue = [NSString stringWithFormat:@"tel://%@", phoneText.text];
        telValue = [telValue stringByReplacingOccurrencesOfString:@"-" withString:@""];
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:telValue]];
    }
}

- (IBAction)homepageButton:(id)sender {
    if(homepageText.text.length !=0){
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:homepageText.text]];
    }
}

#pragma mark -
#pragma mark Mail Method

- (void)displayComposerSheet{
    if ([MFMailComposeViewController canSendMail])
    {
        MFMailComposeViewController *picker = [[MFMailComposeViewController alloc] init];
        // 델리게이트 지정
        picker.mailComposeDelegate = self;
        
        // 제목
        NSString *subjectValue = [NSString stringWithFormat:@"%@ 정보수정 요청 드립니다.", [mapDetailDic objectForKey:@"church_name"]];
        [picker setSubject:subjectValue];
        
        // 수신자
        NSArray *toRecipients = [NSArray arrayWithObject:@"sharp5200@naver.com"];
        
        // 참조
        //NSArray *ccRecipients = [NSArray arrayWithObjects:@"second@example.com", @"third@example.com", nil];
        //NSArray *bccRecipients = [NSArray arrayWithObject:@"fourth@example.com"];
        
        [picker setToRecipients:toRecipients];
        //[picker setCcRecipients:ccRecipients];
        //[picker setBccRecipients:bccRecipients];
        
        // 이미지
        //NSString *path = [[NSBundle mainBundle] pathForResource:@"rainy" ofType:@"png"];
        //NSData *myData = [NSData dataWithContentsOfFile:path];
        //[picker addAttachmentData:myData mimeType:@"image/png" fileName:@"rainy"];
        
        // 내용
        NSString *emailBody = @"*수정사항은 입력해주시고\n*사진은 첨부해주시고\n\n교회명:\n교단명:\n담임목사:\n주소:\n우편번호:\n전화:\n팩스:\n홈페이지:\n교회소개:";
        [picker setMessageBody:emailBody isHTML:NO];
        
        // 뷰 호출
        [self presentViewController:picker animated:YES completion:nil];
    }else{
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"알림" message:@"메일 계정이 없습니다."
                                                       delegate:self cancelButtonTitle:nil otherButtonTitles:@"확인" ,nil];
        [alert show];
    }
}

// 델리게이트
- (void)mailComposeController:(MFMailComposeViewController*)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error
{
    // 결과 값에 따른 상태 활용
    switch (result)
    {
            // 취소
        case MFMailComposeResultCancelled:
            //message.text = @"Result: canceled";
            break;
            // 저장
        case MFMailComposeResultSaved:
            //message.text = @"Result: saved";
            break;
            // 보내기
        case MFMailComposeResultSent:
            //message.text = @"Result: sent";
            break;
            // 실패
        case MFMailComposeResultFailed:
            //message.text = @"Result: failed";
            break;
        default:
            //message.text = @"Result: not sent";
            break;
    }
    // 메일 보내기 창 닫기
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
