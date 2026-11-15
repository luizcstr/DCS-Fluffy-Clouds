# Changelog

## Weather MSFS Realista Completo v1.0

Atualização principal do antigo repositório **DCS Fluffy Clouds** para um pacote unificado de clima, nuvens e shaders, pronto para ativação única pelo OvGME.

### Arquivos alterados

- `Config/Effects/clouds.lua`
  - 611 linhas adicionadas e 551 removidas em comparação com o último commit publicado.
  - Novo `Preset89`, exibido no Mission Editor como `99 ## Congestus Teste (vertical)`.
  - Recalibração extensa de `detailNoiseMapSize`, limites de altitude, espessura das camadas, densidade, cobertura, frequência e desfoque de ruído.
  - Uso ampliado de `coverageMapFactor` e offsets UV do mapa de cobertura.
  - Linhagem dos testes consolidada no cabeçalho: T4a → T5b → T7a → E2 → K3 → G2.

### Arquivos novos

- `Bazar/Effects/Clouds/cloudsMap01.png` — mapa de cobertura suave usado pelos presets.
- `Bazar/shaders/enlight/cirrus.fx` — cirrus C2 com detalhe de alta frequência, variação de padrão, LOD mais próximo e extinção reforçada.
- `Bazar/shaders/Moon.fx` — shader da Lua incluído pela base unificada; multiplicador de tamanho configurado em `2.5`.
- `Bazar/shaders/Star.fx` — shader de estrelas incluído pela base unificada; brilho configurado em `4.0`.
- `Bazar/shaders/ParticleSystem2/lightning.fx` — shader de relâmpago incluído pela base unificada; opacidade máxima configurada em `0.12`.
- `Bazar/shaders/fxo/fxo.edcz` — cache compilado patchado para densidade volumétrica, base cheia, variação do topo e gomos mais definidos.
- `Bazar/Effects/EffectTextures.zip` — 40 texturas de efeitos, incluindo nuvens, cirrus, Lua, estrelas, chuva e neve.
- `LEIA-ME.txt` — instruções rápidas originais do pacote completo.

### Arquivos verificados e mantidos sem alteração de conteúdo

- `bin/enlight.dll`
- `bin-mt/enlight.dll`
- `MissionEditor/modules/me_weather.lua`
- `MissionEditor/modules/dialogs/me_weather_panel.dlg`
- Todas as miniaturas já presentes em `Bazar/Effects/Clouds/Thumbnails/`

### Distribuição dos arquivos grandes

O pacote instalável completo é publicado como anexo de Release. Os dois arquivos abaixo não ficam no branch principal:

| Arquivo | Tamanho | SHA-256 |
| --- | ---: | --- |
| `Bazar/Effects/EffectTextures.zip` | 203.342.908 bytes | `E771C7253FFDC83180BF5E1B0B8E36E739710021C25D24F98F83C1CA7657EE2D` |
| `Bazar/shaders/fxo/fxo.edcz` | 82.008.783 bytes | `AC272BBE4E807861EBF6A681F4C9327891FE93747ABCA8B1B82C341341478073` |

Essa separação evita o limite de 100 MB por arquivo do GitHub e deixa o histórico Git leve, sem retirar nenhum componente do download instalável.
