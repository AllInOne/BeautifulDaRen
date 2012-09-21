#import <Foundation/Foundation.h>

@protocol UpdateViewControllerProtocol <NSObject>

@required
- (void)updateViewController;
- (void)imageLoadedForContact:(NSString*)contactId;

@end
