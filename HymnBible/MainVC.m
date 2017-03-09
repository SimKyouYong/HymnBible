//
//  MainVC.m
//  HymnBible
//
//  Created by Joseph_iMac on 2017. 1. 24..
//  Copyright © 2017년 Joseph_iMac. All rights reserved.
//

#define DOCUMENT_DIRECTORY [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject]

#import "MainVC.h"
#import "MusicVC.h"
#import "MapVC.h"
#import <sqlite3.h>
#import "GlobalHeader.h"
#import "UIImage+animatedGIF.h"
#import "SpeechToTextModule.h"

@interface MainVC () <SpeechToTextModuleDelegate>  {
    SpeechToTextModule *speechToTextModule;
    BOOL isRecording;
}
@end

@implementation MainVC

@synthesize MainWebView;
@synthesize alphaView;
@synthesize firstView;
@synthesize phoneText;
@synthesize addText;
@synthesize agreeCheckButton;
@synthesize agreeTextButton;
@synthesize addView;
@synthesize addText2;
@synthesize animationImageView;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    self.navigationController.view.backgroundColor = [UIColor colorWithRed:0.0/255.0 green:122.0/255.0 blue:255.0/255.0 alpha:1.0];
    
    NSString *urlString = [NSString stringWithFormat:MAIN_URL];
    NSURL *url = [NSURL URLWithString:urlString];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    [MainWebView loadRequest:request];
    
    speechToTextModule = [[SpeechToTextModule alloc] initWithCustomDisplay:nil];
    [speechToTextModule setDelegate:self];
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults synchronize];
    if([defaults stringForKey:POPUP_CHECK].length == 0){
        alphaView.hidden = NO;
        firstView.hidden = NO;
        
        NSMutableAttributedString *title = [[NSMutableAttributedString alloc] initWithString:@"개인정보이용동의"];
        [title addAttribute:NSForegroundColorAttributeName value:[UIColor blackColor] range:NSMakeRange(0, [title length])];
        [title addAttribute:NSUnderlineStyleAttributeName value:[NSNumber numberWithInteger:NSUnderlineStyleSingle] range:NSMakeRange(0, [title length])];
        [agreeTextButton setAttributedTitle:title forState:UIControlStateNormal];
    }
}

- (void)viewWillDisappear:(BOOL)animated {
    [self stopRecording];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSString *)decodeStr:(NSString *)str{
    
    CFStringRef s = CFURLCreateStringByReplacingPercentEscapesUsingEncoding(NULL, (CFStringRef)str, CFSTR(""), kCFStringEncodingUTF8);
    NSString* decoded = [NSString stringWithFormat:@"%@", (__bridge NSString*)s];
    CFRelease(s);
    return decoded;
}

#pragma mark -
#pragma mark Button Action

- (IBAction)submitButton:(id)sender {
    if(phoneText.text.length == 0){
        UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"알림" message:@"휴대폰 번호는 필수 입력입니다." delegate:nil cancelButtonTitle:@"확인" otherButtonTitles:nil, nil];
        [alert show];
        
        return;
    }
    if(agreeCheckButton.selected == 0){
        UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"알림" message:@"개인정보이용 동의에 체크해주세요." delegate:nil cancelButtonTitle:@"확인" otherButtonTitles:nil, nil];
        [alert show];
        
        return;
    }
    
    [self loadingInit];
    
    if(phoneText.text.length == 10 || phoneText.text.length == 11){
        NSString *urlString = [NSString stringWithFormat:@"%@index.do?phone=%@", MAIN_URL, phoneText.text];
        NSURLSessionConfiguration *defaultConfigObject = [NSURLSessionConfiguration defaultSessionConfiguration];
        NSURLSession *defaultSession = [NSURLSession sessionWithConfiguration: defaultConfigObject delegate: nil delegateQueue: [NSOperationQueue mainQueue]];
        NSMutableURLRequest * urlRequest = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:urlString]];
        [urlRequest setHTTPMethod:@"GET"];
        NSURLSessionDataTask * dataTask =[defaultSession dataTaskWithRequest:urlRequest completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
            //NSLog(@"Response:%@ %@\n", response, error);
            NSInteger statusCode = [(NSHTTPURLResponse *)response statusCode];
            if (statusCode == 200) {
                if(addText.text.length == 0){
                    alphaView.hidden = YES;
                    firstView.hidden = YES;
                    
                    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
                    [defaults synchronize];
                    [defaults setObject:@"YES" forKey:POPUP_CHECK];
                    [defaults setObject:phoneText.text forKey:MY_ID];
                }else{
                    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
                    [defaults synchronize];
                    [defaults setObject:phoneText.text forKey:MY_ID];
                }
                
                [self httpInit1];
            }
        }];
        [dataTask resume];
    }else{
        UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"알림" message:@"휴대폰 번호를 잘못 입력하였습니다." delegate:nil cancelButtonTitle:@"확인" otherButtonTitles:nil, nil];
        [alert show];
        
        [self loadingClose];
    }
}

