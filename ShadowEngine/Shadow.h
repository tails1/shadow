#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface Shadow : NSObject {
    NSMutableSet *path_exclusions;
    NSMutableDictionary *path_symlinks;
    NSMutableDictionary *path_rules;
    NSMutableSet *url_schemes;
}

+ (instancetype)shadowWithRules:(NSMutableDictionary *)rules andURLSchemes:(NSMutableSet *)url_schemes;

- (NSDictionary *)exportShadowData;

- (BOOL)isPathRestricted:(NSString *)path;
- (BOOL)isPathRestricted:(NSString *)path exact:(BOOL)exact;
- (BOOL)isURLRestricted:(NSURL *)url;
- (BOOL)isURLRestricted:(NSURL *)url exact:(BOOL)exact;

- (void)setDestinationOfLinkAtPath:(NSString *)path destination:(NSString *)destination;
- (NSString *)getDestinationOfLinkAtPath:(NSString *)path;

- (void)addPathExclusion:(NSString *)path;
- (void)addRestrictedPath:(NSString *)path parent_restricted:(BOOL)parent_restricted restricted:(BOOL)restricted parent_exact_allowed:(BOOL)parent_exact_allowed exact_allowed:(BOOL)exact_allowed;
- (void)addRestrictedURLScheme:(NSString *)scheme;
- (void)addRules:(NSMutableDictionary *)rules;
- (void)addURLSchemes:(NSMutableSet *)schemes;

@end
