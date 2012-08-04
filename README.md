iOS Percero Client Library
==========================

This project is intended to be an isolated binary "framework" that can be included in all client projects.

The client is compiled and packed according to the generous instructions from  https://github.com/jverkoey/iOS-Framework.

Using the Library…
------------------

There are two ways to use the library in a dependent project: as a linked binary or as a dependent project.

### As a linked Binary

1. Drag the Percero.framework from the distribution folder into your project's Frameworks group.
2. Add `#import <Percero/Percero.h>` in any file where you reference Percero APIs.

### As a dependent project

The Percero client library needs development too… and the best way to test it is to build a client around it.  Because you will want to do things like: change library code inline, use the debugger on library code, etc you need to not use the binary but instead use the whole project.  This option will obviously not be allowed for customers but for Percero developers it will make our lives easier.

1. From Finder drag the Percero.xcodeproj file into the frameworks group in your dependent project.
2. Select your Project's target and add Percero as a Target Dependency.
3. Expand the "Link Binary With Libraries" phase and click the + button. Select the libPercero.a and then click add.
4. Add `#import <Percero/Percero.h>` in any file where you reference Percero APIs.


Instrutions compliments of https://github.com/jverkoey/iOS-Framework