- (IBAction)agreeCheckButton:(id)sender {
    UIButton *button = (UIButton *) sender;
    button.selected = !button.selected;
    
    if(button.selected == 1){
        [agreeCheckButton setImage:[UIImage imageNamed:@"check_on"] forState:UIControlStateNormal];
    }else{
        [agreeCheckButton setImage:[UIImage imageNamed:@"check_off"] forState:UIControlStateNormal];
    }
}

- (IBAction)agreeTextButton:(id)sender {
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://www.naver.com"]];
}

// 최초 폰번호 겟으로 통신 후 토큰키 포스트로
- (void)httpInit1{
    [phoneText resignFirstResponder];
    [addText resignFirstResponder];
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults synchronize];
    
    NSString *urlString = [NSString stringWithFormat:@"%@", DB_ADD_URL];
    NSURLSessionConfiguration *defaultConfigObject = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *defaultSession = [NSURLSession sessionWithConfiguration: defaultConfigObject delegate: nil delegateQueue: [NSOperationQueue mainQueue]];
    NSMutableURLRequest * urlRequest = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:urlString]];
    NSString *params = [NSString stringWithFormat:@"phone=%@&reg_id=%@&type=ios", phoneText.text, [defaults stringForKey:TOKEN_KEY]];
    
    [urlRequest setHTTPMethod:@"POST"];
    [urlRequest setHTTPBody:[params dataUsingEncoding:NSUTF8StringEncoding]];
    
    NSURLSessionDataTask * dataTask =[defaultSession dataTaskWithRequest:urlRequest completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        //NSLog(@"Response:%@ %@\n", response, error);
        NSInteger statusCode = [(NSHTTPURLResponse *)response statusCode];
        if (statusCode == 200) {
            if(addText.text.length == 0){
                alphaView.hidden = YES;
                firstView.hidden = YES;
                [self loadingClose];
            }else{
                [self httpInit2];
            }
        }
    }];
    [dataTask resume];
}

// 추천인 있으면 통신
- (void)httpInit2{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults synchronize];
    
    NSString *urlString = [NSString stringWithFormat:@"%@json/recommender-proc.do", MAIN_URL];
    NSURLSessionConfiguration *defaultConfigObject = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *defaultSession = [NSURLSession sessionWithConfiguration: defaultConfigObject delegate: nil delegateQueue: [NSOperationQueue mainQueue]];
    
    NSMutableURLRequest * urlRequest = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:urlString]];
    NSString *params = [NSString stringWithFormat:@"my_id=%@&user_id=%@", [defaults stringForKey:MY_ID], addText.text];
    [urlRequest setHTTPMethod:@"POST"];
    [urlRequest setHTTPBody:[params dataUsingEncoding:NSUTF8StringEncoding]];
    
    NSURLSessionDataTask * dataTask =[defaultSession dataTaskWithRequest:urlRequest completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        //NSLog(@"Response:%@ %@\n", response, error);
        NSInteger statusCode = [(NSHTTPURLResponse *)response statusCode];
        if (statusCode == 200) {
            
        }else{
            UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"알림" message:@"통신에러" delegate:nil cancelButtonTitle:@"확인" otherButtonTitles:nil, nil];
            [alert show];
        }
        
        alphaView.hidden = YES;
        firstView.hidden = YES;
        [self loadingClose];
    }];
    [dataTask resume];
}

// 추천인 팝업뷰
- (IBAction)submitButton2:(id)sender {
    [self httpInit2];
}

#pragma mark -
#pragma mark StoryBoard Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue identifier] isEqualToString:@"music"])
    {
        MusicVC *vc = [segue destinationViewController];
        vc.musicURL = musicURLValue;
    }
    if ([[segue identifier] isEqualToString:@"map"])
    {
        //MapVC *vc = [segue destinationViewController];
        
    }
}

