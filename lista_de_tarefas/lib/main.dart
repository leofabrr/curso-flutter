import 'package:flutter/material.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: Text('Lista de Tarefas')),
        body: const ListaDeTarefas(),
      ),
    );
  }
}

class PerfilUsuario extends StatelessWidget {
  const PerfilUsuario({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.sizeOf(context).width,
      height: 148,
      decoration: BoxDecoration(
        color: Colors.black26,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          CircleAvatar(
            radius: 50,
            foregroundImage: NetworkImage(
              'https://get.pxhere.com/photo/man-person-hair-white-profile-male-portrait-model-young-hairstyle-smile-beard-face-glasses-head-moustache-eyewear-photo-shoot-facial-hair-vision-care-451653.jpg',
            ),
            onForegroundImageError: (exception, stackTrace) => exception,
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'João Silva',
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              Text(
                'Dev FullStack',
                style: Theme.of(context).textTheme.bodyLarge,
              ),
              Text(
                'Compositor nas horas vagas',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class BotaoAdicionar extends StatelessWidget {
  const BotaoAdicionar({super.key, required this.onPressed});
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton.extended(
      onPressed: onPressed,
      label: Text(
        'Adicionar Tarefa',
        style: Theme.of(context).textTheme.bodyLarge,
      ),
    );
  }
}

class ListaDeTarefas extends StatefulWidget {
  const ListaDeTarefas({super.key});

  @override
  State<ListaDeTarefas> createState() => _ListaDeTarefasState();
}

class _ListaDeTarefasState extends State<ListaDeTarefas> {
  final List<TarefaModel> _tarefas = [
    TarefaModel(id: '1', texto: 'Primeira tarefa'),
    TarefaModel(id: '2', texto: 'Executar plano de dominação mundial'),
  ];
  TextEditingController controller = TextEditingController();

  void _adicionarTarefa() {
    setState(() {
      if (controller.text.isNotEmpty) {
        _tarefas.add(
          TarefaModel(
            id: DateTime.now().millisecondsSinceEpoch.toString(),
            texto: controller.text,
          ),
        );
        controller.clear();
      }
    });
  }

  void _removerTarefa(String id) {
    setState(() {
      _tarefas.removeWhere((tarefa) => tarefa.id == id);
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      minimum: const EdgeInsets.all(8),
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            const PerfilUsuario(),
            const SizedBox(height: 8),
            Material(
              child: TextField(
                controller: controller,
                decoration: const InputDecoration(
                  label: Text('Digite uma nova tarefa'),
                ),
              ),
            ),
            const SizedBox(height: 8),
            BotaoAdicionar(onPressed: _adicionarTarefa),
            const SizedBox(height: 16),
            ..._tarefas
                .map(
                  (tarefa) => Tarefa(
                    key: Key(tarefa.id),
                    tarefa: tarefa,
                    onRemover: () => _removerTarefa(tarefa.id),
                  ),
                )
                .toList(),
          ],
        ),
      ),
    );
  }
}

class TarefaModel {
  final String id;
  final String texto;
  bool feita;

  TarefaModel({required this.id, required this.texto, this.feita = false});
}

class Tarefa extends StatefulWidget {
  final TarefaModel tarefa;
  final VoidCallback onRemover;

  const Tarefa({super.key, required this.tarefa, required this.onRemover});

  @override
  State<Tarefa> createState() => _TarefaState();
}

class _TarefaState extends State<Tarefa> {
  void _toogleConclusao() {
    setState(() {
      widget.tarefa.feita = !widget.tarefa.feita;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 12),
        Container(
          width: MediaQuery.sizeOf(context).width,
          decoration: BoxDecoration(
            border: Border.all(width: 0.2, color: Colors.black),
            color: Colors.black12,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  widget.tarefa.texto,
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    decoration:
                        widget.tarefa.feita ? TextDecoration.lineThrough : null,
                  ),
                ),
              ),
              Row(
                children: [
                  IconButton(
                    icon: Icon(
                      widget.tarefa.feita
                          ? Icons.check_box
                          : Icons.check_box_outline_blank,
                    ),
                    onPressed: _toogleConclusao,
                  ),
                  IconButton(
                    onPressed: widget.onRemover,
                    icon: const Icon(Icons.delete, color: Colors.red),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}
