json.(course, :id, :name, :teacher_name, :description)
json.chapters course.chapters.in_order do |chapter|
  json.(chapter, :id, :name, :order)
  json.sections chapter.sections.in_order do |section|
    json.(section, :id, :name, :description, :detail, :order)
  end
end