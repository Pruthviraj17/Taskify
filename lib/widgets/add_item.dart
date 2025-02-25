import 'package:cool_dropdown/cool_dropdown.dart';
import 'package:cool_dropdown/models/cool_dropdown_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:todo_app/components/custom_textfield.dart';
import 'package:todo_app/components/text_widget.dart';
import 'package:todo_app/constants/colors.dart';
import 'package:todo_app/models/task_item.dart';
import 'package:todo_app/providers/taskify_provider.dart';
import 'package:todo_app/providers/pending_task_provider.dart';
import 'package:todo_app/utils/date_picker.dart';
import 'package:uuid/uuid.dart';

class AddTodoItem extends ConsumerStatefulWidget {
  const AddTodoItem({
    super.key,
    required this.ref,
    this.taskItem,
  });
  final WidgetRef ref;
  final TaskItem? taskItem;

  @override
  ConsumerState<AddTodoItem> createState() => _AddTodoItemState();
}

class _AddTodoItemState extends ConsumerState<AddTodoItem> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descController = TextEditingController();

  List<String> priorityValues = ['High', 'Medium', 'Low'];
  final priorityDropdownController = DropdownController<String>();
  List<CoolDropdownItem<String>> pokemonDropdownItems = [];

  @override
  void initState() {
    super.initState();
    createDropDownList();
    initialControllertext();
  }

  void initialControllertext() {
    if (widget.taskItem != null) {
      _titleController.text = widget.taskItem!.title;
      _descController.text = widget.taskItem!.description;
    }
  }

  @override
  void dispose() {
    super.dispose();
    _titleController.dispose();
    _descController.dispose();
  }

  void createDropDownList() {
    for (var i = 0; i < priorityValues.length; i++) {
      pokemonDropdownItems.add(
        CoolDropdownItem<String>(
            selectedIcon: SizedBox(),
            label: '${priorityValues[i]}',
            value: '${priorityValues[i]}'),
      );
    }
  }

  void _addItemToList() {
    if (_formKey.currentState!.validate()) {
      Navigator.of(context).pop();
      final newTodoItem = TaskItem(
        id: Uuid().v4(),
        title: _titleController.text,
        description: _descController.text,
        dueDate: ref.read(pickedDueDateProvider),
        priority: ref.read(selectedPriorityProvider),
        isDone: false,
      );
      widget.ref.read(pendingTaskProvider.notifier).addNewItem(newTodoItem);
      // ref is taken from previous class
    }
  }

  void _saveEdit() {
    print("_saveEdit");
    print(_titleController.text);
    if (_formKey.currentState!.validate()) {
      final taskItem = TaskItem(
        id: widget.taskItem!.id,
        title: _titleController.text,
        description: _descController.text,
        dueDate: ref.read(pickedDueDateProvider),
        priority: ref.read(selectedPriorityProvider),
        isDone: false,
      );

      widget.ref.read(pendingTaskProvider.notifier).updateItem(taskItem);
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Padding(
      padding: const EdgeInsets.only(
        left: 8.0,
        top: 8.0,
        right: 8.0,
        bottom: 20.0,
      ),
      child: Column(
        children: [
          Icon(
            Icons.drag_handle_rounded,
            size: 30,
            color: AppColors.purpleShade2,
          ),
          const SizedBox(
            height: 21,
          ),
          Form(
            key: _formKey,
            child: Column(
              spacing: 20,
              children: [
                CustomTextfield(
                  textEditingController: _titleController,
                  label: "Title",
                  validate: (title) {
                    if (title!.isEmpty) {
                      return "Please enter title";
                    }
                    return null;
                  },
                ),
                CustomTextfield(
                  textEditingController: _descController,
                  label: "Description",
                  validate: (desc) {
                    if (desc!.isEmpty) {
                      return "Please enter description";
                    }
                    return null;
                  },
                ),
                Row(
                  spacing: 20,
                  children: [
                    GestureDetector(
                      onTap: () async {
                        DateTime? pickedDate = await customDatePicker(context);
                        if (pickedDate != null) {
                          ref.read(pickedDueDateProvider.notifier).state =
                              pickedDate;
                        }
                      },
                      child: Container(
                        width: size.width / 2,
                        height: 50,
                        decoration: BoxDecoration(
                          color: AppColors.greyShade2,
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            width: 2,
                            color: const Color.fromARGB(22, 158, 158, 158),
                          ),
                        ),
                        child: Center(
                          child: TextWidget(
                            title: DateFormat('d MMMM')
                                .format(ref.watch(pickedDueDateProvider)),
                            fontSize: 12,
                            fontColor: AppColors.greyShade1,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    Row(
                      spacing: 20,
                      children: [
                        Container(
                          width: size.width / 4.5,
                          height: 50,
                          decoration: BoxDecoration(
                            color: AppColors.greyShade2,
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                              width: 2,
                              color: const Color.fromARGB(22, 158, 158, 158),
                            ),
                          ),
                          child: Center(
                            child: TextWidget(
                              title: ref.watch(selectedPriorityProvider),
                              fontSize: 12,
                              fontColor: AppColors.greyShade1,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        CoolDropdown<String>(
                          controller: priorityDropdownController,
                          dropdownList: pokemonDropdownItems,
                          defaultItem: pokemonDropdownItems.last,
                          onChange: (value) {
                            ref.read(selectedPriorityProvider.notifier).state =
                                value;
                            priorityDropdownController.close();
                          },
                          resultOptions: ResultOptions(
                            width: 45,
                            render: ResultRender.icon,
                            icon: SizedBox(
                              width: 10,
                              height: 10,
                              child: CustomPaint(
                                painter: DropdownArrowPainter(
                                  color: AppColors.purpleShade2,
                                ),
                              ),
                            ),
                          ),
                          dropdownOptions: DropdownOptions(
                            width: 140,
                          ),
                          dropdownItemOptions: DropdownItemOptions(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            selectedBoxDecoration: BoxDecoration(
                              color: Color(0XFFEFFAF0),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                )
              ],
            ),
          ),
          const Spacer(),
          SizedBox(
            width: MediaQuery.of(context).size.width / 2.5,
            height: 40,
            child: ElevatedButton(
              onPressed: () =>
                  widget.taskItem != null ? _saveEdit() : _addItemToList(),
              style: ElevatedButton.styleFrom(
                  elevation: 2,
                  shadowColor: AppColors.purpleShade2,
                  backgroundColor: AppColors.purpleShade1),
              child: TextWidget(
                  title: widget.taskItem != null ? "Save" : "ADD",
                  fontColor: AppColors.white,
                  fontWeight: FontWeight.w700,
                  fontSize: 16),
            ),
          ),
          SizedBox(
            height: 10,
          ),
        ],
      ),
    );
  }
}
