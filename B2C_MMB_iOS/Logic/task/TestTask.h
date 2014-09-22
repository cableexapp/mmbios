//
//  TestTask.h
//  TestConnection
//
//  Created by dqf on 4/9/14.
//  Copyright (c) 2014 dqf. All rights reserved.
//

#import "BaseTask.h"
#import "BaseExecutor.h"

@interface TestTask : BaseTask<MyTaskDelegate>

@property(nonatomic,strong) BaseExecutor *exe;
@property(nonatomic,assign) URLTag urlTag;
@property(nonatomic,assign) BOOL showPromptView;

@property(nonatomic,strong) NSArray *objcs;
@property(nonatomic,strong) NSArray *keys;

- (id)initWith:(id<MyHandleDelegate>)del objcs:(NSArray *)objcArr keys:(NSArray *)keyArr;

@end
