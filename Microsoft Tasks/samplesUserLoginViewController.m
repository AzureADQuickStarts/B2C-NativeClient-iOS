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
#import "samplesApplicationData.h"


@interface samplesUserLoginViewController ()


@end

@implementation samplesUserLoginViewController

- (void)viewDidLoad {
    
    UIImageView *backgroundImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"10637393134_3be20f8467_k.jpg"]];
    
    [self.view addSubview:backgroundImage];
    [self.view sendSubviewToBack:backgroundImage];
    
    
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

- (IBAction)signInFBPressed:(id)sender {
    
    SamplesApplicationData* appData = [SamplesApplicationData getInstance];
    samplesPolicyData *aPolicy = [[samplesPolicyData alloc]init];
    
    
    aPolicy.policyID = appData.faceBookSignInPolicyId;
    aPolicy.policyName = @"Facebook";
    
    
    
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

- (IBAction)signInEmailPressed:(id)sender {
    
    SamplesApplicationData* appData = [SamplesApplicationData getInstance];
    samplesPolicyData *aPolicy = [[samplesPolicyData alloc]init];
    
    
    aPolicy.policyID = appData.emailSignInPolicyId;
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


- (IBAction)signUpEmailPressed:(id)sender {
    
    
    SamplesApplicationData* appData = [SamplesApplicationData getInstance];
    samplesPolicyData *aPolicy = [[samplesPolicyData alloc]init];
    
    
    aPolicy.policyID = appData.emailSignUpPolicyId;
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
