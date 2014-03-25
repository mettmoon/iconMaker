//
//  NSCImageView.m
//  iconMaker
//
//  Created by gideon on 12. 9. 21..
//  Copyright (c) 2012년 blesseddeveloper. All rights reserved.
//

#import "NSCImageView.h"

@implementation NSCImageView

- (NSDragOperation)draggingEntered:(id <NSDraggingInfo>)sender
{
    if ((NSDragOperationGeneric & [sender draggingSourceOperationMask])
		== NSDragOperationGeneric)
    {
        //this means that the sender is offering the type of operation we want
        //return that we want the NSDragOperationGeneric operation that they
		//are offering
        return NSDragOperationGeneric;
    }
    else
    {
        //since they aren't offering the type of operation we want, we have
		//to tell them we aren't interested
        return NSDragOperationNone;
    }
}



- (void)draggingExited:(id <NSDraggingInfo>)sender
{
    //we aren't particularily interested in this so we will do nothing
    //this is one of the methods that we do not have to implement
	//NSLog(@"%@", sender);
}


- (BOOL)performDragOperation:(id <NSDraggingInfo>)sender
{
	NSPasteboard *pboard = [sender draggingPasteboard];
	
    if ( [[pboard types] containsObject:NSFilenamesPboardType] ) {
		//  NSArray *files = [pboard propertyListForType:NSFilenamesPboardType];
        //NSLog(@"%@", files);
        // Perform operation using the list of files
    }
	
	
    NSPasteboard *paste = [sender draggingPasteboard];
	
	//gets the dragging-specific pasteboard from the sender
    NSArray *types = [NSArray arrayWithObjects:NSTIFFPboardType,
					  NSFilenamesPboardType, nil];
	//a list of types that we can accept
    NSString *desiredType = [paste availableTypeFromArray:types];
    NSData *carriedData = [paste dataForType:desiredType];
	
    if (nil == carriedData)
    {
        //the operation failed for some reason
        NSRunAlertPanel(@"Paste Error", @"Sorry, but the past operation failed",
						nil, nil, nil);
        return NO;
    }
    else
    {
        //the pasteboard was able to give us some meaningful data
        if ([desiredType isEqualToString:NSTIFFPboardType])
        {
            //we have TIFF bitmap data in the NSData object
			NSImage *newImage = [[NSImage alloc] initWithData:carriedData];
			[self setImage:newImage];
			//we are no longer interested in this so we need to release it
        }
        else if ([desiredType isEqualToString:NSFilenamesPboardType])
        {
            //we have a list of file names in an NSData object
            NSArray *fileArray =
			[paste propertyListForType:@"NSFilenamesPboardType"];
			//be caseful since this method returns id.
			//We just happen to know that it will be an array.
            NSString *path = [fileArray objectAtIndex:0];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"FilePathChanged" object:path];
			//assume that we can ignore all but the first path in the list
            NSImage *newImage = [[NSImage alloc] initWithContentsOfFile:path];
			
            if (nil == newImage)
            {
                //we failed for some reason
                NSRunAlertPanel(@"File Reading Error",
								@"Sorry, but I failed to open the file at \"%@\"", nil, nil, nil,path);
                return NO;
            }
            else
            {
                //newImage is now a new valid image
				[self setImage:newImage];
            }
        }
        else
        {
            //this can't happen
            NSAssert(NO, @"This can't happen");
            return NO;
        }
    }
    [self setNeedsDisplay:YES];    //redraw us with the new image
    return YES;
}

@end
