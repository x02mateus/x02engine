package backend;

// O backend aqui já tá basicamente pronto
// O que falta é testar pra android, fazer a tradução do jogo, setup das imagens e o resto das coisas traduziveis no Paths

import openfl.system.Capabilities;

class LanguageManager {
    private static var langFiles_path:String = null;

    public static function checkandset() {
        var language:String = null;

        if(SaveData.language == null) {
            language = Capabilities.language;
            switch(language) {
                case 'en':  language = 'en-US';
                case 'pt':  language = 'pt-BR';
                case 'es':  language = 'es-ES';
            }

            SaveData.language = language;
            SaveData.save();
        } else {
            language = SaveData.language;
        }

        #if android 
        // não sei como a pasta dos values funcionaria no IOS
        // por mais que eu não vá portar pra IOS, decidi deixar como #if android e não #if mobile
        langFiles_path = Main.path + 'res/values/$language/';
        #elseif desktop
        langFiles_path = Paths.getPreloadPath('locales/$language/');
        #end

        #if (!mobile && debug)
        trace('sua linguagem atual: $language');
        trace('pasta onde os arquivos de linguagem vão ser procurados: $langFiles_path');
        trace(getString('teste', 'teste'));
        #end
    }

    public static function getString(id:String, fileName:String) {
        var xml:Xml = Xml.parse(Assets.getText(langFiles_path + '$fileName.xml'));
        
        var ids:Xml = xml.firstElement();
        for (i in ids.elements()) {
            if (ids.get("id") == id) {
                return ids.get("string");
            }
        }

        return null;
    }
}