#import <Foundation/Foundation.h>
#import <React/RCTBridgeModule.h>

@interface RCT_EXTERN_MODULE(PortmoneCardModule, NSObject)

RCT_EXTERN_METHOD(invokePortmoneSdk:(NSString *)lang)
RCT_EXTERN_METHOD(initCardPayment:(NSString *)payeeId
                  phoneNumber:(NSString *)phoneNumber
                  billAmount:(NSInteger *)billAmount
                  resolve:(RCTPromiseResolveBlock)resolve
                  rejecter:(RCTPromiseRejectBlock)reject
                  )
RCT_EXTERN_METHOD(initCardSaving:(NSString *)payeeId
                  resolve:(RCTPromiseResolveBlock)resolve
                  rejecter:(RCTPromiseRejectBlock)reject
                  )


+ (BOOL)requiresMainQueueSetup
{
    return YES;
}

- (dispatch_queue_t)methodQueue
{
    return dispatch_get_main_queue();
}

@end
