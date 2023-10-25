class Course {
  String? courseName;
  String? courseCode;
  String? instructor;
  String? imageUrl;
  double? rating;

  Course({
    this.courseName,
    this.courseCode,
    this.instructor,
    this.imageUrl,
    this.rating,
  });

  @override
  static Course fromMap(Map<String, dynamic> query){
    Course course = Course();
    course.courseName = query['courseName'];
    course.courseCode = query['courseCode'];
    // course.instructor = query['instructor'];
    course.imageUrl = query['imageUrl'];
    // course.rating = query['rating'];

    return course;
  }

  @override
  static Map<String, dynamic> toMap(Course course) {
    return <String
    , dynamic> {
      'courseName' : course.courseName,
      'courseCode' : course.courseCode,
      // 'instructor' : course.instructor,
      'imageUrl' : course.imageUrl,
      // 'rating' : course.rating,
    };
  }


  @override
  static List<Course> fromList(List<Map<String, dynamic>> query){
    List<Course> courses = <Course> [];
    for (Map map in query){
      courses.add(fromMap(map.cast()));
    }
    return courses;
  }

}

