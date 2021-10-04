# frozen_string_literal: true

require 'rails_helper'

describe '/courses', type: :request do
  describe 'GET /courses' do
    let!(:course) { create(:course) }
    let!(:chapter1) { create(:chapter, order: 1, course: course) }
    let!(:chapter2) { create(:chapter, order: 2, course: course) }
    let!(:section1_1) { create(:section, order: 1, chapter: chapter1) }
    let!(:section1_2) { create(:section, order: 2, chapter: chapter1) }
    let!(:section2_1) { create(:section, order: 1, chapter: chapter2) }
    let!(:section2_2) { create(:section, order: 2, chapter: chapter2) }
    subject(:do_get) do
      get '/courses'
      response
    end
    subject(:json) { JSON.parse(do_get.body) }

    it 'should show attributes in json' do
      expect(do_get.status).to eq(200)
      expect(json['courses'].size).to be(1)
      expect(json['courses'][0]['chapters'].size).to be(2)
      expect(json['courses'][0]['chapters'][0]['sections'].size).to be(2)
      expect(json['courses'][0]).to include(
        'id' => course.id,
        'name' => course.name,
        'teacher_name' => course.teacher_name,
        'description' => course.description,
        'chapters' => a_kind_of(Array)
      )
      expect(json['courses'][0]['chapters'][0]).to include(
        'id' => chapter1.id,
        'name' => chapter1.name,
        'order' => 1,
        'sections' => a_kind_of(Array)
      )
      expect(json['courses'][0]['chapters'][0]['sections'][0]).to include(
        'id' => section1_1.id,
        'name' => section1_1.name,
        'description' => section1_1.description,
        'order' => 1,
        'detail' => section1_1.detail
      )
    end
  end

  describe 'GET /courses/:id' do
    let!(:course) { create(:course) }
    let!(:chapter1) { create(:chapter, order: 1, course: course) }
    let!(:chapter2) { create(:chapter, order: 2, course: course) }
    let!(:section1_1) { create(:section, order: 1, chapter: chapter1) }
    let!(:section1_2) { create(:section, order: 2, chapter: chapter1) }
    let!(:section2_1) { create(:section, order: 1, chapter: chapter2) }
    let!(:section2_2) { create(:section, order: 2, chapter: chapter2) }
    subject(:do_get) do
      get "/courses/#{course.id}"
      response
    end
    subject(:json) { JSON.parse(do_get.body) }

    it 'should get course attributes in json' do
      expect(do_get.status).to eq(200)
      expect(json['chapters'].size).to be(2)
      expect(json['chapters'][0]['sections'].size).to be(2)
      expect(json).to include(
        'id' => course.id,
        'name' => course.name,
        'teacher_name' => course.teacher_name,
        'description' => course.description,
        'chapters' => a_kind_of(Array)
      )
      expect(json['chapters'][0]).to include(
        'id' => chapter1.id,
        'name' => chapter1.name,
        'order' => 1,
        'sections' => a_kind_of(Array)
      )
      expect(json['chapters'][0]['sections'][0]).to include(
        'id' => section1_1.id,
        'name' => section1_1.name,
        'description' => section1_1.description,
        'order' => 1,
        'detail' => section1_1.detail
      )
    end
  end

  describe 'POST /courses' do
    subject(:do_post) do
      post '/courses', params: params
      response
    end
    subject(:json) { JSON.parse(do_post.body) }
    let(:params) do
      {
        course: {
          name: 'course_name',
          teacher_name: 'teacher_name',
          description: 'course_description',
          chapters: [
            {
              name: chapter_name,
              sections: [
                {
                  name: section_name,
                  description: 'section_description',
                  detail: 'section_detail'
                }
              ]
            }
          ]
        }
      }
    end
    let(:chapter_name) { 'chapter_name' }
    let(:section_name) { 'section_name' }

    context 'when success' do
      it 'should change model counts' do
        expect { do_post }.to change { Course.all.size }.from(0).to(1).and \
          change { Chapter.all.size }.from(0).to(1).and \
            change { Section.all.size }.from(0).to(1)
        expect(json['chapters'].size).to be(1)
        expect(json['chapters'][0]['sections'].size).to be(1)
      end
    end

    context 'when chapter not valid' do
      let(:chapter_name) { '' }

      it do
        response = do_post
        expect(response.status).to eq(400)
        expect(JSON.parse(response.body)['message']).to eq('Chapters name can\'t be blank ')
      end
    end

    context 'when section not valid' do
      let(:section_name) { '' }

      it do
        response = do_post
        expect(response.status).to eq(400)
        expect(JSON.parse(response.body)['message']).to eq('Chapters sections name can\'t be blank ')
      end
    end

    context 'when no chapters and sections provided' do
      # TODO
    end
  end

  describe 'PATCH /courses/:id' do
    let!(:course) { create(:course) }
    subject(:do_patch) do
      patch "/courses/#{course.id}", params: params
      response
    end
    subject(:json) { JSON.parse(do_patch.body) }
    let(:params) do
      {
        course: {
          name: 'course_name',
          teacher_name: 'teacher_name',
          description: 'course_description',
          chapters: [
            {
              name: chapter_name,
              sections: [
                {
                  name: section_name,
                  description: 'section_description',
                  detail: 'section_detail'
                }
              ]
            }
          ]
        }
      }
    end
    let(:chapter_name) { 'chapter_name' }
    let(:section_name) { 'section_name' }
    context 'when success' do
      it 'should change model counts' do
        expect { do_patch }.to change { Chapter.all.size }.from(0).to(1).and \
          change { Section.all.size }.from(0).to(1)
        expect(json['chapters'].size).to be(1)
        expect(json['chapters'][0]['sections'].size).to be(1)
      end
    end

    context 'when chapter not valid' do
      let(:chapter_name) { '' }

      it do
        response = do_patch
        expect(response.status).to eq(400)
        expect(JSON.parse(response.body)['message']).to eq('Chapters name can\'t be blank ')
      end
    end

    context 'when section not valid' do
      let(:section_name) { '' }

      it do
        response = do_patch
        expect(response.status).to eq(400)
        expect(JSON.parse(response.body)['message']).to eq('Chapters sections name can\'t be blank ')
      end
    end
  end

  describe 'DELETE courses/:id' do
    let!(:course) { create(:course, :with_chapters) }
    subject(:do_delete) do
      delete "/courses/#{course.id}"
      response
    end
    subject(:json) { JSON.parse(do_delete.body) }

    it do
      expect { do_delete }.to change { Course.all.size }.from(1).to(0).and \
        change { Chapter.all.size }.from(2).to(0).and \
          change { Section.all.size }.from(4).to(0)
      expect(json['id']).to eq(course.id)
    end
  end
end
