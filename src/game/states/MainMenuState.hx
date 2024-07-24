package game.states;

// Decidi rushar esse menu escutando Master of Puppets do Metallica, então ignore se o code estiver burro k

import objects.MenuItemObject;

class MainMenuState extends FlxState {
    private var menuitem_obj:MenuItemObject;
    private var background:FlxSprite;
    private var versionText:FlxText;

    override function create() {
        Main.mouse(true); // Isso serve pra deixar o mouse visivel, e não precisar colocar um novo code para ele não ficar visível no Android
        
        // Breve explicação de como funcionam os sprites nessa engine
        background = new FlxSprite().loadGraphic(Paths.image('backgrounds/${FlxG.random.int(1,2)}', 'preload')); // Carrega a imagem usando o Paths.image, e procura por ela em 'preload/images/background/(bg 1 ou 2)'
        background.moves = false; // Desativa o sistema de colisão para o aumento de performance (Não tem necessidade de utilizar o sistema de colisão, já que o BG foi feito para ser apenas um fundo)
        background.antialiasing = SaveData.antialiasing; // Ativa ou desativa o antialiasing da imagem de acordo com o que o usuário tiver escolhido
        background.setGraphicSize(Std.int(FlxG.width), Std.int(FlxG.height)); // Faz a imagem preencher a tela inteira
        add(background); // Adiciona a imagem

        versionText = new FlxText(12, FlxG.height - 24, 0, "X02Engine BETA v0.1", 12);
		versionText.scrollFactor.set();
		versionText.setFormat(Paths.font('akira.otf'), 16, FlxColor.WHITE, LEFT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		add(versionText);
        super.create();
    }
}