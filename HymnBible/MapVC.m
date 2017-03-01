//
//  MapVC.m
//  HymnBible
//
//  Created by Joseph_iMac on 2017. 2. 23..
//  Copyright © 2017년 Joseph_iMac. All rights reserved.
//

#import "MapVC.h"

@interface MapVC ()

@end

@implementation MapVC

@synthesize mapView;
@synthesize addressText;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    self.navigationController.view.backgroundColor = [UIColor colorWithRed:0.0/255.0 green:122.0/255.0 blue:255.0/255.0 alpha:1.0];
    
    locationManager = [[CLLocationManager alloc] init];
    locationManager.delegate = self;
    locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    locationManager.distanceFilter = kCLDistanceFilterNone;
    [locationManager startUpdatingLocation];
    
    [mapView setShowsUserLocation:YES];
    [mapView setMapType:MKMapTypeStandard];
    
    float rLatitude;
    float rLongitude;
    arrayLatitude = [[NSMutableArray alloc] init];
    arrayLongitude = [[NSMutableArray alloc] init];
    
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
             CLCircularRegion *circularRegion = (CLCircularRegion *)p.region;
             
             NSLog(@"%f", circularRegion.center.latitude);
             NSLog(@"%f", circularRegion.center.longitude);
             
             Pin *ann = [[Pin alloc] init];
             ann.title = @"test";
             ann.subtitle = @"test_sub";
             CLLocationCoordinate2D center;
             center.latitude = circularRegion.center.latitude;
             center.longitude = circularRegion.center.longitude;
             ann.coordinate = center;
             [mapView addAnnotation:ann];
             
             MKCoordinateRegion region;
             MKCoordinateSpan span;
             
             span.latitudeDelta = 0.00001;
             span.longitudeDelta = 0.00001;
             
             region.center = CLLocationCoordinate2DMake(circularRegion.center.latitude, circularRegion.center.longitude);
             region.span = span;
             
             [mapView setRegion:region animated:YES];
             [mapView setCenterCoordinate:region.center animated:YES];
             [mapView regionThatFits:region];
         }
     }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark -
#pragma mark Map Delegate
/*
- (MKAnnotationView *)mapView:(MKMapView *)aMapView viewForAnnotation:(id <MKAnnotation>)annotation {
    static NSString *placeMarkIdentifier = @"my annotation identifier";
    
    if ([annotation isKindOfClass:[Pin class]]) {
        MKAnnotationView *annotationView = (MKPinAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:placeMarkIdentifier];
        if (annotationView == nil) {
            annotationView = [[MKAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:placeMarkIdentifier];
            annotationView.image = [UIImage imageNamed:[annotation subtitle]];
            annotationView.canShowCallout = YES;
            annotationView.rightCalloutAccessoryView = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
        }
        else
            annotationView.annotation = annotation;
        return annotationView;
    }
    return nil;
}
*/
- (void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control
{
    
}

- (void)mapView:(MKMapView *)mapView didSelectAnnotationView:(MKAnnotationView *)view
{
    
}

#pragma mark -
#pragma mark Button Action

- (IBAction)backButton:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)searchButton:(id)sender {
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
}

- (IBAction)sstButton:(id)sender {
    
}

@end
