//
//  FileUtil.m
//  BoandaProject
//
//  Created by 张仁松 on 13-7-1.
//  Copyright (c) 2013年 szboanda. All rights reserved.
//

#import "FileUtil.h"

@implementation FileUtil

+(UIImage*)imageForFileExt:(NSString*)pathExt
{
    if([pathExt compare:@"pdf" options:NSCaseInsensitiveSearch] == NSOrderedSame )
        return  [UIImage imageNamed:@"pdf_file.png"];
    else if([pathExt compare:@"doc" options:NSCaseInsensitiveSearch] == NSOrderedSame)
        return [UIImage imageNamed:@"doc_file.png"];
    else if([pathExt compare:@"xls" options:NSCaseInsensitiveSearch] == NSOrderedSame)
        return [UIImage imageNamed:@"xls_file.png"];
    else if([pathExt compare:@"zip" options:NSCaseInsensitiveSearch] == NSOrderedSame || [pathExt compare:@"rar" options:NSCaseInsensitiveSearch] == NSOrderedSame)
        return [UIImage imageNamed:@"rar_file.png"];
    else
        return [UIImage imageNamed:@"default_file.png"];
}

+ (UIImage*)imageForFileExtNew:(NSString*)pathExt
{
    if([pathExt compare:@"doc" options:NSCaseInsensitiveSearch] == NSOrderedSame || [pathExt compare:@"docx" options:NSCaseInsensitiveSearch] == NSOrderedSame)
    {
        return  [UIImage imageNamed:@"filetype_word_51h"];
    }
    else if([pathExt compare:@"ppt" options:NSCaseInsensitiveSearch] == NSOrderedSame || [pathExt compare:@"pptx" options:NSCaseInsensitiveSearch] == NSOrderedSame)
    {
        return [UIImage imageNamed:@"filetype_ppt_51h"];
    }
    else if([pathExt compare:@"xls" options:NSCaseInsensitiveSearch] == NSOrderedSame || [pathExt compare:@"xlsx" options:NSCaseInsensitiveSearch] == NSOrderedSame)
    {
        return [UIImage imageNamed:@"filetype_excel_51h"];
    }
    else if([pathExt compare:@"zip" options:NSCaseInsensitiveSearch] == NSOrderedSame || [pathExt compare:@"rar" options:NSCaseInsensitiveSearch] == NSOrderedSame)
    {
        return [UIImage imageNamed:@"filetype_compress_51h"];
    }
    else if ([pathExt compare:@"pdf" options:NSCaseInsensitiveSearch] == NSOrderedSame)
    {
        return [UIImage imageNamed:@"filetype_pdf_51h"];
    }
    else if ([pathExt compare:@"txt" options:NSCaseInsensitiveSearch] == NSOrderedSame)
    {
        return [UIImage imageNamed:@"filetype_txt_51h"];
    }
    else if ([pathExt compare:@"psd" options:NSCaseInsensitiveSearch] == NSOrderedSame)
    {
        return [UIImage imageNamed:@"filetype_psd_51h"];
    }
    else if ([pathExt compare:@"flv" options:NSCaseInsensitiveSearch] == NSOrderedSame)
    {
        return [UIImage imageNamed:@"filetype_flash_51h"];
    }
    else if ([pathExt compare:@"html" options:NSCaseInsensitiveSearch] == NSOrderedSame || [pathExt compare:@"htm" options:NSCaseInsensitiveSearch] == NSOrderedSame)
    {
        return [UIImage imageNamed:@"filetype_html_51h"];
    }
    else if ([pathExt compare:@"jpg" options:NSCaseInsensitiveSearch] == NSOrderedSame || [pathExt compare:@"png" options:NSCaseInsensitiveSearch] == NSOrderedSame)
    {
        return [UIImage imageNamed:@"filetype_image_51h"];
    }
    else if ([pathExt compare:@"key" options:NSCaseInsensitiveSearch] == NSOrderedSame)
    {
        return [UIImage imageNamed:@"filetype_keynote_51h"];
    }
    else if ([pathExt compare:@"pages" options:NSCaseInsensitiveSearch] == NSOrderedSame)
    {
        return [UIImage imageNamed:@"filetype_pages_51h"];
    }
    else if ([pathExt compare:@"numbers" options:NSCaseInsensitiveSearch] == NSOrderedSame)
    {
        return [UIImage imageNamed:@"filetype_numbers_51h"];
    }
    else
    {
        return [UIImage imageNamed:@"filetype_others_51h"];
    }
}

+ (NSString*)documentDir
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    return [paths objectAtIndex:0];
}

+ (NSString*)tmpDir
{
    return NSTemporaryDirectory();
}

@end
