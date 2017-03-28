//
//  ViewController.m
//  Demo
//
//  Created by sunnyxx on 2017/3/28.
//  Copyright © 2017年 sunnyxx. All rights reserved.
//

#import "ViewController.h"
#import <libffi-iOS/ffi.h>
#import <objc/runtime.h>

@interface Sark : NSObject
@end

@implementation Sark

- (int)fooWithBar:(int)bar baz:(int)baz {
    return bar + baz;
}

@end

void testFFICall() {
    ffi_cif cif;
    ffi_type *argumentTypes[] = {&ffi_type_pointer, &ffi_type_pointer, &ffi_type_sint32, &ffi_type_sint32};
    ffi_prep_cif(&cif, FFI_DEFAULT_ABI, 4, &ffi_type_pointer, argumentTypes);
    
    Sark *sark = [Sark new];
    SEL selector = @selector(fooWithBar:baz:);
    int bar = 123;
    int baz = 456;
    void *arguments[] = {&sark, &selector, &bar, &baz};
    
    IMP imp = [sark methodForSelector:selector];
    
    int retValue;
    ffi_call(&cif, imp, &retValue, arguments);
    NSLog(@"ffi_call: %d", retValue);
}

void closureCalled(ffi_cif *cif, void *ret, void **args, void *userdata) {
    int bar = *((int *)args[2]);
    int baz = *((int *)args[3]);
    *((int *)ret) = bar * baz;
}

void testFFIClosure() {
    ffi_cif cif;
    ffi_type *argumentTypes[] = {&ffi_type_pointer, &ffi_type_pointer, &ffi_type_sint32, &ffi_type_sint32};
    ffi_prep_cif(&cif, FFI_DEFAULT_ABI, 4, &ffi_type_pointer, argumentTypes);
    IMP newIMP;
    ffi_closure *closure = ffi_closure_alloc(sizeof(ffi_closure), (void *)&newIMP);
    ffi_prep_closure_loc(closure, &cif, closureCalled, NULL, NULL);
    
    Method method = class_getInstanceMethod([Sark class], @selector(fooWithBar:baz:));
    method_setImplementation(method, newIMP);
    
    // after hook
    Sark *sark = [Sark new];
    int ret = [sark fooWithBar:123 baz:456];
    NSLog(@"ffi_closure: %d", ret);
}

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // test call
    testFFICall();
    // test closure
    testFFIClosure();
}

@end
