#import <Foundation/Foundation.h>
#import <Cordova/CDVPlugin.h>
#import <Cordova/CDVPluginResult.h>
#import <MobileCoreServices/MobileCoreServices.h>
#import "CDVClipboard.h"

@implementation CDVClipboard

- (void)copy:(CDVInvokedUrlCommand*)command {
	[self.commandDelegate runInBackground:^{
		/**
		* Changed on 30 JAN 2018 by Mayank & Karanveer
		* It will now support Html content with links copy and paste
		*/

		//UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
		//NSString     *text       = [command.arguments objectAtIndex:0];

		//[pasteboard setValue:text forPasteboardType:@"public.text"];

		//CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString:text];
		//[self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];

		NSString *html = [command.arguments objectAtIndex:0];
		NSData *data =  [html dataUsingEncoding:NSUTF8StringEncoding];
		NSDictionary *dict = @{@"WebMainResource": @{@"WebResourceData": data, @"WebResourceFrameName": @"", @"WebResourceMIMEType": @"text/html", @"WebResourceTextEncodingName": @"UTF-8", @"WebResourceURL": @"about:blank"}};
		data = [NSPropertyListSerialization dataWithPropertyList:dict format:NSPropertyListXMLFormat_v1_0 options:0 error:nil];
		NSString *archive = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];

		NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"<[^>]+>" options:NSRegularExpressionCaseInsensitive error:nil];
		NSString *plainText = [regex stringByReplacingMatchesInString:html options:0 range:NSMakeRange(0, [html length]) withTemplate:@""];

		[UIPasteboard generalPasteboard].items = @[@{@"Apple Web Archive pasteboard type": archive, (id)kUTTypeUTF8PlainText: plainText}];
		CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString:archive];
		[self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
	}];
}

- (void)paste:(CDVInvokedUrlCommand*)command {
	[self.commandDelegate runInBackground:^{
		UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
		NSString     *text       = [pasteboard valueForPasteboardType:@"public.text"];
	    
	    CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString:text];
	    [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
	}];
}

@end
