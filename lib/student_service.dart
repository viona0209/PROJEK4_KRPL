import 'models/student_model.dart';

class StudentService {
  static List<Student> students = [];

  static void addStudent(Student student) {
    students.add(student);
  }

  static void updateStudent(int index, Student student) {
    students[index] = student;
  }

  static void deleteStudent(int index) {
    students.removeAt(index);
  }
}
