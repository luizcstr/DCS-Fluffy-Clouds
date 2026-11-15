# Weather MSFS Realista Completo para DCS World

Pacote experimental de clima e nuvens para **DCS World**, construído sobre a base do **DCS Fluffy Clouds** e dos presets do [ATMOS-X](https://www.atx4dcs.com/), com inspiração visual no Microsoft Flight Simulator.

O objetivo é reunir em **um único mod para OvGME** tudo o que funcionou nos testes até agora: presets retrabalhados, nuvens volumétricas mais cheias e variadas, cirrus com mais detalhe, mapa de cobertura suave, shaders de céu e os arquivos necessários da base Fluffy.

> **Importante:** este é um mod experimental e dependente da versão do DCS. Atualizações do simulador podem exigir uma nova compilação ou revisão dos shaders. Compatibilidade com o verificador de integridade de servidores multiplayer não é garantida.

[Baixar o pacote completo](https://github.com/luizcstr/DCS-Fluffy-Clouds/releases/latest) · [Ver todas as mudanças](CHANGELOG.md) · [Instruções rápidas](LEIA-ME.txt) · [Licença](LICENSE)

## Baixe pela página de Releases

Use o arquivo `Weather_MSFS_Realista_Completo-*.zip` da [Release mais recente](https://github.com/luizcstr/DCS-Fluffy-Clouds/releases/latest).

O ZIP gerado pelo botão **Code → Download ZIP** contém o código e os arquivos menores para consulta, mas **não é o pacote instalável completo**. O arquivo `Bazar/Effects/EffectTextures.zip` ultrapassa o limite de 100 MB por arquivo do GitHub; por isso, o mod completo é distribuído como anexo de Release. O cache compilado `Bazar/shaders/fxo/fxo.edcz` também fica somente no pacote completo.

## O que está incluído

- Base Fluffy Clouds: `enlight.dll` para `bin` e `bin-mt`, texturas e miniaturas de nuvem, shaders de Lua/estrela/relâmpago e integração com o painel de clima do Mission Editor.
- Presets ATMOS-X retrabalhados em `Config/Effects/clouds.lua`.
- Mapa de cobertura suave `cloudsMap01.png`.
- Shader de cirrus com camada de detalhe C2 em `Bazar/shaders/enlight/cirrus.fx`.
- Cache `fxo.edcz` patchado para uma base volumétrica mais cheia, variação no topo e gomos mais definidos.
- Pacote de texturas de efeitos com recursos de nuvens, cirrus, Lua, estrelas, chuva, neve e outros efeitos atmosféricos.

Quando havia conflito entre a base Fluffy e os ajustes desta versão, prevaleceu a versão do **Weather MSFS Realista Completo**.

## Principais mudanças em relação ao repositório anterior

- `clouds.lua` recebeu uma revisão ampla: **611 linhas adicionadas e 551 removidas** em relação ao último commit publicado.
- Foi adicionado o preset experimental `Preset89` / **Congestus Teste (vertical)**.
- Os presets existentes foram recalibrados em altura e espessura, cobertura, densidade, frequência/desfoque de ruído e uso do mapa de cobertura.
- As camadas passaram a misturar escalas de ruído e offsets do mapa para reduzir repetição visual e produzir bases mais cheias, topos mais variados e gomos mais definidos.
- Entraram os novos arquivos `cloudsMap01.png`, `cirrus.fx`, `Moon.fx`, `Star.fx`, `lightning.fx`, `fxo.edcz` e `EffectTextures.zip`.
- As DLLs `enlight.dll`, as miniaturas, `me_weather.lua` e `me_weather_panel.dlg` são os mesmos arquivos da versão anterior; foram mantidos para que a Release continue sendo um pacote único.

Detalhes adicionais e hashes dos arquivos grandes estão em [CHANGELOG.md](CHANGELOG.md).

## Instalação com OvGME

1. Feche o DCS World.
2. Baixe e extraia o ZIP da [Release mais recente](https://github.com/luizcstr/DCS-Fluffy-Clouds/releases/latest) na biblioteca de mods do seu perfil OvGME.
3. No OvGME, desative outros mods de nuvem, clima ou shader que possam sobrescrever os mesmos arquivos. Exemplos usados durante os testes: `DCS_Shader_BaseSuave_Test01`, `Fluffy clouds`, `Weather_MSFS_Realista_v1`, G1/G2, C1/C2 e as séries T/E/H/K/S/V.
4. Não é necessário desativar o mod **Offline Terrain**, pois ele não faz parte deste conjunto de arquivos.
5. Ative apenas `Weather_MSFS_Realista_Completo`.
6. Abra o DCS e deixe o primeiro carregamento terminar.

O perfil do OvGME deve apontar para a pasta de instalação do DCS World. A estrutura instalada começa diretamente em `Bazar/`, `bin/`, `bin-mt/`, `Config/` e `MissionEditor/`.

## Primeiro carregamento e cache de shaders

No primeiro boot após ativar o mod, o DCS recompila shaders. O carregamento pode demorar mais e as nuvens podem desaparecer e reaparecer enquanto o cache é reconstruído. Isso é esperado uma vez.

Nos boots seguintes, mantenha o mesmo conjunto de mods ativo para que o cache persista. Trocar repetidamente mods de nuvem e shader invalida o cache e pode trazer o pop-in de volta.

Se o problema continuar depois de **dois boots sem mudar os mods**:

1. Feche o DCS.
2. Apague as pastas `fxo` e `metashaders2` em `Saved Games\DCS.openbeta` (ou na pasta equivalente da sua instalação).
3. Abra o DCS e aguarde uma reconstrução limpa do cache.

## Desinstalação e reversão

Feche o DCS e desative `Weather_MSFS_Realista_Completo` no OvGME. O gerenciador restaura os arquivos originais que estavam presentes antes da ativação.

Se o DCS não iniciar após a instalação, desative o mod antes de qualquer outro teste. Não misture arquivos deste pacote manualmente com outras versões de shaders.

## Créditos e licença

Projeto baseado no trabalho do **DCS Fluffy Clouds** e nos presets do **ATMOS-X**. Consulte [LICENSE](LICENSE) para os termos do repositório. Microsoft Flight Simulator é citado apenas como referência visual; este projeto não é afiliado à Microsoft, à Eagle Dynamics ou ao ATMOS-X.
