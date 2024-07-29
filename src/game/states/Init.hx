/* 
	Bom, a ideia pra essa "engine" é, trazer as coisas do FNF e ao mesmo tempo modificá-las de forma que me agradem.
	A principal ideia é fazer ser um jogo confortável, leve e sem lag ao mesmo tempo.
	Andei pensando em coisas como:
		- Suporte a charts de CH, Osu!, FNF (junto de conversores de charts de outros jogos)
		- Suporte a backgrounds com vídeo, tanto customizados, como backgrounds padrões das charts
		- Suporte a charts/skins customizadas sem ter que recompilar o jogo
		- Suporte a customização dos menus de forma softcoded (utilizando JSONs para determinar visibilidade, posição de sprites e etc)
		- Suporte nativo a gamepad (Mobile/Desktop)
		- Suporte nativo a teclado (Mobile/Desktop)
		- Suporte nativo a controles Mobile (Mobile)
		- Charts em BIN para melhor otimização
		- Code compacto e limpo
		- Poder jogar a música que quiser (sugestão feita pela Maria Clara)
		- Ter uma gameplay confortável e agradável para o usuário, com bastantes opções de customização
		- IMPORTANTE: ADICIONAR O OPENFL DO MODBOA

	ESSE ARQUIVO É TEMPORÁRIO, E É USADO APENAS PARA AS CONFIGURAÇÕES INICIAIS DA ENGINE (SaveData, Input, etc.)
 */

package game.states;

import flixel.effects.FlxFlicker;

class Init extends MusicBeatState
{
	var texto:FlxText;
	var coiso:String = #if desktop 'Aperte ENTER ' #elseif mobile 'TOQUE NA TELA ' #end;

	override function create()
	{
		#if android
		FlxG.android.preventDefaultKeys = [BACK];
		#end
		
		SaveData.init();

		if (SaveData.firstTime)
		{
			FlxG.sound.playMusic(Paths.music(Std.string(FlxG.random.int(1, 5))), SaveData.volumeMusica, true);

			texto = new FlxText(0, 0,
				"Bem vindo!\nEssa engine contem luzes piscantes, e caso\nvoce seja sensivel a esse tipo de coisa,\ndesative a opcao 'Luzes Piscantes'\nque se localiza no menu de opcoes.\n\nObrigado!\n" +
				coiso + "para continuar.");
			texto.scrollFactor.set();
			texto.setFormat(Paths.font('akira.otf'), 16, FlxColor.WHITE, CENTER, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
			texto.screenCenter(XY);
			add(texto);
		}
		else
		{
			MusicBeatState.switchState(new game.states.MainMenuState());
		}

		super.create();
	}

	override function update(elapsed:Float)
	{
		var justPressed:Bool = #if desktop FlxG.keys.justPressed.ENTER #elseif mobile BSLTouchUtils.justTouched() #end;
		if (justPressed)
		{
			GlobalSoundManager.play(confirmMenu);
			SaveData.firstTime = false;
			SaveData.save();
			FlxFlicker.flicker(texto, 1, 0.1, false, true, function(flk:FlxFlicker)
			{
				new FlxTimer().start(0.5, function(tmr:FlxTimer)
				{
					#if desktop
					MusicBeatState.switchState(new game.states.PresetsState());
					#elseif mobile 
						// no mobile, quando troca de state acontece um bug esquisito lá
						// lembrar de verificar isso no pc tbm
						// Depois de verificar, eu descobri que o problema é lá no musicbeat, já que ele chama a função dentro dela mesma
						// Essa condição do if desktop vai continuar por conta que o presets ainda não tem touch/controles mobile
					MusicBeatState.switchState(new game.states.MainMenuState());
					#end
				});
			});
		}
	}
}
