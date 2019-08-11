#import <rocketbootstrap/rocketbootstrap.h>
#import "MessagingCenter.h"

@implementation ShadowMessagingCenter
+ (void)load {
    [self sharedInstance];
}

+ (instancetype)sharedInstance {
    static dispatch_once_t once = 0;
    __strong static id sharedInstance = nil;

    dispatch_once(&once, ^{
        sharedInstance = [self new];
    });

    return sharedInstance;
}

- (instancetype)init {
    if((self = [super init])) {
        _messagingCenter = [CPDistributedMessagingCenter centerNamed:@"me.jjolano.shadow"];
        rocketbootstrap_distributedmessagingcenter_apply(_messagingCenter);

        [_messagingCenter runServerOnCurrentThread];
        [_messagingCenter registerForMessageName:@"getShadowData" target:self selector:@selector(handleMessageNamed:withUserInfo:)];
    }

    return self;
}

- (void)setShadowInstance:(Shadow *)shadow {
    _shadow = shadow;
}

- (NSDictionary *)handleMessageNamed:(NSString *)name withUserInfo:(NSDictionary *)userInfo {
    if([name isEqualToString:@"getShadowData"]) {
        if(_shadow) {
            return [_shadow exportShadowData];
        }
    }

    return nil;
}
@end
