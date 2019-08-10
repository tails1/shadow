#import "Shadow.h"

@implementation Shadow
- (instancetype)init {
    self = [super init];

    if(self) {
        path_exclusions = [NSMutableSet new];
        path_symlinks = [NSMutableDictionary new];
        path_rules = [NSMutableDictionary new];
        url_schemes = [NSMutableSet new];
    }

    return self;
}

+ (instancetype)shadowWithRules:(NSMutableDictionary *)rules url_schemes:(NSMutableSet *)url_schemes {
    Shadow shadow = [Shadow new];

    if(shadow) {
        [shadow addRules:rules];
        [shadow addURLSchemes:url_schemes];
    }

    return shadow;
}

- (NSDictionary *)exportShadowData {
    NSMutableDictionary *data = [NSMutableDictionary new];

    data[@"rules"] = path_rules;
    data[@"url_schemes"] = url_schemes;

    return [data copy];
}

- (BOOL)isPathRestricted:(NSString *)path {
    return [self isPathRestricted:path exact:NO];
}

- (BOOL)isPathRestricted:(NSString *)path exact:(BOOL)exact {
    if(![path isAbsolutePath]) {
        path = [[[NSFileManager defaultManager] currentDirectoryPath] stringByAppendingPathComponent:path];
    }

    path = [self getDestinationOfLinkAtPath:path];

    NSDictionary *path_rule = [path_rules copy];
    NSString *path_component;
    NSArray *path_components = [path pathComponents];

    for(path_component in path_components) {
        NSDictionary *next = [path_rule[path_component] copy];

        if(!next) {
            if(exact) {
                path_rule = nil;
                break;
            }

            for(NSString *partial_rule in path_rule) {
                if([path_component hasPrefix:partial_rule]) {
                    next = [path_rule[partial_rule] copy];
                    break;
                }
            }

            if(!next) {
                break;
            }
        }

        path_rule = next;
    }

    if(path_rule && path_rule[@"restricted"]) {
        if(exact && path_rule[@"exact_allowed"] && [[path lastPathComponent] isEqualToString:path_component]) {
            return NO;
        }

        return YES;
    }

    return NO;
}

- (BOOL)isURLRestricted:(NSURL *)url {
    return [self isURLRestricted:url exact:NO];
}

- (BOOL)isURLRestricted:(NSURL *)url exact:(BOOL)exact {
    if([url_schemes containsObject:[url scheme]]) {
        return YES;
    }

    if([url isFileURL]) {
        return [self isPathRestricted:[url path] exact:exact];
    }

    return NO;
}

- (void)setDestinationOfLinkAtPath:(NSString *)path destination:(NSString *)destination {
    if(destination) {
        path_symlinks[path] = destination;
    } else {
        [path_symlinks removeObjectForKey:path];
    }
}

- (NSString *)getDestinationOfLinkAtPath:(NSString *)path {
    return path_symlinks[path] ?: path;
}

- (void)addPathExclusion:(NSString *)path {
    [path_exclusions addObject:path];
}

- (void)addRestrictedPath:(NSString *)path restricted:(BOOL)restricted exact_allowed:(BOOL)exact_allowed {
    if([path isAbsolutePath]) {
        NSMutableDictionary *path_rule = path_rules;
        NSArray *path_components = [path pathComponents];
        
        for(NSString *path_component in path_components) {
            NSMutableDictionary *next = path_rule[path_component];

            if(!next) {
                next = [NSMutableDictionary new];

                next[@"restricted"] = @(restricted);
                next[@"exact_allowed"] = @NO;

                path_rule[path_component] = next;
            }

            path_rule = next;
        }

        if(path_rule) {
            path_rule[@"exact_allowed"] = @(exact_allowed);
        }
    }
}

- (void)addRestrictedURLScheme:(NSString *)scheme {
    [url_schemes addObject:scheme];
}

- (void)addRules:(NSMutableDictionary *)rules {
    [path_rules addEntriesFromDictionary:rules];
}

- (void)addURLSchemes:(NSMutableSet *)schemes {
    [url_schemes unionSet:schemes];
}

@end
