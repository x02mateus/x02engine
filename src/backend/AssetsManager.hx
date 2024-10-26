package backend;

#if mobile
import openfl.utils.AssetType;
import openfl.utils.Assets; // O do Lime tem algumas coisas que faltam.

class AssetsManager {
    public static var assets_list:Array<String> = list(); 
    public static final lua_files:Array<String> = list_by_extension('.lua');
    public static final json_files:Array<String> = list_by_extension('.json', null, 'data/'); // Esse ignora os arquivos de "data/"
    public static final hscript_files:Array<String> = list_by_extension('.hscript');
    public static final sm_chartingfiles:Array<String> = list_by_extension('.sm', 'data/', null);
    public static final osu_chartingfiles:Array<String> = list_by_extension('.osu', 'data/', null);
    public static final json_chartingfiles:Array<String> = list_by_extension('.json', 'data/', null); // Esse só lê os da pasta "data/"
    

    inline public static function list():Array<String> {
        if(assets_list == null)
            assets_list = Assets.list();

        return assets_list;
    }

    inline public static function list_by_extension(ext:String, ?include:String, ?exclude:String):Array<String> {
        var specific_list:Array<String> = [];

        if(assets_list != null) {
            for (file in assets_list)
                if (exclude != null && file.contains(exclude))
                    continue;
                else if (include != null && file.contains(include) || (include == null && exclude == null && file.contains(ext)))
                    specific_list.push(file);
        } else {
            #if (!mobile && debug)
            trace('erro: assets_list é nulo.');
            #else
            FlxG.log.error("Assets_list é nulo.");
            #end
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