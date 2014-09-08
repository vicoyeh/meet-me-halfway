//
//  MappingViewController.m
//  MeetUp2
//
//  Created by Ethan Yu on 9/6/14.
//  Copyright (c) 2014 Kevin Frans. All rights reserved.
//
#import "Singleton.h"
#import "MappingViewController.h"
#import <MapKit/MapKit.h>
#import <ArcGIS/ArcGIS.h>
#import <Firebase/Firebase.h>

@interface MappingViewController ()<AGSMapViewLayerDelegate,AGSCalloutDelegate>

@property (weak, nonatomic) IBOutlet AGSMapView *goodMap;
@end

@implementation MappingViewController
{
    CLLocationManager *locationManager;
    AGSGraphicsLayer* myGraphicsLayer;
    AGSGraphicsLayer* rests;
    
    float xx;
    float yy;
    
    bool hasCalled;
    AGSCalloutTemplate *calloutTemplate;

}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


//- (float)deviceLocationLat {
//    return _map.userLocation.location.coordinate.latitude;
//}
//
//- (float)deviceLocationLong {
//    return _map.userLocation.location.coordinate.longitude;
//}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    hasCalled = false;
    
    _goodMap.layerDelegate = self;
    self.goodMap.callout.delegate = self;
    
    locationManager = [[CLLocationManager alloc] init];
    locationManager.distanceFilter = kCLDistanceFilterNone; // whenever we move
    locationManager.desiredAccuracy = kCLLocationAccuracyBest; // 100 m
    [locationManager startUpdatingLocation];
    
    [self performSelector:@selector(textFieldDidChange) withObject:nil afterDelay:2.0];
    
    
    NSURL* url = [NSURL URLWithString:@"http://services.arcgisonline.com/arcgis/rest/services/World_Street_Map/MapServer"];
    AGSTiledMapServiceLayer *tiledLayer = [AGSTiledMapServiceLayer tiledMapServiceLayerWithURL:url];
    [_goodMap addMapLayer:tiledLayer withName:@"Basemap Tiled Layer"];

    myGraphicsLayer = [AGSGraphicsLayer graphicsLayer];
    [_goodMap addMapLayer:myGraphicsLayer withName:@"Graphics Layer"];
    
    rests = [AGSGraphicsLayer graphicsLayer];
    [_goodMap addMapLayer:rests withName:@"Rests Layer"];

    [self performSelector:@selector(checkOtherPos) withObject:nil afterDelay:2.0];

    
    xx = _goodMap.locationDisplay.location.point.x;
    yy = _goodMap.locationDisplay.location.point.y;

    [[Singleton sharedInstance] setCoord:[NSNumber numberWithFloat:_goodMap.locationDisplay.location.point.x] long:[NSNumber numberWithFloat:_goodMap.locationDisplay.location.point.y]];
    
    
    calloutTemplate = [[AGSCalloutTemplate alloc]init];
    calloutTemplate.titleTemplate = @"${Name}";
    calloutTemplate.detailTemplate = @"${Detail}";
    rests.calloutDelegate = calloutTemplate;
    
    
    
    
    Firebase* myRootRef = [[Firebase alloc] initWithUrl:@"https://meethalfway.firebaseio.com/"];
    //[myRootRef setValue:@"hai"];
    Firebase* me = [myRootRef childByAppendingPath:[[NSUserDefaults standardUserDefaults] objectForKey:@"otherID"]];
    
    NSLog(me.description);
    
    [me observeEventType:FEventTypeValue withBlock:^(FDataSnapshot *snapshot) {
        [self performSelector:@selector(setPoses:) withObject:snapshot afterDelay:2.0];
    }];
    

    
}


- (void) didClickAccessoryButtonForCallout:		(AGSCallout *) 	callout	{
    //instantiate an object of the FeatureDetailsViewController
    NSLog(@"detailed %@",callout.title);
    
}


