//
//  MappingViewController.m
//  MeetUp2
//
//  Created by Ethan Yu on 9/6/14.
//  Copyright (c) 2014 Kevin Frans. All rights reserved.
//

#import "MappingViewController.h"
#import <MapKit/MapKit.h>

@interface MappingViewController ()

@property (weak, nonatomic) IBOutlet MKMapView *map;

@end

@implementation MappingViewController
{
    CLLocationManager *locationManager;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (float)deviceLocationLat {
    return _map.userLocation.location.coordinate.latitude;
}

- (float)deviceLocationLong {
    return _map.userLocation.location.coordinate.longitude;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    locationManager = [[CLLocationManager alloc] init];
    locationManager.distanceFilter = kCLDistanceFilterNone; // whenever we move
    locationManager.desiredAccuracy = kCLLocationAccuracyBest; // 100 m
    [locationManager startUpdatingLocation];
    
    [self performSelector:@selector(textFieldDidChange) withObject:nil afterDelay:2.0];
    
    
}


-(void) textFieldDidChange
{
    [self changeMap];
    
    [self performSelector:@selector(textFieldDidChange) withObject:nil afterDelay:2.0];
}


- (void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation
{
    [self changeMap];
}

-(void) changeMap
{
    CLLocationCoordinate2D zoomLocation;
    zoomLocation.latitude = [self deviceLocationLat];
    zoomLocation.longitude= [self deviceLocationLong];
    
    [_map removeAnnotations:_map.annotations];
    
    MKPointAnnotation *point = [[MKPointAnnotation alloc] init];
    point.coordinate = _map.userLocation.location.coordinate;
    point.title = @"Where am I?";
    point.subtitle = @"I'm here!!!";
    
    [_map addAnnotation:point];
    
    NSLog(@"%f",[self deviceLocationLat]);
    NSLog(@"%f",[self deviceLocationLong]);
    
    
    MKMapPoint annotationPoint = MKMapPointForCoordinate(_map.userLocation.location.coordinate);
    MKMapRect zoomRect = MKMapRectMake(annotationPoint.x, annotationPoint.y, 0.1, 0.1);
    
    for (id <MKAnnotation> annotation in _map.annotations)
    {
        MKMapPoint annotationPoint = MKMapPointForCoordinate(annotation.coordinate);
        MKMapRect pointRect = MKMapRectMake(annotationPoint.x, annotationPoint.y, 0.1, 0.1);
        zoomRect = MKMapRectUnion(zoomRect, pointRect);
    }
    [_map setVisibleMapRect:zoomRect animated:YES];
    
    // 2
//    MKCoordinateRegion viewRegion = MKCoordinateRegionMakeWithDistance(zoomLocation, 0.5*METERS_PER_MILE, 0.5*METERS_PER_MILE);
    
    // 3
//    [_map setRegion:viewRegion animated:YES];
}

- (void)viewWillAppear:(BOOL)animated {
    // 1
    [self changeMap];
}


@end
