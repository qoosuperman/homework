# frozen_string_literal: true

class CoursesController < ApplicationController
  before_action :find_course, only: %i[show update destroy]
  skip_before_action :verify_authenticity_token, only: %i[create update destroy]

  def index
    @courses = Course.includes(chapters: :sections)
  end

  def show
    @courses = Course.includes(chapters: :sections)
  end

  def create
    course = Course.new
    @form = CourseForm.new(course)
    @form.attributes = course_params
    @form.save || render_error_with(@form.errors.full_messages.join(','))
  end

  def update
    @course = Course.find(params[:id])
    @form = CourseForm.new(@course)
    @form.attributes = course_params
    @form.save || render_error_with(@form.errors.full_messages.join(','))
  end

  def destroy
    @course = Course.find(params[:id])
    @course.destroy || render_error_with(@form.errors.full_messages.join(','))
  end

  private

  def find_course
    @course = Course.includes(chapters: :sections).find(params[:id])
  end

  def course_params
    params.require(:course).permit(:name, :teacher_name, :description,
                                   chapters: [:id, :name, :_destroy,
                                              { sections: %i[id name description detail _destroy] }])
  end

  def render_error_with(message)
    render json: { message: message }, status: 400
  end
end
