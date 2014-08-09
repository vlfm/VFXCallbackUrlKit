#import <XCTest/XCTest.h>

#import "VFXCallbackUrlRequest.h"

@interface VFXCallbackUrlRequest_asUrlTests : XCTestCase

@end

@implementation VFXCallbackUrlRequest_asUrlTests

- (void)testAsUrl_scheme {
    VFXCallbackUrlRequest *request = [VFXCallbackUrlRequest requestWithScheme:@"scheme"
                                                                       action:@""
                                                                   parameters:@{}
                                                                       source:@""
                                                              successCallback:@""
                                                                errorCallback:@""
                                                               cancelCallback:@""];
    NSURL * url = request.asUrl;
    XCTAssertEqualObjects(url.absoluteString, @"scheme://x-callback-url", @"");
}

- (void)testAsUrl_noScheme {
    VFXCallbackUrlRequest *request = [VFXCallbackUrlRequest requestWithScheme:@""
                                                                       action:@"action"
                                                                   parameters:@{@"key": @"value"}
                                                                       source:@"source"
                                                              successCallback:@"successCallback"
                                                                errorCallback:@"errorCallback"
                                                               cancelCallback:@"cancelCallback"];
    NSURL * url = request.asUrl;
    XCTAssertNil(url, @"");
}

- (void)testAsUrl_action {
    VFXCallbackUrlRequest *request = [VFXCallbackUrlRequest requestWithScheme:@"scheme"
                                                                       action:@"action"
                                                                   parameters:@{}
                                                                       source:@""
                                                              successCallback:@""
                                                                errorCallback:@""
                                                               cancelCallback:@""];
    NSURL * url = request.asUrl;
    XCTAssertEqualObjects(url.absoluteString, @"scheme://x-callback-url/action", @"");
}

- (void)testAsUrl_parameters {
    VFXCallbackUrlRequest *request = [VFXCallbackUrlRequest requestWithScheme:@"scheme"
                                                                       action:@"action"
                                                                   parameters:@{@"key": @"value"}
                                                                       source:@""
                                                              successCallback:@""
                                                                errorCallback:@""
                                                               cancelCallback:@""];
    NSURL * url = request.asUrl;
    [self assertUrl:url startsWith:@"scheme://x-callback-url/action?" hasQueryParameters:@{@"key": @"value"}];
}

- (void)testAsUrl_source {
    VFXCallbackUrlRequest *request = [VFXCallbackUrlRequest requestWithScheme:@"scheme"
                                                                       action:@"action"
                                                                   parameters:@{}
                                                                       source:@"source"
                                                              successCallback:@""
                                                                errorCallback:@""
                                                               cancelCallback:@""];
    NSURL * url = request.asUrl;
    [self assertUrl:url startsWith:@"scheme://x-callback-url/action?" hasQueryParameters:@{@"x%2Dsource": @"source"}];
}

- (void)testAsUrl_successCallback {
    VFXCallbackUrlRequest *request = [VFXCallbackUrlRequest requestWithScheme:@"scheme"
                                                                       action:@"action"
                                                                   parameters:@{}
                                                                       source:@""
                                                              successCallback:@"successCallback"
                                                                errorCallback:@""
                                                               cancelCallback:@""];
    NSURL * url = request.asUrl;
    [self assertUrl:url startsWith:@"scheme://x-callback-url/action?" hasQueryParameters:@{@"x%2Dsuccess": @"successCallback"}];
}

- (void)testAsUrl_errorCallback {
    VFXCallbackUrlRequest *request = [VFXCallbackUrlRequest requestWithScheme:@"scheme"
                                                                       action:@"action"
                                                                   parameters:@{}
                                                                       source:@""
                                                              successCallback:@""
                                                                errorCallback:@"errorCallback"
                                                               cancelCallback:@""];
    NSURL * url = request.asUrl;
    [self assertUrl:url startsWith:@"scheme://x-callback-url/action?" hasQueryParameters:@{@"x%2Derror": @"errorCallback"}];
}

- (void)testAsUrl_cancelCallback {
    VFXCallbackUrlRequest *request = [VFXCallbackUrlRequest requestWithScheme:@"scheme"
                                                                       action:@"action"
                                                                   parameters:@{}
                                                                       source:@""
                                                              successCallback:@""
                                                                errorCallback:@""
                                                               cancelCallback:@"cancelCallback"];
    NSURL * url = request.asUrl;
    [self assertUrl:url startsWith:@"scheme://x-callback-url/action?" hasQueryParameters:@{@"x%2Dcancel": @"cancelCallback"}];
}

