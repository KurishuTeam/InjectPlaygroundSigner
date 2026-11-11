#import <Foundation/Foundation.h>
#include <Foundation/NSObjCRuntime.h>
#include <stdint.h>
#import <Security/Security.h>

NS_ASSUME_NONNULL_BEGIN

@interface PGSCodeSigner : NSObject

+ (id)signFileAtURL:(NSURL *)url
      withIdentity:(SecIdentityRef)identity
      identifier:(NSString * _Nullable)identifier
            teamID:(NSString *)teamID
      entitlements:(NSDictionary<NSString *, id> * _Nullable)entitlements
codeSignatureFlags:(uint32_t)codeSignatureFlags
metadataToPreserve:(uint32_t)metadataToPreserve
      signatureSize:(NSInteger)signatureSize
      omitAdHocFlag:(BOOL)omitAdHocFlag
preserveExistingSignature:(BOOL)preserveExistingSignature
generateEntitlementsDER:(BOOL)generateEntitlementsDER
            SDKRoot:(NSURL * _Nullable)sdkRoot
            error:(NSError * _Nullable * _Nullable)error;

@end

NS_ASSUME_NONNULL_END
