# TasksSwiftUI — iOS + watchOS Companion

## Descrição

TasksSwiftUI é um app de tarefas com app iOS e app watchOS companheiro. Você cria e gerencia tarefas no iPhone e as vê no Apple Watch, com sincronização via WatchConnectivity. No relógio, é possível abrir os detalhes e alternar o estado de conclusão.

Principais pontos:

- Persistência de tarefas no iOS usando SwiftData (`Task` + `TaskCategory`).
- Sincronização iPhone ⇄ Watch usando `WCSession.updateApplicationContext`.
- UI no Watch com lista de tarefas, detalhe e toggle de concluído.

## Pré‑requisitos

- Xcode 16+ (SDK iOS 18 / watchOS 11 ou compatível)
- macOS com conta Apple configurada no Xcode (Signing)
- Para dispositivo real: iPhone pareado com Apple Watch, ambos no mesmo Apple ID

## Estrutura do projeto

- `TasksSwiftUI/` (app iOS)
	- `App/` (App entry, TabBar, conectividade iOS)
	- `Models/` (`Task`, `TaskCategory`)
	- `Screens/` (`Tasks`, `AddTask`, `Profile`)
- `TasksApp Watch App/` (app watchOS)
	- `App/` (`TasksAppApp`, `TasksAppManager`, `WatchConnection`)
	- `Models/` (`WatchTask`, `TaskCategory`)
	- `Components/` (`TaskRow`)
	- `Screens/` (`TasksAppView`, `TaskDetailsView`)
- `TasksApp Watch App Complication/` (complication target)
- `TasksSwiftUI.xcodeproj/` (projeto Xcode)

## Abrindo o projeto

1. Abra `TasksSwiftUI.xcodeproj` no Xcode.
2. Aguarde o index terminar e verifique os Schemes:
	 - `TasksSwiftUI` (iOS)
	 - `TasksApp Watch App` (watchOS)

## Configuração de Assinatura (Signing & Capabilities)

Faça isso para cada target (iOS e watchOS):

1. Selecione o target (ex.: `TasksSwiftUI`).
2. Aba “Signing & Capabilities”.
3. Marque “Automatically manage signing”.
4. Em “Team”, selecione sua equipe Apple.
5. Repita para `TasksApp Watch App` e (se necessário) para a Complication.

Observações:

- O projeto já inclui os entitlements padrão. Você só precisa garantir o Team correto.
- Use o mesmo Team para todos os targets.

## Executando no simulador (iOS + Watch pareados)

Você pode usar um par de simuladores (iPhone + Apple Watch):

1. No Xcode, menu “Window” → “Devices and Simulators”.
2. Crie/abra um simulador de iPhone.
3. Adicione um Apple Watch pareado a esse simulador (botão “+” → Add Watch…).
4. Selecione o Scheme `TasksSwiftUI` e escolha o simulador de iPhone pareado como destino.
5. Rode o app iOS (⌘R). Isso instala também o app do Watch pareado automaticamente. Caso não instale, selecione o Scheme `TasksApp Watch App` e escolha o simulador de Apple Watch pareado, então rode.

Primeira sincronização:

- Abra o app no iPhone primeiro (para ativar `WCSession` e enviar dados). Depois abra o app do Watch.

## Executando em dispositivos reais (Companion)

1. Conecte o iPhone ao Mac via cabo (ou Wi‑Fi com pairing confiável) e confie no computador se solicitado.
2. Garanta que o iPhone está pareado com um Apple Watch (mesmo Apple ID).
3. No Xcode, selecione o Scheme `TasksSwiftUI` e o seu iPhone como destino.
4. Rode (⌘R). O Xcode instalará o app no iPhone e, se o Watch estiver pareado e disponível, instalará o app watchOS companheiro.
5. Se necessário, troque para o Scheme `TasksApp Watch App`, selecione o Apple Watch como destino e rode para forçar a instalação do app do relógio.

Primeira sincronização:

- Abra o app no iPhone pelo menos uma vez para ativar a sessão e enviar o contexto inicial.
- Em seguida, abra o app no Watch para receber e exibir as tarefas.

## Como a sincronização funciona

- iOS → Watch:
	- `iOSConnectivity.sendUpdatedTasks(tasks:)` codifica as tarefas (`Task` → `WatchTask`) e envia com `updateApplicationContext`.
	- No Watch, `WatchConnection.session(_:didReceiveApplicationContext:)` decodifica e atualiza `TasksAppManager`.

- Watch → iOS:
	- No detalhe da tarefa, ao alternar o status, o Watch chama `WatchConnection.sendUpdatedTasks(tasks:)` enviando o contexto atualizado.
	- Dica: para consumir esse retorno no iOS, implemente `WCSessionDelegate.session(_:didReceiveApplicationContext:)` e atualize o modelo se desejar persistir as mudanças vindas do relógio.

Regras importantes do `WCSession`:

- A sessão só ativa quando ambos estão prontos (apps abertos/ativos, dispositivos desbloqueados, pareados e no mesmo Apple ID).
- `updateApplicationContext` mantém apenas o último estado enviado (sem fila). Use para estado atual.

## Uso básico

- iPhone
	- Aba “Tasks”: visualize e gerencie suas tarefas.
	- “Add Task”: crie novas tarefas com nome, categoria e descrição. Edição/remoção disponíveis.

- Apple Watch
	- Lista de tarefas com ícone da categoria e status.
	- Detalhe da tarefa permite alternar “Completed/Pending”. A lista reflete o novo estado e o contexto é enviado ao iPhone.

## Solução de problemas (FAQ)

1) “Application context data is nil” no Watch

- Abra o app no iPhone antes do Watch (para ativar e enviar o contexto).
- Verifique se a sessão está ativada em ambos (implemente `activationDidComplete` e confira o estado `.activated`).
- Confirme que iPhone e Watch estão pareados, desbloqueados e no mesmo Apple ID.
- Garanta que `updateApplicationContext` é chamado no iOS após criar/editar tarefas.
- No Watch, trate o contexto em `didReceiveApplicationContext` e atualize o `TasksAppManager` no main thread se necessário.

2) O app do Watch não instala

- Use o mesmo Team para todos os targets e marque “Automatically manage signing”.
- Execute primeiro o scheme iOS no dispositivo pareado; se necessário, rode o scheme do Watch explicitamente no destino do Apple Watch.

3) Mudanças no Watch não aparecem no iPhone

- O Watch envia o contexto. Para refletir no iPhone, implemente o recebimento com `session(_:didReceiveApplicationContext:)` no iOS e atualize o modelo/persistência.

## Notas técnicas

- Modelos:
	- iOS: `Task` (SwiftData) e `TaskCategory` (enum `Codable`).
	- watchOS: `WatchTask` (Codable) e `TaskCategory` (análoga, separada no target do Watch).
- Estado (watchOS): `TasksAppManager` com `@Observable` armazena a lista e a seleção.
- Conectividade: `iOSConnectivity` (iOS) e `WatchConnection` (watchOS) usando `WCSession`.

## Licença

Projeto para fins educacionais/demonstração.

