#import <XCTest/XCTest.h>

#import "VFXCallbackUrlHandler.h"
#import "VFXCallbackUrlRequest.h"
#import "VFXCallbackUrlRequirements.h"

@interface VFXCallbackUrlHandlerTests : XCTestCase

@end

@implementation VFXCallbackUrlHandlerTests {
    BOOL _processingCompleted;
}

- (void)setUp {
    [super setUp];
    _processingCompleted = NO;
}

- (void)tearDown {
    XCTAssertTrue(_processingCompleted, @"");
    [super tearDown];
}

- (void)testHandleUrl {
    [self performTestWithURLString:@"scheme://x-callback-url/action?keyA=valueA&keyB=valueB&x-source=sourceValue&x-success=successValue&x-error=errorValue&x-cancel=cancelValue" requirements:nil assertBlock:^(VFXCallbackUrlRequest *request, NSArray *errors) {
        
        XCTAssertEqualObjects(request.source, @"sourceValue", @"");
        XCTAssertEqual(request.parameters.allKeys.count, 2, @"");
        XCTAssertEqual(request.parameters.allValues.count, 2, @"");
        XCTAssertEqualObjects(request.parameters[@"keyA"], @"valueA", @"");
        XCTAssertEqualObjects(request.parameters[@"keyB"], @"valueB", @"");
        XCTAssertEqual(errors.count, 0, @"");
        XCTAssertEqualObjects(request.successCallback, @"successValue", @"");
        XCTAssertEqualObjects(request.errorCallback, @"errorValue", @"");
        XCTAssertEqualObjects(request.cancelCallback, @"cancelValue", @"");
    }];
}

- (void)testHandleUrl_sourceRequired {
    VFXCallbackUrlRequirements *requirements = [VFXCallbackUrlRequirements new];
    requirements.sourceRequired = YES;
    
    [self performTestWithURLString:@"scheme://x-callback-url/action?keyA=valueA&keyB=valueB&x-success=successValue&x-error=errorValue&x-cancel=cancelValue" requirements:requirements assertBlock:^(VFXCallbackUrlRequest *request, NSArray *errors) {
        
        XCTAssertNil(request.source, @"");
        XCTAssertEqual(request.parameters.allKeys.count, 2, @"");
        XCTAssertEqual(request.parameters.allValues.count, 2, @"");
        XCTAssertEqualObjects(request.parameters[@"keyA"], @"valueA", @"");
        XCTAssertEqualObjects(request.parameters[@"keyB"], @"valueB", @"");
        XCTAssertEqualObjects(request.successCallback, @"successValue", @"");
        XCTAssertEqualObjects(request.errorCallback, @"errorValue", @"");
        XCTAssertEqualObjects(request.cancelCallback, @"cancelValue", @"");
        
        XCTAssertEqual(errors.count, 1, @"");
        
        NSError *error = errors[0];
        XCTAssertEqualObjects(error.domain, VFXCallbackUrlErrorDomain, @"");
        XCTAssertEqual(error.code, VFXCallbackUrlErrorMissingParameter, @"");
        XCTAssertEqualObjects(error.userInfo, @{@"parameter": VFXCallbackUrlXSource}, @"");
    }];
}

- (void)testHandleUrl_successCallbackRequired {
    VFXCallbackUrlRequirements *requirements = [VFXCallbackUrlRequirements new];
    requirements.successCallbackRequired = YES;
    
    [self performTestWithURLString:@"scheme://x-callback-url/action?keyA=valueA&keyB=valueB&x-source=sourceValue&x-error=errorValue&x-cancel=cancelValue" requirements:requirements assertBlock:^(VFXCallbackUrlRequest *request, NSArray *errors) {
        
        XCTAssertEqualObjects(request.source, @"sourceValue", @"");
        XCTAssertEqual(request.parameters.allKeys.count, 2, @"");
        XCTAssertEqual(request.parameters.allValues.count, 2, @"");
        XCTAssertEqualObjects(request.parameters[@"keyA"], @"valueA", @"");
        XCTAssertEqualObjects(request.parameters[@"keyB"], @"valueB", @"");
        XCTAssertNil(request.successCallback, @"");
        XCTAssertEqualObjects(request.errorCallback, @"errorValue", @"");
        XCTAssertEqualObjects(request.cancelCallback, @"cancelValue", @"");
        
        XCTAssertEqual(errors.count, 1, @"");
        
        NSError *error = errors[0];
        XCTAssertEqualObjects(error.domain, VFXCallbackUrlErrorDomain, @"");
        XCTAssertEqual(error.code, VFXCallbackUrlErrorMissingParameter, @"");
        XCTAssertEqualObjects(error.userInfo, @{@"parameter": VFXCallbackUrlXSuccess}, @"");
    }];
}