#pragma mark -
#pragma mark Webview Delegate

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType{
    fURL = [NSString stringWithFormat:@"%@", request.URL];
    fURL = [self decodeStr:fURL];
    NSLog(@"fURL : %@", fURL);

    if ([[[request URL] absoluteString] hasPrefix:@"js2ios:"]){
        
        // SST
        if([fURL hasPrefix:@"js2ios://SearchSst?"]){
            alphaView.hidden = NO;
            [self startRecording];
            
        // 성경(DB)
        }else if([fURL hasPrefix:@"js2ios://DBSQL?"]){
            NSArray *dbArr1 = [fURL componentsSeparatedByString:@"db="];
            NSString *dbStr1 = [dbArr1 objectAtIndex:1];
            NSArray *dbArr2 = [dbStr1 componentsSeparatedByString:@"&"];
            urlValue = [dbArr2 objectAtIndex:0];
            
            NSArray *sqlArr1 = [fURL componentsSeparatedByString:@"sql="];
            NSString *sqlStr1 = [sqlArr1 objectAtIndex:1];
            NSArray *sqlArr2 = [sqlStr1 componentsSeparatedByString:@"&"];
            sqlValue = [sqlArr2 objectAtIndex:0];
            
            NSArray *searchArr1 = [fURL componentsSeparatedByString:@"search="];
            NSString *searchStr1 = [searchArr1 objectAtIndex:1];
            NSArray *searchArr2 = [searchStr1 componentsSeparatedByString:@"&"];
            searchValue = [searchArr2 objectAtIndex:0];
            
            NSArray *returnArr1 = [fURL componentsSeparatedByString:@"return="];
            NSString *returnStr1 = [returnArr1 objectAtIndex:1];
            NSArray *returnArr2 = [returnStr1 componentsSeparatedByString:@"&"];
            returnValue = [returnArr2 objectAtIndex:0];
            
            [self sqlLoad];
        
        // 다운로드
        }else if([fURL hasPrefix:@"js2ios://DownLoadDB?"]){
            NSArray *urlArr1 = [fURL componentsSeparatedByString:@"url="];
            NSString *urlStr1 = [urlArr1 objectAtIndex:1];
            NSArray *urlArr2 = [urlStr1 componentsSeparatedByString:@"&"];
            urlValue = [urlArr2 objectAtIndex:0];
            
            NSArray *nameArr1 = [fURL componentsSeparatedByString:@"name="];
            NSString *nameStr1 = [nameArr1 objectAtIndex:1];
            NSArray *nameArr2 = [nameStr1 componentsSeparatedByString:@"&"];
            nameValue = [nameArr2 objectAtIndex:0];
            
            NSArray *returnArr1 = [fURL componentsSeparatedByString:@"return="];
            NSString *returnStr1 = [returnArr1 objectAtIndex:1];
            NSArray *returnArr2 = [returnStr1 componentsSeparatedByString:@"&"];
            returnValue = [returnArr2 objectAtIndex:0];
            
            [self fileDown];
        
        // 악보 확대
        }else if([fURL hasPrefix:@"js2ios://ImageView?"]){
            NSArray *urlArr1 = [fURL componentsSeparatedByString:@"str="];
            NSString *urlStr1 = [urlArr1 objectAtIndex:1];
            NSArray *urlArr2 = [urlStr1 componentsSeparatedByString:@"&"];
            musicURLValue = [urlArr2 objectAtIndex:0];
            
            [self performSegueWithIdentifier:@"music" sender:nil];
        
        // 교회 찾기
        }else if([fURL hasPrefix:@"js2ios://ChurchSearch?"]){
            [self performSegueWithIdentifier:@"map" sender:nil];
        
            // 설정(푸시)
        }else if([fURL hasPrefix:@"js2ios://GetPush?"]){
            NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
            [defaults synchronize];
            
            NSArray *urlArr1 = [fURL componentsSeparatedByString:@"str="];
            NSString *urlStr1 = [urlArr1 objectAtIndex:1];
            NSArray *urlArr2 = [urlStr1 componentsSeparatedByString:@"&"];
            NSString *pushValue = [urlArr2 objectAtIndex:0];
            NSLog(@"%@", pushValue);
            
            NSString *srciptValue = @"";
            if([pushValue isEqualToString:@"ALL"]){
                srciptValue = [NSString stringWithFormat:@"javascript:return_fun('PUSH','PUSHSOUND','PUSHVALIT')"];
                
                [defaults setObject:@"ALL" forKey:PUSH_SETTING];
            }else{
                if([pushValue isEqualToString:@""]){
                    srciptValue = [NSString stringWithFormat:@"javascript:return_fun('off')"];
                    
                    [defaults setObject:@"off" forKey:PUSH_SETTING];
                }else{
                    srciptValue = [NSString stringWithFormat:@"javascript:return_fun('%@')", pushValue];
                    
                    [defaults setObject:pushValue forKey:PUSH_SETTING];
                }
            }
            
            [MainWebView stringByEvaluatingJavaScriptFromString:pushValue];
        }
        
        return NO;
    }
    
    return YES;
}

