//
//  LastdaysObserver.m
//  KVO_Try
//
//  Created by wossoneri on 16/4/30.
//  Copyright © 2016年 wossoneri. All rights reserved.
//

#import "LastdaysObserver.h"

@implementation LastdaysObserver

- (void)observeValueForKeyPath:(NSString *)keyPath
                      ofObject:(id)object
                        change:(NSDictionary<NSString *,id> *)change
                       context:(void *)context {
    
    NSLog(@"old = %@", [change objectForKey:NSKeyValueChangeOldKey]);
    NSLog(@"old = %@", [change objectForKey:NSKeyValueChangeNewKey]);
    NSLog(@"context:%@", context);
    
}

@end
