package;

#if android
import android.Tools;
import android.Permissions as AndroidPermissions;
import android.Settings as AndroidSettings;
import android.os.Environment as AndroidEnvironment;
#end
import lime.app.Application;
import openfl.events.UncaughtErrorEvent;
import openfl.utils.Assets as OpenFlAssets;
import openfl.Lib;
import haxe.CallStack.StackItem;
import haxe.CallStack;
import haxe.io.Path;
import sys.FileSystem;
import sys.io.File;
import flash.system.System;

/**
 * ...
 * @author: Saw (M.A. Jigsaw)
 */

using StringTools;

class SUtil
{
	#if sys
	public static function getStorageDirectory(?force:Bool = false #if (android), type:StorageType = #if EXTERNAL EXTERNAL #elseif OBB EXTERNAL_OBB #elseif MEDIA EXTERNAL_MEDIA #else EXTERNAL_DATA #end #end):String
	{
		var daPath:String = '';
		#if android
		var forcedPath:String = '/storage/emulated/0/';
		var packageNameLocal:String = 'com.shadowmario.psychengine';
		var fileLocal:String = 'NF Engine';
		switch (type)
		{
			case EXTERNAL_DATA:
				daPath = force ? forcedPath + 'Android/data/' + packageNameLocal + '/files' : AndroidContext.getExternalFilesDir();
			case EXTERNAL_OBB:
				daPath = force ? forcedPath + 'Android/obb/' + packageNameLocal : AndroidContext.getObbDir();
			case EXTERNAL_MEDIA:
				daPath = force ? forcedPath + 'Android/media/' + packageNameLocal : AndroidEnvironment.getExternalStorageDirectory() + '/Android/media/' + lime.app.Application.current.meta.get('packageName');
			case EXTERNAL:
				daPath = force ? forcedPath + '.' + fileLocal : AndroidEnvironment.getExternalStorageDirectory() + '/.' + lime.app.Application.current.meta.get('file');
		}
		daPath = haxe.io.Path.addTrailingSlash(daPath);
		#elseif ios
		daPath = LimeSystem.documentsDirectory;
		#end

		return daPath;
	}

    /*
	public static function doTheCheck()
	{
		#if android
		if (!AndroidPermissions.getGrantedPermissions().contains(AndroidPermissions.WRITE_EXTERNAL_STORAGE) || !AndroidPermissions.getGrantedPermissions().contains(AndroidPermissions.WRITE_EXTERNAL_STORAGE))
		{
			AndroidPermissions.requestPermission(AndroidPermissions.READ_EXTERNAL_STORAGE);
			AndroidPermissions.requestPermission(AndroidPermissions.WRITE_EXTERNAL_STORAGE);
			SUtil.applicationAlert('Permissions', "if you acceptd the permissions all good if not expect a crash" + '\n' + 'Press Ok to see what happens');
			if (!AndroidEnvironment.isExternalStorageManager())
				AndroidSettings.requestSetting("android.settings.MANAGE_APP_ALL_FILES_ACCESS_PERMISSION");
		}

		if (AndroidPermissions.getGrantedPermissions().contains(AndroidPermissions.READ_EXTERNAL_STORAGE) || AndroidPermissions.getGrantedPermissions().contains(AndroidPermissions.WRITE_EXTERNAL_STORAGE))
		{
			if (!FileSystem.exists(SUtil.getPath()))
				FileSystem.createDirectory(SUtil.getPath());

			if (!FileSystem.exists(SUtil.getPath() + 'assets') && !FileSystem.exists(SUtil.getPath() + 'mods'))
			{
				SUtil.applicationAlert('Uncaught Error :(!', "Whoops, seems you didn't extract the files from the .APK!\nPlease watch the tutorial by pressing OK.");
				CoolUtil.browserLoad('https://b23.tv/qnuSteM');
				System.exit(0);
			}
			else
			{
				if (!FileSystem.exists(SUtil.getPath() + 'assets'))
				{
					SUtil.applicationAlert('Uncaught Error :(!', "Whoops, seems you didn't extract the assets/assets folder from the .APK!\nPlease watch the tutorial by pressing OK.");
					CoolUtil.browserLoad('https://b23.tv/qnuSteM');
					System.exit(0);
				}

				if (!FileSystem.exists(SUtil.getPath() + 'mods'))
				{
					SUtil.applicationAlert('Uncaught Error :(!', "Whoops, seems you didn't extract the assets/mods folder from the .APK!\nPlease watch the tutorial by pressing OK.");
					CoolUtil.browserLoad('https://b23.tv/qnuSteM');
					System.exit(0);
				}
			}
		}
		#end
	}
	*/
	
	#if android
	public static function doPermissionsShit():Void
	{
		if (!AndroidPermissions.getGrantedPermissions().contains(AndroidPermissions.READ_EXTERNAL_STORAGE)
			&& !AndroidPermissions.getGrantedPermissions().contains(AndroidPermissions.WRITE_EXTERNAL_STORAGE))
		{
			AndroidPermissions.requestPermission(AndroidPermissions.READ_EXTERNAL_STORAGE);
			AndroidPermissions.requestPermission(AndroidPermissions.WRITE_EXTERNAL_STORAGE);
			SUtil.applicationAlert('If you accepted the permissions you are all good!' + '\nIf you didn\'t then expect a crash' + '\nPress Ok to see what happens', 'Notice!');
			if (!AndroidEnvironment.isExternalStorageManager())
				AndroidSettings.requestSetting("android.settings.MANAGE_APP_ALL_FILES_ACCESS_PERMISSION");
		}
		else
		{
			try
			{
				if (!FileSystem.exists(SUtil.getStorageDirectory()))
					FileSystem.createDirectory(SUtil.getStorageDirectory());
			}
			catch (e:Dynamic)
			{
				SUtil.applicationAlert("Please create folder to\n" + SUtil.getStorageDirectory(true) + "\nPress OK to close the game", "Error!");
				LimeSystem.exit(1);
			}
		}
	}
	#end
	#end

	public static function gameCrashCheck()
	{
		Lib.current.loaderInfo.uncaughtErrorEvents.addEventListener(UncaughtErrorEvent.UNCAUGHT_ERROR, onCrash);
	}

	public static function onCrash(e:UncaughtErrorEvent):Void
	{
		var callStack:Array<StackItem> = CallStack.exceptionStack(true);
		var dateNow:String = Date.now().toString();
		dateNow = StringTools.replace(dateNow, " ", "_");
		dateNow = StringTools.replace(dateNow, ":", "'");

		var path:String = "crash/" + "crash_" + dateNow + ".txt";
		var errMsg:String = "";

		for (stackItem in callStack)
		{
			switch (stackItem)
			{
				case FilePos(s, file, line, column):
					errMsg += file + " (line " + line + ")\n";
				default:
					Sys.println(stackItem);
			}
		}

		errMsg += e.error;

		if (!FileSystem.exists(SUtil.getStorageDirectory() + "crash"))
		FileSystem.createDirectory(SUtil.getStorageDirectory() + "crash");

		File.saveContent(SUtil.getStorageDirectory() + path, errMsg + "\n");

		Sys.println(errMsg);
		Sys.println("Crash dump saved in " + Path.normalize(path));
		Sys.println("Making a simple alert ...");

		SUtil.applicationAlert("Uncaught Error :(!", errMsg);
		System.exit(0);
	}

	private static function applicationAlert(title:String, description:String)
	{
		Application.current.window.alert(description, title);
	}

	#if android
	public static function saveContent(fileName:String = 'file', fileExtension:String = '.json', fileData:String = 'you forgot something to add in your code')
	{
		if (!FileSystem.exists(SUtil.getStorageDirectory() + 'saves'))
			FileSystem.createDirectory(SUtil.getStorageDirectory() + 'saves');

		File.saveContent(SUtil.getStorageDirectory() + 'saves/' + fileName + fileExtension, fileData);
		SUtil.applicationAlert('Done :)!', 'File Saved Successfully!');
	}
    
    public static function AutosaveContent(fileName:String = 'file', fileExtension:String = '.json', fileData:String = 'you forgot something to add in your code')
	{
		if (!FileSystem.exists(SUtil.getStorageDirectory() + 'saves'))
			FileSystem.createDirectory(SUtil.getStorageDirectory() + 'saves');

		File.saveContent(SUtil.getStorageDirectory() + 'saves/' + fileName + fileExtension, fileData);
		//SUtil.applicationAlert('Done :)!', 'File Saved Successfully!');
	}
	
	public static function saveClipboard(fileData:String = 'you forgot something to add in your code')
	{
		openfl.system.System.setClipboard(fileData);
		SUtil.applicationAlert('Done :)!', 'Data Saved to Clipboard Successfully!');
	}

	public static function copyContent(copyPath:String, savePath:String)
	{
		if (!FileSystem.exists(savePath))
			File.saveBytes(savePath, OpenFlAssets.getBytes(copyPath));
	}
	#end
} 

enum StorageType
{
	EXTERNAL_DATA;
	EXTERNAL_OBB;
	EXTERNAL_MEDIA;
	EXTERNAL;
}