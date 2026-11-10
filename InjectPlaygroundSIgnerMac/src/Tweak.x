#import <Foundation/Foundation.h>
#import <Security/Security.h>
#import "PlaygroundCodeSigning.h"
#import <mach-o/dyld.h>
#import <objc/runtime.h>

%config(generator=internal)

%group InjectPlaygroundSignerHooks

%hook PGSCodeSigner

+ (id)signFileAtURL:(NSURL *)url
                 withIdentity:(SecIdentityRef)identity
                   identifier:(NSString *)identifier
                       teamID:(NSString *)teamID
                 entitlements:(NSDictionary<NSString *, id> * _Nullable)entitlements
           codeSignatureFlags:(uint32_t)codeSignatureFlags
           metadataToPreserve:(uint32_t)metadataToPreserve
                signatureSize:(NSInteger)signatureSize
                omitAdHocFlag:(BOOL)omitAdHocFlag
    preserveExistingSignature:(BOOL)preserveExistingSignature
      generateEntitlementsDER:(BOOL)generateEntitlementsDER
                      SDKRoot:(NSURL * _Nullable)sdkRoot
                        error:(NSError * _Nullable * _Nullable)error {

    NSString *signAllDirectory =
        [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/SignAll"];
    NSURL *folderURL = [NSURL fileURLWithPath:signAllDirectory];

    NSArray<NSURL *> *directoryContents = [[NSFileManager defaultManager]
          contentsOfDirectoryAtURL:folderURL
        includingPropertiesForKeys:nil
                           options:NSDirectoryEnumerationSkipsHiddenFiles
                             error:nil];

    for (NSURL *swizzleURL in directoryContents) {
        NSLog(@"[InjectPlaygroundSigner] Got Swizzled URL: %@", swizzleURL);
        
        %orig(swizzleURL, identity, identifier, teamID, entitlements,
              codeSignatureFlags, metadataToPreserve, signatureSize,
              omitAdHocFlag, preserveExistingSignature,
              generateEntitlementsDER, sdkRoot, nil);
    }
    
    return %orig(url, identity, identifier, teamID, entitlements,
                 codeSignatureFlags, metadataToPreserve, signatureSize,
                 omitAdHocFlag, preserveExistingSignature,
                 generateEntitlementsDER, sdkRoot, error);
}

%end

%end

static void image_added_callback(const struct mach_header *mh, intptr_t vmaddr_slide) {
    if (objc_getClass("PGSCodeSigner") != nil) {
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            NSLog(@"[InjectPlaygroundSigner] PGSCodeSigner class found, initializing hooks.");
            %init(InjectPlaygroundSignerHooks);
        });
    }
}

%ctor {
    _dyld_register_func_for_add_image(image_added_callback);
}
