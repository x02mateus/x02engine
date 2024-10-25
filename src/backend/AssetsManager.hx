package backend;

#if mobile
import openfl.utils.AssetType;
import openfl.utils.Assets; // O do Lime tem algumas coisas que faltam.

class AssetsManager {
    public static var assets_list:Array<String> = list(); 

    inline public static function list():Array<String> {
        if(assets_list == null)
            assets_list = Assets.list();

        return assets_list;
    }

    inline public static function list_by_type(ext:String):Array<String> {
        var specific_list:Array<String> = [];

        if(assets_list != null) {
            for (file in assets_list)
                if(file.endsWith(ext)) 
                    specific_list.push(file);
        } else {
            specific_list = Assets.list(convert_ext_to_type(ext));
            for (file in specific_list)
                if(!file.endsWith(ext)) 
                    specific_list.remove(file);
        }

        return specific_list;
    }

    private static function convert_ext_to_type(ext:String):AssetType {
        switch(ext) {
            case '.ttf' | '.otf':                                   return FONT;
            case '.png' | '.jpg':                                   return IMAGE;
            case '.ogg' #if web | '.mp3' #end:                      return SOUND;       // Isso poderia retornar MUSIC.
            case '.txt' | '.xml':                                   return TEXT;
            case '.json' | '.lua' | '.hscript' | '.sm' | '.osu':    return BINARY;
            case '.swf':                                            return MOVIE_CLIP;
        }

        return null;
    }
}
#end