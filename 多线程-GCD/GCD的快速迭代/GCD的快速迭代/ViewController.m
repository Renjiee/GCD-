//
//  ViewController.m
//  GCD的快速迭代
//
//  Created by ChangRJey on 2017/8/9.
//  Copyright © 2017年 RenJiee. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self moveFileWithGCD];
}

// 普通for循环
- (void) forDemo{
    for(NSInteger i = 0; i < 10; i++){
        NSLog(@"%zd-----------%@",i,[NSThread currentThread]);
    }
}

// GCD快速迭代 ：开启
- (void) apply{
    
    dispatch_queue_t queue = dispatch_get_global_queue(0, 0);
    /**
     * 第一个参数：遍历次数
       第二个参数：队列（并发队列）
       第三个参数：索引
     */
    dispatch_apply(10, queue, ^(size_t index) {
        NSLog(@"%zd-----------%@",index,[NSThread currentThread]);
    });
}

- (void) moveFile{
    
    // 1. 拿到文件路径
    NSString * form = @"/Users/ChangRJey/Desktop/修改前后对比图";
    
    // 2. 获得目标文件路径
    NSString * to = @"/Users/ChangRJey/Desktop/yoyoyo";
    
    // 3. 得到目录下面的所有文件
    NSArray * subPaths=  [[NSFileManager defaultManager] subpathsAtPath:form];
    
    NSLog(@"文件名------%@",subPaths);
    
    // 4. 遍历所有文件，然后执行剪切操作
    NSInteger count = subPaths.count;
    for(NSInteger i = 0; i < count; i++){
        // 4.1 拼接文件全路径
//        NSString * fullPath = [form stringByAppendingString:subPaths[i]];
        // 在拼接的时候会自行增加 /
        NSString * fullPath = [form stringByAppendingPathComponent:subPaths[i]];
        NSString * toFullPath = [to stringByAppendingPathComponent:subPaths[i]];
        
        NSLog(@"文件名------%@",fullPath);
        
        // 4.2 执行剪切操作
        /**
         * 第一个参数：要剪切的文件路径
           第二个参数：文件应该被存放的目标路径
           第三个参数：错误信息
         */
        [[NSFileManager defaultManager] moveItemAtPath:fullPath toPath:toFullPath error:nil];
        
        NSLog(@"%@------%@------%@",fullPath,toFullPath,[NSThread currentThread]);
    }
}

- (void) moveFileWithGCD{
    // 1. 拿到文件路径
    NSString * form = @"/Users/ChangRJey/Desktop/修改前后对比图";
    
    // 2. 获得目标文件路径
    NSString * to = @"/Users/ChangRJey/Desktop/yoyoyo";
    
    // 3. 得到目录下面的所有文件
    NSArray * subPaths=  [[NSFileManager defaultManager] subpathsAtPath:form];
    
    NSLog(@"文件名------%@",subPaths);
    
    // 4. 遍历所有文件，然后执行剪切操作
    NSInteger count = subPaths.count;
    dispatch_apply(count, dispatch_get_global_queue(0, 0), ^(size_t index) {
        NSString * fullPath = [form stringByAppendingPathComponent:subPaths[index]];
        NSString * toFullPath = [to stringByAppendingPathComponent:subPaths[index]];
        
        NSLog(@"文件名------%@",fullPath);
        
        // 4.2 执行剪切操作
        /**
         * 第一个参数：要剪切的文件路径
         第二个参数：文件应该被存放的目标路径
         第三个参数：错误信息
         */
        [[NSFileManager defaultManager] moveItemAtPath:fullPath toPath:toFullPath error:nil];
        NSLog(@"%@------%@------%@",fullPath,toFullPath,[NSThread currentThread]);
    });
}

@end
