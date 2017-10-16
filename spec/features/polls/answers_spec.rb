require 'rails_helper'

feature 'Answers' do

  background do
    admin = create(:administrator)
    login_as(admin.user)
  end

  scenario "Index" do
    question = create(:poll_question)
    answer1 = create(:poll_question_answer, question: question)
    answer2 = create(:poll_question_answer, question: question)

    visit admin_question_path(question)

    expect(page).to have_css(".poll_question_answer", count: 2)

    within("#poll_question_answer_#{answer1.id}") do
      expect(page).to have_content answer1.title
      expect(page).to have_content answer1.description
    end
  end

  scenario "Create" do
    question = create(:poll_question)

    visit admin_question_path(question)

    click_link "Add answer"
    fill_in "poll_question_answer_title", with: "¿Would you like to reform Central Park?"
    fill_in "poll_question_answer_description", with: "Adding more trees, creating a play area..."
    click_button "Save"

    expect(page).to have_content "Answer created successfully"

    expect(page).to have_css(".poll_question_answer", count: 1)
    expect(page).to have_content "¿Would you like to reform Central Park?"
    expect(page).to have_content "Adding more trees, creating a play area..."
  end


  scenario 'Add video to answer' do
    question = create(:poll_question)
    answer1 = create(:poll_question_answer, question: question)
    answer2 = create(:poll_question_answer, question: question)

    visit admin_question_path(question)

    within("#poll_question_answer_#{answer1.id}") do
      click_link "Video list"
    end

    click_link "Add video"

    fill_in "poll_question_answer_video_title", with: "Awesome project video"
    fill_in "poll_question_answer_video_url", with: "https://www.youtube.com/watch?v=123"

    click_button "Save"

    within("#poll_question_answer_video_#{answer1.id}") do
      expect(page).to have_content "Awesome project video"
      expect(page).to have_content "https://www.youtube.com/watch?v=123"
    end
  end

  pending "Update"
  pending "Destroy"

  context "Gallery" do

    it_behaves_like "nested imageable",
                    "poll_question_answer",
                    "new_admin_answer_image_path",
                    { "answer_id": "id" },
                    nil,
                    "Save image",
                    "Image uploaded successfully",
                    true
  end

end