//
//  ViewController.m
//  HYKVODemo
//
//  Created by 张鸿运 on 2017/7/16.
//  Copyright © 2017年 com.58ganji. All rights reserved.
//

#import "ViewController.h"
#import "Person.h"
#import "NSObject+HYKVO.h"

@interface ViewController ()

@property (nonatomic, strong) Person *person;


@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    Person *p = [[Person alloc] init];
    
    [p HY_addObserver:self forKeyPath:@"name" options:NSKeyValueObservingOptionNew context:nil];
    
    _person = p;

}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context
{
    NSLog(@"=====%@",change);
}


- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    static NSInteger i = 0;
    i++;
    _person.name = [NSString stringWithFormat:@"%ld",(long)i];
}

@end
