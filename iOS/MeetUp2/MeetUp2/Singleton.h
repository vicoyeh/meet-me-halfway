//
//  Singleton.h
//  MeetUp2
//
//  Created by Wilson Zhao on 9/6/14.
//  Copyright (c) 2014 Kevin Frans. All rights reserved.
//

#import <Foundation/Foundation.h>

#define kPostAddressMaps @"http://162.243.151.67:3000/maps"
#define kPostAddressAccount @"http://162.243.151.67:3000/account"
#define kPostAddressLogin @"http://162.243.151.67:3000/login"


@interface Restaurant : NSObject {
    
}

@property (nonatomic,copy) NSString* name;
@property (nonatomic) float rating;
@property (nonatomic,copy)  NSString *URL;
@property (nonatomic,copy)  NSString *imgURL;
@property (nonatomic)  NSString *snippetText;
@property (nonatomic,copy) NSString* address;
@property (nonatomic,copy) NSString* displayAddress;
@property (nonatomic) float latitude;
@property (nonatomic) float longitude;
@property (nonatomic) NSString * city;

@end

@interface Singleton : NSObject

+(Singleton *)sharedInstance;
-(void) updateJSON;
-(void) postData;
-(void) setCoord:(NSNumber*)lat long:(NSNumber*)longi;
-(void) setCoordFriend:(NSNumber*)lat long:(NSNumber*)longi;
-(void)postDataWith:(NSDictionary *)data toAddress:(NSString *)address;

@property (nonatomic) NSString* fullname;
@property (nonatomic) NSString* fbID;
@property (nonatomic) NSData *appleID;

@property (nonatomic) NSString *selectedUserFBID;

@property (nonatomic) NSArray *friends;
@property (nonatomic, readwrite) NSMutableArray *restaurants;
@property (nonatomic, readwrite) NSDictionary *JSONData;
@property (nonatomic) NSNumber *userLat;
@property (nonatomic) NSNumber *userLong;
@property (nonatomic) NSNumber *friendLat;
@property (nonatomic) NSNumber *friendLong;
@property (nonatomic) NSNumber *searchRadius;

@end