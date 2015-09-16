//
//  samplesApplicationData.h
//  Microsoft Tasks for Consumers
//
//  Created by Brandon Werner on 9/14/15.
//  Copyright © 2015 Microsoft. All rights reserved.
//

#ifndef samplesApplicationData_h
#define samplesApplicationData_h

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
@property NSMutableArray* scopes;
@property NSMutableArray* additionalScopes;
@property (strong) NSString* redirectUriString;
@property (strong) NSString* correlationId;
@property (strong) NSString* faceBookSignInPolicyId;
@property (strong) NSString* emailSignInPolicyId;
@property (strong) NSString* emailSignUpPolicyId;
@property BOOL fullScreen;
@property BOOL showClaims;

+(id) getInstance;

@end


#endif /* samplesApplicationData_h */
