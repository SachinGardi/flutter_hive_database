import 'package:flutter/material.dart';
import 'package:flutter_hive_database_tutorial/boxes/boxes.dart';
import 'package:flutter_hive_database_tutorial/models/notes_model.dart';
import 'package:hive_flutter/adapters.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  final titleTextController = TextEditingController();
  final descriptionTextController = TextEditingController();

  @override
  void dispose() {
    titleTextController.dispose();
    descriptionTextController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Hive Database'),
        centerTitle: true,
      ),

      body: ValueListenableBuilder<Box<NotesModel>>(
          valueListenable: Boxes.getData().listenable(),
          builder: (context, box, _) {
            var data = box.values.toList().cast<NotesModel>();
            return  ListView.builder(
                itemCount:box.length ,
                itemBuilder: (context, index) {
                  return Card(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 15,vertical: 15),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [

                          Row(
                            children: [
                              Text(data[index].title,style: const TextStyle(
                                fontSize: 20,fontWeight:  FontWeight.w500
                              ),),
                              const Spacer(),
                                 InkWell(
                                  onTap: () async {
                                    await update(data[index]);
                                  },
                                    child: const Icon(Icons.edit,color: Colors.blue,)),
                              const SizedBox(width: 15,),
                              InkWell(
                                onTap: () async {
                                  await delete(data[index]);
                                },
                                  child: const Icon(Icons.delete,color: Colors.red,))

                            ],
                          ),

                          Text(data[index].description,style: const TextStyle(
                              fontSize: 18,fontWeight:  FontWeight.w500
                          ),),
                        ],
                      ),
                    ),
                  );
                },
            );
          },),
      
      floatingActionButton: FloatingActionButton(onPressed: () async {
        _showMyDialog();
      },child: const Icon(Icons.add)),
    );
  }

  Future<void> _showMyDialog()async{

    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text('Add Notes'),
            content: SingleChildScrollView(
              child: ListView(
                shrinkWrap: true,
                children: [
                  TextFormField(
                    controller: titleTextController,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: 'Enter title'
                    ),
                  ),
                  const SizedBox(height: 20,),
                  TextFormField(
                    controller: descriptionTextController,
                    decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        hintText: 'Enter description'
                    ),
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(onPressed: (){
                    Navigator.pop(context);
              }, child: const Text('CANCEL')),
              TextButton(onPressed: (){
                final data = NotesModel(title: titleTextController.text, description: descriptionTextController.text);
                final box = Boxes.getData();
                box.add(data);
                data.save();
                titleTextController.clear();
                descriptionTextController.clear();
                Navigator.pop(context);
              }, child: const Text('ADD')),
            ],
          );
        },
    );
  }
  Future<void> _editDialog(NotesModel notesModel)async{
    titleTextController.text = notesModel.title;
    descriptionTextController.text = notesModel.description;
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text('Update Notes'),
            content: SingleChildScrollView(
              child: ListView(
                shrinkWrap: true,
                children: [
                  TextFormField(
                    controller: titleTextController,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: 'Enter title'
                    ),
                  ),
                  const SizedBox(height: 20,),
                  TextFormField(
                    controller: descriptionTextController,
                    decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        hintText: 'Enter description'
                    ),
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(onPressed: (){
                    Navigator.pop(context);
              }, child: const Text('CANCEL')),
              TextButton(onPressed: (){
                notesModel.title = titleTextController.text;
                notesModel.description = descriptionTextController.text;
                notesModel.save();
                titleTextController.clear();
                descriptionTextController.clear();
                Navigator.pop(context);
              }, child: const Text('EDIT')),
            ],
          );
        },
    );
  }

  Future<void> delete(NotesModel notesModel)async{
    await notesModel.delete();
  }

  Future<void> update(NotesModel notesModel)async{
    _editDialog(notesModel);
  }
}
