//
//  ViewController.m
//  GCD队列组的基本使用
//
//  Created by ChangRJey on 2017/8/9.
//  Copyright © 2017年 RenJiee. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

/** 图片1 */
@property (nonatomic, strong) UIImage * image1;
/** 图片2 */
@property (nonatomic, strong) UIImage * image2;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;

@end

@implementation ViewController

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self groupThree];
}

- (void) groupOne{
    // 1. 创建队列
    dispatch_queue_t queue = dispatch_get_global_queue(0, 0);
    
    // 2. 创建队列组
    dispatch_group_t group = dispatch_group_create();
    
    // 3. 异步函数封装任务
    dispatch_group_async(group, queue, ^{
        NSLog(@"download_group1------%@",[NSThread currentThread]);
    });
    
    dispatch_group_async(group, queue, ^{
        NSLog(@"download_group2------%@",[NSThread currentThread]);
    });
    
    dispatch_group_async(group, queue, ^{
        NSLog(@"download_group3------%@",[NSThread currentThread]);
    });
    
    // 拦截通知，当队列组中所有任务都执行完成完毕之后会进行通知
    // 内部本身是异步的
    dispatch_group_notify(group, queue, ^{
        NSLog(@"------dispatch_group_notify------");
    });
}

- (void) groupTwo{
    // 1. 创建队列
    dispatch_queue_t queue = dispatch_get_global_queue(0, 0);
    
    // 2. 创建队列组
    dispatch_group_t group = dispatch_group_create();
    
    // 3. 在该方法后面的异步任务会被纳入到队列组的监听范围
    // dispatch_group_enter | dispatch_group_leave 必须配对使用
    dispatch_group_enter(group);
    
    dispatch_async(queue, ^{
        NSLog(@"download_group1------%@",[NSThread currentThread]);
        
        // 离开队列组
        dispatch_group_leave(group);
    });
    
    dispatch_group_enter(group);

    dispatch_async(queue, ^{
        NSLog(@"download_group2------%@",[NSThread currentThread]);
        
        // 离开队列组
        dispatch_group_leave(group);
    });
    
//    dispatch_group_notify(group, queue, ^{
//        NSLog(@"------dispatch_group_notify------");
//    });
    
    // 等待
    // DISPATCH_TIME_FOREVER：死等，知道队列组中所有任务执行完毕之后才能执行 本身是阻塞的
    dispatch_group_wait(group, DISPATCH_TIME_FOREVER);
    
    NSLog(@"------end------");
    
}

- (void) groupThree{
    
    /**
     * 1. 下载图片1 开子线程
       2. 下载图片2 开子线程
       3. 合成图片并显示图片 开子线程
     */
    
    // 获得并发队列
    dispatch_queue_t queue = dispatch_get_global_queue(0, 0);
    
    // 创建队列组
    dispatch_group_t group = dispatch_group_create();
    
    // 1. 下载图片1 开子线程
    dispatch_group_async(group, queue, ^{
        NSLog(@"download_image1------%@",[NSThread currentThread]);

        // 1. 1 确定url
        NSURL * url = [NSURL URLWithString:@"https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1502282744935&di=aaefb03a83917b6b94da36fbf69fa080&imgtype=0&src=http%3A%2F%2Fpic.ilitu.com%2Fy3%2F1475_39900960921.jpg"];
        
        // 1.2 下载图片二进制数据到本地
        NSData * imageData = [NSData dataWithContentsOfURL:url];
        
        // 1.3 转换图片
        self.image1 = [UIImage imageWithData:imageData];
    });
    
    
    // 2. 下载图片1 开子线程
    dispatch_group_async(group, queue, ^{
        NSLog(@"download_image2------%@",[NSThread currentThread]);

        // 2. 1 确定url
        NSURL * url = [NSURL URLWithString:@"https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1502282773716&di=9b788f0dda94c259067c2826795caef4&imgtype=0&src=http%3A%2F%2Fi3.sinaimg.cn%2Fgm%2F2015%2F0422%2FU3932P115DT20150422122125.jpg"];
        
        // 2.2 下载图片二进制数据到本地
        NSData * imageData = [NSData dataWithContentsOfURL:url];
        
        // 2.3 转换图片
        self.image2 = [UIImage imageWithData:imageData];
        
    });
    
    // 3. 合成图片并显示图片 开子线程
    dispatch_group_notify(group, queue, ^{
        NSLog(@"合并图片------%@",[NSThread currentThread]);

        // 3.1 创建图形上下文
        UIGraphicsBeginImageContext(CGSizeMake(300, 400));
        
        // 3.2 画图1
        [self.image1 drawInRect:CGRectMake(0, 0, 300, 200)];
        self.image1 = nil;
        
        // 3.3 画图2
        [self.image2 drawInRect:CGRectMake(0, 200, 300, 200)];
        self.image2 = nil;
        
        // 3.4 根据上下文得到一张图片
        UIImage * image = UIGraphicsGetImageFromCurrentImageContext();
        
        // 3.5 关闭上下文
        UIGraphicsEndImageContext();
        
        // 3.6 得到图片 回到主线程刷新UI
        dispatch_async(dispatch_get_main_queue(), ^{
            self.imageView.image = image;
            NSLog(@"更新UI------%@",[NSThread currentThread]);
        });
        
    });
}

@end
