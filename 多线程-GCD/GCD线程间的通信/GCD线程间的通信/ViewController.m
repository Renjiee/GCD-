//
//  ViewController.m
//  GCD线程间的通信
//
//  Created by ChangRJey on 2017/8/8.
//  Copyright © 2017年 RenJiee. All rights reserved.
// https://ss1.bdstatic.com/70cFvXSh_Q1YnxGkpoWK1HF6hhy/it/u=1909600733,2304577724&fm=26&gp=0.jpg

#import "ViewController.h"

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *imageView;

@end

@implementation ViewController

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self downloadImage];
}

- (void) downloadImage{
    // 创建子线程下载图片
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        
        // 1. 确定图片url
        NSURL * url = [NSURL URLWithString:@"https://ss1.bdstatic.com/70cFvXSh_Q1YnxGkpoWK1HF6hhy/it/u=1909600733,2304577724&fm=26&gp=0.jpg"];
        
        // 2.下载图片二进制数据到本地
        NSData * imageData = [NSData dataWithContentsOfURL:url];
        
        // 3.转换图片
        UIImage * image = [UIImage imageWithData:imageData];
        
        NSLog(@"当前线程------%@",[NSThread currentThread]);
        
        // 更新UI 回到主线程
        dispatch_async(dispatch_get_main_queue(), ^{
            self.imageView.image = image;
            NSLog(@"当前线程------%@",[NSThread currentThread]);
        });
        
    });
}

@end
