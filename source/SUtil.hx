package mobile.backend;

#if android
import android.content.Context as AndroidContext;
import android.os.Environment as AndroidEnvironment;
import android.Permissions as AndroidPermissions;
import android.Settings as AndroidSettings;
#end
import lime.system.System as LimeSystem;
import openfl.utils.Assets as OpenFlAssets;
import openfl.Lib;
#if sys
import sys.io.File;
import sys.FileSystem;
#end

/**
 * A storage class for mobile.
 * @author Mihai Alexandru (M.A. Jigsaw) and Lily (mcagabe19)
 */
class SUtil
{
	#if sys
	public static function getStorageDirectory(?force:Bool = false #if (android), type:StorageType = #if EXTERNAL EXTERNAL #elseif OBB EXTERNAL_OBB #elseif MEDIA EXTERNAL_MEDIA #else EXTERNAL_DATA #end #end):String
	{
		var daPath:String = '';
		#if android
		var forcedPath:String = '/storage/emulated/0/';
		var packageNameLocal:String = 'com.NFengine063test';
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

	public static function mkDirs(directory:String):Void
	{
		var total:String = '';
		if (directory.substr(0, 1) == '/')
			total = '/';

		var parts:Array<String> = directory.split('/');
		if (parts.length > 0 && parts[0].indexOf(':') > -1)
			parts.shift();

		for (part in parts)
		{
			if (part != '.' && part != '')
			{
				if (total != '' && total != '/')
					total += '/';

				total += part;

				try
				{
					if (!FileSystem.exists(total))
						FileSystem.createDirectory(total);
				}
				catch (e:haxe.Exception)
					trace('Error while creating folder. (${e.message}');
			}
		}
	}

	public static function saveContent(fileName:String = 'file', fileExtension:String = '.json', fileData:String = 'You forgor to add somethin\' in yo code :3'):Void
	{
		try
		{
			if (!FileSystem.exists('saves'))
				FileSystem.createDirectory('saves');

			File.saveContent('saves/' + fileName + fileExtension, fileData);
			showPopUp(fileName + " file has been saved.", "Success!");
		}
		catch (e:haxe.Exception)
			trace('File couldn\'t be saved. (${e.message})');
	}
	
	public static function AutosaveContent(fileName:String = 'file', fileExtension:String = '.json', fileData:String = 'You forgor to add somethin\' in yo code :3'):Void
	{
		try
		{
			if (!FileSystem.exists('saves'))
				FileSystem.createDirectory('saves');

			File.saveContent('saves/' + fileName + fileExtension, fileData);
			//showPopUp(fileName + " file has been saved.", "Success!");
		}
		catch (e:haxe.Exception)
			trace('File couldn\'t be saved. (${e.message})');
	}

	#if android
	public static function doPermissionsShit():Void
	{
		if (!AndroidPermissions.getGrantedPermissions().contains(AndroidPermissions.READ_EXTERNAL_STORAGE)
			&& !AndroidPermissions.getGrantedPermissions().contains(AndroidPermissions.WRITE_EXTERNAL_STORAGE))
		{
			AndroidPermissions.requestPermission(AndroidPermissions.READ_EXTERNAL_STORAGE);
			AndroidPermissions.requestPermission(AndroidPermissions.WRITE_EXTERNAL_STORAGE);
			showPopUp('If you accepted the permissions you are all good!' + '\nIf you didn\'t then expect a crash' + '\nPress Ok to see what happens', 'Notice!');
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
				showPopUp("Please create folder to\n" + SUtil.getStorageDirectory(true) + "\nPress OK to close the game", "Error!");
				LimeSystem.exit(1);
			}
		}
	}
	#end
	#end
	
	public static function saveClipboard(fileData:String = 'you forgot something to add in your code')
	{
		openfl.system.System.setClipboard(fileData);
		//SUtil.applicationAlert('Done :)!', 'Data Saved to Clipboard Successfully!');
		showPopUp(" Done :)!", "Data Saved to Clipboard Successfully!");
	}

	public static function copyContent(copyPath:String, savePath:String)
	{
		if (!FileSystem.exists(savePath))
			File.saveBytes(savePath, OpenFlAssets.getBytes(copyPath));
	}

	public static function showPopUp(message:String, title:String):Void
	{
		#if (!ios || !iphonesim)
		lime.app.Application.current.window.alert(message, title);
		#else
		trace('$title - $message');
		#end
	}
}


enum StorageType
{
	EXTERNAL_DATA;
	EXTERNAL_OBB;
	EXTERNAL_MEDIA;
	EXTERNAL;
}
