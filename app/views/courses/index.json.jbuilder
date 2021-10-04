json.courses @courses.each do |course|
  json.partial! 'courses/course', course: course
end