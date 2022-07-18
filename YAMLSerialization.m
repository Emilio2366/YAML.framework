//
//  YAMLSerialization.m
//  YAML Serialization support by Mirek Rusin based on C library LibYAML by Kirill Simonov
//  Released under MIT License
//
//  Copyright 2010 Mirek Rusin
//  Copyright 2010 Stanislav Yudin
//

#import "YAMLSerialization.h"

NSString *const YAMLErrorDomain = @"com.github.mirek.yaml";

// Assumes NSError **error is in the current scope
#define YAML_SET_ERROR(errorCode, description, recovery) \
    if (error) \
        *error = [NSError errorWithDomain: YAMLErrorDomain \
                                     code: errorCode \
                                 userInfo: [NSDictionary dictionaryWithObjectsAndKeys: \
                                            description, NSLocalizedDescriptionKey, \
                                            recovery, NSLocalizedRecoverySuggestionErrorKey, \
                                            nil]]

@implementation YAMLSerialization

#pragma mark Reading YAML

static int
__YAMLSerializationParserInputReadHandler (void *data, unsigned char *buffer, size_t size, size_t *size_read) {
    NSInteger outcome = [(NSInputStream *) data read: (uint8_t *) buffer maxLength: size];
    if (outcome < 0) {
        *size_read = 0;
        return NO;
    } else {
        *size_read = outcome;
        return YES;
    }
+ (NSString *) createYAMLStringWithObject: (id) object options: (YAMLWriteOptions) opt error: (NSError **) error {
    return [[NSString alloc] initWithData: [self YAMLDataWithObject: object options: opt error: error]
                                 encoding: NSUTF8StringEncoding];

}

+ (NSString *) YAMLStringWithObject: (id) object options: (YAMLWriteOptions) opt error: (NSError **) error {
    return [[self createYAMLStringWithObject: object options: opt error: error] autorelease];
}

#pragma mark Deprecated

+ (NSMutableArray *) YAMLWithStream: (NSInputStream *) stream options: (YAMLReadOptions) opt error: (NSError **) error {
    return [self objectsWithYAMLStream: stream options: opt error: error];
}

+ (NSMutableArray *) YAMLWithData: (NSData *) data options: (YAMLReadOptions) opt error: (NSError **) error {
    return [self objectsWithYAMLData: data options: opt error: error];
}

+ (NSData *) dataFromYAML: (id) object options: (YAMLWriteOptions) opt error: (NSError **) error {
    return [self YAMLDataWithObject: object options: opt error: error];
}

+ (BOOL) writeYAML: (id) object toStream: (NSOutputStream *) stream options: (YAMLWriteOptions) opt error: (NSError **) error {
    return [self writeObject: object toYAMLStream: stream options: opt error: error];
}

@end
