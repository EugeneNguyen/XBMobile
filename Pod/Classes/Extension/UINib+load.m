//
//  UINib+load.m
//  Pods
//
//  Created by Binh Nguyen Xuan on 12/1/14.
//
//

#import "UINib+load.h"

@implementation UINib (load)

+ (id)loadResourceWithInformation:(NSDictionary *)information
{
    UINib *nib;
    NSString *path = [[NSBundle mainBundle] pathForResource:information[@"xibname"] ofType:@"nib"];
    if ([[NSFileManager defaultManager] fileExistsAtPath:path])
    {
        nib = [UINib nibWithNibName:information[@"xibname"] bundle:nil];
    }
    else
    {
        NSString *bundleName;
        if (information[@"bundle"])
        {
            bundleName = information[@"bundle"];
        }
        else
        {
            bundleName = @"XBMobile";
        }
        NSBundle *bundle = [NSBundle bundleWithPath:[[NSBundle mainBundle] pathForResource:bundleName ofType:@"bundle"]];
        nib = [UINib nibWithNibName:information[@"xibname"] bundle:bundle];
    }
    return nib;
}

@end
