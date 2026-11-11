#import <Foundation/Foundation.h>
#import <Security/Security.h>
#import "PlaygroundCodeSigning.h"
#import <mach-o/dyld.h>
#import <objc/runtime.h>
#import <dlfcn.h>

%config(generator=internal)

#import <stdio.h>

#define ERROR(fmt, ...) do { \
    fprintf(stderr, "[InjectPlaygroundSigner] " fmt "\n", ##__VA_ARGS__); \
    fflush(stderr); \
} while (0)

#define FATAL(fmt, ...) do { \
    ERROR(fmt, ##__VA_ARGS__); \
    exit(1); \
} while (0)

#define ERROR_NS(fmt, ...) do { \
    NSString *__msg = [NSString stringWithFormat:fmt, ##__VA_ARGS__]; \
    fprintf(stderr, "[InjectPlaygroundSigner] %s\n", [__msg UTF8String]); \
    fflush(stderr); \
} while (0)

#define FATAL_NS(fmt, ...) do { \
    ERROR_NS(fmt, ##__VA_ARGS__); \
    exit(1); \
} while (0)

typedef SecIdentityRef (*swiftPlaygroundsSigningIdentityFunc_t)(
    void * __attribute__((swift_context)) context,
    void * __attribute__((swift_error_result)) *error
) __attribute__((swiftcall));

static SecIdentityRef getIdentity() {
    void *sym = dlsym(RTLD_DEFAULT, "$s21PlaygroundCodeSigning18CertificateManagerO016swiftPlaygroundsC8IdentitySo03SecH3RefayKFZ");
    
    if (!sym) {
        char *error = dlerror();
        
        if (error) {
            FATAL("Error getting symbol. dlerror() returned: %s", error);
        } else {
            FATAL("Error getting symbol. Unknown error.");
        }
    }
    
    swiftPlaygroundsSigningIdentityFunc_t swiftPlaygroundsSigningIdentity = (swiftPlaygroundsSigningIdentityFunc_t)sym;
    void *swiftError = NULL;
    
    SecIdentityRef identity = swiftPlaygroundsSigningIdentity(NULL, &swiftError);
    
    if (swiftError == NULL && identity != NULL) {
        return identity;
    } else if (swiftError != NULL) {
        NSError *err = CFBridgingRelease(swiftError);
        FATAL_NS(@"[InjectPlaygroundSigner] Error: %@", err);
    } else {
        FATAL("[InjectPlaygroundSigner] Identity and swift error were nonnull.");
    }
}

static void signFiles() {
    Class signerClass = %c(PGSCodeSigner);
    
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
        
        NSError *signError = NULL;
        
        SecIdentityRef identity = getIdentity();
        
        if (!identity) {
            FATAL("[InjectPlaygroundSigner] Failed");
        }
        
        id result = [signerClass signFileAtURL:swizzleURL
                     withIdentity:identity
                     identifier:nil
                     teamID:@"LOCALSPKEY"
                     entitlements:nil
                     codeSignatureFlags:0
                     metadataToPreserve:277
                     signatureSize:0
                     omitAdHocFlag:NO
                     preserveExistingSignature:NO
                     generateEntitlementsDER:YES
                     SDKRoot:nil
                     error:&signError];
              
        NSLog(@"[InjectPlaygroundSigner] Result: %@", result);
        NSLog(@"[InjectPlaygroundSigner] Error: %@", signError);
    }
    
    exit(0);
}

static void image_added_callback(const struct mach_header *mh, intptr_t vmaddr_slide) {
    if (objc_getClass("PGSCodeSigner") != nil) {
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            NSLog(@"[InjectPlaygroundSigner] Signing files...");
            signFiles();
        });
    }
}

%ctor {
    _dyld_register_func_for_add_image(image_added_callback);
}
