//
//  LoginViewController.m
//  MeetUp2
//
//  Created by Kevin Frans on 9/6/14.
//  Copyright (c) 2014 Kevin Frans. All rights reserved.
//
#import <FacebookSDK/FacebookSDK.h>
#import "Singleton.h"
#import "LoginViewController.h"
#import "FriendsListTableViewController.h"

@interface LoginViewController ()<FBLoginViewDelegate>
@property (weak, nonatomic) IBOutlet FBLoginView *fbLoginView;
@property (weak, nonatomic) IBOutlet UIImageView *background;

@end

@implementation LoginViewController

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.background.image = [UIImage imageNamed:@"background.jpg"];
    [_fbLoginView setReadPermissions:@[@"public_profile", @"user_friends"]];
    _fbLoginView.delegate = self;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)loginViewFetchedUserInfo:(FBLoginView *)loginView
                            user:(id<FBGraphUser>)user {
    
    [[NSUserDefaults standardUserDefaults] setObject:user.objectID forKey:@"id"];
    //NSLog(@"Hi");
}

- (void)loginViewShowingLoggedInUser:(FBLoginView *)loginView {
    NSLog(@"Logged in");
    
    FBRequest* friendsRequest = [FBRequest requestForMyFriends];
    [friendsRequest startWithCompletionHandler: ^(FBRequestConnection *connection,
                                                  NSDictionary* result,
                                                  NSError *error) {
        
        NSArray *friends = [result objectForKey:@"data"];
        [Singleton sharedInstance].friends = friends;
        
        
        NSLog(@"Found: %lu friends", (unsigned long)friends.count);
        for (NSDictionary<FBGraphUser>* friend in friends) {
            NSLog(@"I have a friend named %@ with id %@", friend.name, friend.objectID);
        }
        
        if ([Singleton sharedInstance].appleID) {
            NSDictionary *accountInfo = @{@"type": @"login", @"appleid": [Singleton sharedInstance].appleID, @"fbid": [Singleton sharedInstance].fbID, @"name": [Singleton sharedInstance].fullname};
            [[Singleton sharedInstance] postDataWith:accountInfo toAddress:kPostAddressAccount];
            NSLog(@"Sent login");
        }
        
        FriendsListTableViewController *friendList = [self.storyboard instantiateViewControllerWithIdentifier:@"FriendNavController"];
        
        [self presentViewController:friendList animated:YES completion:nil];
        
    }];
    
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