-(void) setPoses:(FDataSnapshot *)snapshot
{
    NSLog(@"%@",snapshot.value);
    xx = [[snapshot.value objectForKey:@"lat"] floatValue];
    yy = [[snapshot.value objectForKey:@"long"] floatValue];
    
    [[Singleton sharedInstance] setCoordFriend:[NSNumber numberWithFloat:xx] long:[NSNumber numberWithFloat:yy]];
    
    [[Singleton sharedInstance] setCoord:[NSNumber numberWithFloat:_goodMap.locationDisplay.location.point.x] long:[NSNumber numberWithFloat:_goodMap.locationDisplay.location.point.y]];
    
    [[Singleton sharedInstance] updateJSON];
    
    NSLog(@"%@",[Singleton sharedInstance].JSONData);
    
    if(hasCalled == false)
    {
        [[Singleton sharedInstance] postData];
        hasCalled = true;
    }
    
    
    [self performSelector:@selector(showRests) withObject:nil afterDelay:2.0];
}



-(void) showRests
{
    for(Restaurant* restaurant in [Singleton sharedInstance].restaurants)
    {
        if(restaurant.latitude != 0 && restaurant.longitude != 0)
        {
        
        NSLog(@"Name: %@ Addres %@",restaurant.name,restaurant.address);
        
        AGSSimpleMarkerSymbol *myMarkerSymbol2 =
        [AGSSimpleMarkerSymbol simpleMarkerSymbol];
        myMarkerSymbol2.color = [UIColor redColor];
        
        AGSPoint* myMarkerPoint2 =
        [AGSPoint pointWithX:restaurant.longitude y:restaurant.latitude spatialReference:[AGSSpatialReference wgs84SpatialReference]];
        
        AGSGeometryEngine *ge2 = [AGSGeometryEngine defaultGeometryEngine];
        
        AGSPoint *newPoint2 = (AGSPoint*)[ge2 projectGeometry:myMarkerPoint2 toSpatialReference:_goodMap.spatialReference];
        
        //Create the Graphic, using the symbol and
        //geometry created earlier
        AGSGraphic* myGraphic2 =
        [AGSGraphic graphicWithGeometry:newPoint2
                                 symbol:myMarkerSymbol2
                             attributes:nil];
            
            [myGraphic2 setAttribute:restaurant.name forKey:@"Name"];
            [myGraphic2 setAttribute:[NSString stringWithFormat:@"%@",restaurant.address] forKey:@"Detail"];
            [myGraphic2 setAttribute:restaurant.imgURL forKey:@"image"];
            NSLog(restaurant.imgURL);
        
        //Add the graphic to the Graphics layer
        [rests addGraphic:myGraphic2];
            
        }
        
    }

}




-(void) checkOtherPos
{
    
    
    
    [myGraphicsLayer removeAllGraphics];
    
    //create a marker symbol to be used by our Graphic
    AGSSimpleMarkerSymbol *myMarkerSymbol =
    [AGSSimpleMarkerSymbol simpleMarkerSymbol];
    myMarkerSymbol.color = [UIColor blueColor];
    
    AGSPoint* myMarkerPoint =
    [AGSPoint pointWithX:xx y:yy spatialReference:[AGSSpatialReference wgs84SpatialReference]];
    
    AGSGeometryEngine *ge = [AGSGeometryEngine defaultGeometryEngine];
    
    AGSPoint *newPoint = (AGSPoint*)[ge projectGeometry:myMarkerPoint toSpatialReference:_goodMap.spatialReference];
    
    //NSLog(@"%f",myMarkerPoint.y);
    //NSLog(@"%f",myMarkerPoint.x);
    
    //Create the Graphic, using the symbol and
    //geometry created earlier
    AGSGraphic* myGraphic =
    [AGSGraphic graphicWithGeometry:newPoint
                             symbol:myMarkerSymbol
                         attributes:nil];
    
    //Add the graphic to the Graphics layer
    [myGraphicsLayer addGraphic:myGraphic];
    
    
    
    
    
    
    Firebase* myRootRef = [[Firebase alloc] initWithUrl:@"https://meethalfway.firebaseio.com/"];
    //[myRootRef setValue:@"hai"];
    Firebase* me = [myRootRef childByAppendingPath:[[NSUserDefaults standardUserDefaults] objectForKey:@"id"]];
    
    [[me childByAppendingPath:@"lat"] setValue:[NSString stringWithFormat:@"%f",_goodMap.locationDisplay.location.point.x]];
    [[me childByAppendingPath:@"long"] setValue:[NSString stringWithFormat:@"%f",_goodMap.locationDisplay.location.point.y]];
    
    
    
    
    
    
    
    

    
    [self performSelector:@selector(checkOtherPos) withObject:nil afterDelay:0.1];
}



