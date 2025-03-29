import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lista_de_tarefas/main.dart';

void main() {
  group('MainApp Tests', () {
    testWidgets('App starts and renders main components', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(const MainApp());

      expect(find.byType(MaterialApp), findsOneWidget);
      expect(find.byType(Scaffold), findsOneWidget);
      expect(find.text('Lista de Tarefas'), findsOneWidget);
    });
  });

  group('PerfilUsuario Tests', () {
    testWidgets('Displays correct profile information', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(const MaterialApp(home: ListaDeTarefas()));

      expect(find.byType(PerfilUsuario), findsOneWidget);
      expect(find.text('João Silva'), findsOneWidget);
      expect(find.text('Dev FullStack'), findsOneWidget);
      expect(find.text('Compositor nas horas vagas'), findsOneWidget);
      expect(find.byType(CircleAvatar), findsOneWidget);
    });
  });

  group('BotaoAdicionar Tests', () {
    testWidgets('Calls onPressed when tapped', (WidgetTester tester) async {
      bool pressed = false;
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(body: BotaoAdicionar(onPressed: () => pressed = true)),
        ),
      );

      await tester.tap(find.byType(FloatingActionButton));
      expect(pressed, true);
    });
  });

  group('ListaDeTarefas Tests', () {
    testWidgets('Initial tasks are displayed', (WidgetTester tester) async {
      await tester.pumpWidget(const MaterialApp(home: ListaDeTarefas()));

      expect(find.text('Primeira tarefa'), findsOneWidget);
      expect(find.text('Executar plano de dominação mundial'), findsOneWidget);
    });

    testWidgets('Adding a new task', (WidgetTester tester) async {
      await tester.pumpWidget(const MaterialApp(home: ListaDeTarefas()));

      await tester.enterText(find.byType(TextField), 'Nova tarefa');
      await tester.tap(find.byType(FloatingActionButton));
      await tester.pump();

      expect(find.text('Nova tarefa'), findsOneWidget);
      expect(find.byType(Tarefa), findsNWidgets(3));
    });

    testWidgets('Adding empty task', (WidgetTester tester) async {
      await tester.pumpWidget(const MaterialApp(home: ListaDeTarefas()));

      await tester.enterText(find.byType(TextField), '');
      await tester.tap(find.byType(FloatingActionButton));
      await tester.pump();

      expect(find.byType(Tarefa), findsNWidgets(2));
      expect(find.text(''), findsOne);
    });

    testWidgets('Removing a task', (WidgetTester tester) async {
      await tester.pumpWidget(const MaterialApp(home: ListaDeTarefas()));

      final deleteButtons = find.widgetWithIcon(IconButton, Icons.delete);
      await tester.tap(deleteButtons.first);
      await tester.pump();

      expect(find.byType(Tarefa), findsNWidgets(1));
    });

    testWidgets('TextField clears after adding task', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(const MaterialApp(home: ListaDeTarefas()));

      await tester.enterText(find.byType(TextField), 'Test clear');
      await tester.tap(find.byType(FloatingActionButton));
      await tester.pump();

      expect(find.byType(TextField), findsOneWidget);
      final textField = tester.widget<TextField>(find.byType(TextField));
      expect(textField.controller?.text, isEmpty);
    });
  });

  group('Tarefa Tests', () {
    testWidgets('Toggling task completion', (WidgetTester tester) async {
      final tarefa = TarefaModel(id: 'test', texto: 'Test task');
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(body: Tarefa(tarefa: tarefa, onRemover: () {})),
        ),
      );

      expect(tarefa.feita, false);
      expect(find.byIcon(Icons.check_box_outline_blank), findsOneWidget);

      await tester.tap(find.byIcon(Icons.check_box_outline_blank));
      await tester.pump();

      expect(tarefa.feita, true);
      expect(find.byIcon(Icons.check_box), findsOneWidget);
    });

    testWidgets('Task text shows strike-through when completed', (
      WidgetTester tester,
    ) async {
      final tarefa = TarefaModel(id: 'test', texto: 'Test task', feita: true);
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(body: Tarefa(tarefa: tarefa, onRemover: () {})),
        ),
      );

      final textWidget = tester.widget<Text>(find.text('Test task'));
      expect(textWidget.style?.decoration, TextDecoration.lineThrough);
    });

    testWidgets('Delete button triggers callback', (WidgetTester tester) async {
      bool deleted = false;
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Tarefa(
              tarefa: TarefaModel(id: 'test', texto: 'Test task'),
              onRemover: () => deleted = true,
            ),
          ),
        ),
      );

      await tester.tap(find.widgetWithIcon(IconButton, Icons.delete));
      expect(deleted, true);
    });
  });
  group('Edge Cases', () {
    testWidgets('Removing all tasks', (WidgetTester tester) async {
      await tester.pumpWidget(const MaterialApp(home: ListaDeTarefas()));

      final deleteButtons = find.widgetWithIcon(IconButton, Icons.delete);
      while (deleteButtons.evaluate().isNotEmpty) {
        await tester.tap(deleteButtons.first);
        await tester.pump();
      }

      expect(find.byType(Tarefa), findsNothing);
    });

    testWidgets('Adding multiple tasks quickly', (WidgetTester tester) async {
      await tester.pumpWidget(const MaterialApp(home: ListaDeTarefas()));

      const String taskText = 'Quick Task';
      for (int i = 0; i < 5; i++) {
        await tester.enterText(find.byType(TextField), '$taskText $i');
        await tester.tap(find.byType(FloatingActionButton));
        await tester.pump();
      }

      expect(find.byType(Tarefa), findsNWidgets(7));
      for (int i = 0; i < 5; i++) {
        expect(find.text('$taskText $i'), findsOneWidget);
      }
    });

    testWidgets('Unique keys for tasks', (WidgetTester tester) async {
      await tester.pumpWidget(const MaterialApp(home: ListaDeTarefas()));

      final taskKeys =
          tester
              .widgetList<Tarefa>(find.byType(Tarefa))
              .map((t) => t.key)
              .toList();

      expect(taskKeys.toSet().length, taskKeys.length);
    });
  });
}
