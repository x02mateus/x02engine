# <img src="art/icon64.png" align="center"> X02Engine</img>
## ESSA ENGINE AINDA ESTÁ EM DESENVOLVIMENTO! Isso significa que vários dos codes deste repositório serão reescritos, trocados ou até mesmo apagados. (O code foi aberto só para caso alguém quiser acompanhar e também pra atualizar o meu arquivo de README)
## Antes de tudo, gostaria de avisar que alguns dos codes aqui estão FEIOS e foram feitos como "placeholders" e são provisórios.

Essa engine almeja trazer a experiência do Friday Night Funkin' original ao mesmo tempo que é customizável e user-friendly. Originalmente feita em 2021, baseada na [Psych Engine](https://github.com/ShadowMario/FNF-PsychEngine), esta engine foi basicamente "reescrita do zero", porém, continua sendo feita em Haxe/HaxeFlixel.

Esta engine foi feita pensando principalmente em pessoas com um celular/PC fraco, então, a otimização foi uma preocupação a mais aqui.
Além de suportar mods e suportar charts de FNF, juntamente de modcharts em Lua, a X02Engine também suporta charts de Osu! e Clone Hero. (em progresso)

## Tutorial de Build simplificado:
Siga esses seguintes passos FUNDAMENTAIS para a compilação:
* Instale o [Git](https://git-scm.com/downloads)
* Instale o [Haxe](https://haxe.org/download/version/4.2.5/) - Se atente ao número da versão! Este projeto não é compatível com outras versões do Haxe e a versão 4.2.5 é a menos bugada para compilar este projeto no presente momento.
* Instale o [Haxeflixel](https://haxeflixel.com/documentation/getting-started/)
* Instale o [Visual Studio Community](https://visualstudio.microsoft.com/pt-br/vs/community/) e na hora de instalar as coisas, importe a seguinte [configuração](https://drive.google.com/file/d/1RVxsn2pAIanVKevcAh_VmFnGqy1Q5Xo9/view?usp=sharing) e espere baixar e instalar (tudo isso é feito automáticamente).
* Logo após instalar as ferramentas de compilação do VSC2022 (ou a versão que estiver no momento que você for compilar isso), clone o repositório do Projeto ModBoa usando seu Terminal de preferência via Git.
`git clone https://https://github.com/x02mateus/x02engine`
* Abra novamente o Terminal, só que dessa vez, dentro do diretório raiz do código fonte, e execute o comando:
`haxelib install hmm`
* Em seguida, o comando:
`haxelib run hmm install`

Parte específica para a compilação de Android via PC:
* Faça TODOS os passos que foram indicados acima.
* Baixe e instale o [Android Studio](https://developer.android.com/studio)
* Baixe e extraia as ferramentas de compilação [JDK](https://drive.google.com/file/d/1dIIISXyuNaXTZzIdvCAkIm7_Ee4Y9I-7/view?usp=sharing) e [NDK](https://drive.google.com/file/d/1Eifen5o1Mky0Mr2jl3eO-BiDYeuuRA1n/view?usp=sharing) para onde você preferir.
* Após a instalação completa do Android Studio, já no menu principal do aplicativo, clique em "More Actions" e depois em "SDK Manager"
* Dentro do gerenciador de SDKs, entre no submenu de "SDK Platforms" e selecione as seguintes opções:
![andr](https://i.imgur.com/d9YBzFJ.png)
* Entre no submenu de "SDK Tools" e selecione as seguintes opções:
![andr2](https://i.imgur.com/L100sOm.png)
* Rode o comando `lime setup android` e coloque o caminho de onde suas coisas estão extraídas/instaladas.
![andr3](https://i.imgur.com/AR8NCnV.png)

Caso você não tenha um computador e quiser compilar esta engine para Android, basta usar as workflows do GitHub:
* Faça um fork do repositório da X02Engine.
* Após isso, entre na aba Actions, abaixo do nome do repositório
* Ative o uso de Workflows, vá em `Android X86 Build (build para 32 bits)` ou `Android X64 Build (build para 64 bits)`, depois clique em Run Workflows e aperte no botão verde.

## Creditos:
# Coding
* MateusX02 - Coding/Direção/Designer
* Matheus Silver - Ajuda com codes
* Idklool - Ajuda com codes

# Ideias
* Evil - Ideias e suporte externo no projeto.

# Agradecimentos especiais
* MaybeMaru - Programou a library [Moonchart](https://github.com/MaybeMaru/moonchart) que permite o carregamento e conversão de diversas charts

## TODO/PLANEJAMENTOS:
# Bom, a ideia pra essa "engine" é, trazer as coisas do FNF e ao mesmo tempo modificá-las de forma que me agradem.
# A principal ideia é fazer ser um jogo confortável, leve e sem lag ao mesmo tempo.
# Andei pensando em coisas como:
* Suporte a charts de CH, Osu!, FNF (junto de conversores de charts de outros jogos)
* Suporte a backgrounds com vídeo, tanto customizados, como backgrounds padrões das charts
* Suporte a charts/skins customizadas sem ter que recompilar o jogo
* Suporte a customização dos menus de forma softcoded (utilizando JSONs para determinar visibilidade, posição de sprites, etc)
* Suporte nativo a gamepad (Mobile/Desktop)
* Suporte nativo a teclado (Mobile/Desktop)
* Suporte nativo a controles Mobile (Mobile)
* Charts em BIN para melhor otimização
* Code compacto e limpo
* Poder jogar a música que quiser
* Ter uma gameplay confortável e agradável para o usuário, com bastantes opções de customização
