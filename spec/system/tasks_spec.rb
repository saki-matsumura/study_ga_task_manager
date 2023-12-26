require 'rails_helper'

RSpec.describe "タスク管理機能", type: :system do
  describe '新規作成機能' do
    before do
      # テスト用アカウント作成
      @user = FactoryBot.create(
        :user,
          name: 'Arice',
          email: 'user1@xmail.com',
          password: 'password1',
          icon: ''
      )
      visit new_session_path
      login(@user)
    end
    context 'タスクを新規作成した場合' do
      it '作成したタスクが表示される' do
        visit new_task_path
        fill_in 'task[title]', with: 'task_title'
        fill_in 'task[note]', with: 'task_note'
        fill_in 'task[clients][name]', with: 'client'
        fill_in 'task[type_of_tasks][name]', with: 'type_of_task'
        fill_in 'task[working_process][workload]', with: '1000'
        fill_in 'task[working_process][working_hour]', with: '1'
        click_on '保存'

        task = Task.last

        expect(page).to have_content 'task_title'
        expect(page).to have_content 'task_note'
        expect(page).to have_content 'client'
        expect(page).to have_content 'type_of_task'
        expect(current_path).to eq(task_path(task.id))
      end
    end
    context '一覧画面に遷移した場合' do
      it '作成済みのタスク一覧が表示される' do
        FactoryBot.create(
        :task,
          title: 'task_title',
          note: 'note',
          user_id: @user.id
        )
        visit tasks_path
        expect(page).to have_content 'task_title'
      end
    end
  end
end
