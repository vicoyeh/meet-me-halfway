//
//  FriendsListTableViewController.m
//  MeetUp2
//
//  Created by Ethan Yu on 9/6/14.
//  Copyright (c) 2014 Kevin Frans. All rights reserved.
//

#import <FacebookSDK/FacebookSDK.h>
#import "Singleton.h"
#import "FriendsListTableViewController.h"
#import "MappingViewController.h"


@interface FriendsListTableViewController ()

@end

@implementation FriendsListTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    Singleton *singleton = [Singleton sharedInstance];
      _friends = singleton.friends;
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
#warning Potentially incomplete method implementation.
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
#warning Incomplete method implementation.
    // Return the number of rows in the section.
    return [_friends count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    NSDictionary<FBGraphUser>* friend = _friends[indexPath.row];
    
    cell.textLabel.text = friend.name;
    NSString *strurl = [[NSString alloc] initWithFormat:@"https://graph.facebook.com/%@/picture",[[_friends objectAtIndex:indexPath.row] objectForKey:@"id"]];
    NSURL *url=[NSURL URLWithString:strurl];///here you can retrive the image
    NSData *imageData = [NSData dataWithContentsOfURL:url];
    UIImage *profilePic = [UIImage imageWithData:imageData];
    cell.imageView.image = profilePic;
    
    if ([Singleton sharedInstance].selectedUserFBID) {
        if ([Singleton sharedInstance].selectedUserFBID == friend.objectID) {
            
            NSLog(@"shared");
            
            [[NSUserDefaults standardUserDefaults] setObject:[Singleton sharedInstance].selectedUserFBID forKey:@"otherID"];
            
            [self.tableView selectRowAtIndexPath:indexPath animated:YES scrollPosition:UITableViewScrollPositionNone];
        }
    }
    return cell;
}


-(CGFloat)tableView:(UITableView*)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath;
{
    return 50;
}


/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    NSIndexPath *ip = [self.tableView indexPathForSelectedRow];
    NSDictionary<FBGraphUser>* friend = _friends[ip.row];
    NSLog(@"name: %@, id: %@", friend.name, friend.objectID);
    
    [[NSUserDefaults standardUserDefaults] setObject:friend.objectID forKey:@"otherID"];
    //MappingViewController *vc = [segue destinationViewController];
    // Pass the selected object to the new view controller.
}


@end