// 웹뷰가 컨텐츠를 읽기 시작한 후에 실행된다.
- (void)webViewDidStartLoad:(UIWebView *)webView{
    //NSLog(@"start");
    
    [self loadingInit];
}

// 웹뷰가 컨텐츠를 모두 읽은 후에 실행된다.
- (void)webViewDidFinishLoad:(UIWebView *)webView{
    [self loadingClose];
}

// 컨텐츠를 읽는 도중 오류가 발생할 경우 실행된다.
- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error{
    NSLog(@"ERROR : %@", error);
}

#pragma mark -
#pragma mark SpeechToTextModule Delegate

- (void)startRecording {
    if (isRecording == NO) {
        NSURL *url = [[NSBundle mainBundle] URLForResource:@"recording_animate" withExtension:@"gif"];
        animationImageView.image = [UIImage animatedImageWithAnimatedGIFURL:url];
        animationImageView.hidden = NO;
        [speechToTextModule beginRecording];
        isRecording = YES;
    }
}

- (void)stopRecording {
    if (isRecording) {
        animationImageView.hidden = YES;
        [speechToTextModule stopRecording:YES];
        isRecording = NO;
    }
}

- (BOOL)didReceiveVoiceResponse:(NSDictionary *)data {
    
    NSLog(@"data %@",data);
    [self stopRecording];
    NSString *result = @"";
    id tmp = data[@"transcript"];
    if ([tmp isKindOfClass:[NSNumber class]] || [tmp rangeOfCharacterFromSet:[[NSCharacterSet decimalDigitCharacterSet] invertedSet]].location == NSNotFound) {
        
        NSNumber *resultNumber = [NSNumber numberWithInteger:[tmp integerValue]];
        NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
        [formatter setNumberStyle:NSNumberFormatterSpellOutStyle];
        result = [formatter stringFromNumber:resultNumber];
    } else {
        result = tmp;
    }
   
    if (result == nil) {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Error" message:@"Please pronouce the word or check your microphone" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
    }
    else {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Wrong" message:[NSString stringWithFormat:@"You pronouced \"%@\". You better try again", result] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
        
        NSString *sstStr = [NSString stringWithFormat:@"javascript:returnSearchSst('%@')", result];
        [MainWebView stringByEvaluatingJavaScriptFromString:sstStr];
        
        alphaView.hidden = YES;
    }
    
    return YES;
}

#pragma mark -
#pragma mark File Download

- (void)fileDown{
    NSLog(@"%@", DOCUMENT_DIRECTORY);
    NSString *downloadURL = [NSString stringWithFormat:@"%@/db/%@", MAIN_URL, urlValue];;
    NSString *filePath = [NSString stringWithFormat:@"%@/%@", DOCUMENT_DIRECTORY, urlValue];
    BOOL fileExists = [[NSFileManager defaultManager] fileExistsAtPath:filePath];
    
    // 파일이 없으면 다운로드 시작
    if (!fileExists) {
        ASIHTTPRequest *request;
        request = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:downloadURL]];
        [request setDownloadDestinationPath:[DOCUMENT_DIRECTORY stringByAppendingFormat:@"/%@", urlValue]];
        [request setDelegate:self];
        [request setDidFinishSelector:@selector(requestFinished:)];
        [request setDidFailSelector:@selector(requestFailed:)];
        [request startSynchronous];
    }
}

