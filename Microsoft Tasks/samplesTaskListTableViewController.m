//
//  samplesTaskListTableViewController.m
//  Microsoft Tasks
//
//  Created by Brandon Werner on 3/4/14.
//  Copyright (c) 2014 Microsoft. All rights reserved.
//

#import "samplesTaskListTableViewController.h"
#import "samplesTaskItem.h"
#import "sampleAddTaskItemViewController.h"
#import "samplesWebAPIConnector.h"
#import "SamplesSelectUserViewController.h"
#import <Foundation/Foundation.h>
#import "samplesTaskItem.h"
#import "samplesPolicyData.h"
#import "samplesApplicationData.h"
#import "NXOAuth2.h"


@interface samplesTaskListTableViewController ()

@property NSMutableArray *taskItems;
@property (weak, nonatomic) IBOutlet UILabel* userLabel;

@end

@implementation samplesTaskListTableViewController

-(void)loadData {
    [super viewDidLoad];
    
    
    NXOAuth2AccountStore *store = [NXOAuth2AccountStore sharedStore];
    NSArray *accounts = [store accountsWithAccountType:@"myGraphService"];
    
    if (accounts.count == 0) {
        
        dispatch_async(dispatch_get_main_queue(),^ {
            
            SamplesSelectUserViewController* userSelectController = [self.storyboard instantiateViewControllerWithIdentifier:@"LoginUserView"];
            [self.navigationController pushViewController:userSelectController animated:YES];
        });
    }


    
    // Load data from the webservice
    
    if (accounts.count > 0) {
    [samplesWebAPIConnector getTaskList:^(NSArray *tasks, NSError* error) {
        
        
        if (error != nil && accounts.count)
        {
            
            UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:nil message:[[NSString alloc]initWithFormat:@"%@", error.localizedDescription] delegate:nil cancelButtonTitle:@"Retry" otherButtonTitles:@"Cancel", nil];
            
            [alertView setDelegate:self];
            
            dispatch_async(dispatch_get_main_queue(),^ {
                [alertView show];
            });

        }
        
                           
        else
        {
            self.taskItems = (NSMutableArray*)tasks;
            
            // Refresh main thread since we are async
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.tableView reloadData];
                if(accounts.count)
                {
                    [self.userLabel setText:@"Hi"];
                }
                else
                {
                    [self.userLabel setText:@"No Logged in user"];
                }
            });
        }
    } parent:self];
    } }

- (IBAction)switchUserPressed:(id)sender {
    
    [samplesWebAPIConnector signOut];
    [self.taskItems removeAllObjects];
    
    // Refresh main thread since we are async
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.tableView reloadData];
    });
    
    [self loadData];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.refreshControl = [[UIRefreshControl alloc] init];
    
    [self.refreshControl addTarget:self action:@selector(refreshInvoked:forState:) forControlEvents:UIControlEventValueChanged];
    
    [self setRefreshControl:self.refreshControl];
    self.taskItems = [[NSMutableArray alloc] init];
    [self loadData];
}

-(void)viewDidAppear:(BOOL)animated
{
    
    SamplesApplicationData* appData = [SamplesApplicationData getInstance];
    NXOAuth2AccountStore *store = [NXOAuth2AccountStore sharedStore];
    NSArray *accounts = [store accountsWithAccountType:@"myGraphService"];
    
    if(appData.userItem)
    {
        [self loadData];
    }
    
    if(accounts.count)
    {
        [self.userLabel setText:@"Hello"];    }
    else
    {
        [self.userLabel setText:@"N/A" ];
    }
}


-(void) refreshInvoked:(id)sender forState:(UIControlState)state {
    // Refresh table here...
    

    [self.taskItems removeAllObjects];
    [self.tableView reloadData];
    [self loadData];
    [self.refreshControl endRefreshing];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [self.taskItems count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TaskPrototypeCell" forIndexPath:indexPath];
    
    samplesTaskItem *taskItem = [self.taskItems objectAtIndex:indexPath.row];
    cell.textLabel.text = taskItem.itemName;
    
    if (taskItem.completed) {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    } else {
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    samplesTaskItem *tappedItem = [self.taskItems objectAtIndex:indexPath.row];
    tappedItem.completed = !tappedItem.completed;
    [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
}

// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}



// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        
        
        samplesTaskItem *selectedItem = [self.taskItems objectAtIndex:indexPath.row];
        [samplesWebAPIConnector deleteTask:selectedItem parent:self completionBlock:^(bool success, NSError* error) {
            
            if (error != nil) {
                
                UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:nil message:[[NSString alloc]initWithFormat:@"Error : %@", error.localizedDescription] delegate:nil cancelButtonTitle:@"Retry" otherButtonTitles:@"Cancel", nil];
                
                [alertView setDelegate:self];
                
                dispatch_async(dispatch_get_main_queue(),^ {
                    [alertView show];
                });
            }
            
        }];
        
        [self.taskItems removeObjectAtIndex:indexPath.row];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
        
    }
    
    [self.taskItems removeAllObjects];
    [self.tableView reloadData];
    [self loadData];
    
    
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0)
    {
        [alertView dismissWithClickedButtonIndex:0 animated:NO];
    }
}

- (IBAction)unwindToList:(UIStoryboardSegue *)segue {
    
}


@end
