#import <XCTest/XCTest.h>

#import "VFXCallbackUrlParser.h"

@interface VFXCallbackUrlParserTests : XCTestCase

@end

@implementation VFXCallbackUrlParserTests

- (void)testParse {
    NSURL *url = [NSURL URLWithString:@"scheme://x-callback-url/action?keyA=valueA&keyB=valueB&x-source=sourceValue&x-success=successValue&x-error=errorValue&x-cancel=cancelValue"];
    
    VFXCallbackUrlParseResult *result = [VFXCallbackUrlParser parseUrl:url];
    
    XCTAssertEqualObjects(result.url, url, @"");
    XCTAssertEqualObjects(result.scheme, @"scheme", @"");
    XCTAssertEqualObjects(result.host, @"x-callback-url", @"");
    XCTAssertEqualObjects(result.action, @"action", @"");
    XCTAssertEqualObjects(result.source, @"sourceValue", @"");
    XCTAssertEqualObjects(result.successCallback, @"successValue", @"");
    XCTAssertEqualObjects(result.errorCallback, @"errorValue", @"");
    XCTAssertEqualObjects(result.cancelCallback, @"cancelValue", @"");
    
    XCTAssertEqual(result.parameters.allKeys.count, 2, @"");
    XCTAssertEqual(result.parameters.allValues.count, 2, @"");
    XCTAssertEqualObjects(result.parameters[@"keyA"], @"valueA", @"");
    XCTAssertEqualObjects(result.parameters[@"keyB"], @"valueB", @"");
}

- (void)testParse_decodeUrl {
    NSURL *url = [NSURL URLWithString:@"scheme://x-callback-url/action?keyA=value%20A&%D0%BA%D0%BB%D1%8E%D1%87%20%D0%91=%D0%B7%D0%BD%D0%B0%D1%87%D0%B5%D0%BD%D0%B8%D0%B5%20%D0%91&x-source=sourceValue&x-success=success://action&x-error=error://action&x-cancel=cancel://action"];
    
    VFXCallbackUrlParseResult *result = [VFXCallbackUrlParser parseUrl:url];
    
    XCTAssertEqualObjects(result.url, url, @"");
    XCTAssertEqualObjects(result.scheme, @"scheme", @"");
    XCTAssertEqualObjects(result.host, @"x-callback-url", @"");
    XCTAssertEqualObjects(result.action, @"action", @"");
    XCTAssertEqualObjects(result.source, @"sourceValue", @"");
    XCTAssertEqualObjects(result.successCallback, @"success://action", @"");
    XCTAssertEqualObjects(result.errorCallback, @"error://action", @"");
    XCTAssertEqualObjects(result.cancelCallback, @"cancel://action", @"");
    
    XCTAssertEqual(result.parameters.allKeys.count, 2, @"");
    XCTAssertEqual(result.parameters.allValues.count, 2, @"");
    XCTAssertEqualObjects(result.parameters[@"keyA"], @"value A", @"");
    XCTAssertEqualObjects(result.parameters[@"ключ Б"], @"значение Б", @"");
}

- (void)testParse_decodeUrl_specialCharacters {
    NSURL *url = [NSURL URLWithString:@"scheme://x-callback-url/action?key%2F%25%26%3D%3F%24%23%2B%2D%7E%40%3C%3E%7C%5C%2A%2C%2E%28%29%5B%5D%7B%7D%5E%21=value%D0%90%D0%91%D0%92%2F%25%26%3D%3F%24%23%2B%2D%7E%40%3C%3E%7C%5C%2A%2C%2E%28%29%5B%5D%7B%7D%5E%21"];
    
    VFXCallbackUrlParseResult *result = [VFXCallbackUrlParser parseUrl:url];
    
    XCTAssertEqual(result.parameters.allKeys.count, 1, @"");
    XCTAssertEqual(result.parameters.allValues.count, 1, @"");
    XCTAssertEqualObjects(result.parameters[@"key/%&=?$#+-~@<>|\\*,.()[]{}^!"], @"valueАБВ/%&=?$#+-~@<>|\\*,.()[]{}^!", @"");
}

- (void)testFormatEncodedQueryStringWithParameters {
    NSString *query = [VFXCallbackUrlParser formatEncodedQueryStringWithParameters:@{@"key1": @"value1",
                                                                                     @"key2": @"value2"}];
    NSArray *components1 = [query componentsSeparatedByString:@"&"];
    XCTAssertEqual(components1.count, 2, @"");
    
    for (NSString *pair in components1) {
        NSArray *components2 = [pair componentsSeparatedByString:@"="];
        XCTAssertEqual(components2.count, 2, @"");
        NSString *key = components2[0];
        NSString *value = components2[1];
        XCTAssertTrue([key isEqualToString:@"key1"] || [key isEqualToString:@"key2"], @"");
        XCTAssertTrue([value isEqualToString:@"value1"] || [value isEqualToString:@"value2"], @"");
    }
}

- (void)testFormatEncodedQueryStringWithParameters_specialCharacters {
    NSDictionary *parameters = @{@"key/%&=?$#+-~@<>|\\*,.()[]{}^!": @"valueАБВ/%&=?$#+-~@<>|\\*,.()[]{}^!"};
    NSString *query = [VFXCallbackUrlParser formatEncodedQueryStringWithParameters:parameters];
    XCTAssertEqualObjects(query, @"key%2F%25%26%3D%3F%24%23%2B%2D%7E%40%3C%3E%7C%5C%2A%2C%2E%28%29%5B%5D%7B%7D%5E%21=value%D0%90%D0%91%D0%92%2F%25%26%3D%3F%24%23%2B%2D%7E%40%3C%3E%7C%5C%2A%2C%2E%28%29%5B%5D%7B%7D%5E%21", @"");
}

@end
