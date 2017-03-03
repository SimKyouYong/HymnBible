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

@interface MapVC ()

@end

@implementation MapVC

@synthesize mkView;
@synthesize addressText;
@synthesize mapTableView;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    mapFirstCheck = 0;
    arrIndexNum = 0;
    
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    self.navigationController.view.backgroundColor = [UIColor colorWithRed:0.0/255.0 green:122.0/255.0 blue:255.0/255.0 alpha:1.0];
    
    locationManager = [[CLLocationManager alloc] init];
    locationManager.delegate = self;
    locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    locationManager.distanceFilter = kCLDistanceFilterNone;
    [locationManager startUpdatingLocation];
    
    // Map View
    mkMapView = [[MKMapView alloc] initWithFrame:mkView.bounds];
    mkMapView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    mkMapView.delegate = self;
    [mkView addSubview:mkMapView];
    
    rLatitude = 37.476390;
    rLongitude = 126.885635;
    
    [self mapImageTextSetting];
}

- (void)churchJsonParsing{
    NSString *urlString = [NSString stringWithFormat:@"%@", SEARCH_URL];
    NSURLSessionConfiguration *defaultConfigObject = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *defaultSession = [NSURLSession sessionWithConfiguration: defaultConfigObject delegate: nil delegateQueue: [NSOperationQueue mainQueue]];
    
    NSMutableURLRequest * urlRequest = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:urlString]];
    NSString * params = [NSString stringWithFormat:@""];
    [urlRequest setHTTPMethod:@"POST"];
    [urlRequest setHTTPBody:[params dataUsingEncoding:NSUTF8StringEncoding]];
    
    NSURLSessionDataTask * dataTask =[defaultSession dataTaskWithRequest:urlRequest completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        //NSLog(@"Response:%@ %@\n", response, error);
        NSInteger statusCode = [(NSHTTPURLResponse *)response statusCode];
        NSString *returnStr = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
        churchArr = [NSJSONSerialization JSONObjectWithData:[returnStr dataUsingEncoding:NSUTF8StringEncoding] options:0 error:NULL];
        
        NSLog(@"%@", churchArr);
        [self mapImageTextSetting];
        if (statusCode == 200) {
            
        }else{
            UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"알림" message:@"잠시 후 다시 시도해주세요." delegate:nil cancelButtonTitle:@"확인" otherButtonTitles:nil, nil];
            //[alert show];
        }
    }];
    [dataTask resume];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark -
#pragma mark Map Delegate

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
#pragma mark -
#pragma mark Button Action

- (IBAction)backButton:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)searchButton:(id)sender {
    mapFirstCheck = 1;
    
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
    return 100;
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
}

@end
