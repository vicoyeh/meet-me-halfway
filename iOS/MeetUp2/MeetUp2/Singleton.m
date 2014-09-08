//
//  Singleton.m
//  MeetUp2
//
//  Created by Wilson Zhao on 9/6/14.
//  Copyright (c) 2014 Kevin Frans. All rights reserved.
//
#define BACKEND = @"http://162.243.151.67:3000/maps"

#import "Singleton.h"

@implementation Restaurant {
    
}


@end



@implementation Singleton
+ (Singleton *)sharedInstance
{
    static Singleton *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[Singleton alloc] init];
        // Do any other initialisation stuff here
    });
    return sharedInstance;
}

- (id) init {
    if (self = [super init]) {
        _restaurants = [NSMutableArray array];
        // Setup JSONData
        
        _userLat = @35.7749290;
        _userLong = @-118.4194160;
        _friendLat = @39.7749290;
        _friendLong = @-126.4194160;
        //_JSONData = @{@"user":@"d"};
        _JSONData = @{@"user":@{@"latitude":_userLat,@"longitude":_userLong},@"friend":@{@"latitude":_friendLat,@"longitude":_friendLong}};
    }
    return self;
}

-(void) updateJSON
{
    _JSONData = @{@"user":@{@"latitude":_userLat,@"longitude":_userLong},@"friend":@{@"latitude":_friendLat,@"longitude":_friendLong}};
}

-(void) setCoord:(NSNumber*)lat long:(NSNumber*)longi
{
    _userLat = longi;
    _userLong = lat;
}

-(void) setCoordFriend:(NSNumber*)lat long:(NSNumber*)longi
{
    _friendLat = longi;
    _friendLong = lat;
}

- (NSString * ) parseData:(NSDictionary *)inputData
{
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:inputData
                                                       options:0// Pass 0 if you don't care about the readability of the generated string
                                                         error:&error];
    
    if (! jsonData) {
        NSLog(@"Got an error: %@", error);
        return @"error";
    } else {
        return [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    }
    
    
}
- (NSMutableArray *)parseJSON:(NSData *)responseData
{
    NSError *error;
    //-- JSON Parsing
    NSMutableArray *result = [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingMutableContainers error:&error];
    
    /*
     for (NSMutableDictionary *dic in result)
     {
     if (dic == nil)
     break;
     if (dic[@"array"] != nil)
     {
     NSString *string = dic[@"array"];
     NSData *data = [string dataUsingEncoding:NSUTF8StringEncoding];
     dic[@"array"] = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
     }
     else
     {
     NSLog(@"Error in url response");
     }
     }*/
    return result;
}

- (void)postData {
    [self postDataWith:self.JSONData toAddress:@"http://162.243.151.67:3000/maps"];
}

- (void)postDataWith:(NSDictionary *)data toAddress:(NSString *)address {
    if (self.JSONData == nil) {
        NSLog (@"JSONData is nil");
        return;
    }
    NSLog(@"Posting Data");
    NSString *jsonUrlString = [NSString stringWithFormat:address];
    NSURL *url = [NSURL URLWithString:[jsonUrlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc]initWithURL:url];
    [request setHTTPMethod:@"POST"];
    //[request setValue:@"json" forHTTPHeaderField:@"Content-Type"];
    // NSDictionary *tmp = @{@"a":@"b"};
    
    // Parse data into JSON
    // NSData *postData = [NSJSONSerialization JSONObjectWithData:[NSData dataWith] options:<#(NSJSONReadingOptions)#> error:(NSError *__autoreleasing *) options:NSJSONReadingMutableContainers error:nil];
    
    
    NSData *postData = [NSJSONSerialization dataWithJSONObject:self.JSONData options:0 error:nil];
    // NSString *jsonString = [[NSString alloc] initWithData:postData encoding:NSUTF8StringEncoding];
    // NSData *postData2 = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    
    //NSData *postData = [NSKeyedArchiver archivedDataWithRootObject:_JSONData];
    NSLog(@"%@", postData);
    [request setHTTPBody:postData];
    [NSURLConnection sendAsynchronousRequest:request queue:[[NSOperationQueue alloc] init] completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
        NSLog(@"Connecting...");
        if (error) {
            NSLog(@"Error: %@",error);
            // [self.delegate fetchingGroupsFailedWithError:error];
        } else {
            NSLog(@"connected");
            
            NSMutableArray *dataArray = [self parseJSON:data];
            for (NSDictionary*n in dataArray) {
                // Location is a nested dict
                
                Restaurant *restaurant = [[Restaurant alloc]init];
                
                // Metadata
                restaurant.name = [n objectForKey:@"name"];
                restaurant.URL = [n objectForKey:@"mobile_url"];
                restaurant.snippetText = [n objectForKey:@"snippet_text"];
                restaurant.rating = [[n objectForKey:@"rating"]floatValue];
                
                // Location
                NSDictionary *location = [n objectForKey:@"location"];
                restaurant.address = [location objectForKey:@"address"];


                restaurant.city = [location objectForKey:@"city"];
                restaurant.latitude = [[[location objectForKey:@"coordinate"]objectForKey:@"latitude"]floatValue];
                restaurant.longitude = [[[location objectForKey:@"coordinate"]objectForKey:@"longitude"]floatValue];
                
                
                [_restaurants addObject:restaurant];
                
//                NSLog(@"%@",n);
            }
            
            //NSLog(@"DataArray: %@",dataArray);
            // [self.delegate receivedGroupsJSON:data];
        }
    }];
    
    
}

@end