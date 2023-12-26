require 'rails_helper'

RSpec.describe "ユーザー管理機能", type: :system do
  describe 'ユーザー作成機能' do
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
    context 'ユーザーを新規作成した場合' do
      it 'カレンダー画面に遷移する' do
        visit new_user_path
        fill_in 'user[name]', with: 'new_user_name'
        fill_in 'user[email]', with: 'new_user@xmail.com'
        fill_in 'user[password]', with: 'new_password'
        fill_in 'user[password_confirmation]', with: 'new_password'
        click_on 'アカウント登録'
        expect(current_path).to eq(calendar_tasks_path)
      end
    end
    context 'ユーザーがログインせずにカレンダー画面に遷移した場合' do
      it 'ログイン画面に遷移する' do
        visit calendar_tasks_path
        expect(current_path).to eq(new_session_path)
      end
    end
    context 'ログイン画面からemailとパスワードを入力した場合' do
      it 'ログインしてカレンダー画面に遷移する' do
        visit new_session_path
        fill_in 'session[email]', with: 'user1@xmail.com'
        fill_in 'session[password]', with: 'password1'
        click_on 'ログイン'
        expect(current_path).to eq(calendar_tasks_path)
      end
    end
    context 'ログイン状態でアイコンをクリックした場合' do
      it 'マイページに遷移する' do
        visit new_session_path
        login(@user)
        find('.user_icon').click
        expect(current_path).to eq(user_path(@user.id))
      end
    end
  end
end
