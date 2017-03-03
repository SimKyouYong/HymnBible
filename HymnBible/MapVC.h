//
//  MapVC.h
//  HymnBible
//
//  Created by Joseph_iMac on 2017. 2. 23..
//  Copyright © 2017년 Joseph_iMac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>
#import "Pin.h"

@interface MapVC : UIViewController<CLLocationManagerDelegate, MKMapViewDelegate>{
    CLLocationManager *locationManager;
    CLLocation *startPoint;
    
    NSMutableArray *distance;
    
    NSInteger pinArrCount;
    
    NSMutableArray *mapTitleClickArr;
    NSString *mapTitle;
    NSString *fileImageName;
    NSString *title;
    NSString *content;
    NSInteger loadCount;
    UILabel *bottomTitle;
    UILabel *bottomContent;
    
    float rLatitude;
    float rLongitude;
    
    NSArray *churchArr;
    NSInteger arrIndexNum;
    
    MKMapView *mkMapView;
    
    NSInteger mapFirstCheck;
}

@property (weak, nonatomic) IBOutlet UIView *mkView;
@property (weak, nonatomic) IBOutlet UITableView *mapTableView;

@property (weak, nonatomic) IBOutlet UITextField *addressText;

- (IBAction)backButton:(id)sender;
- (IBAction)searchButton:(id)sender;
- (IBAction)sstButton:(id)sender;

@end