-(BOOL)callout:(AGSCallout*)callout willShowForFeature:(id<AGSFeature>)feature layer:(AGSLayer<AGSHitTestable>*)layer mapPoint:(AGSPoint*)mapPoint{
    //Specify the callout's contents
    _goodMap.callout.title = (NSString*)[feature attributeForKey:@"Name"];
    _goodMap.callout.detail =(NSString*)[feature attributeForKey:@"Address"];
    _goodMap.callout.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:[feature attributeForKey:@"image"]]]];
    return YES;
}

-(void) mapViewDidLoad:(AGSMapView*)mapView {
    [_goodMap.locationDisplay startDataSource];
    
    _goodMap.locationDisplay.autoPanMode = AGSLocationDisplayAutoPanModeDefault ;
    _goodMap.locationDisplay.wanderExtentFactor = 0.75; //75% of the map's viewable extent
    
    //NSLog(@"map loaded");
}


-(void) textFieldDidChange
{
    //[self changeMap];
    
    [self performSelector:@selector(textFieldDidChange) withObject:nil afterDelay:2.0];
}


//- (void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation
//{
//    [self changeMap];
//}

//-(void) changeMap
//{
//    CLLocationCoordinate2D zoomLocation;
//    zoomLocation.latitude = [self deviceLocationLat];
//    zoomLocation.longitude= [self deviceLocationLong];
//    
//    [_map removeAnnotations:_map.annotations];
//    
//    MKPointAnnotation *point = [[MKPointAnnotation alloc] init];
//    point.coordinate = _map.userLocation.location.coordinate;
//    point.title = @"Where am I?";
//    point.subtitle = @"I'm here!!!";
//    
//    [_map addAnnotation:point];
//    
//    NSLog(@"%f",[self deviceLocationLat]);
//    NSLog(@"%f",[self deviceLocationLong]);
//    
//    
//    MKMapPoint annotationPoint = MKMapPointForCoordinate(_map.userLocation.location.coordinate);
//    MKMapRect zoomRect = MKMapRectMake(annotationPoint.x, annotationPoint.y, 0.1, 0.1);
//    
//    for (id <MKAnnotation> annotation in _map.annotations)
//    {
//        MKMapPoint annotationPoint = MKMapPointForCoordinate(annotation.coordinate);
//        MKMapRect pointRect = MKMapRectMake(annotationPoint.x, annotationPoint.y, 0.1, 0.1);
//        zoomRect = MKMapRectUnion(zoomRect, pointRect);
//    }
//    [_map setVisibleMapRect:zoomRect animated:YES];
//    
//    // 2
//    //    MKCoordinateRegion viewRegion = MKCoordinateRegionMakeWithDistance(zoomLocation, 0.5*METERS_PER_MILE, 0.5*METERS_PER_MILE);
//    
//    // 3
//    //    [_map setRegion:viewRegion animated:YES];
//}

- (void)viewWillAppear:(BOOL)animated {
    // 1
    //[self changeMap];
}
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    [Singleton sharedInstance].selectedUserFBID = nil;
}

@end
