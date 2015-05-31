//
//  ViewController.m
//  RMSaveButton
//
//  Created by Richard McDuffey on 5/30/15.
//  Copyright (c) 2015 Richard McDuffey. All rights reserved.
//

#import "ViewController.h"
#import "RMSaveButton.h"

@interface ViewController () <NSURLSessionDownloadDelegate>
@property (weak, nonatomic) IBOutlet RMSaveButton *saveButton;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    NSURL *url = [NSURL URLWithString:
                  @"http://upload.wikimedia.org/wikipedia/commons/7/7f/Williams_River-27527.jpg"]; //@"http://upload.wikimedia.org/wikipedia/commons/7/7f/Williams_River-27527.jpg
    
    NSURLSessionConfiguration *defaultConfig = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *defaultSession = [NSURLSession sessionWithConfiguration:defaultConfig
                                                                 delegate:self
                                                            delegateQueue:[NSOperationQueue mainQueue]];
    
    NSURLSessionDownloadTask *task = [defaultSession downloadTaskWithURL:url];
    
    self.saveButton.startHandler = ^void() { [task resume]; };
    self.saveButton.interruptHandler = ^void() { [task cancel]; };
    self.saveButton.completionHandler = ^void() { NSLog(@"Download completed."); };
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask didWriteData:(int64_t)bytesWritten totalBytesWritten:(int64_t)totalBytesWritten totalBytesExpectedToWrite:(int64_t)totalBytesExpectedToWrite
{
        double progress = (double) (totalBytesWritten/1024) / (double) (totalBytesExpectedToWrite/1024);
        NSLog(@"progress: %f", progress);
}

- (void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask didFinishDownloadingToURL:(NSURL *)location
{
    NSLog(@"Temporary File :%@\n", location);
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSError *error;
    if (![fileManager removeItemAtURL:location error:&error]) {
        NSLog(@"Error: %@", [error localizedDescription]);
    }
    [self.saveButton endAnimation];
    self.saveButton.completionHandler();
}

@end
