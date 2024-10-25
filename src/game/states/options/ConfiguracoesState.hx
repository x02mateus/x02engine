package game.states.options;

import flash.text.TextField;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.addons.display.FlxBackdrop;
import flixel.addons.display.FlxGridOverlay;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.input.keyboard.FlxKey;
import flixel.math.FlxMath;
import flixel.text.FlxText;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.util.FlxColor;
import game.states.options.ConfiguracoesData;
import openfl.Lib;
import openfl.filters.ColorMatrixFilter;

class ConfiguracoesState extends MusicBeatState
{
	public static var instance:ConfiguracoesState;

	var backdrop:FlxBackdrop;
	var logo:FlxSprite;

	var selector:FlxText;
	var curSelected:Int = 0;

	var options:Array<OptionCategory> = [
		new OptionCategory('gameplay', [
			new KeyBindingsOption('Altere suas keybinds de teclado.'),
			new DownscrollOption('Faz as notas ficarem pra baixo, simplesmente.'),
			new GhostTapOption('Determina se você irá tomar dano caso clique em uma nota vazia.'),
			new ScrollSpeedOption('Mude a velocidade do Scroll. Partes em que isso é ajustado não serão afetadas. (Direita ou Esquerda).'),
			new Hitsounds('Altere o tipo do som dos Hitsounds.'),
			new VolumeHitsounds('Altere o volume dos hitsounds (só irá funcionar caso eles estiverem ativados.)'),
			new TesteHitsounds('Teste o Hitsound'),
			new MissSounds('Ative ou desative os sons de erros durante a gameplay.')
		]),
		new OptionCategory('visuals', [
			new FPSOption('Mostra o quanto de FPS o jogo está, e quanta memoria está usando.'),
			new FlashingLightsOption('Determina se vai haver luzes piscantes por causa de epilepsia.'),
			new Daltonismo('Altere entre filtros específicos de daltonismo.')
		]),
		new OptionCategory('sounds', [
			new VolumeEfeitos('Altere o volume dos efeitos do jogo'),
			new VolumeMusica('Altere o volume das músicas dos menus'),
		]),
		new OptionCategory('performance', [
			new FPSCapOption('Coloque um Limite no FPS (Direita ou Esquerda).'),
			new AntiAliasing('Faz os visuais ficarem mais suaves a custo de um pouco de performance.'),
			new GPUTextures('Permite o carregamento das texturas na GPU, fazendo usar menos memória.'),
		]),
		#if MOBILE_CONTROLS
		new OptionCategory('mobile', [
			new HitboxSkin('Altere a skin da Hitbox.')
		])
		#end
	];

	public var acceptInput:Bool = true;

	private var currentDescription:String = "";
	private var grpControls:FlxTypedGroup<FlxText>;

	public static var versionShit:FlxText;

	var currentSelectedCat:OptionCategory;
	var blackBorder:FlxSprite;

