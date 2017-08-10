//
//  ViewController.m
//  GCD栅栏函数
//
//  Created by ChangRJey on 2017/8/9.
//  Copyright © 2017年 RenJiee. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
    // 1 获取全局并发队列
    dispatch_queue_t queue = dispatch_queue_create("download", DISPATCH_QUEUE_CONCURRENT);
    
    // 1. 异步函数
    dispatch_async(queue, ^{
        NSLog(@"download1------%@",[NSThread currentThread]);
    });
    
    dispatch_async(queue, ^{
        NSLog(@"download3------%@",[NSThread currentThread]);
    });
    
    // 栅栏函数
    // 栅栏函数不能使用全局并发队列
    dispatch_barrier_async(queue, ^{
        NSLog(@"+++++++++++++++++++++");
    });
    
    dispatch_async(queue, ^{
        NSLog(@"download2------%@",[NSThread currentThread]);
    });
}


@end
