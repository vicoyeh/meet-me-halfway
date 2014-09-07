//
//  Singleton.m
//  MeetUp2
//
//  Created by Wilson Zhao on 9/6/14.
//  Copyright (c) 2014 Kevin Frans. All rights reserved.
//


#import "Singleton.h"

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
        
    }
    return self;
}

- (NSMutableArray *) parseJSON:(NSData *)responseData
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
    NSLog(@"Posting Data");
    NSHTTPURLResponse *response = nil;
    
    NSString *jsonUrlString = [NSString stringWithFormat:@"http://itunes.apple.com/search?term=rolling&media=software"];
    NSURL *url = [NSURL URLWithString:[jsonUrlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    

    //-- Get request and response though URL
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc]initWithURL:url];
    [request setHTTPMethod:@"POST"];
    NSDictionary *tmp = [[NSDictionary alloc] initWithObjectsAndKeys:
                         @"email", @"Email",
                         @"fname", @"FirstName",
                         nil];
    NSError *error;
    
    
    
    NSData *postData = [NSJSONSerialization dataWithJSONObject:tmp options:0 error:&error];
    [request setHTTPBody:postData];
    [NSURLConnection sendAsynchronousRequest:request queue:[[NSOperationQueue alloc] init] completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
            NSLog(@"Connecting...");
        if (error) {
            NSLog(@"Error: %@",error);
            // [self.delegate fetchingGroupsFailedWithError:error];
        } else {
            NSMutableArray *dataArray = [self parseJSON:data];
            NSLog(@"Data: %@",dataArray);
            // [self.delegate receivedGroupsJSON:data];
        }
    }];


}

@end


