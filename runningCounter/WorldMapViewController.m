//
//  WorldMapViewController.m
//  runningCounter
//
//  Created by chiawei on 2015/1/25.
//  Copyright (c) 2015年 Longfatown. All rights reserved.
//

#import "WorldMapViewController.h"


@interface WorldMapViewController () <MKMapViewDelegate,CLLocationManagerDelegate>

{
    CLLocationManager *locationManager;
    
    CLLocation *userLocation;
    CLLocation *lastLocation;
    
    BOOL isfirstLocation;
    
    NSMutableArray *downloadDatas;
    
    NSDictionary *locationDict;
    
}

@property (weak, nonatomic) IBOutlet MKMapView *myMapView;

@end

@implementation WorldMapViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    locationManager = [CLLocationManager new];
    
//    if ([locationManager respondsToSelector:@selector(requestAlwaysAuthorization)]) {
//        
//        [locationManager requestAlwaysAuthorization];
//    }
    
    locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    
    locationManager.delegate = self;
    
    [locationManager startUpdatingLocation];
    
    _myMapView.userTrackingMode = MKUserTrackingModeFollow;
    
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



// hide status bar
- (BOOL)prefersStatusBarHidden {
    
    return YES;
}


#pragma mark - locationManager delegate

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    
    userLocation = [locations lastObject];
    
    locationDict = @{@"lat":@(userLocation.coordinate.latitude),@"lng":@(userLocation.coordinate.longitude)};
    
    if (isfirstLocation == NO) {
        
        lastLocation = userLocation;
        
        //NSLog(@"lastLocation:%f,%f",lastLocation.coordinate.latitude,lastLocation.coordinate.longitude);
        
        // download data from google api
        [self downloadJSON];
        
        MKCoordinateRegion region = _myMapView.region;
        
        region.center = userLocation.coordinate;
        
        // 縮放比例
        region.span.latitudeDelta = 0.01;
        region.span.longitudeDelta = 0.01;
        
        [_myMapView setRegion:region animated:YES];
        
        isfirstLocation = YES;
        
    }
    
    //
    if ([userLocation distanceFromLocation:lastLocation]>800 ) {
        
        [self downloadJSON];
        lastLocation = userLocation;
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"update map" message:nil delegate:self cancelButtonTitle:@"ok" otherButtonTitles:nil];
        [alert show];
        
    }
    
}



#pragma mark - Async block

- (void)downloadJSON {
    
    downloadDatas = [NSMutableArray new];
    
    NSString *JSONURL = [NSString stringWithFormat:@"https://maps.googleapis.com/maps/api/place/nearbysearch/json?location=%@,%@&radius=1200&types=convenience_store&key=AIzaSyAGTkG8ERNdX-bXpMxBO_jhBad7fJggAkk", [locationDict objectForKey:@"lat"], [locationDict objectForKey:@"lng"]];
    
    // 編碼
    NSString *URLstring = [JSONURL stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    NSURL *url = [NSURL URLWithString:URLstring];
    
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
    NSOperationQueue *queue = [NSOperationQueue new];
    
    [NSURLConnection sendAsynchronousRequest:request queue:queue completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        
        if ([data length]>0 && connectionError == nil) {
            
            NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
            
            downloadDatas = [dict objectForKey:@"results"];
            
            NSLog(@"download Success");
            
            //NSLog(@"datas: %@",downloadDatas);
            
            dispatch_async(dispatch_get_main_queue(), ^{
                //下載完後的動作
                
                [self addAnnotation:downloadDatas];
            });
            
        }
        else if ([data length] == 0 && connectionError == nil) {
            
            NSLog(@"check your network is open");
            
        }
        else if (connectionError != nil) {
            
            NSLog(@"error :%@",[connectionError localizedDescription]);
            
        }
        
    }];
    
}



#pragma mark - add annotation method

- (void)addAnnotation:(NSArray *)data
{
    
    for (NSDictionary *dict in data) {
        
        //NSLog(@"dict:%@",dict);
        
        MKPointAnnotation *annotation = [MKPointAnnotation new];
        
        // set annotation title
        if ([[dict objectForKey:@"types"] containsObject:@"convenience_store"]) {
            
            annotation.title = @"convenience_store";
        }
//        else if ([[dict objectForKey:@"types"] containsObject:@"hospital"]) {
//            
//            self.annotation.title = @"hospital";
//            
//        }
        
        double lat = [[dict valueForKeyPath:@"geometry.location.lat"]doubleValue];
        
        double lon = [[[[dict objectForKey:@"geometry"]objectForKey:@"location"] objectForKey:@"lng"]doubleValue];

        //NSLog(@"lat:%f",lat);
        //NSLog(@"lon:%f",lon);
        
        CLLocationCoordinate2D annoationCoordinate = CLLocationCoordinate2DMake(lat, lon);
        
        // create a circularRegion
        //CLCircularRegion *circularRegion = [[CLCircularRegion alloc]initWithCenter:annoationCoordinate radius:100 identifier:annotation.title];
        
        [self scheduleLocalNotification];
        
        annotation.coordinate = annoationCoordinate;
        
        [_myMapView addAnnotation:annotation];
        
    }
}


#pragma mark - schedule LocalNotification

- (void)scheduleLocalNotification{

    // add localNotification
    UILocalNotification *localNotifi = [UILocalNotification new];
    
    // region is not support ios7
    //localNotifi.region = self.circularRegion;
    localNotifi.alertBody = @"you arrived the region";
    localNotifi.soundName = UILocalNotificationDefaultSoundName;
    localNotifi.applicationIconBadgeNumber = 1;
    
    [[UIApplication sharedApplication] scheduleLocalNotification:localNotifi];
}



#pragma mark - mapView delegate

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation
{
    
    if (annotation == mapView.userLocation) {
        
        return nil;
    }
    
    MyCustomPin *annotationView = (MyCustomPin *)[mapView dequeueReusableAnnotationViewWithIdentifier:annotation.title];
    
    if (annotationView == nil) {
        
        annotationView = [[MyCustomPin alloc]initWithAnnotation:annotation reuseIdentifier:annotation.title];
        
    }
    else {
        
        annotationView.annotation = annotation;
    }
    
    annotationView.canShowCallout = YES;
    
    UIButton *rightButton = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];

    annotationView.rightCalloutAccessoryView = rightButton;
    
    annotationView.rightCalloutAccessoryView.hidden = YES;
    
    
    return annotationView;
}


- (void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control {
    
    CLLocation *location = [[CLLocation alloc]initWithLatitude:[view.annotation coordinate].latitude longitude:[view.annotation coordinate].longitude];
    
    if ([userLocation distanceFromLocation:location] <= 200 ) {
        
       StoreViewController *svc = [self.storyboard instantiateViewControllerWithIdentifier:@"StoreViewController"];
        [self presentViewController:svc animated:YES completion:nil];
        
    }
    else {
        
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"商店距離太遠嘍" message:nil delegate:self cancelButtonTitle:@"ok" otherButtonTitles:nil];
        
        [alert show];
        
    }
    
}


#pragma mark - button 

- (IBAction)backButton:(id)sender {
    
    [self dismissViewControllerAnimated:YES completion:nil];
    
}


- (IBAction)positionButton:(id)sender {
    
    [self downloadJSON];
    
    MKCoordinateRegion region = _myMapView.region;
    
    region.center = userLocation.coordinate;
    
    // 縮放比例
    region.span.latitudeDelta = 0.01;
    region.span.longitudeDelta = 0.01;
    
    [_myMapView setRegion:region animated:YES];
    
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
