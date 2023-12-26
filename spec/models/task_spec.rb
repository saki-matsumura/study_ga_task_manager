require 'rails_helper'

RSpec.describe Task, type: :model do
  before do
    # テスト用アカウント作成
    @user = FactoryBot.create(
      :user,
        name: 'Arice',
        email: 'user1@xmail.com',
        password: 'password1',
        icon: ''
    )
  end
  describe 'バリデーションのテスト' do
    context 'タスクのタイトルが空の場合' do
      it 'バリデーションにひっかる' do
        task = Task.new(title: '', note: '失敗テスト', user_id: @user.id)
        expect(task).not_to be_valid
      end
    end
    context 'タスクのタイトルを入力すると' do
      it 'バリデーションが通る' do
        task = Task.new(title: 'task_title', note: '成功テスト', user_id: @user.id)
        expect(task).to be_valid
      end
    end
  end
end
