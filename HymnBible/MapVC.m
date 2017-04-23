//
//  MapVC.m
//  HymnBible
//
//  Created by Joseph_iMac on 2017. 2. 23..
//  Copyright © 2017년 Joseph_iMac. All rights reserved.
//

#import "MapVC.h"
#import "GlobalHeader.h"
#import "JPSThumbnailAnnotation.h"
#import "MapDetailVC.h"
#import "SpeechToTextModule.h"
#import "UIImage+animatedGIF.h"

@interface MapVC ()<SpeechToTextModuleDelegate>  {
    SpeechToTextModule *speechToTextModule;
    BOOL isRecording;
}
@end

@implementation MapVC

@synthesize alphaView;
@synthesize animationView;
@synthesize sttText;
@synthesize mkView;
@synthesize addressText;
@synthesize mapTableView;
@synthesize searchResultText;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    speechToTextModule = [[SpeechToTextModule alloc] initWithCustomDisplay:nil];
    [speechToTextModule setDelegate:self];
    
    searchResultText.text = @"";
    
    mapFirstCheck = 0;
    arrIndexNum = 0;
    
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    self.navigationController.view.backgroundColor = [UIColor colorWithRed:0.0/255.0 green:122.0/255.0 blue:255.0/255.0 alpha:1.0];
    
    // Map View
    mkMapView = [[MKMapView alloc] initWithFrame:mkView.bounds];
    mkMapView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    mkMapView.delegate = self;
    mkMapView.showsUserLocation = YES;
    [mkMapView setMapType:MKMapTypeStandard];
    [mkView addSubview:mkMapView];
    
}

- (void)viewWillDisappear:(BOOL)animated {
    [self stopRecording];
}

- (MKAnnotationView *)mapView:(MKMapView *)aMapView viewForAnnotation:(id <MKAnnotation>)annotation {
    static NSString *placeMarkIdentifier = @"my annotation identifier";
    
    if ([annotation isKindOfClass:[Pin class]]) {
        MKAnnotationView *annotationView = (MKPinAnnotationView *)[mkMapView dequeueReusableAnnotationViewWithIdentifier:placeMarkIdentifier];
        if (annotationView == nil) {
            annotationView = [[MKAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:placeMarkIdentifier];
            annotationView.image = [UIImage imageNamed:@"pin"];//[annotation subtitle]];
            annotationView.canShowCallout = YES;
            annotationView.tag = aMapView.tag;
            NSLog(@"%@", annotation.title);
            
            NSString *imgName = @"";
            NSData *imageData;
            for(int i = 0; i < [churchArr count]; i++){
                NSDictionary *dic = [churchArr objectAtIndex:i];
                if([annotation.title isEqualToString:[dic objectForKey:@"church_name"]]){
                    imgName = [dic objectForKey:@"church_img"];
                    break;
                }
            }
            
            if([imgName isEqualToString:@""]){
                imageData = nil;
            }else{
                NSURL *imageURL = [NSURL URLWithString:imgName];
                imageData = [NSData dataWithContentsOfURL:imageURL];
            }
            
            UIImageView *myImageView = [[UIImageView alloc] initWithImage:[UIImage imageWithData:imageData]];
            myImageView.frame = CGRectMake(0,0,31,31);

            annotationView.leftCalloutAccessoryView = myImageView;
            myImageView = nil;
        }
        else
            annotationView.annotation = annotation;
        return annotationView;
    }
    return nil;
}

- (void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control
{
    /*
    if(![mapCount isEqualToString:@"1"]){
        mapTitleClickArr = [[NSMutableArray alloc] init];
        id AppID = [[UIApplication sharedApplication] delegate];
        mapTitleClickArr = [AppID selectMapCityName:view.annotation.title];
        mapTitle = view.annotation.title;
        bottomImageView.image = nil;
        bottomTitle.text = @"";
        bottomContent.text = @"";
        loadCount = 2;
        //[self mapUILoad];
    }
     */
}

- (void)mapView:(MKMapView *)mapView didSelectAnnotationView:(MKAnnotationView *)view
{
    
}

- (void)churchJsonParsing{
    NSString *urlString = [NSString stringWithFormat:@"%@", SEARCH_URL];
    NSURLSessionConfiguration *defaultConfigObject = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *defaultSession = [NSURLSession sessionWithConfiguration: defaultConfigObject delegate: nil delegateQueue: [NSOperationQueue mainQueue]];
    
    NSMutableURLRequest * urlRequest = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:urlString]];
    NSString *params = [NSString stringWithFormat:@"type=%@", addressText.text];
    [urlRequest setHTTPMethod:@"POST"];
    [urlRequest setHTTPBody:[params dataUsingEncoding:NSUTF8StringEncoding]];
    
    NSURLSessionDataTask * dataTask =[defaultSession dataTaskWithRequest:urlRequest completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        //NSLog(@"Response:%@ %@\n", response, error);
        NSString *returnStr = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
        churchArr = [NSJSONSerialization JSONObjectWithData:[returnStr dataUsingEncoding:NSUTF8StringEncoding] options:0 error:NULL];
        
        [self mapLoad];
        [mapTableView reloadData];
        
        searchResultText.text = [NSString stringWithFormat:@"%@ 검색 결과는 총 %ld 건 입니다.", addressText.text, [churchArr count]];
        
        /*
        if (statusCode == 200) {
            
        }else{
            UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"알림" message:@"잠시 후 다시 시도해주세요." delegate:nil cancelButtonTitle:@"확인" otherButtonTitles:nil, nil];
            [alert show];
        }
         */
        
        [self loadingClose];
    }];
    [dataTask resume];
}