	override function create()
	{
		instance = this;

		Paths.clearUnusedMemory();
		Paths.clearStoredMemory();

		Main.mouse_allowed = false;

		persistentUpdate = persistentDraw = true;

		var bg = new FlxSprite().loadGraphic(Paths.image('backgrounds/${FlxG.random.int(1, 2)}', 'preload'));
        bg.moves = false;
        bg.antialiasing = SaveData.antialiasing;
        bg.setGraphicSize(Std.int(FlxG.width), Std.int(FlxG.height));
		add(bg);

		grpControls = new FlxTypedGroup<FlxText>();
		add(grpControls);

		generateOptions();

		currentDescription = '';

		versionShit = new FlxText(5, FlxG.height + 40, 0, 'Offset' + ': ${SaveData.offset} ms | ' + currentDescription, 12);
		versionShit.scrollFactor.set();
		versionShit.setFormat(Paths.font('Persona4.ttf'), 16, FlxColor.WHITE, LEFT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		versionShit.antialiasing = SaveData.antialiasing;

		blackBorder = new FlxSprite(0, FlxG.height + 40).makeGraphic(FlxG.width, Std.int(versionShit.height + 600), FlxColor.BLACK);
		blackBorder.alpha = 0.5;

		add(blackBorder);
		add(versionShit);

		FlxTween.tween(versionShit, {y: FlxG.height - 22}, 2, {ease: FlxEase.elasticInOut});
		FlxTween.tween(blackBorder, {y: FlxG.height - 22}, 2, {ease: FlxEase.elasticInOut});

		changeSelection();

		#if MOBILE_CONTROLS
			addVirtualPad(FULL, A_B);
		#end

		super.create();
	}

	var isCat:Bool = false;

	override function update(elapsed:Float)
	{
		if (acceptInput)
		{
			if ((controls.BACK #if android || FlxG.android.justReleased.BACK #end) && !isCat)
			{
				acceptInput = false;
				GlobalSoundManager.play('cancelMenu');
				SaveData.save();
				MusicBeatState.switchState(new AjustesState());
			}
			else if (controls.BACK #if android || FlxG.android.justReleased.BACK #end)
			{
				isCat = false;
				generateOptions();
				changeSelection(curSelected);
			}

			if (controls.UP_P)
				changeSelection(-1);

			if (controls.DOWN_P)
				changeSelection(1);

			changeValue(FlxG.keys.pressed.SHIFT ? controls.LEFT : controls.LEFT_P, FlxG.keys.pressed.SHIFT ? controls.RIGHT : controls.RIGHT_P);

			if (controls.RESET)
			{
				SaveData.offset = 0;
				changeSelection();
			}

			if (controls.ACCEPT)
			{
				if (isCat)
				{
					if (currentSelectedCat.getOptions()[curSelected].press())
					{
						var data:Array<Dynamic> = isCat ? currentSelectedCat.getOptions() : options;
					
						// Calcular a altura total da lista
						var totalHeight:Float = data.length * 45; // 45 é a altura de cada item
					
						// Calcular a posição y inicial para centralizar a lista
						var startY:Float = (FlxG.height / 2) - (totalHeight / 2);
						grpControls.remove(grpControls.members[curSelected]);
						var ctrl:FlxText = new FlxText(0, startY + (45 * curSelected), 0, currentSelectedCat.getOptions()[curSelected].getDisplay());
						ctrl.setFormat(Paths.font('Persona4.ttf'), 36, FlxColor.WHITE, CENTER);
						ctrl.setBorderStyle(OUTLINE, 0xFF9600BB, 2);
						ctrl.antialiasing = SaveData.antialiasing;
						ctrl.x = FlxG.width / 2 - ctrl.width / 2; // Centralizar horizontalmente
						ctrl.ID = curSelected;
						grpControls.add(ctrl);
					}
				}
				else
				{
					currentSelectedCat = options[curSelected];
					isCat = true;
					generateOptions();
				}

				changeSelection();
			}
		}

		super.update(elapsed);
	}

	function generateOptions()
		{
			var data:Array<Dynamic> = isCat ? currentSelectedCat.getOptions() : options;
		
			grpControls.clear();
		
			// Calcular a altura total da lista
			var totalHeight:Float = data.length * 45; // 45 é a altura de cada item
		
			// Calcular a posição y inicial para centralizar a lista
			var startY:Float = (FlxG.height / 2) - (totalHeight / 2);
		
			for (i in 0...data.length)
			{
				var name:String = isCat ? currentSelectedCat.getOptions()[i].getDisplay() : options[i].getName();
		
				// Calcular a posição y de cada item com base na altura total e startY
				var controlLabel:FlxText = new FlxText(0, startY + (45 * i), 0, name);
				controlLabel.setFormat(Paths.font('Persona4.ttf'), 36, FlxColor.WHITE, CENTER);
				controlLabel.setBorderStyle(OUTLINE, 0xFF9600BB, 2);
				controlLabel.antialiasing = SaveData.antialiasing;
				controlLabel.x = FlxG.width / 2 - controlLabel.width / 2; // Centralizar horizontalmente
				controlLabel.ID = i;
				grpControls.add(controlLabel);
			}
			curSelected = 0;
		}
		

	function changeSelection(change:Int = 0)
	{
		GlobalSoundManager.play("scrollMenu");

		curSelected += change;

		if (curSelected < 0)
			curSelected = grpControls.length - 1;
		if (curSelected >= grpControls.length)
			curSelected = 0;

		if (isCat)
			currentDescription = currentSelectedCat.getOptions()[curSelected].getDescription();
		else
			currentDescription = '';

		if (isCat && currentSelectedCat.getOptions()[curSelected].getAccept())
			versionShit.text = currentSelectedCat.getOptions()[curSelected].getValue() + ' | ' + currentDescription;
		else
			versionShit.text = 'Offset' + ': ${SaveData.offset} ms | ' + currentDescription;

		grpControls.forEach(function(txt:FlxText)
		{
			if (txt.ID == curSelected)
				txt.setBorderStyle(OUTLINE, 0xFF9600BB, 2);
			else
				txt.setBorderStyle(OUTLINE, 0xFF750092, 2);
		});
	}

	function changeValue(left:Bool = false, right:Bool = false)
	{
		var changedValue = left || right;

		if (isCat && currentSelectedCat.getOptions()[curSelected].getAccept())
		{
			if (left)
				currentSelectedCat.getOptions()[curSelected].left();
			if (right)
				currentSelectedCat.getOptions()[curSelected].right();

			if (changedValue)
				versionShit.text = currentSelectedCat.getOptions()[curSelected].getValue() + ' | ' + currentDescription;
		}
		else
		{
			if (left)
				SaveData.offset --;
			if (right)
				SaveData.offset ++;

			SaveData.offset = Std.int(SaveData.offset);

			if (changedValue)
				versionShit.text = 'Offset' + ': ${SaveData.offset} ms | ' + currentDescription;
		}
	}

	public static function changeFilter(filter:Int) {
		var elfiltro:Array<openfl.filters.BitmapFilter>;
		switch(filter) {
			case 1:
				SaveData.shaderMatrix = [
				0.43, 0.72, -.15, 0, 0,
				0.34, 0.57, 0.09, 0, 0,
				-.02, 0.03,    1, 0, 0,
				   0,    0,    0, 1, 0, ];
				elfiltro = [new ColorMatrixFilter(SaveData.shaderMatrix)];
				FlxG.game.setFilters(elfiltro);
			case 2:
				SaveData.shaderMatrix = [
					0.97, 0.11, -.08, 0, 0,
					0.02, 0.82, 0.16, 0, 0,
					0.06, 0.88, 0.18, 0, 0,
					   0,    0,    0, 1, 0,
				];
				elfiltro = [new ColorMatrixFilter(SaveData.shaderMatrix)];
				FlxG.game.setFilters(elfiltro);
			case 3:
				SaveData.shaderMatrix = [
					0.20, 0.99, -.19, 0, 0,
					0.16, 0.79, 0.04, 0, 0,
					0.01, -.01,    1, 0, 0,
					   0,    0,    0, 1, 0,
				];
				elfiltro = [new ColorMatrixFilter(SaveData.shaderMatrix)];
				FlxG.game.setFilters(elfiltro);
			default:
				// Só pra apagar tudo da array e tirar o filtro da tela (isso tava bugado)
				SaveData.shaderMatrix = []; // k
				elfiltro = [];
				FlxG.game.setFilters([]);
		}
	}

	override function beatHit()
	{
		super.beatHit();
	}
}