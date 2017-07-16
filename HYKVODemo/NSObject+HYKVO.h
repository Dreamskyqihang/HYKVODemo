//
//  NSObject+HYKVO.h
//  HYKVODemo
//
//  Created by 张鸿运 on 2017/7/16.
//  Copyright © 2017年 com.58ganji. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject (HYKVO)


- (void)HY_addObserver:(NSObject *)observer forKeyPath:(NSString *)keyPath options:(NSKeyValueObservingOptions)options context:(nullable void *)context;

@end
