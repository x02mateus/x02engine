package backend;

// Esse bloco de code em específico agiliza o trabalho de setar os presets
// Desse jeito você já abre o jogo com as opções recomendadas pro seu celular/PC

class PresetsManager {
    /*
    * Essa função detecta o total de RAM do sistema, e faz uma conta que automáticamente pega o limite de RAM suportado pelo sistema e troca o preset automáticamente 
    */
    public static function checkandset() {
        var sysRAM:Float = backend.ExternalCode.getTotalRam();
        var limite:Int = 0;
        // Se a RAM for menor que 1024, 724 tem que ser dividido por sysRAM / 1024
        // Caso for maior, faça a operação inversa e multiplique o valor por sysRAM / 1024
        if(sysRAM > 1024)
            limite = Std.int(sysRAM - (724 * (sysRAM / 1024))); // Priorizar a ordem aqui é importante. Menos se você quiser um resultado gigante...
        else
            limite = Std.int(sysRAM - (724 / (sysRAM / 1024)));

        if(limite >= 500 && limite < 600)
            setPreset(2);
        else if(limite >= 600 && limite < 700)
            setPreset(1);
        else if(limite >= 700)
            setPreset(0);

        trace(SaveData.curPreset);
    }

    private static function setPreset(preset:Int) {
        SaveData.curPreset = preset;
        switch (preset) {
            case 0:
				SaveData.gpu = true;
				SaveData.antialiasing = true;
				SaveData.fps = 90;
			case 1:
				SaveData.gpu = true;
				SaveData.antialiasing = false;
				SaveData.fps = 60;
			case 2:
				SaveData.gpu = false;
				SaveData.antialiasing = false;
				SaveData.fps = 30;
        }

        SaveData.save();
    } 
}