- (void)testAsUrl {
    VFXCallbackUrlRequest *request = [VFXCallbackUrlRequest requestWithScheme:@"scheme"
                                                                       action:@"action"
                                                                   parameters:@{@"key": @"value"}
                                                                       source:@"source"
                                                              successCallback:@"successCallback"
                                                                errorCallback:@"errorCallback"
                                                               cancelCallback:@"cancelCallback"];
    NSURL * url = request.asUrl;
    [self assertUrl:url startsWith:@"scheme://x-callback-url/action?" hasQueryParameters:@{@"key": @"value",
                                                                                           @"x%2Dsource": @"source",
                                                                                           @"x%2Dsuccess": @"successCallback",
                                                                                           @"x%2Derror": @"errorCallback",
                                                                                           @"x%2Dcancel": @"cancelCallback"}];
}

- (void)testAsUrl_encoding {
    VFXCallbackUrlRequest *request = [VFXCallbackUrlRequest requestWithScheme:@"scheme"
                                                                       action:@"action"
                                                                   parameters:@{@"АБВ/%&=?$#+-~@<>|\\*,.()[]{}^!": @"АБВ/%&=?$#+-~@<>|\\*,.()[]{}^!"}
                                                                       source:@"АБВ/%&=?$#+-~@<>|\\*,.()[]{}^!"
                                                              successCallback:@"АБВ/%&=?$#+-~@<>|\\*,.()[]{}^!"
                                                                errorCallback:@"АБВ/%&=?$#+-~@<>|\\*,.()[]{}^!"
                                                               cancelCallback:@"АБВ/%&=?$#+-~@<>|\\*,.()[]{}^!"];
    NSURL * url = request.asUrl;
    [self assertUrl:url startsWith:@"scheme://x-callback-url/action?" hasQueryParameters:@{@"%D0%90%D0%91%D0%92%2F%25%26%3D%3F%24%23%2B%2D%7E%40%3C%3E%7C%5C%2A%2C%2E%28%29%5B%5D%7B%7D%5E%21": @"%D0%90%D0%91%D0%92%2F%25%26%3D%3F%24%23%2B%2D%7E%40%3C%3E%7C%5C%2A%2C%2E%28%29%5B%5D%7B%7D%5E%21",
                                                                                           @"x%2Dsource": @"%D0%90%D0%91%D0%92%2F%25%26%3D%3F%24%23%2B%2D%7E%40%3C%3E%7C%5C%2A%2C%2E%28%29%5B%5D%7B%7D%5E%21",
                                                                                           @"x%2Dsuccess": @"%D0%90%D0%91%D0%92%2F%25%26%3D%3F%24%23%2B%2D%7E%40%3C%3E%7C%5C%2A%2C%2E%28%29%5B%5D%7B%7D%5E%21",
                                                                                           @"x%2Derror": @"%D0%90%D0%91%D0%92%2F%25%26%3D%3F%24%23%2B%2D%7E%40%3C%3E%7C%5C%2A%2C%2E%28%29%5B%5D%7B%7D%5E%21",
                                                                                           @"x%2Dcancel": @"%D0%90%D0%91%D0%92%2F%25%26%3D%3F%24%23%2B%2D%7E%40%3C%3E%7C%5C%2A%2C%2E%28%29%5B%5D%7B%7D%5E%21"}];
}

- (void)testFormatEncodedQueryStringWithParameters {
    NSString *query = [VFXCallbackUrlRequest formatEncodedQueryStringWithParameters:@{@"key1": @"value1",
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
    NSString *query = [VFXCallbackUrlRequest formatEncodedQueryStringWithParameters:parameters];
    XCTAssertEqualObjects(query, @"key%2F%25%26%3D%3F%24%23%2B%2D%7E%40%3C%3E%7C%5C%2A%2C%2E%28%29%5B%5D%7B%7D%5E%21=value%D0%90%D0%91%D0%92%2F%25%26%3D%3F%24%23%2B%2D%7E%40%3C%3E%7C%5C%2A%2C%2E%28%29%5B%5D%7B%7D%5E%21", @"");
}

#pragma mark assert

- (void)assertUrl:(NSURL *)url startsWith:(NSString *)prefix hasQueryParameters:(NSDictionary *)queryParameters {
    XCTAssertTrue([url.absoluteString hasPrefix:prefix], @"");
    XCTAssertEqualObjects(queryParameters, [self queryParametersFromUrl:url], @"");
}

#pragma mark utility

- (NSDictionary *)queryParametersFromUrl:(NSURL *)url {
    NSMutableDictionary *queryParameters = [NSMutableDictionary dictionary];
    
    NSArray *components1 = [url.query componentsSeparatedByString:@"&"];
    
    for (NSString *pair in components1) {
        NSArray *components2 = [pair componentsSeparatedByString:@"="];
        NSString *key = components2[0];
        NSString *value = components2[1];
        queryParameters[key] = value;
    }
    
    return queryParameters;
}

@end