- (void)testHandleUrl_errorCallbackRequired {
    VFXCallbackUrlRequirements *requirements = [VFXCallbackUrlRequirements new];
    requirements.errorCallbackRequired = YES;
    
    [self performTestWithURLString:@"scheme://x-callback-url/action?keyA=valueA&keyB=valueB&x-source=sourceValue&x-success=successValue&x-cancel=cancelValue" requirements:requirements assertBlock:^(VFXCallbackUrlRequest *request, NSArray *errors) {
        
        XCTAssertEqualObjects(request.source, @"sourceValue", @"");
        XCTAssertEqual(request.parameters.allKeys.count, 2, @"");
        XCTAssertEqual(request.parameters.allValues.count, 2, @"");
        XCTAssertEqualObjects(request.parameters[@"keyA"], @"valueA", @"");
        XCTAssertEqualObjects(request.parameters[@"keyB"], @"valueB", @"");
        XCTAssertEqualObjects(request.successCallback, @"successValue", @"");
        XCTAssertNil(request.errorCallback, @"");
        XCTAssertEqualObjects(request.cancelCallback, @"cancelValue", @"");
        
        XCTAssertEqual(errors.count, 1, @"");
        
        NSError *error = errors[0];
        XCTAssertEqualObjects(error.domain, VFXCallbackUrlErrorDomain, @"");
        XCTAssertEqual(error.code, VFXCallbackUrlErrorMissingParameter, @"");
        XCTAssertEqualObjects(error.userInfo, @{@"parameter": VFXCallbackUrlXError}, @"");
    }];
}

- (void)testHandleUrl_cancelCallbackRequired {
    VFXCallbackUrlRequirements *requirements = [VFXCallbackUrlRequirements new];
    requirements.cancelCallbackRequired = YES;
    
    [self performTestWithURLString:@"scheme://x-callback-url/action?keyA=valueA&keyB=valueB&x-source=sourceValue&x-success=successValue&x-error=errorValue" requirements:requirements assertBlock:^(VFXCallbackUrlRequest *request, NSArray *errors) {
        
        XCTAssertEqualObjects(request.source, @"sourceValue", @"");
        XCTAssertEqual(request.parameters.allKeys.count, 2, @"");
        XCTAssertEqual(request.parameters.allValues.count, 2, @"");
        XCTAssertEqualObjects(request.parameters[@"keyA"], @"valueA", @"");
        XCTAssertEqualObjects(request.parameters[@"keyB"], @"valueB", @"");
        XCTAssertEqualObjects(request.successCallback, @"successValue", @"");
        XCTAssertEqualObjects(request.errorCallback, @"errorValue", @"");
        XCTAssertNil(request.cancelCallback, @"");
        
        XCTAssertEqual(errors.count, 1, @"");
        
        NSError *error = errors[0];
        XCTAssertEqualObjects(error.domain, VFXCallbackUrlErrorDomain, @"");
        XCTAssertEqual(error.code, VFXCallbackUrlErrorMissingParameter, @"");
        XCTAssertEqualObjects(error.userInfo, @{@"parameter": VFXCallbackUrlXCancel}, @"");
    }];
}

- (void)testHandleUrl_requiredParameters {
    VFXCallbackUrlRequirements *requirements = [VFXCallbackUrlRequirements new];
    requirements.requiredParameters = @[@"keyA", @"keyB"];
    
    [self performTestWithURLString:@"scheme://x-callback-url/action?x-source=sourceValue&x-success=successValue&x-error=errorValue&x-cancel=cancelValue" requirements:requirements assertBlock:^(VFXCallbackUrlRequest *request, NSArray *errors) {
        
        XCTAssertEqualObjects(request.source, @"sourceValue", @"");
        XCTAssertEqual(request.parameters.allKeys.count, 0, @"");
        XCTAssertEqual(request.parameters.allValues.count, 0, @"");
        XCTAssertEqualObjects(request.successCallback, @"successValue", @"");
        XCTAssertEqualObjects(request.errorCallback, @"errorValue", @"");
        XCTAssertEqualObjects(request.cancelCallback, @"cancelValue", @"");
        
        XCTAssertEqual(errors.count, 2, @"");
        
        NSError *error1 = errors[0];
        XCTAssertEqualObjects(error1.domain, VFXCallbackUrlErrorDomain, @"");
        XCTAssertEqual(error1.code, VFXCallbackUrlErrorMissingParameter, @"");
        XCTAssertEqualObjects(error1.userInfo, @{@"parameter": @"keyA"}, @"");
        
        NSError *error2 = errors[1];
        XCTAssertEqualObjects(error2.domain, VFXCallbackUrlErrorDomain, @"");
        XCTAssertEqual(error2.code, VFXCallbackUrlErrorMissingParameter, @"");
        XCTAssertEqualObjects(error2.userInfo, @{@"parameter": @"keyB"}, @"");
    }];
}

- (void)performTestWithURLString:(NSString *)urlString
                    requirements:(VFXCallbackUrlRequirements *)requirements
                     assertBlock:(VFXCallbackUrlProcessingBlock)assertBlock {
    VFXCallbackUrlHandler *handler = [[VFXCallbackUrlHandler alloc] initWithUrlRequirements:requirements processingBlock:^(VFXCallbackUrlRequest *request, NSArray *errors) {
        assertBlock(request, errors);
        _processingCompleted = YES;
    }];
    
    [handler handleUrl:[NSURL URLWithString:urlString]];
}

@end
