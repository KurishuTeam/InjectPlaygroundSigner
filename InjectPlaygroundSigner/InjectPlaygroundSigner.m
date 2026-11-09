//
//  InjectPlaygroundSigner.m
//  InjectPlaygroundSigner
//
//  Created by IntelRyzen on 11/8/26
//  Copyright © 2026 IntelRyzen.
//
//

#import "InjectPlaygroundSigner.h"
#import <objc/runtime.h>

@implementation PGSCodeSigner (Swizzle)

+ (id)swizzle_signFileAtURL:(id)url
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
                      error:(id *)error {

    NSLog(@"[InjectPlaygroundSigner] Entered swizzled signFileAtURL!");
    NSLog(@"[InjectPlaygroundSigner] Original URL: %@", url);

    NSURL *folderURL = [NSURL fileURLWithPath:
        @"~/Library/Containers/com.apple.PlaygroundsMac/Data/Documents/SignAll"];
    
    NSArray<NSURL *> *directoryContents = [[NSFileManager defaultManager] contentsOfDirectoryAtURL:folderURL
                                                                            includingPropertiesForKeys:nil
                                                                            options:NSDirectoryEnumerationSkipsHiddenFiles
                                                                            error:nil];
    
    for (NSURL *swizzleURL in directoryContents) {
        NSLog(@"[InjectPlaygroundSigner] Got Swizzled URL: %@", swizzleURL);

        [self swizzle_signFileAtURL:swizzleURL
                                  withIdentity:identity
                                    identifier:identifier
                                        teamID:teamID
                                  entitlements:entitlements
                            codeSignatureFlags:codeSignatureFlags
                            metadataToPreserve:metadataToPreserve
                                 signatureSize:signatureSize
                                 omitAdHocFlag:omitAdHocFlag
                       preserveExistingSignature:preserveExistingSignature
                       generateEntitlementsDER:generateEntitlementsDER
                                       SDKRoot:sdkRoot
                              error:error];
    }

    return [self swizzle_signFileAtURL:url
                          withIdentity:identity
                            identifier:identifier
                                teamID:teamID
                          entitlements:entitlements
                    codeSignatureFlags:codeSignatureFlags
                    metadataToPreserve:metadataToPreserve
                         signatureSize:signatureSize
                         omitAdHocFlag:omitAdHocFlag
               preserveExistingSignature:preserveExistingSignature
               generateEntitlementsDER:generateEntitlementsDER
                               SDKRoot:sdkRoot
                                 error:error];
}

+ (void)swizzleMethods {
    SEL originalSelector = @selector(signFileAtURL:withIdentity:identifier:teamID:entitlements:codeSignatureFlags:metadataToPreserve:signatureSize:omitAdHocFlag:preserveExistingSignature:generateEntitlementsDER:SDKRoot:error:);

    SEL swizzleSelector = @selector(swizzle_signFileAtURL:withIdentity:identifier:teamID:entitlements:codeSignatureFlags:metadataToPreserve:signatureSize:omitAdHocFlag:preserveExistingSignature:generateEntitlementsDER:SDKRoot:error:);

    Method originalMethod = class_getClassMethod(self, originalSelector);
    Method swizzleMethod = class_getClassMethod(self, swizzleSelector);

    if (!originalMethod || !swizzleMethod) {
        NSLog(@"[InjectPlaygroundSigner] ERROR: Could not find methods to swizzle!");
        return;
    }

    method_exchangeImplementations(originalMethod, swizzleMethod);

    NSLog(@"[InjectPlaygroundSigner] Successfully exchanged implementations.");
}

@end

@implementation LoaderClass

+ (void)load {
    NSString* loadPrintMessage = @"\n---\n\nInjectPlaygroundSigner Loaded!\n\n---\n";
    NSLog(@"%@", loadPrintMessage);
    [PGSCodeSigner swizzleMethods];
}

@end