- (void)requestFailed:(ASIHTTPRequest *)request{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"알림" message:@"네트워크 오류로 인해 다운로드를 실패하였습니다."
                                                   delegate:self cancelButtonTitle:nil otherButtonTitles:@"확인" ,nil];
    [alert show];
}

- (void)requestFinished:(ASIHTTPRequest *)request{
    NSLog(@"suc");
}

- (void)sqlLoad{
    [MainWebView stopLoading];
    
    sqlite3 *sqlite3Init = nil;
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *path = [documentsDirectory stringByAppendingPathComponent:urlValue];
    
    if (sqlite3_open([path UTF8String], &sqlite3Init) != SQLITE_OK) {
        sqlite3_close(sqlite3Init);
        NSAssert1(0, @"Failed to open database with message '%s'.", sqlite3_errmsg(sqlite3Init));
    }
    
    sqlite3 *database;
    if (sqlite3_open([path UTF8String], &database) != SQLITE_OK) {
        sqlite3_close(database);
        NSLog(@"Error");
    }
    
    const char *selectSql = [sqlValue UTF8String];
    sqlite3_stmt *selectStatement;

    NSMutableString *sqlStr = [NSMutableString string];
    
    if (sqlite3_prepare_v2(database, selectSql, -1, &selectStatement, NULL) == SQLITE_OK) {
        // while문을 돌면서 각 레코드의 데이터를 받아서 출력한다.
        while (sqlite3_step(selectStatement)==SQLITE_ROW) {
            NSString *col1 = [NSString stringWithUTF8String:(char *)sqlite3_column_text(selectStatement, 0)];
            NSString *col2 = [NSString stringWithUTF8String:(char *)sqlite3_column_text(selectStatement, 1)];
            NSString *col3 = [NSString stringWithUTF8String:(char *)sqlite3_column_text(selectStatement, 2)];
            NSString *col4 = [NSString stringWithUTF8String:(char *)sqlite3_column_text(selectStatement, 3)];
            NSString *col5 = [NSString stringWithUTF8String:(char *)sqlite3_column_text(selectStatement, 4)];
            NSString *col6 = [NSString stringWithUTF8String:(char *)sqlite3_column_text(selectStatement, 5)];
            
            NSLog(@"1 : %@, 2 : %@, 3 : %@, 4 : %@, 5 : %@, 6 : %@", col1, col2, col3, col4, col5, col6);
            
            NSString *colValue = [NSString stringWithFormat:@"{\"col_6\":\"%@\",\"col_5\":\"%@\",\"col_4\":\"%@\",\"col_3\":\"%@\",\"col_2\":\"%@\",\"col_1\":\"%@\"}", col6, col5, col4, col3, col2, col1];
                
            [sqlStr length] != 0 ?
            [sqlStr appendFormat:@",%@", colValue] : [sqlStr appendFormat:@"%@", colValue];
        }
    }
    
    sqlite3_finalize(selectStatement);
    sqlite3_close(database);
    
    [MainWebView stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat:@"javascript:%@([%@])", returnValue, sqlStr]];
}

#pragma mark -
#pragma mark Text Field

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

#pragma mark -
#pragma mark Loading Method

- (void)loadingInit{
    // 로딩관련
    loadingView = [[UIView alloc] initWithFrame:CGRectMake((self.view.frame.size.width - 170)/2, (self.view.frame.size.height - 170)/2, 170, 170)];
    loadingView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
    loadingView.clipsToBounds = YES;
    loadingView.layer.cornerRadius = 10.0;
    
    activityView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    activityView.frame = CGRectMake(65, 40, activityView.bounds.size.width, activityView.bounds.size.height);
    [loadingView addSubview:activityView];
    
    loadingLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 115, 130, 42)];
    loadingLabel.backgroundColor = [UIColor clearColor];
    loadingLabel.numberOfLines = 2;
    loadingLabel.textColor = [UIColor whiteColor];
    loadingLabel.adjustsFontSizeToFitWidth = YES;
    loadingLabel.textAlignment = NSTextAlignmentCenter;
    loadingLabel.text = [NSString stringWithFormat:@"로딩중..."];
    [loadingView addSubview:loadingLabel];
    
    [self.view addSubview:loadingView];
    [self.view bringSubviewToFront:loadingView];
    [activityView startAnimating];
}

- (void)loadingClose{
    loadingView.hidden = YES;
    [activityView stopAnimating];
}

@end


