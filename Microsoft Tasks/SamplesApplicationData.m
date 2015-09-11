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


@implementation SamplesApplicationData

+(id) getInstance
{
    static SamplesApplicationData *instance = nil;
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        instance = [[self alloc] init];
        NSDictionary *dictionary = [NSDictionary dictionaryWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"settings" ofType:@"plist"]];
        NSString* va = [dictionary objectForKey:@"fullScreen"];
        NSString* sc = [dictionary objectForKey:@"showClaims"];
        instance.fullScreen = [va boolValue];
        instance.showClaims = [sc boolValue];
        instance.clientId = [dictionary objectForKey:@"clientId"];
        instance.authority = [dictionary objectForKey:@"authority"];
        instance.resourceId = [dictionary objectForKey:@"resourceString"];
        instance.scopes = [dictionary objectForKey:@"scopes"];
        instance.additionalScopes = [dictionary objectForKey:@"additionalScopes"];
        instance.redirectUriString = [dictionary objectForKey:@"redirectUri"];
        instance.taskWebApiUrlString = [dictionary objectForKey:@"taskWebAPI"];
        instance.correlationId = [dictionary objectForKey:@"correlationId"];
        instance.signInPolicyId = [dictionary objectForKey:@"signInPolicyId"];
        instance.signUpPolicyId = [dictionary objectForKey:@"signUpPolicyId"];
        
    });
    
    return instance;
}

@end