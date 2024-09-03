package backend;

// O backend aqui já tá basicamente pronto
// O que falta é testar pra android, fazer a tradução do jogo, setup das imagens e o resto das coisas traduziveis no Paths

import openfl.system.Capabilities;

class LanguageManager {
    public static var langFiles_path:String = null;

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

        langFiles_path = Paths.getPreloadPath('locales/${SaveData.language}/');

        #if (!mobile && debug)
        trace('sua linguagem atual: $language');
        trace('pasta onde os arquivos de linguagem vão ser procurados: $langFiles_path');
        #end
    }

    public static function getString(id:String, fileName:String) {
        var filespath:String = Paths.getPreloadPath('locales/${SaveData.language}/');
        var xml:Xml = Xml.parse(Assets.getText(filespath + '$fileName.xml'));
        
        // Pedi ajuda pro ChatGPT nisso aqui k
        for (child in xml.firstElement().elements()) {
            if (child.get("id") == id) {
                return child.get("string");
            }
        }

        return "missing string";
    }
}