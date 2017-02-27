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

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //[audioMapView setShowsUserLocation:YES];
    [mapView setMapType:MKMapTypeStandard];
    
    locationManager = [[CLLocationManager alloc] init];
    locationManager.delegate = self;
    locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    locationManager.distanceFilter = kCLDistanceFilterNone;
    [locationManager startUpdatingLocation];
    
    float rLatitude;
    float rLongitude;
    arrayLatitude = [[NSMutableArray alloc] init];
    arrayLongitude = [[NSMutableArray alloc] init];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