- (void)mapLoad{
    for (id<MKAnnotation> annotation in mkMapView.annotations) {
        [mkMapView removeAnnotation:annotation];
    }
    
    // Map View
    mkMapView = [[MKMapView alloc] initWithFrame:mkView.bounds];
    mkMapView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    mkMapView.delegate = self;
    mkMapView.showsUserLocation = YES;
    [mkMapView setMapType:MKMapTypeStandard];
    [mkView addSubview:mkMapView];
    
    for (int i = 0; i < [churchArr count]; i++) {
        NSDictionary *dic = [churchArr objectAtIndex:i];
        Pin *ann = [[Pin alloc] init];
        ann.title = [dic objectForKey:@"church_name"];
        ann.subtitle = [dic objectForKey:@"church_address"];
        CLLocationCoordinate2D center;
        center.latitude = [[dic objectForKey:@"latitude"] floatValue];
        center.longitude = [[dic objectForKey:@"hardness"] floatValue];
        ann.coordinate = center;
        [mkMapView addAnnotation:ann];
        
        if([churchArr count] == 1){
            MKCoordinateRegion region = mkMapView.region;

            region.center = CLLocationCoordinate2DMake([[dic objectForKey:@"latitude"] floatValue], [[dic objectForKey:@"hardness"] floatValue]);
            
            region.span.longitudeDelta /= 10000.0;
            region.span.latitudeDelta /= 10000.0;
            [mkMapView setRegion:region animated:NO];
        }else{
            if(i == 0){
                MKCoordinateRegion region = mkMapView.region;
                
                region.center = CLLocationCoordinate2DMake(35.95, 128.25);
                
                region.span.longitudeDelta /= 20.0;
                region.span.latitudeDelta /= 20.0;
                [mkMapView setRegion:region animated:NO];
            }
        }
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark -
#pragma mark Button Action

- (IBAction)backButton:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)searchButton:(id)sender {
    mapFirstCheck = 1;
    
    if(addressText.text.length == 0){
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"알림" message:@"내용을 입력해주세요." delegate:nil cancelButtonTitle:@"확인" otherButtonTitles:nil, nil];
        [alert show];
        return;
    }
    
    [self loadingInit];
    
    [self churchJsonParsing];
    
    /*
    if(addressText.text.length != 0){
        CLGeocoder* geocoder = [[CLGeocoder alloc] init];
        [geocoder geocodeAddressString:@"서울시 영등포구 신길동 4122번지" completionHandler:^(NSArray *placemarks, NSError *error)
         {
             NSLog(@"%@",[placemarks description]);
             NSLog(@"plcaemarks count = %lu",(unsigned long)[placemarks count]);
             
             //검색결과가 아무것도 없을 때
             if ([placemarks count] == 0){
                 UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"검색 실패" message:@"해당 지역을 검색할 수 없습니다." delegate:nil cancelButtonTitle:@"확인" otherButtonTitles:nil, nil];
                 [alert show];
                 
                 return ;
             }else{
                 //첫번째 검색결과 사용
                 CLPlacemark* p = [placemarks objectAtIndex:0];
                 CLCircularRegion* region = (CLCircularRegion *)p.region;
                 
                 NSLog(@"%f", region.center.latitude);
                 NSLog(@"%f", region.center.longitude);
             }
         }];
    }else{
        UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"알림" message:@"주소를 입력해주세요." delegate:nil cancelButtonTitle:@"확인" otherButtonTitles:nil, nil];
        [alert show];
    }
     */
}

- (IBAction)sstButton:(id)sender {
    [self startRecording];
}

- (IBAction)closeButton:(id)sender {
    alphaView.hidden = YES;
    [self stopRecording];
}

