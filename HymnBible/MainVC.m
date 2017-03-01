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

@interface MainVC ()

@end

@implementation MainVC

@synthesize MainWebView;
@synthesize alphaView;
@synthesize firstView;
@synthesize phoneText;
@synthesize addText;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    self.navigationController.view.backgroundColor = [UIColor colorWithRed:0.0/255.0 green:122.0/255.0 blue:255.0/255.0 alpha:1.0];
    
    NSString *urlString = [NSString stringWithFormat:@"http://shqrp5200.cafe24.com/index.do"];
    NSURL *url = [NSURL URLWithString:urlString];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    [MainWebView loadRequest:request];
    
    self.speechToTextObj = [[SpeechToTextModule alloc] initWithCustomDisplay:@"SineWaveViewController"];
    [self.speechToTextObj setDelegate:self];
    [self.view sendSubviewToBack:MainWebView];
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults synchronize];
    if([defaults stringForKey:@"FIRST_POPUP"].length == 0){
        alphaView.hidden = NO;
        firstView.hidden = NO;
    }
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
    }else{
        if(phoneText.text.length == 10 || phoneText.text.length == 10){
            NSString *urlString = [NSString stringWithFormat:@"http://shqrp5200.cafe24.com/index.do?phone=%@", phoneText.text];
            NSURLSessionConfiguration *defaultConfigObject = [NSURLSessionConfiguration defaultSessionConfiguration];
            NSURLSession *defaultSession = [NSURLSession sessionWithConfiguration: defaultConfigObject delegate: nil delegateQueue: [NSOperationQueue mainQueue]];
            NSMutableURLRequest * urlRequest = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:urlString]];
            [urlRequest setHTTPMethod:@"GET"];
            NSURLSessionDataTask * dataTask =[defaultSession dataTaskWithRequest:urlRequest completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                NSLog(@"Response:%@ %@\n", response, error);
                NSInteger statusCode = [(NSHTTPURLResponse *)response statusCode];
                if (statusCode == 200) {
                    alphaView.hidden = YES;
                    firstView.hidden = YES;
                    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
                    [defaults synchronize];
                    [defaults setObject:@"YES" forKey:@"FIRST_POPUP"];
                }
            }];
            [dataTask resume];
        }else{
            UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"알림" message:@"휴대폰 번호를 잘못 입력하였습니다." delegate:nil cancelButtonTitle:@"확인" otherButtonTitles:nil, nil];
            [alert show];
        }
    }
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
    
    if([fURL hasPrefix:@"http://shqrp5200.cafe24.com/hymn/hymn_list.do"]){
        [self performSegueWithIdentifier:@"map" sender:nil];
    }
    
    if ([[[request URL] absoluteString] hasPrefix:@"js2ios:"]){
        
        // SST
        if([fURL hasPrefix:@"js2ios://SearchSst?"]){
            [self.speechToTextObj beginRecording];
            
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
        }else if([fURL hasPrefix:@"http://hoon86.cafe24.com/hymn/hymn_list.do"]){
            [self performSegueWithIdentifier:@"map" sender:nil];
        }
        
        return NO;
    }
    
    return YES;
}

// 웹뷰가 컨텐츠를 읽기 시작한 후에 실행된다.
- (void)webViewDidStartLoad:(UIWebView *)webView{
    //NSLog(@"start");
}

// 웹뷰가 컨텐츠를 모두 읽은 후에 실행된다.
- (void)webViewDidFinishLoad:(UIWebView *)webView{
    
}

// 컨텐츠를 읽는 도중 오류가 발생할 경우 실행된다.
- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error{
    NSLog(@"ERROR : %@", error);
}

#pragma mark - 
#pragma mark SpeechToTextModule Delegate

- (BOOL)didReceiveVoiceResponse:(NSData *)data
{
    NSString *responseString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    
    NSLog(@"responseString: %@",responseString);
    
    NSArray *textArr = [responseString componentsSeparatedByString:@"transcript\":\""];
    NSString *textStr = [textArr objectAtIndex:1];
    NSArray *textArr2 = [textStr componentsSeparatedByString:@"\""];
    
    NSLog(@"%@", [textArr2 objectAtIndex:0]);
    
    NSString *sstStr = [NSString stringWithFormat:@"javascript:returnSearchSst('%@')", [textArr2 objectAtIndex:0]];
    [MainWebView stringByEvaluatingJavaScriptFromString:sstStr];
    
    return YES;
}

- (void)showSineWaveView:(SineWaveViewController *)view
{
    
}

- (void)dismissSineWaveView:(SineWaveViewController *)view cancelled:(BOOL)wasCancelled
{
    
}

- (void)showLoadingView
{
    NSLog(@"show loadingView");
}

- (void)requestFailedWithError:(NSError *)error
{
    NSLog(@"error: %@",error);
}

#pragma mark -
#pragma mark File Download

- (void)fileDown{
    NSLog(@"%@", DOCUMENT_DIRECTORY);
    NSString *downloadURL = [NSString stringWithFormat:@"http://hoon86.cafe24.com/db/%@", urlValue];;
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

@end


