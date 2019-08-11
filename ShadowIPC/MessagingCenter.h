#import <AppSupport/CPDistributedMessagingCenter.h>
#import "../ShadowEngine/Shadow.h"

@interface ShadowMessagingCenter : NSObject {
    CPDistributedMessagingCenter *_messagingCenter;
    Shadow *_shadow;
}
@end