#pragma mark -
#pragma mark Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [churchArr count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 80;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"mapCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    
    NSDictionary *dic = [churchArr objectAtIndex:indexPath.row];
    
    UILabel *titleLabel = (UILabel*)[cell viewWithTag:1];
    UILabel *addrLabel = (UILabel*)[cell viewWithTag:2];
    UILabel *numberLabel = (UILabel*)[cell viewWithTag:3];
    UIButton *selectButton = (UIButton*)[cell viewWithTag:4];
    
    titleLabel.text = [dic objectForKey:@"church_name"];
    addrLabel.text = [dic objectForKey:@"church_address"];
    numberLabel.text = [dic objectForKey:@"church_number"];
    
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 99, self.view.frame.size.width - 40, 0.5)];
    lineView.backgroundColor = [UIColor grayColor];
    [cell addSubview:lineView];
    
    selectButton.tag = indexPath.row;
    [selectButton addTarget:self action:@selector(selectAction:) forControlEvents:UIControlEventTouchUpInside];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // 테이블 항목 터치에 대한 이벤트는 방지. 테이블 셀 위의 버튼 이벤트도 대치하기 위함.
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    return;
}

- (void)selectAction:(UIButton*)sender{
    arrIndexNum = sender.tag;
    
    nextDic = [churchArr objectAtIndex:sender.tag];
    
    [self performSegueWithIdentifier:@"detail" sender:nil];
}

#pragma mark -
#pragma mark SpeechToTextModule Delegate

- (void)startRecording {
    if (isRecording == NO) {
        NSURL *url = [[NSBundle mainBundle] URLForResource:@"recording_animate" withExtension:@"gif"];
        animationView.image = [UIImage animatedImageWithAnimatedGIFURL:url];
        animationView.hidden = NO;
        [speechToTextModule beginRecording];
        isRecording = YES;
    }
}

- (void)stopRecording {
    if (isRecording) {
        animationView.hidden = YES;
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
        alphaView.hidden = YES;
    }
    else {
        addressText.text = result;
        
        [self loadingInit];
        
        [self churchJsonParsing];
        
        alphaView.hidden = YES;
    }
    
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

#pragma mark -
#pragma mark StoryBoard Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue identifier] isEqualToString:@"detail"])
    {
        MapDetailVC *vc = [segue destinationViewController];
        vc.mapDetailDic = nextDic;
    }
}

#pragma mark -
#pragma mark TextField Delegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [self searchButton:nil];
    [textField resignFirstResponder];
    return YES;
}

#pragma mark -
#pragma mark Map Delegate
/*
- (void)mapView:(MKMapView *)mapView didSelectAnnotationView:(MKAnnotationView *)view {
    if ([view conformsToProtocol:@protocol(JPSThumbnailAnnotationViewProtocol)]) {
        [((NSObject<JPSThumbnailAnnotationViewProtocol> *)view) didSelectAnnotationViewInMap:mapView];
    }
}

- (void)mapView:(MKMapView *)mapView didDeselectAnnotationView:(MKAnnotationView *)view {
    if ([view conformsToProtocol:@protocol(JPSThumbnailAnnotationViewProtocol)]) {
        [((NSObject<JPSThumbnailAnnotationViewProtocol> *)view) didDeselectAnnotationViewInMap:mapView];
    }
}

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation {
    if(mapFirstCheck == 0){
    }else{
        if ([annotation conformsToProtocol:@protocol(JPSThumbnailAnnotationProtocol)]) {
            return [((NSObject<JPSThumbnailAnnotationProtocol> *)annotation) annotationViewInMap:mapView];
        }
    }
    return nil;
}

- (NSArray *)annotations {
    JPSThumbnail *empire = [[JPSThumbnail alloc] init];
    NSDictionary *dic;
    NSData *imageData = nil;
    NSString *titleValue = @"";
    NSString *subValue = @"";
    
    if([churchArr count] == 0){
    }else{
        dic = [churchArr objectAtIndex:arrIndexNum];
        rLatitude = [[dic objectForKey:@"latitude"] floatValue];
        rLongitude = [[dic objectForKey:@"hardness"] floatValue];
        NSURL *imageURL = [NSURL URLWithString:[dic objectForKey:@"church_img"]];
        imageData = [NSData dataWithContentsOfURL:imageURL];
        titleValue = [dic objectForKey:@"church_name"];
        subValue = [dic objectForKey:@"church_address"];
    }
    
    empire.image = [UIImage imageWithData:imageData];
    empire.title = titleValue;
    empire.subtitle = subValue;
    empire.coordinate = CLLocationCoordinate2DMake(rLatitude, rLongitude);
    empire.disclosureBlock = ^{ NSLog(@"selected Empire"); };
    
    return @[[JPSThumbnailAnnotation annotationWithThumbnail:empire]];
}

- (void)mapImageTextSetting{
    [mkMapView addAnnotations:[self annotations]];
    MKCoordinateRegion region;
    MKCoordinateSpan span;
    
    span.latitudeDelta = 0.002;
    span.longitudeDelta = 0.002;
    
    region.center = CLLocationCoordinate2DMake(rLatitude, rLongitude);
    region.span = span;
    
    [mkMapView setRegion:region animated:YES];
    [mkMapView setCenterCoordinate:region.center animated:YES];
    [mkMapView regionThatFits:region];
    
    [mapTableView reloadData];
}
*/

@end
