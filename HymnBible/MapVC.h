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
    
    MKMapView *mkMapView;
    
    NSInteger mapFirstCheck;
    
    NSMutableArray *arrayLatitude;
    NSMutableArray *arrayLongitude;
    
    UIActivityIndicatorView *activityView;
    UIView *loadingView;
    UILabel *loadingLabel;
    
    NSDictionary *nextDic;
}

@property (weak, nonatomic) IBOutlet UIView *alphaView;
@property (weak, nonatomic) IBOutlet UIImageView *animationView;
@property (weak, nonatomic) IBOutlet UILabel *sttText;
- (IBAction)closeButton:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *closebutton;

@property (weak, nonatomic) IBOutlet UIView *mkView;
@property (weak, nonatomic) IBOutlet UITableView *mapTableView;

@property (weak, nonatomic) IBOutlet UITextField *addressText;
@property (weak, nonatomic) IBOutlet UILabel *searchResultText;

- (IBAction)backButton:(id)sender;
- (IBAction)searchButton:(id)sender;
- (IBAction)sstButton:(id)sender;

@end
