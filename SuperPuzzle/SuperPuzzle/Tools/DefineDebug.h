//
//  DefineDebug.h
//  SuperPuzzle
//
//  Created by zuokai on 2017/8/9.
//  Copyright © 2017年 zuokai. All rights reserved.
//

#ifdef DEBUG
#  define DLog(fmt, ...) do { NSString* file = [NSString stringWithFormat:@"%s", __FILE__]; NSLog((@"%@(%d) " fmt), [file lastPathComponent], __LINE__, ##__VA_ARGS__);  } while(0)
#  define DLog_METHOD NSLog(@"%s", __func__)
#  define DLog_CMETHOD NSLog(@"%@/%@", NSStringFromClass([self class]), NSStringFromSelector(_cmd))
#  define COUNT(p) NSLog(@"%s(%d): count = %d/n", __func__, __LINE__, [p retainCount]);
#  define DLog_TRACE(x) do {printf x; putchar('/n'); fflush(stdout);} while (0)
#else
#  define DLog(...)
#  define DLog_METHOD
#  define DLog_CMETHOD
#  define COUNT(p)
#  define DLog_TRACE(x)
#endif

//重写NSLog,Debug模式下打印日志和当前行数
#if DEBUG
#define NSLog(FORMAT, ...) fprintf(stderr,"\n%s line:%d content:\n%s\n", __FUNCTION__, __LINE__, [[NSString stringWithFormat:FORMAT, ##__VA_ARGS__] UTF8String]);
#else
//#define NSLog(FORMAT, ...) nil
#endif

#if DEBUG
#define NSLogErr(FORMAT, ...) fprintf(stderr,"❗❗❗❗❗❗❗❗❗❗❗❗❗❗❗❗❗❗❗❗❗❗❗❗❗❗❗❗❗❗❗❗❗❗❗\n%s line:%d content:\n%sz\n❗❗❗❗❗❗❗❗❗❗❗❗❗❗❗❗❗❗❗❗❗❗❗❗❗❗❗❗❗❗❗❗❗❗❗", __FUNCTION__, __LINE__, [[NSString stringWithFormat:FORMAT, ##__VA_ARGS__] UTF8String]);
#else
//#define NSLogErr(FORMAT, ...) nil
#endif

//DEBUG  模式下打印日志,当前行并弹出一个警告
#ifdef DEBUG
#   define ULog(fmt, ...)  { UIAlertView *alert = [[UIAlertView alloc] initWithTitle:[NSString stringWithFormat:@"%s\n [Line %d] ", __PRETTY_FUNCTION__, __LINE__] message:[NSString stringWithFormat:fmt, ##__VA_ARGS__]  delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil]; [alert show]; }
#else
#   define ULog(...)
#endif

