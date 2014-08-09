#import <XCTest/XCTest.h>

#import "VFXCallbackUrlRequest.h"

@interface VFXCallbackUrlRequest_fromUrlTests : XCTestCase

@end

@implementation VFXCallbackUrlRequest_fromUrlTests

- (void)testRequestFromUrl {
    NSURL *url = [NSURL URLWithString:@"scheme://x-callback-url/action?keyA=valueA&keyB=valueB&x-source=sourceValue&x-success=successValue&x-error=errorValue&x-cancel=cancelValue"];
    
    VFXCallbackUrlRequest *request = [VFXCallbackUrlRequest requestFromUrl:url];
    
    XCTAssertEqualObjects(request.scheme, @"scheme", @"");
    XCTAssertEqualObjects(request.host, @"x-callback-url", @"");
    XCTAssertEqualObjects(request.action, @"action", @"");
    XCTAssertEqualObjects(request.source, @"sourceValue", @"");
    XCTAssertEqualObjects(request.successCallback, @"successValue", @"");
    XCTAssertEqualObjects(request.errorCallback, @"errorValue", @"");
    XCTAssertEqualObjects(request.cancelCallback, @"cancelValue", @"");
    
    XCTAssertEqual(request.parameters.allKeys.count, 2, @"");
    XCTAssertEqual(request.parameters.allValues.count, 2, @"");
    XCTAssertEqualObjects(request.parameters[@"keyA"], @"valueA", @"");
    XCTAssertEqualObjects(request.parameters[@"keyB"], @"valueB", @"");
}

- (void)testRequestFromUrl_decodeUrl {
    NSURL *url = [NSURL URLWithString:@"scheme://x-callback-url/action?keyA=value%20A&%D0%BA%D0%BB%D1%8E%D1%87%20%D0%91=%D0%B7%D0%BD%D0%B0%D1%87%D0%B5%D0%BD%D0%B8%D0%B5%20%D0%91&x-source=sourceValue&x-success=success://action&x-error=error://action&x-cancel=cancel://action"];
    
    VFXCallbackUrlRequest *request = [VFXCallbackUrlRequest requestFromUrl:url];
    
    XCTAssertEqualObjects(request.scheme, @"scheme", @"");
    XCTAssertEqualObjects(request.host, @"x-callback-url", @"");
    XCTAssertEqualObjects(request.action, @"action", @"");
    XCTAssertEqualObjects(request.source, @"sourceValue", @"");
    XCTAssertEqualObjects(request.successCallback, @"success://action", @"");
    XCTAssertEqualObjects(request.errorCallback, @"error://action", @"");
    XCTAssertEqualObjects(request.cancelCallback, @"cancel://action", @"");
    
    XCTAssertEqual(request.parameters.allKeys.count, 2, @"");
    XCTAssertEqual(request.parameters.allValues.count, 2, @"");
    XCTAssertEqualObjects(request.parameters[@"keyA"], @"value A", @"");
    XCTAssertEqualObjects(request.parameters[@"ключ Б"], @"значение Б", @"");
}

- (void)testRequestFromUrl_decodeUrl_specialCharacters {
    NSURL *url = [NSURL URLWithString:@"scheme://x-callback-url/action?key%2F%25%26%3D%3F%24%23%2B%2D%7E%40%3C%3E%7C%5C%2A%2C%2E%28%29%5B%5D%7B%7D%5E%21=value%D0%90%D0%91%D0%92%2F%25%26%3D%3F%24%23%2B%2D%7E%40%3C%3E%7C%5C%2A%2C%2E%28%29%5B%5D%7B%7D%5E%21"];
    
    VFXCallbackUrlRequest *request = [VFXCallbackUrlRequest requestFromUrl:url];
    
    XCTAssertEqual(request.parameters.allKeys.count, 1, @"");
    XCTAssertEqual(request.parameters.allValues.count, 1, @"");
    XCTAssertEqualObjects(request.parameters[@"key/%&=?$#+-~@<>|\\*,.()[]{}^!"], @"valueАБВ/%&=?$#+-~@<>|\\*,.()[]{}^!", @"");
}

@end
