#include <CoreFoundation/CoreFoundation.h>
#include <stdio.h>
#include <MobileCoreServices/LSApplicationWorkspace.h>

#ifndef SPRINGBOARDSERVICES_H_
extern int SBSLaunchApplicationWithIdentifier(CFStringRef identifier, Boolean suspended);
extern CFStringRef SBSApplicationLaunchingErrorString(int error);
#endif

int main(int argc, char **argv, char **envp)
{
    int ret;

    if (argc < 2) {
        fprintf(stderr, "Usage: %s com.application.identifier \n", argv[0]);
        return -1;
    }

    CFStringRef identifier = CFStringCreateWithCString(kCFAllocatorDefault, argv[1], kCFStringEncodingUTF8);
    assert(identifier != NULL);

    ret = SBSLaunchApplicationWithIdentifier(identifier, FALSE);

    if (ret != 0) {
        fprintf(stderr, "Couldn't open application: %s. Reason: %i, ", argv[1], ret);
        CFShow(SBSApplicationLaunchingErrorString(ret));

        NSURL *url = [NSURL URLWithString:(NSString*)identifier];
        if (![[LSApplicationWorkspace defaultWorkspace] openURL:url]) {
            fprintf(stderr, "openURL %s also failed.\n", [[url absoluteString] UTF8String]);
        } else {
            ret = 0;
        }
    }

    CFRelease(identifier);

    return ret;
}
