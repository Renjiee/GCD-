//
//  ViewController.m
//  GCD常用函数
//
//  Created by ChangRJey on 2017/8/8.
//  Copyright © 2017年 RenJiee. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self once];
}

- (void) delay{
    
    NSLog(@"------start------");
    // 延迟执行
    
    // 方法1.
//    [self performSelector:@selector(task) withObject:nil afterDelay:2.0];
    
    // 方法2.
//    [NSTimer scheduledTimerWithTimeInterval:2.0 target:self selector:@selector(task) userInfo:nil repeats:YES];
    
    // 方法3. GCD 可以自由选择在哪个线程执行
//    dispatch_queue_t queue = dispatch_get_main_queue();
    dispatch_queue_t queue = dispatch_get_global_queue(0, 0);
    /**
     * 第一个参数：DISPATCH_TIME_NOW 从现在开始计算时间
       第一个参数：延迟2.0 GCD时间单位：纳秒  （需要 * 10的9次方 转换为秒）
     */
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), queue, ^{
        NSLog(@"GCD延迟执行------%@",[NSThread currentThread]);
        NSLog(@"------GCDend------");

    });
    
    NSLog(@"------end------");
}

- (void) task{
    NSLog(@"task------%@",[NSThread currentThread]);
}

// 一次性代码
- (void) once{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSLog(@"------noce------");
    });
}

@end
