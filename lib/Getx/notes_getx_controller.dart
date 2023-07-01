import 'package:database/database/note_db_controller.dart';
import 'package:get/get.dart';
import '../models/note.dart';
import '../process_response.dart';

class NoteGetXController extends GetxController {
  RxList<Note> notes = <Note>[].obs;
  final NoteDbController _dbController = NoteDbController();
  static NoteGetXController get to => Get.find<NoteGetXController>();
  RxBool loading = true.obs;



  @override
  void onInit() {
    read();
    super.onInit();

  }


  Future<ProcessResponse> create(Note note) async {
    int newRowId = await _dbController.create(note);
    if (newRowId != 0) {
      note.id = newRowId;
      notes.add(note);
      //update();
    }
    return getResponse(success: newRowId != 0);
  }

  ProcessResponse getResponse({required bool success}) {
    return ProcessResponse(
        message:
        success ? 'Operation completed successfully' : 'Operation failed',
        success: success);
  }

  void read() async {
    loading.value = true;
    notes.value = await _dbController.read();
    loading.value = false;

    // update();
  }

  Future<ProcessResponse> updateNote(Note note) async {
    bool updated = await _dbController.update(note);
    if (updated) {
      int index = notes.indexWhere((element) => element.id == note.id);
      if (index != -1) {
        notes[index] = note;
        //update();
      }
    }
    return getResponse(success: updated);
  }

  Future<ProcessResponse> delete(int index) async {
    bool deleted = await _dbController.delete(notes[index].id);
    if (deleted) {
      notes.removeAt(index);
      //update();
    }
    return getResponse(success: deleted);
  }
}