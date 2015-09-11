#import "SamplesSelectUserViewController.h"
#import <ADALiOS/ADAuthenticationSettings.h>
#import "ADALiOS/ADAuthenticationContext.h"
#import "samplesUserLoginViewController.h"
#import <Foundation/Foundation.h>
#import "samplesTaskItem.h"
#import "samplesPolicyData.h"
#import "ADALiOS/ADAuthenticationResult.h"

@interface SamplesApplicationData : NSObject

@property (strong) ADTokenCacheStoreItem *userItem;
@property (strong) NSString* taskWebApiUrlString;
@property (strong) NSString* authority;
@property (strong) NSString* clientId;
@property (strong) NSString* resourceId;
@property NSArray* scopes;
@property NSArray* additionalScopes;
@property (strong) NSString* redirectUriString;
@property (strong) NSString* correlationId;
@property (strong) NSString* signInPolicyId;
@property (strong) NSString* signUpPolicyId;
@property BOOL fullScreen;
@property BOOL showClaims;

+(id) getInstance;

@end


@interface SamplesSelectUserViewController ()

@property NSMutableArray *userList;

@end

@implementation SamplesSelectUserViewController


- (void)viewDidLoad
{
    
    [super viewDidLoad];
    self.refreshControl = [[UIRefreshControl alloc] init];
    
    [self.refreshControl addTarget:self action:@selector(refreshInvoked:forState:) forControlEvents:UIControlEventValueChanged];
    
    [self setRefreshControl:self.refreshControl];
    self.userList = [[NSMutableArray alloc] init];

    
    [self loadData];
}

-(void) loadData
{
    ADAuthenticationError* error;
    id<ADTokenCacheStoring> cache = [ADAuthenticationSettings sharedInstance].defaultTokenCacheStore;
    NSArray* array = [cache allItems:&error];
    if (error)
    {
        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:nil message:[[NSString alloc]initWithFormat:@"%@", error.errorDetails] delegate:nil cancelButtonTitle:@"Retry" otherButtonTitles:@"Cancel", nil];
        
        [alertView setDelegate:self];
        
        dispatch_async(dispatch_get_main_queue(),^ {
            [alertView show];
        });
    } else
    {
        NSMutableSet* users = [NSMutableSet new];
        self.userList = [NSMutableArray new];
        for(ADTokenCacheStoreItem* item in array)
        {
            ADProfileInfo *user = item.profileInfo;
            if (!item.profileInfo)
            {
                user = [ADProfileInfo profileInfoWithUsername:@"Unknown user" error:nil];
            }
            if (![users containsObject:user.username])
            {
                //New user, add and print:
                [self.userList addObject:item];
                [users addObject:user.username];
            }
        }
        
        // Refresh main thread since we are async
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tableView reloadData];
        });
    }
}

- (IBAction)cancelPressed:(id)sender
{
    [self.navigationController popToRootViewControllerAnimated:TRUE];
}


-(void) refreshInvoked:(id)sender forState:(UIControlState)state {
    // Refresh table here...
    [self.userList removeAllObjects];
    [self.tableView reloadData];
    [self loadData];
    [self.refreshControl endRefreshing];
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    if (self.userList.count < 1) {
        
    return 1;
    
    }
    else {
        // Display a message when the table is empty
        UILabel *messageLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height)];
        
        messageLabel.text = @"No users are currently available. Please add a user above.";
        messageLabel.textColor = [UIColor blackColor];
        messageLabel.numberOfLines = 0;
        messageLabel.textAlignment = NSTextAlignmentCenter;
        messageLabel.font = [UIFont fontWithName:@"Palatino-Italic" size:20];
        [messageLabel sizeToFit];
        
        self.tableView.backgroundView = messageLabel;
        self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    
    return 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [self.userList count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UserPrototypeCell" forIndexPath:indexPath];
    
    ADTokenCacheStoreItem *userItem = [self.userList objectAtIndex:indexPath.row];
    if(userItem)
    {
        if(userItem.profileInfo){
            
            cell.textLabel.text = userItem.profileInfo.username;
        }
        else
        {
            cell.textLabel.text = @"ADFS User";
        }
    }
    else {
        cell.textLabel.text= @"No logged in users. Add a user above";
    }
    //    if (taskItem.completed) {
    //        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    //    } else {
    //        cell.accessoryType = UITableViewCellAccessoryNone;
    //    }
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    ADTokenCacheStoreItem *userItem = [self.userList objectAtIndex:indexPath.row];
    [self getToken:userItem];
    
    //tappedItem.completed = !tappedItem.completed;
    [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
}

- (void) getToken:(ADTokenCacheStoreItem*) userItem
{
    SamplesApplicationData* appData = [SamplesApplicationData getInstance];
    ADAuthenticationError *error;
    ADAuthenticationContext* authContext = [ADAuthenticationContext authenticationContextWithAuthority:appData.authority validateAuthority:NO error:&error];
    NSString* userId = nil;
    
    if(userItem && userItem.profileInfo){
        if(userItem.profileInfo.username){
            userId = userItem.profileInfo.username;
        }
    }
    
    authContext.parentController = self;
    [ADAuthenticationSettings sharedInstance].enableFullScreen = appData.fullScreen;
    NSURL *redirectUri = [[NSURL alloc]initWithString:appData.redirectUriString];
    
    if(!appData.correlationId ||
       [[appData.correlationId stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] length] == 0)
    {
        authContext.correlationId = [[NSUUID alloc] initWithUUIDString:appData.correlationId];
    }
    

    if(!userItem){
    
    NSURL *redirectUri = [[NSURL alloc]initWithString:appData.redirectUriString];
        [authContext acquireTokenSilentWithScopes:appData.scopes
                                        clientId:appData.clientId
                                     redirectUri:redirectUri
                                      identifier:[ADUserIdentifier identifierWithId:userId type:RequiredDisplayableId]
                                   promptBehavior:AD_CREDENTIALS_AUTO
                          completionBlock:^(ADAuthenticationResult *result) {
                              
                              if (result.status != AD_SUCCEEDED)
                              {
                                  UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:nil message:[[NSString alloc]initWithFormat:@"Error : %@", result.error] delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
                                  
                                  [alertView setDelegate:self];
                                  
                                  dispatch_async(dispatch_get_main_queue(),^ {
                                      [alertView show];
                                  });
                              }
                              else
                              {
                                  SamplesApplicationData* data = [SamplesApplicationData getInstance];
                                  data.userItem = result.tokenCacheStoreItem;
                                  [self cancelPressed:self];
                              }
                          }];
    } else {
        
        [authContext acquireTokenSilentWithScopes:appData.scopes
                                        clientId:appData.clientId
                                     redirectUri:redirectUri
                                      identifier:[ADUserIdentifier identifierWithId:userId type:RequiredDisplayableId]
                                    promptBehavior:AD_CREDENTIALS_AUTO
                                 completionBlock:^(ADAuthenticationResult *result) {
            
            if (result.status != AD_SUCCEEDED)
            {
                UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:nil message:[[NSString alloc]initWithFormat:@"Error : %@", result.error] delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
                
                [alertView setDelegate:self];
                
                dispatch_async(dispatch_get_main_queue(),^ {
                    [alertView show];
                });
            }
            else
            {
                SamplesApplicationData* data = [SamplesApplicationData getInstance];
                data.userItem = result.tokenCacheStoreItem;
                [self cancelPressed:self];
            }
        }];

        
    }
}


- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0)
    {
        [alertView dismissWithClickedButtonIndex:0 animated:NO];
        [self loadData];
    }
}



@end

