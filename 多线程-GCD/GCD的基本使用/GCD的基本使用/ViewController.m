//
//  ViewController.m
//  GCD的基本使用
//
//  Created by ChangRJey on 2017/8/8.
//  Copyright © 2017年 RenJiee. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

/**
 * 同步函数：立刻马上执行，如果我没有执行完毕，那么后面的也别想执行
   异步函数：如果我没有执行完毕，后面也可以执行
 */

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self note];
//    [NSThread detachNewThreadSelector:@selector(syncMain) toTarget:self withObject:nil];
}

// 异步函数+并发队列：会开启多条线程，队列中的任务是并发(异步)执行无顺序
- (void) asyncConcurrent{
    
    // 1.创建队列
    /**
       第一个参数: C语言的字符串，标签
       第二个参数: 队列的类型
            DISPATCH_QUEUE_CONCURRENT：并发队列
            DISPATCH_QUEUE_SERIAL：串行队列
     */
//    dispatch_queue_t queue = dispatch_queue_create("asyncConcurrent", DISPATCH_QUEUE_CONCURRENT);
    
    
    // 获得全局并发队列：并不是一个任务一条线程，而是系统给你分配的线程
    /**
     第一个参数: 优先级
     第二个参数: 未来使用的，默认 0
     */
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    
    // 2 .封装任务 -> 添加任务到队列中
    /**
     第一个参数: 队列
     第二个参数: 要执行的任务
     */
    dispatch_async(queue, ^{
        NSLog(@"asyncConcurrent1------%@",[NSThread currentThread]);
    });
    
    
    dispatch_async(queue, ^{
        NSLog(@"asyncConcurrent2------%@",[NSThread currentThread]);
    });
    
    dispatch_async(queue, ^{
        NSLog(@"asyncConcurrent3------%@",[NSThread currentThread]);
    });

}

// 异步函数+串行队列：只会开启一条线程，任务是串行执行有顺序
- (void) asyncSerial{
    //1. 创建队列
    dispatch_queue_t queue = dispatch_queue_create("asyncSerial", DISPATCH_QUEUE_SERIAL);
    
    // 2. 封装任务
    dispatch_async(queue, ^{
        NSLog(@"asyncSerial1------%@",[NSThread currentThread]);
    });
    
    dispatch_async(queue, ^{
        NSLog(@"asyncSerial2------%@",[NSThread currentThread]);
    });
    
    dispatch_async(queue, ^{
        NSLog(@"asyncSerial3------%@",[NSThread currentThread]);
    });
}

// 同步函数+并发队列：不会开启线程，任务是串行执行
- (void) syncConcurrent{
    
    // 1. 创建队列
    dispatch_queue_t queue = dispatch_queue_create("syncConcurrent", DISPATCH_QUEUE_CONCURRENT);
    
    // 2. 封装任务
    dispatch_sync(queue, ^{
        NSLog(@"syncConcurrent1------%@",[NSThread currentThread]);
    });
    
    dispatch_sync(queue, ^{
        NSLog(@"syncConcurrent2------%@",[NSThread currentThread]);
    });
    
    dispatch_sync(queue, ^{
        NSLog(@"syncConcurrent3------%@",[NSThread currentThread]);
    });
    
}

// 同步函数+串行队列：不会开启线程，任务是串行执行
- (void) syncSerial{
    
    // 1. 创建队列
    dispatch_queue_t queue = dispatch_queue_create("syncSerial", DISPATCH_QUEUE_SERIAL);
    
    // 2. 封装任务
    dispatch_sync(queue, ^{
        NSLog(@"syncSerial1------%@",[NSThread currentThread]);
    });
    
    dispatch_sync(queue, ^{
        NSLog(@"syncSerial2------%@",[NSThread currentThread]);
    });
    
    dispatch_sync(queue, ^{
        NSLog(@"syncSerial3------%@",[NSThread currentThread]);
    });
}

// 异步函数+主队列：所有任务都在主线程中执行，不会开启线程
- (void) asyncMain{
    
    // 1. 获得主队列
    dispatch_queue_t queue = dispatch_get_main_queue();
    
    // 2.封装任务 - 异步函数
    dispatch_async(queue, ^{
        NSLog(@"asyncMain1------%@",[NSThread currentThread]);
    });
    
    dispatch_async(queue, ^{
        NSLog(@"asyncMain2------%@",[NSThread currentThread]);
    });
    
    dispatch_async(queue, ^{
        NSLog(@"asyncMain3------%@",[NSThread currentThread]);
    });
}

/**
 * 主队列特点：如果主队列中发现当前主线程有任务在执行，那么主队列会暂停调用队列中的任务，直到主线程空闲为止
 */
// 同步函数+主队列：死锁
// 注意：如果该方法在子线程中执行，那么所有的任务都会在主线程中执行
- (void) syncMain{
    
    // 1. 获得主队列
    dispatch_queue_t queue = dispatch_get_main_queue();
    
    // 2.封装任务 - 同步函数
    dispatch_sync(queue, ^{
        NSLog(@"syncMain1------%@",[NSThread currentThread]);
    });
    
    dispatch_sync(queue, ^{
        NSLog(@"syncMain2------%@",[NSThread currentThread]);
    });
    
    dispatch_sync(queue, ^{
        NSLog(@"syncMain3------%@",[NSThread currentThread]);
    });
}


- (void) note{
    
    // 创建队列
    dispatch_queue_t queue = dispatch_get_global_queue(0, 0);
    
    // 区别：封装任务的方法（block  函数）
    
    int context = 10;
    /**
     * 第一个参数：队列
       第二个参数：参数 函数指针 注意传地址 不要传值
       第三个参数：要调用函数名称 C语言函数
     */
    dispatch_async_f(queue, &context, task);
}

void task (void * context){
    int * c = context;
    NSLog(@"%d",*c);
}

@end
