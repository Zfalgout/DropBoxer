Dropboxer

Architecture:

Dropboxer uses an MVVM architecture.  The views and associated view controllers as slim and rely on the underlying view
models to do all of the heavy lifting.  DropboxVM.swift is the file responsible for handling all calls associated with
Dropbox.

SavedPhotosVC.swift is the main view that the user interacts with.  It is what displays the user's photo library and is
the delegate for the UIImagePickerController class that handles the user's photo library.  
