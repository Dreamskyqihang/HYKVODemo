//
//  NSObject+HYKVO.m
//  HYKVODemo
//
//  Created by 张鸿运 on 2017/7/16.
//  Copyright © 2017年 com.58ganji. All rights reserved.
//

#import "NSObject+HYKVO.h"
#import <objc/message.h>

@implementation NSObject (HYKVO)


- (void)HY_addObserver:(NSObject *)observer forKeyPath:(NSString *)keyPath options:(NSKeyValueObservingOptions)options context:(nullable void *)context
{
    //1 动态创建一个监听对象的子类
    //1.1 动态类名
    NSString *oldClassName = NSStringFromClass([self class]);
    NSString *newClass = [NSString stringWithFormat:@"HY_%@",oldClassName];
    const char *newClassName = [newClass UTF8String];
    //1.2 定义一个类
    Class myClass = objc_allocateClassPair([self class], newClassName, 0);
    //1.3 添加监听属性的set方法
    class_addMethod(myClass, @selector(setName:), (IMP)setName, "v@:@");
    //1.4 注册该类
    objc_registerClassPair(myClass);
    //1.5 修改被观察者的isa指针,让他指向自定义的类
    object_setClass(self, myClass);
    
    //1.6 动态绑定属性
    objc_setAssociatedObject(self, (__bridge const void *)@"123", observer, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

void setName(id self, SEL _cmd, NSString *newName)
{
    //2 执行监听对象的监听属性的修改
    //2.1 保存当前类型 此时 self 指被监听对象的子类
    id class = [self class];
    //2.2 改变当前对象指向父类 此句之后 self 为被监听的类
    object_setClass(self, class_getSuperclass([self class]));
    //2.3 调用父类的方法 此句执行了对被监听对象的监听属性进行赋值操作
    objc_msgSend(self, @selector(setName:),newName);
    
    //3 赋值完毕，通知外界
    //3.1 拿出观察者
    id obersrver = objc_getAssociatedObject(self,(__bridge const void *)@"123");
    //3.2 通知外界
    objc_msgSend(obersrver, @selector(observeValueForKeyPath:ofObject:change:context:),self,@"name",@{@"new":newName},nil);
    
    //4 改回子类型
    object_setClass(self, class);
    
}

@end
