//
//  InjectPlaygroundSigner.h
//  InjectPlaygroundSigner
//
//  Created by IntelRyzen on 11/8/26
//  Copyright © 2026 IntelRyzen.
//
//

#import <Foundation/Foundation.h>

@interface PGSCodeSigner : NSObject

+ (id)signFileAtURL:(id)url
       withIdentity:(SecIdentityRef)identity
         identifier:(id)identifier
             teamID:(id)teamID
       entitlements:(id)entitlements
 codeSignatureFlags:(uint32_t)codeSignatureFlags
 metadataToPreserve:(uint32_t)metadataToPreserve
      signatureSize:(int64_t)signatureSize
      omitAdHocFlag:(BOOL)omitAdHocFlag
preserveExistingSignature:(BOOL)preserveExistingSignature
generateEntitlementsDER:(BOOL)generateEntitlementsDER
            SDKRoot:(id)sdkRoot
              error:(id *)error;

@end

@interface LoaderClass : NSObject

@end
