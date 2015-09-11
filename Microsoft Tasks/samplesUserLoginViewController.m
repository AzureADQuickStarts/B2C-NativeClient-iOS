//
//  samplesUserLoginViewController.m
//  Microsoft Tasks
//
//  Created by Brandon Werner on 4/20/15.
//  Copyright (c) 2015 Microsoft. All rights reserved.
//

#import "samplesUserLoginViewController.h"
#import "samplesWebAPIConnector.h"
#import "samplesUseViewController.h"
#import "samplesPolicyData.h"
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


@interface samplesUserLoginViewController ()


@end

@implementation samplesUserLoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)signInPressed:(id)sender {
    
    SamplesApplicationData* appData = [SamplesApplicationData getInstance];
    samplesPolicyData *aPolicy = [[samplesPolicyData alloc]init];
    
    
    aPolicy.policyID = appData.signInPolicyId;
    aPolicy.policyName = @"Sign In";
    
    
    
    [samplesWebAPIConnector doPolicy:aPolicy parent:self completionBlock:^(ADProfileInfo* userInfo, NSError* error) {
        if (userInfo && appData.showClaims)
        {
            dispatch_sync(dispatch_get_main_queue(), ^{
            samplesUseViewController* claimsController = [self.storyboard instantiateViewControllerWithIdentifier:@"ClaimsView"];
            claimsController.claims = [NSString stringWithFormat:@" Claims : %@", userInfo.allClaims];
            [self.navigationController pushViewController:claimsController animated:NO];
            });
        }
        else if (userInfo)
        {
            dispatch_sync(dispatch_get_main_queue(), ^{
            [self.navigationController popToRootViewControllerAnimated:TRUE];
                });
        }
        
        else
        {
            UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:nil message:[[NSString alloc]initWithFormat:@"Error : %@", error.localizedDescription] delegate:nil cancelButtonTitle:@"Retry" otherButtonTitles:@"Cancel", nil];
            
            [alertView setDelegate:self];
            
            dispatch_async(dispatch_get_main_queue(),^ {
                [alertView show];
            });
        }
        
    }];

}

- (IBAction)signUpPressed:(id)sender {
    
    
    SamplesApplicationData* appData = [SamplesApplicationData getInstance];
    samplesPolicyData *aPolicy = [[samplesPolicyData alloc]init];
    
    
    aPolicy.policyID = appData.signUpPolicyId;
    aPolicy.policyName = @"Sign Up";
    
    
    
    [samplesWebAPIConnector doPolicy:aPolicy parent:self completionBlock:^(ADProfileInfo* userInfo, NSError* error) {
        if (userInfo && appData.showClaims)
        {
            dispatch_sync(dispatch_get_main_queue(), ^{
            samplesUseViewController* claimsController = [self.storyboard instantiateViewControllerWithIdentifier:@"ClaimsView"];
            claimsController.claims = [NSString stringWithFormat:@" Claims : %@", userInfo.allClaims];
            [self.navigationController pushViewController:claimsController animated:NO];
            });
        }
        else if (userInfo)
        {
             dispatch_sync(dispatch_get_main_queue(), ^{
            [self.navigationController popToRootViewControllerAnimated:TRUE];
                 });
        }
        
        else
        {
            UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:nil message:[[NSString alloc]initWithFormat:@"Error : %@", error.localizedDescription] delegate:nil cancelButtonTitle:@"Retry" otherButtonTitles:@"Cancel", nil];
            
            [alertView setDelegate:self];
            
            dispatch_async(dispatch_get_main_queue(),^ {
                [alertView show];
            });
        }
        
    }];

}
@end
